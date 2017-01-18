unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LSControls, LSGrids, RxMDI, KGrids, JvXPBar, DateUtils,
  TplColorPanelUnit, TplImageButtonUnit, cySkinArea, db, dbf, sqldb, Forms,
  Controls, Graphics, Dialogs, ComCtrls, IniPropStorage, StdCtrls, EditBtn,
  ExtCtrls, Buttons, Grids, PopupNotifier, ExtDlgs, DBGrids, DbCtrls, Types, Math,
  LazLogger, dblo, dbhi;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    Dbf1: TDbf;
    Dbf1CIRHI: TFloatField;
    Dbf1CIRLO: TFloatField;
    Dbf1CIRSTD: TFloatField;
    Dbf1FVHI: TFloatField;
    Dbf1FVLO: TFloatField;
    Dbf1FVSTD: TFloatField;
    Dbf1HDHI: TFloatField;
    Dbf1HDLO: TFloatField;
    Dbf1HDSTD: TFloatField;
    Dbf1ITEMS: TLongintField;
    Dbf1LENHI: TFloatField;
    Dbf1LENLO: TFloatField;
    Dbf1LENSTD: TFloatField;
    Dbf1OVALHI: TFloatField;
    Dbf1OVALLO: TFloatField;
    Dbf1OVALSTD: TFloatField;
    Dbf1PDCHI: TLongintField;
    Dbf1PDCLO: TLongintField;
    Dbf1PDCSTD: TLongintField;
    Dbf1PDOHI: TLongintField;
    Dbf1PDOLO: TLongintField;
    Dbf1PDOMMWGHI: TLongintField;
    Dbf1PDOMMWGLO: TLongintField;
    Dbf1PDOMMWGSTD: TLongintField;
    Dbf1PDOSTD: TLongintField;
    Dbf1PH: TStringField;
    Dbf1PVHI: TFloatField;
    Dbf1PVLO: TFloatField;
    Dbf1PVSTD: TFloatField;
    Dbf1VHI: TFloatField;
    Dbf1VLO: TFloatField;
    Dbf1VSTD: TFloatField;
    Dbf1WGHI: TFloatField;
    Dbf1WGLO: TFloatField;
    Dbf1WGSTD: TFloatField;
    Dbf2: TDbf;
    Dbf2BC: TStringField;
    Dbf2CIRBAD: TLongintField;
    Dbf2CIRCPK: TFloatField;
    Dbf2CIRCV: TFloatField;
    Dbf2CIRMAX: TFloatField;
    Dbf2CIRMEAN: TFloatField;
    Dbf2CIRMIN: TFloatField;
    Dbf2CIRSD: TFloatField;
    Dbf2DATE: TDateField;
    Dbf2FVBAD: TLongintField;
    Dbf2FVCPK: TFloatField;
    Dbf2FVCV: TFloatField;
    Dbf2FVMAX: TFloatField;
    Dbf2FVMEAN: TFloatField;
    Dbf2FVMIN: TFloatField;
    Dbf2FVSD: TFloatField;
    Dbf2HDBAD: TLongintField;
    Dbf2HDCPK: TFloatField;
    Dbf2HDCV: TFloatField;
    Dbf2HDMAX: TFloatField;
    Dbf2HDMEAN: TFloatField;
    Dbf2HDMIN: TFloatField;
    Dbf2HDSD: TFloatField;
    Dbf2ITEMS: TLongintField;
    Dbf2JTH: TStringField;
    Dbf2LENBAD: TLongintField;
    Dbf2LENCPK: TFloatField;
    Dbf2LENCV: TFloatField;
    Dbf2LENMAX: TFloatField;
    Dbf2LENMEAN: TFloatField;
    Dbf2LENMIN: TFloatField;
    Dbf2LENSD: TFloatField;
    Dbf2NAME: TStringField;
    Dbf2NUM: TLongintField;
    Dbf2OVALBAD: TLongintField;
    Dbf2OVALCPK: TFloatField;
    Dbf2OVALCV: TFloatField;
    Dbf2OVALMAX: TFloatField;
    Dbf2OVALMEAN: TFloatField;
    Dbf2OVALMIN: TFloatField;
    Dbf2OVALSD: TFloatField;
    Dbf2PDCBAD: TLongintField;
    Dbf2PDCCPK: TFloatField;
    Dbf2PDCCV: TFloatField;
    Dbf2PDCMAX: TLongintField;
    Dbf2PDCMEAN: TLongintField;
    Dbf2PDCMIN: TLongintField;
    Dbf2PDCSD: TLongintField;
    Dbf2PDOBAD: TLongintField;
    Dbf2PDOCPK: TFloatField;
    Dbf2PDOCV: TFloatField;
    Dbf2PDOMAX: TLongintField;
    Dbf2PDOMEAN: TLongintField;
    Dbf2PDOMIN: TLongintField;
    Dbf2PDOMMWGCPK: TFloatField;
    Dbf2PDOMMWGCV: TFloatField;
    Dbf2PDOMMWGMAX: TLongintField;
    Dbf2PDOMMWGMEA: TLongintField;
    Dbf2PDOMMWGMIN: TLongintField;
    Dbf2PDOMMWGSD: TLongintField;
    Dbf2PDOSD: TLongintField;
    Dbf2PH: TStringField;
    Dbf2PVBAD: TLongintField;
    Dbf2PVCPK: TFloatField;
    Dbf2PVCV: TFloatField;
    Dbf2PVMAX: TFloatField;
    Dbf2PVMEAN: TFloatField;
    Dbf2PVMIN: TFloatField;
    Dbf2PVSD: TFloatField;
    Dbf2TIME: TStringField;
    Dbf2VBAD: TLongintField;
    Dbf2VCPK: TFloatField;
    Dbf2VCV: TFloatField;
    Dbf2VMAX: TFloatField;
    Dbf2VMEAN: TFloatField;
    Dbf2VMIN: TFloatField;
    Dbf2VSD: TFloatField;
    Dbf2WGBAD: TLongintField;
    Dbf2WGCPK: TFloatField;
    Dbf2WGCV: TFloatField;
    Dbf2WGMAX: TFloatField;
    Dbf2WGMEAN: TFloatField;
    Dbf2WGMIN: TFloatField;
    Dbf2WGSD: TFloatField;
    Dbf2YPBH: TStringField;
    Dbf3: TDbf;
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
    procedure DirectoryEdit1Change(Sender: TObject);
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
    function ConvertDate(s: TDateTime): string;
    function GetNr(txt: string): string;
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
function TForm1.ConvertDate(s: TDateTime): string;
begin
   Result := FormatDateTime('YYYY-MM-DD', s);
end;

// return a string with the first numerical digits of a string
function TForm1.GetNr(txt: string): string;
var
   nr: string;
   kar: Char;
begin
   nr := '';
	for kar in txt do begin
		if (Ord(kar) >= Ord('0')) and (Ord(kar) <= Ord('9')) then
  	   	nr := nr + string(kar);
		if kar = ' ' then
      	break;	// skip the remainder of the string
	end;
   Result := nr;
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

   StringGrid1.RowCount := 1;
   StringGrid1.ColCount := ctdata2.numfields+1;
   for i := 0 to ctdata2.NumFields-1 do
      StringGrid1.Cells[i, 0] := ctdata2.fielddev[i].name;

   r := 1;
   WHILE r <= ctdata2.NumRecs DO BEGIN
      if ctdata2.GetField('YPBH', r) = YPBH then begin
      	StringGrid1.RowCount := StringGrid1.RowCount+1;
         FOR i := 0 TO ctdata2.NumFields-1 DO
				StringGrid1.Cells[i, StringGrid1.RowCount-1] := ctdata2.GetFieldNr(i, r);
      end;
		r := r+1;
   END;
   DebugLn(inttostr(StringGrid1.RowCount));
end;

// temporarily disable updates (10min) to browse through the data
procedure TForm1.Button1Click(Sender: TObject);
var
   i, r: integer;
begin
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
end;

// reads the specifications from the laboratory station and sends it to the server (adds it, doesn't replace)
procedure TForm1.Button2Click(Sender: TObject);
var
   prodnr, MeasFormat: string;
begin
	Timer1.Enabled := false;
   Timer2.Enabled := false;
   Dbf1.Open;
   DataModule1.Connect(Sender);		// connect to server

   if DataModule1.MySQL56Connection1.Connected then begin
   	with DataModule1.SQLQuery1 do begin
			Dbf1.First;
			while not Dbf1.Eof do begin
				prodnr := GetNr(DataSource1.Dataset.FieldByName('PH').AsString);
				if (prodnr <> '') then begin	// sla alleen produkten met nummer op
					with DataSource1.Dataset do begin
						MeasFormat := ':PH, :WGLO, :WGSTD, :WGHI, :CIRLO, :CIRSTD, :CIRHI, :LENLO, :LENSTD, :LENHI, '+
											':PDOLO, :PDOSTD, :PDOHI, :VLO, :VSTD, :VHI, :HDLO, :HDSTD, :HDHI';
                  SQL.Text:='INSERT INTO products_finished (`name`, `weight_min`, `weight`, `weight_max`, `circ_min`, `circ`, `circ_max`, '+
										'`len_min`, `len`, `len_max`, `pd_min`, `pd`, `pd_max`, `vent_min`, `vent`, `vent_max`,'+
										'`hd_min`, `hd`, `hd_max`) VALUES ('+MeasFormat+')';
                  Params.ParamByName('PH').AsString := prodnr;
                  Params.ParamByName('WGLO').AsString := FieldByName('WGLO').AsString;
                  Params.ParamByName('WGSTD').AsString := FieldByName('WGSTD').AsString;
                  Params.ParamByName('WGHI').AsString := FieldByName('WGHI').AsString;
                  Params.ParamByName('CIRLO').AsString := FieldByName('CIRLO').AsString;
                  Params.ParamByName('CIRSTD').AsString := FieldByName('CIRSTD').AsString;
                  Params.ParamByName('CIRHI').AsString := FieldByName('CIRHI').AsString;
                  Params.ParamByName('LENLO').AsString := FieldByName('LENLO').AsString;
                  Params.ParamByName('LENSTD').AsString := FieldByName('LENSTD').AsString;
                  Params.ParamByName('LENHI').AsString := FieldByName('LENHI').AsString;
                  Params.ParamByName('PDOLO').AsString := FieldByName('PDOLO').AsString;
                  Params.ParamByName('PDOSTD').AsString := FieldByName('PDOSTD').AsString;
                  Params.ParamByName('PDOHI').AsString := FieldByName('PDOHI').AsString;
                  Params.ParamByName('VLO').AsString := FieldByName('VLO').AsString;
                  Params.ParamByName('VSTD').AsString := FieldByName('VSTD').AsString;
                  Params.ParamByName('VHI').AsString := FieldByName('VHI').AsString;
                  Params.ParamByName('HDLO').AsString := FieldByName('HDLO').AsString;
                  Params.ParamByName('HDSTD').AsString := FieldByName('HDSTD').AsString;
                  Params.ParamByName('HDHI').AsString := FieldByName('HDHI').AsString;
               end;
               ExecSQL;
     	         DataModule1.SQLTransaction1.Commit;
            end;
            Dbf1.Next;
         end;
      end;
   end;

   DataModule1.DisConnect(Sender);		// disconnect to server
   Dbf1.Close;
	Timer1.Enabled := true;
   Timer2.Enabled := true;
end;

// reads the specifications from the workfloor station and sends it to the server (adds it, doesn't replace)
procedure TForm1.Button3Click(Sender: TObject);
var
   prodnr, MeasFormat: string;
begin
	Timer1.Enabled := false;
   Timer2.Enabled := false;
   Dbf1.Open;
   DataModule1.Connect(Sender);		// connect to server

   if DataModule1.MySQL56Connection1.Connected then begin
   	with DataModule1.SQLQuery1 do begin
			Dbf1.First;
			while not Dbf1.Eof do begin
				prodnr := GetNr(DataSource1.Dataset.FieldByName('PH').AsString);
				if (prodnr <> '') then begin	// sla alleen produkten met nummer op
					with DataSource1.Dataset do begin
						MeasFormat := ':PH, :WGLO, :WGSTD, :WGHI, :CIRLO, :CIRSTD, :CIRHI, :LENLO, :LENSTD, :LENHI, '+
											':PDOLO, :PDOSTD, :PDOHI, :VLO, :VSTD, :VHI, :HDLO, :HDSTD, :HDHI';
                  SQL.Text:='INSERT INTO products_workfloor (`name`, `weight_min`, `weight`, `weight_max`, `circ_min`, `circ`, `circ_max`, '+
										'`len_min`, `len`, `len_max`, `pd_min`, `pd`, `pd_max`, `vent_min`, `vent`, `vent_max`,'+
										'`hd_min`, `hd`, `hd_max`) VALUES ('+MeasFormat+')';
                  Params.ParamByName('PH').AsString := prodnr;
                  Params.ParamByName('WGLO').AsString := FieldByName('WGLO').AsString;
                  Params.ParamByName('WGSTD').AsString := FieldByName('WGSTD').AsString;
                  Params.ParamByName('WGHI').AsString := FieldByName('WGHI').AsString;
                  Params.ParamByName('CIRLO').AsString := FieldByName('CIRLO').AsString;
                  Params.ParamByName('CIRSTD').AsString := FieldByName('CIRSTD').AsString;
                  Params.ParamByName('CIRHI').AsString := FieldByName('CIRHI').AsString;
                  Params.ParamByName('LENLO').AsString := FieldByName('LENLO').AsString;
                  Params.ParamByName('LENSTD').AsString := FieldByName('LENSTD').AsString;
                  Params.ParamByName('LENHI').AsString := FieldByName('LENHI').AsString;
                  Params.ParamByName('PDOLO').AsString := FieldByName('PDOLO').AsString;
                  Params.ParamByName('PDOSTD').AsString := FieldByName('PDOSTD').AsString;
                  Params.ParamByName('PDOHI').AsString := FieldByName('PDOHI').AsString;
                  Params.ParamByName('VLO').AsString := FieldByName('VLO').AsString;
                  Params.ParamByName('VSTD').AsString := FieldByName('VSTD').AsString;
                  Params.ParamByName('VHI').AsString := FieldByName('VHI').AsString;
                  Params.ParamByName('HDLO').AsString := FieldByName('HDLO').AsString;
                  Params.ParamByName('HDSTD').AsString := FieldByName('HDSTD').AsString;
                  Params.ParamByName('HDHI').AsString := FieldByName('HDHI').AsString;
               end;
               ExecSQL;
     	         DataModule1.SQLTransaction1.Commit;
            end;
            Dbf1.Next;
         end;
      end;
   end;

   DataModule1.DisConnect(Sender);		// disconnect to server
   Dbf1.Close;
	Timer1.Enabled := true;
   Timer2.Enabled := true;
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

end;

// set the database location for the dbase tables
procedure TForm1.DirectoryEdit1Change(Sender: TObject);
var
   pad: string;
begin
	pad := DirectoryEdit1.Text;

   // open the dbase tables
   //cfg.Open(DirectoryEdit1.Text);
   //ctdata1.Open(pad);
   //ctdata2.Open(pad);
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
   prodnr, YPBH, nr, MeasFormat, MS, row: string;
	S : TDateTime;
	fs: int64;
   spec_hd, spec_circ, spec_len, spec_pd, spec_vent, spec_weight: string;
   n1, n2: single;
   spec_name, spec_nr, spec_weight_min, spec_weight_max, spec_circ_min, spec_circ_max, spec_len_min, spec_len_max: string;
   spec_pd_min, spec_pd_max, spec_hd_min, spec_hd_max, spec_vent_min, spec_vent_max: string;
begin
   if (teller = 0) then
	   teller := 10;        // process a maximum of 10 new records

   // remove the trayicon to prevent closing the program
//   TrayIcon1.Visible:= false;

   // sync the specifications with the server
   DebugLn('connecting');
   DataModule1.Connect(Sender);		// connect to server
   DebugLn('after connect');
   if DataModule1.MySQL56Connection1.Connected then begin
   	with DataModule1.SQLQuery1 do begin
         DebugLn('send query');
         Close;
   		SQL.Text:='SELECT force_update FROM stations WHERE name='+Edit2.Text;		// check if there is a force update specs on the server
         Open;
         if (FieldByName('force_update').AsInteger > 0) then begin
            //Application.MessageBox('force update', Pchar(Edit2.Text));

          	Close;
   			SQL.Text:='CHECKSUM TABLE products_finished';		// get the checksum of the spec-table from the server
   			Open;
            Edit3.Text := FieldByName('Checksum').AsString;		// store the new checksum

				Dbf1.Close;
				Dbf1.Exclusive := true;
				Dbf1.Open;	// open de specs on the station

            Close;
	   		SQL.Text:='SELECT * FROM products_finished WHERE DATE(end) = "3000-01-01" ';		// select the latest specs from the server
   			Open;

            while (not Eof) do begin
               // get all specs from the server
               spec_name := FieldByName('name').AsString;
               spec_nr := GetNr(FieldByName('name').AsString);  // get the product number (chinese characters can not be stored)
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

               // find the corresponding spec on the station (only use the number because utf is not supported in tdbf)

               // update this spec or add the new spec
               Dbf1.FilterOptions := [foCaseInsensitive];
               Dbf1.Filter := 'PH="' + spec_nr + ' *"';
               Dbf1.Filtered := true;
               Dbf1.First;

					if (not Dbf1.Eof) then begin
               	// update the station
                  Dbf1.Edit;
                  Dbf1.FieldByName('WGSTD').Value := spec_weight;
                  Dbf1.FieldByName('WGLO').Value := spec_weight_min;
						Dbf1.FieldByName('WGHI').Value := spec_weight_max;
                  Dbf1.FieldByName('CIRSTD').Value := spec_circ;
                  Dbf1.FieldByName('CIRLO').Value := spec_circ_min;
						Dbf1.FieldByName('CIRHI').Value := spec_circ_max;
                  Dbf1.FieldByName('LENSTD').Value := spec_len;
                  Dbf1.FieldByName('LENLO').Value := spec_len_min;
						Dbf1.FieldByName('LENHI').Value := spec_len_max;
                  Dbf1.FieldByName('PDOSTD').Value := spec_pd;
                  Dbf1.FieldByName('PDOLO').Value := spec_pd_min;
						Dbf1.FieldByName('PDOHI').Value := spec_pd_max;
                  Dbf1.FieldByName('VSTD').Value := spec_vent;
                  Dbf1.FieldByName('VLO').Value := spec_vent_min;
						Dbf1.FieldByName('VHI').Value := spec_vent_max;
                  Dbf1.FieldByName('HDSTD').Value := spec_hd;
                  Dbf1.FieldByName('HDLO').Value := spec_hd_min;
						Dbf1.FieldByName('HDHI').Value := spec_hd_max;
                  Dbf1.Post;
               end else begin
               	// adds a new spec on the station (DOES NOT WRITE UTF8 CHARACTERS TO DBF)
                  //Application.MessageBox(Pchar(spec_name), 'NOT FOUND');
                  Dbf1.Insert;
                  Dbf1.FieldByName('PH').Value := spec_nr+' ...';	// the name is utf8 and must later be manually filled on the stations
                  Dbf1.FieldByName('WGSTD').Value := spec_weight;
                  Dbf1.FieldByName('WGLO').Value := spec_weight_min;
						Dbf1.FieldByName('WGHI').Value := spec_weight_max;
                  Dbf1.FieldByName('CIRSTD').Value := spec_circ;
                  Dbf1.FieldByName('CIRLO').Value := spec_circ_min;
						Dbf1.FieldByName('CIRHI').Value := spec_circ_max;
                  Dbf1.FieldByName('LENSTD').Value := spec_len;
                  Dbf1.FieldByName('LENLO').Value := spec_len_min;
						Dbf1.FieldByName('LENHI').Value := spec_len_max;
                  Dbf1.FieldByName('PDOSTD').Value := spec_pd;
                  Dbf1.FieldByName('PDOLO').Value := spec_pd_min;
						Dbf1.FieldByName('PDOHI').Value := spec_pd_max;
                  Dbf1.FieldByName('VSTD').Value := spec_vent;
                  Dbf1.FieldByName('VLO').Value := spec_vent_min;
						Dbf1.FieldByName('VHI').Value := spec_vent_max;
                  Dbf1.FieldByName('HDSTD').Value := spec_hd;
                  Dbf1.FieldByName('HDLO').Value := spec_hd_min;
						Dbf1.FieldByName('HDHI').Value := spec_hd_max;
                  Dbf1.Post;
               end;
               Next;
            end;
            Dbf1.Close;
            Dbf1.Exclusive := false;

            SQL.Text:='UPDATE stations SET force_update=0, date=NOW() WHERE name='+Edit2.Text;
            ExecSQL;
	         DataModule1.SQLTransaction1.Commit;
         end;

   		Close;
   		SQL.Text:='CHECKSUM TABLE products_finished';		// get the checksum of the spec-table from the server
   		Open;

         DebugLn( 'Checksum Specs = '+FieldByName('Checksum').AsString);
         if (Edit3.Text <> FieldByName('Checksum').AsString) then begin
            Dbf1.Close;
            Dbf1.Exclusive := true;
            Dbf1.Open;	// open de specs on the station

            Edit3.Text := FieldByName('Checksum').AsString;		// store the new checksum
            Close;
	   		SQL.Text:='SELECT * FROM products_finished WHERE DATE(end) = "3000-01-01" ';		// select the latest specs from the server
   			Open;

            while (not Eof) do begin
               // get all specs from the server
               spec_name := FieldByName('name').AsString;
               spec_nr := GetNr(FieldByName('name').AsString);  // get the product number (chinese characters can not be stored)
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

               // find the corresponding spec on the station (only use the number because utf is not supported in tdbf)

               // update this spec or add the new spec
               Dbf1.FilterOptions := [foCaseInsensitive];
               Dbf1.Filter := 'PH="' + spec_nr + ' *"';
               Dbf1.Filtered := true;
               Dbf1.First;
					if (not Dbf1.Eof) then begin
               	// update the station
                  //Application.MessageBox(Pchar(spec_weight), 'FOUND');
                  Dbf1.Edit;
                  Dbf1.FieldByName('WGSTD').Value := spec_weight;
                  Dbf1.FieldByName('WGLO').Value := spec_weight_min;
						Dbf1.FieldByName('WGHI').Value := spec_weight_max;
                  Dbf1.FieldByName('CIRSTD').Value := spec_circ;
                  Dbf1.FieldByName('CIRLO').Value := spec_circ_min;
						Dbf1.FieldByName('CIRHI').Value := spec_circ_max;
                  Dbf1.FieldByName('LENSTD').Value := spec_len;
                  Dbf1.FieldByName('LENLO').Value := spec_len_min;
						Dbf1.FieldByName('LENHI').Value := spec_len_max;
                  Dbf1.FieldByName('PDOSTD').Value := spec_pd;
                  Dbf1.FieldByName('PDOLO').Value := spec_pd_min;
						Dbf1.FieldByName('PDOHI').Value := spec_pd_max;
                  Dbf1.FieldByName('VSTD').Value := spec_vent;
                  Dbf1.FieldByName('VLO').Value := spec_vent_min;
						Dbf1.FieldByName('VHI').Value := spec_vent_max;
                  Dbf1.FieldByName('HDSTD').Value := spec_hd;
                  Dbf1.FieldByName('HDLO').Value := spec_hd_min;
						Dbf1.FieldByName('HDHI').Value := spec_hd_max;
                  Dbf1.Post;
               end else begin
               	// adds a new spec on the station (DOES NOT WRITE UTF8 CHARACTERS TO DBF)
                  //Application.MessageBox(Pchar(spec_name), 'NOT FOUND');
                  Dbf1.Insert;
                  Dbf1.FieldByName('PH').Value := spec_nr+' ...';	// the name is utf8 and must later be manually filled on the stations
                  Dbf1.FieldByName('WGSTD').Value := spec_weight;
                  Dbf1.FieldByName('WGLO').Value := spec_weight_min;
						Dbf1.FieldByName('WGHI').Value := spec_weight_max;
                  Dbf1.FieldByName('CIRSTD').Value := spec_circ;
                  Dbf1.FieldByName('CIRLO').Value := spec_circ_min;
						Dbf1.FieldByName('CIRHI').Value := spec_circ_max;
                  Dbf1.FieldByName('LENSTD').Value := spec_len;
                  Dbf1.FieldByName('LENLO').Value := spec_len_min;
						Dbf1.FieldByName('LENHI').Value := spec_len_max;
                  Dbf1.FieldByName('PDOSTD').Value := spec_pd;
                  Dbf1.FieldByName('PDOLO').Value := spec_pd_min;
						Dbf1.FieldByName('PDOHI').Value := spec_pd_max;
                  Dbf1.FieldByName('VSTD').Value := spec_vent;
                  Dbf1.FieldByName('VLO').Value := spec_vent_min;
						Dbf1.FieldByName('VHI').Value := spec_vent_max;
                  Dbf1.FieldByName('HDSTD').Value := spec_hd;
                  Dbf1.FieldByName('HDLO').Value := spec_hd_min;
						Dbf1.FieldByName('HDHI').Value := spec_hd_max;
                  Dbf1.Post;
               end;
               Next;
            end;
            Dbf1.Close;
            Dbf1.Exclusive := false;

            SQL.Text:='UPDATE stations SET force_update=0, date=NOW() WHERE name='+Edit2.Text;
            ExecSQL;
	         DataModule1.SQLTransaction1.Commit;
         end;
      end;
   end;

   fs:=FileSize(IncludeTrailingPathDelimiter(DirectoryEdit1.Text)+'CtData1.DBF');

   DebugLn('size database station = '+dbgs(fs));
   DebugLn('last size = '+dbgs(LastSize));
   DebugLn('Finished = '+dbgs(Finished));
	if ((fs <> LastSize) OR NOT Finished) then begin
      DebugLn('start updating server');
      Form1.Caption := 'Last Update at: '+DateTimeToStr(Now);
      Form1.Caption := intToStr(fs);
   	LastSize := fs;
     	Timer1.Enabled := false;
   	DataModule1.Connect(Sender);		// connect to server
      Dbf3.Open;								// open the tables on the measuring station (get the latest data)
      Dbf2.Open;
      Dbf1.Open;

      if DataModule1.MySQL56Connection1.Connected then begin
      	with DataModule1.SQLQuery1 do begin
            DebugLn('teller = '+dbgs(teller));
       		Dbf2.Last;
            while (not Dbf2.Bof AND (teller > 0)) do begin
    				YPBH := Edit2.Caption+'-'+DataSource2.Dataset.FieldByName('YPBH').AsString;

         		Close;
         		SQL.Text:='SELECT * FROM cigaret WHERE YPBH="'+YPBH+'"';		// check to see if the data is already stored
         		Open;

            	if (Eof) then begin 	// measurement not found
               	prodnr := GetNr(DataSource2.Dataset.FieldByName('PH').AsString);
                  DebugLn('productnr = '+prodnr);
               	if (prodnr <> '') then begin	// sla alleen produkten met nummer op
                     //Application.MessageBox(Pchar(row), '');
                     teller := teller-1;

                     // find product specifications
                     Close;
                     SQL.Text:='SELECT * FROM products_finished WHERE id='+prodnr;
                     Open;
                     spec_hd := DataModule1.SQLQuery1.FieldByName('hd').AsString;
                     spec_circ := DataModule1.SQLQuery1.FieldByName('circ').AsString;
                     spec_len := DataModule1.SQLQuery1.FieldByName('len').AsString;
                     spec_pd := DataModule1.SQLQuery1.FieldByName('pd').AsString;
                     spec_vent := DataModule1.SQLQuery1.FieldByName('vent').AsString;
                     spec_weight := DataModule1.SQLQuery1.FieldByName('weight').AsString;

                  	with DataSource2.Dataset do begin
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
      	               Params.ParamByName('DATE').AsString := format('%s', [(ConvertDate(FieldByName('DATE').AsDateTime ) +' '+ FieldByName('TIME').AsString)]);
                        Params.ParamByName('SHIFT').AsString := GetShift(FieldByName('TIME').AsString);
                        Params.ParamByName('ORIGIN').AsString := Edit2.Text;
         	            Params.ParamByName('PH').AsString := format('%s', [prodnr]);
            	         Params.ParamByName('ITEMS').AsString := format('%s', [(FieldByName('ITEMS').AsString)]);
               	      Params.ParamByName('JTH').AsString := format('%s', [(FieldByName('JTH').AsString)]);
   							Params.ParamByName('HDMAX').AsString := FieldByName('HDMAX').AsString;
   							Params.ParamByName('HDMIN').AsString := FieldByName('HDMIN').AsString;
   	                  Params.ParamByName('HDMEAN').AsString :=  FieldByName('HDMEAN').AsString;
      	               Params.ParamByName('HDSD').AsString := FieldByName('HDSD').AsString;
         	            Params.ParamByName('HDCV').AsString := FieldByName('HDCV').AsString;
            	         Params.ParamByName('HDCPK').AsString := FieldByName('HDCPK').AsString;
               	      Params.ParamByName('HDBAD').AsString := FieldByName('HDBAD').AsString;
                        if (Trim(FieldByName('HDMEAN').AsString) <> '') then begin
                           n1 := GetFloat(FieldByName('HDMEAN').AsString);
                           n2 := GetFloat(spec_hd);
	                        Params.ParamByName('HDDIV').AsString := FloatToStr(  Round(100*Abs(n1-n2))/100 );
                        end else
                           Params.ParamByName('HDDIV').AsString := '-';

   							Params.ParamByName('CIRMAX').AsString := FieldByName('CIRMAX').AsString;
                     	Params.ParamByName('CIRMIN').AsString := FieldByName('CIRMIN').AsString;
   	                  Params.ParamByName('CIRMEAN').AsString := FieldByName('CIRMEAN').AsString;
      	               Params.ParamByName('CIRSD').AsString := FieldByName('CIRSD').AsString;
         	            Params.ParamByName('CIRCV').AsString := FieldByName('CIRCV').AsString;
            	         Params.ParamByName('CIRCPK').AsString := FieldByName('CIRCPK').AsString;
               	      Params.ParamByName('CIRBAD').AsString := FieldByName('CIRBAD').AsString;
                        if (Trim(FieldByName('CIRMEAN').AsString) <> '') then begin
                           n1 := GetFloat(FieldByName('CIRMEAN').AsString);
                           n2 := GetFloat(spec_circ);
	                        Params.ParamByName('CIRDIV').AsString := FloatToStr( Round(100*Abs(n1-n2))/100 );
                        end else
                           Params.ParamByName('CIRDIV').AsString := '-';

                  	   Params.ParamByName('LENMAX').AsString := FieldByName('LENMAX').AsString;
                     	Params.ParamByName('LENMIN').AsString := FieldByName('LENMIN').AsString;
   	                  Params.ParamByName('LENMEAN').AsString := FieldByName('LENMEAN').AsString;
      	               Params.ParamByName('LENSD').AsString := FieldByName('LENSD').AsString;
         	            Params.ParamByName('LENCV').AsString := FieldByName('LENCV').AsString;
            	         Params.ParamByName('LENCPK').AsString := FieldByName('LENCPK').AsString;
               	      Params.ParamByName('LENBAD').AsString := FieldByName('LENBAD').AsString;
                        if (Trim(FieldByName('LENMEAN').AsString) <> '') then begin
                           n1 := GetFloat(FieldByName('LENMEAN').AsString);
                           n2 := GetFloat(spec_len);
	                        Params.ParamByName('LENDIV').AsString := FloatToStr( Round(100*Abs(n1-n2))/100 );
                        end else
                           Params.ParamByName('LENDIV').AsString := '-';

                  	   Params.ParamByName('PDOMAX').AsString := FieldByName('PDOMAX').AsString;
                     	Params.ParamByName('PDOMIN').AsString := FieldByName('PDOMIN').AsString;
   	                  Params.ParamByName('PDOMEAN').AsString := FieldByName('PDOMEAN').AsString;
      	               Params.ParamByName('PDOSD').AsString := FieldByName('PDOSD').AsString;
         	            Params.ParamByName('PDOCV').AsString := FieldByName('PDOCV').AsString;
            	         Params.ParamByName('PDOCPK').AsString := FieldByName('PDOCPK').AsString;
               	      Params.ParamByName('PDOBAD').AsString := FieldByName('PDOBAD').AsString;
                        if (Trim(FieldByName('PDOMEAN').AsString) <> '') then begin
                           n1 := GetFloat(FieldByName('PDOMEAN').AsString);
                           n2 := GetFloat(spec_pd);
	                        Params.ParamByName('PDODIV').AsString := FloatToStr( Round(100*Abs(n1-n2))/100 );
                        end else
                           Params.ParamByName('PDODIV').AsString := '-';

                  	   Params.ParamByName('VMAX').AsString := FieldByName('VMAX').AsString;
                     	Params.ParamByName('VMIN').AsString := FieldByName('VMIN').AsString;
   	                  Params.ParamByName('VMEAN').AsString := FieldByName('VMEAN').AsString;
      	               Params.ParamByName('VSD').AsString := FieldByName('VSD').AsString;
         	            Params.ParamByName('VCV').AsString := FieldByName('VCV').AsString;
            	         Params.ParamByName('VCPK').AsString := FieldByName('VCPK').AsString;
               	      Params.ParamByName('VBAD').AsString := FieldByName('VBAD').AsString;
                        if (Trim(FieldByName('VMEAN').AsString) <> '') then begin
                           n1 := GetFloat(FieldByName('VMEAN').AsString);
                           n2 := GetFloat(spec_vent);
	                        Params.ParamByName('VDIV').AsString := FloatToStr( Round(100*Abs(n1-n2))/100 );
                        end else
                           Params.ParamByName('VDIV').AsString := '-';

                  	   Params.ParamByName('WGMAX').AsString := FieldByName('WGMAX').AsString;
                     	Params.ParamByName('WGMIN').AsString := FieldByName('WGMIN').AsString;
   	                  Params.ParamByName('WGMEAN').AsString := FieldByName('WGMEAN').AsString;
      	               Params.ParamByName('WGSD').AsString := FieldByName('WGSD').AsString;
         	            Params.ParamByName('WGCV').AsString := FieldByName('WGCV').AsString;
            	         Params.ParamByName('WGCPK').AsString := FieldByName('WGCPK').AsString;
               	      Params.ParamByName('WGBAD').AsString := FieldByName('WGBAD').AsString;
                        if (Trim(FieldByName('WGMEAN').AsString) <> '') then begin
                           n1 := GetFloat(FieldByName('WGMEAN').AsString);
                           n2 := GetFloat(spec_weight);
	                        Params.ParamByName('WGDIV').AsString := FloatToStr( Round(100*Abs(n1-n2))/100 );
                        end else
                           Params.ParamByName('WGDIV').AsString := '-';

                  	   Params.ParamByName('YPBH').AsString := YPBH;
   	               end;
      	            ExecSQL;
         	         DataModule1.SQLTransaction1.Commit;
            	   end;
   	         end;

               // store the stick numbers that are already stored
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

   				Dbf3.First;   // loop de details af
   				while not Dbf3.Eof do begin
   					if (Edit2.Caption+'-'+DataSource3.Dataset.FieldByName('YPBH').AsString) = YPBH then begin  // check only the details of the current master
   						nr := DataSource3.Dataset.FieldByName('NO').AsString;
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
               	      Params.ParamByName('VALUE').AsString := DataSource3.Dataset.FieldByName('WG').AsString;
                        Params.ParamByName('row').AsString := row;
                        ExecSQL;
   	      	         DataModule1.SQLTransaction1.Commit;

                        SQL.Text:='INSERT INTO circumference(`stick`, `master`, `value`, `row`) VALUES ('+MeasFormat+')';
                        Params.ParamByName('STICK').AsString := nr;
            	         Params.ParamByName('MASTER').AsString := YPBH;
               	      Params.ParamByName('VALUE').AsString := DataSource3.Dataset.FieldByName('CIR').AsString;
                        Params.ParamByName('row').AsString := row;
                        ExecSQL;
   	      	         DataModule1.SQLTransaction1.Commit;

                        SQL.Text:='INSERT INTO length(`stick`, `master`, `value`, `row`) VALUES ('+MeasFormat+')';
                        Params.ParamByName('STICK').AsString := nr;
            	         Params.ParamByName('MASTER').AsString := YPBH;
               	      Params.ParamByName('VALUE').AsString := DataSource3.Dataset.FieldByName('LEN').AsString;
                        Params.ParamByName('row').AsString := row;
                        ExecSQL;
   	      	         DataModule1.SQLTransaction1.Commit;

                        SQL.Text:='INSERT INTO pd (`stick`, `master`, `value`, `row`) VALUES ('+MeasFormat+')';
                        Params.ParamByName('STICK').AsString := nr;
            	         Params.ParamByName('MASTER').AsString := YPBH;
               	      Params.ParamByName('VALUE').AsString := DataSource3.Dataset.FieldByName('PDO').AsString;
                        Params.ParamByName('row').AsString := row;
                        ExecSQL;
   	      	         DataModule1.SQLTransaction1.Commit;

                        SQL.Text:='INSERT INTO ventilation(`stick`, `master`, `value`, `row`) VALUES ('+MeasFormat+')';
                        Params.ParamByName('STICK').AsString := nr;
            	         Params.ParamByName('MASTER').AsString := YPBH;
               	      Params.ParamByName('VALUE').AsString := DataSource3.Dataset.FieldByName('V').AsString;
                        Params.ParamByName('row').AsString := row;
                        ExecSQL;
   	      	         DataModule1.SQLTransaction1.Commit;

                        SQL.Text:='INSERT INTO hardness(`stick`, `master`, `value`, `row`) VALUES ('+MeasFormat+')';
                        Params.ParamByName('STICK').AsString := nr;
            	         Params.ParamByName('MASTER').AsString := YPBH;
               	      Params.ParamByName('VALUE').AsString := DataSource3.Dataset.FieldByName('HD').AsString;
                        Params.ParamByName('row').AsString := row;
                        ExecSQL;
   	      	         DataModule1.SQLTransaction1.Commit;
                  	end;
   					end;
   					Dbf3.Next; 	// next detail record
   				end;
      	      Dbf2.Prior;	// prior master record
   	      end;
            Finished := Dbf2.Bof;
      	end;
      end;

      DataModule1.DisConnect(Sender);	// disconnect the server
   	Dbf3.Close; 					// close the dbase tables
   	Dbf2.Close;
   	Dbf1.Close;
     	Timer1.Enabled := true;

   end;

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

