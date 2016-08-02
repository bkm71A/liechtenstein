MODULE mainproc ;
FROM Window IMPORT Open,TextColor,GotoXY,Close,Clear,CursorOff,SetTitle,Use,
                   WinType,WinDef,DoubleFrame,SingleFrame,Color,CenterUpperTitle,
                   FrameStr,RightUpperTitle,DirectWrite,Hide,TextBackground,
                   SetFrame,Change,Used,WhereY,CenterLowerTitle,PutOnTop ;

FROM IO      IMPORT RdCharDirect,WrStr,WrShtCard,WrCard,WrChar ;
             IMPORT Storage,Lib,SYSTEM ;
             IMPORT IO,Str  ;
             IMPORT TxtImage ;
FROM _Window IMPORT Shadow,Close_Sh,Open_Sh ;
CONST mline =' СИСТЕМА ВВОДА И ПРЕДВАРИТЕЛЬНОЙ ОБРАБОТКИ |'+
    (* главное меню *)
            ' Ввод и сохранение данных |'+
            ' Экспресс обработка |'+
            ' Просмотр и коррекция экспериментальных данных |'+
            ' Предварительная обработка |'+
            ' Возврат в предыдущее меню |'+
    (* меню первого режима *)
            ' Расчет тарировок |'+
            ' Загрузка и сохранение информационных массивов |'+
            ' Выход в главное меню |'+
    (* меню четвертого режима *)
            ' Статистическая обработка сигнала |'+
            ' Цифровая обработка сигнала |'+
            ' Математическая обработка сигнала |'+
            ' Выход в главное меню |'+
    (* меню режима тарировок *)
            ' Расчет линейных тарировок |'+
            ' Расчет нелинейных тарировок |'+
(*            ' Задание таблицы тарировок |'+*)
            ' Выход в главное меню |' ;


 VAR  Aaa,Bbb,Ccc,Ddd,Eee,Ggg,
      Hhh,Fff,Yyy : WinType ;
      AA,BB,CC,DD,EE,GG,HH,FF,YY      : WinDef ;
      a,b,c,d                         : CARDINAL ;
      OT                              : CHAR ;
      i,j,k                           : CARDINAL ;
      t1,t2                           : CARDINAL ;
      kol                             : INTEGER ;
      fon,tex                         : Color ;
      w1                              : ARRAY[1..2],[1..4] OF CARDINAL ;
      (* вывод строки меню *)
      line                            : ARRAY[1..47] OF CHAR ;
      adr          : ADDRESS ;           (* адрес для запуска модулей *)
      kod          : CARDINAL ;          (* код возврата DOS *)
      kod1         : SHORTCARD ;         (* код завершения программы *)
      pri_mamory   : BOOLEAN ; (* признак возможности загрузки программы *)
      m,m1,m2,m4   : CARDINAL ;          (* активный пункт меню *)
PROCEDURE GetReturnCode() : SHORTCARD ;
VAR   r            : SYSTEM.Registers ;
BEGIN ;
   r.AH:=4DH ;
   Lib.Dos(r) ;
   kod1:=r.AL ;
RETURN kod1 ;
END GetReturnCode ;

PROCEDURE WrWin (w:CARDINAL) ;
                (* Процедура заполнения окна выбора режимов *)
BEGIN
   FOR k:=1 TO w1[2,w] DO
      Str.ItemS(line,mline,'|',k+w1[1,w]-1) ;
      GotoXY(3,k) ;
      WrStr(line) ;
   END ; (* FOR *)
END WrWin ;

PROCEDURE MLINE (VAR m : CARDINAL; x1,y1,x2,w:CARDINAL; fon,tex:Color) ;
                (* Процедура выбора режима из меню *)
BEGIN
   i:=m ;
   j:=y1+m-1 ;
   LOOP
      EE.Y1:=j ;  EE.X1:=x1 ;
      EE.Y2:=j ;  EE.X2:=x2+x1 ;
      EE.Foreground:=fon ;
      EE.Background:=tex ;
      Eee:=Open(EE) ;
      GotoXY(2,1) ;
      Str.ItemS(line,mline,'|',i+w1[1,w]-1) ;
      WrStr(line) ;
      OT:=RdCharDirect() ;
      CASE OT OF (CHAR(72)) : DEC(i) ; DEC(j) ;
                              IF i<1 THEN i:=w1[2,w] ;
                                 j:=y1+i-1 ;
                                 END ;
              |  (CHAR(80)) : INC(i) ; INC(j) ;
                              IF i>w1[2,w] THEN i:=1 ;
                                 j:=y1 ;
                              END ;
              | (CHAR(0DH)) : Hide(Eee) ;
                              m:=i ;
                              RETURN ;
              | (CHAR(27))  : Close(Eee) ; EXIT ;
      END ;  (* CASE *)
      Close(Eee) ;
   END ;     (* LOOP *)
END MLINE ;

PROCEDURE FreeMamory ( SizeMamory: CARDINAL ): BOOLEAN ;

VAR SM      :  CARDINAL ; (* размер доступной памяти *)
    t       :  CARDINAL ; (* описатель тени *)
BEGIN
   HH:=WinDef(18,6,62,15,White,Red,FALSE,FALSE,FALSE,TRUE,DoubleFrame,White,Red) ;
   SM:=Storage.HeapAvail(Storage.MainHeap) ;
   IF SM > SizeMamory THEN
         pri_mamory:=TRUE ;
      ELSE
         pri_mamory:=FALSE ;
(*  выдача сообщения об ошибке, если не хватает памяти *)
         Hhh:=Open(HH);
         GotoXY(16,1) ; WrStr("О Ш И Б К А !") ;
         TextColor(Yellow) ;
         GotoXY(8,3) ;  WrStr("Не хватает места для загрузки") ;
         GotoXY(13,4) ; WrStr("оверлейного модуля") ;
         TextColor(LightGray) ;
         TextBackground(LightRed) ;
         GotoXY(8,7) ;  WrStr("Для продолжения работы нажмите") ;
         GotoXY(16,8) ; WrStr("любую клавишу") ;
         t:=Open_Sh(Hhh) ;
         OT:=RdCharDirect() ;
         Close_Sh(t) ;
         Close(Hhh) ;
   END ; (* IF *)
RETURN pri_mamory ;
END FreeMamory ;

PROCEDURE NR() ;      (* Процедура не реализованных режимов *)
VAR  Fff  : WinType ;
     FF   : WinDef ;
BEGIN
                  (*****  Окно для сообщений  *****)
FF:=WinDef(5,21,75,25,Cyan,Red,FALSE,TRUE,FALSE,TRUE,DoubleFrame,Cyan,Red) ;

   Fff:=Open(FF) ;
   GotoXY(5,1) ;
   WrStr('Данный режим предназначен для дальнейшего расширения системы') ;
   GotoXY(13,2) ;
   WrStr('Для продолжения работы нажмите любую клавишу.') ;
   OT:=RdCharDirect() ;
   Close(Fff) ;
END NR ;


BEGIN
      (************** задание цвета экрана ******************)
FF:=WinDef(0,0,79,24,White,Black,FALSE,FALSE,FALSE,FALSE,CHR(0),Blue,LightGray) ;
Fff:=Open(FF);
   FOR i:=0 TO 24 DO
      IO.WrCharRep('░',80) ; GotoXY(1,i+1) ;
   END ; (* FOR *)

(* задание координат для меню *)
w1[1,1]:=1 ; w1[1,2]:=6 ; w1[1,3]:=9 ; w1[1,4]:=13 ;
w1[2,1]:=5 ; w1[2,2]:=3 ; w1[2,3]:=4 ; w1[2,4]:=3 ;

        (******************** главное окно ***********************)
AA:=WinDef(6,6,58,12,LightCyan,Blue,FALSE,TRUE,FALSE,TRUE,DoubleFrame,Yellow,Blue) ;
      (**************   окно для первого режима   ******************)
BB:=WinDef(22,8,74,12,Blue,Cyan,FALSE,TRUE,FALSE,TRUE,DoubleFrame,Yellow,Cyan) ;
      (**************   окно для первого режима   ******************)
CC:=WinDef(22,11,74,16,Blue,Cyan,FALSE,TRUE,FALSE,TRUE,DoubleFrame,Yellow,Cyan) ;
      (**************   окно для режима тарировок  ******************)
DD:=WinDef(34,11,76,15,Blue,LightGray,FALSE,TRUE,FALSE,TRUE,DoubleFrame,Yellow,LightGray) ;
                  (*****      Перемещающееся окно       *****)
EE:=WinDef(10,7,48,7,Brown,Cyan,FALSE,FALSE,FALSE,FALSE,' ',White,Blue) ;
                  (*****      Окно подсказки      *****)
YY:=WinDef(0,24,79,24,White,Brown,FALSE,FALSE,FALSE,FALSE,' ',White,Blue) ;


Yyy:=Open(YY) ;
GotoXY(9,1) ;
WrStr('[^V] ') ;
TextColor(Black) ;
WrStr('Перемещение курсора') ;
GotoXY(38,1) ;
TextColor(White) ;
WrStr('[Enter] ') ;
TextColor(Black) ;
WrStr('Выбор режима') ;
GotoXY(63,1) ;
TextColor(White) ;
WrStr('[Esc] ') ;
TextColor(Black) ;
WrStr('Выход') ;

Aaa:=Open(AA) ;
a:=Open_Sh(Aaa) ;
Str.ItemS(line,mline,'|',0) ;
SetTitle(Aaa,line,CenterUpperTitle) ;
PutOnTop(Aaa) ;
WrWin(1) ;

                          (***** главное меню ****)
GG:=WinDef(24,12,39,12,Yellow,Blue,FALSE,TRUE,FALSE,FALSE,DoubleFrame,Yellow,Blue) ;
Ggg:=Open(GG) ;
IO.WrStr('  главное меню ') ;
m:=1 ;
m1:=1 ;
m2:=1 ;
m4:=1 ;
LOOP
   MLINE(m,8,7,48,1,Brown,Cyan) ;
   IF OT=CHAR(27) THEN
       i:=5 ;
   END (* IF *) ;
   CASE i OF 1 : Bbb:=Open(BB) ;
                 b:=Open_Sh(Bbb) ;
                 Str.ItemS(line,mline,'|',1) ;
                 SetTitle(Bbb,line,CenterUpperTitle) ;
                 PutOnTop(Bbb) ;
                 WrWin(2) ;

                 LOOP
                    MLINE(m1,24,9,48,2,Cyan,Blue) ;
                    IF OT=CHAR(27) THEN
                       i:=3 ;
                    END (* IF *) ;
                    CASE i OF 1 : (* расчет тарировок *)

Ddd:=Open(DD) ;
                 d:=Open_Sh(Ddd) ;
                 Str.ItemS(line,mline,'|',6) ;
                 SetTitle(Ddd,line,CenterUpperTitle) ;
                 PutOnTop(Ddd) ;
                 WrWin(4) ;

                 LOOP
                    MLINE(m4,36,12,38,4,Cyan,Blue) ;
                    IF OT=CHAR(27) THEN
                       i:=3 ;
                    END (* IF *) ;
                    CASE i OF 1 : (* линейная тарировка *)
                                  TxtImage.SaveScreen() ;
                                  pri_mamory:=FreeMamory(15000) ;
                                  IF pri_mamory=TRUE THEN
                                     Storage.HeapAllocate(Storage.MainHeap,adr,15000) ;
                                     kod:=Lib.Execute("lt.ovl"," ",adr,15000 ) ;
                                     Storage.HeapDeallocate(Storage.MainHeap,adr,15000) ;
                                  END ; (* IF *)
                                  TxtImage.RestoreScreen();
                           |  2 : (* нелинейная тарировка *)
                                  TxtImage.SaveScreen() ;
                                  pri_mamory:=FreeMamory(15000) ;
                                  IF pri_mamory=TRUE THEN
                                     Storage.HeapAllocate(Storage.MainHeap,adr,15000) ;
                                     kod:=Lib.Execute("kt.ovl"," ",adr,15000 ) ;
                                     Storage.HeapDeallocate(Storage.MainHeap,adr,15000) ;
                                  END ; (* IF *)
                                  TxtImage.RestoreScreen();
                   (*        |  3 : (* таблица тарировок *)
                                  NR() ;*)
                           |  3 : Close_Sh(d) ;
                                  Close(Ddd) ;
                                  Shadow(Bbb) ;
                                  EXIT ;
                    END ; (* CASE *)
                 END ;
                           |  2 : (* загрузка и сохранение *)
                                  TxtImage.SaveScreen() ;
                                  pri_mamory:=FreeMamory(15000) ;
                                  IF pri_mamory=TRUE THEN
                                     Storage.HeapAllocate(Storage.MainHeap,adr,15000) ;
                                     kod:=Lib.Execute("cf.ovl"," ",adr,15000 ) ;
                                     Storage.HeapDeallocate(Storage.MainHeap,adr,15000) ;
                                  END ; (* IF *)
                                  TxtImage.RestoreScreen();
                           |  3 : Close_Sh(b) ;
                                  Close(Bbb) ;
                                  Shadow(Aaa) ;
                                  EXIT ;
                    END ; (* CASE *)
                 END ;
          |  2 : TxtImage.SaveScreen() ;
                 pri_mamory:=FreeMamory(15000) ;
                 IF pri_mamory=TRUE THEN
                       Storage.HeapAllocate(Storage.MainHeap,adr,15000) ;
                       kod:=Lib.Execute("gs.ovl"," ",adr,15000 ) ;
                       Storage.HeapDeallocate(Storage.MainHeap,adr,15000) ;
                 END ; (* IF *)
                 TxtImage.RestoreScreen();
          |  3 : TxtImage.SaveScreen() ;
                 pri_mamory:=FreeMamory(15000) ;
                 IF pri_mamory=TRUE THEN
                       Storage.HeapAllocate(Storage.MainHeap,adr,15000) ;
                       kod:=Lib.Execute("start.exe"," ",adr,15000 ) ;
                       Storage.HeapDeallocate(Storage.MainHeap,adr,15000) ;
                 END ; (* IF *)
                 TxtImage.RestoreScreen();
          |  4 : Ccc:=Open(CC) ;
                 c:=Open_Sh(Ccc) ;
                 PutOnTop(Ccc) ;
                 Str.ItemS(line,mline,'|',4) ;
                 SetTitle(Ccc,line,CenterUpperTitle) ;
                 WrWin(3) ;
                 LOOP
                    MLINE(m2,24,12,48,3,Cyan,Blue) ;
                    IF OT=CHAR(27) THEN
                       i:=4 ;
                    END (* IF *) ;
                    CASE i OF 1 : (* статистическая обработка *)
                           TxtImage.SaveScreen() ;
                           pri_mamory:=FreeMamory(20000) ;
                           IF pri_mamory=TRUE THEN
                              Storage.HeapAllocate(Storage.MainHeap,adr,20000) ;
                              kod:=Lib.Execute("exstat.ovl"," ",adr,20000 ) ;
                              Storage.HeapDeallocate(Storage.MainHeap,adr,20000) ;
                           END ; (* IF *)
                           TxtImage.RestoreScreen();

                           |  2 : (* цифровая обработка сигнала *)
                           TxtImage.SaveScreen() ;
                           pri_mamory:=FreeMamory(20000) ;
                           IF pri_mamory=TRUE THEN
                              Storage.HeapAllocate(Storage.MainHeap,adr,20000) ;
                              kod:=Lib.Execute("exdigit.ovl"," ",adr,20000 ) ;
                              Storage.HeapDeallocate(Storage.MainHeap,adr,20000) ;
                           END ; (* IF *)
                           (* OT:=RdCharDirect() ; *)
                           TxtImage.RestoreScreen();
                           |  3 : (* математическая обработка *)
                           TxtImage.SaveScreen() ;
                           pri_mamory:=FreeMamory(20000) ;
                           IF pri_mamory=TRUE THEN
                              Storage.HeapAllocate(Storage.MainHeap,adr,20000) ;
                              kod:=Lib.Execute("exmath.ovl"," ",adr,20000 ) ;
                              Storage.HeapDeallocate(Storage.MainHeap,adr,20000) ;
                           END ; (* IF *)
                           TxtImage.RestoreScreen();
                           |  4 : Close_Sh(c) ;
                                  Close(Ccc) ;
                                  Shadow(Aaa) ;
                                  EXIT ;
                    END ; (* CASE *)
                 END ;
          |  5 : EXIT ;
   END ; (* CASE *)
END ; (* LOOP *)
Close_Sh(a) ;
Close(Ggg) ;
Close(Aaa) ;
Close(Yyy) ;
Close(Fff) ;
END mainproc.
