{juego - Maneja el estado de juego}
unit juego;

interface
uses
    crt,
    pdcommons,
    puntajes,
    nivel,
    jugador,
    entidad,
    graficador;

function correr_juego():byte;


implementation
{forward declarations}
function correr_nivel(numero_nivel:byte; var jugador:t_jugador):byte; forward;

const
     CANTIDAD_NIVELES = 3;

function correr_juego():byte;
var
   jugador:t_jugador;
   respuesta_nivel:byte;
   numero_nivel:integer;
begin
     numero_nivel := 0;
     respuesta_nivel := PD_PROXIMO_NIVEL;

     inicializar_jugador(jugador);
     jugador.nombre := formulario_nombre();

     while((respuesta_nivel = PD_PROXIMO_NIVEL) and (numero_nivel < CANTIDAD_NIVELES)) do
     begin
          inc(numero_nivel);
          respuesta_nivel := correr_nivel(numero_nivel,jugador);
     end;

     correr_juego := respuesta_nivel;
end;

end.

