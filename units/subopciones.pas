unit subopciones;

interface

uses
    crt,
    lecater,
    loginmas;

var
   numero_conj_naves:integer;

   function subopcion1(var numero_conj_naves:integer):integer;
   procedure subopcion2();
   procedure subopcion3();
   procedure subopcion4();

implementation
{
Permite elegir el conjunto de naves (aka "skins de naves"), validando los datos
}
function subopcion1 (var numero_conj_naves:integer):integer;
var
 t_apretada:char;
 cod,aux:integer;
 bandera, cefinit:boolean;
begin
     cantidad_conjuntos_naves (conjuntos, mirador);
     cod:=-1;
     cefinit:=false;
     aux:=0;

if conjuntos=0 then begin
   writeln('No hay skins para elegir, posible error de PDfile.apd');
   writeln('Presione 0 para volver'); readkey() end

else

begin
repeat
      repeat
            t_apretada:=readkey;
            val (t_apretada, numero_conj_naves,cod);
            if cod<>0 then
               begin
                 writeln ('No es una opci',chr(162),'n num',chr(162),'rica. Por favor, reingrese');
                 writeln ()
               end
            else if (numero_conj_naves > conjuntos) then
                    begin
                      writeln ('S',chr(162),'lo existen ', conjuntos, ' para elegir. Por favor, reingrese.');
                      writeln ()
                    end
                 else if numero_conj_naves = 0 then
                      begin
                         cefinit:=true;
                         nosirve:=false
                      end
                         else
                             begin
                                  aux:=numero_conj_naves;
                                  procesar_skins (vnaves, renglado,aux,nosirve);
                                  cefinit:=true
                             end;
      until cefinit;
until NOT nosirve;

subopcion1:=aux
end
end;

{

}
procedure subopcion2();
begin
  Modificar_Usuario(Participante,INDICE_DAT)
end;

procedure subopcion3();
begin
  Baja_Usuario(Participante,INDICE_DAT)
end;

procedure subopcion4();
begin
   Menu_Login_Principal (participante)
end;

end.

