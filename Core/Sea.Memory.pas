{
  Sea.Memory
    OpenSea memory read/write

  This source code was NOT written by a chipmunk!
  Copyright © 2022 Sordie Aranka Solomon-Smith

  https://github.com/NotAChipmunk/OpenSea
}

unit Sea.Memory;

interface

uses
  WinAPI.Windows;

{$REGION 'Staging'}
procedure Stage1;
procedure Stage2;
procedure StageZ;
{$ENDREGION}

{$REGION 'Peek'}
function PeekData(const AAddress: NativeUInt; const AData: Pointer; const ASize: Integer): Boolean;

function PeekByte (const AAddress: NativeUInt; const ADefault: Byte  = 0): Byte;  inline;
function PeekWord (const AAddress: NativeUInt; const ADefault: Word  = 0): Word;  inline;
function PeekDWord(const AAddress: NativeUInt; const ADefault: DWord = 0): DWord; inline;
{$ENDREGION}

{$REGION 'Poke'}
function PokeData(const AAddress: NativeUInt; const AData: Pointer; const ASize: Integer): Boolean;

function PokeByte (const AAddress: NativeUInt; const AValue: Byte  = 0): Boolean; inline;
function PokeWord (const AAddress: NativeUInt; const AValue: Word  = 0): Boolean; inline;
function PokeDWord(const AAddress: NativeUInt; const AValue: DWord = 0): Boolean; inline;
{$ENDREGION}

implementation

uses
  libNut.Types.Convert;

{$REGION 'Staging'}
procedure Stage1;
begin
  {}
end;

procedure Stage2;
begin
  {}
end;

procedure StageZ;
begin
  {}
end;
{$ENDREGION}

{$REGION 'Peek'}
function PeekData;
var
  p1, p2: LongWord;
begin
  if not VirtualProtect(Pointer(AAddress), ASize, PAGE_EXECUTE_READWRITE, p1) then
    Exit(False);

  CopyMemory(AData, Pointer(AAddress), ASize);

  if not VirtualProtect(Pointer(AAddress), ASize, p1, p2) then
    Exit(False);

  Result := True;
end;

function PeekByte;
begin
  if not PeekData(AAddress, @Result, SizeOf(Result)) then
    Result := ADefault;
end;

function PeekWord;
begin
  if not PeekData(AAddress, @Result, SizeOf(Result)) then
    Result := ADefault;
end;

function PeekDWord;
begin
  if not PeekData(AAddress, @Result, SizeOf(Result)) then
    Result := ADefault;
end;
{$ENDREGION}

{$REGION 'Poke'}
function PokeData;
var
  p1, p2: LongWord;
begin
  if not VirtualProtect(Pointer(AAddress), ASize, PAGE_EXECUTE_READWRITE, p1) then
    Exit(False);

  CopyMemory(Pointer(AAddress), AData, ASize);

  if not VirtualProtect(Pointer(AAddress), ASize, p1, p2) then
    Exit(False);

  Result := True;
end;

function PokeByte;
begin
  Result := PokeData(AAddress, @AValue, SizeOf(AValue));
end;

function PokeWord;
begin
  Result := PokeData(AAddress, @AValue, SizeOf(AValue));
end;

function PokeDWord;
begin
  Result := PokeData(AAddress, @AValue, SizeOf(AValue));
end;
{$ENDREGION}

end.
