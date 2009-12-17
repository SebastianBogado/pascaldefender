unit log_de_errores; 

interface

uses
    SysUtils; 


    
type
    t_error = (archivo, tipo_nave, dimension_nave, carac_no_visibles, velocidad);
    t_mx_nave = array[1..2,1..3] of char;
  
          
procedure logueador(error : t_error);
procedure procesar_error_naves(var cadena : string);
function caracteres_validos(skin_nave : t_mx_nave) : boolean; 
 
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

    
{
El procedimiento que guarda el tipo de error cometido si se encuentra algo mal
@param el tipo de error encontrado
@return el log con la fecha y tipo de error escritos
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



procedure procesar_error_naves(var cadena : string);
var error : t_error; 
 {
 Subproceso
 }
  procedure chequeo_dimensiones(var cadena : string[20]);
  var cadena_dimensiones : string[6];
      c , n : byte;
      ancho_alien : integer;
      cadenita : string[1];   
  begin
       {Existe una relación lineal entre el nivel y el ancho del alien:
       n = 1, ancho = 5;
       n = 2, ancho = 4;
       n = 3, ancho = 3;
       n + ancho = 6, será nuestra variable c, y n está en cadena[9]
       }
       c := 6;
       n := byte(cadena[9]);
       {c - n = ancho alien}
       ancho_alien := c - n;
       str(ancho_alien,cadenita);
       cadena_dimensiones := copy(cadena, 11, 5); 

       if (cadena_dimensiones <> ('[2x' + cadenita)) then
          begin
               error := dimension_nave;
               logueador(error);
          end; 
         
  end; 
 
 {
 Subproceso
 }
  procedure chequeo_alien(var cadena : string[20]);
  var cadena_nave : string[12];
  begin
       cadena_nave := copy(cadena, 1, 10); 

       if ((cadena_nave = '[alien_n1]')
        or (cadena_nave = '[alien_n2]')
        or (cadena_nave = '[alien_n3]')) then
        
        chequeo_dimensiones(cadena) 
     
       else
           begin
                error := tipo_nave;
                logueador(error);
           end;
  end;   
 
 {
 Subproceso
 chequea, además de Beto, la dimensión y que esté bien escrito "[velocidad]",
 porque eran cositas cortas
 }
  procedure chequeo_beto(var cadena : string[20]);
  var cadena_nave : string[8];
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
                          end
               else
                   begin
                        error := tipo_nave;
                        logueador(error);
                   end;
               end;
       end;
  end;   
{
Cuerpo principal del proceso
}    
begin
     {las cadenas levantadas, para que estén correctas tienen que medir 15,
     en el caso de los marcianos, u 11 para Beto}
     case length(cadena) of
          15 : chequeo_alien(cadena);
          11 : chequeo_beto(cadena);
          else
              begin
                   error := tipo_nave;
                   logueador(error);
              end;
     end;
end;  

end.
