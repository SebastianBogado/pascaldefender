unit opciones; 
{levanta las opciones de naves y velocidad
 crea el log de error, si es necesario}
interface

function opciones_juego() : t_pantalla;       

implementation
uses
    crt,
    sysutils;

const
     CANTIDAD_CONJ_ARCHIVO=5;
     CANTIDAD_LINEAS_ARCHIVO=100;
     {const para el log}
     DIRECTORIO_LOG = 'Log.txt';
     SEP = ',';
     {textos de error a continuación}
     ER_ARCHIVO = 'No se pudo abrir el archivo'; 
     ER_TIPO_NAVE = 'Tipo de nave no reconocida';
     ER_DIMENSION_NAVE = 'Dimension de nave invalida';
     ER_CARAC_NO_VISIBLES = 'Caracteres en blanco';
     ER_VELOCIDAD = 'La velocidad es un numero no valido';

type
    tr_navesp=record
                    beto: array [1..2,1..3] of char;
		    naven1: array[1..2,1..5] of char;
		    naven2: array[1..2,1..4] of char;
		    naven3: array[1..2,1..3] of char;
		    velnave: real
              end;                
    tv_navesp= array[1..CANTIDAD_CONJ_ARCHIVO] of tr_navesp;
    t_renglado= array[1..CANTIDAD_LINEAS_ARCHIVO] of string[70];
    t_error = (archivo, tipo_nave, dimension_nave, carac_no_visibles, velocidad);

var
   renglado: t_renglado;
   totrenglones:integer;
   vnaves: tv_navesp;
   ar_texto: text;
   conjuntos:byte;
{
El procedimiento que guarda el tipo de error cometido, si se encuentrara algo
@todo verificar que no haya forma alguna de que se dé el else del case
}	
procedure logueador (error : t_error);

var
   log : text;
   str_crono : string[15];
   
begin
   assign(log,DIRECTORIO_LOG);
   {$i-}
   append(log);
   {$i+}
   if IOresult <> 0 then
      rewrite(log);
   str_crono := formatdatetime ('YYYYMMDD","hh:nn', now); {formatea el tiempo y lo pasa a una string}
   write(log, str_crono, SEP);
   case error of
      archivo : writeln(log,ER_ARCHIVO);
      tipo_nave : writeln(log,ER_TIPO_NAVE);
      dimension_nave : writeln(log,ER_DIMENSION_NAVE);
      carac_no_visibles : writeln(log,ER_CARAC_NO_VISIBLES);
      velocidad : writeln(log,ER_VELOCIDAD)
   {else
      writeln(log,'Error no reconocido');}
{lo pongo así por las dudas, sería ideal que esto no sucediera, pero qué sé yo}
   end;
   close(log);
end;

{
Abre el archivo de texto, además utiliza @renglado para guardar cada línea del mismo, @totrenglones guarda el total de línas 
y @conjuntos tiene el tag de la cantidad de conjuntos (lo lee de la segunda línea)
}
procedure apertura_archivo (var ar_texto:text;
                            var renglado:t_renglado;
                            var totrenglones:integer;
                            var conjuntos:byte
                            dir_archivo:string[50]);
var
   contcant:integer;
   cod:byte;
   error : t_error;
   
begin
     assign (ar_texto,dir_archivo);
     {$i-}       
     reset(ar_texto);
     {$i+}
     if IOresult <> 0 then
        begin
             error := archivo;
             logueador(error);
             writeln(ER_ARCHIVO);
        end;
     contcant:=0;
     while not eof (ar_texto) do
           begin
	        inc(contcant);
		readln (ar_texto,renglado[contcant])
	   end;
     totrenglones:=contcant;
     val(renglado[2][11],conjuntos,cod); {Acá lee explícitamente una ubicación del archivo en búsqueda del nro de conjuntos}
     close (ar_texto)
end;
{
Una función que devuelve en qué línea del txt se encuentra
}
function buscar_linea_encabezado (renglon:t_renglado; conjun:byte):byte;
var
	tt:byte;
	opcionb:string[2];
	patronp:string[70];
begin
	str(conjun,opcionb);
	patronp:='[opcion_' + opcionb + ']';
	for tt:=1 to totrenglones do
		if renglon[tt]= patronp then
			buscar_linea_encabezado:=tt;
end;
{
Este procedimiento consta de subprocesos que extraen los datos (formas de naves y velocidad) 
de @renglado y la colocan en un vector de registros, para luego poder ser utilizadas por el graficador
}
procedure procesar_skins (var vnaves: tv_navesp; var renglado:t_renglado);
var
   error : t_error; {no sé, pero me pinta para hacerla global interna. @todo justificar}
{
subprocess
}
   function caracteres_validos(max_ancho : byte; tt : byte) : boolean;
   var
      carac_validos : boolean;
      i,j : byte;
      cont_carac_validos : byte;
      ascii_cod : byte;
   begin
      carac_validos := false;
      cont_carac_validos := 0;
      for i := 1 to 2 do
         for j := 1 to max_ancho do
            begin
               ascii_cod := ord(renglado[tt+i,j]);
               if ( (ascii_cod > 32) xor (ascii_cod = 127) xor (ascii_cod = 255) ) then
                  inc(cont_carac_validos);
               {
               los valores entre 0 y 32, el 127 y 255 son caracteres no visibles
               }
            end;
      if cont_carac_validos = (2 * max_ancho) then {2 * max_ancho es la cantidad de caracteres}
         carac_validos := true; 
      caracteres_validos := carac_validos;
   end;
{
subprocess
}
	procedure proc_nave_beto (cont_co:byte; tt: byte);
	var
		t1,t2:byte;
	begin
		for t1:=1 to 2 do
			for t2:=1 to 3 do
				if caracteres_validos(3, tt) then
               vnaves[cont_co].beto[t1,t2]:=renglado[tt+t1][t2]
            else
               begin
                  error := carac_no_visibles;
                  logueador(error);
                  writeln(ER_CARAC_NO_VISIBLES);
               end;  
               
   end;
{
subprocess
}
	procedure proc_nave_n1 (cont_co:byte; tt: byte);
	var
		t3,t4:byte;
	begin
		for t3:=1 to 2 do
			for t4:=1 to 5 do
				if caracteres_validos(5, tt) then
               vnaves[cont_co].naven1[t3,t4]:=renglado[tt+t3][t4]
            else
               begin
                  error := carac_no_visibles;
                  logueador(error);
                  writeln(ER_CARAC_NO_VISIBLES);
               end;         
	end;
{
subprocess
}
	procedure proc_nave_n2 (cont_co:byte; tt: byte);
	var
		t5,t6:byte;
	begin
		for t5:=1 to 2 do
			for t6:=1 to 4 do
				if caracteres_validos(4, tt) then
               vnaves[cont_co].naven2[t5,t6]:=renglado[tt+t5][t6]
            else
               begin
                  error := carac_no_visibles;
                  logueador(error);
                  writeln(ER_CARAC_NO_VISIBLES);
               end;
	end;
{
subprocess
}
	procedure proc_nave_n3 (cont_co:byte; tt: byte);
	var
		t7,t8:byte;
	begin
		for t7:=1 to 2 do
			for t8:=1 to 3 do
				if caracteres_validos(3, tt) then
               vnaves[cont_co].naven3[t7,t8]:=renglado[tt+t7][t8]
            else
               begin
                  error := carac_no_visibles;
                  logueador(error);
                  writeln(ER_CARAC_NO_VISIBLES);
               end;
	end;
{
subprocess
}
	procedure proc_velocidad (cont_co:byte; tt: byte);
	var
		cod:byte;
	begin
		val (renglado[tt],vnaves[cont_co].velnave,cod);
      if (cod <> 0) then 
         begin
            error := velocidad;
            logueador(error);
            writeln(ER_VELOCIDAD);
         end;
	end;

{
process
}
var
	tt,cont_conj:byte;
begin
	for cont_conj:=1 to conjuntos do
	begin
		tt:=buscar_linea_encabezado (renglado, cont_conj);
		if (
			(renglado[tt+1]='[beto][2x3]') AND
			(renglado[tt+4]='[alien_n1][2x5]') AND  
			(renglado[tt+7]='[alien_n2][2x4]') AND 
			(renglado[tt+10]='[alien_n3][2x3]') AND
			(renglado[tt+13]='[velocidad]')
		) then
			begin
				proc_nave_beto (cont_conj, tt+1); {"tt+1" es la posición relativa al encabezado que tiene el tag de la nave, siempre}
				proc_nave_n1 (cont_conj, tt+4);
				proc_nave_n2 (cont_conj, tt+7);
				proc_nave_n3 (cont_conj, tt+10);
				proc_velocidad (cont_conj, tt+14) 
			end
		else
			{
			Acá se podría poner para guardar que el archivo de log de la opción de naves que no anduvo, pero es general, 
			no se puede especificar el tipo de error, salvo que hagas un "tipo error" y lo vayas poniendo por todos lados			
			}
			writeln ('El skin de naves ', cont_conj, ' no se puede usar. Tags incorrectas, verifique.');
	end
end;

function opciones_juego() : t_pantalla;
var
   opcion_seleccionada : t_pantalla;
   ar_texto : text;
   
begin                  
     graficar_opciones_juego(); {pide la dir. del archivo}
     readln(dir_archivo);

     opciones_juego := opcion_seleccionada; {o directamente asignarle opciones, mientras metemos la
     función en un loop que no salga a menos que "x". opciones volvería a la pantalla de opciones}
end;


end.

