{pdbase - Sistema base del juego}
unit pdbase;

interface
procedure iniciar_pd();

implementation

uses
  pdcommons,
  pantalla_introduccion,
  pantalla_instrucciones,
  pantalla_hiscores,
  pantalla_juego;

{
Maneja el paso de una pantalla del programa a otra. Cada ejecución
de las distintas pantallas, devuelve la pantalla a ejecutar luego.
}
procedure correr_pd();
var
   {La pantalla que se debe mostrar}
   pantalla : t_pantalla;
begin
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
            hiscores:
                  pantalla := correr_hiscores();
            else
                  pantalla := salida;
       end;
    end;
end;

end.

