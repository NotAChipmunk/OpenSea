{
  Sea.Globals
    OpenSea global variables

  This source code was NOT written by a chipmunk!
  Copyright © 2022 Sordie Aranka Solomon-Smith

  https://github.com/NotAChipmunk/OpenSea
}

unit Sea.Globals;

{$I Sea.Options.inc}

interface

const
  ClientWindowClass = 'TMainForm';

  SeaName    = 'OpenSEA';
  SeaVersion = '0.1a';

  SeaDir        = '.\Sea\';
  SeaPluginsDir = SeaDir + 'Plugins\';

  VersionData = SeaDir + 'VersionData.csv';

var
  ClientVersionSignature: String  = '0000000000000';
  ClientVersionName:      String  = 'Unknown';
  ClientVersionUnknown:   Boolean = True;

  SeaDirVer: String = SeaDir + VersionData;

implementation

end.
