MODULE pr_obrab;
IMPORT IO,Str,Lib;
FROM Window   IMPORT  Color,WinType,WinDef,SingleFrame,Open,Close,Clear,TextColor,
                      SetTitle,GotoXY,FullScreen,Use,PutOnTop,Change,DoubleFrame,
                      CenterUpperTitle,LeftUpperTitle,Hide,FrameStr,SetFrame,
                      TitleMode,TextBackground,ClrEol;
FROM FIO      IMPORT  ChDir;
FROM ServisVl IMPORT  GetNameLastDrive;
FROM Difer    IMPORT  differ;
FROM Integr   IMPORT  integral;
FROM filtr    IMPORT  filtration;
FROM MakeMenu IMPORT  MenuMaker,FirstOpeningMenu,wt_menu,wt_pris,wd_pris,wt_invr,
                                                 wt_shpr,wd_shpr,wt_shad;
FROM SearchFl IMPORT  GetContainsCurrentDisk,FileInformArray,GetPath,PathName;

VAR a,a1,Length,Number:      INTEGER;
    LengthWind,LengthName:   INTEGER;
    ContrFiltr,Control:      LONGINT;
    LostGr,HighGr:           REAL;
    Range,
    Proverka,metka_vozvr,i:  CARDINAL;
    wt_info,wt_ishd,wt_por,
    wt_prist,wt_wait,wt_shwt:WinType;
    wd_info,wd_ishd,wd_por,
    wd_prist,wd_wait,wd_shwt:WinDef;
    LastDisk,answ:           CHAR;
    Proverka_vozvr:          BOOLEAN;
    PathExit:                ARRAY[0..52] OF CHAR;
    peremen:                 ARRAY[0..12] OF CHAR;


LABEL lab0,lab1,lab_d,lab_d1,lab_i;


PROCEDURE AnalizGr(min,max: REAL; X1,Y1: CARDINAL): REAL;
 VAR  digit: REAL;
BEGIN
   Change(wt_por,X1,Y1,X1+8,Y1);
   PutOnTop(wt_por);
   digit:=IO.RdReal();
   Hide(wt_por);
 IF (digit>=min)AND(digit<=max) THEN RETURN digit;   ELSE RETURN 0.;  END;
END AnalizGr;


PROCEDURE AnalizRange(min,max,X1: CARDINAL): CARDINAL;
 VAR  digit : CARDINAL;
BEGIN
   Change(wt_por,X1,wd_por.Y1,X1+4,wd_por.Y2);
   PutOnTop(wt_por);
   digit:=IO.RdCard();
   Hide(wt_por);
 IF (digit>=min)AND(digit<=max) THEN RETURN digit;   ELSE RETURN 0;  END;
END AnalizRange;


PROCEDURE FileOtobr(): CARDINAL;
VAR ret:  CARDINAL;
    long: CARDINAL;
    answ: CHAR;
BEGIN
(* -- установить текущую дирректорию, добавить к ней имя выбранного файла -- *)
GetPath();
Str.Append(PathName,FileInformArray[Number].Name);
Use(wt_info); Clear();
TextColor(LightRed);
TextBackground(Red);
GotoXY(3,1); IO.WrStr('Файл выбранный Вами для обработки');
GotoXY(5,3); IO.WrStr('Подтверждение выбора <ENTER>');
GotoXY(8,4); IO.WrStr('Изменение выбора <ESC>');
GotoXY(4,5); IO.WrStr('Отказ от дифференцирования <Q>');
long:= Str.Length(PathName);
i:= (wd_info.X2 - wd_info.X1 - long) >> 1 ;
TextColor(White);
TextBackground(LightRed) ;
GotoXY(i,2); IO.WrStr(PathName);
TextBackground(Red) ;
PutOnTop(wt_ishd);
PutOnTop(wt_info);
LOOP
answ:= IO.RdCharDirect();
 CASE answ OF CHAR(13): ret:= 0;
                        EXIT
             |CHAR(27): ret:= 1;
                        EXIT
             |'Q','q':  ret:= 2;
                        EXIT
 END; (* case *)
END; (* loop *)
Hide(wt_ishd);
Hide(wt_info);
RETURN ret;
END FileOtobr;

PROCEDURE WaitingOn();
BEGIN
wt_shwt:= Open(wd_shwt);
wt_wait:= Open(wd_wait);
GotoXY(6,1); IO.WrStr('Processing');
GotoXY(2,2); IO.WrStr('Please waiting !!');
END WaitingOn;

PROCEDURE  WaitingOff();
BEGIN
Close(wt_wait);
Close(wt_shwt);
END WaitingOff;

BEGIN

(* ----------- запоминаем в PathExit текущую дирректорию входа ------------ *)
GetPath();
Str.Copy(PathExit,PathName);
Length:= Str.Length(PathExit);
IF Length= 3 THEN INC(Length) END;
Str.Delete(PathExit,Length-1,1);
(* ----------- описатели всех окон основного тела программы -------------- *)
wd_info:=WinDef(40,1,77,7,LightBlue,Red,FALSE,FALSE,TRUE,TRUE,SingleFrame,Yellow,Red);
wd_ishd:=WinDef(41,2,78,8,Red,Black,FALSE,FALSE,TRUE,FALSE,SingleFrame,Red,Red);
wd_por:= WinDef(59,7,63,7,White,LightGreen,TRUE,FALSE,TRUE,FALSE,SingleFrame,Red,Red);
wd_wait:=WinDef(29,10,49,13,White,LightRed,FALSE,FALSE,FALSE,TRUE,SingleFrame,Yellow,Red);
wd_shwt:=WinDef(30,11,50,14,Red,DarkGray,FALSE,FALSE,FALSE,FALSE,'........',Red,Red);

(* ------------------------ открываем все окна ---------------------------- *)
FirstOpeningMenu(TRUE,Cyan);
wt_ishd:= Open(wd_ishd);
wt_info:= Open(wd_info);
wt_por:=  Open(wd_por);
wt_pris:= Open(wd_pris);
wt_shpr:= Open(wd_shpr);
(* --------------------- основное тело программы -------------------- *)
  LOOP
     a:= MenuMaker(10,1,           (* координаты верхнего левого угла *)
                   White,          (* цвет текста в меню *)
                   8,              (* колличество полей в меню *)
                   TRUE,           (* наличие рамки *)
                   SingleFrame,    (* тип рамки *)
                   White,Blue,     (* цвет рамки и фона *)
                   TRUE,           (* наличие тени *)
                   FALSE,          (* наличие пристройки *)
                   0,0,            (* горизонтальный и вертикальный размер пристройки *)
                   TRUE,           (* наличие заголовка *)
                   CenterUpperTitle,
                   ' Предварительная обработка ',(* содержание заголовка *)
                   'Выбор файла данных для обработки+Статистическая обработка+Фильтрация входных сигналов+Вычисление спектральных характеристик+Вычисление корреляционных характеристик+Дифференцирование процесса+Интегрирование процесса+Выход в главное меню',
                   39                    (* длинна наибольшего поля меню*) );
lab0:
    CASE a OF
(*  ---------- выбор имени файла для обработки ---------------- *)
              0: Proverka_vozvr:= FALSE;
                 lab1:
                 Number:= GetContainsCurrentDisk('*.*');
                 IF Proverka_vozvr THEN a:= metka_vozvr;
                                        GOTO lab0
                 END;
(* ----------- статистическая обработка --------------------- *)
             |1: LOOP
                   a1:= MenuMaker(35,7,LightRed,3,TRUE,SingleFrame,Yellow,Blue,
                                 TRUE,FALSE,0,0,TRUE,CenterUpperTitle,
                                 ' Статистическая обработка ',
                                 'Порядок производной+Запуск+Выход',26);
                   CASE a1 OF 0:
                             |1:
                             |2: EXIT
                   END; (* case *)
                 END; (* loop *)
(* -------- фильтрация входных сигналов ---------------------- *)
             |2: LOOP
                   a1:= MenuMaker(35,7,LightRed,4,TRUE,DoubleFrame,Yellow,Blue,
                                  TRUE,TRUE,9,4,TRUE,LeftUpperTitle,
                                 ' Фильтрация входных сигналов ',
                                 'Нижняя граница (1-10)+Верхняя граница(100-1000)+Запуск+Выход',24);
                   CASE a1 OF 0: LostGr:= AnalizGr(1.,10.,66,9);
                                 IF LostGr=0. THEN
                                           Use(wt_pris);
                                           TextBackground(LightBlue);
                                           TextColor(White);
                                           GotoXY(1,2); ClrEol();
                                           IO.WrStr('ERROR');
                                           TextBackground(Blue);
                                    ELSE   Use(wt_pris);
                                           GotoXY(0,2); ClrEol();
                                           IO.WrReal(LostGr,5,5)
                                 END; (* if *)
                             |1: HighGr:= AnalizGr(100.,1000.,66,10);
                                 IF HighGr=0. THEN
                                           Use(wt_pris);
                                           TextBackground(LightBlue);
                                           TextColor(White);
                                           GotoXY(1,3); ClrEol();
                                           IO.WrStr('ERROR');
                                           TextBackground(Blue);
                                    ELSE   Use(wt_pris);
                                           GotoXY(0,3); ClrEol();
                                           IO.WrReal(HighGr,5,5)
                                 END; (* if *)
                             |2: Proverka:= FileOtobr();
                                 CASE Proverka OF
                                      0: WaitingOn();
(* Славик доделает - вставить *)         ContrFiltr:= filtration(TRUE,LostGr,HighGr,FileInformArray[Number].Name);
                                         WaitingOff();
                                     |1: Hide(wt_menu); Hide(wt_pris);
                                         Hide(wt_shad); Hide(wt_shpr);
                                         Hide(wt_invr);
                                         Proverka_vozvr:= TRUE;
                                         metka_vozvr:= 2;
                                         GOTO lab1
                                     |2: GOTO lab_d1
                                 END; (* case *)

                             |3: GOTO lab_d1;
                   END; (* case *)
                 END; (* loop *)
(* -------- вычисление спектральных характеристик ------------- *)
             |3: LOOP
                   a1:= MenuMaker(35,7,LightRed,3,TRUE,SingleFrame,Yellow,Blue,
                                   TRUE,FALSE,0,0,TRUE,CenterUpperTitle,
                                 ' Вычисление  спектральных характеристик ',
                                 'Порядок производной+Выбор файла+Выход',38);
                   CASE a1 OF 0:
                             |1:
                             |2: EXIT
                   END; (* case *)
                 END; (* loop *)
(* --------- вычисление корреляционных характеристик ------------- *)
             |4: LOOP
                   a1:= MenuMaker(35,7,LightRed,3,TRUE,SingleFrame,Yellow,Blue,
                                  TRUE,FALSE,0,0,TRUE,CenterUpperTitle,
                                 ' Вычисление корреляционных характеристик ',
                                 'Порядок производной+Выбор файла+Выход',38);
                   CASE a1 OF 0:
                             |1:
                             |2: EXIT
                   END; (* case *)
                 END; (* loop *)
(* ---------- дифференцирование процесса -------------------------- *)
             |5: Use(wt_pris); Clear();
                 LOOP
                   a1:= MenuMaker(30,5,LightRed,3,TRUE,DoubleFrame,Yellow,Blue,
                                   TRUE,TRUE,5,3,TRUE,LeftUpperTitle,
                                 ' Дифференцирование процесса ',
                                 'Порядок производной(1-3)+Запуск+Выход',22);
                   CASE a1 OF 0: Range:= AnalizRange(1,3,59);
                                 IF Range= 0 THEN
                                    lab_d: Use(wt_pris); Clear();
                                           TextBackground(LightBlue);
                                           TextColor(White);
                                           GotoXY(1,2); IO.WrStr('ERROR');
                                           TextBackground(Blue);
                                    ELSE   Use(wt_pris); Clear();
                                           GotoXY(3,2);IO.WrCard(Range,1)
                                 END; (* if *)
                             |1: IF (Range>3)OR(Range<1) THEN GOTO lab_d END;
                                 Proverka:= FileOtobr();
                                 CASE Proverka OF
                                        0: WaitingOn();
                                           Control:= differ(Range,FileInformArray[Number].Name);
                                           WaitingOff();
                                       |1: Hide(wt_menu); Hide(wt_pris);
                                           Hide(wt_shad); Hide(wt_shpr);
                                           Hide(wt_invr);
                                           Proverka_vozvr:= TRUE;
                                           metka_vozvr:= 5;
                                           GOTO lab1
                                       |2: GOTO lab_d1
                                 END; (* case *)
                             |2: lab_d1:
                                 Hide(wt_pris);
                                 Hide(wt_shpr);
                                 EXIT
                   END; (* case *)
                 END; (* loop *)
(* ------------ интегрирование процесса -------------------- *)
             |6: Use(wt_pris); Clear();
                 LOOP
                   a1:= MenuMaker(30,5,LightRed,3,TRUE,DoubleFrame,Yellow,Blue,
                                  TRUE,TRUE,5,3,TRUE,LeftUpperTitle,
                                 ' Интегрирование процесса ',
                                 'Порядок интегрирования(1-2)+Запуск+Выход',25);
                   CASE a1 OF 0: Range:= AnalizRange(1,2,62);
                                 IF Range= 0 THEN
                                    lab_i: Use(wt_pris); Clear();
                                           TextBackground(LightBlue);
                                           TextColor(White);
                                           GotoXY(1,2); IO.WrStr('ERROR');
                                           TextBackground(Blue);
                                    ELSE   Use(wt_pris); Clear();
                                           GotoXY(3,2);IO.WrCard(Range,1)
                                 END; (* if *)


                             |1: IF (Range>2)OR(Range<1) THEN GOTO lab_i END;
                                 Proverka:= FileOtobr();
                                 CASE Proverka OF
                                        0: WaitingOn();
                                           LastDisk:= GetNameLastDrive();
                                           Control:= integral(LastDisk,Range,FileInformArray[Number].Name);
                                           WaitingOff();
                                       |1: Hide(wt_menu); Hide(wt_pris);
                                           Hide(wt_shad); Hide(wt_shpr);
                                           Hide(wt_invr);
                                           Proverka_vozvr:= TRUE;
                                           metka_vozvr:= 6;
                                           GOTO lab1
                                       |2: GOTO lab_d1
                                 END; (* case *)
                             |2: Hide(wt_pris);
                                 Hide(wt_shpr);
                                 EXIT;
                   END; (* case *)
                 END; (* loop *)
(* ------------ выход из главного меню ------------------------ *)
             |7: EXIT
    END; (* case *)
  END ; (* loop *)
(* -------------- выходим туда-же, откуда вошли --------------- *)
ChDir(PathExit);
END pr_obrab.

