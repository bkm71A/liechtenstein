IMPLEMENTATION MODULE DIntegr;
(* интегрирование процесса *)
IMPORT FIO,Str,SwLib;
VAR aa[0B800H:0]     : CARDINAL;
PROCEDURE integral(c:CHAR;ord:CARDINAL;VAR sname,dname:ARRAY OF CHAR):LONGINT;
(*Передаем с - виртуальный диск,ord-порядок интегрирования,sname-имя файла*)
(* возвращает: 0 - успешное завершение ,число>0-мало места на текущем жестком
диске,или виртуальном диске,не хватает <число> байт *)
VAR xi,xi1,y0,re64             : REAL;
    del,y1,mo,min,max,mt       : REAL;
    sfile,dfile,fs,fd          : FIO.File;(*Файлы s-исходный,d-файл результата*)
    sbuf,dbuf,buf              : ARRAY[1..1024] OF BYTE;
    tname                      : ARRAY[0..11] OF CHAR;(*имена файлов*)
    long,i                     : LONGCARD;(*число отсчетов*)
    sizef                      : LONGCARD;(* размер файла *)
    res,commence,obr,j,p       : CARDINAL;
    t                          : LONGINT;
    b,vdisk                    : SHORTCARD;
 PROCEDURE int1();
(* интегрирование 1 степени *)
 BEGIN
          y0:=0.0;
          mt:=0.0;
          max:=0.0;
          min:=0.0;
          FIO.WrBin(fd,y0,4);
          res:=FIO.RdBin(fs,xi,4);
            FOR i:=1 TO long-1 DO
            res:=FIO.RdBin(fs,xi1,4);
            y1:=y0+(xi+xi1-2.0*mo)*del;
            IF y1>max THEN max:=y1;END;
            IF y1<min THEN min:=y1;END;
            mt:=mt+y1;
            FIO.WrBin(fd,y1,4);
            y0:=y1;
            xi:=xi1;
            p:=CARDINAL(REAL(i)*re64/REAL(long-1));
            IF (i=long-1) AND (aa>33) THEN aa:=64;END;
            IF p>aa THEN aa:=aa+1;END;
            END;
          mt:=mt/REAL(long);
 END int1;
BEGIN
(* 0 Открываем входной файл*)
 sfile:=FIO.Open(sname);
 sizef:=FIO.Size(sfile);
(* 1  Проверить есть ли место на диске *)
 t:=SwLib.DiskAvail(0); (* число свободных байт *)
 t:=LONGINT(ord)*LONGINT(sizef)-t;
 IF t>=0 THEN FIO.Close(sfile);RETURN t;END;
(* 2 Формируем имя выходного файла *)
 Str.Item(dname,sname,Str.CHARSET{'.'},0);
 res:=Str.Length(dname);
 dname[res]:='.';
 IF ((sname[res+1]='I') OR (sname[res+1]='N')) AND
    ((sname[res+2]='i') OR (sname[res+2]='n'))
    THEN dname[res+3]:=CHAR(CARDINAL(sname[res+3])+ord);
    ELSE dname[res+3]:=CHAR(ord+30H);
    END;
 dname[res+1]:='I';
 dname[res+2]:='N';
 dname[res+4]:=CHAR(0);
(* 3 Создать выходной файл *)
 dfile:=FIO.Create(dname);
 FIO.AssignBuffer(sfile,sbuf);
 FIO.AssignBuffer(dfile,dbuf);
(* 4 Читаем данные из этикетки *)
 FIO.Seek(sfile,22);
 res:=FIO.RdBin(sfile,del,4); (* частота дискретизации *)
 del:=0.5/del;
 res:=FIO.RdBin(sfile,long,4);    (* длина реализации  *)
 FIO.Seek(sfile,32);
 res:=FIO.RdBin(sfile,commence,2);(* начало данных     *)
 FIO.Seek(sfile,44);
 res:=FIO.RdBin(sfile,mo,4);      (* матожидание       *)
 res:=FIO.RdBin(sfile,obr,2);     (* байт обработки    *)
(* 5 Копируем этикетку *)
 FIO.Seek(sfile,0);
 FOR j:=1 TO commence DO          (* commence байт копируем *)
      res:=FIO.RdBin(sfile,b,1);
      FIO.WrBin(dfile,b,1);
 END;
(* 6 Вызов процедур*)
 CASE ord OF
      |1  : re64:=64.0;
            fs:=sfile;
            fd:=dfile;
            int1();
      |2  : re64:=32.0;
            aa:=32;
            tname:='musor';
            fs:=sfile;
            fd:=FIO.Create(tname);
            FIO.AssignBuffer(fd,buf);
            int1();
            fs:=fd;
            fd:=dfile;
            FIO.Seek(fs,LONGCARD(0));
            mo:=mt;
            int1();               (* еще раз вторая производная*)
            FIO.Erase(tname);
 END;
 FIO.Close(sfile);
(* 7 Запись в этикетку *)
 FIO.Seek(dfile,36);
 FIO.WrBin(dfile,min,4);
 FIO.WrBin(dfile,max,4);
 FIO.WrBin(dfile,mt,4);
 obr:=CARDINAL(BITSET(obr)+BITSET(0010H));
 FIO.WrBin(dfile,obr,2);
 FIO.Close(dfile);
RETURN 0;
END integral;

END DIntegr.