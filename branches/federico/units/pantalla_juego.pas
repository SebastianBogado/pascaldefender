unit pantalla_juego;

interface

uses
    crt,
    sysutils,
    dateutils,
    pdcommons,
    puntajes,
    nivel,
    jugador,
    entidad,
    mapa,
    graficador;

function correr_juego():t_pantalla;


implementation

const
    CANTIDAD_NIVELES = 3;

{
Crea un jugador y lo inicializa con un nombre pedido al usuario
@return t_jugador EL jugador creado.
}
function crear_jugador():t_jugador;
var
    jugador:t_jugador;
begin
    inicializar_jugador(jugador);
    jugador.nombre := pedir_nombre();

    crear_jugador := jugador;
end;


{
Crea las entidades para un nivel
@param nivel t_nivel El nivel sobre el cual se van a crear las entidades
}
procedure crear_entidades_nivel(var nivel:t_nivel);
var
    i,j,k,espacio:byte;
    x_refugio,y_refugio:byte;
begin
  {crear beto}
  nivel.beto.x := (ANCHO_MAPA-ANCHO_BETO) div 2; {en el "medio"}
  nivel.beto.y := ALTURA_MAPA - ALTURA_BETO + 1; {sobre el borde inf.}

  {crear refugios}
  y_refugio := nivel.beto.y - ALTURA_REFUGIO - 1; {estan 1 casillero por arriba de beto}
  espacio := (ANCHO_MAPA - CANTIDAD_REFUGIOS * ANCHO_REFUGIO) div (CANTIDAD_REFUGIOS+1); {el espaciado entre refugios}
  for  i := 1 to CANTIDAD_REFUGIOS do
  begin
    x_refugio := (i-1)*ANCHO_REFUGIO+i*espacio;
    {crear escudos. cada refugio se compone de escudos independientes, lo que facilita romperlos de a poco}
    for j := 1 to ESCUDOS_POR_REFUGIO do
    begin
        k := ((i-1)*ESCUDOS_POR_REFUGIO)+j; {auxiliar}
        {ordenamos en rectangulos}        
        nivel.escudos[k].x := x_refugio + ((k-1) mod ANCHO_REFUGIO);
        nivel.escudos[k].y := y_refugio + ((j-1) div ANCHO_REFUGIO);
                               
        if	(nivel.escudos[k].y >= (y_refugio + (ALTURA_REFUGIO div 2) ))
        	and (nivel.escudos[k].x >= (x_refugio + (ANCHO_REFUGIO div 3)))
	        and (nivel.escudos[k].x < (x_refugio + ANCHO_REFUGIO - (ANCHO_REFUGIO div 3))) then
        	nivel.escudos[k].vivo := false;
    end;
  end;

  {crear aliens}
  for i := 1 to CANTIDAD_ALIENS do
  begin
    {esto los acomoda de filas de ALIENS_POR_FILA naves cada una}
    nivel.aliens[i].x := 1 + ((i-1) mod ALIENS_POR_FILA)*(nivel.ancho_alien+1);
    nivel.aliens[i].y := 1 + ((i-1) div ALIENS_POR_FILA)*(ALTURA_ALIEN+1);
  end;
  nivel.direccion_aliens := -1; {arrancan hacia la izquierda}

  nivel.disparo_beto.vivo := false; {el unico disparo de beto arranca inactivo}

  {todos los disparos aliens arrancan inactivos}
  for i:=1 to CANTIDAD_DISPAROS_ALIENS do
	nivel.disparos_aliens[i].vivo := false;

end;

{
Interpreta los comandos del usuario. Puede mover a Beto, disparar, o salir del juego
@param nivel t_nivel El nivel en juego
@param jugador t_jugador El jugador que esta jugando
@return boolean False si el jugador desea salir, sino, True.
}
function jugar_turno_beto(var nivel:t_nivel; var jugador:t_jugador):boolean;
var
	direccion_beto:integer; {dirección del movimiento sobre eje x}
    seguir_jugando:boolean;
begin
	direccion_beto := 0; {beto no se mueve}
    seguir_jugando := true;

    {beto se mueve cada 0.1s}
	if millisecondspan(nivel.inicio_turno, nivel.inicio_turno_beto) > 100 then
    begin
    nivel.inicio_turno_beto := now();


    	if keypressed() then
    	begin
            case readkey() of
                #0: begin
    				case readkey() of
    					#75 {flecha izq}: direccion_beto := -1;
                        #77 {flecha der}: direccion_beto := 1;
    				end;
    			end;
                'd': begin
                	{disparar si no hay un disparo en curso}
                	if not nivel.disparo_beto.vivo then
                    begin
    	                nivel.disparo_beto.vivo := true;
                        {posicionar el disparo}
    					nivel.disparo_beto.x := nivel.beto.x + (ANCHO_BETO div 2);
        	            nivel.disparo_beto.y := nivel.beto.y;
                    end;
                end;
                'q': seguir_jugando := false; {abandonar la partida}
                'p': readkey(); {pausa. espera otra tecla, para continuar}
    		end;
    	end;

        {mover a Beto, sin pasarnos de los bordes}
        if ((direccion_beto = 1) and (nivel.beto.x + ANCHO_BETO < ANCHO_MAPA))
        	or ((direccion_beto = -1) and (nivel.beto.x > 1)) then
        	nivel.beto.x := nivel.beto.x + direccion_beto;


    end;

 jugar_turno_beto := seguir_jugando;
end;


{
Mueve los aliens, y efectua disparos al azar
@param nivel t_nivel El nivel en juego
@param jugador t_jugador El jugador que esta jugando
}
procedure jugar_turno_alien(var nivel:t_nivel; var jugador:t_jugador);
var
	se_disparo:boolean;
	x_extremo:byte;
    i,j:integer;
begin
	{los aliens se mueven a cada nivel más rápido}
	if millisecondspan(nivel.inicio_turno, nivel.inicio_turno_aliens) > (1000 div nivel.numero) then
    begin
    nivel.inicio_turno_aliens := now();

        {MOVIMIENTO ALIENIGENA}
    	if (nivel.direccion_aliens > 0) then
        {la flota se mueve a la derecha}
        begin
    		x_extremo := x_alien_extremo_der(nivel);
        	if (x_extremo + nivel.ancho_alien) <= ANCHO_MAPA then
            {la flota no toca el borde derecho, muevo todos}
    		begin
    	    	for i := 1 to CANTIDAD_ALIENS do
      				nivel.aliens[i].x := nivel.aliens[i].x + nivel.direccion_aliens;
    		end
            else
            begin
            {están en el borde derecho, bajan e invierten direcion}
            	{si no están abajo de todo...}
            	if (y_alien_extremo_inf(nivel) + ALTURA_ALIEN) < ALTURA_MAPA then
    	        	for i := 1 to CANTIDAD_ALIENS do
      					inc(nivel.aliens[i].y);

                nivel.direccion_aliens := nivel.direccion_aliens * -1;
            end;
        end
        else if (nivel.direccion_aliens < 0) then
        {la flota se mueve a la izquierda}
        begin
        	x_extremo := x_alien_extremo_izq(nivel);
        	if x_extremo > 1 then
            {la flota no toca el borde izquierdo, muevo todos}
    		begin
    	    	for i := 1 to CANTIDAD_ALIENS do
      				nivel.aliens[i].x := nivel.aliens[i].x + nivel.direccion_aliens;
    		end
            else
    	        {están en el borde izquierdo, invierten direcion}
                nivel.direccion_aliens := nivel.direccion_aliens * -1;
        end;

        {DISPARO ALIEN ALEATORIO}
        se_disparo := false; {vamos a permitir un solo disparo de la flota por turno}
        i:=1;
        while not se_disparo and (i <= CANTIDAD_DISPAROS_ALIENS) do
        begin
        	{si el disparo no esta activo, y los dados lo indican, disparamos}
        	if (not nivel.disparos_aliens[i].vivo) and (random(5) = 1) then
           	begin
                {hay que disparar... pero hay que elegir quién, agarramos un alien al azar}
                se_disparo := true;
                j:= random(CANTIDAD_ALIENS) + 1;

                {buscamos un alien vivo, y que esté abajo}
                while (not nivel.aliens[j].vivo) or (nivel.aliens[j].y < y_alien_extremo_inf(nivel)) do
    	            j:= random(CANTIDAD_ALIENS) + 1;


    			nivel.disparos_aliens[i].vivo := true;

                {posicionamos el disparo}
                nivel.disparos_aliens[i].x := nivel.aliens[j].x + (nivel.ancho_alien div 2);
                nivel.disparos_aliens[i].y := nivel.aliens[j].y + ALTURA_ALIEN - 1;
            end;
            inc(i);
        end;


    end;
end;


{
Mueve todos los disparos, y realiza la lógica de colisiones
@param nivel t_nivel El nivel en juego
@param jugador t_jugador El jugador que esta jugando
}
procedure jugar_turno_mundo(var nivel:t_nivel; var jugador:t_jugador);
var
    i,j:integer;
begin
	{MOVIMIENTO DE DISPAROS}

    {el disparo de beto siempre se mueve a la misma velocidad}
	if millisecondspan(nivel.inicio_turno, nivel.inicio_disparo_beto) > 100 then
    begin
    	nivel.inicio_disparo_beto := now();
     	{si el disparo de Beto está activo, se mueve. Si toca el borde, se desactiva}
    	if nivel.disparo_beto.vivo then
        	if nivel.disparo_beto.y > 0 then
        		dec(nivel.disparo_beto.y)
            else
            	nivel.disparo_beto.vivo := false;
	end;

	{los disparos aliens se mueven a cada nivel más rápido}
	if millisecondspan(nivel.inicio_turno, nivel.inicio_disparos_aliens) > (250 div nivel.numero) then
    begin
	    nivel.inicio_disparos_aliens := now();
    	{idem al disparo de Beto, pero para cada disparo alienígena}
    	for i:=1 to CANTIDAD_DISPAROS_ALIENS do
        	if nivel.disparos_aliens[i].vivo then
        		if nivel.disparos_aliens[i].y < ALTURA_MAPA then
            		inc(nivel.disparos_aliens[i].y)
                else
                	nivel.disparos_aliens[i].vivo := false;
    end;



 	{LOGICA DE COLISIONES}
    {
    hay 3 tipos de colisiones:
    1) puntos vs puntos
    	si tienen identicas coordenadas, colisionan
    2) puntos vs áreas
    	si el punto está por afuera del área, no colisionan
    3) áreas vs áreas
    	si las áreas se solapan, colisionan
    }

    {disparos aliens vs disparo beto}
    {los disparos son "puntos" en el espacio}
    i := 1;
    while nivel.disparo_beto.vivo and (i <= CANTIDAD_DISPAROS_ALIENS) do
    begin
       	if 	nivel.disparos_aliens[i].vivo
        	and (nivel.disparo_beto.x = nivel.disparos_aliens[i].x)
            and (nivel.disparo_beto.y >= nivel.disparos_aliens[i].y)  then
		begin
        	{hay colisión, se destruyen los dos}
			nivel.disparo_beto.vivo := false;
            nivel.disparos_aliens[i].vivo := false;
		end;
        inc(i);
	end;

    {disparo beto vs escudos}
    {los disparos y los escudos son "puntos" en el espacio}
    i := 1;
    while nivel.disparo_beto.vivo and (i <= CANTIDAD_ESCUDOS) do
    begin
       	if 	nivel.escudos[i].vivo
        	and (nivel.disparo_beto.x = nivel.escudos[i].x)
            and (nivel.disparo_beto.y = nivel.escudos[i].y)  then
		begin
        	{hay colisión, se destruyen los dos}
			nivel.disparo_beto.vivo := false;
            nivel.escudos[i].vivo := false;
		end;
        inc(i);
	end;

    {disparo beto vs aliens}
    {los disparos son "puntos" en el espacio, los aliens son áreas}
    i := 1;
    while nivel.disparo_beto.vivo and (i <= CANTIDAD_ALIENS) do
    begin
       	if 	nivel.aliens[i].vivo
        	and (nivel.disparo_beto.x >= nivel.aliens[i].x)
           	and (nivel.disparo_beto.x < (nivel.aliens[i].x + nivel.ancho_alien))
            and (nivel.disparo_beto.y >= nivel.aliens[i].y)
            and (nivel.disparo_beto.y < nivel.aliens[i].y + ALTURA_ALIEN)  then
		begin
        	{hay colisión, se destruyen los dos}
			nivel.disparo_beto.vivo := false;
            nivel.aliens[i].vivo := false;

            {pero en cada nivel hay diferente puntaje!}
            case nivel.numero of
            	1: jugador.puntos := jugador.puntos + 10;
                2: jugador.puntos := jugador.puntos + 20;
                3: jugador.puntos := jugador.puntos + 40;
                else
                	{una formula rápida por si en algun momento se juegan más de 3 niveles :)}
                	jugador.puntos := jugador.puntos + 10 + nivel.numero * 10;
            end;
		end;
        inc(i);
	end;

    {todos los disparos aliens activos}
    for i := 1 to CANTIDAD_DISPAROS_ALIENS do
    	if nivel.disparos_aliens[i].vivo then
        begin
			{disparo alien vs escudos}
            {los disparos y los escudos son "puntos" en el espacio}
	        j := 1;
    		while nivel.disparos_aliens[i].vivo and (j <= CANTIDAD_ESCUDOS) do
		    begin
    	   		if 	nivel.escudos[j].vivo
        			and (nivel.disparos_aliens[i].x = nivel.escudos[j].x)
                    and (nivel.disparos_aliens[i].y = nivel.escudos[j].y)  then
				begin
                {hay colisión, se destruyen los dos}
				nivel.disparos_aliens[i].vivo := false;
	            nivel.escudos[j].vivo := false;
				end;
		        inc(j);
			end;

        	{disparo alien vs beto}
            {los disparos son "puntos" en el espacio, Beto es un área}
	            if 	nivel.disparos_aliens[i].vivo
        			and (nivel.disparos_aliens[i].x >= nivel.beto.x)
	        	   	and (nivel.disparos_aliens[i].x < (nivel.beto.x + ANCHO_BETO))
		            and (nivel.disparos_aliens[i].y >= nivel.beto.y)
		            and (nivel.disparos_aliens[i].y < nivel.beto.y + ALTURA_BETO)  then
				begin
	                {hay colisión, se destruye el disparo alien}

     				nivel.disparos_aliens[i].vivo := false;

                    {descontamos 1 vida y 300 puntos al jugador. ojo con el underflow!}
                    if(jugador.vidas > 0) then
                    begin
                        if jugador.puntos >= 300 then
                        	jugador.puntos := jugador.puntos - 300
                        else
                        	jugador.puntos := 0;

                    	dec(jugador.vidas);
                    end;
				end;
        end;

	{todos los aliens vivos}
	for i := 1 to CANTIDAD_ALIENS do
    	if nivel.aliens[i].vivo then
        begin
        	{alien vs escudos}
            {los escudos son "puntos" en el espacio, los aliens son áreas}
        	j := 1;
    		while nivel.aliens[i].vivo and (j <= CANTIDAD_ESCUDOS) do
		    begin
    	   		if 	nivel.escudos[j].vivo
                	and not (
        				(nivel.aliens[i].x >= nivel.escudos[j].x + ANCHO_ESCUDO)
	        	   		or (nivel.aliens[i].x + nivel.ancho_alien <= nivel.escudos[j].x)
		            	or (nivel.aliens[i].y >= nivel.escudos[j].y + ALTURA_ESCUDO)
		            	or (nivel.aliens[i].y + ALTURA_ALIEN <= nivel.escudos[j].y)
              		) then
				begin
                	{hay colisión, se destruyen los dos}
					nivel.aliens[i].vivo := false;
	            	nivel.escudos[j].vivo := false;
				end;
		        inc(j);
			end;

            {alien vs beto}
            {los aliens y Beto son áreas}
            	if 	nivel.aliens[i].vivo
        			and not (
        				(nivel.aliens[i].x >= nivel.beto.x + ANCHO_BETO)
	        	   		or (nivel.aliens[i].x + nivel.ancho_alien <= nivel.beto.x)
		            	or (nivel.aliens[i].y >= nivel.beto.y + ALTURA_BETO)
		            	or (nivel.aliens[i].y + ALTURA_ALIEN <= nivel.beto.y)
              		) then
				begin
                	{hay colisión, se destruye el alien}
					nivel.aliens[i].vivo := false;

                    {descontamos 1 vida y 300 puntos al jugador. ojo con el underflow!}
                    if(jugador.vidas > 0) then
                    begin
                        if jugador.puntos >= 300 then
                        	jugador.puntos := jugador.puntos - 300
                        else
                        	jugador.puntos := 0;

                    	dec(jugador.vidas);
                    end;
				end;

        end;



end;

{
Juega los turnos de Beto, los aliens, y el mundo. Además, grafica el nivel.
@param nivel t_nivel El nivel en juego
@param jugador t_jugador El jugador que está jugando
@return t_resultado_nivel "gano" si no quedan aliens por matar,
	"abandono" si el jugador abandonó, "perdió" si el jugador ha perdido,
 	o "continuar" si hay que seguir jugando turnos.
}
function jugar_turno(var nivel:t_nivel; var jugador:t_jugador):t_resultado_nivel;
var
    resultado_turno:t_resultado_nivel;
begin
	{para regular las velocidades...}
    nivel.inicio_turno := now();

    if jugar_turno_beto(nivel, jugador) then
    begin
    	jugar_turno_alien(nivel, jugador);
        jugar_turno_mundo(nivel, jugador);
        graficar_nivel(nivel, jugador);


    	if jugador.vidas = 0 then
    	    resultado_turno := perdio
        else if cantidad_aliens_vivos(nivel) = 0 then
        	resultado_turno := gano
        else
        	resultado_turno := continuar;

    end
    else
    	resultado_turno := abandono;

    jugar_turno := resultado_turno;
end;


{
Inicializa el nivel, muestra la pantalla previa, y corre los turnos.
@param numero_nivel byte El número de nivel a jugar
@param jugador t_jugador El jugador que está jugando
@return t_resultado_nivel "gano" si ha concluído el nivel,
	"abandono" si el jugador abandonó, o "perdió" si el jugador ha perdido.
}
function jugar_nivel(numero_nivel:byte; var jugador:t_jugador):t_resultado_nivel;
var
    nivel:t_nivel;
    resultado_turno:t_resultado_nivel;
    i:integer;
begin
    inicializar_nivel(nivel);
    nivel.numero := numero_nivel;

    {el ancho del alien es variable, para que tenga distinta forma}
    if (MAX_ANCHO_ALIEN - nivel.numero + 1) >= MIN_ANCHO_ALIEN then
    	nivel.ancho_alien := MAX_ANCHO_ALIEN - nivel.numero + 1;

    resultado_turno := continuar;

    crear_entidades_nivel(nivel);

    graficar_prenivel(nivel);

    while resultado_turno = continuar do
        resultado_turno := jugar_turno(nivel, jugador);

    jugar_nivel := resultado_turno;
end;


{
Corre cada uno de los niveles hasta que el jugador gana, muere o abandona.
@return t_pantalla La pantalla a la que el usuario accederá luego
}
function correr_juego():t_pantalla;
var
    jugador:t_jugador;
    resultado_nivel:t_resultado_nivel;
    numero_nivel:integer;
    p:t_puntaje;
begin
    numero_nivel := 0;
    resultado_nivel := gano;

    jugador := crear_jugador();

    {corremos todos los niveles}
    while((resultado_nivel = gano) and (numero_nivel < CANTIDAD_NIVELES)) do
    begin
        inc(numero_nivel);
        resultado_nivel := jugar_nivel(numero_nivel, jugador);
    end;

    if (resultado_nivel = gano) and (numero_nivel = CANTIDAD_NIVELES) then
    begin
        jugador.puntos := jugador.puntos + 1000;
        graficar_victoria(jugador);
    end
    else if resultado_nivel = perdio then
        graficar_derrota();

	{guardado de puntos}
	p.nombre := jugador.nombre;
    p.puntos := jugador.puntos;
    if intentar_guardar_puntaje(p) then
    	graficar_felicitaciones(jugador);

    correr_juego := introduccion;
end;


end.

