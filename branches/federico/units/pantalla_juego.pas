unit pantalla_juego;

interface

uses
    crt,
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
    {
    crear escudos
    cada refugio se compone de escudos independientes, lo que facilita romperlos de a poco
    }
    for j := 1 to ESCUDOS_POR_REFUGIO do
    begin
        k := ((i-1)*ESCUDOS_POR_REFUGIO)+j; {auxiliar}
        {ordenamos en rectangulos}
        nivel.escudos[k].x := x_refugio + ((k-1) mod ANCHO_REFUGIO);
        nivel.escudos[k].y := y_refugio + ((j-1) div ANCHO_REFUGIO);
    end;
  end;

  {crear aliens}
  for i := 1 to CANTIDAD_ALIENS do
  begin
    {esto los acomoda de filas de ALIENS_POR_FILA naves cada una}
    nivel.aliens[i].x := 1 + ((i-1) mod ALIENS_POR_FILA)*(ANCHO_ALIEN+1);
    nivel.aliens[i].y := 1 + ((i-1) div ALIENS_POR_FILA)*(ALTURA_ALIEN+1);
  end;
  nivel.direccion_aliens := -1; {arrancan hacia la izquierda}

  nivel.disparo_beto.vivo := false; {el unico disparo de beto arranca inactivo}

  {todos los disparos aliens arrancan inactivos}
  for i:=1 to CANTIDAD_DISPAROS_ALIENS do
	nivel.disparos_aliens[i].vivo := false;

end;

{
Devuelve la posición extrema derecha de la flota alienigena.
Es decir, el numero de la primer columna que contiene alguna nave alien
@param nivel t_nivel el nivel donde se encuentra la flota
@return byte la posición derecha extrema
}
function x_alien_extremo_der(var nivel:t_nivel):byte;
var
	i:integer;
	x_extremo:byte;
begin
	x_extremo := 1;
	for i := 1 to CANTIDAD_ALIENS do
    	if nivel.aliens[i].vivo and (nivel.aliens[i].x > x_extremo) then
        	x_extremo := nivel.aliens[i].x;

    x_alien_extremo_der := x_extremo;
end;

{
Devuelve la posición extrema izquierda de la flota alienigena.
Es decir, el numero de la última columna que contiene alguna nave alien
@param nivel t_nivel el nivel donde se encuentra la flota
@return byte la posición izquierda extrema
}
function x_alien_extremo_izq(var nivel:t_nivel):byte;
var
	i:integer;
	x_extremo:byte;
begin
	x_extremo := ANCHO_MAPA;
	for i := 1 to CANTIDAD_ALIENS do
    	if nivel.aliens[i].vivo and (nivel.aliens[i].x < x_extremo) then
        	x_extremo := nivel.aliens[i].x;

    x_alien_extremo_izq := x_extremo;
end;

{

}
function y_alien_extremo_inf(var nivel:t_nivel):byte;
var
	i:integer;
	y_extremo:byte;
begin
	y_extremo := 1;
	for i := 1 to CANTIDAD_ALIENS do
    	if nivel.aliens[i].vivo and (nivel.aliens[i].y > y_extremo) then
        	y_extremo := nivel.aliens[i].y;

    y_alien_extremo_inf := y_extremo;
end;

function cantidad_aliens_vivos(var nivel:t_nivel):integer;
var
	i,n:integer;
begin
	n:=0;
	for i:=1 to CANTIDAD_ALIENS do
    	if nivel.aliens[i].vivo then
     		inc(n);

	cantidad_aliens_vivos := n;
end;

function jugar_turno_beto(var nivel:t_nivel; var jugador:t_jugador):boolean;
var
	direccion_beto:integer;
    seguir_jugando:boolean;
begin
    direccion_beto := 0;
    seguir_jugando := true;

	if keypressed() then
	begin
        case readkey() of
            #0: begin
				case readkey() of
					#75: direccion_beto := -1;
                    #77: direccion_beto := 1;
				end;
			end;
            'd': begin
            	if not nivel.disparo_beto.vivo then
                begin
	                nivel.disparo_beto.vivo := true;
					nivel.disparo_beto.x := nivel.beto.x + (ANCHO_BETO div 2);
    	            nivel.disparo_beto.y := nivel.beto.y;
                end;
            end;
            'q': seguir_jugando := false;
		end;
	end;

    if ((direccion_beto = 1) and (nivel.beto.x + ANCHO_BETO < ANCHO_MAPA))
    	or ((direccion_beto = -1) and (nivel.beto.x > 1)) then
    	nivel.beto.x := nivel.beto.x + direccion_beto;

	jugar_turno_beto := seguir_jugando;
end;

procedure jugar_turno_alien(var nivel:t_nivel; var jugador:t_jugador);
var
	x_extremo:byte;
    i,j:integer;
    se_disparo:boolean;
begin
	se_disparo := false;

	if (nivel.direccion_aliens > 0) then
    {la flota se mueve a la derecha}
    begin
		x_extremo := x_alien_extremo_der(nivel);
    	if (x_extremo + ANCHO_ALIEN) < ANCHO_MAPA then
        {la flota no toca el borde, muevo todos}
		begin
	    	for i := 1 to CANTIDAD_ALIENS do
  				nivel.aliens[i].x := nivel.aliens[i].x + nivel.direccion_aliens;
		end
        else
        begin
        {en el borde, bajan e invierten direcion}
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
        {la flota no toca el borde, muevo todos}
		begin
	    	for i := 1 to CANTIDAD_ALIENS do
  				nivel.aliens[i].x := nivel.aliens[i].x + nivel.direccion_aliens;
		end
        else
	        {en el borde invierten direcion}
            nivel.direccion_aliens := nivel.direccion_aliens * -1;
    end;

    {DISPARO ALIEN ALEATORIO}
    i:=1;
    while (not se_disparo) and (i <= CANTIDAD_DISPAROS_ALIENS) do
    begin
    	if (not nivel.disparos_aliens[i].vivo) and (random(500) = 1) then
       	begin
	        se_disparo := true;
            {hay que disparar... pero hay que elegir quién}
            j:= random(CANTIDAD_ALIENS) + 1;
            while not nivel.aliens[j].vivo do
	            j:= random(CANTIDAD_ALIENS) + 1;

			nivel.disparos_aliens[i].vivo := true;
            nivel.disparos_aliens[i].x := nivel.aliens[j].x + (ANCHO_ALIEN div 2);
            nivel.disparos_aliens[i].y := nivel.aliens[j].y + ALTURA_ALIEN - 1;
        end;
        inc(i);
    end;

end;

procedure jugar_turno_mundo(var nivel:t_nivel; var jugador:t_jugador);
var
    i,j:integer;
begin
	if nivel.disparo_beto.vivo then
    	if nivel.disparo_beto.y > 0 then
    		dec(nivel.disparo_beto.y)
        else
        	nivel.disparo_beto.vivo := false;

	for i:=1 to CANTIDAD_DISPAROS_ALIENS do
    	if nivel.disparos_aliens[i].vivo then
    		if nivel.disparos_aliens[i].y < ALTURA_MAPA then
        		inc(nivel.disparos_aliens[i].y)
            else
            	nivel.disparos_aliens[i].vivo := false;

	{COLISIONES}

    {disparo beto vs escudos}
    i := 1;
    while nivel.disparo_beto.vivo and (i <= CANTIDAD_DISPAROS_ALIENS) do
    begin
       	if 	nivel.escudos[i].vivo
        	and (nivel.disparo_beto.x = nivel.disparos_aliens[i].x)
            and (nivel.disparo_beto.y = nivel.disparos_aliens[i].y)  then
		begin
			nivel.disparo_beto.vivo := false;
            nivel.disparos_aliens[i].vivo := false;
		end;
        inc(i);
	end;

    {disparo beto vs escudos}
    i := 1;
    while nivel.disparo_beto.vivo and (i <= CANTIDAD_ESCUDOS) do
    begin
       	if 	nivel.escudos[i].vivo
        	and (nivel.disparo_beto.x = nivel.escudos[i].x)
            and (nivel.disparo_beto.y = nivel.escudos[i].y)  then
		begin
			nivel.disparo_beto.vivo := false;
            nivel.escudos[i].vivo := false;
		end;
        inc(i);
	end;

    {disparo beto vs aliens}
    i := 1;
    while nivel.disparo_beto.vivo and (i <= CANTIDAD_ALIENS) do
    begin
       	if 	nivel.aliens[i].vivo
        	and (nivel.disparo_beto.x >= nivel.aliens[i].x)
           	and (nivel.disparo_beto.x < (nivel.aliens[i].x + ANCHO_ALIEN))
            and (nivel.disparo_beto.y >= nivel.aliens[i].y)
            and (nivel.disparo_beto.y < nivel.aliens[i].y + ALTURA_ALIEN)  then
		begin
			nivel.disparo_beto.vivo := false;
            nivel.aliens[i].vivo := false;
            case nivel.numero of
            	1: jugador.puntos := jugador.puntos + 10;
                2: jugador.puntos := jugador.puntos + 20;
                else
                	jugador.puntos := jugador.puntos + 40;
            end;
		end;
        inc(i);
	end;

    for i := 1 to CANTIDAD_DISPAROS_ALIENS do
    	if nivel.disparos_aliens[i].vivo then
        begin
			{disparo alien vs escudos}
	        j := 1;
    		while nivel.disparos_aliens[i].vivo and (j <= CANTIDAD_ESCUDOS) do
		    begin
    	   		if 	nivel.escudos[i].vivo
        			and (nivel.disparos_aliens[i].x = nivel.escudos[j].x)
                    and (nivel.disparos_aliens[i].y = nivel.escudos[j].y)  then
				begin
				nivel.disparos_aliens[i].vivo := false;
	            nivel.escudos[j].vivo := false;
				end;
		        inc(j);
			end;

        	{disparo alien vs beto}
	            if 	nivel.disparos_aliens[i].vivo and nivel.beto.vivo
        			and (nivel.disparos_aliens[i].x >= nivel.beto.x)
	        	   	and (nivel.disparos_aliens[i].x < (nivel.beto.x + ANCHO_BETO))
		            and (nivel.disparos_aliens[i].y >= nivel.beto.y)
		            and (nivel.disparos_aliens[i].y < nivel.beto.y + ALTURA_BETO)  then
				begin
					nivel.disparos_aliens[i].vivo := false;
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

	for i := 1 to CANTIDAD_ALIENS do
    	if nivel.aliens[i].vivo then
        begin
        	{alien vs escudos}
        	j := 1;
    		while nivel.aliens[i].vivo and (j <= CANTIDAD_ESCUDOS) do
		    begin
    	   		if 	nivel.escudos[j].vivo
                	and not (
        				(nivel.aliens[i].x >= nivel.escudos[j].x + ANCHO_ESCUDO)
	        	   		or (nivel.aliens[i].x + ANCHO_ALIEN <= nivel.escudos[j].x)
		            	or (nivel.aliens[i].y >= nivel.escudos[j].y + ALTURA_ESCUDO)
		            	or (nivel.aliens[i].y + ALTURA_ALIEN <= nivel.escudos[j].y)
              		) then
				begin
					nivel.aliens[i].vivo := false;
	            	nivel.escudos[j].vivo := false;
				end;
		        inc(j);
			end;

            {alien vs beto}
            	if 	nivel.aliens[i].vivo and nivel.beto.vivo
        			and not (
        				(nivel.aliens[i].x >= nivel.beto.x + ANCHO_BETO)
	        	   		or (nivel.aliens[i].x + ANCHO_ALIEN <= nivel.beto.x)
		            	or (nivel.aliens[i].y >= nivel.beto.y + ALTURA_BETO)
		            	or (nivel.aliens[i].y + ALTURA_ALIEN <= nivel.beto.y)
              		) then
				begin
					nivel.aliens[i].vivo := false;
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

function jugar_turno(var nivel:t_nivel; var jugador:t_jugador):t_resultado_nivel;
var
    resultado_turno:t_resultado_nivel;
begin

    if jugar_turno_beto(nivel, jugador) then
    begin
    	jugar_turno_alien(nivel, jugador);
        jugar_turno_mundo(nivel, jugador);
        graficar_nivel(nivel, jugador);
        //delay(250);

    	if jugador.vidas = 0 then
    	begin
            graficar_derrota();
    	    resultado_turno := perdio;
    	end
        else if cantidad_aliens_vivos(nivel) = 0 then
        begin
        	resultado_turno := gano;
	    end
        else
        	resultado_turno := continuar;

    end
    else
    	resultado_turno := abandono;

    jugar_turno := resultado_turno;
end;


{
Corre el nivel, ejecutando todos los turnos hasta que el usuario gana, muere
o abandona.
@param numero_nivel byte El número del nivel a jugar
@param jugador t_jugador El jugador que jugará el nivel
@return boolean True si el jugador ha ganado, False si ha perdido o abandonado.
@todo implementar el guardado de puntos.
}
function jugar_nivel(numero_nivel:byte; var jugador:t_jugador):t_resultado_nivel;
var
    nivel:t_nivel;
    resultado_turno:t_resultado_nivel;
    i:integer;
begin
    inicializar_nivel(nivel);
    nivel.numero := numero_nivel;

    resultado_turno := continuar;

    crear_entidades_nivel(nivel);

    graficar_prenivel(nivel);

    while resultado_turno = continuar do
    begin
        resultado_turno := jugar_turno(nivel, jugador);
    end;

    jugar_nivel := resultado_turno;
end;


{
Corre cada uno de los niveles hasta que el jugador muere o abandona.
@return t_pantalla La pantalla a la que el usuario quiere acceder
}
function correr_juego():t_pantalla;
var
    jugador:t_jugador;
    resultado_nivel:t_resultado_nivel;
    numero_nivel:integer;
begin
    numero_nivel := 0;
    resultado_nivel := gano;

    jugador := crear_jugador();

    while((resultado_nivel = gano) and (numero_nivel < CANTIDAD_NIVELES)) do
    begin
        inc(numero_nivel);
        resultado_nivel := jugar_nivel(numero_nivel, jugador);
    end;

    if (resultado_nivel = gano) and (numero_nivel = CANTIDAD_NIVELES) then
    begin
        jugador.puntos := jugador.puntos + 1000;
        graficar_victoria(jugador);
    end;

    correr_juego := introduccion;
end;


end.

