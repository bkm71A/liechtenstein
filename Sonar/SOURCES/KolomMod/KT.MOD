MODULE KT ;

FROM Window  IMPORT Open,WinType,WinDef,Color,DoubleFrame,GotoXY,Close,
                   TextColor,TextBackground,PutOnTop,SetTitle,
                   Clear,CenterUpperTitle,Hide,Change,SingleFrame ;
FROM _Window IMPORT Shadow,Close_Sh,Open_Sh ;
FROM IO      IMPORT RdCharDirect,WrStr,WrShtCard,WrCard,WrChar,KeyPressed ;
             IMPORT Str ;
             IMPORT IO ;
             IMPORT Lib ;
             IMPORT FIO ;
             IMPORT SYSTEM ;

VAR DD,YY,BB,VV,TT        : WinDef ;
    Ddd,Yyy,Bbb,Vvv,Ttt   : WinType ;
    b                     : CARDINAL ; (* тени окошек *)
    ot                    : CHAR ;
    i,j                   : CARDINAL ;
    flag                  : CHAR ;
    ok                    : BOOLEAN ;
    xmin,ymin             : REAL ;
    xminstr,yminstr       : ARRAY[0..9] OF CHAR ;
    xmax,ymax             : REAL ;
    xmaxstr,ymaxstr       : ARRAY[0..9] OF CHAR ;
    razmer                : ARRAY[0..9] OF CHAR ;
    nacp                  : SHORTCARD ;
    nacpstr               : ARRAY[0..1] OF CHAR ;
    vmin,vmax             : REAL ;
    vminstr,vmaxstr       : ARRAY[0..9] OF CHAR ;
    tip_dat               : ARRAY[0..7] OF CHAR ;
    nkol                  : SHORTCARD ;
    nkolstr               : ARRAY[0..1] OF CHAR ;
    xx                    : ARRAY[1..32] OF REAL ;
    yy                    : ARRAY[1..32] OF REAL ;

LABEL           con,con1,M1,M2,M3,M4,M5,M6,M7,M11 ;

PROCEDURE edit_line(VAR line : ARRAY OF CHAR ; VAR flag : CHAR ) ;
(* редактор одной строки *)
VAR   rez    : CARDINAL ;
      x      : CARDINAL ;
      p      : BOOLEAN  ;
BEGIN
p:=FALSE ;
x:=1 ;
IF Str.Match(line[0],' ') THEN
      Str.Slice(line,line,1,80) ;
END ; (* IF *)
LOOP
   GotoXY(1,1) ;
   WrStr(line) ;
   GotoXY(x,1) ;
   ot:=RdCharDirect() ;
   CASE ot OF  |  (CHAR(0DH)) : (* Enter *)
                                flag:=ot ;
                                EXIT ;
               |  (CHAR(27))  : (* Esc *)
                                flag:=ot ;
                                EXIT ;
               |  (CHAR(08H)) : (* Backspace *)
                     IF x>1 THEN
                           p:=TRUE ;
                           Clear ;
                           Str.Delete(line,x-2,1) ;
                           x:=x-1 ;
                     END ; (* IF *)
               | (CHAR(00))   : ot:=RdCharDirect() ;
                     CASE ot OF CHAR(83) : (* Del *)
                                p:=TRUE ;
                                Clear ;
                                Str.Delete(line,x-1,1) ;
                              | (CHAR(75))  : (* влево *)
                                flag:=ot ;
                                EXIT ;
                             (*   IF x>1 THEN
                                      x:=x-1 ;
                                END ; (* IF *)
                              *)
                              | (CHAR(77))  : (* вправо*)
                                flag:=ot ;
                                EXIT ;
                             (*   IF x<=Str.Length(line) THEN
                                      x:=x+1 ;
                                END ; (* IF *)
                              *)
                            (*  | (CHAR(79))  : (* End *)
                                x:=Str.Length(line)+1 ;*)
                            (*  | (CHAR(71))  : (* Home *)
                                x:=1 ;*)
                              | (CHAR(72))  : (* Вверх *)
                                flag:=ot ;
                                EXIT ;
                              | (CHAR(80))  : (* Вниз  *)
                                flag:=ot ;
                                EXIT ;
                     END ; (* CASE *)
         ELSE (* CASE *)
            IF p=FALSE THEN
                  Str.Copy(line,'') ;
                  Clear ;
                  p:=TRUE ;
                  Str.Insert(line,ot,x-1) ;
                  x:=x+1 ;
               ELSE
                  Str.Insert(line,ot,x-1) ;
                  x:=x+1 ;
             END ; (* IF *)
      END ; (* case *)
END ; (* LOOP *)

END edit_line ;

PROCEDURE beep ;
(* бипкает при ошибке *)
BEGIN
Lib.Sound(300) ;
Lib.Delay(100) ;
Lib.NoSound() ;
END beep ;

PROCEDURE error(nomer : CARDINAL) ;

VAR WW       : WinDef ;
    Www      : WinType ;
    x        : CARDINAL ;
    stroka   : ARRAY [0..30] OF CHAR ;
BEGIN
WW:=WinDef(20,9,60,14,White,Red,FALSE,FALSE,FALSE,TRUE,SingleFrame,Yellow,Red) ;
Www:=Open(WW) ;
SetTitle(Www,' О Ш И Б К А  ! ',CenterUpperTitle);
(* анализ номера ошибки *)
CASE nomer OF | 1 :(* не целое число *)
                  stroka:='Нет свободного места на диске' ;
                  x:=6 ;
              | 2 :(* не целое число *)
                  stroka:='Файл с таким именем существует' ;
                  x:=6 ;
              | 3 :(* не правильно введены X *)
                  stroka:='Не правильно введены значения X' ;
                  x:=5 ;
END ; (* CASE *)
GotoXY(x,2) ;
WrStr(stroka) ;
GotoXY(2,4) ;
IF nomer=2 THEN
      TextColor(White) ;
      WrStr(' [Esc]           [Enter]');
      TextColor(LightGray) ;
      GotoXY(9,4) ;
      WrStr('Выход') ;
      GotoXY(27,4) ;
      WrStr('Продолжение');

   ELSE
      TextBackground(LightRed) ;
      TextColor(LightGray) ;
      WrStr('для продолжения нажмите любую клавишу');
END ; (* IF *)
beep ;
ot:=RdCharDirect() ;
Close(Www) ;
END error;


PROCEDURE proces() ;
(* расчет таблицы тарировок *)
VAR
     AA,BB          : WinDef ;
     Aaa,Bbb        : WinType ;
     a              : CARDINAL ;
     buf            : ARRAY[0..4095+FIO.BufferOverhead] OF BYTE ;
     ff             : FIO.File ;
     file           : ARRAY[0..65] OF CHAR ;
     min            : REAL ;
     max            : REAL ;
     MO             : REAL ;
     kol            : LONGCARD ;   (* количество точек таблицы тарировок *)
     delta          : REAL ;       (*  шаг для x                         *)
     x              : REAL ;       (* значения для напряжения на АЦП     *)
     y              : REAL ;       (* значение на датчике                *)
     razmer1        : LONGCARD ;   (* размер создаваемого файла          *)
     r              : SYSTEM.Registers ;
     i              : LONGCARD ;
     y1             : LONGREAL ;
     raz            : ARRAY[0..15] OF CHAR ;
     stroka         : ARRAY[0..65] OF CHAR ;
     stroka1        : ARRAY[0..65] OF CHAR ;
     kol1           : CARDINAL ;
LABEL                vixod,write,vixod1 ;
BEGIN
PutOnTop(Yyy) ;
Clear ;
AA:=WinDef(20,7,60,9,LightMagenta,Blue,FALSE,FALSE,FALSE,TRUE,SingleFrame,White,Blue) ;
BB:=WinDef(8,21,71,21,Cyan,LightGray,FALSE,FALSE,FALSE,FALSE,SingleFrame,Blue,Blue) ;
   Str.Copy(stroka,'░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░') ;
   FIO.IOcheck:=FALSE ;
   min:= MAX(REAL) ;
   max:= MIN(REAL) ;
   (* вычисление числа точек таблицы тарировок *)
   kol:=2 ;
   FOR i:=1 TO LONGCARD(nacp-1) DO
      kol:=kol*2
   END ; (* FOR *)
   (* формирование имени файла *)
   Str.Concat(file,'d:\data\',tip_dat) ;
   Str.Append(file,'.tar') ;

   (* контролируем наличие свободного места на диске *)
   r.AH:=36H ;
   r.DL:=4 ;
   Lib.Dos(r) ;
   razmer1:=4*LONGCARD(kol)+100 ;
   IF razmer1<(LONGCARD(r.BX)*LONGCARD(r.AX)*LONGCARD(r.CX)) THEN
         (* места на диске достаточно *)
      ELSE
         error(1) ;
         ot:=RdCharDirect() ;
         GOTO vixod ;
   END ; (* IF *)

   (* открываем файл для записи *)
   ff:=FIO.Open(file) ;
   (* контроль на наличие такого файла *)
   j:=FIO.IOresult () ;
   IF j=0 THEN
         error(2) ;
         IF ot=CHAR(27) THEN GOTO vixod1 ; END ; (* IF *)
         FIO.Close(ff) ;
   END ; (* IF *)
   ff:=FIO.Create(file) ;
   FIO.AssignBuffer(ff,buf) ;
   Aaa:=Open(AA) ;
   GotoXY(12,1) ;
   WrStr('Выполняются расчеты') ;
   a:=Open_Sh(Aaa) ;
   Bbb:=Open(BB) ;
   WrStr(stroka) ;
   TextColor(LightRed) ;
   TextBackground(Red) ;
   (* запись пустой этикетки *)
   FOR i:=0 TO 104 DO
      FIO.WrBin(ff,CHAR(00),1) ;
   END ; (* FOR *)

   (* вычисляем шаг для x *)
   delta:=(vmax-vmin)/REAL(kol-1) ;
   (* расчет и запись таблицы тарировок *)
   x:=vmin ;
   MO:=0. ;

   FOR i:=1 TO kol DO
      FOR j:=2 TO CARDINAL(nkol) DO
         IF x <= xx[j] THEN
               GOTO write ;
         END ; (* IF *)
      END ; (* FOR *)
         j:=CARDINAL(nkol) ;
write:            kol1:=CARDINAL(i * 65 DIV kol ) ;
                  Str.Slice(stroka1,stroka,0,kol1) ;
                  GotoXY(0,1) ;
                  WrStr(stroka1) ;
      (* запись значений для тарировки в файл *)
    (*  y1:=LONGREAL(ymin*(x-xmax)-ymax*(x-xmin))/LONGREAL((xmin-xmax)) ;*)
    (*  y:=(ymin* (x-xmax)- ymax* (x-xmin))   /(xmin-xmax) ;*)
      y:=(yy[j-1]*(x-xx[j])-yy[j]*(x-xx[j-1]))/(xx[j-1]-xx[j]) ;
      FIO.WrBin(ff,y,4) ;
      MO:=MO+y ;
      IF y>max THEN
            max:=y ;
      END ; (* IF *)
      IF y<min THEN
            min:=y
      END ; (* IF *)
      x:=x+delta ;
   END ; (* FOR *)

   MO:=MO/REAL(kol) ;
   (* запись этикетки *)
   FIO.Seek(ff,0) ;
   j:=34 ;
   FIO.WrBin(ff,j,2) ;
   FIO.WrBin(ff,'00/00/00',8) ;
   FIO.WrBin(ff,'тар.',4) ;
   FIO.Seek(ff,26) ;
   FIO.WrBin(ff,kol,4) ;
   FIO.Seek(ff,32) ;
   j:=105 ;
   FIO.WrBin(ff,j,2) ;
   FIO.WrBin(ff,'SW',2) ;
   FIO.WrBin(ff,min,4) ;
   FIO.WrBin(ff,max,4) ;
   FIO.WrBin(ff,MO,4) ;
   FIO.Seek(ff,80) ;
   (* исправить размерность *)
   FOR i:=0 TO 15 DO
      raz[CARDINAL(i)] := CHR(0) ;
   END ;
   Str.Concat(raz,CHR(13),razmer) ;
   FIO.WrBin(ff,raz,16) ;
   FIO.WrBin(ff,nacp,1) ;
   FIO.WrBin(ff,vmin,4) ;
   FIO.WrBin(ff,vmax,4) ;

   FIO.Close(ff) ;
   Close(Bbb) ;
vixod:
Close_Sh(a) ;
Close(Aaa) ;
vixod1:
END proces ;



PROCEDURE vvod(nkol : SHORTCARD) ;
(* ввод X и Y *)

VAR EE,KK            : WinDef ;
    Eee,Kkk          : WinType ;
    e                : CARDINAL ;
    i,n,j            : CARDINAL ;
    x,y              : CARDINAL ;
    x1               : CARDINAL ;
    xxstr,yystr      : ARRAY[0..9] OF CHAR ;

LABEL             M10 ;

BEGIN

   n:=CARDINAL(nkol) ;
(* окно для ввода X и Y *)
   EE:=WinDef(4,2,75,21,White,Blue,FALSE,TRUE,FALSE,TRUE,SingleFrame,Yellow,Blue) ;
   Eee:=Open(EE) ;
   e:=Open_Sh(Eee) ;
   PutOnTop(Eee) ;
FOR i:=1 TO 33 DO
    xx[i]:=0.0 ;
    yy[i]:=0.0 ;
END ; (* IF *)

GotoXY(10,1) ;
WrStr('X') ;
GotoXY(25,1) ;
WrStr('Y') ;
GotoXY(45,1) ;
WrStr('X') ;
GotoXY(60,1) ;
WrStr('Y') ;


GotoXY(1,2) ;
WrStr('───────────────────────────────────────────────────────────────────') ;

FOR i:=1 TO n DO
   IF i>16 THEN
         y:=i-16 ;
         x:=37 ;
      ELSE
         y:=i ;
         x:=1 ;
   END ; (* IF *)
   GotoXY(x,y+2) ; WrCard(i,2) ;
END ; (* FOR *)
TextColor(LightMagenta) ;

M10 :
   PutOnTop(Yyy) ;
   Clear() ;
   GotoXY(18,1) ;
   WrStr('Введите значения для расчета таблицы тарировок') ;
   PutOnTop(Eee) ;
i:=1 ; j:=1 ;
LOOP
   IF i>16 THEN
         y:=i-14 ;
         x:=1+40 ;
         x1:=40+8 ;
      ELSE
         y:=i+2 ;
         x:=1+4 ;
         x1:=20+8
   END ; (* IF *)

KK:=WinDef(0,0,0,0,Black,LightGray,TRUE,FALSE,FALSE,FALSE,DoubleFrame,White,Blue) ;
IF j=1 THEN
      KK.X1:=x+5  ;KK.Y1:=y+2 ;
      KK.X2:=x+13 ; KK.Y2:=y+2 ;
      Kkk:=Open(KK) ;
      IF xx[i]=0. THEN
            xxstr:='' ;
         ELSE
            Str.RealToStr(LONGREAL(xx[i]),4,TRUE,xxstr,ok) ;
      END ; (* IF *)
      edit_line(xxstr,flag) ;
      xx[i]:=REAL(Str.StrToReal(xxstr,ok)) ;
      Close(Kkk) ;
   ELSE
      KK.X1:=x+20 ; KK.Y1:=y+2 ;
      KK.X2:=x+28 ; KK.Y2:=y+2 ;
      Kkk:=Open(KK) ;
      IF yy[i]=0.0 THEN
            yystr:='' ;
         ELSE
            Str.RealToStr(LONGREAL(yy[i]),4,TRUE,yystr,ok) ;
      END ; (* IF *)
      edit_line(yystr,flag) ;
      yy[i]:=REAL(Str.StrToReal(yystr,ok)) ;
      Close(Kkk) ;
END ; (* IF *)
   IF ok=TRUE THEN
         IF j=1 THEN
               GotoXY(x,y) ;
               IO.WrReal(xx[i],4,9) ;
            ELSE
               GotoXY(x+15,y) ;
               IO.WrReal(yy[i],4,9) ;
         END ; (* IF *)
         IF flag=CHAR(27) THEN  EXIT ;END ; (* IF *)
         IF flag=CHAR(72) THEN
               IF i>1 THEN
                      i:=i-1 ;
               END ;
         END ;
         IF flag=CHAR(80) THEN
               IF i<n THEN
                     i:=i+1 ;
               END ;
         END ;
         IF flag=CHAR(0DH) THEN
               IF i<n THEN
                     IF j=1 THEN
                           j:=2 ;
                        ELSE
                           i:=i+1 ;
                           j:=1 ;
                     END ; (* IF *)
                  ELSE
                     IF j=2 THEN
                           EXIT ;
                        ELSE
                           j:=2 ;
                     END ; (* IF *)
               END ;
         END ;
         IF flag=CHAR(75) THEN
               IF j=2 THEN
                     j:=1 ;
                  ELSE
                     IF i>16 THEN i:=i-16 ;j:=2 ; END ; (* IF *)
               END ; (* IF *)
         END ; (* IF *)
         IF flag=CHAR(77) THEN
               IF j=1 THEN
                     j:=2
                  ELSE
                     IF i+16<=n THEN
                           j:=1 ;
                           i:=i+16 ;
                     END ; (* IF *)
               END ; (* IF *)
         END ; (* IF *)
      ELSE
         beep ;
   END ; (* IF *)
END ; (* LOOP *)
IF flag<>CHAR(27) THEN
   PutOnTop(Yyy) ;
   Clear ;
   GotoXY(5,1) ; WrStr('[Enter]') ; TextColor(Black) ;
   WrStr(' Расчет таблицы тарировок') ;
   GotoXY(40,1) ; TextColor(White) ; WrStr('[SpaceBar]') ;
   TextColor(Black) ; WrStr(' Коррекция') ;
   GotoXY(63,1) ; TextColor(White) ; WrStr('[Esc]') ;
   TextColor(Black) ; WrStr(' Выход') ;
   TextColor(White) ;
   PutOnTop(Eee) ;
(* контроль на одинаковые x *)
   FOR i:=1 TO n DO
      FOR j:=i+1 TO n DO
         IF xx[i]=xx[j] THEN error(3) ; GOTO M10 ; END ; (* IF *)
      END ; (* FOR *)
   END ; (* FOR *)
(* контроль на упорядочение X *)
   FOR i:=1 TO n-1 DO
      IF xx[i]>xx[i+1] THEN error(3) ; GOTO M10 ; END ; (* IF *)
   END ; (* FOR *)
   LOOP
      ot:=RdCharDirect() ;
      CASE ot OF | (CHAR(32))  : (* SpaceBar *)
                                 GOTO M10 ;
                 | (CHAR(27))  : (* Esc *)
                                 flag:=CHAR(27) ;
                                 EXIT ;
                 | (CHAR(0DH)) : (* Enter *)
                                 EXIT ;
      END ; (* CASE *)

   END ; (* LOOP *)
END ; (* IF *)
   Close_Sh(e) ;
   Close(Eee) ;
END vvod ;

BEGIN
(* задание начальных значений *)
xmin :=0.0 ;
xmax :=0.0 ;
ymin :=0.0 ;
ymax :=0.0 ;
vmin :=0.0 ;
vmax :=0.0 ;
nacp :=12 ;
nkol :=3 ;
Str.Copy(razmer,'') ;
Str.Copy(tip_dat,'') ;
(* окно для титра *)
   TT:=WinDef(26,0,54,0,Yellow,Black,FALSE,FALSE,FALSE,FALSE,SingleFrame,White,Blue) ;
(* окно для ввода значений  *)
   VV:=WinDef(59,8,60,8,Black,Green,TRUE,FALSE,FALSE,FALSE,SingleFrame,White,Blue) ;
(* окно для ввода параметров *)
   BB:=WinDef(4,3,75,15,White,Blue,FALSE,TRUE,FALSE,TRUE,SingleFrame,Yellow,Blue) ;
(* заполнение экрана псевдографикой *)
   DD:=WinDef(0,0,79,24,White,Black,FALSE,TRUE,TRUE,TRUE,SingleFrame,Green,Black) ;

   Ddd:=Open(DD) ;
   FOR i:=0 TO 22 DO
      FOR j:=0 TO 77 DO
         WrChar('░') ;
      END ; (* FOR *)
   END ; (* FOR *)
(*   SetTitle(Ddd,' Расчет нелинейных тарировок ',CenterUpperTitle) ;*)
   PutOnTop(Ddd) ;
   Ttt:=Open(TT) ;
   WrStr(' Расчет нелинейных тарировок') ;
   (*****      Окно подсказки      *****)
YY:=WinDef(1,23,78,23,White,Brown,FALSE,FALSE,FALSE,FALSE,' ',White,Blue) ;
Yyy:=Open(YY) ;

   Bbb:=Open(BB) ;
   b:=Open_Sh(Bbb) ;
   PutOnTop(Bbb) ;
   GotoXY(25,2) ;
   WrStr('Разрядность АЦП') ;
   GotoXY(2,4) ;
   WrStr('Диапазон изменения входного сигнала ( В )           -') ;
   GotoXY(27,6) ;
   WrStr('Тип датчика') ;
   GotoXY(18,8) ;
   WrStr('Размерность физической величины') ;
   GotoXY(18,10) ;
   WrStr('Количество точек апроксимации') ;

M1:
   PutOnTop(Yyy) ;
   Clear ;
   GotoXY(25,1) ; WrStr('Введите указанные параметры') ;
M2:
   VV.X1:=45 ; VV.X2:=46 ;
   VV.Y1:=5 ; VV.Y2:=5 ;
   Vvv:=Open(VV) ;
   Str.IntToStr(LONGINT(nacp),nacpstr,10,ok) ;
   edit_line(nacpstr,flag) ;
   Close(Vvv) ;
   IF flag=CHAR(27) THEN GOTO con ; END ; (* IF *)
   IF flag=CHAR(27) THEN GOTO con ; END ; (* IF *)
   nacp:=SHORTCARD(Str.StrToInt(nacpstr,10,ok)) ;
   IF (ok=FALSE) OR (nacp<6) OR (nacp>12) THEN beep ; GOTO M2 ; END ; (* IF *)
   PutOnTop(Bbb) ;
   GotoXY(VV.X1-4,VV.Y1-3) ;
   TextColor(LightMagenta) ;
   IO.WrShtCard(nacp,2) ;
   IF (flag=CHAR(72)) OR (flag=CHAR(75)) THEN GOTO M11 ; END ; (* IF *)
   IF (flag=CHAR(77)) OR (flag=CHAR(80)) THEN GOTO M3 ; END ; (* IF *)

M3:
   VV.X1:=48 ; VV.X2:=56 ;
   VV.Y1:=7 ; VV.Y2:=7 ;
   Vvv:=Open(VV) ;
   IF vmin=0. THEN
         vminstr:='' ;
      ELSE
         Str.RealToStr(LONGREAL(vmin),4,TRUE,vminstr,ok) ;
   END ; (* IF *)
   edit_line(vminstr,flag) ;
   Close(Vvv) ;
   IF flag=CHAR(27) THEN GOTO con ; END ; (* IF *)
   vmin:=REAL(Str.StrToReal(vminstr,ok)) ;
   IF ok=FALSE THEN beep ; GOTO M3 ; END ; (* IF *)
   PutOnTop(Bbb) ;
   GotoXY(VV.X1-5,VV.Y1-3) ;
   TextColor(LightMagenta) ;
   IO.WrReal(vmin,4,9) ;
   IF (flag=CHAR(72)) OR (flag=CHAR(75)) THEN GOTO M2 ; END ; (* IF *)
   IF (flag=CHAR(77)) OR (flag=CHAR(80)) THEN GOTO M4 ; END ; (* IF *)

M4:
   VV.X1:=60 ; VV.X2:=68 ;
   VV.Y1:=7 ; VV.Y2:=7 ;
   Vvv:=Open(VV) ;
   IF vmax=0. THEN
         vmaxstr:='' ;
      ELSE
         Str.RealToStr(LONGREAL(vmax),4,TRUE,vmaxstr,ok) ;
   END ; (* IF *)
   edit_line(vmaxstr,flag) ;
   Close(Vvv) ;
   IF flag=CHAR(27) THEN GOTO con ; END ; (* IF *)
   vmax:=REAL(Str.StrToReal(vmaxstr,ok)) ;
   IF ok=FALSE THEN beep ; GOTO M4 ; END ; (* IF *)
   PutOnTop(Bbb) ;
   GotoXY(VV.X1-5,VV.Y1-3) ;
   TextColor(LightMagenta) ;
   IO.WrReal(vmax,4,9) ;
   IF (flag=CHAR(72)) OR (flag=CHAR(75)) THEN GOTO M3 ; END ; (* IF *)
   IF (flag=CHAR(77)) OR (flag=CHAR(80)) THEN GOTO M5 ; END ; (* IF *)

M5:
   VV.X1:=44 ; VV.X2:=51 ;
   VV.Y1:=9  ; VV.Y2:=9  ;
   Vvv:=Open(VV) ;
   edit_line(tip_dat,flag) ;
   Close(Vvv) ;
   IF flag=CHAR(27) THEN GOTO con ; END ; (* IF *)
   PutOnTop(Bbb) ;
   GotoXY(VV.X1-4,VV.Y1-3) ;
   TextColor(LightMagenta) ;
   WrStr(tip_dat) ;
   IF (flag=CHAR(72)) OR (flag=CHAR(75)) THEN GOTO M4 ; END ; (* IF *)
   IF (flag=CHAR(77)) OR (flag=CHAR(80)) THEN GOTO M6 ; END ; (* IF *)

M6:
   VV.X1:=55 ; VV.X2:=63 ;
   VV.Y1:=11  ; VV.Y2:=11  ;
   Vvv:=Open(VV) ;
   edit_line(razmer,flag) ;
   Close(Vvv) ;
   IF flag=CHAR(27) THEN GOTO con ; END ; (* IF *)
   PutOnTop(Bbb) ;
   GotoXY(VV.X1-4,VV.Y1-3) ;
   TextColor(LightMagenta) ;
   WrStr(razmer) ;
   IF (flag=CHAR(72)) OR (flag=CHAR(75)) THEN GOTO M5 ; END ; (* IF *)
   IF (flag=CHAR(77)) OR (flag=CHAR(80)) THEN GOTO M7 ; END ; (* IF *)

M7:
   VV.X1:=52 ; VV.X2:=53 ;
   VV.Y1:=13 ; VV.Y2:=13 ;
   Vvv:=Open(VV) ;
   Str.IntToStr(LONGINT(nkol),nkolstr,10,ok) ;
   edit_line(nkolstr,flag) ;
   Close(Vvv) ;
   IF flag=CHAR(27) THEN GOTO con ; END ; (* IF *)
   IF flag=CHAR(27) THEN GOTO con ; END ; (* IF *)
   nkol:=SHORTCARD(Str.StrToInt(nkolstr,10,ok)) ;
   IF (ok=FALSE) OR (nkol<3) OR (nkol>32) THEN beep ; GOTO M7 ; END ; (* IF *)
   PutOnTop(Bbb) ;
   GotoXY(VV.X1-4,VV.Y1-3) ;
   TextColor(LightMagenta) ;
   IO.WrShtCard(nkol,2) ;
   IF (flag=CHAR(72)) OR (flag=CHAR(75)) THEN GOTO M6 ; END ; (* IF *)
   IF (flag=CHAR(77)) OR (flag=CHAR(80)) THEN GOTO M11 ; END ; (* IF *)
M11:
   IF vmax>vmin THEN ELSE beep ; GOTO M3 ; END ; (* IF *)
   IF Str.Length(tip_dat)=0 THEN beep ; GOTO M5 ; END ; (* IF *)



   PutOnTop(Yyy) ;
   Clear ;
   GotoXY(4,1) ; WrStr('[Enter]') ; TextColor(Black) ;
   WrStr(' Ввод тарировочных значений') ;
   GotoXY(41,1) ; TextColor(White) ; WrStr('[SpaceBar]') ;
   TextColor(Black) ; WrStr(' Коррекция') ;
   GotoXY(65,1) ; TextColor(White) ; WrStr('[Esc]') ;
   TextColor(Black) ; WrStr(' Выход') ;
   TextColor(White) ;
   LOOP
      ot:=RdCharDirect() ;
      CASE ot OF | (CHAR(32))  :  (* SpaceBar *)
                                 GOTO M1 ;
                 | (CHAR(27))  : (* Esc *)
                                 Close_Sh(b) ;
                                 Close(Bbb) ;
                                 EXIT ;
                 | (CHAR(0DH)) : (* Enter *)
                                 Close_Sh(b) ;
                                 Close(Bbb) ;
                                 vvod(nkol) ;
                                 IF flag<>CHAR(27) THEN
                                    proces () ;
                                 END ; (* IF *)
                                 EXIT ;
      END ; (* CASE *)

   END ; (* LOOP *)
GOTO con1 ;

con :
   Close_Sh(b) ;
   Close(Bbb) ;

con1 :

   Close(Yyy) ;
   Close(Ttt) ;
   Close(Ddd) ;

END KT.