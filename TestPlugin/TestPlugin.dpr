library TestPlugin;

{$R *.res}

procedure Stage1; stdcall; export;
begin
  Writeln('Test plugin stage 1');
end;

procedure Stage2; stdcall; export;
begin
  Writeln('Test plugin stage 2');
end;

procedure StageZ; stdcall; export;
begin
  Writeln('Test plugin stage Z');
end;

exports
  Stage1,
  Stage2,
  StageZ;


end.
