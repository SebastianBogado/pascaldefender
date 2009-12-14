unit pantalla_opciones;

interface

uses
  crt,
  pdcommons,
  graficador,
  lecater,
  subopciones;

function correr_opciones(): t_pantalla;

implementation

var
  tecla_ingresada: char;

function correr_opciones(): t_pantalla;
begin
  graficar_opciones();
  tecla_ingresada := readkey;
  case tecla_ingresada of
    '1': begin cantidad_conjuntos_naves(conjuntos); graficar_conjuntos_naves();  subopcion1(numero_conj_naves) end;
    '2': subopcion2();
    '3': subopcion3();
    '4': subopcion4()
   end;

  correr_opciones := introduccion;
end;


end.

