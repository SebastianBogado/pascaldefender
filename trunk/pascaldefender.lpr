program pascaldefender;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, pascaldefender, LResources;

{$IFDEF WINDOWS}{$R pascaldefender.rc}{$ENDIF}

begin
  {$I pascaldefender.lrs}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

