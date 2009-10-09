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
@retorna t_jugador EL jugador creado.
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
Crea las entidades
@todo implementar!
}
procedure crear_entidades(var entidades:t_entidades);
begin

end;

function jugar_nivel(numero_nivel:byte; var jugador:t_jugador):boolean;
var
    nivel:t_nivel;
    seguir_jugando:boolean;
begin
    inicializar_nivel(nivel);
    nivel.numero := numero_nivel;

    crear_entidades_nivel(nivel);

    while seguir_jugando do
        jugar_turno();


    correr_nivel := seguir_jugando;
end;

    { {inicializa los aliens
     @TODO separar}
     for i := 1 to 12 do
     begin
       origen_x := (((i-1)*5)+1) mod (5{4 cuerpo + 1 espacio} * 6{naves por fila});
       origen_y := ((i-1) div 6) * 3 + 1;
       nivel.entidades[i].tipo := alien_a;
       nivel.entidades[i].origen.x := origen_x;
       nivel.entidades[i].origen.y := origen_y;
       nivel.mapa[origen_y][origen_x] := i;
       nivel.mapa[origen_y][origen_x+1] := i;
       nivel.mapa[origen_y][origen_x+2] := i;
       nivel.mapa[origen_y][origen_x+3] := i;
       nivel.mapa[origen_y+1][origen_x+1] := i;
       nivel.mapa[origen_y+1][origen_x+2] := i;
     end;

     {inicializa a beto
     @TODO separar}
     inc(i);
     origen_x := 10;
     origen_y := 19;
     nivel.entidades[i].tipo := beto;
     nivel.entidades[i].origen.x := origen_x;
     nivel.entidades[i].origen.y := origen_y;
     nivel.mapa[origen_y][origen_x+1] := i;
     nivel.mapa[origen_y][origen_x+2] := i;
     nivel.mapa[origen_y+1][origen_x] := i;
     nivel.mapa[origen_y+1][origen_x+1] := i;
     nivel.mapa[origen_y+1][origen_x+2] := i;
     nivel.mapa[origen_y+1][origen_x+3] := i;

     hubo_cambio := true;
     estado := PD_JUGAR;

     while(estado = PD_JUGAR)do
     begin
          if(keypressed) then
          begin
              tecla := readkey ;
              case tecla of
                   #0 :
                   begin
                        tecla := readkey ; {scancode}
                        case tecla of
                          #75 : estado := PD_VER_INSTRUCCIONES; {izquierda}
                          #77 : estado := PD_VER_HISCORES ; {derecha}
                        end ;
                   end ;
                   #27 : estado := PD_INTRO;
                   'q' : estado := PD_SALIR;
                   'n' : estado := PD_PROXIMO_NIVEL;
              end ;
          end;
          {logica de movimientos}

          if((estado = PD_JUGAR) and hubo_cambio) then
          begin
               if(hubo_cambio)then
                    graficar_nivel(nivel,jugador);
          end;
     end;   }



{
Corre cada uno de los niveles hasta que el jugador muere o abandona.
@retorna t_pantalla La pantalla a la que el usuario quiere acceder
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

