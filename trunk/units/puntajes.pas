unit puntajes;

interface

uses
    jugador,
    crt,
    sysutils;

const
     MAX_USUARIOS=1000;

type
    file_t_jugador= file of t_jugador;

    r_idx = record
          puntaje,posicion:integer;
            end;

    tv_ridx = array[1..MAX_USUARIOS] of r_idx;


var
       fpuntajes:file_t_jugador;
       v_idx_punt : tv_ridx;
       rjugador:t_jugador;
       maximo:integer;


procedure guardar_puntajes (var rjugador: t_jugador);
procedure mostrar_puntajes (var hastadonde:integer);

implementation

procedure guardar_puntajes (var rjugador: t_jugador);
var
   fpuntajes:file_t_jugador;
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

procedure ordenar_vector (var v_idx_punt: tv_ridx; var maximo:integer);
var
   i,j,aux,aux1:integer;
begin
for i:=1 to (maximo-1) do
    for j:=(i+1) to maximo do
        if v_idx_punt[i].puntaje<v_idx_punt[j].puntaje then
           begin
                aux:=v_idx_punt[i].puntaje;
                v_idx_punt[i].puntaje:=v_idx_punt[j].puntaje;
                v_idx_punt[j].puntaje:=aux;

                aux1:=v_idx_punt[i].posicion;
                v_idx_punt[i].posicion:=v_idx_punt[j].posicion;
                v_idx_punt[j].posicion:=aux1;
           end;
end;

procedure indexar_puntajes (var fpuntajes:file_t_jugador; var v_idx_punt: tv_ridx; var maximo:integer);
var
   n:integer;
begin
     n:=0;
     while not eof (fpuntajes) do
           begin
                read (fpuntajes,rjugador);
                v_idx_punt[n+1].puntaje:=rjugador.puntos;
                v_idx_punt[n+1].posicion:=n;
                inc(n)
           end;
     maximo := n;
     ordenar_vector (v_idx_punt, maximo);
end;


procedure mostrar_puntajes (var hastadonde:integer);
var
   i:integer;
begin
     assign (fpuntajes, 'puntajes.bin');
     reset (fpuntajes);
     indexar_puntajes (fpuntajes,v_idx_punt, maximo);
     for i:=1 to hastadonde do
         begin
              seek (fpuntajes,v_idx_punt[i].posicion);
              read (fpuntajes, rjugador);
              writeln (rjugador.nombre, ' ', rjugador.puntos)
         end;
     readkey();
     close (fpuntajes)
end;



end.


