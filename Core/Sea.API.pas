{
  Sea.API
    OpenSea exported API

  This source code was NOT written by a chipmunk!
  Copyright © 2022 Sordie Aranka Solomon-Smith

  https://github.com/NotAChipmunk/OpenSea
}

unit Sea.API;

{$I Sea.Options.inc}

interface

uses
  WinAPI.Windows;

{$REGION 'Memory'}
function PeekData(const AAddress: NativeUInt; const AData: Pointer; const ASize: Integer): Boolean; stdcall; export;

function PeekByte (const AAddress: NativeUInt; const ADefault: Byte  = 0): Byte;  stdcall; export;
function PeekWord (const AAddress: NativeUInt; const ADefault: Word  = 0): Word;  stdcall; export;
function PeekDWord(const AAddress: NativeUInt; const ADefault: DWord = 0): DWord; stdcall; export;

function PokeData(const AAddress: NativeUInt; const AData: Pointer; const ASize: Integer): Boolean; stdcall; export;

function PokeByte (const AAddress: NativeUInt; const AValue: Byte  = 0): Boolean; stdcall; export;
function PokeWord (const AAddress: NativeUInt; const AValue: Word  = 0): Boolean; stdcall; export;
function PokeDWord(const AAddress: NativeUInt; const AValue: DWord = 0): Boolean; stdcall; export;
{$ENDREGION}

{$REGION 'Hook'}
function HookProc(ATargetProc:          Pointer; const ANewProc: Pointer; var AOldProc: Pointer): Boolean; stdcall; export;
function HookAPI (const AModule, AName: PChar;   const ANewProc: Pointer; var AOldProc: Pointer): Boolean; stdcall; export;
{$ENDREGION}

exports
  PeekData, PeekByte, PeekWord, PeekDWord,
  PokeData, PokeByte, PokeWord, PokeDWord,
  HookProc, HookAPI;

implementation

uses
  Sea.Globals,
  Sea.Memory,
  Sea.Hook,
  Sea.Version,
  Sea.Window,
  Sea.Console,
  Sea.Plugins;

{$REGION 'Memory'}
function PeekData;  begin Result := Sea.Memory.PeekData (AAddress, AData, ASize); end;
function PeekByte;  begin Result := Sea.Memory.PeekByte (AAddress, ADefault);     end;
function PeekWord;  begin Result := Sea.Memory.PeekWord (AAddress, ADefault);     end;
function PeekDWord; begin Result := Sea.Memory.PeekDWord(AAddress, ADefault);     end;

function PokeData;  begin Result := Sea.Memory.PokeData (AAddress, AData, ASize); end;
function PokeByte;  begin Result := Sea.Memory.PokeByte (AAddress, AValue);       end;
function PokeWord;  begin Result := Sea.Memory.PokeWord (AAddress, AValue);       end;
function PokeDWord; begin Result := Sea.Memory.PokeDWord(AAddress, AValue);       end;
{$ENDREGION}

{$REGION 'Hook'}
function HookProc; begin Result := Sea.Hook.HookProc(AtargetProc,    ANewProc, AOldProc); end;
function HookAPI;  begin Result := Sea.Hook.HookAPI (AModule, AName, ANewProc, AOldProc); end;
{$ENDREGION}

end.
