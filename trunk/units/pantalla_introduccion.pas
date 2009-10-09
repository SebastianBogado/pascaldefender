unit pantalla_introduccion;

interface

uses
    crt,
    pdcommons,
    graficador;

function correr_introduccion(): t_pantalla;


implementation

{
Muestra la pantalla de introducción, y espera que el usuario seleccione
una opción.
@retorna t_pantalla La pantalla a la que el usuario quiere acceder
}
function correr_introduccion(): t_pantalla;
var
   pantalla_seleccionada: t_pantalla;
   tecla_ingresada: char;
begin
     pantalla_seleccionada := introduccion;

     while(pantalla_seleccionada = introduccion) do
     begin
          graficar_introduccion();
          tecla_ingresada := readkey();
          writeln(tecla_ingresada);
          case tecla_ingresada of
               '1': pantalla_seleccionada := juego;
               '2': pantalla_seleccionada := instrucciones;
               '3': pantalla_seleccionada := hiscores;
               '0': pantalla_seleccionada := salida;
          end;
     end;

     correr_introduccion := pantalla_seleccionada;
end;

end.

