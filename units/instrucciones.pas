unit instrucciones;

interface
function correr_instrucciones():byte;

implementation

uses
    crt,
    pdcommons,
    graficador;

function correr_instrucciones():byte;
begin
     graficar_instrucciones();
     readkey();
     correr_instrucciones := PD_INTRO;
end;

end.

