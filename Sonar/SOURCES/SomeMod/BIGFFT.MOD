IMPLEMENTATION MODULE BIGFFT;
(* Находит преобразование Фурье; вход - файл с данными
   выход - файл с мнимой и действительной частью*)
IMPORT MATHLIB,FIO,Str,SwLib,FFT;
CONST pi=3.1415926;
      k4=4096;
      musor='MUSOR';
VAR   arre,arim           : ARRAY[0..k4-1] OF REAL;
VAR   bufout,buf1,buf2    : ARRAY[0..4095] OF BYTE;

PROCEDURE Diskfft(rsize:LONGCARD;commence:CARDINAL;
                  pram:BOOLEAN;VAR sname:ARRAY OF CHAR);
(* Находит преобразование Фурье;
   вход: rsize - точек в файле,
   commence - начало данных,
   pram=TRUE - прямое преобразование Фурье,
   sname - имя файла с данными,
   выход - файл с мнимой и действительной частью*)
VAR   res,dlina           : CARDINAL;
      offset,step         : CARDINAL;
      points,i,mlog,j     : CARDINAL;
      dname,evname,odname : ARRAY[0..12] OF CHAR;
      fs,fd               : FIO.File;
VAR  a,sin,cos            : REAL;
     fin                  : ARRAY[0..2] OF CHAR;
     bool                 : BOOLEAN;
     inv,long             : LONGCARD;

PROCEDURE sticker(n:CARDINAL;VAR even,odd:ARRAY OF CHAR);
(* склейка двух файлов - реализаций
   структура входных файлов - четные - действительные,
   нечетные - мнимая; вход: n-количество комплексных чисел,
   even,odd-имена входных файлов*)
VAR imodd,imeven,reodd,reeven : REAL;
    im,re,sign                : REAL;
    w                         : LONGREAL;
    l                         : LONGCARD;
    end                       : ARRAY[0..2] OF CHAR;
    out                       : ARRAY[0..8] OF CHAR;
    bul                       : BOOLEAN;
    i,j,result                : CARDINAL;
    f,fe,fo                   : FIO.File;
BEGIN
Str.Delete(out,0,8);
Str.Copy(out,musor);
(* 2 Склейка *)
(*  Открыть файлы *)
  fe:=FIO.Open(even);
  FIO.AssignBuffer(fe,buf1);
  fo:=FIO.Open(odd);
  FIO.AssignBuffer(fo,buf2);
  f:=FIO.Create(out);
  FIO.AssignBuffer(f,bufout);
  w:=pi/LONGREAL(n);
  sign:=1.0;
    FOR i:=1 TO 2 DO
      FOR j:=0 TO n-1 DO
      result:=FIO.RdBin(fe,reeven,4);
      result:=FIO.RdBin(fe,imeven,4);
      result:=FIO.RdBin(fo,reodd,4);
      result:=FIO.RdBin(fo,imodd,4);
      sin:=REAL(MATHLIB.Sin(w*LONGREAL(j)));
      cos:=REAL(MATHLIB.Cos(w*LONGREAL(j)));
      re:=reeven+sign*(reodd*cos+imodd*sin);
      im:=imeven+sign*(imodd*cos-reodd*sin);
      FIO.WrBin(f,re,4);
      FIO.WrBin(f,im,4);
      END;
    sign:=-1.0;
    FIO.Seek(fe,0);
    FIO.Seek(fo,0);
    END;
(* Закрытие файлoв *)
  FIO.Close(f);
  FIO.Close(fe);FIO.Erase(even);
  FIO.Close(fo);FIO.Erase(odd);
(* 2 Формируем имя выходного файла *)
FIO.Rename(musor,even);
END sticker;

PROCEDURE invert(VAR dig:LONGCARD;p:CARDINAL);
(* двоичное инвертирование dig *)
VAR  ji,temp,sum,knife         : CARDINAL;
BEGIN
sum:=0;
knife:=16;
   FOR ji:=1 TO 7 BY 2 DO
   temp:=CARDINAL(dig);
   temp:=temp<<ji;
   sum:=sum+CARDINAL(BITSET(temp)*BITSET(knife));
   knife:=knife<<1;
   END;
dig:=LONGCARD(sum);
dig:=dig*LONGCARD(p) DIV 256;
END invert;

BEGIN
(* 1 Открываем файл данных              *)
  fs:=FIO.Open(sname);
  FIO.AssignBuffer(fs,bufout);
(* 2 Делаем чтоб длина реализации была степенью двойки *)
  SwLib.pow2(rsize,long,mlog);
(* 3 Порубати на шматки та зробити FFT                 *)
step:=CARDINAL(long DIV k4);
IF long>=k4  THEN mlog:=12;
                  dlina:=k4;
             ELSE step:=1;
                  dlina:=CARDINAL(long);
             END;
  FOR offset:=0 TO step-1 DO
  FIO.Seek(fs,LONGCARD(commence+offset*4));
  points:=CARDINAL((rsize-LONGCARD(offset+1)) DIV LONGCARD(step))+1;
  (* 3.0 Переписываем кусок файла в память*)
  IF pram THEN  (*для прямого*)
                FOR i:=0 TO points-1 DO
                FIO.Seek(fs,LONGCARD(commence+offset*4)+
                         LONGCARD(4*step)*LONGCARD(i));
                res:=FIO.RdBin(fs,a,4);
                arre[i]:=a;
                arim[i]:=0.0;
                END;
                FOR i:=points TO dlina-1 DO
                arre[i]:=0.0;
                arim[i]:=0.0;
                END;
          ELSE  (*для обратного*)
                FOR i:=0 TO points-1 DO
                FIO.Seek(fs,LONGCARD(offset*8)+
                         LONGCARD(8*step)*LONGCARD(i));
                res:=FIO.RdBin(fs,a,4);
                arre[i]:=a;
                res:=FIO.RdBin(fs,a,4);
                arim[i]:=a;
                END;
          END;
  (* 3.1 Преобразование Фурье короткое *)
  FFT.nfft(dlina,mlog,arre,arim);
  (* 3.2 Формируем имя выходного файла *)
  (* инвертируем offset *)
  inv:=LONGCARD(offset);
  invert(inv,step);
  Str.Copy(dname,musor);
  Str.CardToStr(inv,fin,CARDINAL(10),bool);
  Str.Append(dname,fin);
  (* 3.3 Запись в файл *)
  fd:=FIO.Create(dname);
  FIO.AssignBuffer(fd,buf2);
    FOR i:=0 TO dlina-1 DO
    FIO.WrBin(fd,arre[i],4);
    FIO.WrBin(fd,arim[i],4);
    END;
  FIO.Close(fd);
  END;
  FIO.Close(fs);
 IF NOT pram THEN FIO.Erase(sname);END;
(* 4 Склейка кусков в один большой *)
  res:=k4;
  j:=1;
  WHILE step>1 DO
  (* одна склейка *)
    FOR i:=1 TO step DIV 2 DO
    inv:=LONGCARD((i-1)*2*j);
    Str.Copy(evname,musor);
    Str.CardToStr(inv,fin,CARDINAL(10),bool);
    Str.Append(evname,fin);
    inv:=inv+LONGCARD(j);
    Str.Copy(odname,musor);
    Str.CardToStr(inv,fin,CARDINAL(10),bool);
    Str.Append(odname,fin);
    sticker(res,evname,odname)
    END;
  step:=step DIV 2;
  res:=res*2;
  j:=j*2;
  END;
END Diskfft;

END BIGFFT.