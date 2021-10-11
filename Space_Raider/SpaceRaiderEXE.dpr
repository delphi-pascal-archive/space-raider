program SpaceRaiderEXE;

uses
  Forms,
  Main in 'Main.pas' {Form1};

{$R *.res}
{$R ImgResrc.res}
{$R Explosion.res}

begin
  Application.Initialize;
  Application.Title := 'Space Raider';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
