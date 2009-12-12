unit pantalla_opciones; 
{interfaz de opciones de naves y velocidad}

interface
 function correr_opciones():t_pantalla;
uses
    crt,
    pdcommons,
    graficador;

function correr_opciones():t_pantalla;


implementation

uses
    pdcommons,
    crt,
    opciones; {y la(s) unit(s) de usuario}
    

{
Muestra la pantalla de opciones, y espera que el usuario seleccione
una opción.
@return t_pantalla La pantalla a la que el usuario quiere acceder
}
function correr_opciones(): t_pantalla;

var
    pantalla_seleccionada: t_pantalla;

begin
    pantalla_seleccionada := opciones;
    graficar_opciones();

    while(pantalla_seleccionada = opciones) do
        pantalla_seleccionada := pedir_opcion();

    correr_opciones := pantalla_seleccionada;
end; 


{
Muestra las todas opciones, y sub-opciones
@returns t_pantalla La pantalla que debe correrse a continuación
@todo completar el case
}

function pedir_opcion():t_pantalla;

var
   tecla_ingresada : char;
   pantalla_seleccionada : t_pantalla;

begin
    graficar_opciones();
    c := readkey();
    case c of
         '1' : pantalla_seleccionada := {función opciones_juego que devuelva
               t_pantalla, que será siempre "opciones" e incluya 
               graficar_opciones_juego();}
                    
                    
         '2' : pantalla_seleccionada := {función modificar_datos que devuelva
               t_pantalla, que será siempre "opciones" e incluya 
               graficar_modificacion_datos();} 
               
               
         '3' : pantalla_seleccionada := {función baja_usuario que devuelva
               t_pantalla, que será siempre "opciones" e incluya 
               graficar_baja_usuario();}                     
                 
         '4' : pantalla_seleccionada := {función cambiar_usuario que devuelva
               t_pantalla, que será siempre "login" e incluya 
               graficar_login();}          
               
         '0' : pantalla_seleccionada := introduccion;
   
    end;
    
    
    pedir_opcion := pantalla_seleccionada;
end;

end.   
