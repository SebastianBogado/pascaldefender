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

const
     MOSTRAR_PUNT = 12;

  
procedure graficar_introduccion();
procedure graficar_instrucciones();
procedure graficar_opciones();
procedure graficar_victoria(var jugador:t_jugador);
procedure graficar_derrota();
procedure graficar_prenivel(var nivel:t_nivel);
procedure graficar_hiscores(CONSTA:integer);
procedure graficar_felicitaciones(var jugador:t_jugador);
procedure graficar_nivel(var nivel:t_nivel; var jugador:t_jugador);
procedure graficar_nombre( var jugadora:t_jugador);
procedure graficar_conjuntos_naves();
procedure graficar_acercade();
procedure graficar_loginmas();

implementation

var
   beto1, beto2:string [4];
   jugadora:t_jugador;
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
    titulo('----------|La heroica batalla del Capit'+chr(160)+'n Beto|----------',7);
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
    titulo('5. Acerca De',15);
    titulo('0. Salir',16);
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
    titulo('0. Volver al men'+chr(163)+' principal',14);
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
    writeln (chr(168),'Cu',chr(160),'l desea elegir? Se aceptan s',chr(162),'lo opciones num',chr(130),'ricas');
    writeln ('Puede presionar la tecla 0 (cero) para las opciones por defecto');
    writeln
end;

{
Grafica la pantalla con las instrucciones del juego
}
procedure graficar_instrucciones();
begin
    clrscr();
    encabezado();
    titulo('I N S T R U C C I O N E S',9);
    writeln();
    titulo('El objetivo del juego es destruir a todas las naves marcianas.',11);
    titulo('Para mover la nave de Beto, usar las flechas direccionales',13);
    titulo('y D para disparar.',14);
    titulo('Con P se pausa el juego hasta que se presione una tecla cualquiera',15);
    titulo('Los marcianos van avanzando y destruir'+chr(160)+'n la nave del Capit'+chr(160)+'n Beto si',17);
    titulo('entran en contacto',18);
    titulo('El juego termina al pasar tres niveles, o perder las tres vidas.',20);
    titulo('En el primer nivel, cada nave destruida da 10 puntos; en el',22);
    titulo('segundo, 20 puntos y en el tercero, 40. Al ganar, se bonifica al',23);
    titulo('jugador con 1000 puntos. Cada vida perdida descuenta 300 puntos.',24);
    titulo('Presione cualquier tecla para volver al inicio.',26);
end;

procedure graficar_loginmas();
begin
    clrscr();
    encabezado();
	titulo('P R I N C I P A L',10);
	titulo('1.Entrar',13);
	titulo('2.Nuevo Usuario',14);
	titulo('3.Olvide Password',15);
	titulo('0.Salir',16)

end;

procedure graficar_acercade();
begin
    textbackground (5); {colorinches} 
    clrscr();            
    textcolor (128);
    encabezado();
    textcolor (0);
    titulo('Este juego fue desarrollado para el trabajo pr'+chr(160)+'ctico de la c'+chr(160)+'tedra de',9);
    titulo('Algoritmos y Programaci'+chr(162)+'n I, del Ing. Pablo Guarna',10);
    titulo('INTEGRANTES',12);
    titulo('Amarillo, Emilio',13);
    titulo('Bogado, Sebasti'+chr(160)+'n',14);
    titulo('Cingolani, Federico',15);
    titulo('Knack, Iv'+chr(160)+'n',16);
    titulo('Sol'+chr(160)+', Rub'+chr(130)+'n',17);
    titulo('Un agradecimiento especial a Mart'+chr(161)+'n Lebuchorskyj,',19);
    titulo('por su paciencia y dedicaci'+chr(162)+'n',20);
    titulo('@COPYLEFT 2009',23);
    titulo('Presione una tecla para volver',25);
    textbackground (0);
    textcolor(15);

end;

{
Muestra en pantalla los puntajes recibidos
@param cantidad_puntajes byte La cantidad de puntajes que tiene el vector de puntajes
@param puntajes t_puntajes El listado de los puntajes a mostrar
}
procedure graficar_hiscores(CONSTA:integer);
var
    i:byte;
begin
    clrscr();
    encabezado();
    titulo('Puntajes R'+chr(130)+'cord',9);
    writeln();

    mostrar_puntajes (CONSTA);
    
    writeln();
    writeln('Presione cualquier tecla para volver al inicio.');
end;

procedure graficar_prenivel(var nivel:t_nivel);
var
	segundos:byte;
    auxs,auxi,auxi2,auxs2:string;
begin
    cursoroff();
    clrscr();

    str (nivel.numero,auxi);
    auxs:= 'Nivel ' + auxi;
    titulo (auxs,11);
    segundos := 3;
    while segundos > 0 do
    begin
    	clreol();
        str (segundos,auxi2);
        auxs2 := 'Arranca en ' + auxi2 + 's';
        titulo (auxs2,15);
    	delay(1000 {1 segundo});
    	dec(segundos);
    end;

    cursoron();
end;

{
GRAFICAR SALUTACION
}
procedure graficar_nombre( var jugadora:t_jugador);
var
    nombre,auxs,cortes:string;

begin
    clrscr();
    inicializar_jugador (jugadora);
    nombre:= jugadora.nombre;
    case nombre[length(nombre)] of
    'A' : cortes :='a ';
    'a' : cortes :='a ';
    else
        cortes:='o '
    end;
    auxs:= chr(173)+'Bienvenid' + cortes + nombre + '!';
    titulo (auxs,7);
    readkey();
    titulo(chr(173)+'El Capit'+chr(160)+'n Beto te pide tu ayuda!',13);
    titulo ('Juntos, '+chr(173)+'vamos a destruir a los malvados alien'+chr(161)+'genas!',14);
    titulo ('Presiona ENTER para continuar',20);
    readkey();
end;
{


}
procedure graficar_victoria(var jugador:t_jugador);
var
   mensaje_felicitacion : string;
    cad_puntaje : string[4];
begin
    clrscr();
    str(jugador.puntos, cad_puntaje);
    mensaje_felicitacion := chr(173)+'Sos un groso, ' + jugador.nombre + '! Ganaste el juego con ' + cad_puntaje + ' puntos';
    titulo(mensaje_felicitacion,10);
    titulo('Presiona ENTER para continuar',11);
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
var mensaje_felicitacion : string[80];
    cad_puntaje : string[4];
begin
    clrscr();
    str(jugador.puntos, cad_puntaje);
    mensaje_felicitacion := 'Felicitaciones, ' + jugador.nombre + ', con tus ' + cad_puntaje + ' puntos '+chr(173)+'lograste un nuevo HiScore!';
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



begin
naves_por_defecto(vnaves);   {inicializa las naves por defecto}
end.
