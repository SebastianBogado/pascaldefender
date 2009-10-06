unit pdbase;

interface
procedure iniciar_pd();

implementation

uses
  pdcommons,
  introduccion,
  juego;

procedure iniciar_pd();
var
   opcion : byte;
begin
    writeln('comenzando');
    opcion := PD_INTRO;

    while (opcion <> PD_SALIR) do
    begin
       case opcion of
            PD_INTRO: opcion := correr_introduccion();
            PD_JUGAR: opcion := correr_juego();
            else
                opcion := PD_SALIR
       end;
    end;
end;

end.

