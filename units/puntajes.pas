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
function intentar_guardar_puntaje(var puntaje:t_puntaje):boolean;
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
}
function obtener_puntajes():t_puntajes;
begin
    obtener_puntajes := mejores_puntajes;
end;

{
Devuelve la cantidad de puntajes almacenados.
@returns byte La cantidad de puntajes
}
function obtener_cantidad_puntajes() : byte;
begin
    obtener_cantidad_puntajes := cantidad_mejores_puntajes;
end;



procedure swap(var a : t_puntaje; var b : t_puntaje);
var
    aux : t_puntaje;
begin
    aux := a;
    a := b;
    b := aux;
end;

{
Almacena un puntaje, Ordena la lista luego de cada inserción, e incrementa
la variable global cantidad_mejores_puntajes
@param t_puntajes El puntaje a almacenar
}
procedure guardar_puntaje(var puntaje : t_puntaje );
var
   i : byte;
   mayor : boolean;
begin
    inc(cantidad_mejores_puntajes);
    i := cantidad_mejores_puntajes;
    mejores_puntajes[i].nombre := puntaje.nombre;
    mejores_puntajes[i].puntos := puntaje.puntos;
    mayor := true;
    while ((mayor) and (i > 1)) do
          if (mejores_puntajes[i].puntos) > (mejores_puntajes[i-1].puntos) then
             begin
                  swap(mejores_puntajes[i],mejores_puntajes[i-1]);
                  dec(i);
             end
             else
                 mayor := false;
end;

{

}
function intentar_guardar_puntaje(var puntaje:t_puntaje):boolean;
var
	grabo:boolean;
begin
	grabo := false;
	{si hay slots disponibles, o es mejor puntaje que el último}
	if	(cantidad_mejores_puntajes < MAX_PUNTAJES)
    	or (puntaje.puntos > mejores_puntajes[cantidad_mejores_puntajes].puntos) then
        begin
            grabo := true;
            guardar_puntaje(puntaje);
        end;

	intentar_guardar_puntaje := grabo;
end;



begin
{inicializa las variables globales privadas de la unit}
cantidad_mejores_puntajes := 0;
end.

