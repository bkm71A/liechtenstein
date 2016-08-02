IMPLEMENTATION MODULE DSPlot;
IMPORT MATHLIB,FIO,BIGFFT,SwLib;
VAR bufs,bufd                 : ARRAY[1..2048] OF BYTE;
(* Вычисление спектральной плотности *)
PROCEDURE s_pect(bet:SHORTCARD;VAR eps,c1,c2:REAL;
                 VAR sname,dname:ARRAY OF CHAR):LONGINT;
VAR c                         : SHORTCARD;
    mo,m2,m4,min,max,dw       : REAL;
    a,amp,xr,xi               : REAL;        (*служебные значения   *)
    y                         : LONGREAL;
    freq                      : REAL;        (*частота дискретизации*)
    mlog,commence,obr         : CARDINAL;    (*log 2 длины массива  *)
    result,ns,of,i,bo         : CARDINAL;
    rsize,long,n,o,v          : LONGCARD;(*длина реализации *)
    fs,fd                     : FIO.File;(*файлы:входной,выходной*)
    dr                        : LONGINT;
    ZA                        : ARRAY[0..13] OF REAL;
    beta                      : ARRAY[0..13] OF REAL;
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
  long:=rsize;
  FIO.Close(fs);
(* 3 Делаем чтоб длина реализации была степенью двойки *)
  SwLib.pow2(rsize,n,mlog);
(* 4  Проверка есть ли место на жестком диске,прерывание DOS 36H *)
  dr:=SwLib.DiskAvail(0); (* число свободных байт *)
  o:=n*16;
  IF LONGCARD(commence)>n*6 THEN o:=o+LONGCARD(commence);END;
  dr:=LONGINT(o)-dr;
  IF dr>0 THEN RETURN dr;END;
(* 5 Преобразование Фурье *)
  BIGFFT.Diskfft(rsize,commence,TRUE,sname);
(* 6  Формируем имя выходного файла *)
  SwLib.nome('S','P','L',result,sname,dname);
(* 7 Копируем этикетку *)
  fs:=FIO.Open(sname);
  FIO.AssignBuffer(fs,bufs);
  fd:=FIO.Create(dname);
  FIO.AssignBuffer(fd,bufd);
  FIO.Seek(fs,0);
    FOR i:=0 TO commence-1 DO
    result:=FIO.RdBin(fs,c,1);
    FIO.WrBin(fd,c,1);
    END;
  FIO.Close(fs);
(* 8  Вычисление спектра и Запись результатов *)
  fs:=FIO.Open('MUSOR0');
  FIO.AssignBuffer(fs,bufs);
mo:=0.0;m2:=0.0;m4:=0.0;min:=MAX(REAL);max:=MIN(REAL);
    FOR o:=0 TO (n DIV 2)-1 DO
    result:=FIO.RdBin(fs,xr,4);
    result:=FIO.RdBin(fs,xi,4);
    amp:=2.0*(xr*xr+xi*xi)/REAL(n)/freq;
    a:=REAL(o)*REAL(o);
    mo:=mo+amp;
    m2:=m2+amp*a;
    m4:=m4+amp*a*a;
    IF amp>max THEN max:=amp;END;
    IF amp<min THEN min:=amp;END;
    FIO.WrBin(fd,amp,4);
    END;
eps:=REAL(MATHLIB.Sqrt(LONGREAL(1.0-m2*m2/mo/m4)));
mo:=mo/REAL(n DIV 2);
(* 9 Вычисление доверительных интервалов *)
ZA[0]:=1.282;ZA[1]:=1.340;ZA[2]:=1.404;ZA[3]:=1.475;ZA[4]:=1.554;ZA[5]:=1.643;
ZA[6]:=1.750;ZA[7]:=1.880;ZA[8]:=1.960;ZA[9]:=2.053;ZA[10]:=2.170;ZA[11]:=2.325;
ZA[12]:=2.576;ZA[13]:=3.290;
IF bet>12 THEN bet:=13;END;
bo:=CARDINAL(bet);
v:=3*rsize;
IF v<120 THEN v:=120;END;
c1:=(1.0-2.0/9.0/REAL(v)+ZA[bo]*REAL(MATHLIB.Sqrt(LONGREAL(2.0/9.0/REAL(v)))))*
    (1.0-2.0/9.0/REAL(v)+ZA[bo]*REAL(MATHLIB.Sqrt(LONGREAL(2.0/9.0/REAL(v)))))*
    (1.0-2.0/9.0/REAL(v)+ZA[bo]*REAL(MATHLIB.Sqrt(LONGREAL(2.0/9.0/REAL(v)))));
c1:=1.0/c1;
c2:=(1.0-2.0/9.0/REAL(v)-ZA[bo]*REAL(MATHLIB.Sqrt(LONGREAL(2.0/9.0/REAL(v)))))*
    (1.0-2.0/9.0/REAL(v)-ZA[bo]*REAL(MATHLIB.Sqrt(LONGREAL(2.0/9.0/REAL(v)))))*
    (1.0-2.0/9.0/REAL(v)-ZA[bo]*REAL(MATHLIB.Sqrt(LONGREAL(2.0/9.0/REAL(v)))));
c2:=1.0/c2;
(* 10  Запись данных в этикетку *)
beta[0] := 0.8;
beta[1] := 0.82;
beta[2] := 0.84;
beta[3] := 0.86;
beta[4] := 0.88;
beta[5] := 0.9;
beta[6] := 0.92;
beta[7] := 0.94;
beta[8] := 0.95;
beta[9] := 0.96;
beta[10]:= 0.97;
beta[11]:= 0.98;
beta[12]:= 0.99;
beta[13]:= 0.999;
 FIO.Seek(fd,26);
 FIO.WrBin(fd,n DIV 2,4);
 dw:=freq/REAL(n-1);
 FIO.Seek(fd,36);
 FIO.WrBin(fd,min,4);
 FIO.WrBin(fd,max,4);
 FIO.WrBin(fd,mo,4);
 obr:=CARDINAL(BITSET(obr)+BITSET(0080H));
 FIO.WrBin(fd,obr,2);
 FIO.Seek(fd,60);
 FIO.WrBin(fd,dw,4);
 FIO.WrBin(fd,eps,4);
 FIO.WrBin(fd,c1,4);
 FIO.WrBin(fd,c2,4);
 FIO.WrBin(fd,beta[CARDINAL(bet)],4);
   FIO.WrStr(fd,'Hz'); FIO.WrChar(fd,CHR(13));
                       FIO.WrChar(fd,CHR(13));
(* 11 Закрытие файлoв *)
  FIO.Close(fs);
  FIO.Close(fd);
  FIO.Erase('MUSOR0');
  RETURN 0;
END s_pect;
BEGIN
END DSPlot.