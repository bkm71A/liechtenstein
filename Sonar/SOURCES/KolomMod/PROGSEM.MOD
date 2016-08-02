MODULE progsem ;
FROM Window IMPORT Open,TextColor,GotoXY,Close,Clear,CursorOff,SetTitle,Use,
                   WinType,WinDef,DoubleFrame,SingleFrame,Color,CenterUpperTitle,
                   FrameStr,RightUpperTitle,DirectWrite,Hide,TextBackground,
                   SetFrame ;

FROM IO  IMPORT RdCharDirect,WrStr,WrLn,WrChar,WrCard,WrLngCard,WrHex ;

FROM Lib IMPORT Dos,IncAddr,AddAddr ;

IMPORT FIO,Storage,Str  ;

FROM SYSTEM IMPORT Out,In,Registers,Ofs,Seg ;
FROM Str IMPORT CardToStr ;
CONST const = 19 ;
      O01  ='Система ввода и предварительной обработки' ;
      O11  ='Ввод и сохранение данных' ;
      O12  ='Экспресс обработка' ;
      O13  ='Просмотр и коррекция эксперементальных данных' ;
      O14  ='Предварительная обработка' ;
      O15  ='Архивирование экспериментальных данных' ;
      O16  ='Просмотр каталога рабочих файлов' ;
      O17  ='Выход в ДОС' ;
      O21  ='Коррекция таблицы кроссировок' ;
      O22  ='Ввод тарировок' ;
      O23  ='Ввод калибровок' ;
      O24  ='Загрузка и сохранение информационных массивов' ;
      O25  ='Выход в главное меню' ;
      O31  ='Просмотр реализаций и ручная коррекция' ;
      O32  ='Калибровка' ;
      O33  ='Устранение трендов' ;
      O34  ='Сглаживание' ;
      O35  ='Фильтрация' ;
      O36  ='Тарировка' ;
      O37  ='Выход в главное меню' ;
      O41  ='Интегрирование' ;
      O42  ='Дифференцирование' ;
      O43  ='Фильтрация' ;
      O44  ='Вычисление корреляции' ;
      O45  ='Вычисление спектральной плотности' ;
      O46  ='Проверка данных на стационарность' ;
      O47  ='Масштабирование' ;
      O48  ='Выход в главное меню' ;
      PROB = ' Для продолжения нажмите любую клавишу.' ;
 TYPE slovo = ARRAY[1..const] OF CHAR ;
      BUF   = ARRAY[1..2048+FIO.BufferOverhead] OF BYTE ;
      Address = POINTER TO BYTE ;
 VAR Aaa,Bbb,Ccc,Ddd,Eee,Fff,Www     : WinType ;
     AA,BB,CC,DD,EE,FF,WW            : WinDef ;
     OT                              : CHAR ;
     Imja                            : ARRAY[1..const] OF CHAR ;
     Put                             : ARRAY[1..const+11] OF CHAR ;
     otvet                           : FIO.DirEntry ;
     tit,tit1                        : CARDINAL ;
     prizfile,przap                  : BOOLEAN ;

     x,y,h,w,dh,F,i,d,k,f,j     : CARDINAL ;
     peremen               : slovo ;
     fileprm               : FIO.File ;
     Regim,maska           : SHORTCARD ;
     r                     : Registers ;
     NomKan,YprSlov        : ARRAY[1..8] OF SHORTCARD ;
     Bufer                 : ARRAY[1..8] OF BUF ;
     ADDR                  : Address     ;
     file                  :  ARRAY[1..23] OF CHAR ;
     dd                    :  ARRAY[1..8]  OF FIO.File ;
     Kan                   :  ARRAY[1..8] OF CARDINAL ;
     inf                   :  CARDINAL ;

BEGIN
(************** задание цвета экрана ******************)
WW:=WinDef(0,0,79,24,Blue,LightGray,FALSE,FALSE,FALSE,FALSE,DoubleFrame,Blue,LightGray) ;
Www:=Open(WW);

      (**********  Вас приветствует НИЦ СОНАР ******************)
WW:=WinDef(50,1,77,5,Yellow,Cyan,FALSE,FALSE,FALSE,TRUE,DoubleFrame,Yellow,Blue) ;
Www:=Open(WW);
GotoXY(6,1)  ; WrStr('Вас приветствует') ;
GotoXY(8,2)  ; WrStr('НИЦ') ;     TextColor(Brown) ;
GotoXY(13,2) ; WrStr('"Сонар"') ; TextColor(Yellow) ;
GotoXY(10,3)  ; WrStr('АН УССР') ;

AA:=WinDef(20,8,60,16,Yellow,Cyan,FALSE,FALSE,FALSE,TRUE,DoubleFrame,Yellow,Blue) ;
Aaa:=Open(AA);
GotoXY(3,2)  ; WrStr('А В Т О М А Т И З И Р О В А Н Н А Я') ;
GotoXY(7,4)  ; WrStr('И Н Ф О Р М А Ц И О Н Н А Я') ;
GotoXY(14,6) ; WrStr('С И С Т Е М А') ;

OT:=RdCharDirect() ;
Close(Www) ;
Close(Aaa) ;

        (******************** главное окно ***********************)
AA:=WinDef(10,6,60,14,LightCyan,Blue,FALSE,TRUE,FALSE,TRUE,DoubleFrame,Yellow,Blue) ;
Aaa:=Open(AA) ;
     SetTitle(Aaa,O01,CenterUpperTitle) ;
     GotoXY(3,1)  ; WrStr(O11) ;
     GotoXY(3,2)  ; WrStr(O12) ;
     GotoXY(3,3)  ; WrStr(O13) ;
     GotoXY(3,4)  ; WrStr(O14) ;
     GotoXY(3,5)  ; WrStr(O15) ;
     GotoXY(3,6)  ; WrStr(O16) ;
     GotoXY(3,7)  ; WrStr(O17) ;

      (**************   окно для первого режима   ******************)
BB:=WinDef(20,14,70,20,Blue,Cyan,FALSE,TRUE,FALSE,TRUE,DoubleFrame,LightRed,Cyan) ;
                    (*****  окно для третьего режима   ****)
CC:=WinDef(20,14,70,22,Blue,Cyan,FALSE,TRUE,FALSE,TRUE,DoubleFrame,LightRed,Cyan) ;
                   (*****  окно для четвертого режима   ****)
DD:=WinDef(20,14,70,23,Blue,Cyan,FALSE,TRUE,FALSE,TRUE,DoubleFrame,LightRed,Cyan) ;
                  (*****      Перемещающееся окно       *****)
EE:=WinDef(12,7,48,7,Brown,Cyan,FALSE,FALSE,FALSE,FALSE,' ',White,Blue) ;

tit:=7 ;
LOOP
   EE.Y1:=tit ; EE.Y2:=tit ;
   EE.X1:=12 ;  EE.X2:=58 ;
   EE.Foreground:=Brown ;
   EE.Background:=Cyan ;
   Eee:=Open(EE) ;
   GotoXY(2,1)   ;
   CASE EE.Y1 OF  7 : WrStr(O11)
              |   8 : WrStr(O12)
              |   9 : WrStr(O13)
              |  10 : WrStr(O14)
              |  11 : WrStr(O15)
              |  12 : WrStr(O16)
              |  13 : WrStr(O17)
   END ;
   OT:=RdCharDirect() ;
   CASE OT OF
         (CHAR(72)) : DEC(tit)   ;                (* ВВЕРХ *)
                      IF tit<7  THEN tit:=13  END
      |  (CHAR(80)) : IF tit>12 THEN tit:=7       (* ВНИЗ *)
                                ELSE INC(tit)   END

      | (CHAR(0DH)) : Hide(Eee) ;

                       CASE tit OF 7 :  Bbb:=Open(BB) ;
                                        SetTitle(Bbb,O11,CenterUpperTitle) ;
                                        GotoXY(3,1)  ; WrStr(O21) ;
                                        GotoXY(3,2)  ; WrStr(O22) ;
                                        GotoXY(3,3)  ; WrStr(O23) ;
                                        GotoXY(3,4)  ; WrStr(O24) ;
                                        GotoXY(3,5)  ; WrStr(O25) ;
                                        tit1:=15 ;
                                        LOOP
                                        EE.Y1:=tit1 ; EE.X1:=22 ;
                                        EE.Y2:=tit1 ; EE.X2:=68 ;
                                        EE.Foreground:=Cyan ;
                                        EE.Background:=Blue ;
                                        Eee:=Open(EE) ;
                                        GotoXY(2,1) ;
                                        CASE EE.Y1 OF 15 : WrStr(O21)
                                                    | 16 : WrStr(O22)
                                                    | 17 : WrStr(O23)
                                                    | 18 : WrStr(O24)
                                                    | 19 : WrStr(O25)
                                        END (* CASE *) ;

                                        OT:=RdCharDirect() ;

                                           CASE OT OF
                                              (CHAR(72)) : DEC(tit1)   ;
                                              IF tit1<15 THEN tit1:=19  END
                                           |  (CHAR(80)) : IF tit1>18 THEN tit1:=15
                                              ELSE INC(tit1)   END

                                           | (CHAR(0DH)) : IF tit1=19 THEN
                                                              Hide(Bbb) ;
                                                              Hide(Eee) ;
                                                              EXIT;
                                                           END (* IF *)
                                           END ; (* CASE *)
                                           Hide(Eee)
                                        END (* LOOP *)
                                 | 8 :
                                 | 9 :  Ccc:=Open(CC) ;
                                        SetTitle(Ccc,O13,CenterUpperTitle) ;
                                        GotoXY(3,1)  ; WrStr(O31) ;
                                        GotoXY(3,2)  ; WrStr(O32) ;
                                        GotoXY(3,3)  ; WrStr(O33) ;
                                        GotoXY(3,4)  ; WrStr(O34) ;
                                        GotoXY(3,5)  ; WrStr(O35) ;
                                        GotoXY(3,6)  ; WrStr(O36) ;
                                        GotoXY(3,7)  ; WrStr(O37) ;
                                        tit1:=15 ;
                                        LOOP
                                        EE.Y1:=tit1 ; EE.X1:=22 ;
                                        EE.Y2:=tit1 ; EE.X2:=68 ;
                                        EE.Foreground:=Cyan ;
                                        EE.Background:=Blue ;
                                        Eee:=Open(EE) ;
                                        GotoXY(2,1) ;
                                        CASE EE.Y1 OF 15 : WrStr(O31)
                                                    | 16 : WrStr(O32)
                                                    | 17 : WrStr(O33)
                                                    | 18 : WrStr(O34)
                                                    | 19 : WrStr(O35)
                                                    | 20 : WrStr(O36)
                                                    | 21 : WrStr(O37)

                                        END (* CASE *) ;

                                        OT:=RdCharDirect() ;

                                           CASE OT OF
                                              (CHAR(72)) : DEC(tit1)   ;
                                              IF tit1<15 THEN tit1:=21  END
                                           |  (CHAR(80)) : IF tit1>20 THEN tit1:=15
                                              ELSE INC(tit1)   END

                                           | (CHAR(0DH)) : IF tit1=21 THEN
                                                              Hide(Ccc) ;
                                                              Hide(Eee) ;
                                                              EXIT;
                                                           END (* IF *)
                                           END ; (* CASE *)
                                           Hide(Eee)
                                        END (* LOOP *)
                                 |10 :  Ddd:=Open(DD) ;
                                        SetTitle(Ddd,O14,CenterUpperTitle) ;
                                        GotoXY(3,1)  ; WrStr(O41) ;
                                        GotoXY(3,2)  ; WrStr(O42) ;
                                        GotoXY(3,3)  ; WrStr(O43) ;
                                        GotoXY(3,4)  ; WrStr(O44) ;
                                        GotoXY(3,5)  ; WrStr(O45) ;
                                        GotoXY(3,6)  ; WrStr(O46) ;
                                        GotoXY(3,7)  ; WrStr(O47) ;
                                        GotoXY(3,8)  ; WrStr(O48) ;
                                        tit1:=15 ;
                                        LOOP
                                        EE.Y1:=tit1 ; EE.X1:=22 ;
                                        EE.Y2:=tit1 ; EE.X2:=68 ;
                                        EE.Foreground:=Cyan ;
                                        EE.Background:=Blue ;
                                        Eee:=Open(EE) ;
                                        GotoXY(2,1) ;
                                        CASE EE.Y1 OF 15 : WrStr(O41)
                                                    | 16 : WrStr(O42)
                                                    | 17 : WrStr(O43)
                                                    | 18 : WrStr(O44)
                                                    | 19 : WrStr(O45)
                                                    | 20 : WrStr(O46)
                                                    | 21 : WrStr(O47)
                                                    | 22 : WrStr(O48)

                                        END (* CASE *) ;

                                        OT:=RdCharDirect() ;

                                           CASE OT OF
                                              (CHAR(72)) : DEC(tit1)   ;
                                              IF tit1<15 THEN tit1:=22  END
                                           |  (CHAR(80)) : IF tit1>21 THEN tit1:=15
                                              ELSE INC(tit1)   END

                                           | (CHAR(0DH)) : IF tit1=22 THEN
                                                              Hide(Ddd) ;
                                                              Hide(Eee) ;
                                                              EXIT;
                                                           END (* IF *)
                                           END ; (* CASE *)
                                           Hide(Eee)
                                        END (* LOOP *)
                                 |11 :
                                 |12 :
                                 |13 :  EXIT
                       END ; (* case *)

   END ;  (* CASE *)
         Hide(Eee);
END ;  (*loop*)

       Close(Eee) ;
       Close(Aaa) ;

END progsem.
