unit entidad;

interface
uses
    pdcommons;

const
	MAX_ENTIDADES = 200;

    ALTURA_BETO = 2;
    ANCHO_BETO = 3;

    ALTURA_ALIEN = 2;
    ANCHO_ALIEN = 3;

    CANTIDAD_ALIENS = 12;
    CANTIDAD_DISPAROS_ALIENS = 10;

    CANTIDAD_REFUGIOS = 3;
    ALTURA_REFUGIO = 2;
    ANCHO_REFUGIO = 9;
    ANCHO_ESCUDO = 1;
    ALTURA_ESCUDO = 1;
    ESCUDOS_POR_REFUGIO = ALTURA_REFUGIO * ANCHO_REFUGIO;
    CANTIDAD_ESCUDOS = CANTIDAD_REFUGIOS * ESCUDOS_POR_REFUGIO;

type
    t_entidad = Record
              x : byte;
              y : byte;
              vivo : boolean;
    end;
    t_entidades = array[1..MAX_ENTIDADES] of t_entidad;

procedure inicializar_entidades(var entidades:t_entidades); 
procedure inicializar_entidad(var entidad:t_entidad);


implementation

procedure inicializar_entidades(var entidades:t_entidades);
var
   i:byte;
begin
     for i := 0 to MAX_ENTIDADES do
       inicializar_entidad(entidades[i]);
end;

procedure inicializar_entidad(var entidad:t_entidad);
begin
          entidad.vivo := true;
          entidad.x := 0;
          entidad.y := 0;
end;

end.

