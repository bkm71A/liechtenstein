IMPLEMENTATION MODULE Sglaj;
IMPORT MATHLIB,FIO,Storage,SwLib;
VAR line[0A800H:0]            : CARDINAL;
PROCEDURE heing(henning:BOOLEAN;VAR sname,dname:ARRAY OF CHAR):LONGINT;
VAR p                         : SHORTCARD;
    mo,min,max                : REAL;
    a,b,c,x1,x2,x4,res        : REAL;        (*служебные значения   *)
    commence,obr              : CARDINAL;    (*log 2 длины массива  *)
    result,i                  : CARDINAL;
    rsize,o,size              : LONGCARD;(*длина реализации,длина бпф,счетчики*)
    fs,fd                     : FIO.File;(*файлы:входной,выходной*)
    bufs,bufd                 : ARRAY[1..2048] OF BYTE;
    dr                        : LONGINT;
BEGIN
(* Проверка имени на spl - Владик *)
line:=0;
(* 0  Формируем имя выходного файла *)
  SwLib.nome('S','G','0',result,sname,dname);
  i:=0;
    WHILE FIO.Exists(dname) DO
    i:=i+1;
    dname[result+3]:=CHAR(i+30H);
    END;
(* 1  Открыть файл *)
  fs:=FIO.Open(sname);
  FIO.AssignBuffer(fs,bufs);
(* 2  Проверка есть ли место на жестком диске,прерывание DOS 36H *)
  size:=FIO.Size(fs);
  dr:=SwLib.DiskAvail(0); (* число свободных байт *)
  dr:=LONGINT(size)-dr;
  IF dr>0 THEN FIO.Close(fs);RETURN dr;END;
(* 3  Работа с этикеткой,считать данные *)
  FIO.Seek(fs,26);
  result:=FIO.RdBin(fs,rsize,4);
  FIO.Seek(fs,32);
  result:=FIO.RdBin(fs,commence,2);
  FIO.Seek(fs,48);
  result:=FIO.RdBin(fs,obr,2);
  INC(line);
(* 4 Копируем этикетку *)
  fd:=FIO.Create(dname);
  FIO.AssignBuffer(fd,bufd);
  FIO.Seek(fs,0);
    FOR i:=0 TO commence-1 DO
    result:=FIO.RdBin(fs,p,1);
    FIO.WrBin(fd,p,1);
    END;
(* 5  Вычисление сглаженной оценки и Запись результатов *)
    IF henning THEN  x1:=0.5;x2:=0.5;x4:=0.25;
               ELSE  x1:=0.54;x2:=0.46;x4:=0.23;
               END;
    mo:=0.0;min:=MAX(REAL);max:=MIN(REAL);
    result:=FIO.RdBin(fs,a,4);
    result:=FIO.RdBin(fs,b,4);
    res:=x1*a+x2*b;
    mo:=mo+res;
    IF res>max THEN max:=res;END;
    IF res<min THEN min:=res;END;
    FIO.WrBin(fd,res,4);
      FOR o:=2 TO rsize-1 DO
      IF CARDINAL(o*63 DIV rsize)>line THEN line:=line+1;END;
      result:=FIO.RdBin(fs,c,4);
      res:=x4*(a+c)+x1*b;
      FIO.WrBin(fd,res,4);
      a:=b;b:=c;
      mo:=mo+res;
      IF res>max THEN max:=res;END;
      IF res<min THEN min:=res;END;
      END;
    result:=FIO.RdBin(fs,c,4);
    res:=x2*b+x1*c;
    FIO.WrBin(fd,res,4);
    mo:=mo+res;
    IF res>max THEN max:=res;END;
    IF res<min THEN min:=res;END;
    mo:=mo/REAL(rsize);
(* 6  Запись данных в этикетку *)
 FIO.Seek(fd,36);
 FIO.WrBin(fd,min,4);
 FIO.WrBin(fd,max,4);
 FIO.WrBin(fd,mo,4);
 IF henning THEN obr:=CARDINAL(BITSET(obr)+BITSET(0200H));
            ELSE obr:=CARDINAL(BITSET(obr)+BITSET(0100H));
            END;
 FIO.WrBin(fd,obr,2);
 FIO.Seek(fd,80)    ; FIO.WrStr(fd,'Hz'); FIO.WrChar(fd,CHR(13));
                                          FIO.WrChar(fd,CHR(13));
(* 7 Закрытие файлoв *)
  FIO.Close(fs);
  FIO.Close(fd);
  RETURN 0;
END heing;

END Sglaj.