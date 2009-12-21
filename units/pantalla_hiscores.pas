unit pantalla_hiscores;

interface

uses
    crt,
    pdcommons,
    graficador,
    loginmas;


function correr_hiscores():t_pantalla;


implementation

{
Obtiene los mejores puntajes y los muestra.
@retorna t_pantalla La pantalla que debe correrse a continuación
}
function correr_hiscores():t_pantalla;

var
 t_apretada:char;
 cod,aux:integer;
 cefinit:boolean;

begin
     cod:=-1;
     cefinit:=false;
     if	administrador then
        begin
            repeat
            clrscr;
            writeln ('Señor admin, cuántos puntajes desea ver?');
            t_apretada:=readkey;
            val (t_apretada, aux,cod);
            if cod<>0 then
               begin
                 writeln ('No es una opción numérica. Por favor, reingrese');
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
        graficar_hiscores(MOSTRAR_PUNT);

    correr_hiscores := introduccion
end;

end.

