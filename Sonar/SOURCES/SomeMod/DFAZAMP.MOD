IMPLEMENTATION MODULE DFazAmp;
IMPORT MATHLIB,FIO,SwLib,BIGFFT;
CONST   rad=57.29578049;
        pi=3.1415926;
VAR     bufs,buf1,buf2        : ARRAY[1..2048] OF BYTE;

PROCEDURE afaza(VAR sname,aname,fname:ARRAY OF CHAR):LONGINT;
VAR c                         : SHORTCARD;
    fmo,amo,fmin,amin,fmax,amax: REAL;

    a,b,xr,xi,dw,amp,faza     : REAL;        (*служебные значения   *)
    y                         : LONGREAL;
    freq                      : REAL;        (*частота дискретизации*)
    mlog,commence,obr         : CARDINAL;    (*log 2 длины массива  *)
    result,ns,of,i            : CARDINAL;
    rsize,long,n,o,o1,o2      : LONGCARD;(*длина реализации,длина бпф*)

    fs,tf1,tf2                : FIO.File;(*файлы:входной,выходные*)
    dr                        : LONGINT;

BEGIN
(* 0  Формируем имя выходного файла *)
  SwLib.nome('S','P','A',result,sname,aname);
  SwLib.nome('S','P','F',result,sname,fname);
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
  long:=rsize;
(* 3 Делаем чтоб длина реализации была степенью двойки *)
  SwLib.pow2(long,n,mlog);
  FIO.Close(fs);
(* 4  Проверка есть ли место на жестком диске,прерывание DOS 36H *)
  dr:=SwLib.DiskAvail(0); (* число свободных байт *)
  o:=n*16;
  IF LONGCARD(2*commence)>n*6 THEN o:=o+LONGCARD(2*commence);END;
  dr:=LONGINT(o)-dr;
  IF dr>0 THEN RETURN dr;END;
(* 5 Преобразование Фурье *)
  BIGFFT.Diskfft(rsize,commence,TRUE,sname);
(* 7 Копируем этикетку *)
  fs:=FIO.Open(sname);
  FIO.AssignBuffer(fs,bufs);
  tf1:=FIO.Create(aname);
  FIO.AssignBuffer(tf1,buf1);
    FOR i:=0 TO commence-1 DO
    result:=FIO.RdBin(fs,c,1);
    FIO.WrBin(tf1,c,1);
    END;
  tf2:=FIO.Create(fname);
  FIO.AssignBuffer(tf2,buf2);
  FIO.Seek(fs,0);
    FOR i:=0 TO commence-1 DO
    result:=FIO.RdBin(fs,c,1);
    FIO.WrBin(tf2,c,1);
    END;
  FIO.Close(fs);
(* 8  Вычисление амплитуды и фазы и Запись результатов *)
  fs:=FIO.Open('MUSOR0');
  FIO.AssignBuffer(fs,bufs);
fmo:=0.0;fmin:=MAX(REAL);fmax:=MIN(REAL);
amo:=0.0;amin:=MAX(REAL);amax:=MIN(REAL);
    FOR o:=0 TO (n DIV 2)-1 DO
    result:=FIO.RdBin(fs,xr,4);
    result:=FIO.RdBin(fs,xi,4);
    amp:=2.0*(xr*xr+xi*xi);
    amp:=REAL(MATHLIB.Sqrt(LONGREAL(amp)));
    amp:=amp/REAL(n);
    IF o>0 THEN amp:=amp*2.0;END;
    IF xr=0.0  THEN faza:=90.0;   IF xi<0.0
                                  THEN faza:=-faza;
                                  END;
               ELSE faza:=REAL(MATHLIB.ATan(LONGREAL(xi/xr)))*rad;
               END;
    amo:=amo+amp;
    IF amp>amax THEN amax:=amp;END;
    IF amp<amin THEN amin:=amp;END;
    fmo:=fmo+faza;
    IF faza>fmax THEN fmax:=faza;END;
    IF faza<fmin THEN fmin:=faza;END;
    FIO.WrBin(tf1,amp,4);
    FIO.WrBin(tf2,faza,4);
    END;
amo:=amo/REAL(n DIV 2);
fmo:=fmo/REAL(n DIV 2);
(* 10  Запись данных в этикетку *)
  FIO.Seek(tf1,26);
  FIO.WrBin(tf1,n DIV 2,4);
  dw:=freq/REAL(n-1);
  FIO.Seek(tf1,36);
  FIO.WrBin(tf1,amin,4);
  FIO.WrBin(tf1,amax,4);
  FIO.WrBin(tf1,amo,4);
  obr:=CARDINAL(BITSET(obr)+BITSET(0040H));
  FIO.WrBin(tf1,obr,2);
  FIO.Seek(tf1,60);
  FIO.WrBin(tf1,dw,4);
     FIO.Seek(tf1,80); FIO.WrStr(tf1,'Hz'); FIO.WrChar(tf1,CHR(13));
                                            FIO.WrChar(tf1,CHR(13));
  FIO.Seek(tf2,26);
  FIO.WrBin(tf2,n DIV 2,4);
  FIO.Seek(tf2,36);
  FIO.WrBin(tf2,fmin,4);
  FIO.WrBin(tf2,fmax,4);
  FIO.WrBin(tf2,fmo,4);
  FIO.WrBin(tf2,obr,2);
  FIO.Seek(tf2,60);
  FIO.WrBin(tf2,dw,4);
     FIO.Seek(tf2,80); FIO.WrStr(tf2,'Hz'); FIO.WrChar(tf2,CHR(13));
                                            FIO.WrChar(tf2,CHR(13));

(* 11 Закрытие файлoв *)
  FIO.Close(fs);
  FIO.Close(tf1);
  FIO.Close(tf2);
  FIO.Erase('MUSOR0');
  RETURN 0;
END afaza;

END DFazAmp.