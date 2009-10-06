unit graficador;

interface

uses
    crt,
    puntajes;

procedure graficar_introduccion();
procedure graficar_instrucciones();
procedure graficar_hiscores(cantidad_puntajes:byte; var puntajes:t_puntajes);

implementation

procedure encabezado();
begin
    writeln('Pascal Defender');
    writeln('===============');
    writeln('La heroica batalla del Capitan Beto');
    writeln();
end;

procedure graficar_introduccion();
begin
     clrscr();
     encabezado();
     writeln('Seleccione una opcion:');
     writeln('1. Jugar');
     writeln('2. Instrucciones');
     writeln('3. High Scores');
     writeln('0. Salir');
end;

procedure graficar_instrucciones();
begin
     clrscr();
     encabezado();
     writeln('Instrucciones');
     writeln('Aca van las instrucciones...');
     writeln('');
     writeln('Presione cualquier tecla para volver al inicio.');
end;

procedure graficar_hiscores(cantidad_puntajes:byte; var puntajes:t_puntajes);
var
   i:byte;
begin
     clrscr();
     encabezado();
     writeln('Puntajes Record');
     writeln('Hay ',cantidad_puntajes,' puntajes record registrados');

     for i := 1 to cantidad_puntajes do
         writeln(i,' - ',puntajes[i].puntos,' ',puntajes[i].nombre);

     writeln('');
     writeln('Presione cualquier tecla para volver al inicio.');
end;


end.

