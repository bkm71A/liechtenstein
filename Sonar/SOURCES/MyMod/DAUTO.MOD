IMPLEMENTATION MODULE DAuto;
IMPORT FIO,BIGFFT,SwLib,Str;
CONST mus='MUSORF';
      tmp='MUSORT';
      isx='MUSOR0';
VAR bufs,bufd                 : ARRAY[1..2048] OF BYTE;
PROCEDURE correl(VAR sname,dname:ARRAY OF CHAR):LONGINT;
VAR c                         : SHORTCARD;
    mo,min,max                : REAL;
    a,b,xr,xi                 : REAL;        (*служебные значения   *)
    freq                      : REAL;        (*частота дискретизации*)
    y                         : LONGREAL;
    mlog,commence,obr         : CARDINAL;    (*log 2 длины массива  *)
    result,ns,of,i,ji         : CARDINAL;
    rsize,n,o,o1,o2           : LONGCARD;(*длина реализации,длина бпф*)
    mem                       : CARDINAL;(*доступная память в блоках*)
    fs,fd,ft                  : FIO.File;(*файлы:входной,выходной*)
    dr                        : LONGINT;

BEGIN
(* 1  Открыть файл *)
  fs:=FIO.Open(sname);
  FIO.AssignBuffer(fs,bufs);
(* 2  Работа с этикеткой,считать данные *)
  FIO.Seek(fs,22);
  result:=FIO.RdBin(fs,freq,4);
  result:=FIO.RdBin(fs,rsize,4);
  FIO.Seek(fs,32);
  result:=FIO.RdBin(fs,commence,2);
  FIO.Seek(fs,48);
  result:=FIO.RdBin(fs,obr,2);
  FIO.Close(fs);
(* 3 Делаем чтоб длина реализации была степенью двойки *)
  SwLib.pow2(rsize,n,mlog);
(* 4  Проверка есть ли место на жестком диске  *)
  dr:=SwLib.DiskAvail(0); (* число свободных байт *)
  o:=n*16;
 IF LONGCARD(commence)>n*4 THEN o:=o+LONGCARD(commence);END;
  dr:=LONGINT(o)-dr;
  IF dr>0 THEN RETURN dr;END;
(* 5 Преобразование Фурье *)
  BIGFFT.Diskfft(rsize,commence,TRUE,sname);
(* 6  Вычисление спектральной плотности *)
  Str.Copy(dname,mus);
  (*  Переименовать и открыть FFT *)
  FIO.Rename(isx,dname);
  fd:=FIO.Open(dname);
  FIO.AssignBuffer(fd,bufd);
  ft:=FIO.Create(tmp);
  FIO.AssignBuffer(ft,bufs);
      FOR o:=0 TO n-1 DO
      result:=FIO.RdBin(fd,a,4);
      result:=FIO.RdBin(fd,b,4);
      a:=(a*a+b*b)/REAL(n)/freq;
      b:=0.0;
      FIO.WrBin(ft,a,4);
      FIO.WrBin(ft,b,4);
      END;
  FIO.Close(fd);
  FIO.Close(ft);
  FIO.Erase(dname);
  Str.Copy(dname,tmp);
(* 7 Обратное FFT *)
  BIGFFT.Diskfft(n,CARDINAL(0),FALSE,dname);
(* 8  Формируем имя выходного файла *)
  SwLib.nome('K','O','R',result,sname,dname);
(* 9 Копируем этикетку *)
  fd:=FIO.Create(dname);
  FIO.AssignBuffer(fd,bufd);
  fs:=FIO.Open(sname);
  FIO.AssignBuffer(fs,bufs);
    FOR i:=0 TO commence-1 DO
    result:=FIO.RdBin(fs,c,1);
    FIO.WrBin(fd,c,1);
    END;
  FIO.Close(fs);
(* 10  Вычисление функции и Запись результатов *)
    fs:=FIO.Open(isx);
    FIO.AssignBuffer(fs,bufs);
    mo:=0.0;min:=MAX(REAL);max:=MIN(REAL);
      FOR o:=0 TO (n DIV 2)-1 DO
      result:=FIO.RdBin(fs,xr,4);
      result:=FIO.RdBin(fs,xi,4);
      xr:=xr/REAL(n)*freq;
      mo:=mo+xr;
      IF xr>max THEN max:=xr;END;
      IF xr<min THEN min:=xr;END;
      FIO.WrBin(fd,xr,4);
      END;
 mo:=mo/REAL(n DIV 2);
 FIO.Erase(isx);
(* 10  Запись данных в этикетку *)
 FIO.Seek(fd,26);
 FIO.WrBin(fd,n DIV 2,4);
 FIO.Seek(fd,36);
 FIO.WrBin(fd,min,4);
 FIO.WrBin(fd,max,4);
 FIO.WrBin(fd,mo,4);
 obr:=CARDINAL(BITSET(obr)+BITSET(0004H));
 FIO.WrBin(fd,obr,2);
(* 11 Закрытие файлoв *)
  FIO.Close(fd);
  RETURN 0;
END correl;
BEGIN
END DAuto.