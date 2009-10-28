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
            aliens : t_entidades;
            disparos_aliens : t_entidades;
            escudos : t_entidades;
            direccion_aliens : integer;

    end;

    t_resultado_nivel = (continuar, gano, perdio, abandono);

procedure inicializar_nivel(var nivel:t_nivel);

implementation

procedure inicializar_nivel(var nivel:t_nivel);
begin
     nivel.numero := 0;
     inicializar_entidades(nivel.escudos);
     inicializar_entidades(nivel.aliens);
end;

end.

