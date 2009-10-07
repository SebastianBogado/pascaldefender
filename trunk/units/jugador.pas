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

procedure inicializar_jugador(var jugador:t_jugador);
begin
     jugador.nombre := '';
     jugador.puntos := 0;
     jugador.vidas  := 3;
end;

end.

