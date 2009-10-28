unit entidad;

interface
uses
    pdcommons;

const
	MAX_ENTIDADES = 100;

    ALTURA_BETO = 2;
    ANCHO_BETO = 3;

    ALTURA_ESCUDO = 3;
    ANCHO_ESCUDO = 4;

    ALTURA_ALIEN = 2;
    ANCHO_ALIEN = 3;

    CANTIDAD_ESCUDOS = 4;
    CANTIDAD_ALIENS = 12;
    CANTIDAD_DISPAROS_ALIENS = 5;

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

