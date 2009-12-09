unit log_de_errores;
{NO COMPILA, error log_de_errores.pas(187,1) Fatal: Syntax error, "BEGIN" expected but "END" found}
interface

const
   MAX_LINEA = 20; {ninguna línea levantada va a tener más que 15 caracteres. 
   le puse un poquito más no sé por qué
   además, la puse acá la constante porque la uso en la función de abajo, no sé 
   si está bien. @todo justificar}

type
   t_error = (archivo, tipo_nave, dimension_nave, carac_no_visibles, velocidad);
   
var
   error : t_error; {una hermosa variable global}
   log : text;
{
esto puede estar sujeto a modificaciones
está pensado para leer la información del archivo si linea_erronea devuelve false
y el procedimiento sólo se usaría, externamente, cuando el archivo no se encontrase,
por eso puse a error como global
por supuesto que también lo va a usar la unit
} 
function linea_erronea(linea : string[MAX_LINEA]) : boolean;
procedure escritura_log();

{==========================================================================}

implementation

{no sé si las siguientes librerías debería ponerlas arriba. las puse acá porque 
solamente las uso para esta unit}
uses   
   sysutils;
   {crt;} {@todo verificar si la usé, jaja, la puse por default XD}
   
const
   DIRECTORIO_LOG =  ''; {@todo completar con el directorio, que no sé dónde va :P}
   SEP = ',';
   {textos de error a continuación}
   ER_ARCHIVO = 'No se pudo abrir el archivo'; 
   ER_TIPO_NAVE = 'Tipo de nave no reconocida';
   ER_DIMENSION_NAVE = 'Dimension de nave invalida';
   ER_CARAC_NO_VISIBLES = 'Caracteres en blanco';
   ER_VELOCIDAD = 'La velocidad es un numero no valido';
   {tipos de opciones a continuación}
   OP_NAVE = 'nave';
   OP_MARCIANO = 'marciano';
   OP_VELOCIDAD = 'velocidad';
 

   
{
@param la linea con algo inválido
@return el tipo de error, para luego trabajar con el archivo log
@todo toda la función jaja. si es que la necesito, en realidad...
}
function identificar_error(linea_erronea : string[MAX_LINEA]) : t_error; 
{podría limitarse el tamaño de la cadena, string[15]}

   
begin
   identificar_error := archivo; {lo puse para que Pascal no jodiera, borrarlo}
end;


{
@param el tipo de opcion que se está modificando (nave de Beto, marcianos o 
velocidad)
@return true si es inválida la opción, false si es válida, indicando, a la vez,
 el tipo de error
}
function opcion_invalida(tipo_de_opcion,linea : string[MAX_LINEA]) : boolean;

var
   hay_error : boolean;
   linea_truncada : string[MAX_LINEA];
   long_tipo_de_opcion : byte;   
   
begin
   long_tipo_de_opcion := length(tipo_de_opcion);
   if pos(']',linea) = (long_tipo_de_opcion + 2) then {verifica, de entrada, que 
   no sea más larga que la opción}
      begin
         linea_truncada := copy(linea,2,long_tipo_de_opcion);
         if linea_truncada =  OP_NAVE then
            hay_error := false
         else
            begin 
               hay_error := true;
               error := tipo_nave; {si la palabra no es exactamente como debe ser,
               se da un error de nave no reconocida}
            end;
      end
   else
      begin
         hay_error := true;
         error := tipo_nave; {si la palabra no tiene el mismo largo, se da un error
         de nave no reconocida}
      end;
   opcion_invalida := hay_error;
end; 

{
@param como la funcion de arriba, pero para la dimension. quizás podría fusionarlas, 
pero primero la tengo que escribir
@return "   "    "....
@todo toda
}
function dimension_invalida(dimension : string[5]) : boolean;


{
@param esta recibe el string leído y lo transforma en real. estoy haciéndolas
todas parecidas para ver si las puedo unir en una sola, aunque todavía no sé cómo
@return true o false...
@todo hacerla
}
function velocidad_invalida(velocidad : string[5]) : boolean;


{
@param linea leída del archivo de opciones
@return true si hay un error, false si no lo hay
@todo terminarla: falta ver la validación de las dimensiones, que las naves tengan
por lo menos 1 caracter visible, velocidad
}
function linea_erronea(linea : string[MAX_LINEA]) : boolean;
var
   hay_error : boolean;
   primera_letra : char;
   pos_corchete : byte; {ver si la uso}
   dimensiones : string[5]; {otra vez, un poquito más de lo que sería (sería 3)}
   
begin
   if ( linea[1] = '[' ) then
      begin
         primera_letra := linea[2];
         case primera_letra of
            'n' : hay_error := opcion_invalida(OP_NAVE,linea);
            'm' : hay_error := opcion_invalida(OP_MARCIANO,linea);
            'v' : hay_error := opcion_invalida(OP_VELOCIDAD,linea);
         else
            hay_error := true;
         end;
      end
   {else}{quizás implemente un case acá...}
     
 

end;


{
@param ninguno, el error es variable global y el archivo se usa sólo acá
@return el log de errores escrito
@todo implementar el tema de la fecha y horario
  y solucionar problema de compilación
}   
procedure escritura_log();

var
   log : text;
   
begin
   assign(log,DIRECTORIO_LOG);
   {$i-}
   append(log);
   {$i+}
   if IOresult <> 0 then
      rewrite(log);
   write(log,{fecha,}SEP,{hora,}SEP);
   case error of
      archivo : writeln(log,ER_ARCHIVO);
      tipo_nave : writeln(log,ER_TIPO_NAVE);
      dimension_nave : writeln(log,ER_DIMENSION_NAVE);
      carac_no_visibles : writeln(log,ER_CARAC_NO_VISIBLES);
      {velocidad : writeln(log,ER_VELOCIDAD);} {saco los corchetes y tira error...}
   {else
      writeln(log,'Error no reconocido');}
{lo pongo así por las dudas, sería ideal que esto no sucediera, pero qué sé yo}
   end;
   
end;


end.