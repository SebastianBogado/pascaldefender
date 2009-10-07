unit puntajes;

interface

const
     MAX_PUNTAJES = 20;

type
    t_puntaje = Record
              nombre : string;
              puntos : integer;
    end;
    t_puntajes = Array [1..MAX_PUNTAJES] of t_puntaje;

function obtener_puntajes():t_puntajes;
procedure guardar_puntaje(var puntaje : t_puntaje );

function obtener_cantidad_puntajes() : byte;


implementation

var
   mejores_puntajes : t_puntajes;
   cantidad_mejores_puntajes : byte;

function obtener_puntajes():t_puntajes;
begin

end;

procedure guardar_puntaje(var puntaje : t_puntaje );
begin

end;

function obtener_cantidad_puntajes() : byte;
begin
    obtener_cantidad_puntajes := cantidad_mejores_puntajes;
end;

begin

cantidad_mejores_puntajes := 0;

end.

