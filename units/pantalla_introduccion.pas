unit pantalla_introduccion;

interface

uses
    crt,
    pdcommons,
    graficador;

function correr_introduccion(): t_pantalla;


implementation

{
Interpreta la elección de pantalla del usuario.
@return t_pantalla La pantalla a la que el usuario quiere acceder
@todo mostrar un error si el usuario elige una opción incorrecta
}
function pedir_pantalla():t_pantalla;
var
    pantalla_seleccionada:t_pantalla;
    tecla_ingresada:char;
begin
    tecla_ingresada := readkey();
    write(tecla_ingresada);
    case tecla_ingresada of
        '1': pantalla_seleccionada := juego;
        '2': pantalla_seleccionada := instrucciones;
        '3': pantalla_seleccionada := hiscores;
        '0': pantalla_seleccionada := salida;
    end;

    pedir_pantalla := pantalla_seleccionada;
end;

{
Muestra la pantalla de introducción, y espera que el usuario seleccione
una opción.
@return t_pantalla La pantalla a la que el usuario quiere acceder
}
function correr_introduccion(): t_pantalla;
var
    pantalla_seleccionada: t_pantalla;
begin
    pantalla_seleccionada := introduccion;
    graficar_introduccion();

    while(pantalla_seleccionada = introduccion) do
        pantalla_seleccionada := pedir_pantalla();

    correr_introduccion := pantalla_seleccionada;
end;

end.

