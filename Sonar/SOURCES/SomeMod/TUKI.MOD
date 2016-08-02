IMPLEMENTATION MODULE Tuki;
IMPORT MATHLIB,FIO;
CONST  pi=3.1415926;
VAR aa[0B800H:0]     : CARDINAL;
PROCEDURE window(VAR sname:ARRAY OF CHAR);
VAR  mo,min,max      : REAL;
     a               : REAL;        (*служебные значения   *)
     y               : LONGREAL;
     commence,obr    : CARDINAL;
     result,p        : CARDINAL;
     rsize,pos,o1,o2 : LONGCARD;(*длина реализации,счетчики*)
     f               : FIO.File;  (*файлы : входной*)
     buf             : ARRAY[1..2048] OF BYTE;
BEGIN
  mo:=0.0;
  min:=MAX(REAL);
  max:=MIN(REAL);
(* 1  Открыть файл *)
  f:=FIO.Open(sname);
  FIO.AssignBuffer(f,buf);
(* 2  Работа с этикеткой,считать данные *)
  FIO.Seek(f,26);
  result:=FIO.RdBin(f,rsize,4);
  FIO.Seek(f,32);
  result:=FIO.RdBin(f,commence,2);
  FIO.Seek(f,48);
  result:=FIO.RdBin(f,obr,2);
(* 3 Умножение на синус *)
  o1:=LONGCARD(REAL(rsize-1)*0.1);
  o2:=LONGCARD(REAL(rsize-1)*0.9);
  y:=5.0*pi/LONGREAL(rsize-1);
  FIO.Seek(f,LONGCARD(commence));
    FOR pos:=0 TO o1 DO
    result:=FIO.RdBin(f,a,4);
    a:=a*REAL(MATHLIB.Sin(y*LONGREAL(pos))*MATHLIB.Sin(y*LONGREAL(pos)));
    mo:=mo+a;
    IF a>max THEN max:=a;END;
    IF a<min THEN min:=a;END;
    FIO.Seek(f,pos*4+LONGCARD(commence));
    FIO.WrBin(f,a,4);
    p:=CARDINAL(REAL(pos)*32.0/REAL(o1));
    IF p>aa THEN aa:=aa+1; END;
    END;
    FOR pos:=o1+1 TO o2-1 DO
    result:=FIO.RdBin(f,a,4);
    mo:=mo+a;
    IF a>max THEN max:=a;END;
    IF a<min THEN min:=a;END;
    END;
    FOR pos:=o2 TO rsize-1 DO
    result:=FIO.RdBin(f,a,4);
    a:=a*REAL(MATHLIB.Sin(y*LONGREAL(pos))*MATHLIB.Sin(y*LONGREAL(pos)));
    mo:=mo+a;
    IF a>max THEN max:=a;END;
    IF a<min THEN min:=a;END;
    FIO.Seek(f,pos*4+LONGCARD(commence));
    FIO.WrBin(f,a,4);
    p:=CARDINAL(REAL(pos)*64.0/REAL(rsize-1));
    IF pos=rsize-1 THEN aa:=64;END;
    IF p>aa THEN aa:=aa+1;END;
    END;
(* изменить матожид max,min obr *)
  mo:=mo/REAL(rsize);
(* 4 Запись данных в этикетку *)
 FIO.Seek(f,36);
 FIO.WrBin(f,min,4);
 FIO.WrBin(f,max,4);
 FIO.WrBin(f,mo,4);
 obr:=CARDINAL(BITSET(obr)+BITSET(0002H));
 FIO.WrBin(f,obr,2);
(* 5 Закрытие файлa *)
 FIO.Close(f);
END window;
BEGIN
END Tuki.