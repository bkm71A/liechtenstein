IMPLEMENTATION MODULE Fazamp;
(* Работа с областями RAM*)
IMPORT MATHLIB,FIO,Storage,SwLib;
CONST ln2=0.69314717;
      pi=3.1415926;
      k64=65536;
      k32=32768;
      k4=4096;
      k8=8192;
      k16=16384;
      nome1='musor1';
      nome2='musor2';
      rad=57.29578049;
PROCEDURE afaza(VAR sname,aname,fname:ARRAY OF CHAR):LONGINT;
VAR adr                       : ADDRESS;
    c                         : SHORTCARD;
    fmo,amo,fmin,amin,fmax,amax: REAL;
    a,b,xr,xi,dw,amp,faza     : REAL;        (*служебные значения   *)
    y                         : LONGREAL;
    freq                      : REAL;        (*частота дискретизации*)
    mlog,commence,obr         : CARDINAL;    (*log 2 длины массива  *)
    result,ns,of,i            : CARDINAL;
    sr,si                     : ARRAY[0..1] OF CARDINAL;(*сегменты данных *)
    rsize,long,n,o,o1,o2      : LONGCARD;(*длина реализации,длина бпф,счетчики*)
    mem                       : CARDINAL;(*доступная память в блоках*)
    fs,tf1,tf2                : FIO.File;(*файлы:входной,выходной,промежуточные*)
    bufs,buf1,buf2            : ARRAY[1..2048] OF BYTE;
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
(* 4  Проверка есть ли место на жестком диске,прерывание DOS 36H *)
  dr:=SwLib.DiskAvail(0); (* число свободных байт *)
  o:=(LONGCARD(commence)+n*2)*2;
  dr:=LONGINT(o)-dr;
  IF dr>0 THEN FIO.Close(fs);RETURN dr;END;

(* 5  Распределение памяти   *)
(* Если rsize>32K,то разбить на две части *)
  IF rsize>k32 THEN n:=k32;END;
  mem:=Storage.HeapAvail(Storage.MainHeap);
  IF mem<CARDINAL(n DIV 2) THEN FIO.Close(fs);
                                RETURN LONGINT(mem)-LONGINT(n DIV 2);
                                END;
  Storage.HeapAllocate(Storage.MainHeap,adr,mem);
  sr[0]:=CARDINAL(LONGCARD(adr)>>16);
  si[0]:=sr[0]+1000H;
  IF n<k16 THEN si[0]:=sr[0]+CARDINAL(n DIV 4);END;
  sr[1]:=sr[0]+2000H;
  si[1]:=si[0]+2000H;
(* 6 Преобразование Фурье *)
FIO.Seek(fs,LONGCARD(commence));
IF rsize>k32 THEN  (* 6.A Вычисляем по частям *)
  o2:=(rsize-1) DIV 2;
   FOR i:=1 TO 2 DO
    FOR o:=0 TO o2 DO
    result:=FIO.RdBin(fs,b,4);
    ns:=CARDINAL(o DIV k16);
    of:=4*CARDINAL(o MOD k16);
    p1:=[sr[ns]:of];
    p1^:=b;
    result:=FIO.RdBin(fs,b,4);
    END;
   (* растянуть нулями до 32K *)
   IF o2+1<k32 THEN  FOR o:=o2+1 TO k32-1 DO
                     ns:=CARDINAL(o DIV k16);
                     of:=4*CARDINAL(o MOD k16);
                     p1:=[sr[ns]:of];
                     p1^:=0.0;
                     END;
                    END;
  (*мнимая часть равна нулю *)
    FOR o:=0 TO k32-1 DO
    ns:=CARDINAL(o DIV k16);
    of:=4*CARDINAL(o MOD k16);
    p2:=[si[ns]:of];
    p2^:=0.0;
    END;
   SwLib.fft(k32,15,sr,si);
   IF i=1 THEN (* четные *)
          tf1:=FIO.Create(nome1);
          tf2:=FIO.Create(nome2);
          (* сохранить четные *)
          reszapis(tf1,tf2,k32);
          (*Seek установить на первый элемент реализации ,т.е. второй*)
          o1:=LONGCARD(commence)+4;
          FIO.Seek(fs,o1);
          o2:=(rsize DIV 2)-1;
          END;
   END;
(* 6.A.2 склейка *)
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
  n:=k64;
ELSE
 (* 6.B.1  Переписываем файл в области RAM *)
    FOR o:=0 TO long-1 DO
    result:=FIO.RdBin(fs,b,4);
    ns:=CARDINAL(o DIV k16);
    of:=4*CARDINAL(o MOD k16);
    p1:=[sr[ns]:of];
    p1^:=b;
    END;
  IF n>long THEN     (* растянуть файл *)
     b:=0.0;
       FOR o:=long TO n-1 DO
       ns:=CARDINAL(o DIV k16);
       of:=4*CARDINAL(o MOD k16);
       p1:=[sr[ns]:of];
       p1^:=b;
       END;
     END;
    FOR o:=0 TO n-1 DO
    ns:=CARDINAL(o DIV k16);
    of:=4*CARDINAL(o MOD k16);
    p1:=[si[ns]:of];
    p1^:=0.0;
    END;
(* 6.B.2  Вызов процедуры *)
  SwLib.fft(n,mlog,sr,si);
END;
(* 7 Копируем этикетку *)
  tf1:=FIO.Create(aname);
  FIO.AssignBuffer(tf1,buf1);
  FIO.Seek(fs,0);
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
(* 8  Вычисление амплитуды и фазы и Запись результатов *)
fmo:=0.0;fmin:=MAX(REAL);fmax:=MIN(REAL);
amo:=0.0;amin:=MAX(REAL);amax:=MIN(REAL);
    FOR o:=0 TO (n DIV 2)-1 DO
    ns:=CARDINAL(o*4 DIV k64);
    of:=CARDINAL(o*4 MOD k64);
    p1:=[sr[ns]:of];
    p2:=[si[ns]:of];
    y:=LONGREAL(p1^*p1^)+LONGREAL(p2^*p2^);
    amp:=REAL(MATHLIB.Sqrt(y));
    IF amp=0.0 THEN faza:=0.0;
               ELSE faza:=REAL(MATHLIB.ACos(LONGREAL(p1^/amp)))*rad;
               END;
    IF p2^<0.0 THEN faza:=360.0-faza;END;
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
(* 9  Закрытие областей памяти*)
  Storage.HeapDeallocate(Storage.MainHeap,adr,mem);
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
  RETURN 0;
END afaza;

END Fazamp.