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
procedure graficar_felicitaciones(var jugador:t_jugador);
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
    writeln();
    writeln('El objetivo del juego es destruir a todas las naves marcianas. ');
    writeln();
    writeln('El juego termina al pasar tres niveles, o perder tres vidas.');
    writeln();
    writeln('Para mover la nave de Beto, usar las flechas laterales para moverse');
    writeln('y D para disparar');
    writeln();
    writeln('Los marcianos van avanzando y destruiran la nave del Capitan si ');
    writeln('entran en contacto');
    writeln();
    writeln('En el primer nivel, cada nave destruida da 10 puntos; en el ');
    writeln('segundo, 20 puntos y en el tercero, 40. Al ganar, se bonifica al ');
    writeln('jugador con 1000 puntos. Cada vida perdida descuenta 300 puntos.');
    writeln();
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
        writeln('#', i,' - ',puntajes[i].puntos,' ',puntajes[i].nombre);

    writeln('');
    writeln('Presione cualquier tecla para volver al inicio.');
end;

procedure graficar_prenivel(var nivel:t_nivel);
var
	segundos:byte;
begin
	cursoroff();
    clrscr();
    writeln('Nivel ',nivel.numero);

    segundos := 3;
    while segundos > 0 do
    begin
    	gotoxy(1,2);
    	clreol();
        write('Arranca en ',segundos,'s');
    	delay(1000 {1 segundo});
    	dec(segundos);
    end;
    cursoron();
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
    writeln('Presiona ENTER para continuar');
    readln();

    pedir_nombre := nombre;
end;

procedure graficar_victoria(var jugador:t_jugador);
begin
    clrscr();
    writeln('Sos un groso, ', jugador.nombre, '! Ganaste el juego con ',jugador.puntos,' puntos');
    writeln('Presiona ENTER para continuar');
    readln();
end;

procedure graficar_derrota();
begin
    clrscr();
    writeln('GAME OVER');
    writeln('Presiona ENTER para continuar');
    readln();
end;


procedure graficar_felicitaciones(var jugador:t_jugador);
begin
    clrscr();
    writeln('Felicitaciones, ', jugador.nombre, ', con tus ', jugador.puntos, ' puntos lograste un nuevo HiScore!');
    writeln('Presiona ENTER para continuar');
    readln();
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

