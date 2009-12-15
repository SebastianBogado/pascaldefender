unit lecater;

interface

uses
    puntajes,
    jugador,
    sysutils;

const
	CANTIDAD_CONJ_ARCHIVO=5;
	CANTIDAD_LINEAS_ARCHIVO=100;

type
	tr_navesp=record
		beto: array [1..3,1..3] of char;
		naven1: array[1..2,1..3] of char;
		naven2: array[1..2,1..3] of char;
		naven3: array[1..2,1..3] of char;
		velnave: integer
		end;
	tv_navesp= array[0..CANTIDAD_CONJ_ARCHIVO] of tr_navesp;
	t_renglado= array[1..CANTIDAD_LINEAS_ARCHIVO] of string[50];
    file_t_puntaje= file of t_jugador;

 var
	renglado: t_renglado;
	vnaves: tv_navesp;
    conjuntos:integer;
    fpuntajes:file_t_puntaje;

procedure procesar_skins (var vnaves: tv_navesp; var renglado:t_renglado);
procedure cantidad_conjuntos_naves (var conjuntos:integer);
procedure naves_por_defecto(var vnaves: tv_navesp);
procedure guardar_puntajes (rjugador: t_jugador);


implementation

const
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
    t_error = (archivo, tipo_nave, dimension_nave, carac_no_visibles, velocidad);
var
	totrenglones:integer;
	ar_texto: text;
{
Procedimiento para establecer las naves por defecto, si el usuario no elige nada
o elige las naves predeterminadas
}
procedure naves_por_defecto(var vnaves: tv_navesp);
begin
     vnaves[0].beto[1,1]:='/';
     vnaves[0].beto[1,2]:='U';
     vnaves[0].beto[1,3]:='\';
     vnaves[0].beto[2,1]:='<';
     vnaves[0].beto[2,2]:='_';
     vnaves[0].beto[2,3]:='>';
     vnaves[0].naven1[1,1]:='H';
     vnaves[0].naven1[2,1]:='|';
     vnaves[0].naven1[1,3]:='H';
     vnaves[0].naven1[2,3]:='|';
     vnaves[0].naven1[2,2]:='^';
     vnaves[0].naven1[1,2]:='+';
     vnaves[0].naven2[1,1]:=')';
     vnaves[0].naven2[2,1]:=']';
     vnaves[0].naven2[1,3]:='(';
     vnaves[0].naven2[2,3]:='[';
     vnaves[0].naven2[2,2]:='Y';
     vnaves[0].naven2[1,2]:='8';
     vnaves[0].naven3[1,1]:='}';
     vnaves[0].naven3[2,1]:='~';
     vnaves[0].naven3[1,3]:='{';
     vnaves[0].naven3[2,3]:='~';
     vnaves[0].naven3[2,2]:='H';
     vnaves[0].naven3[1,2]:='V';
     vnaves[0].velnave:=1000;
end;

{
El procedimiento que guarda el tipo de error cometido si se encuentra algo mal
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
   str_crono := formatdatetime ('YYYYMMDD","hh:nn', now); {da el formato el tiempo y lo pasa a una string}
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
Devuelve la cantidad de conjuntos de naves que existen
}
procedure cantidad_conjuntos_naves (var conjuntos:integer);
var
    archivo:text;
    contcant:integer;
    cod:byte;
begin
     assign (archivo,'PDfile.apd');
     reset (archivo);
     contcant:=0;
     repeat
           inc(contcant);
           readln (archivo,renglado[contcant]);
     until contcant=2;
     val(renglado[2][11],conjuntos,cod); {Acá lee explícitamente una ubicación del archivo en búsqueda del nro de conjuntos}
     close (archivo)
end;

{
Abre el archivo de texto, además utiliza @renglado para guardar cada línea del mismo, @totrenglones guarda el total de línas
y @conjuntos tiene el tag de la cantidad de conjuntos (lo lee de la segunda línea)
}
procedure apertura_archivo (var ar_texto:text; var renglado:t_renglado; var totrenglones:integer);
var
	contcant:integer;
begin
	assign (ar_texto,'PDfile.apd');
	reset (ar_texto);
	contcant:=0;
	while not eof (ar_texto) do
		begin
			inc(contcant);
			readln (ar_texto,renglado[contcant])
		end;
	totrenglones:=contcant;
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
{
subprocess
}
	procedure proc_nave_beto (cont_co:byte; tt: byte);
	var
		t1,t2:byte;
	begin
		for t1:=1 to 2 do
			for t2:=1 to 3 do
				vnaves[cont_co].beto[t1,t2]:=renglado[tt+t1][t2]
	end;
{
subprocess
}
	procedure proc_nave_n1 (cont_co:byte; tt: byte);
	var
		t3,t4:byte;
	begin
		for t3:=1 to 2 do
			for t4:=1 to 3 do
				vnaves[cont_co].naven1[t3,t4]:=renglado[tt+t3][t4]
	end;
{
subprocess
}
	procedure proc_nave_n2 (cont_co:byte; tt: byte);
	var
		t5,t6:byte;
	begin
		for t5:=1 to 2 do
			for t6:=1 to 3 do
				vnaves[cont_co].naven2[t5,t6]:=renglado[tt+t5][t6];
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
				vnaves[cont_co].naven3[t7,t8]:=renglado[tt+t7][t8];
	end;
{
subprocess
}
	procedure proc_velocidad (cont_co:byte; tt: byte);
	var
		cod:byte;
	begin
		val (renglado[tt],vnaves[cont_co].velnave,cod)
	end;

{
process
}
var
	tt,cont_conj:byte;
begin
        apertura_archivo (ar_texto, renglado, totrenglones);
        cantidad_conjuntos_naves (conjuntos);
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



procedure guardar_puntajes (rjugador: t_jugador);
var
   fpuntajes:file_t_puntaje;
begin
     assign (fpuntajes, 'puntajes.bin');
     if NOT FileExists ('puntajes.bin') then
        rewrite (fpuntajes)
     else
         reset (fpuntajes);
     seek (fpuntajes, filesize(fpuntajes));
     write (fpuntajes, rjugador);
     close (fpuntajes)
end;


end.

