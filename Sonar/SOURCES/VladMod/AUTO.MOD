IMPLEMENTATION MODULE Auto;
(* Работа с областями RAM*)
IMPORT MATHLIB,FIO,Storage,SwLib;
CONST pi=3.1415926;
      k64=65536;
      k32=32768;
      k16=16384;
      nome1='musor1';
      nome2='musor2';
      nome3='musor';
PROCEDURE correl(VAR sname,dname:ARRAY OF CHAR):LONGINT;
VAR adr                       : ADDRESS;
    c                         : SHORTCARD;
    mo,min,max                : REAL;
    a,b,xr,xi                 : REAL;        (*служебные значения   *)
    freq                      : REAL;        (*частота дискретизации*)
    y                         : LONGREAL;
    mlog,commence,obr         : CARDINAL;    (*log 2 длины массива  *)
    result,ns,of,i,ji         : CARDINAL;
    sr,si                     : ARRAY[0..1] OF CARDINAL;(*сегменты данных *)
    rsize,long,n,o,o1,o2      : LONGCARD;(*длина реализации,длина бпф,счетчики*)
    mem                       : CARDINAL;(*доступная память в блоках*)
    fs,fd,tf1,tf2             : FIO.File;(*файлы:входной,выходной,промежуточные*)
    bufs,bufd,buf1,buf2       : ARRAY[1..2048] OF BYTE;
    p1,p2                     : POINTER TO REAL;
    dr                        : LONGINT;
PROCEDURE reszapis(fil1,fil2:FIO.File;dlina:LONGCARD);
(*Копирует память в файлы и закрывает их *)
VAR op : LONGCARD;
BEGIN
FIO.AssignBuffer(fil1,buf1);
FIO.AssignBuffer(fil2,buf2);
    FOR op:=0 TO dlina-1 DO
    ns:=CARDINAL(o*4 DIV k64);
    of:=CARDINAL(o*4 MOD k64);
    p1:=[sr[ns]:of];
    p2:=[si[ns]:of];
    FIO.WrBin(fil1,p1^,4);
    FIO.WrBin(fil2,p2^,4);
    END;
FIO.Close(fil1);
FIO.Close(fil2);
END reszapis;
BEGIN
(* 0  Формируем имя выходного файла *)
  SwLib.nome('K','O','R',result,sname,dname);
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
(* 4  Проверка есть ли место на жестком диске,прерывание DOS 36H *)
  dr:=SwLib.DiskAvail(0); (* число свободных байт *)
  IF rsize>k32 THEN o:=8*k64;ELSE o:=LONGCARD(commence)+n*2;END;
  dr:=LONGINT(o)-dr;
  IF dr>0 THEN FIO.Close(fs);RETURN dr;END;
(* 5 Копируем этикетку *)
  fd:=FIO.Create(dname);
  FIO.AssignBuffer(fd,bufd);
  FIO.Seek(fs,0);
    FOR i:=0 TO commence-1 DO
    result:=FIO.RdBin(fs,c,1);
    FIO.WrBin(fd,c,1);
    END;
(* 6  Распределение памяти   *)
(* Если rsize>32K,то разбить на две части *)
  IF rsize>k32 THEN n:=k32;END;
  mem:=Storage.HeapAvail(Storage.MainHeap);
  IF mem<CARDINAL(n DIV 2) THEN FIO.Close(fs);FIO.Close(fd);FIO.Erase(dname);
                                RETURN LONGINT(mem)-LONGINT(n DIV 2);
                                END;
  Storage.HeapAllocate(Storage.MainHeap,adr,mem);
  sr[0]:=CARDINAL(LONGCARD(adr)>>16);
  si[0]:=sr[0]+1000H;
  IF n<k16 THEN si[0]:=sr[0]+CARDINAL(n DIV 4);END;
  sr[1]:=sr[0]+2000H;
  si[1]:=si[0]+2000H;
              (* 7  С А М О   В Ы Ч И С Л Е Н И Е  *)
IF rsize<=k32 THEN
      (*  Д Л Я         Д Л И Н Ы      М Е Н Е Е   32 K    *)
 (* 7.B.1  Переписываем файл в области RAM *)
    FOR o:=0 TO long-1 DO
    result:=FIO.RdBin(fs,b,4);
    ns:=CARDINAL(o DIV k16);
    of:=4*CARDINAL(o MOD k16);
    p1:=[sr[ns]:of];
    p2:=[si[ns]:of];
    p2^:=0.0;
    p1^:=b;
    END;
  IF n>long THEN     (* растянуть файл *)
            b:=0.0;
              FOR o:=long TO n-1 DO
              ns:=CARDINAL(o DIV k16);
              of:=4*CARDINAL(o MOD k16);
              p1:=[sr[ns]:of];
              p2:=[si[ns]:of];
              p2^:=0.0;
              p1^:=b;
              END;
            END;
(* 7.B.3  Вызов процедуры *)
  SwLib.fft(n,mlog,sr,si);
(* 7.B.4  Вычисление спектральной плотности *)
    FOR o:=0 TO n-1 DO
    ns:=CARDINAL(o*4 DIV k64);
    of:=CARDINAL(o*4 MOD k64);
    p1:=[sr[ns]:of];
    p2:=[si[ns]:of];
    p1^:=2.0*(p1^*p1^+p2^*p2^)/REAL(n)/freq;
    p2^:=0.0;
    END;
(* 7.B.5  Вызов процедуры,обратное FFT *)
  SwLib.fft(n,mlog,sr,si);
END;
     (* Д Л Я Д Л И Н Ы  Б О Л Е Е    32 K *)
IF rsize>k32 THEN
  FOR ji:=1 TO 2 DO
(* 7.A Вычисляем по частям *)
  o2:=(rsize-1) DIV 2;
   FOR i:=1 TO 2 DO
   (* 7.A.1 читаем через один *)
    FOR o:=0 TO o2 DO
    result:=FIO.RdBin(fs,b,4);
    ns:=CARDINAL(o DIV k16);
    of:=4*CARDINAL(o MOD k16);
    p1:=[sr[ns]:of];
    p2:=[si[ns]:of];
    p2^:=0.0;
    p1^:=b;
    result:=FIO.RdBin(fs,b,4);
    END;
   (* 7.A.2 растянуть нулями до 32K *)
   IF o2+1<k32 THEN  FOR o:=o2+1 TO k32-1 DO
                     ns:=CARDINAL(o DIV k16);
                     of:=4*CARDINAL(o MOD k16);
                     p1:=[sr[ns]:of];
                     p2:=[si[ns]:of];
                     p2^:=0.0;
                     p1^:=0.0;
                     END;
               END;
   (* 7.A.3  Вызов процедуры *)
   SwLib.fft(k32,15,sr,si);
   (* 7.A.4 сохранить первую половину *)
   IF i=1 THEN (* четные *)
          tf1:=FIO.Create(nome1);
          tf2:=FIO.Create(nome2);
          (* сохранить четные *)
          reszapis(tf1,tf2,k32);
          (*Seek установить на первый элемент реализации ,т.е. второй*)
          o1:=LONGCARD(2-ji)*LONGCARD(commence)+4;
          FIO.Seek(fs,o1);
          o2:=(rsize DIV 2)-1;
          END;
   END;
(* 7.A.5 склейка *)
  tf1:=FIO.Open(nome1);
  tf2:=FIO.Open(nome2);
  y:=pi/LONGREAL(k32);
    FOR o:=0 TO k32-1 DO
    result:=FIO.RdBin(tf1,a,4);
    result:=FIO.RdBin(tf2,b,4);
    ns:=CARDINAL(o DIV k16);
    of:=4*CARDINAL(o MOD k16);
    p1:=[sr[ns]:of];
    p2:=[si[ns]:of];
    xr:=a+p1^*REAL(MATHLIB.Cos(y*LONGREAL(o)))+p2^*REAL(MATHLIB.Sin(y*LONGREAL(o)));
    xi:=b-p1^*REAL(MATHLIB.Sin(y*LONGREAL(o)))+p2^*REAL(MATHLIB.Cos(y*LONGREAL(o)));
    p1^:=xr;
    p2^:=xi;
    END;
  FIO.Close(tf1);FIO.Erase(nome1);
  FIO.Close(tf2);FIO.Erase(nome2);
  (* ji=1 имеем в памяти 32к спектра                    *)
  (* ji=2 имеем в памяти 32к автокорреляционной функции *)
  IF ji=1 THEN rsize:=k64;
               FIO.Close(fs);
               fs:=FIO.Create(nome3);
               FIO.AssignBuffer(fs,bufs);
                  FOR o:=0 TO k32-1 DO
                  ns:=CARDINAL(o*4 DIV k64);
                  of:=CARDINAL(o*4 MOD k64);
                  p1:=[sr[ns]:of];
                  p2:=[si[ns]:of];
                  p1^:=2.0*(p1^*p1^+p2^*p2^)/freq/REAL(k64);
                  FIO.WrBin(fs,p1^,4);
                  END;
                  FOR o:=k32-1 TO 0 BY -1 DO
                  ns:=CARDINAL(o*4 DIV k64);
                  of:=CARDINAL(o*4 MOD k64);
                  p1:=[sr[ns]:of];
                  FIO.WrBin(fs,p1^,4);
                  END;
                FIO.Seek(fs,0);
          END;
  END;
  FIO.Close(fs);FIO.Erase(nome3);fs:=FIO.Open(sname);
  n:=k64;
END;
(* 8  Вычисление функции и Запись результатов *)
mo:=0.0;min:=MAX(REAL);max:=MIN(REAL);
    FOR o:=0 TO (n DIV 2)-1 DO
    ns:=CARDINAL(o*4 DIV k64);
    of:=CARDINAL(o*4 MOD k64);
    p1:=[sr[ns]:of];
    p1^:=p1^/REAL(n);
    mo:=mo+p1^;
    IF p1^>max THEN max:=p1^;END;
    IF p1^<min THEN min:=p1^;END;
    FIO.WrBin(fd,p1^,4);
    END;
mo:=mo/REAL(n DIV 2);
(* 9  Закрытие областей памяти*)
  Storage.HeapDeallocate(Storage.MainHeap,adr,mem);
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
  FIO.Close(fs);
  FIO.Close(fd);
  RETURN 0;
END correl;
BEGIN
END Auto.