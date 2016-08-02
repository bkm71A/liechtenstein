MODULE ras_tar ;

FROM Window  IMPORT Open,WinType,WinDef,Color,DoubleFrame,GotoXY,Close,
                   TextColor,TextBackground,PutOnTop,SetTitle,
                   Clear,CenterUpperTitle,Hide,Change,SingleFrame ;
FROM _Window IMPORT Shadow,Close_Sh,Open_Sh ;
FROM IO      IMPORT RdCharDirect,WrStr,WrShtCard,WrCard,WrChar,KeyPressed ;
             IMPORT Str ;
             IMPORT IO ;
             IMPORT Lib ;
VAR DD,YY,BB,VV    : WinDef ;
    Ddd,Yyy,
    Bbb,Vvv           : WinType ;
    a,b               : CARDINAL ; (* тени окошек *)
    ot                : CHAR ;
    i,j               : CARDINAL ;
    h,n               : INTEGER ;
    hstr,nstr         : ARRAY [0..1] OF CHAR ;
    flag              : CHAR ;
    ok                : BOOLEAN ;
LABEL           M1,M2,M3 ;

PROCEDURE edit_line(VAR line : ARRAY OF CHAR ; VAR flag : CHAR ) ;
(* редактор одной строки *)
VAR   rez    : CARDINAL ;
      x      : CARDINAL ;
BEGIN
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
                           Clear ;
                           Str.Delete(line,x-2,1) ;
                           x:=x-1 ;
                     END ; (* IF *)
               | (CHAR(00))   : ot:=RdCharDirect() ;
                     CASE ot OF CHAR(83) : (* Del *)
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
                              | (CHAR(79))  : (* End *)
                                x:=Str.Length(line)+1 ;
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
            Str.Insert(line,ot,x-1) ;
            x:=x+1 ;
      END ; (* case *)
END ; (* LOOP *)

END edit_line ;

PROCEDURE beep ;
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
WW:=WinDef(20,9,60,14,White,Red,FALSE,FALSE,FALSE,TRUE,SingleFrame,White,Red) ;
(* сообщение об ошибке *)
(* Lib.Sound(400) ;*)
Www:=Open(WW) ;
SetTitle(Www,' О Ш И Б К А  ! ',CenterUpperTitle);
(* анализ номера ошибки *)
CASE nomer OF | 1 :(* не целое число *)
                  stroka:='Значения аргументов совподают' ;
                  x:=6 ;
END ; (* CASE *)
GotoXY(x,2) ;
WrStr(stroka) ;
GotoXY(2,4) ;
TextColor(Yellow) ;
TextBackground(LightRed) ;
TextColor(LightGray) ;
WrStr('для продолжения нажмите любую клавишу');
(* Lib.NoSound ;*)
beep ;
ot:=RdCharDirect() ;
Close(Www) ;
END error;


PROCEDURE uzel ;
(* Введение узлов интерполяции *)

VAR AA,BB,CC          : WinDef ;
    Aaa,Bbb,Ccc       : WinType ;
    x,y,x1            : CARDINAL ;
    xx                : ARRAY[1..80] OF CARDINAL ;
    yy                : ARRAY[1..80] OF REAL ;
    xxstr             : ARRAY[0..3] OF CHAR ;
    yystr             : ARRAY[0..9] OF CHAR ;
    i                 : INTEGER ;

LABEL       M1 ;
BEGIN
AA:=WinDef(3,1,76,21,White,Blue,FALSE,TRUE,FALSE,TRUE,SingleFrame,Yellow,Blue) ;
Aaa:=Open(AA) ;
a:=Open_Sh(Aaa) ;
SetTitle(Aaa,' Введение узлов интерполяции ',CenterUpperTitle) ;
PutOnTop(Yyy) ;
Clear ;
GotoXY(25,1) ; WrStr('Введите значения для узлов') ;
PutOnTop(Aaa) ;

(*
GotoXY(1,2) ;
WrStr('──────────────────────────────────────────────────────────────────────────') ;
GotoXY(8,1) ;
WrStr('Количество узлов апроксимации ') ; WrStr(hstr) ;
GotoXY(48,1) ;
WrStr('Степень полинома ') ; WrStr(nstr) ;
*)
FOR i:=1 TO h DO
    xx[i]:=0 ;
    yy[i]:=0.0 ;
END ; (* IF *)
FOR i:=1 TO h DO
   IF i>19 THEN
         IF i>38 THEN
               IF i>57 THEN
                     x:=55 ;
                     y:=i-57 ;
                  ELSE
                     x:=37 ;
                     y:=i-38 ;
               END ; (* IF *)
            ELSE
               x:=19 ;
               y:=i-19 ;
         END ; (* IF *)
      ELSE
         y:=i ;
         x:=1 ;
   END ; (* IF *)
   GotoXY(x,y) ; WrCard(i,2) ;
END ; (* FOR *)
TextColor(LightMagenta) ;
M1 :
i:=1 ; j:=1 ;
LOOP
   IF i>19 THEN
         IF i>38 THEN
               IF i>57 THEN
                     x:=55+3 ;
                     x1:=55+8 ;
                     y:=i-57 ;
                  ELSE
                     x:=37+3 ;
                     x1:=37+8 ;
                     y:=i-38 ;
               END ; (* IF *)
            ELSE
               x:=19+3 ;
               x1:=19+8 ;
               y:=i-19 ;
         END ; (* IF *)
      ELSE
         y:=i ;
         x:=1+3 ;
         x1:=19+8
   END ; (* IF *)

BB:=WinDef(0,0,0,0,Black,LightGray,TRUE,FALSE,FALSE,FALSE,DoubleFrame,White,Blue) ;
IF j=1 THEN
      BB.X1:=x+3  ;BB.Y1:=y+1 ;
      BB.X2:=x+6 ; BB.Y2:=y+1 ;
      Bbb:=Open(BB) ;
      IF xx[i]=0 THEN
            xxstr:='' ;
         ELSE
            Str.IntToStr(LONGINT(xx[i]),xxstr,10,ok) ;
      END ; (* IF *)
      edit_line(xxstr,flag) ;
      xx[i]:=INTEGER(Str.StrToInt(xxstr,10,ok)) ;
      Close(Bbb) ;
   ELSE
      BB.X1:=x+8  ;BB.Y1:=y+1 ;
      BB.X2:=x+16 ; BB.Y2:=y+1 ;
      Bbb:=Open(BB) ;
      IF yy[i]=0.0 THEN
            yystr:='' ;
         ELSE
            Str.RealToStr(LONGREAL(yy[i]),4,TRUE,yystr,ok) ;
      END ; (* IF *)
      edit_line(yystr,flag) ;
      yy[i]:=REAL(Str.StrToReal(yystr,ok)) ;
      Close(Bbb) ;
END ;
   IF ok=TRUE THEN
         IF j=1 THEN
               GotoXY(x,y) ;
(*               WrStr('    ') ;
               GotoXY(x,y) ;
               WrStr(xxstr) ;*)
               IO.WrInt(xx[i],4) ;
            ELSE
               GotoXY(x+4,y) ;
(*               WrStr('         ') ;
               GotoXY(x+5,y) ;
               WrStr(yystr) ;*)
               IO.WrReal(yy[i],4,9) ;
         END ; (* IF *)
         IF flag=CHAR(27) THEN  EXIT ;END ; (* IF *)
         IF flag=CHAR(72) THEN
               IF i>1 THEN
                      i:=i-1 ;
               END ;
         END ;
         IF flag=CHAR(80) THEN
               IF i<h THEN
                     i:=i+1 ;
               END ;
         END ;
         IF flag=CHAR(0DH) THEN
               IF i<h THEN
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
                     IF i>19 THEN i:=i-19 ;j:=2 ; END ; (* IF *)
               END ; (* IF *)
         END ; (* IF *)
         IF flag=CHAR(77) THEN
               IF j=1 THEN
                     j:=2
                  ELSE
                     IF i+19<=h THEN
                           j:=1 ;
                           i:=i+19 ;
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
   GotoXY(7,1) ; WrStr('[Enter]') ; TextColor(Black) ;
   WrStr(' Расчет коэффициентов') ;
   GotoXY(37,1) ; TextColor(White) ; WrStr('[SpaceBar]') ;
   TextColor(Black) ; WrStr(' Коррекция') ;
   GotoXY(62,1) ; TextColor(White) ; WrStr('[Esc]') ;
   TextColor(Black) ; WrStr(' Выход') ;
   TextColor(White) ;
   PutOnTop(Aaa) ;
(* контроль на одинаковые x *)
   FOR i:=1 TO h DO
      FOR j:=i+1 TO h DO
         IF xx[i]=xx[j] THEN error(1) ; GOTO M1 ; END ; (* IF *)
      END ; (* FOR *)
   END ; (* FOR *)
   LOOP
      ot:=RdCharDirect() ;
      CASE ot OF | (CHAR(32))  : (* SpaceBar *)
                                 GOTO M1 ;
                 | (CHAR(27))  : (* Esc *)
                                 EXIT ;
                 | (CHAR(0DH)) : (* Enter *)

      END ; (* CASE *)

   END ; (* LOOP *)
END ; (* IF *)
Close_Sh(a) ;
Close(Aaa) ;
END uzel ;

BEGIN
(* заполнение экрана псевдографикой *)
   DD:=WinDef(0,0,79,24,White,Black,FALSE,TRUE,TRUE,TRUE,SingleFrame,Green,Black) ;
   Ddd:=Open(DD) ;
   FOR i:=0 TO 22 DO
      FOR j:=0 TO 77 DO
         WrChar('░') ;
      END ; (* FOR *)
   END ; (* FOR *)
   SetTitle(Ddd,' Расчет тарировок ',CenterUpperTitle) ;
   PutOnTop(Ddd) ;

(*****      Окно подсказки      *****)
YY:=WinDef(1,23,78,23,White,Brown,FALSE,FALSE,FALSE,FALSE,' ',White,Blue) ;
Yyy:=Open(YY) ;
(* ВВедение количества узлов и степени полинома
   -------------------------------------------- *)
   BB:=WinDef(15,6,64,12,White,Blue,FALSE,TRUE,FALSE,TRUE,SingleFrame,Yellow,Blue) ;
   Bbb:=Open(BB) ;
   b:=Open_Sh(Bbb) ;
   PutOnTop(Bbb) ;
   GotoXY(4,2) ;
   WrStr('Количество узлов апроксимации (7-76)') ;
   GotoXY(4,4) ;
   WrStr('Степень полинома (6-10)') ;
M1:nstr:='' ;
   hstr:='' ;
   PutOnTop(Yyy) ;
   Clear ;
   GotoXY(25,1) ; WrStr('Введите указанные параметры') ;
   VV:=WinDef(59,8,60,8,Black,Green,TRUE,FALSE,FALSE,FALSE,SingleFrame,White,Blue) ;
   Vvv:=Open(VV) ;
   edit_line(hstr,flag) ;
   Close(Vvv) ;
(*  если flag=Esc, то на конец программы *)
   h:=INTEGER(Str.StrToInt(hstr,10,ok)) ;
   IF (ok=FALSE) OR (h>76) OR (h<7) THEN beep ; hstr:='' ; GOTO M1 ; END ; (* IF *)

   PutOnTop(Bbb) ;
   TextColor(LightMagenta) ;
   GotoXY(44,2) ;
   WrStr('  ') ;
   GotoXY(44,2) ;
   WrStr(hstr) ;
   IF h<11 THEN
         n:=h-1 ;
         Str.IntToStr(LONGINT(n),nstr,10,ok) ;
         GOTO M3 ;
   END ; (* IF *)

M2:VV:=WinDef(59,10,60,10,Black,Green,TRUE,FALSE,FALSE,FALSE,SingleFrame,White,Blue) ;
   Vvv:=Open(VV) ;
   edit_line(nstr,flag) ;
   n:=INTEGER(Str.StrToInt(nstr,10,ok)) ;
   Close(Vvv) ;
   IF (ok=FALSE) OR (n>10) OR (n<6) THEN beep ; nstr:='' ; GOTO M2 ; END ; (* IF *)
M3:GotoXY(44,4) ;
   TextColor(LightMagenta) ;
   WrStr('  ') ;
   GotoXY(44,4) ;
   WrStr(nstr) ;
   (* возврат для коррекции количества узлов *)
   IF flag=CHAR(72) THEN GOTO M1 ; END ; (* IF *)
   PutOnTop(Yyy) ;
   Clear ;
   GotoXY(7,1) ; WrStr('[Enter]') ; TextColor(Black) ;
   WrStr(' Ввод узлов') ;
   GotoXY(33,1) ; TextColor(White) ; WrStr('[SpaceBar]') ;
   TextColor(Black) ; WrStr(' Коррекция') ;
   GotoXY(62,1) ; TextColor(White) ; WrStr('[Esc]') ;
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
                                 uzel ;
                                 Close_Sh(b) ;
                                 Close(Bbb) ;
                                 EXIT ;
      END ; (* CASE *)

   END ; (* LOOP *)
Close(Yyy) ;
Close(Ddd) ;
END ras_tar.