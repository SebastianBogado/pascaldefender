unit nivel;

interface
{dependencias}
uses
    mapa,
    entidad;

const
     PD_PROXIMO_NIVEL = 1;

type
    t_nivel = Record
            numero : byte;
            mapa : t_mapa;
            entidades : t_entidades;
    end;

procedure inicializar_nivel(var nivel:t_nivel);

implementation

procedure inicializar_nivel(var nivel:t_nivel);
begin
     nivel.numero := 0;
     inicializar_entidades(nivel.entidades);
     inicializar_mapa(nivel.mapa);
end;

end.

