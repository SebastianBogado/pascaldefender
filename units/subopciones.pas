unit subopciones;

interface

uses
    crt,
    lecater;
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

repeat
      repeat
            t_apretada:=readkey;
            val (t_apretada, numero_conj_naves,cod);
            if cod<>0 then
                 writeln ('No es una opción numérica. Por favor, reingrese')
            else if (numero_conj_naves > conjuntos) then
                      writeln ('Ese conjunto de naves NO existe, solo existen ', conjuntos, ' para elegir. Por favor, reingrese.')
                 else if numero_conj_naves = 0 then begin
                         cefinit:=true; nosirve:=false end
                      else
                      begin
                          aux:=numero_conj_naves;
                          procesar_skins (vnaves, renglado,aux,nosirve);
                          cefinit:=true
                      end;
      until cefinit;
until NOT nosirve;
subopcion1:=aux

end;
{

}
procedure subopcion2();
begin
  clrscr;
  writeln('lalala');
  readkey
end;

procedure subopcion3();
begin
  clrscr;
  writeln('lalala');
  readkey
end;

procedure subopcion4();
begin
  clrscr;
  writeln('lalala');
  readkey
end;

end.

