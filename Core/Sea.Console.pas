{
  Sea.Console
    Console window control

  This source code was NOT written by a chipmunk!
  Copyright © 2022 Sordie Aranka Solomon-Smith

  https://github.com/NotAChipmunk/OpenSea
}

unit Sea.Console;

{$I Sea.Options.inc}

interface

uses
  WinAPI.Windows;

{$REGION 'Staging'}
procedure Stage1;
procedure Stage2;
procedure StageZ;
{$ENDREGION}

var
  ConsoleWindow: HWND    = 0;
  ConsoleHandle: THandle = 0;

{$REGION 'Methods'}
procedure ToggleConsole;

procedure Header(const ATitle: String);
{$ENDREGION}

implementation

uses
  Sea.Globals,

  libNut.Strings;

{$REGION 'Staging'}
procedure Stage1;
var
  ConsoleTitle: String;
begin
  AllocConsole;

  ConsoleWindow := GetConsoleWindow;
  ConsoleHandle := GetStdHandle(STD_OUTPUT_HANDLE);

  ConsoleTitle := (SeaName + ' v' + SeaVersion + ' (F9 to toggle console) - ' + ParamStr(0));
  SetConsoleTitle(PChar(ConsoleTitle));

  SetConsoleTextAttribute(ConsoleHandle, FOREGROUND_GREEN or FOREGROUND_BLUE or FOREGROUND_INTENSITY);

  Writeln(' _____             _____ _____ _____');
  Writeln('|     |___ ___ ___|   __|   __|  _  |');
  Writeln('|  |  | . | -_|   |__   |   __|     |');
  Writeln('|_____|  _|___|_|_|_____|_____|__|__|');
  Writeln('      |_| Version ' + SeaVersion);

  SetConsoleTextAttribute(ConsoleHandle, FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE);
end;

procedure Stage2;
begin
  {}
end;

procedure StageZ;
begin
  FreeConsole;
  ConsoleWindow := 0;
end;
{$ENDREGION}

{$REGION 'Methods'}
procedure ToggleConsole;
begin
  if ConsoleWindow = 0 then
    Exit;

  if IsWindowVisible(ConsoleWindow) then
    ShowWindow(ConsoleWindow, SW_HIDE)
  else
    ShowWindow(ConsoleWindow, SW_SHOWNOACTIVATE);
end;

procedure Header;
var
  BufferInfo: TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo(ConsoleHandle, BufferInfo);
  SetConsoleTextAttribute(ConsoleHandle, FOREGROUND_RED or FOREGROUND_GREEN);
  Write(#13#10 + '== ' + ATitle + ' ' + String('=').Repeated(BufferInfo.dwSize.X - Length(ATitle) - 4));
  SetConsoleTextAttribute(ConsoleHandle, FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE);
end;
{$ENDREGION}

end.
