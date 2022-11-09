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

uses
  WinAPI.Windows;

implementation

uses
  Sea.Globals,
  Sea.Memory,
  Sea.Version;

{$REGION 'Staging'}
procedure Stage1;
begin;
  Sea.Memory.Stage1;
  Sea.Version.Stage1;
end;

procedure StageZ;
begin
  Sea.Memory.Stage1;
  Sea.Version.StageZ;
end;
{$ENDREGION}

initialization
  {$IFDEF DEBUG}
    AllocConsole;
  {$ENDIF}

  Stage1;

finalization
  StageZ;

end.
