unit loginmas;

interface

uses
    crt;

type
    t_jugador_L = record
	Nombre: string[20];
	Apellido: string[20];
	Mail: string[40];
	Usuario: string[8];
	Clave: string[8];
	Pregunta: string[1];
	Respuesta: string[20];
	end;

     T_Jugador_Indice = record
	Usuario: string[8];
	Posicion: longint;
	end;

var
   f:File;
   Participante: t_jugador_L;

procedure Menu_Login_Principal (var participante:t_jugador_L);


implementation

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
item_actual:byte;
ini_fila,ini_col: byte;
c:char;

begin

item_actual:=item;
i:=length(entrada);

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
         #72,#75: begin c:=#0; dec(item) end;
         #80,#77: begin c:=#0; inc(item)  end;
            end;

     #27: begin c:=#0; dec(item) end;


     #13: begin c:=#0; inc(item) end;

else
    if (i<longitud) and (c<>#0) then
       begin
            if visualiza then Write(c) else Write('*');
            entrada:=entrada+c;
            inc(i);
            end

end;  //Fin case

until item_actual<>item;


gotoxy(ini_col,ini_fila);
for j:=1 to longitud do write(' ');

gotoxy(ini_col,ini_fila);

if visualiza then
write(entrada)
else
for j:=1 to i do write('*');



end;


procedure Alta_Jugador(var Jugador:t_jugador_L);
var
Datos_OK:boolean;
Item: byte;
Confirma:string[1];
Jugador_Idx:T_Jugador_Indice;
Escritos,x_archivo:longint;
f: File of t_jugador_L;
g: File of T_Jugador_Indice;


begin
Item:=1;
Confirma:='N';
Datos_OK:=false;



Jugador.Nombre:='';
Jugador.Apellido:='';
Jugador.Mail:='';
Jugador.Usuario:='';
Jugador.Clave:='';
Jugador.Pregunta:='a';
Jugador.Respuesta:='';
// Última fecha de ingreso


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
gotoxy(1,10); write('a- Nombre del primer chico/a que te gustó');
gotoxy(1,11); write('b- Nombre de la ciudad donde nació tu abuelo paterno');
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



if length(Jugador.Usuario)<6 then
begin
gotoxy(20,18); write('EL USUARIO DEBE TENER AL MENOS 6 CARACTERES'); readkey;
gotoxy(20,18); write('                                           ');
item:=4;
Confirma[1]:='N';
end
else
    if length(Jugador.Clave)<6 then
	begin
	gotoxy(20,18); write('EL PASSWORD DEBE TENER AL MENOS 6 CARACTERES'); readkey;
	gotoxy(20,18); write('                                            ');

	item:=5;
	Confirma[1]:='N';
	end
	else Datos_OK:=true;


until Datos_OK=true;

//______________________________________________
Jugador_idx.Usuario:=Jugador.Usuario;
//______________________________________________



if Existe_Archivo('usuarios.dat') then
begin
writeln('CASO 1  esta!');
readkey;
assign(f,'usuarios.dat');
reset(f);

//writeln('sizeof de f: ', filesize(f));
writeln('sizeof de Jugador idx: ', sizeof(Jugador_idx));
readkey;
x_archivo:=filesize(f);
seek(f, x_archivo);
write(f, Jugador);
close(f);

  Jugador_idx.Posicion:=x_archivo;
  assign(g,'usuarios.idx');
  reset(g);
  seek(g, filesize(g) );
  write(g, Jugador_idx);
  close(g);


end

else
  begin
  writeln('CASO 2 Nuevo archivo y graba');
  readkey;
  assign(f,'usuarios.dat');
  rewrite(f);
  reset(f);

  write(f, Jugador);
  close(f);

  Jugador_idx.Posicion:=0;
  assign(g,'usuarios.idx');
  rewrite(g);
  reset(g);
  write(g, Jugador_idx);
  close(g);
  end;


end;

procedure Menu_Usuario(var Participante:t_jugador_L);
begin
clrscr;
end;

procedure Olvido_Password(var Participante:t_jugador_L);
begin
clrscr;
end;


procedure Menu_Login_Principal(var Participante:t_jugador_L);
var
	op:char;
	salir:boolean;
begin
	salir := false;
	repeat
		clrscr;
		writeln('Principal');
		writeln;
		writeln('1.Entrar');
		writeln('2.Nuevo Usuario');
		writeln('3.Olvide Password');
		writeln('0.Salir');
		writeln;
		write('Ingrese su opcion: ');
		op := readkey;
		case op of
			'1': Menu_Usuario(Participante);
			'2': Alta_Jugador(Participante);
			'3': Olvido_Password(Participante);

			'0': salir := true;
		end;
	until salir;
end;

end.

