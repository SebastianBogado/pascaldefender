unit hiscores;

interface
function correr_hiscores():byte;

implementation

uses
    crt,
    pdcommons,
    puntajes,
    graficador;

function correr_hiscores():byte;
var
   cantidad_puntajes : byte;
   puntajes : t_puntajes;
begin
     puntajes := obtener_puntajes();
     cantidad_puntajes := obtener_cantidad_puntajes();

     graficar_hiscores(cantidad_puntajes, puntajes);
     readkey();
     correr_hiscores := PD_INTRO;
end;

end.

