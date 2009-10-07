unit mapa;

interface

uses
    entidad;

const
     COLUMNAS_MAPA = 70;
     FILAS_MAPA = 20;

type
    t_fila_mapa = Array [1..COLUMNAS_MAPA] of t_id_entidad;
    t_mapa = Array [1..FILAS_MAPA] of t_fila_mapa;

procedure inicializar_mapa(var mapa:t_mapa);


implementation

procedure inicializar_mapa(var mapa:t_mapa);
var
   i,j:byte;
begin
     for i := 1 to FILAS_MAPA do
         for j := 1 to COLUMNAS_MAPA do
             mapa[i][j] := 0;
end;

end.

