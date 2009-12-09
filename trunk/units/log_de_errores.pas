unit log_de_errores;
{NO COMPILA, error log_de_errores.pas(187,1) Fatal: Syntax error, "BEGIN" expected but "END" found}
interface

const
   MAX_LINEA = 20; {ninguna l�nea levantada va a tener m�s que 15 caracteres. 
   le puse un poquito m�s no s� por qu�
   adem�s, la puse ac� la constante porque la uso en la funci�n de abajo, no s� 
   si est� bien. @todo justificar}

type
   t_error = (archivo, tipo_nave, dimension_nave, carac_no_visibles, velocidad);
   
var
   error : t_error; {una hermosa variable global}
   log : text;
{
esto puede estar sujeto a modificaciones
est� pensado para leer la informaci�n del archivo si linea_erronea devuelve false
y el procedimiento s�lo se usar�a, externamente, cuando el archivo no se encontrase,
por eso puse a error como global
por supuesto que tambi�n lo va a usar la unit
} 
function linea_erronea(linea : string[MAX_LINEA]) : boolean;
procedure escritura_log();

{==========================================================================}

implementation

{no s� si las siguientes librer�as deber�a ponerlas arriba. las puse ac� porque 
solamente las uso para esta unit}
uses   
   sysutils;
   {crt;} {@todo verificar si la us�, jaja, la puse por default XD}
   
const
   DIRECTORIO_LOG =  ''; {@todo completar con el directorio, que no s� d�nde va :P}
   SEP = ',';
   {textos de error a continuaci�n}
   ER_ARCHIVO = 'No se pudo abrir el archivo'; 
   ER_TIPO_NAVE = 'Tipo de nave no reconocida';
   ER_DIMENSION_NAVE = 'Dimension de nave invalida';
   ER_CARAC_NO_VISIBLES = 'Caracteres en blanco';
   ER_VELOCIDAD = 'La velocidad es un numero no valido';
   {tipos de opciones a continuaci�n}
   OP_NAVE = 'nave';
   OP_MARCIANO = 'marciano';
   OP_VELOCIDAD = 'velocidad';
 

   
{
@param la linea con algo inv�lido
@return el tipo de error, para luego trabajar con el archivo log
@todo toda la funci�n jaja. si es que la necesito, en realidad...
}
function identificar_error(linea_erronea : string[MAX_LINEA]) : t_error; 
{podr�a limitarse el tama�o de la cadena, string[15]}

   
begin
   identificar_error := archivo; {lo puse para que Pascal no jodiera, borrarlo}
end;


{
@param el tipo de opcion que se est� modificando (nave de Beto, marcianos o 
velocidad)
@return true si es inv�lida la opci�n, false si es v�lida, indicando, a la vez,
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
   no sea m�s larga que la opci�n}
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
@param como la funcion de arriba, pero para la dimension. quiz�s podr�a fusionarlas, 
pero primero la tengo que escribir
@return "   "    "....
@todo toda
}
function dimension_invalida(dimension : string[5]) : boolean;


{
@param esta recibe el string le�do y lo transforma en real. estoy haci�ndolas
todas parecidas para ver si las puedo unir en una sola, aunque todav�a no s� c�mo
@return true o false...
@todo hacerla
}
function velocidad_invalida(velocidad : string[5]) : boolean;


{
@param linea le�da del archivo de opciones
@return true si hay un error, false si no lo hay
@todo terminarla: falta ver la validaci�n de las dimensiones, que las naves tengan
por lo menos 1 caracter visible, velocidad
}
function linea_erronea(linea : string[MAX_LINEA]) : boolean;
var
   hay_error : boolean;
   primera_letra : char;
   pos_corchete : byte; {ver si la uso}
   dimensiones : string[5]; {otra vez, un poquito m�s de lo que ser�a (ser�a 3)}
   
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
   {else}{quiz�s implemente un case ac�...}
     
 

end;


{
@param ninguno, el error es variable global y el archivo se usa s�lo ac�
@return el log de errores escrito
@todo implementar el tema de la fecha y horario
  y solucionar problema de compilaci�n
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
{lo pongo as� por las dudas, ser�a ideal que esto no sucediera, pero qu� s� yo}
   end;
   
end;


end.