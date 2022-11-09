{
  msimg32
    OpenSea loader dll

  This source code was NOT written by a chipmunk!
  Copyright © 2022 Sordie Aranka Solomon-Smith

  https://github.com/NotAChipmunk/OpenSea

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
}

library msimg32;

{.$DEFINE DEBUG}
{$DEFINE STATIC_GDI32}

{$IFDEF DEBUG}
function AllocConsole: LongBool; stdcall; external 'kernel32';
{$ENDIF}
function GetKeyState(nVirtKey: Integer): Smallint; stdcall; external 'user32';
function LoadLibrary(lpLibFileName: PWideChar): HMODULE; stdcall; external 'kernel32' name 'LoadLibraryW';
{$IFNDEF STATIC_GDI32}
function GetProcAddress(hModule: HMODULE; lpProcName: PWideChar): Pointer; stdcall; external 'kernel32';
function ExpandEnvironmentStrings(lpSrc: PWideChar; lpDst: PWideChar; nSize: Cardinal): Cardinal; stdcall; external 'kernel32' name 'ExpandEnvironmentStringsW';
{$ENDIF}

type
  HDC = type NativeUInt;

{$IFDEF STATIC_GDI32}
function _AlphaBlend(DC: HDC; p2, p3, p4, p5: Integer; DC6: HDC; p7, p8, p9, p10: Integer; p11: Pointer): LongBool; stdcall; external 'gdi32' name 'GdiAlphaBlend';
function _TransparentBlt(DC: HDC; p2, p3, p4, p5: Integer; DC6: HDC; p7, p8, p9, p10: Integer; p11: LongWord): LongBool; stdcall; external 'gdi32' name 'GdiTransparentBlt';
function _GradientFill(DC: HDC; Vertex: Pointer; NumVertex: LongWord; Mesh: Pointer; NumMesh, Mode: LongWord): LongBool; stdcall; external 'gdi32' name 'GdiGradientFill';
{$ELSE}
var
  _AlphaBlend:     function(DC: HDC; p2, p3, p4, p5: Integer; DC6: HDC; p7, p8, p9, p10: Integer; p11: Pointer): LongBool; stdcall;
//_AlphaDIBBlend:  function(DC: HDC; p2, p3, p4, p5: Integer; const p6: Pointer; const p7: Pointer; p8: LongWord; p9, p10, p11, p12: Integer; p13: Pointer): LongBool; stdcall;
  _TransparentBlt: function(DC: HDC; p2, p3, p4, p5: Integer; DC6: HDC; p7, p8, p9, p10: Integer; p11: LongWord): LongBool; stdcall;
  _GradientFill:   function(DC: HDC; Vertex: Pointer; NumVertex: LongWord; Mesh: Pointer; NumMesh, Mode: LongWord): LongBool; stdcall;
{$ENDIF}

function AlphaBlend(DC: NativeUInt; p2, p3, p4, p5: Integer; DC6: NativeUInt; p7, p8, p9, p10: Integer; p11: Pointer): LongBool; stdcall; export;
begin
  {$IFDEF DEBUG}
  Writeln('AlphaBlend');
  {$ENDIF}

  {$IFNDEF STATIC_GDI32}
  if Assigned(_AlphaBlend) then
  {$ENDIF}
    Result := _AlphaBlend(DC, p2, p3, p4, p5, DC6, p7, p8, p9, p10, p11)
  {$IFNDEF STATIC_GDI32}
  else
    Result := False;
  {$ENDIF}
end;

//function AlphaDIBBlend(DC: NativeUInt; p2, p3, p4, p5: Integer; const p6: Pointer; const p7: Pointer; p8: LongWord; p9, p10, p11, p12: Integer; p13: Pointer): LongBool; stdcall; export;
//begin
//  {$IFDEF DEBUG}
//  Writeln('AlphaDIBBlend');
//  {$ENDIF}
//
//  {$IFNDEF STATIC_GDI32}
//  if Assigned(_AlphaDIBBlend) then
//    Result := _AlphaDIBBlend(DC, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13)
//  else
//  {$ENDIF}
//    Result := False;
//end;

function TransparentBlt(DC: NativeUInt; p2, p3, p4, p5: Integer; DC6: NativeUInt; p7, p8, p9, p10: Integer; p11: LongWord): LongBool; stdcall; export;
begin
  {$IFDEF DEBUG}
  Writeln('TransparentBlt');
  {$ENDIF}

  {$IFNDEF STATIC_GDI32}
  if Assigned(_TransparentBlt) then
  {$ENDIF}
    Result := _TransparentBlt(DC, p2, p3, p4, p5, DC6, p7, p8, p9, p10, p11)
  {$IFNDEF STATIC_GDI32}
  else
    Result := False;
  {$ENDIF}
end;

function GradientFill(DC: NativeUInt; Vertex: Pointer; NumVertex: LongWord; Mesh: Pointer; NumMesh, Mode: LongWord): LongBool; stdcall; export;
begin
  {$IFDEF DEBUG}
  Writeln('GradientFill');
  {$ENDIF}

  {$IFNDEF STATIC_GDI32}
  if Assigned(_GradientFill) then
  {$ENDIF}
    Result := _GradientFill(DC, Vertex, NumVertex, Mesh, NumMesh, Mode)
  {$IFNDEF STATIC_GDI32}
  else
    Result := False;
  {$ENDIF}
end;

exports
  AlphaBlend,
//AlphaDIBBlend,
  TransparentBlt,
  GradientFill;

const
  Dll: PChar = '.\Sea\Sea.Core.dll';

  {$IFNDEF STATIC_GDI32}
  I32: PChar = '%SystemRoot%\system32\msimg32.dll';
  {$ENDIF}

function lowercase(const s: String): String;
const
  upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  lower = 'abcdefghijklmnopqrstuvwxyz';
var
  i, j: Integer;
begin
  Result := s;

  for i := 1 to Length(Result) do
  begin
    j := pos(Result[i], upper);
    if j > 0 then
      Result[i] := lower[j];
  end;
end;

var
  {$IFNDEF STATIC_GDI32}
  RealModule: HMODULE;
  RealPath:   String;
  {$ENDIF}

  IsClient: Boolean;
begin
  {$IFDEF DEBUG}
  AllocConsole;
  Writeln('msimg32.dll');
  {$ENDIF}

  {$IFNDEF STATIC_GDI32}
  _AlphaBlend     := nil;
//_AlphaDIBBlend  := nil;
  _TransparentBlt := nil;
  _GradientFill   := nil;

  SetLength(RealPath, 256);
  SetLength(RealPath, ExpandEnvironmentStrings(I32, PChar(RealPath), Length(RealPath)) - 1);

  {$IFDEF DEBUG}
  Write('Loading "' + RealPath + '" ... ');
  {$ENDIF}
  RealModule  := LoadLibrary(PChar(RealPath));
  {$IFDEF DEBUG}
  WriteLN(Cardinal(RealModule));
  {$ENDIF}

  if RealModule <> 0 then
  begin
    _AlphaBlend     := GetProcAddress(RealModule, 'AlphaBlend');
//  _AlphaDIBBlend  := GetProcAddress(RealModule, 'AlphaDIBBlend');
    _TransparentBlt := GetProcAddress(RealModule, 'TransparentBlt');
    _GradientFill   := GetProcAddress(RealModule, 'GradientFill');
  end;
  {$ENDIF}

  IsClient := Pos('endless.exe', lowercase(ParamStr(0))) > 0;

  {$IFDEF DEBUG}
  Writeln('IsClient=', IsClient);
  {$ENDIF}

  if IsClient then
    if (GetKeyState($A2) and $8000) = 0 then
    begin
      {$IFDEF DEBUG}
      Writeln('Loading ', Dll);
      {$ENDIF}

      LoadLibrary(Dll);
    end;
end.

