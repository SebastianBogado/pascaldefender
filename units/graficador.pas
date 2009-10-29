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
procedure graficar_victoria(var jugador:t_jugador);
procedure graficar_derrota();
procedure graficar_prenivel(var nivel:t_nivel);
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

procedure graficar_prenivel(var nivel:t_nivel);
begin
    clrscr();
    writeln('NIVEL ',nivel.numero);
    delay(3000);
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

procedure graficar_victoria(var jugador:t_jugador);
begin
    clrscr();
    writeln('Sos un groso, ', jugador.nombre, '! Ganaste el juego con ',jugador.puntos,' puntos');
    writeln('Presiona una tecla para continuar');
    readkey();
end;

procedure graficar_derrota();
begin
    clrscr();
    writeln('GAME OVER');
    writeln('Presiona una tecla para continuar');
    readkey();
end;

procedure graficar_nivel(var nivel:t_nivel; var jugador:t_jugador);
var
    i,j,k:byte;
    mapa:array[1..ALTURA_MAPA] of string[ANCHO_MAPA];
begin
     for i := 1 to ALTURA_MAPA do
     begin
          mapa[i] := '';
         for j := 1 to ANCHO_MAPA do
             mapa[i] := mapa[i]+' ';
     end;

    gotoxy(1,1);
    cursoroff();
    clreol();
    writeln('Nivel ',nivel.numero,', Puntos ',jugador.puntos,', Vidas ',jugador.vidas);

    clreol();
    writeln();

    for k := nivel.beto.x to nivel.beto.x + ANCHO_BETO - 1 do
        for j := nivel.beto.y to nivel.beto.y + ALTURA_BETO - 1 do
            begin
            mapa[j][k] := 'B';
            end;

    for i := 1 to CANTIDAD_ESCUDOS do
    	if nivel.escudos[i].vivo then
			for k := nivel.escudos[i].x to nivel.escudos[i].x + ANCHO_ESCUDO - 1 do
        		for j := nivel.escudos[i].y to nivel.escudos[i].y + ALTURA_ESCUDO - 1 do
            		mapa[j][k] := 'E';

    for i := 1 to CANTIDAD_ALIENS do
    	if nivel.aliens[i].vivo then
      		for k := nivel.aliens[i].x to nivel.aliens[i].x + ANCHO_ALIEN - 1 do
        		for j := nivel.aliens[i].y to nivel.aliens[i].y + ALTURA_ALIEN - 1 do
             		mapa[j][k] := 'A';

    if nivel.disparo_beto.vivo then
    	mapa[nivel.disparo_beto.y][nivel.disparo_beto.x] := '|';

    for i := 1 to CANTIDAD_DISPAROS_ALIENS do
    	if nivel.disparos_aliens[i].vivo then
			mapa[nivel.disparos_aliens[i].y][nivel.disparos_aliens[i].x] := '|';

    for i := 1 to ALTURA_MAPA do
        writeln(mapa[i]);

    cursoron();
end;

end.

