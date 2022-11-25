{
  Sea.Version
    OpenSea version detection

  This source code was NOT written by a chipmunk!
  Copyright © 2022 Sordie Aranka Solomon-Smith

  https://github.com/NotAChipmunk/OpenSea
}

unit Sea.Version;

{$I Sea.Options.inc}

interface

uses
  WinAPI.Windows;

{$REGION 'Staging'}
procedure Stage1;
procedure Stage2;
procedure StageZ;
{$ENDREGION}

{$REGION 'VersionInfoXXX'}
//procedure VersionInfoInit;
//procedure VersionInfoRelease;

//function  VersionInfoRead(const AValue: String; const ALang: Integer = 0): String;

function VersionInfoReadFrom(const AFileName, AValue: String; const ALang: Integer = 0): String;
{$ENDREGION}

{$REGION 'ClientVersionXXX'}
function  ClientVersionTDS: DWord;
procedure ClientVersionDetect;
{$ENDREGION}

implementation

uses
  Sea.Globals,
  Sea.Memory,

  libNut.Types.Convert,
  libNut.Strings,
  libNut.Vectors;

{$REGION 'Staging'}
procedure Stage1;
begin
  //VersionInfoInit;
  ClientVersionDetect;
end;

procedure Stage2;
begin
  {}
end;

procedure StageZ;
begin
  //VersionInfoRelease;
end;
{$ENDREGION}

{$REGION 'VersionInfoXXX'}
{
var
  VersionInfoSize: Cardinal = 0;
  VersionInfoBuff: Pointer  = nil;

procedure VersionInfoInit;
var
  VersionInfoHandle: DWORD;
begin
  VersionInfoRelease;

  VersionInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), VersionInfoHandle);
  if VersionInfoSize = 0 then
  begin
    Writeln('Failed to get version size');
    Exit;
  end;

  GetMem(VersionInfoBuff, VersionInfoSize);

  if not GetFileVersionInfo(PChar(ParamStr(0)), 0, VersionInfoSize, VersionInfoBuff) then
  begin
    Writeln('Failed to get version information');
    VersionInfoRelease;
  end;
end;

procedure VersionInfoRelease;
begin
  if Assigned(VersionInfoBuff) then
  begin
    FreeMem(VersionInfoBuff);

    VersionInfoSize := 0;
    VersionInfoBuff := nil;
  end;
end;

function VersionInfoRead;
type
  TLangCP = record
    Language: Word;
    CodePage: Word;
  end;

  PLangCPPool = ^TLangCPPool;
  TLangCPPool = array[0..0] of TLangCP;
var
  LangCP:     PLangCPPool;
  LangCPSize: UINT;
  BoundLang:  Integer;
  Value:      PChar;
  ValueLen:   UINT;
  QueryStr:   String;
begin
  if not Assigned(VersionInfoBuff) then
    VersionInfoInit;

  if not Assigned(VersionInfoBuff) then
    Exit;

  QueryStr := '\StringFileInfo\';

  if VerQueryValue(VersionInfoBuff, PChar('\VarFileInfo\Translation'), Pointer(LangCP), LangCPSize) then
  begin
    BoundLang := Abs(ALang);
    if BoundLang > Integer(LangCPSize) then
      BoundLang := LangCPSize;

    QueryStr := QueryStr + IntToBaseX(TLangCPPool(LangCP^)[BoundLang].Language, 16, 4) +
                           IntToBaseX(TLangCPPool(LangCP^)[BoundLang].CodePage, 16, 4) + '\';
  end;

  QueryStr := QueryStr + AValue;

  if VerQueryValue(VersionInfoBuff, PChar(QueryStr), Pointer(Value), ValueLen) then
    Result := String(Value)
  else
  begin
    Writeln('Failed to get version string "' + QueryStr + '"');
    Result := '';
  end;
end;
}
function VersionInfoReadFrom;
type
  TLangCP = record
    Language: Word;
    CodePage: Word;
  end;

  PLangCPPool = ^TLangCPPool;
  TLangCPPool = array[0..0] of TLangCP;
var
  VersionInfoSize: Cardinal;
  VersionInfoBuff: Pointer;

  LangCP:     PLangCPPool;
  LangCPSize: UINT;
  BoundLang:  Integer;
  Value:      PChar;
  ValueLen:   UINT;
  QueryStr:   String;

  procedure VersionInfoRelease;
  begin
    FreeMem(VersionInfoBuff);

    VersionInfoSize := 0;
    VersionInfoBuff := nil;
  end;

  procedure VersionInfoInit;
  var
    VersionInfoHandle: DWORD;
  begin
    VersionInfoSize := GetFileVersionInfoSize(PChar(AFileName), VersionInfoHandle);
    if VersionInfoSize = 0 then
    begin
      Writeln('Failed to get version size');
      Exit;
    end;

    GetMem(VersionInfoBuff, VersionInfoSize);

    if not GetFileVersionInfo(PChar(AFileName), 0, VersionInfoSize, VersionInfoBuff) then
    begin
      Writeln('Failed to get version information');
      VersionInfoRelease;
    end;
  end;
begin
  VersionInfoBuff := nil;
  VersionInfoSize := 0;

  VersionInfoInit;

  if not Assigned(VersionInfoBuff) then
    Exit('');

  try
    QueryStr := '\StringFileInfo\';

    if VerQueryValue(VersionInfoBuff, PChar('\VarFileInfo\Translation'), Pointer(LangCP), LangCPSize) then
    begin
      BoundLang := Abs(ALang);
      if BoundLang > Integer(LangCPSize) then
        BoundLang := LangCPSize;

      QueryStr := QueryStr + IntToBaseX(LangCP^[BoundLang].Language, 16, 4) +
                             IntToBaseX(LangCP^[BoundLang].CodePage, 16, 4) + '\';
    end;

    QueryStr := QueryStr + AValue;

    if VerQueryValue(VersionInfoBuff, PChar(QueryStr), Pointer(Value), ValueLen) then
      Result := String(Value)
    else
      Result := '';
  finally
    VersionInfoRelease;
  end;
end;
{$ENDREGION}

{$REGION 'ClientVersionXXX'}
function ClientVersionTDS: DWord;
var
  Addr:  NativeUInt;
  PEOfs: DWord;
begin
  Addr := GetModuleHandle(nil);

  PEOfs := PeekDWord(Addr + $3C);
  if PEOfs = 0 then
  begin
    Writeln('Error getting PE offset');
    Exit(0);
  end;

  Result := PeekDWord(Addr + PEOfs + 8);
end;

procedure ClientVersionDetect;
var
  VerFile: TStrings;
  Line:    String;
  LineSig: String;
begin
  ClientVersionSignature := IntToBaseX(ClientVersionTDS, 16, 8) {+ VersionInfoRead('FileVersion').Replace('.', '')};
  ClientVersionName      := 'Unknown';
  ClientVersionUnknown   := True;

  VerFile := TStrings.Create;

  try
    try
      VerFile.LoadFromFile(VersionData);
    except
      Writeln('No Version Data');
    end;

    for var i := 0 to VerFile.Count - 1 do
    begin
      Line := VerFile[i].Tidy;

      if Line.IsEmpty or (Line.FirstChar = '#') then
        Continue;

      LineSig := Line.SplitFirst(',');

      if LineSig = ClientVersionSignature then
      begin
        ClientVersionName    := Line.SplitFirst(',', True, True);
        ClientVersionUnknown := False;
        Break;
      end;
    end;
  finally
    VerFile.Free;
  end;

  Writeln('Detected client version: ', ClientVersionName, ' (', ClientVersionSignature, ')');

  SeaDirVer := SeaDir + VersionData + ClientVersionName + '\';
end;
{$ENDREGION}

end.
