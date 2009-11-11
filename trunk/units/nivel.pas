unit nivel;

interface
{dependencias}
uses
    mapa,
    entidad;

const
     PD_PROXIMO_NIVEL = 1;

type
    t_nivel = record
            numero : byte;
            beto : t_entidad;
            disparo_beto : t_entidad;
            aliens : t_aliens;
            disparos_aliens : t_disparos_aliens;
            escudos : t_escudos;
            direccion_aliens : integer;
            inicio_turno : TDateTime;
            inicio_turno_beto : TDateTime;
            inicio_turno_aliens : TDateTime;
            inicio_disparo_beto : TDateTime;
            inicio_disparos_aliens : TDateTime;
            ancho_alien : byte;

    end;

    t_resultado_nivel = (continuar, gano, perdio, abandono);

procedure inicializar_nivel(var nivel:t_nivel);
function x_alien_extremo_der(var nivel:t_nivel):byte;
function x_alien_extremo_izq(var nivel:t_nivel):byte;
function y_alien_extremo_inf(var nivel:t_nivel):byte;
function cantidad_aliens_vivos(var nivel:t_nivel):integer;

implementation

procedure inicializar_nivel(var nivel:t_nivel);
begin
     nivel.numero := 0;
     nivel.inicio_turno := 0;
     nivel.inicio_turno_beto := 0;
     nivel.inicio_turno_aliens := 0;
     nivel.inicio_disparo_beto := 0;
     nivel.inicio_disparos_aliens := 0;
     nivel.ancho_alien := MIN_ANCHO_ALIEN;
     inicializar_escudos(nivel.escudos);
     inicializar_aliens(nivel.aliens);
     inicializar_disparos_aliens(nivel.disparos_aliens);
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
Devuelve la posición extrema inferior de la flota alienigena.
Es decir, el numero de la última fila que contiene alguna nave alien
@param nivel t_nivel el nivel donde se encuentra la flota
@return byte la posición inferior extrema
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

{
Devuelve la cantidad de aliens que están vivos.
@param nivel t_nivel el nivel donde se encuentra la flota.
@return integer la cantidad de aliens vivos
}
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

end.

