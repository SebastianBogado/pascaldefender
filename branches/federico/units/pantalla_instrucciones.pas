unit pantalla_instrucciones;

interface

uses
    crt,
    pdcommons,
    graficador;

function correr_instrucciones():t_pantalla;


implementation

{
Muestra las instrucciones del juego, y vuelve a la introducción
@returns t_pantalla La pantalla que debe correrse a continuación
}
function correr_instrucciones():t_pantalla;
begin
    graficar_instrucciones();
    readkey();

    correr_instrucciones := introduccion;
end;

end.

