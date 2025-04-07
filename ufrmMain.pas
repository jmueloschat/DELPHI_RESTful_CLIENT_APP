unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls
  ,HttpSend
  ,IdHTTP
  ;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  loResquest: THttpSend;
  loJsonRequestStream: TStringStream;
  loJsonResponseStream: TStringStream;
  lsMessage: String;
begin
  loResquest := THttpSend.Create;
  loJsonRequestStream := TStringStream.Create( '{"fields":{"fieldString":"something 1/2"h20777","fieldInteger":98,"fieldBoolean":false,"fieldDouble":-72.5}', TEncoding.UTF8 );
  loJsonResponseStream := TStringStream.Create;

  try
    loResquest.Clear;
    loResquest.MimeType := 'application/json';
    loResquest.UserAgent := 'UserXPTO';

    loResquest.Timeout := 1000 * 60 * 30;
    loResquest.Headers.Insert(0, 'apikey: 0');
    loResquest.Headers.Insert(1, 'User-Agent: UserXPTO' );
    loResquest.Headers.Insert(2, 'Content-Type: application/json' );

    //if you have a Bearer token
    //loResquest.Headers.Insert(3, 'Authorization: Bearer ' +'xxx'+'yyyy'+'wwww');

    loResquest.UserName := 'your user login';
    loResquest.Password := 'your pw login';



    loResquest.Document.CopyFrom(loJsonRequestStream, 0);
    loResquest.HTTPMethod('POST', 'http://localhost:8050/api0001');

    lsMessage := EmptyStr;
    if loResquest.Document.Size > 0 then
    begin
      loResquest.Document.SaveToStream(loJsonResponseStream);
      lsMessage := loJsonResponseStream.DataString
    end;

    if loResquest.Resultcode <> 200 then
      ShowMessage(lsMessage);

  finally
    FreeAndNil( loResquest );
    FreeAndNil( loJsonRequestStream );
    FreeAndNil( loJsonResponseStream );
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  loRequest: TIdHTTP;
  lsMessage: String;
begin
  loRequest := TIdHTTP.Create(nil);
  try
    loRequest.ReadTimeout := 0;
    loRequest.Request.Accept := 'text/javascript';
    loRequest.Request.ContentType := 'application/json';
    loRequest.Request.Charset := 'utf-8';
    loRequest.ReadTimeout := 1000 * 60 * 5;
    lsMessage := loRequest.Put('http://localhost:8050/api0001', TStringStream.Create('{"fields":{"fieldString":"something 1/2"h20777","fieldInteger":98,"fieldBoolean":false,"fieldDouble":-72.5}', TEncoding.UTF8));

    if loRequest.ResponseCode <> 20 then
      ShowMessage(lsMessage);
  finally
    FreeAndNil( loRequest );
  end;
end;

end.
