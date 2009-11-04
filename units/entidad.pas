unit entidad;

interface
uses
    pdcommons;

const
    ALTURA_BETO = 2;
    ANCHO_BETO = 3;

    CANTIDAD_ALIENS = 24;
    ALTURA_ALIEN = 2;
    MAX_ANCHO_ALIEN = 5;
    MIN_ANCHO_ALIEN = 3;

    CANTIDAD_DISPAROS_ALIENS = 10;

    CANTIDAD_REFUGIOS = 3;
    ALTURA_REFUGIO = 6;
    ANCHO_REFUGIO = 12;
    ESCUDOS_POR_REFUGIO = ALTURA_REFUGIO * ANCHO_REFUGIO;

    ANCHO_ESCUDO = 1;
    ALTURA_ESCUDO = 1;
    CANTIDAD_ESCUDOS = CANTIDAD_REFUGIOS * ESCUDOS_POR_REFUGIO;

type
    t_entidad = Record
              x : byte;
              y : byte;
              vivo : boolean;
    end;
    t_aliens = array[1..CANTIDAD_ALIENS] of t_entidad;
    t_disparos_aliens = array[1..CANTIDAD_DISPAROS_ALIENS] of t_entidad;
    t_escudos = array[1..CANTIDAD_ESCUDOS] of t_entidad;


procedure inicializar_aliens(var entidades:t_aliens);
procedure inicializar_disparos_aliens(var entidades:t_disparos_aliens);
procedure inicializar_escudos(var entidades:t_escudos);
procedure inicializar_entidad(var entidad:t_entidad);


implementation

procedure inicializar_aliens(var entidades:t_aliens);
var
   i:byte;
begin
     for i := 0 to CANTIDAD_ALIENS do
       inicializar_entidad(entidades[i]);
end;

procedure inicializar_disparos_aliens(var entidades:t_disparos_aliens);
var
   i:byte;
begin
     for i := 0 to CANTIDAD_DISPAROS_ALIENS do
       inicializar_entidad(entidades[i]);
end;

procedure inicializar_escudos(var entidades:t_escudos);
var
   i:byte;
begin
     for i := 0 to CANTIDAD_ESCUDOS do
       inicializar_entidad(entidades[i]);
end;

procedure inicializar_entidad(var entidad:t_entidad);
begin
          entidad.vivo := true;
          entidad.x := 0;
          entidad.y := 0;
end;

end.

