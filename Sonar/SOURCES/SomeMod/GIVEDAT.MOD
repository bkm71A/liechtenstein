(*Пpогpамма фоpмиpования исходных данных,макет*)
MODULE givedat;
IMPORT IO,Lib,Window,InOut,FIO,MATHLIB;
CONST   pi=3.1415926;
VAR i,n,o1,o2       : CARDINAL;
    f               : FIO.File;
    pil,imp,gar     : BOOLEAN;
    buf             : ARRAY[0..2047] OF BYTE;
    s               : CHAR;
    x,freq,a,zero   : REAL;
    mo,max,min      : REAL;
    long,j          : LONGCARD;
    commence        : CARDINAL;
    amp,faza,w      : ARRAY[1..100] OF REAL;
    filename        : ARRAY[1..12]  OF CHAR;
PROCEDURE vvod();
VAR j                         : CARDINAL;    (* счетчик цикла *)
    wd0,wd1,wd2,wd3,wd4,wd5,wd6,wd7   : Window.WinDef;     (*window*)
    wt0,wt1,wt2,wt3,wt4,wt5,wt6,wt7   : Window.WinType;
    c                                 : CHAR;
BEGIN
(* 1 Задание параметров окон *)
wd0:=Window.WinDef(0,0,79,24,Window.LightGreen,Window.Blue,
FALSE,FALSE,FALSE,FALSE,Window.SingleFrame,Window.Red,Window.Red);
wd1:=Window.WinDef(30,3,35,3,Window.Black,Window.Cyan,
TRUE,FALSE,FALSE,FALSE,Window.SingleFrame,Window.Red,Window.Red);
wd2:=Window.WinDef(30,4,35,4,Window.Black,Window.Cyan,
TRUE,FALSE,FALSE,FALSE,Window.SingleFrame,Window.Red,Window.Red);
wd3:=Window.WinDef(30,5,35,5,Window.Black,Window.Cyan,
TRUE,FALSE,FALSE,FALSE,Window.SingleFrame,Window.Red,Window.Red);
wd4:=Window.WinDef(35,6,50,6,Window.Black,Window.Cyan,
TRUE,FALSE,FALSE,FALSE,Window.SingleFrame,Window.Red,Window.Red);
(*
wd5:=Window.WinDef(30,7,45,7,Window.Black,Window.Cyan,
TRUE,FALSE,FALSE,FALSE,Window.SingleFrame,Window.Red,Window.Red);
wd6:=Window.WinDef(30,8,35,8,Window.Black,Window.Cyan,
TRUE,FALSE,FALSE,FALSE,Window.SingleFrame,Window.Red,Window.Red);
wd7:=Window.WinDef(11,12,14,12,Window.Black,Window.Cyan,
TRUE,FALSE,FALSE,FALSE,Window.SingleFrame,Window.Red,Window.Red);
wd8:=Window.WinDef(15,14,16,14,Window.Black,Window.Cyan,
TRUE,FALSE,FALSE,FALSE,Window.SingleFrame,Window.Red,Window.Red);*)

(* 2 Вывод окона 0 - общее окно *)
wt0:=Window.Open(wd0);
Window.GotoXY(14,1);IO.WrStr('Пpогpамма фоpмиpования исходных данных,макет');
Window.GotoXY(25,3);IO.WrStr(' ЗАДАЙТЕ  ПАРАМЕТРЫ');
Window.GotoXY(3,4);IO.WrStr('Пила Y -да,иначе N нет     ');
Window.GotoXY(3,5);IO.WrStr('Импульс Y -да,иначе N нет  ');
Window.GotoXY(3,6);IO.WrStr('Гармоники Y -да,иначе N нет');
Window.GotoXY(3,7);IO.WrStr('Имя выходного файла        ');
(* 3 Чтение                  *)
wt1:=Window.Open(wd1);
InOut.Read(c);
IF (c='y') OR (c='Y') THEN pil:=TRUE;
                  ELSE pil:=FALSE;
                  END;
Window.Close(wt1);
wt2:=Window.Open(wd2);
InOut.Read(c);
IF (c='y') OR (c='Y') THEN imp:=TRUE;
                      ELSE imp:=FALSE;
                      END;
Window.Close(wt2);

wt3:=Window.Open(wd3);
InOut.Read(c);
IF (c='y') OR (c='Y') THEN gar:=TRUE;
                      ELSE gar:=FALSE;
                      END;
Window.Close(wt3);
wt4:=Window.Open(wd4);
InOut.ReadString(filename);
Window.Close(wt4);
Window.GotoXY(3,8);IO.WrStr(filename);
Window.GotoXY(3,9);IO.WrStr('Длина peaлизации ');
long:=IO.RdLngCard();
IF pil=TRUE THEN  IO.WrStr('    введите наклон   ');
                  a:=IO.RdReal();
                  a:=a/freq;
            END;
IO.WrLn();
IF imp=TRUE THEN  IO.WrStr('введите начальную точку   ');
                  o1:=IO.RdCard();
                  IO.WrStr('введите конечную  точку   ');
                  o2:=IO.RdCard();
            END;
IO.WrLn();
IF gar=TRUE THEN  IO.WrStr('Количество гармоник  ');
                  n:=IO.RdCard();
                  IF n>100 THEN n:=99;END;
              FOR i:=1 TO n DO
              IO.WrStr('Амплитуда гармоники  ');IO.WrCard(i,4);IO.WrStr('   ');
              amp[i]:=IO.RdReal();
              (*Частота процесса, составляющяя i*)
              IO.WrStr('Частота гармоники    ');IO.WrCard(i,4);IO.WrStr('   ');
              w[i]:=IO.RdReal();
              IF w[i]>500. THEN w[i]:=450.0 END;
              IO.WrStr('Фаза гармоники       ');IO.WrCard(i,4); IO.WrStr('   ');
              faza[i]:=IO.RdReal();IO.WrLn;
              END;
            END;
(* 5 Закрытие окон *)
Window.Close(wt0);
END vvod;

BEGIN
(*Частота дискретизации*)
 freq:=1000.0;
 vvod();
 (* 2 задание значений *)
(* Начало данных     *)
 commence:=105;
 zero:=0.0;
 f:=FIO.Create(filename);
 FIO.AssignBuffer(f,buf);
   FOR j:=1 TO LONGCARD(commence) DO
   FIO.WrBin(f,zero,4);
   END;
 FIO.Seek(f,LONGCARD(0));
(* Создаем этикетку *)
 FIO.WrBin(f,34,2);
 FIO.WrStr(f,'12/04/91');
 FIO.WrStr(f,'" 1"');
 x:=0.0;
 FIO.WrBin(f,x,4);
 x:=0.512;
 FIO.WrBin(f,x,4);
 FIO.Seek(f,LONGCARD(commence));

(* 3 Задание и запись массива *)
 mo:=0.0;min:=MAX(REAL);max:=MIN(REAL);
    FOR j:=0 TO long-LONGCARD(1) DO
    x:=0.0;
    (* задание входного массива *)
    IF gar THEN FOR i:=1 TO n DO
                x:=x+amp[i]*REAL(MATHLIB.Sin(LONGREAL(w[i]*pi*
                2.0/freq)*LONGREAL(REAL(j)+faza[i])));
                END;
           END;
    IF pil THEN x:=x+a*REAL(j);
           END;
    IF (imp) AND (j>=LONGCARD(o1)) AND (j<=LONGCARD(o2)) THEN x:=x+1.0;
                                                         END;
    mo:=mo+x;
    IF min>x THEN min:=x;END;
    IF x>max THEN max:=x;END;
    FIO.WrBin(f,x,4);
    END;
 mo:=mo/REAL(long);
(* 4 Запись в этикетку *)
 FIO.Seek(f,22);
 FIO.WrBin(f,freq,4);    (* частота дискретизации *)
 FIO.WrBin(f,long,4);    (* длина реализации  *)
 FIO.Seek(f,32);
 FIO.WrBin(f,commence,2);(* начало данных     *)
 FIO.WrBin(f,'S',1);
 FIO.WrBin(f,'W',1);
 FIO.WrBin(f,min,4);
 FIO.WrBin(f,max,4);
 FIO.WrBin(f,mo,4);
 n:=0;
 FIO.WrBin(f,n,2);
 FIO.Close(f);
END givedat.