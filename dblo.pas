unit dblo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dos, LazLoggerDummy;

(******************************************************************************
 dBASE DBF file access via Turbo Pascal

-------------------------------------------------------------------------------
 Updated to Turbo Pascal 4.0/5.0 by Winthrop Chan, January 1989
                                    producer@cscwam.umd.edu

 comments : I originally downloaded this program from Turbo City (209-599-7435)
            but found it was severely outdated and was written for Turbo
            Pascal 3.0. Since I lack the dBase technical reference manual, I
            was not able to expand on the functions that are currently
            available. I made the code more readable (which it wasn't when I
            got hold of it) and updated some of the functions to take advantage
            of Turbo 4.0/5.0's new features. If I get some time someday, I
            would like to add index file access for both the dBase and Foxbase
            index format. As usual, please backup your data before using this
            unit since I may have not found all the bugs.
-------------------------------------------------------------------------------

DBF.PAS version 1.3

Copyright (C) 1986 By James Troutman
CompuServe PPN 74746,1567
Permission is granted to use these routines for non-commercial purposes.
For commercial use, please request permission via EasyPlex.

Revision history
 1.1  - 5/6/86 - update header when modifying the .DBF file; write the
 End Of File marker; simplify use.

 1.2  - 5/27/86 - removed (some of) the absurdities from the code;
 allocate the current record buffer on the heap rather than in the data
 segment; symbol names changed to avoid conflicts; some error checking
 added.

 1.3  - 6/5/86 - added support for dBASE II files; new procedure CreateDbf.

                  !!!!ATTENTION!!!!
If you have downloaded an earlier version of this file, please note that
several of the TYPEs and VARs have been changed.  You may have to make
some adjustments to any existing programs you have that use these routines.

The routines in this file present some tools for accessing dBASE II, III, and
III Plus files from within a Turbo Pascal program.  There is MUCH
room for improvement: the error checking is simplistic, there is no support
for memo files, no buffering of data, no support for index files,
etc. The main routines are:

       PROCEDURE OpenDbf(VAR D : dbfRecord;) : Integer;
       PROCEDURE CloseDbf(VAR D : dbfRecord) : Integer;
       PROCEDURE GetDbfRecord(VAR D : dbfRecord; RecNum : Real);
       PROCEDURE PutDbfRecord(VAR D : dbfRecord; RecNum : Real);
       PROCEDURE AppendDbf(VAR D : dbfRecord);
       PROCEDURE CreateDbf(VAR D : dbfRecord; fn : _Str64; n : Integer;
                           flds : _dFields);

After calling one of the procedures, check the status of the Boolean variable
dbfOK to determine the success or failure of the operation.  If it failed,
dbfError will contain a value corresponding to the IOResult value or
to a specially assigned value for several special conditions.  Notice in
particular that an unsuccessful call to CloseDbf will leave the file status
unchanged and the memory still allocated.  It is your program's
responsibility to take appropriate action.

A skeletal program might go something like:
  {$I Dbf.PAS}
  VAR
    D : dbfRecord; { declare your dBASE file variable }
  BEGIN
  D.FileName := 'MyFile.DBF'; { get filename of .dbf file into FileName field
                                of D variable ...  }
  OpenDbf(D);        { to open the file }
  IF NOT dbfOK THEN { check dbfError and process error };
  {... the rest of your program including calls to
   GetDbfRecord, PutDbfRecord, AppendDbf as needed,
   always remembering to interrogate the two global status
   variables after each procedure call   }
  CloseDbf(D);      { to close the file  }
  IF NOT dbfOK THEN { check dbfError and process error };
  END.

Upon exit from the GetDbfRecord Procedure, the CurRecord of the
dbfRecord variable points to the current record contents.  Each field
can be accessed using its offset into the CurRecord^ with the variable
Off in the Fields^ array.
Upon entry to the PutDbfRecord Procedure, the CurRecord^ should contain
the data that you want to write.
AppendDbf automatically adds a record to the end of the file (the
CurRecord^ should contain the data that you want to write).

Notice that the OpenDbf routine does allocate a buffer on the heap for
the current record.  You can, of course, override this by pointing
CurRecord to any data structure that you wish; HOWEVER, since CloseDbf
deallocates the buffer, you must repoint CurRecord to its original buffer
before calling CloseDbf.

See the demo program for some examples.
If you have any problems with these routines, please
let me know.  Suggestions for improvements gratefully accepted.



dBASE III Database File Structure
The structure of a dBASE III database file is composed of a
header and data records.  The layout is given below.
dBASE III DATABASE FILE HEADER:
ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³  BYTE   ³     CONTENTS      ³          MEANING                ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŽ
³  0      ³  1 byte           ³ dBASE III version number        ³
³         ³                   ³  (03H without a .DBT file)      ³
³         ³                   ³  (83H with a .DBT file)         ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŽ
³  1-3    ³  3 bytes          ³ date of last update             ³
³         ³                   ³  (YY MM DD) in binary format    ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŽ
³  4-7    ³  32 bit number    ³ number of records in data file  ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŽ
³  8-9    ³  16 bit number    ³ length of header structure      ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŽ
³  10-11  ³  16 bit number    ³ length of the record            ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŽ
³  12-31  ³  20 bytes         ³ reserved bytes (version 1.00)   ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŽ
³  32-n   ³  32 bytes each    ³ field descriptor array          ³
³         ³                   ³  (see below)                    ÃÄÄÄ¿
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŽ   ³
³  n+1    ³  1 byte           ³ 0DH as the field terminator     ³   ³
ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   ³
                                                                    ³
                                                                    ³
A FIELD DESCRIPTOR:      <ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³  BYTE   ³     CONTENTS      ³          MEANING                ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŽ
³  0-10   ³  11 bytes         ³ field name in ASCII zero-filled ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŽ
³  11     ³  1 byte           ³ field type in ASCII             ³
³         ³                   ³  (C N L D or M)                 ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŽ
³  12-15  ³  32 bit number    ³ field data address              ³
³         ³                   ³  (address is set in memory)     ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŽ
³  16     ³  1 byte           ³ field length in binary          ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŽ
³  17     ³  1 byte           ³ field decimal count in binary   ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŽ
³  18-31  ³  14 bytes         ³ reserved bytes (version 1.00)   ³
ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

The data records are layed out as follows:
1. Data records are preceeded by one byte that is a
   space (20H) if the record is not deleted and an
   asterisk (2AH) if it is deleted.
2. Data fields are packed into records with no field
   separators or record terminators.
3. Data types are stored in ASCII format as follows:

DATA TYPE      DATA RECORD STORAGE
---------      --------------------------------------------
Character      (ASCII characters)
Numeric        - . 0 1 2 3 4 5 6 7 8 9
Logical        ? Y y N n T t F f  (? when not initialized)
Memo           (10 digits representing a .DBT block number)
Date           (8 digits in YYYYMMDD format, such as
19840704 for July 4, 1984)

This information came directly from the Ashton-Tate Forum.
It can also be found in the Advanced Programmer's Guide available
from Ashton-Tate.

One slight difference occurs between files created by dBASE III and those
created by dBASE III Plus.  In the earlier files, there is an ASCII NUL
character between the $0D end of header indicator and the start of the data.
This NUL is no longer present in Plus, making a Plus header one byte smaller
than an identically structured III file.

******************************************************************************)

const
  DB2File = 2;
  DB3File = 3;
  DB3WithMemo = $83;
  ValidTypes: set of char = ['C', 'N', 'L', 'M', 'D', 'F'];
  MAX_HEADER = 4129;          { = maximum length of dBASE III header }
  MAX_BYTES_IN_RECORD = 4000; { dBASE III record limit }
  MAX_FIELDS_IN_RECORD = 128; { dBASE III field limit  }
  BYTES_IN_MEMO_RECORD = 512; { dBASE III memo field record size }

  { Special Error codes for .DBF files }
  NOT_DB_FILE = $80; { first byte was not a $3 or $83 or a $2 (dBASE II)}
  INVALID_FIELD = $81; { invalid field type was found }
  REC_TOO_HIGH = $82; { tried to read a record beyond the correct range }
  PARTIAL_READ = $83; { only a partial record was read }

  (*
  Although there are some declarations for memo files, the routines to access
  them have not yet been implemented.
  *)

type
  _HeaderType = array[0..MAX_HEADER] of byte;
  _HeaderPrologType = array[0..31] of byte;
  _FieldDescType = array[0..31] of byte;
  _dRec = ^_DataRecord;
  _DataRecord = array[0..MAX_BYTES_IN_RECORD] of byte;
  _Str255 = string[255];
  _Str80 = string[80];
  _Str64 = string[64];
  _Str10 = string[10];
  _Str8 = string[8];
  _Str2 = string[2];
  _dbfFile = file;

  _FieldRecord = record
    Name: _Str10;
    Typ: char;
    Len: byte;
    Dec: byte;
    Off: integer;
  end;
  _FieldArray = array[1..MAX_FIELDS_IN_RECORD] of _FieldRecord;
  _dFields = ^_FieldArray;
  _MemoRecord = array[1..BYTES_IN_MEMO_RECORD] of byte;
  _MemoFile = file of _MemoRecord;
  _StatusType = (NotOpen, NotUpdated, Updated);

  dbfRecord = record
    FileName: _Str64;
    dFile: _dbfFile;
    HeadProlog: _HeaderPrologType;
    dStatus: _StatusType;
    WithMemo: boolean;
    DateOfUpdate: _Str8;
    NumRecs: longint;
    HeadLen: word;
    RecLen: word;
    NumFields: integer;
    Fields: _dFields;
    CurRecord: _dRec;
  end;

var
  dbfError: integer;
  dbfOK: boolean;

procedure GetDbfRecord(var D: dbfRecord; RecNum: longint);
procedure PutDbfRecord(var D: dbfRecord; RecNum: longint);
procedure AppendDbf(var D: dbfRecord);
procedure CloseDbf(var D: dbfRecord);
procedure OpenDbf(var D: dbfRecord);
procedure CreateDbf(var D: dbfRecord; fn: _Str64; n: integer; flds: _dFields);
procedure ErrorHalt(errorCode: integer);

implementation

procedure ErrorHalt(errorCode: integer);
var
  errorMsg: _Str80;
begin
  case errorCode of
    00: Exit;                { no error occurred }
    $01: errorMsg := 'Not found';
    $02: errorMsg := 'Not open for input';
    $03: errorMsg := 'Not open for output';
    $04: errorMsg := 'Just not open';
    $91: errorMsg := 'Seek beyond EOF';
    $99: errorMsg := 'Unexpected EOF';
    $F0: errorMsg := 'Disk write error';
    $F1: errorMsg := 'Directory full';
    $F3: errorMsg := 'Too many files';
    $FF: errorMsg := 'Where did that file go?';
    NOT_DB_FILE: errorMsg := 'Not a dBASE data file';
    INVALID_FIELD: errorMsg := 'Invalid field type encountered';
    REC_TOO_HIGH: errorMsg := 'Requested record beyond range';
    PARTIAL_READ: errorMsg := 'Tried to read beyon EOF';
  else
		errorMsg := 'Undefined error';
  end;
  WriteLn;
  DebugLn(errorMsg);
  Halt(1);
end;

function MakeLongInt(var b): longint;
var
  r: longint ABSOLUTE b;
begin
  MakeLongInt := r;
end;

function MakeWord(var b): word;
var
  r: word ABSOLUTE b;
begin
  MakeWord := r;
end;

function MakeInt(var b): integer;
var
  i: integer ABSOLUTE b;
begin
  MakeInt := i;
end;

function MakeStr(b: byte): _Str2;
var
  i: integer;
  s: _Str2;
begin
  i := b;
  Str(i: 2, s);
  if s[1] = ' ' then
    s[1] := '0';
  MakeStr := s;
end;

procedure GetDbfRecord(var D: dbfRecord; RecNum: longint);
var
  Result: integer;
begin
  if RecNum > D.NumRecs then
  begin
    dbfError := REC_TOO_HIGH;
    dbfOK := False;
    Exit;
  end;
  //DebugLn(inttostr(D.HeadLen+(RecNum-1)*D.RecLen));
  seek(D.dFile, D.HeadLen + (RecNum - 1) * D.RecLen);
  dbfError := IOResult;
  if dbfError = 0 then
  begin
    BlockRead(D.dFile, D.CurRecord^, D.RecLen, Result);
    dbfError := IOResult;
    if (dbfError = 0) and (Result < D.RecLen) then
      dbfError := PARTIAL_READ;
  end;
  dbfOK := (dbfError = 0);
end;

procedure PutDbfRecord(var D: dbfRecord; RecNum: longint);
var
  Result: integer;
begin
  if RecNum > D.NumRecs then
  begin
    RecNum := D.NumRecs + 1;
    D.NumRecs := RecNum;
  end;
  seek(D.dFile, D.HeadLen + (RecNum - 1) * D.RecLen);
  dbfError := IOResult;
  if dbfError = 0 then
  begin
    BlockWrite(D.dFile, D.CurRecord^, D.RecLen, Result);
    dbfError := IOResult;
  end;
  if dbfError = 0 then
    D.dStatus := Updated;
  //DebugLn(dbgs(D.reclen));
  dbfOK := (dbfError = 0);
end;                        {PutDbfRecord}

procedure AppendDbf(var D: dbfRecord);
begin
  PutDbfRecord(D, D.NumRecs + 1);
end;

procedure CloseDbf(var D: dbfRecord);
const
  EofMark: byte = $1A;

  procedure UpdateHeader(var D: dbfRecord);
  var
    r: longint;
    YY, MM, DD: word;
  begin
    r := D.NumRecs;
    DeCodeDate(Date, YY, MM, DD);
    if D.HeadProlog[0] = DB2File then
    begin
      D.HeadProlog[5] := YY;
      D.HeadProlog[3] := MM;
      D.HeadProlog[4] := DD; //Reg.DL; {Day}
      D.HeadProlog[2] := r div 256;
      r := r - (D.HeadProlog[5] * 256);
      D.HeadProlog[1] := r;
    end
    else
    begin
      D.HeadProlog[1] := YY;
      D.HeadProlog[2] := MM;
      D.HeadProlog[3] := DD;
      D.HeadProlog[7] := r div 16777216;
      r := r - (D.HeadProlog[7] * 16777216);
      D.HeadProlog[6] := r div 65536;
      r := r - (D.HeadProlog[6] * 65536);
      D.HeadProlog[5] := r div 256;
      r := r - (D.HeadProlog[5] * 256);
      D.HeadProlog[4] := r;
    end;
    seek(D.dFile, 0);
    dbfError := IOResult;
    if dbfError = 0 then
    begin
      BlockWrite(D.dFile, D.HeadProlog, 8);
      dbfError := IOResult;
    end;
    dbfOK := (dbfError = 0);
  end;

begin                       { CloseDbf }
  dbfError := 0;
  if D.dStatus = Updated then
  begin
    UpdateHeader(D);
    if dbfError = 0 then
    begin
      seek(D.dFile, D.HeadLen + D.NumRecs * D.RecLen);
      dbfError := IOResult;
    end;
    if dbfError = 0 then
    begin
      BlockWrite(D.dFile, EofMark, 1); {Put EOF marker }
      dbfError := IOResult;
    end;
  end;   { IF Updated }
  if dbfError = 0 then
  begin
    Close(D.dFile);
    dbfError := IOResult;
  end;
  if dbfError = 0 then
  begin
    D.dStatus := NotOpen;
    FreeMem(D.CurRecord, D.RecLen);
    FreeMem(D.Fields, D.NumFields * SizeOf(_FieldRecord));
  end;
  dbfOK := (dbfError = 0);
end;                        { CloseDbf }

procedure OpenDbf(var D: dbfRecord);

  procedure ProcessHeader(var Header: _HeaderType; NumBytes: integer);
  var
    o, i: integer;
    tempFields: _FieldArray;

    procedure GetOneFieldDesc(var F; var Field: _FieldRecord; var Offset: integer);
    var
      i: integer;
      FD: _FieldDescType ABSOLUTE F;
    begin                   { GetOneFieldDesc }
      i := 0;
      Field.Name := '';
      repeat
        Field.Name[Succ(i)] := Chr(FD[i]);
        i := Succ(i);
      until FD[i] = 0;
      Field.Name[0] := Chr(i);
      Field.Typ := char(FD[11]);
      if D.HeadProlog[0] = DB2File then
      begin
        Field.Len := FD[12];
        Field.Dec := FD[15];
      end
      else
      begin
        Field.Len := FD[16];
        Field.Dec := FD[17];
      end;
      Field.Off := Offset;
      Offset := Offset + Field.Len;
      if not (Field.Typ in ValidTypes) then
        dbfError := INVALID_FIELD;
    end;                    { GetOneFieldDesc }

    procedure ProcessDB2Header;
    var
      o, i, tFieldsLen: integer;
      tempFields: _FieldArray;
    begin   { ProcessDB2Header }
      D.DateOfUpdate := MakeStr(Header[3]) + '/' + MakeStr(Header[4]) + '/' + MakeStr(Header[5]);
      D.NumRecs := MakeWord(Header[1]);
      D.HeadLen := 521;
      if NumBytes < D.HeadLen then
      begin
        dbfError := NOT_DB_FILE;
        Close(D.dFile);
        Exit;
      end;
      D.RecLen := MakeInt(Header[6]); { Includes the Deleted Record Flag }
      GetMem(D.CurRecord, D.RecLen); { Allocate some memory for a buffer  }
      D.dStatus := NotUpdated;
      D.NumFields := 0;
      Move(Header, D.HeadProlog, SizeOf(D.HeadProlog));
      o := 1;                   {Offset within dbf record of current field }
      i := 8;                   {Index for Header }
      while Header[i] <> $0D do
      begin
        D.NumFields := Succ(D.NumFields);
        GetOneFieldDesc(Header[i], tempFields[D.NumFields], o);
        if dbfError <> 0 then
        begin
          Close(D.dFile);
          Exit;
        end;
        i := i + 16;
      end;                    { While Header[i] <> $0D }
      tFieldsLen := D.NumFields * SizeOf(_FieldRecord);
      GetMem(D.Fields, tFieldsLen);
      Move(tempFields, D.Fields^, tFieldsLen);
      D.WithMemo := False;
    end;                      {ProcessDB2Header}

  begin                     {ProcessHeader}
    case Header[0] of
      DB2File:
      begin
        ProcessDB2Header;
        Exit;
      end;
      DB3File: D.WithMemo := False;
      DB3WithMemo: D.WithMemo := True;
      else
      begin
        dbfError := NOT_DB_FILE;
        Close(D.dFile);
        Exit;
      end;
    end;                      {CASE}
    D.DateOfUpdate := IntToStr(Header[1] mod 100) + '/' + MakeStr(Header[2]) + '/' + MakeStr(Header[3]);
    D.NumRecs := MakeLongInt(Header[4]);
    D.HeadLen := MakeInt(Header[8]);
    if NumBytes < D.HeadLen then
    begin
      dbfError := NOT_DB_FILE;
      Close(D.dFile);
      Exit;
    end;
    D.RecLen := MakeInt(Header[10]); { Includes the Deleted Record Flag }
    GetMem(D.CurRecord, D.RecLen); { Allocate some memory for a buffer  }
    D.dStatus := NotUpdated;
    D.NumFields := 0;
    Move(Header, D.HeadProlog, SizeOf(D.HeadProlog));
    o := 1;                   {Offset within dbf record of current field }
    i := 32;                  {Index for Header }
    while Header[i] <> $0D do
    begin
      D.NumFields := Succ(D.NumFields);
      GetOneFieldDesc(Header[i], tempFields[D.NumFields], o);
      if dbfError <> 0 then
      begin
        Close(D.dFile);
        Exit;
      end;
      i := i + 32;
    end;                    { While Header[i] <> $0D }
    i := D.NumFields * SizeOf(_FieldRecord);
    GetMem(D.Fields, i);
    Move(tempFields, D.Fields^, i);
  end;                      {ProcessHeader}

  procedure GetHeader;
  var
    Result: integer;
    H: _HeaderType;
  begin                     { GetHeader }
    BlockRead(D.dFile, H, MAX_HEADER, Result);
    dbfError := IOResult;
    if dbfError = 0 then
      ProcessHeader(H, Result);
  end;                      { GetHeader }

begin                       { OpenDbf }
  Assign(D.dFile, D.FileName);
  Reset(D.dFile, 1); {the '1' parameter sets the record size}
  dbfError := IOResult;
  if dbfError = 0 then
    GetHeader;
  dbfOK := (dbfError = 0);
end;                        { OpenDbf }

procedure CreateDbf(var D: dbfRecord; fn: _Str64; n: integer; flds: _dFields);
  {
  Call this procedure with the full pathname of the file that you want
  to create (fn), the number of fields in a record (n), and a pointer
  to an array of _FieldRecord (flds).  The procedure will initialize all
  the data structures in the dbfRecord (D).
  }

var
  tHeader: _HeaderType;

  procedure MakeFieldDescs;
  var
    i: integer;

    procedure MakeOneFieldDesc(var F; var Field: _FieldRecord);
    var
      FD: _FieldDescType ABSOLUTE F;
    begin                   { MakeOneFieldDesc }
      Move(Field.Name[1], FD, Ord(Field.Name[0]));
      //DebugLn(Field.Name);
      FD[11] := Ord(Field.Typ);
      FD[16] := Field.Len;
      if Field.Typ <> 'N' then
        Field.Dec := 0;
      FD[17] := Field.Dec;
      Field.Off := D.RecLen;
      D.RecLen := D.RecLen + Field.Len;
      if not (Field.Typ in ValidTypes) then
        dbfError := INVALID_FIELD;
      if Field.Typ = 'M' then
        D.WithMemo := True;
    end;                    { MakeOneFieldDesc }

  begin                     {MakeFieldDescs}
    D.RecLen := 1;
    for i := 1 to D.NumFields do
    begin
      //DebugLn(flds^[i].Name);
      MakeOneFieldDesc(tHeader[i * 32], flds^[i]);
      if dbfError <> 0 then
        Exit;
    end;
  end;                      {MakeFieldDescs}

  procedure MakeHeader;
  var
    Result: integer;
  begin                     { MakeHeader }
    FillChar(tHeader, SizeOf(tHeader), #0);
    D.WithMemo := False;
    D.HeadLen := Succ(D.NumFields) * 32;
    tHeader[D.HeadLen] := $0D;
    D.HeadLen := Succ(D.HeadLen);
    tHeader[8] := Lo(D.HeadLen);
    tHeader[9] := Hi(D.HeadLen);
    MakeFieldDescs;
    if D.WithMemo then
      tHeader[0] := DB3WithMemo
    else
      tHeader[0] := DB3File;
    tHeader[10] := Lo(D.RecLen);
    tHeader[11] := Hi(D.RecLen);
  end;                      { MakeHeader }

var
  i: integer;
begin            { CreateDbf }
  D.NumFields := n;
  MakeHeader;
  D.FileName := fn;
  Assign(D.dFile, D.FileName);
  Rewrite(D.dFile, 1); {Will overwrite if file exists!}
  dbfError := IOResult;
  if dbfError = 0 then
  begin
    BlockWrite(D.dFile, tHeader, Succ(D.HeadLen));
    dbfError := IOResult;
  end;
  if dbfError = 0 then
  begin
    D.dStatus := Updated;
    D.NumRecs := 0;
    Move(tHeader, D.HeadProlog, SizeOf(D.HeadProlog));
    D.DateOfUpdate := '  /  /  ';
    GetMem(D.CurRecord, D.RecLen); { Allocate some memory for a buffer  }
    FillChar(D.CurRecord^, D.RecLen, ' ');
    i := D.NumFields * SizeOf(_FieldRecord);
    GetMem(D.Fields, i);
    Move(flds, D.Fields^, i);
  end;
  dbfOK := (dbfError = 0);
end;                        { CreateDbf }

begin
end.
