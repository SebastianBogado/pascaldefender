unit pantalla_juego;

interface

uses
    crt,
    pdcommons,
    puntajes,
    nivel,
    jugador,
    entidad,
    mapa,
    graficador;

function correr_juego():t_pantalla;


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

function detectar_colision(id_entidad:t_id_entidad; var nivel:t_nivel):t_id_entidad;
begin

end;

procedure reposicionar_entidad(id_entidad:t_id_entidad; var nivel:t_nivel);
begin
  nivel.mapa[nivel.entidades[id_entidad].origen.y,nivel.entidades[id_entidad].origen.x] := id_entidad;
  nivel.mapa[nivel.entidades[id_entidad].origen.y,nivel.entidades[id_entidad].origen.x+1] := id_entidad;
  nivel.mapa[nivel.entidades[id_entidad].origen.y+1,nivel.entidades[id_entidad].origen.x] := id_entidad;
  nivel.mapa[nivel.entidades[id_entidad].origen.y+1,nivel.entidades[id_entidad].origen.x+1] := id_entidad;
end;

{
Crea las entidades para un nivel
@todo implementar!
}
procedure crear_entidades_nivel(var nivel:t_nivel);
var
    i:byte;
begin
    nivel.cantidad_entidades := 0;

  {crear beto}
  nivel.entidades[1].tipo := beto;
  nivel.entidades[1].origen.x := 1;
  nivel.entidades[1].origen.y := 18;
  inc(nivel.cantidad_entidades);

  {crear escudo}
  for i := CANTIDAD_BETOS+1 to CANTIDAD_BETOS + CANTIDAD_ESCUDOS do
  begin
    nivel.entidades[i].tipo := escudo;
    nivel.entidades[i].origen.x := i*3;
    nivel.entidades[i].origen.y := 15;
    inc(nivel.cantidad_entidades);
  end;

  {crear aliens}
  for i := CANTIDAD_BETOS+CANTIDAD_ESCUDOS+1 to CANTIDAD_BETOS + CANTIDAD_ESCUDOS + CANTIDAD_ALIENS do
  begin
    nivel.entidades[i].tipo := alien_a;
    {esto los acomoda de filas de 6 naves cada una}
    nivel.entidades[i].origen.x := ((i mod 6)+1)*3;
    nivel.entidades[i].origen.y := ((i div 6)-1)*3 + 1;
    inc(nivel.cantidad_entidades);
  end;

end;

procedure mover_beto(d:integer; var nivel:t_nivel; var jugador:t_jugador);
begin
    if ((d < 0) and (nivel.entidades[1].origen.x > 1)) or ((d > 0) and (nivel.entidades[1].origen.x < COLUMNAS_MAPA)) then
    begin
        nivel.entidades[1].origen.x := nivel.entidades[1].origen.x + d;
    end;
end;

{
@todo implementar!
}
procedure turno_jugador(var nivel:t_nivel; var jugador:t_jugador);
begin
    if keypressed() then
    begin
        case readkey() of
            #0: begin
                  case readkey() of
                      #72 : mover_beto(1, nivel, jugador);
                      #75 : mover_beto(-1, nivel, jugador);
                      {#77 : r;
                      #80 : d;}
                  end;
                end;
        end;
    end;

end;

{
@todo implementar!
}
procedure turno_alienigena(var nivel:t_nivel; var jugador:t_jugador);
begin

end;

{
@todo implementar!
}
procedure turno_mundo(var nivel:t_nivel; var jugador:t_jugador);
begin

end;

{
Realiza todas las acciones de un turno
@todo implementar!
}
function jugar_turno(var nivel:t_nivel; var jugador:t_jugador):boolean;
var
    i:integer;
begin
        inicializar_mapa(nivel.mapa);

        turno_jugador(nivel, jugador);

        for i := 1 to nivel.cantidad_entidades do
            reposicionar_entidad(i, nivel);

        graficar_nivel(nivel, jugador);

        jugar_turno := true;
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

    jugar_nivel := seguir_jugando;
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

