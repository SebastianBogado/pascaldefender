unit loginmas;

interface

uses
    crt,
    sysutils,
    pdbase,
    dateutils;

const MAX_USUARIOS=1000;   //Hasta 1000 usuarios, se podría hacer asignando memoria dinámica y no tener ninguna otra reestricción mas que el heap.
	  OCULTO=0;
	  ALFANUMERICO=1;
	  NUMERICO=2;
	  ALFABETICO=3;
	  AFIRMA_NIEGA=4;

type
	Ficha_Jugador = record
				Marca:byte;
				Nombre: string[20];
				Apellido: string[20];
				Mail: string[40];
				Usuario: string[8];
				Clave: string[8];
				Pregunta: string[1];
				Respuesta: string[20];
				Ultimo_Ingreso:string[8];
				end;

	Ficha_Jugador_Usuario_Indice = record
				Usuario: string[8];
				Posicion: longint;
				end;

	Indice_Usuarios = array[1..MAX_USUARIOS] of Ficha_Jugador_Usuario_Indice;

	Ficha_Jugador_Fecha_Indice = Record

				Ultimo_Ingreso: string[8];
				Posicion: longint;
				end;
	Indice_Fecha = array[1..MAX_USUARIOS] of Ficha_Jugador_Fecha_Indice;

	 t_Fecha=record
     dia: byte;
     mes: byte;
     anio: integer;
     end;

     tsalvacion=string[5];
var
   Participante: Ficha_Jugador;
   INDICE_DAT:longint;
   administrador:boolean;


procedure Menu_Login_Principal (var participante:Ficha_Jugador);
procedure Baja_Usuario(var Participante:Ficha_Jugador; var INDICE_ARCHIVO_DAT:longint);
procedure Modificar_Usuario(var Participante:Ficha_Jugador; var INDICE_ARCHIVO_DAT:longint);
function Ingresa_Usuario(var Jugador:Ficha_Jugador; var INDICE_DAT:longint; var administrador:boolean):boolean;
procedure Listar_Usuarios_Inactivos (var diasa:tsalvacion);
procedure Actualizar_Usuarios_Dat;

implementation

uses
    graficador;

function CalcJuliano(dia, mes, ano: integer): longint;
var
  anospn, aux: real;
  c : real;
begin
{  yy:= 1.0 * yyyy + (1.0 * mm - 2.85) / 12;}
  anospn:= 1.0 * ano;
  aux:= (1.0 * mes - 2.85) / 12;
  anospn:= anospn + aux;
  if ((longint(ano) * 10000) + (mes * 100) + dia) <= 15821004 then
     c:= 0.75 * 2
  else
     c:= 0.75 * trunc(anospn / 100);
     CalcJuliano:= trunc(
           trunc(
           trunc(367 * anospn) - 1.75 * trunc(anospn) + dia) - c) + 1721115
end;


function RestarFecha (f1, f2: t_Fecha):integer;
begin
  RestarFecha := CalcJuliano(f1.dia, f1.mes, f1.anio) - CalcJuliano(f2.dia,f2.mes,f2.anio);
end;


function CompararStringFechas (s1,s2:string[8]):integer;
var
   sdia1,smes1,sdia2,smes2:string[2];
   sanio1,sanio2:string[4];
   cod:integer;
   fecha1,fecha2:t_Fecha;

begin
   sanio1:=s1[1]+s1[2]+s1[3]+s1[4];
   smes1:=s1[5]+s1[6];
   sdia1:=s1[7]+s1[8];

   sanio2:=s2[1]+s2[2]+s2[3]+s2[4];
   smes2:=s2[5]+s2[6];
   sdia2:=s2[7]+s2[8];

   val (sanio1,fecha1.anio,cod);
   val (smes1,fecha1.mes,cod);
   val (sdia1,fecha1.dia,cod);

   val (sanio2,fecha2.anio,cod);
   val (smes2,fecha2.mes,cod);
   val (sdia2,fecha2.dia,cod);

   compararstringfechas:=RestarFecha(fecha1, fecha2)

end;





Function Existe_Archivo(Nombre_Archivo: String ):boolean;
Var F: File;
begin
{$I-}
Assign(F ,Nombre_Archivo) ;
Reset(F);
{$I+}
Existe_Archivo:=(IoResult=0) and (Nombre_Archivo<> '');
Close(F);
end;





function Caracter_Valido(c:char; estilo:byte):boolean;

begin
if ((estilo=0) or (estilo=1)) and (c in ['0'..'9','A'..'Z','a'..'z','@','.',',',chr(32),chr(160)..chr(165)]) then Caracter_Valido:=true
else
if (estilo=2) and (c in ['0'..'9']) then Caracter_Valido:=true
else
if (estilo=3) and (c in ['a'..'z','A'..'Z','@','.',',',chr(32),chr(160)..chr(165)]) then Caracter_Valido:=true
else
if (estilo=4) and (c in ['s','S','n','N']) then Caracter_Valido:=true
else
Caracter_Valido:=false;

end;



Procedure leecampo(var item:byte; var entrada:string; longitud:byte; estilo:byte);
var 
i,j: byte;
item_actual: byte;
ini_fila,ini_col: byte;
c:char;

begin

item_actual:=item;
i:=length(entrada); 


textcolor(BLACK);
textbackground(WHITE);

ini_fila:=wherey;
ini_col:=wherex;

for j:=1 to longitud do
write(' ');

gotoxy(ini_col,ini_fila);

if estilo<>0 then
write(entrada)
else
for j:=1 to i do write('*');


Repeat 

c:=readkey(); 

case c of

#8:
if i>0 then 
begin
write(c); write(' '); write(c); 
delete(entrada,i,1);
dec(i);
end;

#0: case readkey() of
     #72,#75: begin
			  c:=#0;
			  dec(item);
			  end;
	 #80,#77: begin
		   	  c:=#0;
			  inc(item);
			  end;
    end;

#27: begin 
     item:=255;
	 end;

	 
#13: begin
     inc(item);
	 end;

else 
if (i<longitud) and Caracter_Valido(c,estilo) then
begin
if estilo<>0 then Write(c) else Write('*');
entrada:=entrada+c;
inc(i);
end

end;  //Fin case

until item_actual<>item;

textcolor(WHITE);
textbackground(CYAN);

gotoxy(ini_col,ini_fila);
for j:=1 to longitud do write(' ');

gotoxy(ini_col,ini_fila);

if estilo<>0 then
write(entrada)
else
for j:=1 to i do write('*');

textcolor(WHITE);
textbackground(BLACK);


end;

procedure Intercambio(var a,b: Ficha_Jugador_Usuario_Indice);
var
   aux : Ficha_Jugador_Usuario_Indice;
   
begin
   aux := a;
   a := b;
   b := aux;
end;

procedure Intercambia_X_Fecha(var a,b: Ficha_Jugador_Fecha_Indice);
var
   aux : Ficha_Jugador_Fecha_Indice;
   
begin
   aux := a;
   a := b;
   b := aux;
end;




procedure Indexa_X_Usuarios(var f:file of Ficha_Jugador);
var
   h:file of Ficha_Jugador_Usuario_Indice;
   indice:Indice_Usuarios;
   registro:Ficha_Jugador;   
   i,j,cantidad_registros: longint;
   no_intercambio : boolean;
 
begin

 reset(f);
 cantidad_registros:=filesize(f);

 j:=1; 
 for i:=1 to cantidad_registros do
 begin 
 read(f,registro);
  if registro.Marca<>255 then
  begin
  indice[j].Usuario := upcase(registro.Usuario);
  indice[j].Posicion:= (filepos(f)-1);
  inc(j);
  end;
 end;

 //Ordena con Método Burbuja Mejorado.

 i := 1;
   repeat
      no_intercambio := true;
      for j := 1 to (cantidad_registros - i) do
         if indice[j].Usuario > indice[j+1].Usuario then
            begin
               Intercambio(indice[j],indice[j+1]);
               no_intercambio := false;
            end;
      inc(i);
   until ((i = cantidad_registros) or (no_intercambio));
 
 assign(h,'usuarios.idx');
 rewrite(h);
 reset(h);
 
 for i:=1 to cantidad_registros do
 begin
 write(h,indice[i]);
 end;
 close(h);

 
end;

procedure Indexa_X_Fecha(var f:file of Ficha_Jugador);

var
   h:file of Ficha_Jugador_Fecha_Indice;
   indice:Indice_Fecha;
   registro:Ficha_Jugador;   
   i,j,cantidad_registros: longint;
   no_intercambio : boolean;
 
begin

 reset(f);
 cantidad_registros:=filesize(f);

 j:=1; 
 for i:=1 to cantidad_registros do
 begin 
 read(f,registro);
  if registro.Marca<>255 then
  begin
  indice[j].Ultimo_Ingreso := registro.Ultimo_Ingreso;
  indice[j].Posicion:= (filepos(f)-1);
  inc(j);
  end;
 end;

 //Ordena con Método Burbuja Mejorado.

 i := 1;
   repeat
      no_intercambio := true;
      for j := 1 to (cantidad_registros - i) do
         if indice[j].Ultimo_Ingreso > indice[j+1].Ultimo_Ingreso then
            begin
               Intercambia_X_Fecha(indice[j],indice[j+1]);
               no_intercambio := false;
            end;
      inc(i);
   until ((i = cantidad_registros) or (no_intercambio));
 
 assign(h,'fechas.idx');
 rewrite(h);
 reset(h);
 
 for i:=1 to cantidad_registros do
 begin
 write(h,indice[i]);
 end;
 close(h);

 
end;


Procedure Actualizar_Usuarios_Dat;

var
   fusers, fusbak, fusaux: file of Ficha_Jugador;
   ultima_depuracion,hoy:string[8];
   f_ud: file of string[8];
   usuario: Ficha_Jugador;

Begin
	
	hoy:= formatdatetime ('YYYYMMDD', now); 
		
	if not Existe_Archivo('depurado.dat') then
	begin
	assign (f_ud,'depurado.dat');
	rewrite(f_ud);
	write(f_ud,hoy);
	close(f_ud);	
	end 
		
		else
		
		if Existe_Archivo('usuarios.dat') then
			begin
			assign (f_ud,'depurado.dat');
			reset  (f_ud);
			read(f_ud,ultima_depuracion);
			close(f_ud);
		
			if CompararStringFechas(hoy,ultima_depuracion) > 30 then
				begin
				assign (fusers, 'usuarios.dat');
				assign (fusbak, 'usuarios.bak');
				assign (fusaux, 'usersaux.dat');
				reset  (fusers);
				rewrite(fusbak);
				rewrite(fusaux);
		
				while not eof(fusers) do
				Begin
					read(fusers, usuario);
					write(fusbak, usuario);
					if usuario.marca <> 255 then write(fusaux, usuario);
				end;	
				close(fusers);
				close(fusaux);
				close(fusbak);

				
				
				assign (fusers, 'usuarios.dat');
				erase  (fusers);
				
				assign (fusaux, 'usersaux.dat');
				rename (fusaux, 'usuarios.dat');

				Indexa_X_Usuarios(fusaux);
				
				close(fusaux);
				
				hoy:= formatdatetime ('YYYYMMDD', now); 
				assign (f_ud,'depurado.dat');
				rewrite(f_ud);
				write(f_ud,hoy);
				close(f_ud);	
				
				end;
		end;
end;



function Posicion_Usuario_Idx(usuario_buscado: string[8]; var archivo_idx: File of Ficha_Jugador_Usuario_Indice):longint;

var
   i,inicio,medio,fin: longint;
   encontrado:  boolean;
   posicion:    longint;
   v_indice:    Indice_Usuarios;
   registro:    Ficha_Jugador_Usuario_Indice;
 
   
begin

   reset(archivo_idx);
   fin:= filesize(archivo_idx);
   
   for i:=1 to fin do
   begin 
   read(archivo_idx,registro);
   v_indice[i].Usuario := registro.Usuario;
   v_indice[i].Posicion:= registro.Posicion;
   end;

   inicio:= 1;
   encontrado:= false;
   posicion:= -1;

   while ((not encontrado) and (inicio <= fin)) do
      begin
         medio := (inicio + fin) div 2;
         if v_indice[medio].Usuario = upcase(usuario_buscado) then
            encontrado:= true
			else
            if v_indice[medio].Usuario > upcase(usuario_buscado) then fin := medio - 1 else inicio := medio + 1;
      end;
   if encontrado then
      posicion := medio-1;
      
   Posicion_Usuario_Idx:= posicion;     
end;



procedure Alta_Jugador(var Jugador:Ficha_Jugador);
var

Datos_OK:boolean;
Item: byte;
Confirma:string[1];
Jugador_Idx:Ficha_Jugador_Usuario_Indice;
f: File of Ficha_Jugador;
g: File of Ficha_Jugador_Usuario_Indice;


begin
Item:=1;
Confirma:='N';
Datos_OK:=false;


Jugador.Marca:=65;   //Letra A como marca de registro activo.   255 será cuando sea borrado lógico.
Jugador.Nombre:='';
Jugador.Apellido:='';
Jugador.Mail:='';
Jugador.Usuario:='';
Jugador.Clave:='';
Jugador.Pregunta:='a';
Jugador.Respuesta:='';
// Última fecha de ingreso


textbackground(9);
textcolor(15);

clrscr;
gotoxy(1,1);
write('NUEVO USUARIO');

gotoxy(1,3);
Write('Nombre: ');
gotoxy(1,4);
Write('Apellido: ');
gotoxy(1,5);
Write('Mail: ');
gotoxy(1,6);
Write('Usuario: ');
gotoxy(1,7);
Write('Clave: ');

gotoxy(1,9); write('Elija una de estas preguntas secretas para recordar la contraseña en caso de olvido:');
gotoxy(1,10); write('a- Nombre del primer chico/a que te gust',chr(162));
gotoxy(1,11); write('b- Nombre de la ciudad donde naci',chr(162),' tu abuelo paterno');
gotoxy(1,12); write('c- Nombre del juego preferido en la escuela primaria');
gotoxy(1,13);
Write('Pregunta elegida: ');
gotoxy(1,15);
Write('Respuesta: ');
gotoxy(1,16);
Write('Confirma? (S/N): ');

repeat

while Confirma[1] in['n','N'] do
begin

	case item of

	255: Confirma[1]:='X';  //Sale de Altas!
	
	0:	item:=8;

	1:	begin
		gotoxy(20,3);
		leecampo(item,Jugador.Nombre, 20, ALFANUMERICO);
		end;

	2:	begin 
		gotoxy(20,4);
		leecampo(item,Jugador.Apellido, 20, ALFANUMERICO);
		end;
  
	3:	begin 
		gotoxy(20,5);
		leecampo(item,Jugador.Mail, 40, ALFANUMERICO);
		end;

	4:	begin
		gotoxy(20,6);
		leecampo(item,Jugador.Usuario, 8, ALFANUMERICO);
		end;

	5:	begin
		gotoxy(20,7);
		leecampo(item,Jugador.Clave, 8, OCULTO);
		end;
	6:

		repeat
		item:=6;
		gotoxy(20,13);
		leecampo(item,Jugador.Pregunta, 1, ALFANUMERICO); 
		until Jugador.Pregunta[1] in ['a'..'c','A'..'C'];

	7:
		begin
		gotoxy(20,15);
		leecampo(item,Jugador.Respuesta, 20, ALFANUMERICO);
		end;

	8:	begin
		gotoxy(20,16);
		leecampo(item,Confirma, 1, AFIRMA_NIEGA); 
		end;
	9:
		item:=1;
	
	end;

end;


if Confirma[1] in['s','S'] then

begin

	if (length(Jugador.Usuario)<6) and (upcase(Jugador.Usuario)<>'ADMIN') then
	begin
	textbackground(9);
	textcolor(12);
	gotoxy(20,18); write('EL USUARIO DEBE TENER AL MENOS 6 CARACTERES'); readkey;
	gotoxy(20,18); write('                                           ');
	item:=4;
	Confirma[1]:='N';
	end
	
		else
		if length(Jugador.Clave)<6 then
		begin
		textbackground(9);
		textcolor(12);
		gotoxy(20,18); write('EL PASSWORD DEBE TENER AL MENOS 6 CARACTERES'); readkey;
		gotoxy(20,18); write('                                            ');
		item:=5;
		Confirma[1]:='N';
		end

			else 
				if Existe_Archivo('usuarios.idx') then
				begin
				assign(g,'usuarios.idx');
				reset(g);
				
					if Posicion_Usuario_Idx(Jugador.Usuario,g)<> -1 then 
					begin
					textbackground(9);
					textcolor(12);
					gotoxy(20,18); write('USUARIO EXISTENTE!'); readkey;
					gotoxy(20,18); write('                  ');
					Datos_OK:=false;
					item:=4;
					Confirma[1]:='N';
					end 
					else Datos_OK:=true;
			 
				close(g);
				end

					else Datos_OK:=true;  //Primer Usuario!	
			
end;
	
until (Datos_OK=true) or (Confirma[1]='X');

//______________________________________________

//______________________________________________


if Confirma[1] in ['s','S'] then

begin
	if Existe_Archivo('usuarios.dat') then 
	begin
	assign(f,'usuarios.dat');
	reset(f);
	seek(f, filesize(f));
	Jugador.Ultimo_Ingreso := formatdatetime ('YYYYMMDD', now); 
	write(f, Jugador);
	Indexa_X_Usuarios(f);
    close(f);
	end

	else 
	begin   
	assign(f,'usuarios.dat');
	rewrite(f);
	reset(f);
	Jugador.Ultimo_Ingreso := formatdatetime ('YYYYMMDD', now); 
	write(f, Jugador);
	close(f);
    //Crea archivo indice por usuario.
  
	Jugador_idx.Usuario:=upcase(Jugador.Usuario);
	Jugador_idx.Posicion:=0;
	assign(g,'usuarios.idx');
	rewrite(g);
	reset(g); 
	write(g, Jugador_idx);
	close(g);
	end;
end;

end;

procedure Olvido_Password;

var
Respuesta_Secreta: string[40];
Posi_Idx:longint;
Datos_OK:boolean;
Item: byte;
Confirma:string[1];
Usuario:string[8];
registro:Ficha_Jugador;
Jugador_Idx:Ficha_Jugador_Usuario_Indice;
f: File of Ficha_Jugador;
g: File of Ficha_Jugador_Usuario_Indice;

begin
Item:=1;
Confirma:='N';
Datos_OK:=false;

Usuario:='';


textbackground(12);
clrscr;
gotoxy(1,1);
write('RECORDAR PASSWORD');


repeat
textbackground(12);  //ver
textcolor(15);

		gotoxy(1,6);
		Write('Usuario: ');

		leecampo(item,Usuario, 8, ALFANUMERICO);
		if item=255 then Confirma[1]:='X';
        
	    if ((length(Usuario)<6) and (upcase(Usuario)<>'ADMIN')) and (item<>255) then
		
			begin
			textbackground(12);
			textcolor(15);
			gotoxy(20,18); write('EL USUARIO DEBE TENER AL MENOS 6 CARACTERES'); readkey;
			gotoxy(20,18); write('                                           ');
			
			end
	
		else
		

			if Existe_Archivo('usuarios.idx') then
		
					begin
					assign(g,'usuarios.idx');
					reset(g);
					Posi_Idx:=Posicion_Usuario_Idx(Usuario,g);
									    
						if Posi_Idx<> -1 then   //Si el Usuario Exite entonces...
						
							begin
							seek(g,Posi_Idx);
							read(g,Jugador_Idx);
							assign(f,'usuarios.dat');
							reset(f);
							seek(f,Jugador_idx.Posicion);
							read(f,registro);
							close(f);
						
							gotoxy(1,10);
							textbackground(12);
							textcolor(15);
								
						
							case registro.Pregunta[1] of
						
								'a':write('Nombre del primer chico/a que te gust',chr(162),': ');
								'b':write('Nombre de la ciudad donde naci',chr(162),' tu abuelo paterno: ');
								'c':write('Nombre del juego preferido en la escuela primaria: ');
						
							end;
						
							leecampo(item,Respuesta_Secreta, 20, ALFANUMERICO);
							
							if item=255 then Confirma[1]:='X';
        					
						
							if  (Respuesta_Secreta=registro.Respuesta) and (item<>255) then    //respondió correctamente a la pregunta secreta?
						
								begin
								textbackground(12);
								textcolor(15);
								gotoxy(1,12); write('SU PASSWORD ES: ',registro.Clave); readkey;
								Datos_OK:=true;
								end 
						
								else
							
								begin
								textbackground(12);
								textcolor(15);
								gotoxy(1,10); write('RESPUESTA INCORRECTA                                                '); readkey;
								gotoxy(1,10); write('                                                                    ');
								Datos_OK:=false;
								end;
							
							end

						
						else // si no existe usuario hacer...
					
						begin
						textbackground(12);
						textcolor(15);
						gotoxy(20,18); write('USUARIO INEXISTENTE!'); readkey;
						gotoxy(20,18); write('                    ');
						Datos_OK:=false;
						end;
			 
					close(g);
				end

					else   // si no hay archivo usuarios.idx
					begin
					textbackground(12);
					textcolor(15);
					gotoxy(20,18); write('No hay usuarios registrados!'); readkey;
					gotoxy(20,18); write('                            ');
					Datos_OK:=false;
					Confirma[1]:='X';
					end;
			
until (Datos_OK=true) or (Confirma[1]='X');

end;

//***************************************************************************************



procedure Modificar_Usuario(var Participante:Ficha_Jugador; var INDICE_ARCHIVO_DAT:longint);
var

Datos_OK:boolean;
Item: byte;
Confirma:string[1];
f: File of Ficha_Jugador;

begin
Item:=1;
Confirma:='N';
Datos_OK:=false;

textbackground(9);
textcolor(15);

clrscr;
gotoxy(1,1);
write('MODIFICAR USUARIO');

gotoxy(1,3);
Write('Nombre: ');
gotoxy(1,4);
Write('Apellido: ');
gotoxy(1,5);
Write('Mail: ');
gotoxy(1,7);
Write('Clave: ');

gotoxy(1,9); write('Elija una de estas preguntas secretas para recordar la contraseña en caso de olvido:');
gotoxy(1,10); write('a- Nombre del primer chico/a que te gust',chr(162));
gotoxy(1,11); write('b- Nombre de la ciudad donde naci',chr(162),' tu abuelo paterno');
gotoxy(1,12); write('c- Nombre del juego preferido en la escuela primaria');
gotoxy(1,13);
Write('Pregunta elegida: ');
gotoxy(1,15);
Write('Respuesta: ');
gotoxy(1,16);
Write('Confirma? (S/N): ');

repeat

while Confirma[1] in['n','N'] do
begin

	case item of

	255: Confirma[1]:='X';  //Sale de Altas!
	
	0:	item:=1;

	1:	begin
		gotoxy(20,3);
		leecampo(item,Participante.Nombre, 20, ALFANUMERICO);
		end;

	2:	begin 
		gotoxy(20,4);
		leecampo(item,Participante.Apellido, 20, ALFANUMERICO);
		end;
  
	3:	begin 
		gotoxy(20,5);
		leecampo(item,Participante.Mail, 40, ALFANUMERICO);
		end;

		
	4:	begin
		gotoxy(20,7);
		leecampo(item,Participante.Clave, 8, OCULTO);
		end;
		
	5:	repeat
		item:=5;
		gotoxy(20,13);
		leecampo(item,Participante.Pregunta, 1, ALFANUMERICO); 
		until Participante.Pregunta[1] in ['a'..'c','A'..'C'];

	6:
		begin
		gotoxy(20,15);
		leecampo(item,Participante.Respuesta, 20, ALFANUMERICO);
		end;

	7:	begin
		gotoxy(20,16);
		leecampo(item,Confirma, 1, AFIRMA_NIEGA); 
		end;

	8:
		item:=1;
	
	end;

end;  //fin while.


	if Confirma[1] in['s','S'] then

	begin
		
		if length(Participante.Clave)<6 then
			begin
			textbackground(9);
			textcolor(12);
			gotoxy(20,18); write('EL PASSWORD DEBE TENER AL MENOS 6 CARACTERES'); readkey;
			gotoxy(20,18); write('                                            ');
			item:=5;
			Confirma[1]:='N';
			end
			
			else Datos_OK:=true;  //Primer Usuario!	
			
	end;
	
until (Datos_OK=true) or (Confirma[1]='X');

//______________________________________________

//______________________________________________


	if Confirma[1] in ['s','S'] then

	begin
	assign(f,'usuarios.dat');
	reset(f);
	seek(f, INDICE_ARCHIVO_DAT);
	
	write(f, Participante);
	//Indexa_X_Usuarios(f); No es necesario en este caso ya que no modificamos el usuario.
    close(f);
	end

	
end;



procedure Baja_Usuario(var Participante:Ficha_Jugador; var INDICE_ARCHIVO_DAT:longint);
var
Item: byte;
Confirma:string[1];
f: File of Ficha_Jugador;

begin
Item:=1;
Confirma:='N';

textbackground(0);
textcolor(15);
clrscr;
gotoxy(10,1);
write('BAJA DE USUARIO');


gotoxy(10,14);
Write('El Usuario: ',upcase(Participante.Usuario));
gotoxy(35,14);
Write('ser',chr(160),' eliminado con todos sus datos');

gotoxy(10,16);
Write('Confirma? (S/N): ');

gotoxy(28,16);
leecampo(item,Confirma, 1, AFIRMA_NIEGA); 

if Confirma[1] in['s','S'] then 
	
	begin
	assign(f,'usuarios.dat');
	reset(f);
	seek(f, INDICE_ARCHIVO_DAT);
	Participante.Marca:=255;  //Marca de Borrado Lógico.
	write(f, Participante);
	Indexa_X_Usuarios(f);
    close(f);
	INDICE_ARCHIVO_DAT:=-1;
	gotoxy(35,14);
	Write('FUE ELIMINADO CON EXITO!!!                ');
	readkey;
	end

	
end;





procedure Menu_Bienvenida(var Participante:Ficha_Jugador; var INDICE_DAT:longint);
var
	f: File of Ficha_Jugador;


begin
    {
    guardar la última fecha de ingreso
    }
    assign(f,'usuarios.dat');
	reset(f);
	seek(f, INDICE_DAT);
	Participante.Ultimo_Ingreso := formatdatetime ('YYYYMMDD', now);
	write(f, Participante);
	close(f);

    {
    correr el juego
    }
    textcolor(15);
    TextBackGround(0);
    correr_pd();
    textcolor(15);
    TextBackGround(0)
end;


function Ingresa_Usuario(var Jugador:Ficha_Jugador; var INDICE_DAT:longint; var administrador:boolean):boolean;

var
Password_Dat:string[8];
Posi_Idx:longint;
Datos_OK:boolean;
Item: byte;
Confirma:string[1];
registro:Ficha_Jugador;
Jugador_Idx:Ficha_Jugador_Usuario_Indice;
f: File of Ficha_Jugador;
g: File of Ficha_Jugador_Usuario_Indice;

begin
Item:=1;
Confirma:='N';
Datos_OK:=false;

Jugador.Usuario:='';
Jugador.Clave:='';



// Última fecha de ingreso


textbackground(12);
clrscr;
gotoxy(1,1);
write('INGRESO AL JUEGO');

gotoxy(1,6);
Write('Usuario: ');
gotoxy(1,7);
Write('Clave: ');
gotoxy(1,9);
Write('Confirma? (S/N): ');

repeat
textbackground(12);  //ver
textcolor(15);

while Confirma[1] in['n','N'] do
begin

	case item of

	255: Confirma[1]:='X';  //Sale esta pantalla!

	0:	item:=3;


	1:	begin
		gotoxy(20,6);
		leecampo(item,Jugador.Usuario, 8, ALFANUMERICO);
		end;

	2:	begin
		gotoxy(20,7);
		leecampo(item,Jugador.Clave, 8, OCULTO);
		end;

	3:  begin
		gotoxy(20,9);
		leecampo(item,Confirma, 1, AFIRMA_NIEGA);
		end;

	4:
		item:=1;

	end;

end;

administrador:=false;
    if upcase(Jugador.Usuario)='ADMIN' then
		administrador:=true;

if Confirma[1] in['s','S'] then

	begin

	    if (length(Jugador.Usuario)<6) and (upcase(Jugador.Usuario)<>'ADMIN') then

			begin
			textbackground(12);
			textcolor(15);
			gotoxy(20,18); write('EL USUARIO DEBE TENER AL MENOS 6 CARACTERES'); readkey;
			gotoxy(20,18); write('                                           ');
			item:=1;
			Confirma[1]:='N';
			end

		else

		if length(Jugador.Clave)<6 then
			begin
			textbackground(12);
			textcolor(15);
			gotoxy(20,18); write('EL PASSWORD DEBE TENER AL MENOS 6 CARACTERES'); readkey;
			gotoxy(20,18); write('                                            ');
			item:=2;
			Confirma[1]:='N';
			end

			else
				if Existe_Archivo('usuarios.idx') then

					begin
					assign(g,'usuarios.idx');
					reset(g);
					Posi_Idx:=Posicion_Usuario_Idx(Jugador.Usuario,g);

					if Posi_Idx<> -1 then   //Si el Usuario Exite entonces...

						begin
						seek(g,Posi_Idx);
						read(g,Jugador_Idx);
						INDICE_DAT:=Jugador_Idx.Posicion;
						assign(f,'usuarios.dat');
						reset(f);
						seek(f,INDICE_DAT);
						read(f,registro);

						Jugador.Marca:=registro.Marca;      //Sobreescribo el Jugador pasado como argumento con los datos de su correspondiente registro.
						Jugador.Nombre:=registro.Nombre;    //Excepto el Usuario y el Password, que ya se han ingresado.
						Jugador.Apellido:=registro.Apellido;
						Jugador.Mail:=registro.Mail;
						Jugador.Pregunta:=registro.Pregunta;
						Jugador.Respuesta:=registro.Respuesta;
						Jugador.Ultimo_Ingreso:=registro.Ultimo_Ingreso;

						close(f);

						Password_Dat:=registro.Clave;

							if  Jugador.Clave=Password_Dat then    //El Password es correcto?

								begin

								textbackground(12);
								textcolor(15);
								gotoxy(20,18); write('A JUGAR!'); readkey;
								gotoxy(20,18); write('        ');
								Datos_OK:=true;
								end

								else

								begin
								textbackground(12);
								textcolor(15);
								gotoxy(20,18); write('PASSWORD INVALIDO!!!'); readkey;
								gotoxy(20,18); write('                    ');
								Datos_OK:=false;
								item:=1;
								Confirma[1]:='N';
								end;

						end


					else // si no existe usuario hacer...

					begin
					textbackground(12);
					textcolor(15);
					gotoxy(20,18); write('USUARIO INEXISTENTE!'); readkey;
					gotoxy(20,18); write('                    ');
					Datos_OK:=false;
					item:=1;
					Confirma[1]:='N';
					end;

				close(g);
				end

					else   // si no hay archivo usuarios.idx
					begin
					textbackground(12);
					textcolor(15);
					gotoxy(20,18); write('No hay usuarios registrados!'); readkey;
					gotoxy(20,18); write('                            ');
					Datos_OK:=false;
					Confirma[1]:='X';
					end



	end;

until (Datos_OK=true) or (Confirma[1]='X');

if Datos_OK then Ingresa_Usuario:=true else Ingresa_Usuario:=false;

end;
{
   *
   *
   *
   * }
procedure Listar_Usuarios_Inactivos (var diasa:tsalvacion);

var
Datos_OK:boolean;
Item,coderr,i: byte;
hoy:string[8];
numdias:integer;
reg_indice:Ficha_Jugador_Fecha_Indice;
registro:Ficha_Jugador;
f: File of Ficha_Jugador;
g: File of Ficha_Jugador_Fecha_Indice;



begin
Item:=1;

Datos_OK:=false;

textbackground(0);
textcolor(15);

clrscr;


write('LISTADO DE INACTIVOS');
Write('Personas que no ingresan hace ', diasa ,' d',chr(161),'as.  Sale con 0');

item:=1;


gotoxy(1,5);
writeln('      ____________________________________________________');
writeln('             NOMBRE                APELLIDO       USUARIO');
writeln('      ____________________________________________________');
writeln;
Val(diasa,numdias,coderr);
if (coderr<>0) or (numdias<>0) then

begin

assign(f,'usuarios.dat');
Indexa_X_Fecha(f);
reset(f);

hoy := formatdatetime ('YYYYMMDD', now);

if Existe_Archivo('fechas.idx') then

begin
	assign(g,'fechas.idx');
	reset(g);
	read(g,reg_indice);

	i:=1;

	if EOF(g) then begin write('Archivo IDX al final'); readkey; end;

	while (CompararStringFechas(hoy,reg_indice.Ultimo_Ingreso)>= numdias) and (NOT EOF(g)) do
	begin
	seek(f,reg_indice.Posicion);
	read(f,registro);
	writeln(i:4,'- ',registro.Nombre:20,' ',registro.Apellido:20,' ',registro.Usuario:8);

	read(g,reg_indice);
	inc(i);
	end;


	if i=1 then write('No se encontraron Usuarios inactivos en este per',chr(161),'odo.');

	close(g);
end
else writeln('Lista de Usuarios Vac',chr(161),'a!');

close(f);

end;

end;


procedure Menu_Login_Principal(var Participante:Ficha_Jugador);
var
	op:char;
	salir:boolean;
	IndiceDat:longint;
begin

	IndiceDat:=0;  // Variable que pasará al Menu de Bienvenida la posición del Participante Ingresado.
	salir := false;

	repeat
		clrscr;
        graficar_loginmas();
		op := readkey;
		case op of
			'1': if Ingresa_Usuario(Participante,IndiceDat,administrador) then Menu_Bienvenida(Participante,IndiceDat);
			'2': Alta_Jugador(Participante);
			'3': Olvido_Password;
			'0': salir := true;
		end;
	until salir;
end;

end.
