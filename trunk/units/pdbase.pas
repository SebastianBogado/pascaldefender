unit pdbase;

interface
procedure iniciar_pd();

implementation

uses
  pdcommons,
  introduccion,
  instrucciones,
  hiscores,
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
            PD_VER_INSTRUCCIONES: opcion := correr_instrucciones();
            PD_VER_HISCORES: opcion := correr_hiscores();
            else
                opcion := PD_SALIR
       end;
    end;
end;

end.

