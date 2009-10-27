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
            mapa : t_mapa;
            entidades : t_entidades;
            cantidad_entidades : t_id_entidad;
    end;

procedure inicializar_nivel(var nivel:t_nivel);

implementation

procedure inicializar_nivel(var nivel:t_nivel);
begin
     nivel.numero := 0;
     nivel.cantidad_entidades := MAX_ENTIDADES;
     inicializar_entidades(nivel.entidades);
     inicializar_mapa(nivel.mapa);
end;

end.

