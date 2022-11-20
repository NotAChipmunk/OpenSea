{
  Sea.Startup
    OpenSea main entry point

  This source code was NOT written by a chipmunk!
  Copyright © 2022 Sordie Aranka Solomon-Smith

  https://github.com/NotAChipmunk/OpenSea
}

unit Sea.Startup;

{$I Sea.Options.inc}

interface

procedure Stage1;
procedure Stage2;
procedure StageZ;

implementation

uses
  libNut.Strings,

  Sea.Globals,
  Sea.Memory,
  Sea.Hook,
  Sea.Version,
  Sea.Window,
  Sea.Console;

{$REGION 'Staging'}
procedure Stage1;
begin;
  Sea.Console.Stage1;
  Header('Stage 1');
  Sea.Memory.Stage1;
  Sea.Hook.Stage1;
  Sea.Version.Stage1;
  Sea.Window.Stage1;
end;

procedure Stage2;
begin
  header('Stage 2');
  Sea.Console.Stage2;
  Sea.Memory.Stage2;
  Sea.Hook.Stage2;
  Sea.Version.Stage2;
  Sea.Window.Stage2;
end;

procedure StageZ;
begin
  Writeln('Stage Z (cleanup)');
  Sea.Window.StageZ;
  Sea.Version.StageZ;
  Sea.Hook.StageZ;
  Sea.Memory.StageZ;
  Sea.Console.StageZ;
end;
{$ENDREGION}

initialization
  Stage1;

finalization
  StageZ;

end.
