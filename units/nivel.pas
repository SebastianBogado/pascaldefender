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
            aliens : t_entidades;
            escudos : t_entidades;
    end;

procedure inicializar_nivel(var nivel:t_nivel);

implementation

procedure inicializar_nivel(var nivel:t_nivel);
begin
     nivel.numero := 0;
     inicializar_entidades(nivel.escudos);
     inicializar_entidades(nivel.aliens);
end;

end.

