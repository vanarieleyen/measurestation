unit dbhi;

{$mode objfpc}{$H+}

interface

uses
  dblo, Classes, SysUtils, LazLoggerDummy, math, LConvEncoding;

(******************************************************************************
High level DBase file handling

On open, the DBase file is completely read into memory and closed
Field content is seen as string data, each field is stored in a string that contains all
field-data in one long string (this makes locating fast)

Usage:

database := TDBFdatabase.Create;
database.Open(FileName);

GetField(fieldname; recno)	: returns content of field
GetFieldNr(fieldnr; recno) : returns content of field
SetField(fieldname; recno; value) : updates the value in a field (disk + memory)
Locate(fieldname; needle) : returns true/false and fills filter-array with the found records
Delete(recno) : deletes a record (sets the deleteflag)
Append() : append an empty record (disk + memory)

note:
	on open() the data is read from hd to memory and the dbf file is closed
	GetField[Nr] and Locate use the data from memory
   SetField updates the data in memory, opens the dbf file for update and closes it afterwards
   Delete(nr) only sets the delete flag, opens the dbf file for update and closes it afterwards
   Append() appends an empty record on disk and memory
******************************************************************************)

type
   TRecord = record
		name: string;
      length: integer;
   end;

   TDBFdatabase = class
		private
         procedure SetFieldNr(nr: integer; recno: integer; value: string);
      public
         numfields: integer;
         numrecs: integer;
         HeadLen:	integer;
         RecLen: integer;
         DateOfUpdate: string;
        	fieldval: array of string;  	// field contents in one long string
			fielddev: array of TRecord;
         filter: array of integer;		// result of a locate call (the search result)
         DBASE : dbfRecord;
         procedure Open(text: string);
         procedure Close();
         function GetField(name: string; recno: integer): string;
         function GetFieldNr(nr: integer; recno: integer): string;
         function Locate(field: string; needle: string): boolean;
         procedure SetField(name: string; recno: integer; value: string);
         procedure Delete(recno: integer);
         procedure Append();
         procedure Empty();
   end;

implementation

// open the database and read the data into memory
procedure TDBFdatabase.Open(text: string);
var
  i, r: integer;
  s: string;
  deleted: boolean;
begin
   DBASE.FileName := text;
   OpenDbf(DBASE);
   IF NOT dbfOK THEN
      ErrorHalt(dbfError);

   numfields := DBASE.NumFields;
   numrecs := DBASE.NumRecs;
   RecLen := DBASE.RecLen;
   HeadLen := DBASE.HeadLen;
   DateOfUpdate := DBASE.DateOfUpdate;

   setlength(fieldval, numfields);
   setlength(fielddev, numfields);

   FOR i := 0 TO numfields-1 DO BEGIN			// store fieldnames and lengths
     fielddev[i].name := DBASE.Fields^[i+1].Name;
     fielddev[i].length := DBASE.Fields^[i+1].Len;
   end;

   r := 1;
   WHILE r <= numrecs DO BEGIN       // store all records in memory
   	GetDbfRecord(DBASE, r);
      deleted := false; //(DBASE.CurRecord^[DBASE.Fields^[1].Off-1] = Byte('*')); 	// dont use the deleted flag yet
      if not deleted then begin
	    	FOR i := 0 TO numfields-1 DO BEGIN
				SetString(s, @DBASE.CurRecord^[DBASE.Fields^[i+1].Off] , DBASE.Fields^[i+1].Len);
   	      fieldval[i] := fieldval[i] + s;
	      end;
      end;
      r := r+1;
   END;
   CloseDbf(DBASE);
end;

// get fieldvalue based on field name and record number
function TDBFdatabase.GetField(name: string; recno: integer): string;
var
  i: integer;
begin
   for i := 0 to numfields-1 do begin
 	 	if fielddev[i].name = name then
   	  	break;
   end;
   Result := GetFieldNr(i, recno);
end;

// get fieldvalue based on field number and record number
function TDBFdatabase.GetFieldNr(nr: integer; recno: integer): string;
var
	s, str: string;
begin
   s := copy( fieldval[nr], (recno-1)*fielddev[nr].length+1, fielddev[nr].length);
   str := CP936ToUTF8(s);
   Result := str;
end;

// set fieldvalue based on field name and record number
procedure TDBFdatabase.SetField(name: string; recno: integer; value: string);
var
  i: integer;
begin
   for i := 0 to numfields-1 do begin
 	 	if fielddev[i].name = name then
   	  	break;
   end;
   //DebugLn(inttostr(i));
   SetFieldNr(i, recno, value);
end;

// set fieldvalue based on field number and record number
procedure TDBFdatabase.SetFieldNr(nr: integer; recno: integer; value: string);
var
	str: string;
   s: string;
   i: integer;
begin
   // convert utf8 string to dbase format (gb18030)
   str := UTF8ToCP936(value);

	// fill remaining with spaces
   for i:=fielddev[nr].length-Length(str) downto 1 do
     str := str + ' ';

	// move the string to the memory database
   Move( str[1], fieldval[nr][(recno-1)*fielddev[nr].length+1], fielddev[nr].length );

   // update the physical database
   OpenDbf(DBASE);
   GetDbfRecord(DBASE, recno);
   Move( str[1], DBASE.CurRecord^[DBASE.Fields^[nr+1].Off], fielddev[nr].length );
   PutDbfRecord(DBASE, recno);
   CloseDbf(DBASE);
end;

procedure TDBFdatabase.Close();
begin
	setlength(fieldval, 0);
	setlength(fielddev, 0);
   setlength(filter, 0);
	CloseDbf(DBASE);
end;

// remove all records from the database, leaves the structure untouched
procedure TDBFdatabase.Empty();
begin
	OpenDbf(DBASE);
   CreateDbf(DBASE, DBASE.FileName, DBASE.NumFields, DBASE.Fields);
   CloseDbf(DBASE);
end;

// locate record, returns index or 0 when not found
function TDBFdatabase.Locate(field: string; needle: string): boolean;
var
   i, found: integer;
	str, rec: string;
begin
   for i := 0 to numfields-1 do						// get field number
 	 	if fielddev[i].name = field then	break;

   str := UTF8ToCP936(needle);

   SetLength(filter, 0);

   found := 0;
	while found <= numrecs do begin
      rec := copy(fieldval[i], found*fielddev[i].length+1, fielddev[i].length);
		if Pos(str, rec) > 0 then begin
      	SetLength(filter, Length(filter)+1);
			filter[Length(filter)-1] := found+1;
      end;
      found := found + 1;
   end;
	Result := (Length(filter) > 0);
end;

// delete a record
procedure TDBFdatabase.Delete(recno: integer);
VAR
  Result : Integer;
  delflag: Byte;
begin
   delflag := Byte('*');
   OpenDbf(DBASE);
   seek(DBASE.dFile, DBASE.HeadLen+(recno-1)*DBASE.RecLen);
   BlockWrite(DBASE.dFile, delflag, 1, Result);
   CloseDbf(DBASE);
end;

// append an empty record
procedure TDBFdatabase.Append();
var
  i, j: integer;
begin
   FOR i := 0 TO numfields-1 DO BEGIN   			// add empty record in memory
      FOR j := 0 TO DBASE.Fields^[i+1].Len DO
	      fieldval[i] := fieldval[i] + ' ';
   end;
   NumRecs := NumRecs + 1;

   // add an empty record on disk
   OpenDbf(DBASE);
   FillChar(DBASE.CurRecord^, DBASE.RecLen, ' ');
   AppendDbf(DBASE);
   CloseDbf(DBASE);
end;


end.

