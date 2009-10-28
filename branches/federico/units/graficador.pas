{Se encarga de toda la representación gráfica del programa}
unit graficador;

interface

uses
    crt,
    puntajes,
    nivel,
    mapa,
    entidad,
    jugador;

procedure graficar_introduccion();
procedure graficar_instrucciones();
procedure graficar_hiscores(cantidad_puntajes:byte; var puntajes:t_puntajes);
procedure graficar_nivel(var nivel:t_nivel; var jugador:t_jugador);
function pedir_nombre():string;

implementation

{
Un procedimiento auxiliar para mostrar el título del programa
}
procedure encabezado();
begin
    writeln('Pascal Defender');
    writeln('===============');
    writeln('La heroica batalla del Capitan Beto');
    writeln();
end;

{
Grafica la pantalla de introducción
}
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

{
Grafica la pantalla con las instrucciones del juego
@todo escribir las instrucciones
}
procedure graficar_instrucciones();
begin
    clrscr();
    encabezado();
    writeln('Instrucciones');
    writeln('Aca van las instrucciones...');
    writeln('');
    writeln('Presione cualquier tecla para volver al inicio.');
end;

{
Muestra en pantalla los puntajes recibidos
@param cantidad_puntajes byte La cantidad de puntajes que tiene el vector de puntajes
@param puntajes t_puntajes El listado de los puntajes a mostrar
}
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

{
Retorna un nombre que el usuario ingresa
@param string El nombre ingresado
@todo implementar el tipo t_nombre?
}
function pedir_nombre():string;
var
    nombre:string;
begin
    clrscr();
    writeln('Hola! Antes de empezar, al Capitan Beto le gustaria saber tu nombre:');
    readln(nombre);
    writeln('Bienvenido ',nombre,'!');
    writeln('Presiona una tecla para continuar');
    readkey();

    pedir_nombre := nombre;
end;

procedure graficar_nivel(var nivel:t_nivel; var jugador:t_jugador);
var
    i,j,k:byte;
    mapa:array[1..ALTURA_MAPA,1..ANCHO_MAPA] of char;
begin
    clrscr();
    gotoxy(1,1);
    cursoroff();
    clreol();
    writeln('Nivel ',nivel.numero,', Puntos ',jugador.puntos,', Vidas ',jugador.vidas);

    clreol();
    writeln();

    for k := nivel.beto.x to nivel.beto.x + ANCHO_BETO do
        for j := nivel.beto.y to nivel.beto.y + ALTURA_BETO do
            begin
            mapa[j,k] := 'B';
            end;

    for i := 1 to ALTURA_MAPA

    cursoron();
end;

end.
