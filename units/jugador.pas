unit jugador;

interface

type
    t_jugador = Record
              nombre : string;
              puntos : integer;
              vidas : byte;
    end;

procedure inicializar_jugador(var jugador:t_jugador);


implementation

{
Inicializa el jugador con valores predeterminados.
@param jugador t_jugador El jugador a inicializar.
}
procedure inicializar_jugador(var jugador:t_jugador);
begin
     jugador.nombre := 'Jugador';
     jugador.puntos := 0;
     jugador.vidas  := 3;
end;

end.

