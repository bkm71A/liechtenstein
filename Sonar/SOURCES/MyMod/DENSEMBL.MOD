IMPLEMENTATION MODULE DEnsembl;
IMPORT FIO,FFT,SwLib;
CONST k4=4096;
VAR   re,im,ono          : ARRAY[0..k4-1] OF REAL;
VAR   bufs,bufd          : ARRAY[1..2048] OF BYTE;
PROCEDURE katok(kol:SHORTCARD;shift:CARDINAL;
                VAR sname,dname:ARRAY OF CHAR):LONGINT;
VAR c                  : SHORTCARD;
    mo,min,max,dw      : REAL;
    a,b                : REAL;        (*служебные значения   *)
    freq               : REAL;        (*частота дискретизации*)
    mlog,commence,obr  : CARDINAL;    (*log 2 длины массива  *)
    result,i,j,n       : CARDINAL;
    rsize,long,nl,o    : LONGCARD;(*длина реализации,длина бпф*)
    fs,fd              : FIO.File;(*файлы:входной,выходной *)
    dr                 : LONGINT;
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
(* 3 Делаем чтоб длина реализации была степенью двойки *)
  long:=rsize-LONGCARD(shift)*LONGCARD(kol-1);
  SwLib.pow2(long,nl,mlog);
  IF nl#long THEN  mlog:=mlog-1;
                   nl:=nl>>1;
            END;
  IF nl>k4 THEN nl:=k4; mlog:=12;END;
(* 4  Проверка есть ли место на жестком диске,прерывание DOS 36H *)
  dr:=SwLib.DiskAvail(0); (* число свободных байт *)
  o:=LONGCARD(commence)+nl*2;
  dr:=LONGINT(o)-dr;
  IF dr>0 THEN FIO.Close(fs);RETURN dr;END;
(* 5  Формируем имя выходного файла *)
  SwLib.nome('S','G','0',result,sname,dname);
  i:=0;
    WHILE FIO.Exists(dname) DO
    i:=i+1;
    dname[result+3]:=CHAR(i+30H);
    END;
(* 6 Копируем этикетку *)
  fd:=FIO.Create(dname);
  FIO.AssignBuffer(fd,bufd);
  FIO.Seek(fs,0);
    FOR i:=0 TO commence-1 DO
    result:=FIO.RdBin(fs,c,1);
    FIO.WrBin(fd,c,1);
    END;
(* 7 Обнуление массива результатов *)
  n:=CARDINAL(nl);
    FOR i:=0 TO n-1 DO
    ono[i]:=0.0;
    END;
(* 8 Вычисление спектра и суммирование результатов *)
    FOR i:= 1 TO CARDINAL(kol) DO
    FIO.Seek(fs,LONGCARD(commence+shift*(i-1)));
    (* переписать отрезок в массив *)
      FOR j:=0 TO n-1 DO
      result:=FIO.RdBin(fs,a,4);
      re[j]:=a;
      im[j]:=0.0;
      END;
    (* преобразование Фурье *)
    FFT.nfft(n,mlog,re,im);
    (* суммирование *)
      FOR j:=0 TO n-1 DO
      ono[j]:=ono[j]+2.0*(re[j]*re[j]+im[j]*im[j])/REAL(n-1)/freq;
      END;
    END;
(* 9  Осреднение и Запись результатов в файл *)
  mo:=0.0;min:=MAX(REAL);max:=MIN(REAL);
  b:=REAL(kol);
    FOR i:=0 TO (n DIV 2)-1 DO
    a:=ono[i]/b;
    FIO.WrBin(fd,a,4);
    mo:=mo+a;
    IF a>max THEN max:=a;END;
    IF a<min THEN min:=a;END;
    END;
  mo:=mo/REAL(n DIV 2);
(* 10  Запись данных в этикетку *)
  FIO.Seek(fd,26);
  FIO.WrBin(fd,n DIV 2,4);
  dw:=freq/REAL(n-1);
  FIO.Seek(fd,36);
  FIO.WrBin(fd,min,4);
  FIO.WrBin(fd,max,4);
  FIO.WrBin(fd,mo,4);
  obr:=CARDINAL(BITSET(obr)+BITSET(0400H));
  FIO.WrBin(fd,obr,2);
  FIO.Seek(fd,60);
  FIO.WrBin(fd,dw,4);
(* 11 Закрытие файлoв *)
  FIO.Close(fs);
  FIO.Close(fd);
  RETURN 0;
END katok;
BEGIN
END DEnsembl.