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
  SeaDir = '.\Sea\';
  VersionData = 'VersionData\';

var
  ClientVersionSignature: String = '0000000000000';
  ClientVersionName:      String = '';

  SeaDirVer: String = SeaDir + VersionData;

implementation

end.
