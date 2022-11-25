{
  Sea.Plugins
    OpenSea External/3rd party plugin loader

  This source code was NOT written by a chipmunk!
  Copyright © 2022 Sordie Aranka Solomon-Smith

  https://github.com/NotAChipmunk/OpenSea
}

unit Sea.Plugins;

{$I Sea.Options.inc}

interface

uses
  libNut.Vectors;

{$REGION 'Staging'}
procedure Stage1;
procedure Stage2;
procedure StageZ;

type
  TStageProc = procedure; stdcall;
{$ENDREGION}

type
  {$REGION 'Plugin type'}
  TPlugin = class
  private
    FName:    String;
    FHandle:  THandle;
    FVersion: String;
    FProduct: String;
    FCommon:  Boolean;

    FFullName: String;

    function GetLoaded: Boolean; inline;
  public
    constructor Create(const AName: String);
    destructor  Destroy; override;

    function  Load: Boolean;
    procedure Unload;

    function GetProc(const AName: String): Pointer; inline;

    property Loaded: Boolean read GetLoaded;

    property Name:    String  read FName;
    property Handle:  THandle read FHandle;
    property Version: String  read FVersion;
    property Product: String  read FProduct;
    property Common:  Boolean read FCommon;

    property FullName: String read FFullName;
  end;
  {$ENDREGION}

  {$REGION 'Plugin manager'}
  TPlugins = class
  private
    FPlugins: TList<TPlugin>;

    function GetCount: Integer; inline;

    function GetPlugin(const AIndex: Integer): TPlugin; inline;
  public
    constructor Create;
    destructor  Destroy; override;

    function Find  (const AName: String): Integer;
    function Loaded(const AName: String): Boolean; inline;

    function  Load(const AName: String): TPlugin;
    procedure LoadAll(const ARoot: String);

    procedure Unload(const AName: String);
    procedure UnloadAll;

    procedure Stage(const AStage: String);

    property Count: Integer read GetCount;

    property Plugin[const AIndex: Integer]: TPlugin read GetPlugin; default;
  end;
  {$ENDREGION}

var
  Plugins: TPlugins = nil;

implementation

uses
  WinAPI.Windows,

  libNut.Strings,
  libNut.FileSystem,

  Sea.Globals,
  Sea.Version;

{$REGION 'Staging'}
procedure Stage1;
begin
  Plugins := TPlugins.Create;

  Plugins.LoadAll(SeaPluginsDir);

  if not ClientVersionUnknown then
    Plugins.LoadAll(SeaPluginsDir + ClientVersionName + '\');

  Plugins.Stage('Stage1');
end;

procedure Stage2;
begin
  Plugins.Stage('Stage2');
end;

procedure StageZ;
begin
  Plugins.Stage('StageZ');

  Plugins.Free;
end;
{$ENDREGION}

{$REGION 'Plugin type'}
function TPlugin.GetLoaded;
begin
  Result := FHandle <> 0;
end;

constructor TPlugin.Create;
begin
  inherited Create;

  FName    := AName;
  FHandle  := 0;
  FCommon  := True;
  FVersion := '';
  FProduct := '';

  FFullName := '';

  Load;
end;

destructor TPlugin.Destroy;
begin
  Unload;

  inherited;
end;

function TPlugin.Load;
begin
  if Loaded then
    Exit(True);

  try
    FVersion := VersionInfoReadFrom(FName, 'FileVersion', 0);
    FProduct := VersionInfoReadFrom(FName, 'FileDescription', 0);

    FFullName := FName;

    if FProduct.IsNotEmpty then
      FFullName := FProduct + ' (' + FFullName + ')';

    if not FVersion.IsEmpty then
      FFullName := FFullName + ' - Version ' + FVersion;

    Writeln('Loading ', FFullName);

    FHandle := LoadLibrary(PChar(FName));

    if FHandle = 0 then
    begin
      Writeln('Plugin "', FName + '" failed to load.');
      Exit(False);
    end;
  except
    Writeln('Plugin "', FName + '" raised an exception.');
    Unload;
    Exit(False);
  end;

  Result := True;
end;

procedure TPlugin.Unload;
begin
  if FHandle = 0 then
    Exit;

  Writeln('Unloading plugin "', FName, '"');

  // TODO: Call StageZ() ?
  FreeLibrary(FHandle);

  FHandle := 0;
end;

function TPlugin.GetProc;
begin
  if not Loaded then
    Exit(nil);

  Result := GetProcAddress(FHandle, PChar(AName));
end;
{$ENDREGION}

{$REGION 'Plugin type'}
function TPlugins.GetCount;
begin
  Result := FPlugins.Count;
end;

function TPlugins.GetPlugin;
begin
  Result := FPlugins[AIndex];
end;

constructor TPlugins.Create;
begin
  inherited;

  FPlugins := TList<TPlugin>.Create;
end;

destructor TPlugins.Destroy;
begin
  UnloadAll;

  FPlugins.Free;

  inherited;
end;

function TPlugins.Find;
begin
  for var i := FPlugins.Count - 1 downto 0 do
    if AName.Same(FPlugins[i].Name, True) then
      Exit(i);

  Result := -1;
end;

function TPlugins.Loaded;
begin
  Result := Find(AName) > -1;
end;

function TPlugins.Load;
var
  i: Integer;
begin
  i := Find(AName);

  if i = -1 then
  begin
    Result := TPlugin.Create(AName);

    if not Result.Loaded then
    begin
      Result.Free;
      Result := nil;
    end
    else
      FPlugins.Add(Result);
  end
  else
    Result := FPlugins[i];
end;

procedure TPlugins.LoadAll;
var
  Name: String;
begin
  with TFileSystemEnum.Create(ARoot + '*.dll', 0, True) do try
    if Done then
      Exit;

    repeat
      Name := ARoot + Data.cFileName;
      Load(Name);
    until not Next;
  finally
    Free;
  end;
end;

procedure TPlugins.Unload;
var
  i: Integer;
begin
  i := Find(AName);

  if i > -1 then
  begin
    FPlugins[i].Free;
    FPlugins.Delete(i);
  end;
end;

procedure TPlugins.UnloadAll;
var
  i: Integer;
begin
  for i := FPlugins.Count - 1 downto 0 do
    FPlugins[i].Free;

  FPlugins.Clear;
end;

procedure TPlugins.Stage;
var
  StageProc: TStageProc;
begin
  Writeln('Plugins: ', AStage, '()');

  for var i := 0 to FPlugins.Count - 1 do
  begin
    StageProc := FPlugins[i].GetProc(AStage);

    if Assigned(StageProc) then
      try
        StageProc;
      except
        Writeln('Exception in plugin ', Plugins[i].FullName, ' in ', AStage, '()');
      end;
  end;
end;
{$ENDREGION}

end.
