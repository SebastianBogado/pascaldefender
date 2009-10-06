unit introduccion;

interface
function correr_introduccion():byte;

implementation

uses
    pdcommons,
    puntajes;

function correr_introduccion():byte;
begin
     writeln('esto es la introduccion');
     correr_introduccion := PD_JUGAR;
end;

end.

