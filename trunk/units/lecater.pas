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
    t_error = (archivo, tipo_nave, dimension_nave, carac_no_visibles, velocidad);
    t_mx_nave = array[1..2,1..3] of char;

	tr_navesp=record
		beto: t_mx_nave;
		naven1: t_mx_nave;
		naven2: t_mx_nave;
		naven3: t_mx_nave;
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
    mirador,nosirve:boolean;

procedure procesar_skins (var vnaves: tv_navesp; var renglado: t_renglado; c_conjuntos:integer; var nosirve:boolean);
procedure cantidad_conjuntos_naves (var conjuntos:integer; var mirador:boolean);
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
var
    ar_texto: text;
    totrenglones:integer;


{OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO}

{
El procedimiento que guarda el tipo de error cometido si se encuentra algo mal
@param el tipo de error encontrado
@return el log con la fecha y tipo de error escritos
}
procedure logueador (var error : t_error);
var
   log : text;
   str_crono : string[15];


begin
     assign (log, DIRECTORIO_LOG);
     if NOT FileExists (DIRECTORIO_LOG) then
        rewrite (log)
     else
          append(log);
     str_crono := formatdatetime ('YYYYMMDD","hh:nn', now); {da el formato el tiempo y lo pasa a una string}
     case error of
          archivo : writeln(log,str_crono,SEP,ER_ARCHIVO);
          tipo_nave : writeln(log,str_crono,SEP,ER_TIPO_NAVE);
          dimension_nave : writeln(log,str_crono,SEP,ER_DIMENSION_NAVE);
          carac_no_visibles : writeln(log,str_crono,SEP,ER_CARAC_NO_VISIBLES);
          velocidad : writeln(log,str_crono,SEP,ER_VELOCIDAD)
     end;
     close(log);
end;

{
Trata punto por punto a la nave para chequear que todos los caracteres sean
visibles
}
function caracteres_validos(skin_nave : t_mx_nave) : boolean;
var
   carac_validos : boolean;
   i,j : byte;
   cont_carac_invalidos : byte;
   ascii_cod : byte;
begin
     carac_validos := true;
     cont_carac_invalidos := 0;
     for i := 1 to 2 do
        for j := 1 to 3 do
           begin
              ascii_cod := ord(skin_nave[i,j]);
              if ( (ascii_cod < 33) or (ascii_cod = 127) or (ascii_cod = 255) ) then
                 inc(cont_carac_invalidos);
              {
              Los valores entre 0 y 32, el 127 y 255 son caracteres no visibles
              No se valida para mayor a 0 porque no puede devolver menor la función ord
              }
           end;
     if cont_carac_invalidos = 6 then {6 = alto * ancho de la matriz, es la cantidad de caracteres}
        carac_validos := false;
        caracteres_validos := carac_validos;
end;



procedure procesar_error_naves(var cadena : string; var saltear:boolean);
var
   error : t_error;
 {
 Subproceso
 }
  procedure chequeo_dimensiones(var cadena : string[20]; nivel : byte);
  var
      cadena_dimensiones : string[6];
      c : byte;
      ancho_alien : integer;
      cadenita : string[1];
  begin
       {Existe una relación lineal entre el nivel y el ancho del alien:
       n = 1, ancho = 5;
       n = 2, ancho = 4;
       n = 3, ancho = 3;
       n + ancho = 6, será nuestra variable c (constante, en realidad), y n llega
       por parámetro "nivel"
       }
       c := 6;


       {c - nivel = ancho alien}
       ancho_alien := c - nivel;
       str(ancho_alien,cadenita);
       cadena_dimensiones := copy(cadena, 11, 5);

       if (cadena_dimensiones <> ('[2x' + cadenita + ']')) then
         begin
               error := dimension_nave;
               logueador(error);
               saltear:=true
          end;

  end;

 {
 Subproceso
 }
  procedure chequeo_alien(var cadena : string[20]);
  var
     cadena_nave : string[10];
  begin
       cadena_nave := copy(cadena, 1, 10);

       if cadena_nave = '[alien_n1]' then
            chequeo_dimensiones(cadena, 1)
       else if cadena_nave = '[alien_n2]' then
               chequeo_dimensiones(cadena, 2)
            else if cadena_nave = '[alien_n3]' then
                    chequeo_dimensiones(cadena, 3)
                 else
                     begin
                          error := tipo_nave;
                          logueador(error);
                          saltear:=true
                     end;
  end;

 {
 Subproceso
 chequea, además de Beto, la dimensión y que esté bien escrito "[velocidad]",
 porque eran cositas cortas
 }
  procedure chequeo_beto(var cadena : string[20]);
  var
      cadena_nave : string[8];
      cadena_dimension : string[6];
  begin
       if (cadena <> '[velocidad]') then
          begin
               cadena_nave := copy(cadena, 1, 6);

               if (cadena_nave = '[beto]') then
                  begin
                       cadena_dimension := copy(cadena, 7, 5);
                       if (cadena_dimension <> '[2x3]') then
                          begin
                               error := dimension_nave;
                               logueador(error);
                               saltear:=true
                          end;
                  end
               else
                   begin
                        error := tipo_nave;
                        logueador(error);
                        saltear:=true
                   end;
           end;
  end;

{
Cuerpo principal del proceso
}
begin
     {las cadenas levantadas, para que estén correctas tienen que medir 15,
     en el caso de los marcianos, u 11 para Beto}
     saltear:=false;
     case length(cadena) of
          15 : chequeo_alien(cadena);
          11 : chequeo_beto(cadena);
          else
              begin
                   error := tipo_nave;
                   logueador(error);
                   saltear:=true
              end;
     end;
end;

{OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO}

{
Devuelve la cantidad de conjuntos de naves que existen
}
procedure cantidad_conjuntos_naves (var conjuntos:integer; var mirador:boolean);
var
    ar_naves:text;
    contcant:integer;
    cod:byte;
    error : t_error;
begin
     assign (ar_naves, 'PDfile.apd');
     mirador:=false;
     if NOT FileExists ('PDfile.apd') then
        begin
             error := archivo;
             logueador(error);
             conjuntos:=0;
             mirador:=false
        end
     else
         begin
              reset (ar_naves);
              mirador:=true;
              contcant:=0;
              repeat
                    inc(contcant);
                    {Acá lee explícitamente una ubicación del archivo en búsqueda del nro de conjuntos}
                    readln (ar_naves,renglado[contcant]);
              until contcant=2;

              val(renglado[2][11],conjuntos,cod);
              close (ar_naves)
          end
end;

{
Abre el archivo de texto, además utiliza @renglado para guardar cada línea del mismo, @totrenglones guarda el total de línas
y @conjuntos tiene el tag de la cantidad de conjuntos (lo lee de la segunda línea)
}

procedure apertura_archivo (var ar_texto:text; var renglado:t_renglado; var totrenglones:integer);
var
	contcant:integer;
    error : t_error;
begin
     assign (ar_texto, 'PDfile.apd');
     if NOT FileExists ('PDfile.apd') then
        begin
             error := archivo;
             logueador(error);
             conjuntos:=0;
             close (ar_texto)
        end
     else
     begin
         reset (ar_texto);
         contcant:=0;
         while not eof (ar_texto) do
         begin
              inc(contcant);
	          readln (ar_texto,renglado[contcant])
	          end;
         totrenglones:=contcant;
         close (ar_texto)
     end
end;
{
Una función que devuelve en qué línea del txt se encuentra
}
function buscar_linea_encabezado (renglon:t_renglado; conjun:byte):byte;
var
	tt:byte;
    opcionb:string[3];
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
procedure procesar_skins (var vnaves: tv_navesp; var renglado:t_renglado; c_conjuntos:integer; VAR nosirve:boolean);

                
{
subprocess
}
	procedure proc_nave_beto (cont_co:byte; tt: byte);
	var
		t1,t2:byte;
                error : t_error;
                skin : t_mx_nave;
	begin
		for t1:=1 to 2 do
		    for t2:=1 to 3 do
                        skin[t1,t2] := renglado[tt+t1][t2];
                if caracteres_validos(skin) then
                   vnaves[cont_co].beto := skin
                else
                    begin
                         error := carac_no_visibles;
                         logueador(error);
                    end;
end;
{
subprocess
}
	procedure proc_nave_n1 (cont_co:byte; tt: byte);
	var
		t3,t4:byte;
                error : t_error;
                skin : t_mx_nave;
	begin
		for t3:=1 to 2 do
		    for t4:=1 to 3 do
                        skin[t3,t4] := renglado[tt+t3][t4];
                if caracteres_validos(skin) then
                   vnaves[cont_co].naven1 := skin
                else
                    begin
                         error := carac_no_visibles;
                         logueador(error)
                    end;				
	end;
{
subprocess
}
	procedure proc_nave_n2 (cont_co:byte; tt: byte);
	var
		t5,t6:byte;
                error : t_error;
                skin : t_mx_nave;
	begin
		for t5:=1 to 2 do
		    for t6:=1 to 3 do
                        skin[t5,t6] := renglado[tt+t5][t6];
                if caracteres_validos(skin) then
                   vnaves[cont_co].naven2 := skin
                else
                    begin
                         error := carac_no_visibles;
                         logueador(error);
                    end;				
	end;
{
subprocess
}
	procedure proc_nave_n3 (cont_co:byte; tt: byte);
	var
		t7,t8:byte;
                error : t_error;
                skin : t_mx_nave;
	begin
		for t7:=1 to 2 do
		    for t8:=1 to 3 do
                        skin[t7,t8] := renglado[tt+t7][t8];
                if caracteres_validos(skin) then
                   vnaves[cont_co].naven3 := skin
                else
                    begin
                         error := carac_no_visibles;
                         logueador(error);
                    end;				
	end;
{
subprocess
}
	procedure proc_velocidad (cont_co:byte; tt: byte);
	var
		cod:byte;
                error : t_error;
	begin
		val (renglado[tt],vnaves[cont_co].velnave,cod);
                if (cod <> 0) then 
                   begin
                        error := velocidad;
                        logueador(error);
                   end;
        end;

{
process
}
var
	tt:byte;
    saltear1,saltear2,saltear3,saltear4,saltear5:boolean;
begin
        apertura_archivo (ar_texto, renglado, totrenglones);
		tt:=buscar_linea_encabezado (renglado, c_conjuntos);
        nosirve:=false;
		if NOT mirador then
           begin
           nosirve:=true;
           writeln ('El archivo de naves no es v',chr(160),'lido o no existe. Por favor ingrese la opci',chr(162),'n por defecto (0)');
           writeln ()
           end
        else  begin
              procesar_error_naves(renglado[tt+1],saltear1);
              procesar_error_naves(renglado[tt+4],saltear2);
              procesar_error_naves(renglado[tt+7],saltear3);
              procesar_error_naves(renglado[tt+10],saltear4);
              procesar_error_naves(renglado[tt+13],saltear5)
              end;
          if ( saltear1
             OR saltear2
             OR saltear3
             OR saltear4
             OR saltear5) then
                          begin
                             nosirve:=true;
                             writeln ('Ese skins de naves no sirve por problemas con el archivo. Corr',chr(161),'jalo.');
                             writeln ('Por favor ingrese otra opci',chr(162),'n.');
                             writeln ()
                          end
          else
              begin
                proc_nave_beto (c_conjuntos, tt+1); {"tt+1" es la posición relativa al encabezado que tiene el tag de la nave, siempre}
				proc_nave_n1 (c_conjuntos, tt+4);
				proc_nave_n2 (c_conjuntos, tt+7);
				proc_nave_n3 (c_conjuntos, tt+10);
				proc_velocidad (c_conjuntos, tt+14)
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

