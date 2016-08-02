IMPLEMENTATION MODULE Iron;
IMPORT FIO,SwLib;
VAR aa[0B800H:0]                : CARDINAL;
PROCEDURE iron(el:SHORTCARD;VAR sname,dname:ARRAY OF CHAR):LONGINT;
VAR c                         : SHORTCARD;
    s,x,mo,min,max,dw         : REAL;
    commence,obr              : CARDINAL;
    result,l,k                : CARDINAL;
    rsize,o,i,j,m             : LONGCARD;(*длина реализации,счетчики*)
    fs,fd                     : FIO.File;(*файлы:входной,выходной *)
    bufs,bufd                 : ARRAY[1..2048] OF BYTE;
    dr                        : LONGINT;
BEGIN
(* 0  Формируем имя выходного файла и проверка входного файла*)
  SwLib.nome('S','G','0',result,sname,dname);
  k:=0;
    WHILE FIO.Exists(dname) DO
    k:=k+1;
    dname[result+3]:=CHAR(k+30H);
    END;
  IF NOT(((sname[result+1]='S') OR (sname[result+1]='s'))
     AND ((sname[result+2]='P') OR (sname[result+2]='p'))
     AND ((sname[result+3]='L') OR (sname[result+3]='l')))
     THEN RETURN -1;END;
(* 1  Открыть файл *)
  fs:=FIO.Open(sname);
  FIO.AssignBuffer(fs,bufs);
(* 2  Работа с этикеткой,считать данные *)
  FIO.Seek(fs,26);
  result:=FIO.RdBin(fs,rsize,4);
  FIO.Seek(fs,32);
  result:=FIO.RdBin(fs,commence,2);
  FIO.Seek(fs,48);
  result:=FIO.RdBin(fs,obr,2);
  FIO.Seek(fs,60);
  result:=FIO.RdBin(fs,dw,4);
(* 3  Проверка есть ли место на жестком диске,прерывание DOS 36H *)
  dr:=SwLib.DiskAvail(0); (* число свободных байт *)
  o:=LONGCARD(commence+4)+(rsize DIV LONGCARD(l))*4;
  dr:=LONGINT(o)-dr;
  IF dr>0 THEN FIO.Close(fs);RETURN dr;END;
(* 4 Копируем этикетку *)
  fd:=FIO.Create(dname);
  FIO.AssignBuffer(fd,bufd);
  FIO.Seek(fs,0);
    FOR k:=0 TO commence-1 DO
    result:=FIO.RdBin(fs,c,1);
    FIO.WrBin(fd,c,1);
    END;
(* 5 Само тело *)
  l:=CARDINAL(el);
  min:=MAX(REAL);max:=MIN(REAL);mo:=0.0;
  IF rsize<LONGCARD(l) THEN FIO.Close(fs);
                            FIO.Close(fd);
                            FIO.Erase(dname);
                            RETURN -2;
                       END;
  i:=rsize DIV LONGCARD(l);
    FOR m:=1 TO i DO
    s:=0.0;
      FOR j:=1 TO LONGCARD(l) DO
      result:=FIO.RdBin(fs,x,4);
      s:=s+x;
      END;
    s:=s/REAL(l);
    mo:=mo+s;
    IF min>s THEN min:=s;END;
    IF max<s THEN max:=s;END;
    FIO.WrBin(fd,s,4);
    IF CARDINAL(REAL(m)*64.0/REAL(i))>aa
                          THEN aa:=aa+1;
                          END;
    END;
(* 6  Запись данных в этикетку *)
 mo:=mo/REAL(i);
 FIO.Seek(fd,26);
 FIO.WrBin(fd,LONGCARD(i),4);
 dw:=dw*REAL(l);
 FIO.Seek(fd,36);
 FIO.WrBin(fd,min,4);
 FIO.WrBin(fd,max,4);
 FIO.WrBin(fd,mo,4);
 obr:=CARDINAL(BITSET(obr)+BITSET(0800H));
 FIO.WrBin(fd,obr,2);
 FIO.Seek(fd,60);
 FIO.WrBin(fd,dw,4);
 FIO.Seek(fd,80)  ; FIO.WrStr(fd,'Hz'); FIO.WrChar(fd,CHR(13));
                                        FIO.WrChar(fd,CHR(13));
(* 7 Закрытие файлoв *)
 FIO.Close(fs);
 FIO.Close(fd);
 RETURN 0;
END iron;

END Iron.