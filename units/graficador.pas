{Se encarga de toda la representación gráfica del programa}
unit graficador;

interface

uses
    crt,
    puntajes,
    nivel,
    mapa,
    entidad,
    jugador,
    lecater,
    subopciones;


procedure graficar_introduccion();
procedure graficar_instrucciones();
procedure graficar_opciones();
procedure graficar_victoria(var jugador:t_jugador);
procedure graficar_derrota();
procedure graficar_prenivel(var nivel:t_nivel);
procedure graficar_hiscores(cantidad_puntajes:byte; var puntajes:t_puntajes);
procedure graficar_felicitaciones(var jugador:t_jugador);
procedure graficar_nivel(var nivel:t_nivel; var jugador:t_jugador);
function pedir_nombre():string;
procedure graficar_conjuntos_naves();

implementation

var
   beto1, beto2:string [4];
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
end;

{
Grafica la pantalla con las opciones del juego
}
procedure graficar_conjuntos_naves();

begin
    clrscr();
    encabezado(); writeln;
    writeln;     writeln;     writeln;
    writeln ('Usted puede elegir ', conjuntos, ' skins de naves');
    writeln ('Cual desea elegir? Se aceptan solo opciones numericas');
    writeln ('Puede presionar la tecla 0 (cero) para las opciones por defecto')
end;

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
}
function pedir_nombre():string;
var
    nombre,auxs:string;

begin
    clrscr();
    titulo('Hola! Antes de empezar, al Capitan Beto le gustaria saber tu nombre:',4);
    write('                                                         '); read(nombre);
    auxs:= 'Bienvenido ' + nombre + '!';
    titulo (auxs,9);
    titulo ('Presiona ENTER para continuar',11);
    readkey();

    pedir_nombre := nombre;
end;

procedure graficar_victoria(var jugador:t_jugador);
var mensaje_felicitacion : string[80];
    cad_puntaje : string[4];
begin
    clrscr();
    str(jugador.puntos, cad_puntaje);
    mensaje_felicitacion := 'Sos un groso, ' + jugador.nombre + '! Ganaste el juego con ' + cad_puntaje + ' puntos';
    titulo(mensaje_felicitacion,10);
    titulo('Presiona ENTER para continuar',11);
    readln();
    readln();
end;

procedure graficar_derrota();
begin
    clrscr();
    titulo('GAME OVER',10);
    titulo('Presiona ENTER para continuar',11);
    readln();
    readln(); 
end;


procedure graficar_felicitaciones(var jugador:t_jugador);
var mensaje_felicitacion : string[80];
    cad_puntaje : string[4];
begin
    clrscr();
    str(jugador.puntos, cad_puntaje);
    mensaje_felicitacion := 'Felicitaciones, ' + jugador.nombre + ', con tus ' + cad_puntaje + ' puntos lograste un nuevo HiScore!';
    titulo(mensaje_felicitacion,10);
    titulo('Presiona ENTER para continuar',11);
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
    naves_por_defecto(vnaves);
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

    procesar_skins (vnaves, renglado);
    {dibujo a Beto}
    beto1:= vnaves[numero_conj_naves].beto[1,1] + vnaves[numero_conj_naves].beto[1,2] + vnaves[numero_conj_naves].beto[1,3];
    beto2:= vnaves[numero_conj_naves].beto[2,1] + vnaves[numero_conj_naves].beto[2,2] + vnaves[numero_conj_naves].beto[2,3];
    pisar_string(nivel.beto.x, beto1, mapa[nivel.beto.y]);
    pisar_string(nivel.beto.x, beto2, mapa[nivel.beto.y+1]);

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
                 				mapa[j][k] := vnaves[numero_conj_naves].naven1[1,1]
                            else
                            	mapa[j][k] := vnaves[numero_conj_naves].naven1[2,1]
                        else if (k = nivel.aliens[i].x + nivel.ancho_alien - 1) then
                            if (j = nivel.aliens[i].y) then
                 				mapa[j][k] := vnaves[numero_conj_naves].naven1[1,3]
                            else
                            	mapa[j][k] := vnaves[numero_conj_naves].naven1[2,3]
                        else
                        	if (j = nivel.aliens[i].y + ALTURA_ALIEN - 1) then
                 				mapa[j][k] := vnaves[numero_conj_naves].naven1[2,2]
                            else
                            	mapa[j][k] := vnaves[numero_conj_naves].naven1[1,2]
                    else if (nivel.numero = 2) then
                    	if (k = nivel.aliens[i].x) then
    						if (j = nivel.aliens[i].y) then
                 				mapa[j][k] := vnaves[numero_conj_naves].naven2[1,1]
                            else
                            	mapa[j][k] := vnaves[numero_conj_naves].naven2[2,1]
                        else if (k = nivel.aliens[i].x + nivel.ancho_alien - 1) then
                            if (j = nivel.aliens[i].y) then
                 				mapa[j][k] := vnaves[numero_conj_naves].naven2[1,3]
                            else
                            	mapa[j][k] := vnaves[numero_conj_naves].naven2[2,3]
                        else
                        	if (j = nivel.aliens[i].y + ALTURA_ALIEN - 1) then
                 				mapa[j][k] := vnaves[numero_conj_naves].naven2[2,2]
                            else
                            	mapa[j][k] := vnaves[numero_conj_naves].naven2[1,2]
                    else
                    	if (k = nivel.aliens[i].x) then
    						if (j = nivel.aliens[i].y) then
                 				mapa[j][k] := vnaves[numero_conj_naves].naven3[1,1]
                            else
                            	mapa[j][k] := vnaves[numero_conj_naves].naven3[2,1]
                        else if (k = nivel.aliens[i].x + nivel.ancho_alien - 1) then
                            if (j = nivel.aliens[i].y) then
                 				mapa[j][k] := vnaves[numero_conj_naves].naven3[1,3]
                            else
                            	mapa[j][k] := vnaves[numero_conj_naves].naven3[2,3]
                        else
                        	if (j = nivel.aliens[i].y + ALTURA_ALIEN - 1) then
                 				mapa[j][k] := vnaves[numero_conj_naves].naven3[2,2]
                            else
                            	mapa[j][k] := vnaves[numero_conj_naves].naven3[1,2];
                end;

    for i := 1 to ALTURA_MAPA do
        writeln('|',mapa[i],'|');

    cursoron();
end;

end.

