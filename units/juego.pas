unit juego;

interface
function correr_juego():byte;

implementation

uses
    pdcommons,
    puntajes;

function correr_juego():byte;
begin
     writeln('esto es el juego');
     correr_juego := PD_SALIR;
end;

end.

