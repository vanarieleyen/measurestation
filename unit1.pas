unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateUtils, sqldb, Forms,
  Controls, Dialogs, ComCtrls, IniPropStorage, StdCtrls, EditBtn,
  ExtCtrls, Buttons, Grids, PopupNotifier, ExtDlgs, Types, Math,
  LazLoggerDummy, dbhi;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    DirectoryEdit1: TDirectoryEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    IniPropStorage1: TIniPropStorage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet6: TTabSheet;
    Timer1: TTimer;
    Timer2: TTimer;
    TrackBar1: TTrackBar;
    TrayIcon1: TTrayIcon;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure StringGrid3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrayIcon1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure ClearStringGrid(const Grid: TStringGrid);
    procedure UpdateGrid(Sender: TObject; YPBH: string);
    function ConvertDate(s: string): string;
    function GetShift(tijd: string): string;
    function GetFloat(s: string): double;
  end;

type
	TLanguage = record
		telnr, faxnr, remark, add, remove: string;
	end;

var
	Form1: TForm1;
   LastSize: int64;
   Finished: boolean;
	teller: integer;		// used to break from the loop when there are too many inserts
   cfg: TDBFdatabase;       	// specs
   ctdata1: TDBFdatabase;		// measurements master
   ctdata2: TDBFdatabase;		// measurements details

implementation

uses Unit2;

{$R *.lfm}


{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
	IniPropStorage1.Restore;		// get the contents of config.ini
   Application.ShowMainForm := False;
   LastSize := 0;
   Finished := false;
   teller := 0;

   // open the dbase tables (reads all data in memory and closes the files on hd)
	cfg := TDBFdatabase.Create;
   ctdata1 := TDBFdatabase.Create;
   ctdata2 := TDBFdatabase.Create;

   cfg.Open(DirectoryEdit1.Text+PathDelim+'Cfg.DBF');
   ctdata1.Open(DirectoryEdit1.Text+PathDelim+'CtData1.DBF');
   ctdata2.Open(DirectoryEdit1.Text+PathDelim+'CtData2.DBF');
end;

// save the settings
procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
	 IniPropStorage1.Save;
    DataModule1.MySQL56Connection1.Close;

   cfg.Free;
   ctdata1.Free;
   ctdata2.Free;
end;

// empty the stringgrid
procedure TForm1.ClearStringGrid(const Grid: TStringGrid);
var
  c, r: Integer;
begin
	for c := 0 to Pred(Grid.ColCount) do
		for r := 1 to Pred(Grid.RowCount) do
			Grid.Cells[c, r] := '';
	Grid.RowCount := 1;
end;

// checks date format and returns yyyy-mm-yy
function TForm1.ConvertDate(s: string): string;
var
  Y, M, D: string;
begin
   Y := copy(s, 1, 4);
   M := copy(s, 5, 2);
   D := copy(s, 7, 2);
   Result := Y+'-'+M+'-'+D;
end;

// converts a string to double, returns 0 when conversion is not possible
function TForm1.GetFloat(s: string): double;
var
	dummyNumber:double;
	posError:integer;
begin
   DebugLn(s);
	val(s, dummyNumber, posError);
   if (posError=0) then
		result := StrToFloat(s)
   else
		result:= 0;
end;

// show details from the measurement
procedure TForm1.UpdateGrid(Sender: TObject; YPBH: string);
var
   i, r: integer;
begin
	ClearStringGrid(StringGrid1);

   // show field names
   StringGrid1.RowCount := 1;
   StringGrid1.ColCount := ctdata2.numfields+1;
   for i := 0 to ctdata2.NumFields-1 do
      StringGrid1.Cells[i, 0] := ctdata2.fielddev[i].name;

   // show the details
   if ctdata2.Locate('YPBH', YPBH) then begin
		StringGrid1.RowCount := Length(ctdata2.filter)+1;
      for r := 1 to Length(ctdata2.filter) do begin
         FOR i := 0 TO ctdata2.NumFields-1 DO
				StringGrid1.Cells[i, r] := ctdata2.GetFieldNr(i, ctdata2.filter[r-1]);
      end;
   end;
end;

// temporarily disable updates (10min) to browse through the data
procedure TForm1.Button1Click(Sender: TObject);
var
   i, r: integer;
begin
   DebugLn('browse');

  // display specs
  StringGrid2.ColCount := cfg.NumFields;
  StringGrid2.RowCount := cfg.NumRecs+1;
  for i := 0 to cfg.NumFields-1 do
     StringGrid2.Cells[i, 0] := cfg.fielddev[i].name;
  r := 1;
  WHILE r <= cfg.NumRecs DO BEGIN
     FOR i := 0 TO cfg.NumFields-1 DO
      	StringGrid2.Cells[i,r] := cfg.GetFieldNr(i, r);
     r := r+1;
  END;

  // display measurements master
  StringGrid3.ColCount := ctdata1.NumFields;
  StringGrid3.RowCount := ctdata1.NumRecs+1;
  for i := 0 to ctdata1.NumFields-1 do
     StringGrid3.Cells[i, 0] := ctdata1.fielddev[i].name;
  r := 1;
  WHILE r <= ctdata1.NumRecs DO BEGIN
     FOR i := 0 TO ctdata1.NumFields-1 DO
      	StringGrid3.Cells[i,r] := ctdata1.GetFieldNr(i, r);
     r := r+1;
  END;

  	for i := 0 to ctdata1.numfields-1 do      // get field number for YPBH
      if ctdata1.fielddev[i].name = 'YPBH' then break;

   // diplay details
	UpdateGrid(Sender, StringGrid3.Cells[i, 1]);

   Timer1.Enabled := false;
   Timer2.Enabled := true;
end;

// reads the specifications from the laboratory station and sends it to the server (adds it, doesn't replace)
procedure TForm1.Button2Click(Sender: TObject);
var
   prodname, MeasFormat: string;
   recordnr: integer;
begin
	Timer1.Enabled := false;
	Timer2.Enabled := false;

	DataModule1.Connect(Sender);		// connect to server
   if DataModule1.MySQL56Connection1.Connected then begin
   	with DataModule1.SQLQuery1 do begin
      	recordnr := 1;
         while recordnr < cfg.numrecs do begin
            prodname := cfg.GetField('PH', recordnr);
				MeasFormat := ':PH, :WGLO, :WGSTD, :WGHI, :CIRLO, :CIRSTD, :CIRHI, :LENLO, :LENSTD, :LENHI, '+
									':PDOLO, :PDOSTD, :PDOHI, :VLO, :VSTD, :VHI, :HDLO, :HDSTD, :HDHI';
				SQL.Text:='INSERT INTO products_finished (`name`, `weight_min`, `weight`, `weight_max`, `circ_min`, `circ`, `circ_max`, '+
								'`len_min`, `len`, `len_max`, `pd_min`, `pd`, `pd_max`, `vent_min`, `vent`, `vent_max`,'+
								'`hd_min`, `hd`, `hd_max`) VALUES ('+MeasFormat+')';
				Params.ParamByName('PH').AsString := prodname;
				Params.ParamByName('WGLO').AsString := cfg.GetField('WGLO', recordnr);
				Params.ParamByName('WGSTD').AsString := cfg.GetField('WGSTD', recordnr);
				Params.ParamByName('WGHI').AsString := cfg.GetField('WGHI', recordnr);
				Params.ParamByName('CIRLO').AsString := cfg.GetField('CIRLO', recordnr);
				Params.ParamByName('CIRSTD').AsString := cfg.GetField('CIRSTD', recordnr);
				Params.ParamByName('CIRHI').AsString := cfg.GetField('CIRHI', recordnr);
				Params.ParamByName('LENLO').AsString := cfg.GetField('LENLO', recordnr);
				Params.ParamByName('LENSTD').AsString := cfg.GetField('LENSTD', recordnr);
				Params.ParamByName('LENHI').AsString := cfg.GetField('LENHI', recordnr);
				Params.ParamByName('PDOLO').AsString := cfg.GetField('PDOLO', recordnr);
				Params.ParamByName('PDOSTD').AsString := cfg.GetField('PDOSTD', recordnr);
				Params.ParamByName('PDOHI').AsString := cfg.GetField('PDOHI', recordnr);
				Params.ParamByName('VLO').AsString := cfg.GetField('VLO', recordnr);
				Params.ParamByName('VSTD').AsString := cfg.GetField('VSTD', recordnr);
				Params.ParamByName('VHI').AsString := cfg.GetField('VHI', recordnr);
				Params.ParamByName('HDLO').AsString := cfg.GetField('HDLO', recordnr);
				Params.ParamByName('HDSTD').AsString := cfg.GetField('HDSTD', recordnr);
				Params.ParamByName('HDHI').AsString := cfg.GetField('HDHI', recordnr);
				ExecSQL;
				DataModule1.SQLTransaction1.Commit;
            recordnr := recordnr+1;
         end;
      end;

   end;

end;

// reads the specifications from the workfloor station and sends it to the server (adds it, doesn't replace)
procedure TForm1.Button3Click(Sender: TObject);
var
   prodname, MeasFormat: string;
   recordnr: integer;
begin
	Timer1.Enabled := false;
	Timer2.Enabled := false;

	DataModule1.Connect(Sender);		// connect to server
   if DataModule1.MySQL56Connection1.Connected then begin
   	with DataModule1.SQLQuery1 do begin
      	recordnr := 1;
         while recordnr < cfg.numrecs do begin
            prodname := cfg.GetField('PH', recordnr);
				MeasFormat := ':PH, :WGLO, :WGSTD, :WGHI, :CIRLO, :CIRSTD, :CIRHI, :LENLO, :LENSTD, :LENHI, '+
									':PDOLO, :PDOSTD, :PDOHI, :VLO, :VSTD, :VHI, :HDLO, :HDSTD, :HDHI';
				SQL.Text:='INSERT INTO products_finished (`name`, `weight_min`, `weight`, `weight_max`, `circ_min`, `circ`, `circ_max`, '+
								'`len_min`, `len`, `len_max`, `pd_min`, `pd`, `pd_max`, `vent_min`, `vent`, `vent_max`,'+
								'`hd_min`, `hd`, `hd_max`) VALUES ('+MeasFormat+')';
				Params.ParamByName('PH').AsString := prodname;
				Params.ParamByName('WGLO').AsString := cfg.GetField('WGLO', recordnr);
				Params.ParamByName('WGSTD').AsString := cfg.GetField('WGSTD', recordnr);
				Params.ParamByName('WGHI').AsString := cfg.GetField('WGHI', recordnr);
				Params.ParamByName('CIRLO').AsString := cfg.GetField('CIRLO', recordnr);
				Params.ParamByName('CIRSTD').AsString := cfg.GetField('CIRSTD', recordnr);
				Params.ParamByName('CIRHI').AsString := cfg.GetField('CIRHI', recordnr);
				Params.ParamByName('LENLO').AsString := cfg.GetField('LENLO', recordnr);
				Params.ParamByName('LENSTD').AsString := cfg.GetField('LENSTD', recordnr);
				Params.ParamByName('LENHI').AsString := cfg.GetField('LENHI', recordnr);
				Params.ParamByName('PDOLO').AsString := cfg.GetField('PDOLO', recordnr);
				Params.ParamByName('PDOSTD').AsString := cfg.GetField('PDOSTD', recordnr);
				Params.ParamByName('PDOHI').AsString := cfg.GetField('PDOHI', recordnr);
				Params.ParamByName('VLO').AsString := cfg.GetField('VLO', recordnr);
				Params.ParamByName('VSTD').AsString := cfg.GetField('VSTD', recordnr);
				Params.ParamByName('VHI').AsString := cfg.GetField('VHI', recordnr);
				Params.ParamByName('HDLO').AsString := cfg.GetField('HDLO', recordnr);
				Params.ParamByName('HDSTD').AsString := cfg.GetField('HDSTD', recordnr);
				Params.ParamByName('HDHI').AsString := cfg.GetField('HDHI', recordnr);
				ExecSQL;
				DataModule1.SQLTransaction1.Commit;
            recordnr := recordnr+1;
         end;
      end;

   end;
end;

function TForm1.GetShift(tijd: string): string;
var
   List: TStrings;
   h, m, min: integer;
begin
   List := TStringList.Create;
   ExtractStrings([':'], [], PChar(tijd), List);
   h := List[0].ToInteger();
	m := List[1].ToInteger();
   min := (h*60)+m;

	if InRange(min, 480, 780) then
      Result := '1'
   else if InRange(min, 780, 1080) then
   	Result := '2'
   else if InRange(min, 1080, 1320) then
   	Result := '3'
   else if InRange(min, 120, 1320) then
   	Result := '4';

   List.Free;
end;

procedure TForm1.FormWindowStateChange(Sender: TObject);
begin
   if Form1.WindowState = wsminimized then begin
      Form1.Hide;
      TrayIcon1.Visible:=true;
   end;
end;

// update the detail-grid
procedure TForm1.StringGrid3MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   i: integer;
begin
  	for i := 0 to ctdata1.numfields-1 do
      if ctdata1.fielddev[i].name = 'YPBH' then
         break;
	UpdateGrid(Sender, StringGrid3.Cells[i, StringGrid3.Row]);
end;

// the main program loop
// stores data on the server
procedure TForm1.Timer1Timer(Sender: TObject);
var
   sticks: string;
   YPBH, nr, MeasFormat, MS, row: string;
	S : TDateTime;
	fs: int64;
   recordnr, detailnr: integer;
   spec_hd, spec_circ, spec_len, spec_pd, spec_vent, spec_weight: string;
   n1, n2: single;
   spec_name, spec_nr, spec_weight_min, spec_weight_max, spec_circ_min, spec_circ_max, spec_len_min, spec_len_max: string;
   spec_pd_min, spec_pd_max, spec_hd_min, spec_hd_max, spec_vent_min, spec_vent_max, spec_pid: string;
begin
	Timer1.Enabled:=false;
   Timer2.Enabled:=false;

   if (teller = 0) then
	   teller := 10;        // process a maximum of 10 new records

   // remove the trayicon to prevent closing the program
//   TrayIcon1.Visible:= false;

   // sync the specifications with the server
   DebugLn('connecting');
   DataModule1.Connect(Sender);		// connect to the main server
   DebugLn('after connect');

   if DataModule1.MySQL56Connection1.Connected then begin
   	with DataModule1.SQLQuery1 do begin
         DebugLn('send query');
         Close;
   		SQL.Text:='SELECT force_update FROM stations WHERE name='+Edit2.Text;		// check if there is a force update specs on the server
         Open;
         if (FieldByName('force_update').AsInteger > 0) then begin
            DebugLn('force update');

            cfg.Empty();  // delete all records from the dbase table
            recordnr := 0;

				Close;
				SQL.Text:='SELECT * FROM products_finished WHERE DATE(end) = "3000-01-01" ';		// select the latest specs from the server
				Open;

            while (not Eof) do begin
               // get all specs from the server
               spec_name := FieldByName('name').AsString;
               spec_pid := FieldByName('pid').AsString;
               if (FieldByName('weight').AsString='') then spec_weight:='0' else spec_weight:=FieldByName('weight').AsString;
               if (FieldByName('weight_min').AsString='') then spec_weight_min:='0' else spec_weight_min:=FieldByName('weight_min').AsString;
               if (FieldByName('weight_max').AsString='') then spec_weight_max:='0' else spec_weight_max:=FieldByName('weight_max').AsString;
               if (FieldByName('circ').AsString='') then spec_circ:='0' else spec_circ:=FieldByName('circ').AsString;
               if (FieldByName('circ_min').AsString='') then spec_circ_min:='0' else spec_circ_min:=FieldByName('circ_min').AsString;
               if (FieldByName('circ_max').AsString='') then spec_circ_max:='0' else spec_circ_max:=FieldByName('circ_max').AsString;
               if (FieldByName('len').AsString='') then spec_len:='0' else spec_len:=FieldByName('len').AsString;
               if (FieldByName('len_min').AsString='') then spec_len_min:='0' else spec_len_min:=FieldByName('len_min').AsString;
               if (FieldByName('len_max').AsString='') then spec_len_max:='0' else spec_len_max:=FieldByName('len_max').AsString;
               if (FieldByName('pd').AsString='') then spec_pd:='0' else spec_pd:=FieldByName('pd').AsString;
               if (FieldByName('pd_min').AsString='') then spec_pd_min:='0' else spec_pd_min:=FieldByName('pd_min').AsString;
               if (FieldByName('pd_max').AsString='') then spec_pd_max:='0' else spec_pd_max:=FieldByName('pd_max').AsString;
               if (FieldByName('vent').AsString='') then spec_vent:='0' else spec_vent:=FieldByName('vent').AsString;
               if (FieldByName('vent_min').AsString='') then spec_vent_min:='0' else spec_vent_min:=FieldByName('vent_min').AsString;
               if (FieldByName('vent_max').AsString='') then spec_vent_max:='0' else spec_vent_max:=FieldByName('vent_max').AsString;
               if (FieldByName('hd').AsString='') then spec_hd:='0' else spec_hd:=FieldByName('hd').AsString;
               if (FieldByName('hd_min').AsString='') then spec_hd_min:='0' else spec_hd_min:=FieldByName('hd_min').AsString;
               if (FieldByName('hd_max').AsString='') then spec_hd_max:='0' else spec_hd_max:=FieldByName('hd_max').AsString;

               // add the spec to the empty file
               cfg.Append();
               recordnr := recordnr+1;
               cfg.SetField('PH', recordnr, spec_name);
               cfg.SetField('ITEMS', recordnr, spec_pid);
               cfg.SetField('WGSTD', recordnr, spec_weight);
               cfg.SetField('WGLO', recordnr, spec_weight_min);
               cfg.SetField('WGHI', recordnr, spec_weight_max);
               cfg.SetField('CIRSTD', recordnr, spec_circ);
               cfg.SetField('CIRLO', recordnr, spec_circ_min);
               cfg.SetField('CIRHI', recordnr, spec_circ_max);
               cfg.SetField('LENSTD', recordnr, spec_len);
               cfg.SetField('LENLO', recordnr, spec_len_min);
               cfg.SetField('LENHI', recordnr, spec_len_max);
               cfg.SetField('PDOSTD', recordnr, spec_pd);
               cfg.SetField('PDOLO', recordnr, spec_pd_min);
               cfg.SetField('PDOHI', recordnr, spec_pd_max);
               cfg.SetField('VSTD', recordnr, spec_vent);
               cfg.SetField('VLO', recordnr, spec_vent_min);
               cfg.SetField('VHI', recordnr, spec_vent_max);
               cfg.SetField('HDSTD', recordnr, spec_hd);
               cfg.SetField('HDLO', recordnr, spec_hd_min);
               cfg.SetField('HDHI', recordnr, spec_hd_max);

               // the remaining fields that are not used
               cfg.SetField('PDOMMWGSTD', recordnr, '');
               cfg.SetField('PDOMMWGLO', recordnr, '');
               cfg.SetField('PDOMMWGHI', recordnr, '');
               cfg.SetField('PDCSTD', recordnr, '');
               cfg.SetField('PDCLO', recordnr, '');
               cfg.SetField('PDCHI', recordnr, '');
               cfg.SetField('FVSTD', recordnr, '');
               cfg.SetField('FVLO', recordnr, '');
               cfg.SetField('FVHI', recordnr, '');
               cfg.SetField('PVSTD', recordnr, '');
               cfg.SetField('PVLO', recordnr, '');
               cfg.SetField('PVHI', recordnr, '');
               Next;
            end;

            SQL.Text:='UPDATE stations SET force_update=0, date=NOW() WHERE name='+Edit2.Text;
            ExecSQL;
	         DataModule1.SQLTransaction1.Commit;
         end;

   		Close;
   		SQL.Text:='CHECKSUM TABLE products_finished';		// get the checksum of the spec-table from the server
   		Open;

         if (Edit3.Text <> FieldByName('Checksum').AsString) then begin

            Edit3.Text := FieldByName('Checksum').AsString;		// store the new checksum

            Close;
	   		SQL.Text:='SELECT * FROM products_finished WHERE DATE(end) = "3000-01-01" ';		// select the latest specs from the server
   			Open;

            while (not Eof) do begin
               // get all specs from the server
               spec_name := FieldByName('name').AsString;
               spec_pid := FieldByName('pid').AsString;
               if (FieldByName('weight').AsString='') then spec_weight:='0' else spec_weight:=FieldByName('weight').AsString;
               if (FieldByName('weight_min').AsString='') then spec_weight_min:='0' else spec_weight_min:=FieldByName('weight_min').AsString;
               if (FieldByName('weight_max').AsString='') then spec_weight_max:='0' else spec_weight_max:=FieldByName('weight_max').AsString;
               if (FieldByName('circ').AsString='') then spec_circ:='0' else spec_circ:=FieldByName('circ').AsString;
               if (FieldByName('circ_min').AsString='') then spec_circ_min:='0' else spec_circ_min:=FieldByName('circ_min').AsString;
               if (FieldByName('circ_max').AsString='') then spec_circ_max:='0' else spec_circ_max:=FieldByName('circ_max').AsString;
               if (FieldByName('len').AsString='') then spec_len:='0' else spec_len:=FieldByName('len').AsString;
               if (FieldByName('len_min').AsString='') then spec_len_min:='0' else spec_len_min:=FieldByName('len_min').AsString;
               if (FieldByName('len_max').AsString='') then spec_len_max:='0' else spec_len_max:=FieldByName('len_max').AsString;
               if (FieldByName('pd').AsString='') then spec_pd:='0' else spec_pd:=FieldByName('pd').AsString;
               if (FieldByName('pd_min').AsString='') then spec_pd_min:='0' else spec_pd_min:=FieldByName('pd_min').AsString;
               if (FieldByName('pd_max').AsString='') then spec_pd_max:='0' else spec_pd_max:=FieldByName('pd_max').AsString;
               if (FieldByName('vent').AsString='') then spec_vent:='0' else spec_vent:=FieldByName('vent').AsString;
               if (FieldByName('vent_min').AsString='') then spec_vent_min:='0' else spec_vent_min:=FieldByName('vent_min').AsString;
               if (FieldByName('vent_max').AsString='') then spec_vent_max:='0' else spec_vent_max:=FieldByName('vent_max').AsString;
               if (FieldByName('hd').AsString='') then spec_hd:='0' else spec_hd:=FieldByName('hd').AsString;
               if (FieldByName('hd_min').AsString='') then spec_hd_min:='0' else spec_hd_min:=FieldByName('hd_min').AsString;
               if (FieldByName('hd_max').AsString='') then spec_hd_max:='0' else spec_hd_max:=FieldByName('hd_max').AsString;

               // find the corresponding spec on the station
               if cfg.Locate('ITEMS', spec_pid) then begin
                  recordnr := cfg.filter[0];
               end else begin
                  cfg.Append();
                  recordnr := cfg.numrecs-1;
               end;

					cfg.SetField('PH', recordnr, spec_name);
               cfg.SetField('ITEMS', recordnr, spec_pid);
					cfg.SetField('WGSTD', recordnr, spec_weight);
					cfg.SetField('WGLO', recordnr, spec_weight_min);
					cfg.SetField('WGHI', recordnr, spec_weight_max);
					cfg.SetField('CIRSTD', recordnr, spec_circ);
					cfg.SetField('CIRLO', recordnr, spec_circ_min);
					cfg.SetField('CIRHI', recordnr, spec_circ_max);
               cfg.SetField('LENSTD', recordnr, spec_len);
               cfg.SetField('LENLO', recordnr, spec_len_min);
               cfg.SetField('LENHI', recordnr, spec_len_max);
               cfg.SetField('PDOSTD', recordnr, spec_pd);
               cfg.SetField('PDOLO', recordnr, spec_pd_min);
               cfg.SetField('PDOHI', recordnr, spec_pd_max);
               cfg.SetField('VSTD', recordnr, spec_vent);
               cfg.SetField('VLO', recordnr, spec_vent_min);
               cfg.SetField('VHI', recordnr, spec_vent_max);
               cfg.SetField('HDSTD', recordnr, spec_hd);
               cfg.SetField('HDLO', recordnr, spec_hd_min);
               cfg.SetField('HDHI', recordnr, spec_hd_max);

               // the remaining fields that are not used
               cfg.SetField('PDOMMWGSTD', recordnr, '');
               cfg.SetField('PDOMMWGLO', recordnr, '');
               cfg.SetField('PDOMMWGHI', recordnr, '');
               cfg.SetField('PDCSTD', recordnr, '');
               cfg.SetField('PDCLO', recordnr, '');
               cfg.SetField('PDCHI', recordnr, '');
               cfg.SetField('FVSTD', recordnr, '');
               cfg.SetField('FVLO', recordnr, '');
               cfg.SetField('FVHI', recordnr, '');
               cfg.SetField('PVSTD', recordnr, '');
               cfg.SetField('PVLO', recordnr, '');
               cfg.SetField('PVHI', recordnr, '');
               Next;
            end;

            SQL.Text:='UPDATE stations SET force_update=0, date=NOW() WHERE name='+Edit2.Text;
            ExecSQL;
	         DataModule1.SQLTransaction1.Commit;
         end;

      end;
   end;

   fs := FileSize(IncludeTrailingPathDelimiter(DirectoryEdit1.Text)+'CtData1.DBF');

   //DebugLn('size database station = '+dbgs(fs));
   //DebugLn('last size = '+dbgs(LastSize));
   //DebugLn('Finished = '+dbgs(Finished));

   //Finished := true;
   if ((fs <> LastSize) OR NOT Finished) then begin
      DebugLn('start updating server');
      Form1.Caption := 'Last Update at: '+DateTimeToStr(Now);
      Form1.Caption := intToStr(fs);
   	LastSize := fs;

      if DataModule1.MySQL56Connection1.Connected then begin
      	with DataModule1.SQLQuery1 do begin
            DebugLn('teller = '+dbgs(teller));

            recordnr := ctdata1.numrecs-1;
            while (recordnr > 0) and (teller > 0) do begin
               YPBH := Edit2.Caption + '-' + ctdata1.GetField('YPBH', recordnr);

         		Close;
         		SQL.Text:='SELECT * FROM cigaret WHERE YPBH="'+YPBH+'"';		// check to see if the data is already stored
         		Open;

            	if (Eof) then begin 	// measurement not found
               	spec_name := ctdata1.GetField('PH', recordnr);

                  teller := teller-1;

						// find product specifications
						Close;
                  SQL.Text:='SELECT * FROM products_finished WHERE DATE(end) = "3000-01-01" AND name="'+spec_name+'"';
						Open;

						spec_hd := DataModule1.SQLQuery1.FieldByName('hd').AsString;
						spec_circ := DataModule1.SQLQuery1.FieldByName('circ').AsString;
						spec_len := DataModule1.SQLQuery1.FieldByName('len').AsString;
						spec_pd := DataModule1.SQLQuery1.FieldByName('pd').AsString;
						spec_vent := DataModule1.SQLQuery1.FieldByName('vent').AsString;
						spec_weight := DataModule1.SQLQuery1.FieldByName('weight').AsString;

						MeasFormat := ':DATE, :SHIFT, :ORIGIN, :PH, :ITEMS, :JTH, '+
											':HDMAX, :HDMIN, :HDMEAN, :HDSD, :HDCV, :HDCPK, :HDBAD, :HDDIV, '+
											':CIRMAX, :CIRMIN, :CIRMEAN, :CIRSD, :CIRCV, :CIRCPK, :CIRBAD, :CIRDIV, '+
											':LENMAX, :LENMIN, :LENMEAN, :LENSD, :LENCV, :LENCPK, :LENBAD, :LENDIV, '+
											':PDOMAX, :PDOMIN, :PDOMEAN, :PDOSD, :PDOCV, :PDOCPK, :PDOBAD, :PDODIV, '+
											':VMAX, :VMIN, :VMEAN, :VSD, :VCV, :VCPK, :VBAD, :VDIV, '+
											':WGMAX, :WGMIN, :WGMEAN, :WGSD, :WGCV, :WGCPK, :WGBAD, :WGDIV, :YPBH';
						SQL.Text:='INSERT INTO cigaret(`date`, `shift`, `origin`, `product`, `bunching_m`, `packing_m`, `max_hd`, `min_hd`, '+
										'`avg_hd`, `dev_hd`, `var_hd`, `cpk_hd`, `out_hd`, `div_hd`, `max_circum`, `min_circum`, `avg_circum`, `dev_circum`, `var_circum`, '+
										'`cpk_circum`, `out_circum`, `div_circum`, `max_len`, `min_len`, `avg_len`, `dev_len`, `var_len`, `cpk_len`, `out_len`, `div_len`, '+
										'`max_pd`, `min_pd`, `avg_pd`, `dev_pd`, `var_pd`, `cpk_pd`, `out_pd`, `div_pd`, `max_vent`, `min_vent`, `avg_vent`, `dev_vent`, '+
										'`var_vent`, `cpk_vent`, `out_vent`, `div_vent`, `max_weight`, `min_weight`, `avg_weight`, `dev_weight`, `var_weight`, `cpk_weight`, '+
										'`out_weight`, `div_weight`, `YPBH`) '+
										'VALUES ('+MeasFormat+')';
						Params.ParamByName('DATE').AsString := ConvertDate(ctdata1.GetField('DATE', recordnr)) +' '+ ctdata1.GetField('TIME', recordnr);
						Params.ParamByName('SHIFT').AsString := GetShift(ctdata1.GetField('TIME', recordnr));
						Params.ParamByName('ORIGIN').AsString := Edit2.Text;
						Params.ParamByName('PH').AsString := ctdata1.GetField('PH', recordnr);
						Params.ParamByName('ITEMS').AsString := ctdata1.GetField('ITEMS', recordnr);
						Params.ParamByName('JTH').AsString := ctdata1.GetField('JTH', recordnr);

						Params.ParamByName('HDMAX').AsString := ctdata1.GetField('HDMAX', recordnr);
						Params.ParamByName('HDMIN').AsString := ctdata1.GetField('HDMIN', recordnr);
						Params.ParamByName('HDMEAN').AsString := ctdata1.GetField('HDMEAN', recordnr);
						Params.ParamByName('HDSD').AsString := ctdata1.GetField('HDSD', recordnr);
						Params.ParamByName('HDCV').AsString := ctdata1.GetField('HDCV', recordnr);
						Params.ParamByName('HDCPK').AsString := ctdata1.GetField('HDCPK', recordnr);
						Params.ParamByName('HDBAD').AsString := ctdata1.GetField('HDBAD', recordnr);
						if (Trim(ctdata1.GetField('HDMEAN', recordnr)) <> '') then begin
							n1 := GetFloat(ctdata1.GetField('HDMEAN', recordnr));
							n2 := GetFloat(spec_hd);
							Params.ParamByName('HDDIV').AsString := FloatToStr(  Round(100*Abs(n1-n2))/100 );
						end else
							Params.ParamByName('HDDIV').AsString := '-';

                  Params.ParamByName('CIRMAX').AsString := ctdata1.GetField('CIRMAX', recordnr);
						Params.ParamByName('CIRMIN').AsString := ctdata1.GetField('CIRMIN', recordnr);
						Params.ParamByName('CIRMEAN').AsString := ctdata1.GetField('CIRMEAN', recordnr);
						Params.ParamByName('CIRSD').AsString := ctdata1.GetField('CIRSD', recordnr);
						Params.ParamByName('CIRCV').AsString := ctdata1.GetField('CIRCV', recordnr);
						Params.ParamByName('CIRCPK').AsString := ctdata1.GetField('CIRCPK', recordnr);
						Params.ParamByName('CIRBAD').AsString := ctdata1.GetField('CIRBAD', recordnr);
						if (Trim(ctdata1.GetField('CIRMEAN', recordnr)) <> '') then begin
							n1 := GetFloat(ctdata1.GetField('CIRMEAN', recordnr));
							n2 := GetFloat(spec_circ);
							Params.ParamByName('CIRDIV').AsString := FloatToStr( Round(100*Abs(n1-n2))/100 );
						end else
							Params.ParamByName('CIRDIV').AsString := '-';

                  Params.ParamByName('LENMAX').AsString := ctdata1.GetField('LENMAX', recordnr);
						Params.ParamByName('LENMIN').AsString := ctdata1.GetField('LENMIN', recordnr);
						Params.ParamByName('LENMEAN').AsString := ctdata1.GetField('LENMEAN', recordnr);
						Params.ParamByName('LENSD').AsString := ctdata1.GetField('LENSD', recordnr);
						Params.ParamByName('LENCV').AsString := ctdata1.GetField('LENCV', recordnr);
						Params.ParamByName('LENCPK').AsString := ctdata1.GetField('LENCPK', recordnr);
						Params.ParamByName('LENBAD').AsString := ctdata1.GetField('LENBAD', recordnr);
						if (Trim(ctdata1.GetField('LENMEAN', recordnr)) <> '') then begin
							n1 := GetFloat(ctdata1.GetField('LENMEAN', recordnr));
							n2 := GetFloat(spec_len);
							Params.ParamByName('LENDIV').AsString := FloatToStr( Round(100*Abs(n1-n2))/100 );
						end else
							Params.ParamByName('LENDIV').AsString := '-';

						Params.ParamByName('PDOMAX').AsString := ctdata1.GetField('PDOMAX', recordnr);
						Params.ParamByName('PDOMIN').AsString := ctdata1.GetField('PDOMIN', recordnr);
						Params.ParamByName('PDOMEAN').AsString := ctdata1.GetField('PDOMEAN', recordnr);
						Params.ParamByName('PDOSD').AsString := ctdata1.GetField('PDOSD', recordnr);
						Params.ParamByName('PDOCV').AsString := ctdata1.GetField('PDOCV', recordnr);
						Params.ParamByName('PDOCPK').AsString := ctdata1.GetField('PDOCPK', recordnr);
						Params.ParamByName('PDOBAD').AsString := ctdata1.GetField('PDOBAD', recordnr);
						if (Trim(ctdata1.GetField('PDOMEAN', recordnr)) <> '') then begin
							n1 := GetFloat(ctdata1.GetField('PDOMEAN', recordnr));
							n2 := GetFloat(spec_pd);
							Params.ParamByName('PDODIV').AsString := FloatToStr( Round(100*Abs(n1-n2))/100 );
						end else
							Params.ParamByName('PDODIV').AsString := '-';

						Params.ParamByName('VMAX').AsString := ctdata1.GetField('VMAX', recordnr);
						Params.ParamByName('VMIN').AsString := ctdata1.GetField('VMIN', recordnr);
						Params.ParamByName('VMEAN').AsString := ctdata1.GetField('VMEAN', recordnr);
						Params.ParamByName('VSD').AsString := ctdata1.GetField('VSD', recordnr);
						Params.ParamByName('VCV').AsString := ctdata1.GetField('VCV', recordnr);
						Params.ParamByName('VCPK').AsString := ctdata1.GetField('VCPK', recordnr);
						Params.ParamByName('VBAD').AsString := ctdata1.GetField('VBAD', recordnr);
						if (Trim(ctdata1.GetField('VMEAN', recordnr)) <> '') then begin
							n1 := GetFloat(ctdata1.GetField('VMEAN', recordnr));
							n2 := GetFloat(spec_vent);
							Params.ParamByName('VDIV').AsString := FloatToStr( Round(100*Abs(n1-n2))/100 );
						end else
							Params.ParamByName('VDIV').AsString := '-';

						Params.ParamByName('WGMAX').AsString := ctdata1.GetField('WGMAX', recordnr);
						Params.ParamByName('WGMIN').AsString := ctdata1.GetField('WGMIN', recordnr);
						Params.ParamByName('WGMEAN').AsString := ctdata1.GetField('WGMEAN', recordnr);
						Params.ParamByName('WGSD').AsString := ctdata1.GetField('WGSD', recordnr);
						Params.ParamByName('WGCV').AsString := ctdata1.GetField('WGCV', recordnr);
						Params.ParamByName('WGCPK').AsString := ctdata1.GetField('WGCPK', recordnr);
						Params.ParamByName('WGBAD').AsString := ctdata1.GetField('WGBAD', recordnr);
						if (Trim(ctdata1.GetField('WGMEAN', recordnr)) <> '') then begin
							n1 := GetFloat(ctdata1.GetField('WGMEAN', recordnr));
							n2 := GetFloat(spec_weight);
							Params.ParamByName('WGDIV').AsString := FloatToStr( Round(100*Abs(n1-n2))/100 );
						end else
							Params.ParamByName('WGDIV').AsString := '-';

						Params.ParamByName('YPBH').AsString := YPBH;

						ExecSQL;
						DataModule1.SQLTransaction1.Commit;

   	         end;

               // get the stick numbers that are already stored
               with DataModule1.SQLQuery1 do begin
                  Close;
            		SQL.Text:='SELECT * FROM weight WHERE master="'+YPBH+'"';		// check to see if the details are already stored (in any detail table)
            		Open;
                  sticks := '';
      				while not Eof do begin
      					sticks := format('%s %s', [sticks, FieldByName('stick').AsString]);	// make a string with all the stored stick numbers
      					Next;
      				end;
               end;

   				// loop de details af
               detailnr := 1;
   				while detailnr < ctdata2.numrecs do begin
   					if (Edit2.Caption+'-'+ctdata2.GetField('YPBH', detailnr)) = YPBH then begin  // check only the details of the current master
   						nr := ctdata2.GetField('NO', detailnr);
   						if Pos(nr, sticks) = 0 then begin	// store the stick that was not found on the server
                        // create a new row
                        SQL.Text := 'INSERT INTO rows (`id`) VALUES(null)';
                        ExecSQL;
             	         DataModule1.SQLTransaction1.Commit;
                        Close;
                        SQL.Text := 'SELECT id FROM rows ORDER BY id DESC LIMIT 1';
                        Open;
                        row := FieldByName('ID').AsString; // get the created row number

                        MeasFormat := ':STICK, :MASTER, :VALUE, :ROW';

                        SQL.Text:='INSERT INTO weight(`stick`, `master`, `value`, `row`) VALUES ('+MeasFormat+')';
                        Params.ParamByName('STICK').AsString := nr;
            	         Params.ParamByName('MASTER').AsString := YPBH;
               	      Params.ParamByName('VALUE').AsString := ctdata2.GetField('WG', detailnr);
                        Params.ParamByName('row').AsString := row;
                        ExecSQL;
   	      	         DataModule1.SQLTransaction1.Commit;

                        SQL.Text:='INSERT INTO circumference(`stick`, `master`, `value`, `row`) VALUES ('+MeasFormat+')';
                        Params.ParamByName('STICK').AsString := nr;
            	         Params.ParamByName('MASTER').AsString := YPBH;
               	      Params.ParamByName('VALUE').AsString := ctdata2.GetField('CIR', detailnr);
                        Params.ParamByName('ROW').AsString := row;
                        ExecSQL;
   	      	         DataModule1.SQLTransaction1.Commit;

                        SQL.Text:='INSERT INTO length(`stick`, `master`, `value`, `row`) VALUES ('+MeasFormat+')';
                        Params.ParamByName('STICK').AsString := nr;
            	         Params.ParamByName('MASTER').AsString := YPBH;
               	      Params.ParamByName('VALUE').AsString := ctdata2.GetField('LEN', detailnr);
                        Params.ParamByName('ROW').AsString := row;
                        ExecSQL;
   	      	         DataModule1.SQLTransaction1.Commit;

                        SQL.Text:='INSERT INTO pd (`stick`, `master`, `value`, `row`) VALUES ('+MeasFormat+')';
                        Params.ParamByName('STICK').AsString := nr;
            	         Params.ParamByName('MASTER').AsString := YPBH;
               	      Params.ParamByName('VALUE').AsString := ctdata2.GetField('PDO', detailnr);
                        Params.ParamByName('ROW').AsString := row;
                        ExecSQL;
   	      	         DataModule1.SQLTransaction1.Commit;

                        SQL.Text:='INSERT INTO ventilation(`stick`, `master`, `value`, `row`) VALUES ('+MeasFormat+')';
                        Params.ParamByName('STICK').AsString := nr;
            	         Params.ParamByName('MASTER').AsString := YPBH;
               	      Params.ParamByName('VALUE').AsString := ctdata2.GetField('V', detailnr);
                        Params.ParamByName('ROW').AsString := row;
                        ExecSQL;
   	      	         DataModule1.SQLTransaction1.Commit;

                        SQL.Text:='INSERT INTO hardness(`stick`, `master`, `value`, `row`) VALUES ('+MeasFormat+')';
                        Params.ParamByName('STICK').AsString := nr;
            	         Params.ParamByName('MASTER').AsString := YPBH;
               	      Params.ParamByName('VALUE').AsString := ctdata2.GetField('HD', detailnr);
                        Params.ParamByName('ROW').AsString := row;
                        ExecSQL;
   	      	         DataModule1.SQLTransaction1.Commit;
                        {  }
                  	end;
                  end;
   					detailnr := detailnr+1; 	// next detail record
   				end;
      	      recordnr := recordnr-1;	// prior master record
   	      end;
            Finished := (recordnr = 0);
      	end;
      end;
   end;

   if DataModule1.MySQL56Connection1.Connected then
      DataModule1.DisConnect(Sender);	// disconnect the server

   Timer1.Enabled := true;
end;

// enable the update timer (after browsing)
procedure TForm1.Timer2Timer(Sender: TObject);
begin
  Timer1.Enabled:=true;
end;

// change the update frequency
procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  Timer1.Enabled := false;
  Timer1.Interval := TrackBar1.Position*1000;
  Timer1.Enabled := true;
end;

procedure TForm1.TrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Label3.Caption := format('%d sec', [TrackBar1.Position]);
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
   if Visible then begin // Application is visible, so minimize it to TrayIcon
		Application.Minimize; // This is to minimize the whole application
   end else begin // Application is not visible, so show it
      Show; // This is to show it from taskbar
      Application.Restore; // This is to restore the whole application
      WindowState:=wsNormal;
      SetFocus;
   end;
end;


end.

