unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, mysql56conn, FileUtil, LazLoggerDummy, Forms;

type

  { TDataModule1 }

  TDataModule1 = class(TDataModule)
    DataSource1: TDataSource;
    MySQL56Connection1: TMySQL56Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure DataModuleDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
		procedure Connect(Sender: TObject);
      procedure DisConnect(Sender: TObject);
  end;

var
  DataModule1: TDataModule1;

implementation

uses Unit1;

{$R *.lfm}

procedure TDataModule1.DataModuleDestroy(Sender: TObject);
begin
  MySQL56Connection1.Close;
end;

// connect to the main server
procedure TDataModule1.Connect(Sender: TObject);
begin
   with Form1 do begin
		MySQL56Connection1.HostName:=Edit1.Text;
	   StatusBar1.Hint:=Edit1.Text;
         DebugLn('connect()');
		try
			try
   	   	MySQL56Connection1.Close;
			 	MySQL56Connection1.Open;
         finally
				If MySQL56Connection1.Connected then
					StatusBar1.SimpleText:='connected'
            else
               StatusBar1.SimpleText:='NOT connected'
   		end;
	  	except
			StatusBar1.SimpleText:='Server not found';
		end;
	end;
end;

// disconnect the server
procedure TDataModule1.DisConnect(Sender: TObject);
begin
   with Form1 do begin
		MySQL56Connection1.HostName:=Edit1.Text;
	   StatusBar1.Hint:=Edit1.Text;
		try
			try
   	   	MySQL56Connection1.Close;
			finally
				If MySQL56Connection1.Connected then
					StatusBar1.SimpleText:='connected'
            else
               StatusBar1.SimpleText:='NOT connected'
   		end;
	  	except
			StatusBar1.SimpleText:='Server not found';
		end;
	end;
end;

end.

