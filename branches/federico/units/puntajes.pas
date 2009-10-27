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
function obtener_cantidad_puntajes() : byte;
procedure guardar_puntaje(var puntaje : t_puntaje );


implementation
{
variables globales, pero privadas
Los puntajes se almacenan globales dentro de la unit, para que el almacenamiento
de los puntajes sea transparente para los desarrolladores que utilicen las
funciones de agregado y obtención de puntajes.
}
var
    mejores_puntajes : t_puntajes;
    cantidad_mejores_puntajes : byte;

{
Devuelve los mejores puntajes almacenados ordenados de mayor a menor.
@returns t_puntajes La lista de los puntajes
@todo implementar!
}
function obtener_puntajes():t_puntajes;
begin

end;

{
Devuelve la cantidad de puntajes almacenados.
@returns byte La cantidad de puntajes
}
function obtener_cantidad_puntajes() : byte;
begin
    obtener_cantidad_puntajes := cantidad_mejores_puntajes;
end;

{
Almacena un puntaje,
@param t_puntajes El puntaje a almacenar
@todo implementar! debe ordenar la lista luego de cada inserción, e incrementar
la variable global cantidad_mejores_puntajes
}
procedure guardar_puntaje(var puntaje : t_puntaje );
begin

end;



begin
{inicializa las variables globales privadas de la unit}
cantidad_mejores_puntajes := 0;
end.
