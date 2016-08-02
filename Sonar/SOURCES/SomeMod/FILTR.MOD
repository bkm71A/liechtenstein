IMPLEMENTATION MODULE Filtr;
(* Работа с областями RAM*)
IMPORT MATHLIB,FIO,Storage,SwLib;
PROCEDURE filtration(bor1,bor2:REAL;VAR sname,dname:ARRAY OF CHAR):LONGINT;
CONST pi=3.1415926;
      k64=65536;
      k32=32768;
      k4=4096;
      k8=8192;
      k16=16384;
      p=20;
VAR adr                       : ADDRESS;
    c                         : SHORTCARD;
    a,b,max,min,mo            : REAL;        (*служебные значения   *)
    freq                      : REAL;        (*частота дискретизации*)
    commence,mlog             : CARDINAL;    (*log 2 длины массива  *)
    result,ns,of,ara,i,obr    : CARDINAL;
    sr,si                     : ARRAY[0..1] OF CARDINAL;(*сегменты данных *)
    rsize,long,n,o,o1,o2      : LONGCARD;    (*длина файла,длина бпф,счетчики*)
    mem                       : CARDINAL;
    fs,fd                     : FIO.File;    (*файлы:входной,выходной*)
    bufs,bufd                 : ARRAY[1..2048] OF BYTE;
    p1,p2,p3,p4               : POINTER TO REAL;
    dr                        : LONGINT;
BEGIN
  mo:=0.0;
  min:=MAX(REAL);
  max:=MIN(REAL);
(* 0  Проверка есть ли место на жестком диске,прерывание DOS 36H *)
  fs:=FIO.Open(sname);
  FIO.AssignBuffer(fs,bufs);
  o:=FIO.Size(fs);
  dr:=SwLib.DiskAvail(0);(* число свободных байт *)
  dr:=LONGINT(o)-dr;
  IF dr>0 THEN FIO.Close(fs);RETURN dr;
          END;
(* 1  Формируем имя выходного файла *)
  SwLib.nome('F','L','0',result,sname,dname);
  i:=0;
    WHILE FIO.Exists(dname) DO
    i:=i+1;
    dname[result+3]:=CHAR(i+30H);
    END;
(* 2  Работа с этикеткой,считать данные *)
  FIO.Seek(fs,22);
  result:=FIO.RdBin(fs,freq,4);
  result:=FIO.RdBin(fs,rsize,4);
  FIO.Seek(fs,32);
  result:=FIO.RdBin(fs,commence,2);
  FIO.Seek(fs,48);
  result:=FIO.RdBin(fs,obr,2);
(* 3 Копируем этикетку *)
  fd:=FIO.Create(dname);
  FIO.AssignBuffer(fd,bufd);
  FIO.Seek(fs,0);
    FOR i:=0 TO commence-1 DO
    result:=FIO.RdBin(fs,c,1);
    FIO.WrBin(fd,c,1);
    END;
  long:=rsize;
(* 4 Делаем чтоб длина реализации была степенью двойки *)
  SwLib.pow2(long,n,mlog);
(* 5  Распределение памяти   *)
(* Если rsize>32K,то разбить на две части *)
  IF rsize>k32 THEN ara:=2;n:=k32;mlog:=15;long:=k32;
               ELSE ara:=1;
               END;
  mem:=Storage.HeapAvail(Storage.MainHeap);
  IF mem<CARDINAL(n DIV 2) THEN FIO.Close(fs);FIO.Close(fd);
                           FIO.Erase(dname);
                           RETURN LONGINT(mem)-LONGINT(n DIV 2);
                           END;
  Storage.HeapAllocate(Storage.MainHeap,adr,mem);
  sr[0]:=CARDINAL(LONGCARD(adr)>>16);
  si[0]:=sr[0]+1000H;
  IF n<k16 THEN si[0]:=sr[0]+CARDINAL(n DIV 4);
           END;
  sr[1]:=sr[0]+2000H;
  si[1]:=si[0]+2000H;
    FOR i:=1 TO ara DO (*если длина>32K,то повторить два раза*)
    IF i=2 THEN long:=rsize-k32;
           END;
(* 6  Переписываем файл в области RAM *)
      FOR o:=0 TO long-1 DO
      result:=FIO.RdBin(fs,b,4);
      ns:=CARDINAL(o DIV k16);
      of:=4*CARDINAL(o MOD k16);
      p1:=[sr[ns]:of];
      p1^:=b;
      END;
(* 8  Pастянуть файл *)
    IF n>long THEN
              b:=0.0;
                FOR o:=long TO n-1 DO
                ns:=CARDINAL(o DIV k16);
                of:=4*CARDINAL(o MOD k16);
                p1:=[sr[ns]:of];
                p1^:=b;
                END;
              END;
(* 9  Комплексная часть - 0 *)
      FOR o:=0 TO n-1 DO
      ns:=CARDINAL(o DIV k16);
      of:=4*CARDINAL(o MOD k16);
      p1:=[si[ns]:of];
      p1^:=0.0;
      END;
(* 10 Вызов процедуры *)
    SwLib.fft(n,mlog,sr,si);
(* 11 Проверка границ на корректность и перевод в номер *)
    IF bor1<0.0 THEN bor1:=0.0;END;
    IF bor2<0.0 THEN bor2:=0.0;END;
    IF bor1>bor2 THEN bor2:=bor1;END;
    IF bor1>=freq/2.0 THEN o1:=(n DIV 2)-1;
                      ELSE o1:=LONGCARD(bor1*REAL(n-1)/freq);
                      END;
    IF bor2>=freq/2.0 THEN o2:=(n DIV 2)-1;
                      ELSE o2:=LONGCARD(bor2*REAL(n-1)/freq+0.5);
                      END;
(* 12 Умножение на передаточную функцию *)
      FOR o:=0 TO n-1 DO
      ns:=CARDINAL(o*4 DIV k64);
      of:=CARDINAL(o*4 MOD k64);
      p1:=[sr[ns]:of];
      p2:=[si[ns]:of];
      IF (o1>o) OR ((o2<o)AND(n-1-o2>o)) OR (o>n-1-o1)
                      THEN  p1^:=0.0;
                            p2^:=0.0;
                      ELSE  p2^:=-p2^;
                      END;
      END;
(* 13 Обратное FFT *)
    SwLib.fft(n,mlog,sr,si);
      FOR o:=0 TO n-1 DO
      ns:=CARDINAL(o*4 DIV k64);
      of:=CARDINAL(o*4 MOD k64);
      p1:=[sr[ns]:of];
      p2:=[si[ns]:of];
      p1^:=p1^/REAL(n);
      END;
(* 14 Запись результатов *)
(*Копирует память в файлы и закрывает их *)
      FOR o:=0 TO long-1 DO
      ns:=CARDINAL(o*4 DIV k64);
      of:=CARDINAL(o*4 MOD k64);
      p1:=[sr[ns]:of];
      mo:=mo+p1^;
      IF p1^>max THEN max:=p1^;END;
      IF p1^<min THEN min:=p1^;END;
      FIO.WrBin(fd,p1^,4);
      END;
    END;
(* 15 Закрытие областей памяти*)
  Storage.HeapDeallocate(Storage.MainHeap,adr,mem);
(* 16 Запись в этикетку *)
  mo:=mo/REAL(rsize);
  FIO.Seek(fd,36);
  FIO.WrBin(fd,min,4);
  FIO.WrBin(fd,max,4);
  FIO.WrBin(fd,mo,4);
  obr:=CARDINAL(BITSET(obr)+BITSET(0020H));
  FIO.WrBin(fd,obr,2);
  FIO.WrBin(fd,bor1,4);
  FIO.WrBin(fd,bor2,4);
(* Утюг *)
  IF rsize>k32 THEN o1:=LONGCARD(commence)+k32*4-4;
                    FIO.Seek(fd,o1);
                    result:=FIO.RdBin(fd,mo,4);
                    result:=FIO.RdBin(fd,b,4);
                    a:=(mo*1.2+b*0.8)/2.0;
                    b:=(b*1.2+mo*0.8)/2.0;
                    o1:=LONGCARD(commence)+k32*4-4;
                    FIO.Seek(fd,o1);
                    FIO.WrBin(fd,a,4);
                    FIO.WrBin(fd,b,4);
                    o1:=LONGCARD(commence)+k32*4-20;
                    FIO.Seek(fd,o1);
                    result:=FIO.RdBin(fd,mo,4);
                    result:=FIO.RdBin(fd,a,4);
                    o1:=o1+8;
                      FOR i:= 1 TO 8 DO
                      result:=FIO.RdBin(fd,b,4);
                      mo:=(mo+a+b)/3.0;
                      o1:=o1-4;
                      FIO.Seek(fd,o1);
                      FIO.WrBin(fd,mo,4);
                      mo:=a;
                      a:=b;
                      o1:=o1+8;
                      FIO.Seek(fd,o1);
                      END;
               END;
(* 17 Закрытие файлoв *)
  FIO.Close(fs);
  FIO.Close(fd);
  RETURN 0;
END filtration;

END Filtr.