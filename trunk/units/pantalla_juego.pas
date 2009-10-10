unit pantalla_juego;

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

const
    CANTIDAD_NIVELES = 3;

{
Crea un jugador y lo inicializa con un nombre pedido al usuario
@return t_jugador EL jugador creado.
}
function crear_jugador():t_jugador;
var
    jugador:t_jugador;
begin
    inicializar_jugador(jugador);
    jugador.nombre := pedir_nombre();

    crear_jugador := jugador;
end;

{
Crea las entidades para un nivel
@todo implementar!
}
procedure crear_entidades_nivel(var nivel:t_nivel);
begin

end;

{
@todo implementar!
}
procedure turno_jugador(var nivel:t_nivel, var jugador:t_jugador);
begin

end;

{
@todo implementar!
}
procedure turno_alienigena(var nivel:t_nivel, var jugador:t_jugador);
begin

end;

{
@todo implementar!
}
procedure turno_mundo(var nivel:t_nivel, var jugador:t_jugador);
begin

end;

{
Realiza todas las acciones de un turno
@todo implementar!
}
procedure jugar_turno(var nivel:t_nivel, var jugador:t_jugador);
begin

end;

{
Corre el nivel, ejecutando todos los turnos hasta que el usuario gana, muere
o abandona.
@param numero_nivel byte El número del nivel a jugar
@param jugador t_jugador El jugador que jugará el nivel
@return boolean True si el jugador ha ganado, False si ha perdido o abandonado.
@todo implementar el guardado de puntos.
}
function jugar_nivel(numero_nivel:byte; var jugador:t_jugador):boolean;
var
    nivel:t_nivel;
    seguir_jugando:boolean;
begin
    inicializar_nivel(nivel);
    nivel.numero := numero_nivel;

    crear_entidades_nivel(nivel);

    while seguir_jugando do
        seguir_jugando := jugar_turno(nivel, jugador);

    correr_nivel := seguir_jugando;
end;


{
Corre cada uno de los niveles hasta que el jugador muere o abandona.
@return t_pantalla La pantalla a la que el usuario quiere acceder
}
function correr_juego():t_pantalla;
var
    jugador:t_jugador;
    seguir_jugando:boolean;
    numero_nivel:integer;
begin
    numero_nivel := 0;
    seguir_jugando := true;

    jugador := crear_jugador();

    while(seguir_jugando and (numero_nivel < CANTIDAD_NIVELES)) do
    begin
        inc(numero_nivel);
        seguir_jugando := jugar_nivel(numero_nivel, jugador);
    end;

    correr_juego := introduccion;
end;


end.

