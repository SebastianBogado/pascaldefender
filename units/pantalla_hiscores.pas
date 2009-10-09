unit pantalla_hiscores;

interface

uses
    crt,
    pdcommons,
    puntajes,
    graficador;

function correr_hiscores():t_pantalla;


implementation

{
Obtiene los mejores puntajes y los muestra.
@retorna t_pantalla La pantalla que debe correrse a continuación
}
function correr_hiscores():t_pantalla;
var
   cantidad_puntajes : byte;
   puntajes : t_puntajes;
begin
     cantidad_puntajes := obtener_cantidad_puntajes();
     puntajes := obtener_puntajes();

     graficar_hiscores(cantidad_puntajes, puntajes);
     readkey();

     correr_hiscores := introduccion;
end;

end.

