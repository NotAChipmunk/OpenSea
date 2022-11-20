{
  Sea.Window
    Client window sub-classing

  This source code was NOT written by a chipmunk!
  Copyright © 2022 Sordie Aranka Solomon-Smith

  https://github.com/NotAChipmunk/OpenSea
}

unit Sea.Window;

{$I Sea.Options.inc}

interface

uses
  WinAPI.Windows,
  WinAPI.Messages,

  libNut.Platform,
  libNut.Windows;

{$REGION 'Staging'}
procedure Stage1;
procedure Stage2;
procedure StageZ;
{$ENDREGION}

{$REGION 'Hooked API'}
var
  OldCreateWindowExA: function(dwExStyle: DWORD; lpClassName: LPCSTR; lpWindowName: LPCSTR; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer; hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND; stdcall;

function NewCreateWindowExA(dwExStyle: DWORD; lpClassName: LPCSTR; lpWindowName: LPCSTR; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer; hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND; stdcall;
{$ENDREGION}

{$REGION 'Window subclass'}
const
  WM_STAGE2 = WM_USER + $5A;

type
  TClientWindow = class(TSubClass)
  public
    procedure WMStage2(var Msg: TWndMsg); message WM_STAGE2;

    procedure WMKeyDown(var Msg: TWndMsg); message WM_KEYDOWN;
  end;

function ClientWindow: TClientWindow;
{$ENDREGION}

implementation

uses
  Sea.Globals,
  Sea.Console,
  Sea.Startup,
  Sea.Hook;

{$REGION 'Staging'}
procedure Stage1;
begin
  HookAPI(user32, 'CreateWindowExA', @NewCreateWindowExA, @OldCreateWindowExA);
end;

procedure Stage2;
begin
  ClientWindow.Handle.Caption := ClientWindow.Handle.Caption + ' - OpenSea';
end;

procedure StageZ;
begin
  {}
end;
{$ENDREGION}

{$REGION 'Hooked API'}
function NewCreateWindowExA;
begin
  Result := OldCreateWindowExA(dwExStyle, lpClassName, lpWindowName, dwStyle, X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam);

  if lpClassName = ClientWindowClass then
  begin
    Writeln('Client window creation detected. Subclassing.');

    &Platform.ProcessMessages(False);
    ClientWindow.Handle := Result;

    PostMessage(ClientWindow.Handle, WM_STAGE2, 0, 0);

    Writeln('Subclass OK');
  end;
end;
{$ENDREGION}

{$REGION 'Window subclass'}
var
  _ClientWindow: TClientWindow = nil;

function ClientWindow: TClientWindow;
begin
  if not Assigned(_ClientWindow) then
    _ClientWindow := TClientWindow.Create;

  Result := _ClientWindow;
end;

procedure TClientWindow.WMStage2;
begin
  Sea.Startup.Stage2;
end;

procedure TClientWindow.WMKeyDown;
begin
  case Msg.wParam of
    VK_F9: ToggleConsole;
  end;

  inherited;
end;
{$ENDREGION}

end.
