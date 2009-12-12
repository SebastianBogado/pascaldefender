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
procedure graficar_opciones();
{@todo implementar
procedure graficar_opciones_juego();
procedure graficar_modificacion_datos();
procedure graficar_baja_usuario();
procedure graficar_login();
procedure graficar_modificacion_datos();
}
procedure graficar_victoria(var jugador:t_jugador);
procedure graficar_derrota();
procedure graficar_prenivel(var nivel:t_nivel);
procedure graficar_hiscores(cantidad_puntajes:byte; var puntajes:t_puntajes);
procedure graficar_felicitaciones(var jugador:t_jugador);
procedure graficar_nivel(var nivel:t_nivel; var jugador:t_jugador);
function pedir_nombre():string;

implementation

{
Un procedimiento auxiliar para centrar líneas de texto
}

procedure titulo (titulo:string; y:integer);
begin
	gotoxy(trunc((80/2)-(length(titulo))/2),y);
	write(titulo);
end;

{
Un procedimiento auxiliar para mostrar el título del programa
}
procedure encabezado();
begin
    titulo('______                   _  ______      __               _           ',1);
    titulo('| ___ \                 | | |  _  \    / _|             | |          ',2);
    titulo('| |_/ /_ _ ___  ___ __ _| | | | | |___| |_ ___ _ __   __| | ___ _ __ ',3);
    titulo('|  __/ _` / __|/ __/ _` | | | | | / _ \  _/ _ \  _ \ / _` |/ _ \  __|',4);
    titulo('| | | (_| \__ \ (_| (_| | | | |/ /  __/ ||  __/ | | | (_| |  __/ |   ',5);
    titulo('\_|  \__,_|___/\___\__,_|_| |___/ \___|_| \___|_| |_|\__,_|\___|_|   ',6);
    titulo('----------|La heroica batalla del Capitan Beto|----------',7);
    writeln();
end;

{
Grafica la pantalla de introducción
}
procedure graficar_introduccion();
begin
    clrscr();
    encabezado();
    titulo('1. Jugar',11);
    titulo('2. Instrucciones',12);
    titulo('3. High Scores',13);
    titulo('4. Opciones',14);
    titulo('0. Salir',15);
end;

{
Grafica la pantalla con las opciones del juego
}
procedure graficar_opciones();


begin
    clrscr();
    encabezado(); writeln;
    titulo('1. Elegir skin de naves',10);
    titulo('2. Modificar datos',11);
    titulo('3. Baja del usuario',12);
    titulo('4. Cambiar de usuario',13);
    titulo('0. Volver al menu principal',14);
{
Grafica la pantalla con las instrucciones del juego
}
procedure graficar_instrucciones();
begin
    clrscr();
    encabezado();
    titulo('Instrucciones',9);
    writeln();
    writeln('El objetivo del juego es destruir a todas las naves marcianas. ');
    writeln();
    writeln('El juego termina al pasar tres niveles, o perder tres vidas.');
    writeln();
    writeln('Para mover la nave de Beto, usar las flechas laterales para moverse');
    writeln('y D para disparar.');
    writeln();
    writeln('Con P se pausa el juego hasta que se presione una tecla');
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
    titulo('Puntajes Record',9);
    writeln;
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
    titulo('GAME OVER',10);
    titulo('Presiona ENTER para continuar',11);
    readln();
end;


procedure graficar_felicitaciones(var jugador:t_jugador);
begin
    clrscr();
    writeln('Felicitaciones, ', jugador.nombre, ', con tus ', jugador.puntos, ' puntos lograste un nuevo HiScore!');
    writeln('Presiona ENTER para continuar');
    readln();
end;

procedure pisar_string(pos:byte; origen:string; var dst:string);
var
	i:byte;
begin
	for i:= 0 to length(origen)-1 do
    begin
        dst[i+pos] := origen[i+1];
    end;
end;

procedure graficar_nivel(var nivel:t_nivel; var jugador:t_jugador);
var
    i,j,k:byte;
    mapa:array[1..ALTURA_MAPA] of string[ANCHO_MAPA];
begin
	{vacío el mapa}
     for i := 1 to ALTURA_MAPA do
     begin
         mapa[i] := ''; 
         for j := 1 to ANCHO_MAPA do
             mapa[i] := mapa[i]+' ';
     end;

    gotoxy(1,1);
    cursoroff();

    {cabecera}
    clreol();
    writeln('Nivel ',nivel.numero,', Puntos ',jugador.puntos,', Vidas ',jugador.vidas);

    clreol();
    writeln();

    {dibujar disparo Beto}
    if nivel.disparo_beto.vivo then
    	mapa[nivel.disparo_beto.y][nivel.disparo_beto.x] := 'I';

    {dibujar disparos aliens}
    for i := 1 to CANTIDAD_DISPAROS_ALIENS do
    	if nivel.disparos_aliens[i].vivo then
			mapa[nivel.disparos_aliens[i].y][nivel.disparos_aliens[i].x] := '!';

    {dibujo a Beto}
    pisar_string(nivel.beto.x, '.A.', mapa[nivel.beto.y]);
    pisar_string(nivel.beto.x, 'IMI', mapa[nivel.beto.y+1]);

    {dibujar escudos}                             
    for i := 1 to CANTIDAD_ESCUDOS do
    	if nivel.escudos[i].vivo then
			for k := nivel.escudos[i].x to nivel.escudos[i].x + ANCHO_ESCUDO - 1 do
        		for j := nivel.escudos[i].y to nivel.escudos[i].y + ALTURA_ESCUDO - 1 do
            		mapa[j][k] := '#';

	{dibujar aliens}
    for i := 1 to CANTIDAD_ALIENS do
    	if nivel.aliens[i].vivo then
      		for k := nivel.aliens[i].x to nivel.aliens[i].x + nivel.ancho_alien - 1 do
        		for j := nivel.aliens[i].y to nivel.aliens[i].y + ALTURA_ALIEN - 1 do
                begin
                	if nivel.numero = 1 then
                    	if (k = nivel.aliens[i].x) then
    						if (j = nivel.aliens[i].y) then
                 				mapa[j][k] := 'q'
                            else
                            	mapa[j][k] := '\'
                        else if (k = nivel.aliens[i].x + nivel.ancho_alien - 1) then
                            if (j = nivel.aliens[i].y) then
                 				mapa[j][k] := 'p'
                            else
                            	mapa[j][k] := '/'
                        else
                        	if (j = nivel.aliens[i].y + ALTURA_ALIEN - 1) then
                 				mapa[j][k] := 'V'
                            else
                            	mapa[j][k] := 'w'
                    else if (nivel.numero = 2) then
                    	if (k = nivel.aliens[i].x) then
    						if (j = nivel.aliens[i].y) then
                 				mapa[j][k] := '<'
                            else
                            	mapa[j][k] := '|'
                        else if (k = nivel.aliens[i].x + nivel.ancho_alien - 1) then
                            if (j = nivel.aliens[i].y) then
                 				mapa[j][k] := '>'
                            else
                            	mapa[j][k] := '|'
                        else
                        	if (j = nivel.aliens[i].y + ALTURA_ALIEN - 1) then
                 				mapa[j][k] := 'Y'
                            else
                            	mapa[j][k] := 'X'
                    else
                    	if (k = nivel.aliens[i].x) then
    						if (j = nivel.aliens[i].y) then
                 				mapa[j][k] := 'W'
                            else
                            	mapa[j][k] := 'Y'
                        else if (k = nivel.aliens[i].x + nivel.ancho_alien - 1) then
                            if (j = nivel.aliens[i].y) then
                 				mapa[j][k] := 'W'
                            else
                            	mapa[j][k] := 'Y'
                        else
                        	if (j = nivel.aliens[i].y + ALTURA_ALIEN - 1) then
                 				mapa[j][k] := '='
                            else
                            	mapa[j][k] := '8';
                end;

    for i := 1 to ALTURA_MAPA do
        writeln('|',mapa[i],'|');

    cursoron();
end;

end.

