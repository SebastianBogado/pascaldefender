unit pantalla_acercade;

interface

uses
    crt,
    pdcommons,
    graficador;

function correr_acercade():t_pantalla;


implementation

function correr_acercade():t_pantalla;
begin
    graficar_acercade();
    readkey();

    correr_acercade := introduccion;
end;

end.

