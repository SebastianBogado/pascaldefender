unit entidad;

interface
uses
    pdcommons;

const
     MAX_ENTIDADES = 100;

type
    t_id_entidad = byte;
    t_tipo_entidad = (beto, alien_a, alien_b, alien_c, escudo, disparo_alien, disparo_beto, unknown);

    t_entidad = Record
              tipo : t_tipo_entidad;
              origen : t_coordenada;
    end;

    t_entidades = Array [1..MAX_ENTIDADES] of t_entidad;

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
          entidad.tipo := unknown;
          entidad.origen.x := 0;
          entidad.origen.y := 0;
end;

end.

