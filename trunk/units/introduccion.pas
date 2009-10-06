unit introduccion;

interface
function correr_introduccion():byte;

implementation

uses
    crt,
    pdcommons,
    graficador;

function correr_introduccion():byte;
var
   opcion : byte;
   tecla : char;
begin
     writeln('correr intro');
     opcion := PD_INTRO;
     while(opcion = PD_INTRO) do
     begin
          graficar_introduccion();
          tecla := readkey();
          writeln(tecla);
          case tecla of
               '1': opcion := PD_JUGAR;
               '2': opcion := PD_VER_INSTRUCCIONES;
               '3': opcion := PD_VER_HISCORES;
               '0': opcion := PD_SALIR;
          end;
     end;
     correr_introduccion := opcion;
end;

end.

