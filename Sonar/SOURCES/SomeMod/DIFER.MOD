IMPLEMENTATION MODULE Difer;
(* дифференциирование процесса *)
IMPORT FIO,Str,SwLib;
VAR aa[0B800H:0]     : CARDINAL;
PROCEDURE differ(ord:CARDINAL;VAR sname,dname:ARRAY OF CHAR):LONGINT;
VAR xi_2,xi_1,xi,xi1,xi2       : REAL;
    del,y,max,min,mo           : REAL;
    sfile,dfile                : FIO.File;(*Файлы s-исходный,d-файл результата*)
    sbuf,dbuf                  : ARRAY[0..1023] OF BYTE;
    long                       : LONGCARD;(*число отсчетов*)
    fs                         : LONGCARD;(* размер файла *)
    res,commence,j,obr,p       : CARDINAL;
    i                          : LONGCARD;
    t                          : LONGINT;
    b                          : SHORTCARD;
PROCEDURE dif1();
(* нахождение первой производной *)
BEGIN
 del:=del*2.0;
 res:=FIO.RdBin(sfile,xi_1,4);
 res:=FIO.RdBin(sfile,xi,4);
 res:=FIO.RdBin(sfile,xi1,4);
 y:=(-3.0*xi_1+4.0*xi-xi1)/del;
 min:=y;max:=y;mo:=mo+y;
 FIO.WrBin(dfile,y,4);
 y:=(xi1-xi_1)/del;
 mo:=mo+y;
 IF y>max THEN max:=y;
    ELSIF y<min THEN min:=y;END;
 FIO.WrBin(dfile,y,4);
 xi_1:=xi;
 xi:=xi1;
   FOR i:=2 TO long-3 DO
       res:=FIO.RdBin(sfile,xi1,4);
       y:=(xi1-xi_1)/del;
       mo:=mo+y;
       IF y>max THEN max:=y;
          ELSIF y<min THEN min:=y;END;
       FIO.WrBin(dfile,y,4);
       xi_1:=xi;
       xi:=xi1;
       p:=CARDINAL(REAL(i)*64.0/REAL(long-3));
       IF i=long-3 THEN p:=64;END;
       IF p>aa THEN aa:=p;END;
   END;
 res:=FIO.RdBin(sfile,xi1,4);
 y:=(xi1-xi_1)/del;
 mo:=mo+y;
 IF y>max THEN max:=y;
    ELSIF y<min THEN min:=y;END;
 FIO.WrBin(dfile,y,4);
 y:=(xi_1-4.0*xi+3.0*xi1)/del;
 mo:=mo+y;
 IF y>max THEN max:=y;
    ELSIF y<min THEN min:=y;END;
 FIO.WrBin(dfile,y,4);
END dif1;

PROCEDURE dif2();
(* нахождение второй производной *)
BEGIN
 del:=12.0*del*del;
 res:=FIO.RdBin(sfile,xi_2,4);
 res:=FIO.RdBin(sfile,xi_1,4);
 res:=FIO.RdBin(sfile,xi,4);
 res:=FIO.RdBin(sfile,xi1,4);
 res:=FIO.RdBin(sfile,xi2,4);
 y:=(35.0*xi_2-104.0*xi_1+114.0*xi-56.0*xi1+11.0*xi2)/del;
 mo:=mo+y;
 max:=y;min:=y;
 FIO.WrBin(dfile,y,4);
 y:=(11.0*xi_2-20.0*xi_1+6.0*xi+4.0*xi1-xi2)/del;
 mo:=mo+y;
 IF y>max THEN max:=y;
    ELSIF y<min THEN min:=y;END;
 FIO.WrBin(dfile,y,4);
 y:=(16.0*(xi1+xi_1)-30.0*xi-xi_2-xi2)/del;
 mo:=mo+y;
 IF y>max THEN max:=y;
    ELSIF y<min THEN min:=y;END;
 FIO.WrBin(dfile,y,4);
 xi_2:=xi_1;
 xi_1:=xi;
 xi:=xi1;
 xi1:=xi2;
   FOR i:=2 TO long-5 DO
       res:=FIO.RdBin(sfile,xi2,4);
       y:=(16.0*(xi1+xi_1)-30.0*xi-xi_2-xi2)/del;
       mo:=mo+y;
       IF y>max THEN max:=y;
          ELSIF y<min THEN min:=y;END;
       FIO.WrBin(dfile,y,4);
       xi_2:=xi_1;
       xi_1:=xi;
       xi:=xi1;
       xi1:=xi2;
       p:=CARDINAL(REAL(i)*64.0/REAL(long-5));
       IF i=long-5 THEN p:=64;END;
       IF p>aa THEN aa:=p;END;
   END;
 res:=FIO.RdBin(sfile,xi2,4);
 y:=(16.0*(xi1+xi_1)-30.0*xi-xi_2-xi2)/del;
 mo:=mo+y;
 IF y>max THEN max:=y;
    ELSIF y<min THEN min:=y;END;
 FIO.WrBin(dfile,y,4);
 y:=(-xi_2+4.0*xi_1+6.0*xi-20.0*xi1+11.0*xi2)/del;
 mo:=mo+y;
 IF y>max THEN max:=y;
    ELSIF y<min THEN min:=y;END;
 FIO.WrBin(dfile,y,4);
 y:=(11.0*xi_2-56.0*xi_1+114.0*xi-104.0*xi1+35.0*xi2)/del;
 mo:=mo+y;
 IF y>max THEN max:=y;
    ELSIF y<min THEN min:=y;END;
 FIO.WrBin(dfile,y,4);
END dif2;

PROCEDURE dif3();
(* нахождение третьей производной *)
BEGIN
 del:=2.0*del*del*del;
 res:=FIO.RdBin(sfile,xi_2,4);
 res:=FIO.RdBin(sfile,xi_1,4);
 res:=FIO.RdBin(sfile,xi,4);
 res:=FIO.RdBin(sfile,xi1,4);
 res:=FIO.RdBin(sfile,xi2,4);
 y:=(-5.0*xi_2+18.0*xi_1-24.0*xi+14.0*xi1-3.0*xi2)/del;
 mo:=mo+y;
 max:=y;min:=y;
 FIO.WrBin(dfile,y,4);
 y:=(-3.0*xi_2+10.0*xi_1-12.0*xi+6.0*xi1-xi2)/del;
 mo:=mo+y;
 IF y>max THEN max:=y;
    ELSIF y<min THEN min:=y;END;
 FIO.WrBin(dfile,y,4);
 y:=(2.0*(xi_1-xi1)-xi_2+xi2)/del;
 mo:=mo+y;
 IF y>max THEN max:=y;
    ELSIF y<min THEN min:=y;END;
 FIO.WrBin(dfile,y,4);
 xi_2:=xi_1;
 xi_1:=xi;
 xi:=xi1;
 xi1:=xi2;
   FOR i:=2 TO long-5 DO
       res:=FIO.RdBin(sfile,xi2,4);
       y:=(2.0*(xi_1-xi1)-xi_2+xi2)/del;
       mo:=mo+y;
       IF y>max THEN max:=y;
          ELSIF y<min THEN min:=y;END;
       FIO.WrBin(dfile,y,4);
       xi_2:=xi_1;
       xi_1:=xi;
       xi:=xi1;
       xi1:=xi2;
       p:=CARDINAL(REAL(i)*64.0/REAL(long-5));
       IF i=long-5 THEN p:=64;END;
       IF p>aa THEN aa:=p;END;
   END;
 res:=FIO.RdBin(sfile,xi2,4);
 y:=(2.0*(xi_1-xi1)-xi_2+xi2)/del;
 mo:=mo+y;
 IF y>max THEN max:=y;
    ELSIF y<min THEN min:=y;END;
 FIO.WrBin(dfile,y,4);
 y:=(xi_2-6.0*xi_1+12.0*xi-10.0*xi1+3.0*xi2)/del;
 mo:=mo+y;
 IF y>max THEN max:=y;
    ELSIF y<min THEN min:=y;END;
 FIO.WrBin(dfile,y,4);
 y:=(3.0*xi_2-14.0*xi_1+24.0*xi-18.0*xi1+5.0*xi2)/del;
 mo:=mo+y;
 IF y>max THEN max:=y;
    ELSIF y<min THEN min:=y;END;
 FIO.WrBin(dfile,y,4);
END dif3;

BEGIN
(* 0 Тело программы *)
 sfile:=FIO.Open(sname);
 fs:=FIO.Size(sfile);
(* 1  Проверить есть ли место на диске *)
 t:=SwLib.DiskAvail(0); (* число свободных байт *)
 t:=LONGINT(fs)-t;
 IF t>=0 THEN FIO.Close(sfile);RETURN t;END;
(* 2 Формируем имя выходного файла *)
 Str.Item(dname,sname,Str.CHARSET{'.'},0);
 res:=Str.Length(dname);
 dname[res]:='.';
 IF ((sname[res+1]='D') OR (sname[res+1]='d')) AND
    ((sname[res+2]='F') OR (sname[res+2]='f'))
    THEN dname[res+3]:=CHAR(CARDINAL(sname[res+3])+ord);
    ELSE dname[res+3]:=CHAR(ord+30H);
    END;
 dname[res+1]:='D';
 dname[res+2]:='F';
 dname[res+4]:=CHAR(0);
(* 3 Создать выходной файл *)
 dfile:=FIO.Create(dname);
 FIO.AssignBuffer(sfile,sbuf);
 FIO.AssignBuffer(dfile,dbuf);
(* 4 Читаем данные из этикетки *)
 FIO.Seek(sfile,22);
 res:=FIO.RdBin(sfile,del,4); (* частота дискретизации *)
 del:=1.0/del;
 res:=FIO.RdBin(sfile,long,4);    (* длина реализации  *)
 FIO.Seek(sfile,32);
 res:=FIO.RdBin(sfile,commence,2);(* начало данных     *)
 FIO.Seek(sfile,48);
 res:=FIO.RdBin(sfile,obr,2);     (* байт обработки    *)
(* 5 Копируем этикетку *)
 FIO.Seek(sfile,0);
 FOR j:=1 TO commence DO          (* commence байт копируем *)
      res:=FIO.RdBin(sfile,b,1);
      FIO.WrBin(dfile,b,1);
 END;
(* 6 Вызов процедур*)
 mo:=0.0;
 CASE ord OF
   |1 : dif1();
   |2 : dif2();
   |3 : dif3();
 END;
 FIO.Close(sfile);
 mo:=mo/REAL(long);
(* 7 Запись в этикетку *)
 FIO.Seek(dfile,36);
 FIO.WrBin(dfile,min,4);
 FIO.WrBin(dfile,max,4);
 FIO.WrBin(dfile,mo,4);
 obr:=CARDINAL(BITSET(obr)+BITSET(0008H));
 FIO.WrBin(dfile,obr,2);
 FIO.Close(dfile);
RETURN 0;
END differ;

END Difer.