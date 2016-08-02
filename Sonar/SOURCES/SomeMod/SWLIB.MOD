IMPLEMENTATION MODULE SwLib;
IMPORT MATHLIB,SYSTEM,Lib,Str;
CONST  ln2=0.69314717;
       k64=65536;
       pi=3.1415926;
PROCEDURE fft(num:LONGCARD;m:CARDINAL;VAR ser,sei:ARRAY OF CARDINAL);
(* передаем массив указателей длину *)
(* передаем : ser,sei *)
VAR d                           : REAL;        (*служебные значения *)
    w1,w2,u1,u2,u3,t1,t2        : REAL;        (*служебные значения *)
    i,i1,j                      : LONGCARD;    (*индексы            *)
    k,l,l1,l2                   : LONGCARD;    (*индексы            *)
    n2,res                      : CARDINAL;
    numseg,off                  : CARDINAL;(*номер сегмента и смещение *)
    p1,p2,p3,p4                 : POINTER TO REAL;
BEGIN
(* A. Перестановка входной последовательности *)
n2:=CARDINAL(num DIV 2);
j:=0;
   FOR i:=0 TO num-2 DO
   IF i<j THEN (* меняем два отсчета местами *)
               numseg:=CARDINAL(j*4 DIV k64);
               off:=CARDINAL(j*4 MOD k64);
               p1:=[ser[numseg]:off];
               d:=p1^;
               numseg:=CARDINAL(i*4 DIV k64);
               off:=CARDINAL(i*4 MOD k64);
               p2:=[ser[numseg]:off];
               p1^:=p2^;
               p2^:=d;
               numseg:=CARDINAL(j*4 DIV k64);
               off:=CARDINAL(j*4 MOD k64);
               p1:=[sei[numseg]:off];
               d:=p1^;
               numseg:=CARDINAL(i*4 DIV k64);
               off:=CARDINAL(i*4 MOD k64);
               p2:=[sei[numseg]:off];
               p1^:=p2^;
               p2^:=d;
               END;
   k:=LONGCARD(n2);
   WHILE k<j+1 DO
             j:=j-k;
             k:=k DIV 2;
             END;
   j:=j+k;
   END;
(* B. Само  БПФ *)
l1:=1;
   FOR l:=1 TO LONGCARD(m) DO
   l1:=l1*2;
   l2:=l1 DIV 2;
   u1:=1.0;
   u2:=0.0;
   w1:=REAL(MATHLIB.Cos(LONGREAL(pi/REAL(l2))));
   w2:=-REAL(MATHLIB.Sin(LONGREAL(pi/REAL(l2))));
       FOR j:=0 TO l2-1 DO
              i:=j;
              WHILE i<=num-1 DO
              i1:=i+l2;
              numseg:=CARDINAL(i1*4 DIV k64);
              off:=CARDINAL(i1*4 MOD k64);
              p1:=[ser[numseg]:off];
              p2:=[sei[numseg]:off];
              t1:=p1^*u1-p2^*u2;
              t2:=p2^*u1+p1^*u2;
              numseg:=CARDINAL(i*4 DIV k64);
              off:=CARDINAL(i*4 MOD k64);
              p3:=[ser[numseg]:off];
              p4:=[sei[numseg]:off];
              p1^:=p3^-t1;
              p2^:=p4^-t2;
              p3^:=p3^+t1;
              p4^:=p4^+t2;
              i:=i+l1;
              END;
       u3:=u1;
       u1:=u1*w1-u2*w2;
       u2:=u2*w1+u3*w2;
       END;
   END;
END fft;
PROCEDURE DiskAvail(disk:SHORTCARD):LONGINT;
VAR r    : SYSTEM.Registers;
    ilya : LONGINT;
BEGIN
(* Проверка сколько места есть на текущем жестком диске,прерывание DOS 36H *)
  r.AH:=36H;
  r.DL:=disk;    (*номер диска 0-текущий,1-A и т.д.*)
  Lib.Dos(r);
  ilya:=LONGINT(r.CX)*LONGINT(r.AX)*LONGINT(r.BX); (* число свободных байт *)
  RETURN ilya;
END DiskAvail;
PROCEDURE nome(ca,cb,cc:CHAR;VAR ult: CARDINAL;VAR inp,out:ARRAY OF CHAR);
BEGIN
  Str.Item(out,inp,Str.CHARSET{'.'},0);
  ult:=Str.Length(out);
  out[ult]:='.';
  out[ult+1]:=ca;
  out[ult+2]:=cb;
  out[ult+3]:=cc;
  out[ult+4]:=CHAR(0);
END nome;
PROCEDURE pow2(dlina: LONGCARD;VAR n2 :LONGCARD;VAR log:CARDINAL);
VAR bob   :REAL;
BEGIN
  bob:=REAL(MATHLIB.Log(LONGREAL(dlina))/ln2);
  log:=CARDINAL(bob);
  n2:=1;
  n2:=n2 << LONGCARD(log);
  IF n2<dlina THEN log:=log+1;
              n2:=n2<<1;
              END;
END pow2;
BEGIN
END SwLib.