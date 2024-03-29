{
Sistema base del juego
}
unit pdbase;

interface
procedure correr_pd();

implementation

uses
    pdcommons,
    pantalla_introduccion,
    pantalla_instrucciones,
    pantalla_hiscores,
    pantalla_opciones,
    pantalla_juego,
    pantalla_acercade;

{
Maneja el paso de una pantalla del programa a otra. Cada ejecución
de las distintas pantallas, devuelve la pantalla a ejecutar luego.
}
procedure correr_pd();
var
    {La pantalla que se debe mostrar}
    pantalla : t_pantalla;
begin
	randomize();

    pantalla := introduccion;

    while (pantalla <> salida) do
    begin
        case pantalla of
            introduccion:
                pantalla := correr_introduccion();
            juego:
                pantalla := correr_juego();
            instrucciones:
                pantalla := correr_instrucciones();
            opciones:
                pantalla := correr_opciones();
            acercade:
                pantalla:= correr_acercade();
            hiscores:
                pantalla := correr_hiscores();
            else
                pantalla := salida;
       end;
    end;
end;

end.

