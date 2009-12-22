unit pantalla_hiscores;

interface

uses
    crt,
    pdcommons,
    graficador,
    loginmas;

const
   mostrardoce=12;


function correr_hiscores():t_pantalla;


implementation

{
Obtiene los mejores puntajes y los muestra.
@retorna t_pantalla La pantalla que debe correrse a continuación
}
function correr_hiscores():t_pantalla;

var
 t_apretada:string[5];
 cod,aux:integer;
 cefinit:boolean;

begin
     cod:=-1;
     cefinit:=false;
     if	administrador then
        begin
            repeat
            clrscr;
            writeln ('Se',chr(164),'or admin, ',chr(168),'cu',chr(160),'ntos puntajes desea ver?');
            readln (t_apretada);
            val (t_apretada, aux,cod);
            if cod<>0 then
               begin
                 writeln ('No es una opci',chr(162),'n num',chr(130),'rica. Por favor, reingrese');
                 writeln ()
               end
            else
                begin
                    writeln(); writeln();
                    graficar_hiscores(aux);
                    cefinit:=true
                 end;
            until cefinit;
        end
    else
        graficar_hiscores(mostrardoce);

    correr_hiscores := introduccion
end;

end.

