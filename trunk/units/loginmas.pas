unit loginmas;

interface

uses
    crt,
    sysutils,
    pdbase;

const MAX_USUARIOS=1000;

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

     Ficha_Jugador_Reg_Indice = record
				Usuario: string[8];
				Posicion: longint;
				end;

		Indice_Usuarios = array[1..MAX_USUARIOS] of Ficha_Jugador_Reg_Indice;


var
   Participante: Ficha_Jugador;
   INDICE_DAT:longint;
   administrador:boolean;


procedure Menu_Login_Principal (var participante:Ficha_Jugador);
procedure Baja_Usuario(var Participante:Ficha_Jugador; var INDICE_ARCHIVO_DAT:longint);
procedure Modificar_Usuario(var Participante:Ficha_Jugador; var INDICE_ARCHIVO_DAT:longint);
function Ingresa_Usuario(var Jugador:Ficha_Jugador; var INDICE_DAT:longint):boolean;

implementation

uses
    graficador;

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


Procedure leecampo(var item:byte; var entrada:string; longitud:byte; visualiza:boolean);
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

if visualiza then
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
     c:=#0;
	 item:=255;
	 end;


#13: begin
     c:=#0;
     inc(item);
	 end;

else
if (i<longitud) and (c<>#0) then
begin
if visualiza then Write(c) else Write('*');
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

if visualiza then
write(entrada)
else
for j:=1 to i do write('*');

textcolor(WHITE);
textbackground(BLACK);


end;

procedure Intercambio(var a,b: Ficha_Jugador_Reg_Indice);
var
   aux : Ficha_Jugador_Reg_Indice;

begin
   aux := a;
   a := b;
   b := aux;
end;



procedure Indexa_X_Usuarios(var f:file of Ficha_Jugador);
var
   h:file of Ficha_Jugador_Reg_Indice;
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

 //Ordena con M�todo Burbuja Mejorado.

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


function Posicion_Usuario_Idx(usuario_buscado: string[8]; var archivo_idx: File of Ficha_Jugador_Reg_Indice):longint;

var
   i,inicio,medio,fin: longint;
   encontrado:  boolean;
   posicion:    longint;
   v_indice:    Indice_Usuarios;
   registro:    Ficha_Jugador_Reg_Indice;


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
Jugador_Idx:Ficha_Jugador_Reg_Indice;
f: File of Ficha_Jugador;
g: File of Ficha_Jugador_Reg_Indice;


begin
Item:=1;
Confirma:='N';
Datos_OK:=false;


Jugador.Marca:=65;   //Letra A como marca de registro activo.   255 ser� cuando sea borrado l�gico.
Jugador.Nombre:='';
Jugador.Apellido:='';
Jugador.Mail:='';
Jugador.Usuario:='';
Jugador.Clave:='';
Jugador.Pregunta:='a';
Jugador.Respuesta:='';
// �ltima fecha de ingreso


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

gotoxy(1,9); write('Elija una de estas preguntas secretas para recordar la contrase',chr(164),'a en caso de olvido:');
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
		leecampo(item,Jugador.Nombre, 20, true);
		end;

	2:	begin
		gotoxy(20,4);
		leecampo(item,Jugador.Apellido, 20, true);
		end;

	3:	begin
		gotoxy(20,5);
		leecampo(item,Jugador.Mail, 40, true);
		end;

	4:	begin
		gotoxy(20,6);
		leecampo(item,Jugador.Usuario, 8, true);
		end;

	5:	begin
		gotoxy(20,7);
		leecampo(item,Jugador.Clave, 8, false);
		end;
	6:

		repeat
		item:=6;
		gotoxy(20,13);
		leecampo(item,Jugador.Pregunta, 1, true);
		until Jugador.Pregunta[1] in ['a'..'c','A'..'C'];

	7:
		begin
		gotoxy(20,15);
		leecampo(item,Jugador.Respuesta, 20, true);
		end;

	8:
		repeat
		item:=8;
		gotoxy(20,16);
		leecampo(item,Confirma, 1, true);
		until Confirma[1] in['S','s','N','n'];

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
				write('Existe USUARIOS.IDX');
				readkey;
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
	writeln('CASO 2: usuarios.dat existe!');
	readkey;
	assign(f,'usuarios.dat');
	reset(f);
	seek(f, filesize(f));
	Jugador.Ultimo_Ingreso := formatdatetime ('DDMMYYYY', now);
	write(f, Jugador);
	Indexa_X_Usuarios(f);
    close(f);
	end

	else
	begin
	writeln('CASO 1 Nuevo archivo y graba');
	readkey;
	assign(f,'usuarios.dat');
	rewrite(f);
	reset(f);
	Jugador.Ultimo_Ingreso := formatdatetime ('DDMMYYYY', now);
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
Jugador_Idx:Ficha_Jugador_Reg_Indice;
f: File of Ficha_Jugador;
g: File of Ficha_Jugador_Reg_Indice;

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

		leecampo(item,Usuario, 8, true);
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

							leecampo(item,Respuesta_Secreta, 20, true);

							if item=255 then Confirma[1]:='X';


							if  (Respuesta_Secreta=registro.Respuesta) and (item<>255) then    //respondi� correctamente a la pregunta secreta?

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
gotoxy(1,6);
Write('Ultimo Ingreso: ',Participante.Ultimo_Ingreso);
gotoxy(1,7);
Write('Clave: ');

gotoxy(1,9); write('Elija una de estas preguntas secretas para recordar la contrase�a en caso de olvido:');
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
		leecampo(item,Participante.Nombre, 20, true);
		end;

	2:	begin
		gotoxy(20,4);
		leecampo(item,Participante.Apellido, 20, true);
		end;

	3:	begin
		gotoxy(20,5);
		leecampo(item,Participante.Mail, 40, true);
		end;


	4:	begin
		gotoxy(20,7);
		leecampo(item,Participante.Clave, 8, false);
		end;

	5:	repeat
		item:=5;
		gotoxy(20,13);
		leecampo(item,Participante.Pregunta, 1, true);
		until Participante.Pregunta[1] in ['a'..'c','A'..'C'];

	6:
		begin
		gotoxy(20,15);
		leecampo(item,Participante.Respuesta, 20, true);
		end;

	7:
		repeat
		item:=7;
		gotoxy(20,16);
		leecampo(item,Confirma, 1, true);
		until Confirma[1] in['S','s','N','n'];

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
	Indexa_X_Usuarios(f);
    close(f);
	end


end;



procedure Baja_Usuario(var Participante:Ficha_Jugador; var INDICE_ARCHIVO_DAT:longint);
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
gotoxy(10,1);
write('BAJA DE USUARIO');


gotoxy(10,14);
Write('El Usuario: ',upcase(Participante.Usuario),' ser',chr(160),' eliminado con todos sus datos');

gotoxy(10,16);
Write('Confirma? (S/N): ');

repeat

while Confirma[1] in['n','N'] do
begin

	case item of

	255: Confirma[1]:='X';  //Sale de Altas!

	0:	item:=1;

	1:	repeat
		item:=1;
		gotoxy(28,16);
		leecampo(item,Confirma, 1, true);
		until Confirma[1] in['S','s','N','n'];

	2:
		item:=1;

	end;

end;  //fin while.


	if Confirma[1] in['s','S'] then Datos_OK:=true;



until (Datos_OK=true) or (Confirma[1]='X');

//______________________________________________

//______________________________________________


	if Confirma[1] in ['s','S'] then

	begin
	assign(f,'usuarios.dat');
	reset(f);
	seek(f, INDICE_ARCHIVO_DAT);
	Participante.Marca:=255;  //Marca de Borrado L�gico.
	write(f, Participante);
	Indexa_X_Usuarios(f);
    close(f);
	INDICE_ARCHIVO_DAT:=-1;
	end


end;


procedure Menu_Bienvenida(var Participante:Ficha_Jugador; var INDICE_DAT:longint; var administrador:boolean );
begin
	administrador:=false;
    textbackground(0);
    textcolor(0);
    if upcase(Participante.Usuario)='ADMIN' then
		administrador:=true;
    textcolor(15);
    correr_pd();
    textbackground(0)

end;





function Ingresa_Usuario(var Jugador:Ficha_Jugador; var INDICE_DAT:longint):boolean;

var
Password_Dat:string[8];
Posi_Idx:longint;
Datos_OK:boolean;
Item: byte;
Confirma:string[1];
registro:Ficha_Jugador;
Jugador_Idx:Ficha_Jugador_Reg_Indice;
f: File of Ficha_Jugador;
g: File of Ficha_Jugador_Reg_Indice;

begin
Item:=1;
Confirma:='N';
Datos_OK:=false;

Jugador.Usuario:='';
Jugador.Clave:='';


// �ltima fecha de ingreso


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
		leecampo(item,Jugador.Usuario, 8, true);
		end;

	2:	begin
		gotoxy(20,7);
		leecampo(item,Jugador.Clave, 8, false);
		end;

	3:
		repeat
		item:=3;
		gotoxy(20,9);
		leecampo(item,Confirma, 1, true);
		until Confirma[1] in['S','s','N','n'];

	4:
		item:=1;

	end;

end;


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





procedure Menu_Login_Principal(var Participante:Ficha_Jugador);
var
	op:char;
	salir:boolean;
	IndiceDat:longint;
begin
        textcolor(15);
        
	IndiceDat:=0;  // Variable que pasar� al Menu de Bienvenida la posici�n del Participante Ingresado.
	salir := false;

	repeat
		clrscr;
        graficar_loginmas();
		op := readkey;
		case op of
			'1': if Ingresa_Usuario(Participante,IndiceDat) then Menu_Bienvenida(Participante,IndiceDat,administrador);
			'2': Alta_Jugador(Participante);
			'3': Olvido_Password;
			'0': salir := true;
		end;
	until salir;
end;

end.

