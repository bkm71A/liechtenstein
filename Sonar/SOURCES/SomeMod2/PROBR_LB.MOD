IMPLEMENTATION MODULE Probr_lb;
IMPORT FIO,Str,IO,Lib;
FROM   Assa     IMPORT  Screen,Print_ready;
FROM   GraphVl  IMPORT  PolygonDoubleFr,Coordinate_4,OutText;
FROM   ServisVl IMPORT  DiskFree,CheckDrive;
FROM   TxtImage IMPORT  SaveScreen,RestoreScreen;
FROM   Normal   IMPORT  alfa;
FROM   MakeMenu IMPORT  Vert_menu,wt_menu,wt_invr;
FROM   GraphSk  IMPORT  Put_Image,Get_Image;
FROM   SearchFl IMPORT  FileInformArray,GetCurrentDrive,DriveName,GetAllDrives,
                        drive_computer;
FROM   Down_hlp IMPORT  DownHelp0,DownHelp01,DownHelp012,DownHelp120,DownHelp221_31;
FROM   _Window  IMPORT  Open_Shadow,Close_Shadow,Shadow;
FROM   DigitCon IMPORT  wd_mathmet,wd_invmat, wt_mathmet,wt_invmat;
FROM   Window   IMPORT  WinDef,WinType,Color,TextColor,DoubleFrame,SingleFrame,
                        Open,Close,GotoXY,Use,SetTitle,Clear,CenterUpperTitle,
                        LeftLowerTitle,Change,TextBackground,PutOnTop,Hide,
                        SetFrame;
VAR    i:       CARDINAL;
       drive:   SHORTCARD;

PROCEDURE Zastavka(): INTEGER;
 VAR   j,i: INTEGER;
      answ: CHAR;
       str: ARRAY [0..47] OF CHAR;
 CONST
       contain1= 'Ввод и сохранение данных|'+
                 'Экспресс обработка|'+
                 'Просмотр и коррекция экспериментальных данных|'+
                 'Предварительная обработка|'+
                 'Архивирование экспериментальных данных';
       contain2= 'Статистическая обработка сигнала|'+
                 'Цифровая обработка сигнала|'+
                 'Математическая обработка сигнала|'+
                 'Выход в главное меню';
BEGIN
 PutOnTop(wt_lipa);
 PutOnTop(wt_zshad);
 PutOnTop(wt_zast);
 SetTitle(wt_zast,' СИСТЕМА ВВОДА И ПРЕДВАРИТЕЛЬНОЙ ОБРАБОТКИ ',CenterUpperTitle);
 FOR i:= 0 TO 4 DO
   Str.ItemS(str,contain1,'|',i);
   GotoXY(4,i+1);  IO.WrStr(str);
 END; (* for *)
 PutOnTop(wt_vertmenush);
 PutOnTop(wt_vertmenu);
 Clear();
 SetTitle(wt_vertmenu,' Предварительная обработка ',CenterUpperTitle);
 FOR i:= 0 TO 3 DO
   Str.ItemS(str,contain2,'|',i);
   GotoXY(4,i+1);  IO.WrStr(str);
 END; (* for *)
 PutOnTop(wt_invvertmenu);
 Change(wt_invvertmenu,13,10,46,10);
 i:= 0;
 Str.ItemS(str,contain2,'|',i);
 GotoXY(2,1);  IO.WrStr(str);
LOOP
   answ:= IO.RdCharDirect();
   CASE answ OF
     CHAR(0): answ:= IO.RdCharDirect();
       CASE answ OF  CHAR(72): DEC(i);
                    |CHAR(80): INC(i);
       END; (* case *)
    |CHAR(13): EXIT
   END; (* case *)
 IF i> 3  THEN i:= 0 END;
 IF i< 0  THEN i:= 3 END;
   Change(wt_invvertmenu,13,i+10,46,i+10);
   Clear();
   Str.ItemS(str,contain2,'|',i);
   GotoXY(2,1);  IO.WrStr(str);
END; (* loop *)
 Hide(wt_invvertmenu);
 Hide(wt_vertmenu);
 Hide(wt_vertmenush);
 Hide(wt_zast);
 Hide(wt_zshad);
PutOnTop(wt_zasw);
RETURN i;
END Zastavka;

PROCEDURE Soundock();
BEGIN
  Lib.Sound(400);
  Lib.Delay(250);
  Lib.NoSound();
END Soundock;

PROCEDURE ExitMesage();
BEGIN
END ExitMesage;

PROCEDURE SetOnHorMenu(): CARDINAL;
VAR
 shad_control: CARDINAL;
BEGIN
  wt_hormenu:= Open(wd_hormenu);
  shad_control:= Open_Shadow(wt_hormenu);
  wt_inverhormenu:= Open(wd_inverhormenu);
  RETURN shad_control;
END SetOnHorMenu;

PROCEDURE SetOffHorMenu(shad_control: CARDINAL);
BEGIN
  Close(wt_hormenu);
  Close(wt_inverhormenu);
  Close_Shadow(shad_control);
END SetOffHorMenu;


PROCEDURE Attantion(file_name: ARRAY OF CHAR): BOOLEAN;
VAR
    wd_wd:   WinDef;
    wt_wd:   WinType;
    answ:    CHAR;
    control: CARDINAL;
    sh_contr:CARDINAL;
    file:    FIO.File;
    ident:   ARRAY[1..2] OF CHAR;
BEGIN
   wd_wd:= WinDef(15,8,65,14,White,Red,FALSE,FALSE,FALSE,TRUE,SingleFrame,Cyan,Red);
   file:= FIO.Open(file_name);
   FIO.Seek(file,34);
   control:= FIO.RdBin(file,ident,2);
   FIO.Close(file);
 IF NOT(Str.Match(ident,'SW')) THEN
        wt_wd:= Open(wd_wd);
        sh_contr:= Open_Shadow(wt_wd);
        Use(wt_wd);
        GotoXY(8,3); IO.WrStr('неправильный формат данных в файле');
       TextColor(Yellow);
        GotoXY(18,1); IO.WrStr('О Ш И Б К А !');
       TextColor(LightGray);
        GotoXY(7,5);  IO.WrStr('для продолжения нажмите любую клавишу');
        Soundock();
  ELSIF Str.Match(ident,'SW') THEN RETURN TRUE;
 END; (* if *)
answ:= IO.RdCharDirect();
Close(wt_wd);
Close_Shadow(sh_contr);
RETURN FALSE;
END Attantion;

PROCEDURE File_error(): BOOLEAN;
VAR
 file:           FIO.File;
 control:        CARDINAL;
 control_file:   CARDINAL;
 answ:           CHAR;
 ok:             BOOLEAN;
 str:            ARRAY [0..30] OF CHAR;
BEGIN
 file:= FIO.Open(FileInformArray[contdisk_contr].Name);
 FIO.Close(file);
 control_file:= FIO.IOresult();
IF control_file <> 0 THEN
  CASE control_file OF
    2: str:= 'Файл не найден';
   |3: str:= 'Путь не найден';
   |4: str:= 'Слишком много открытых файлов';
   |6: str:= 'Не выбрано имя файла';
   |8: str:= 'Недостаточно памяти';
   |21:str:= 'Дисковод не готов';
  ELSE Str.CardToStr(LONGCARD(control_file),str,10,ok);
       Str.Concat(str,'код ошибки ДОС  ',str);
  END; (* case *)
 control:= Open_Shadow(wt_attantion);
 PutOnTop(wt_attantion);   Clear();
 control_file:= Str.Length(str);
 TextColor(White);
  GotoXY(25-control_file DIV 2,3); IO.WrStr(str);
 TextColor(Yellow);
  GotoXY(18,1); IO.WrStr('О Ш И Б К А !');
 TextColor(LightGray);
  GotoXY(7,5);  IO.WrStr('для продолжения нажмите любую клавишу');
  Soundock();
  answ:= IO.RdCharDirect();
  Hide(wt_attantion);
  Close_Shadow(control);
  RETURN FALSE;
 ELSE RETURN TRUE
END; (* if *)
END File_error;

PROCEDURE Fio_check(): BOOLEAN;
VAR
 control:        CARDINAL;
 control_file:   CARDINAL;
 ok:             BOOLEAN;
 answ:           CHAR;
 str:            ARRAY [0..35] OF CHAR;
BEGIN
 control_file:= FIO.IOresult();
IF control_file <> 0 THEN
  CASE control_file OF
    2: str:= 'Файл не найден';
   |3: str:= 'Путь не найден';
   |4: str:= 'Слишком много открытых файлов';
   |5: str:= 'Доступ отвергнут';
   |6: str:= 'Неверный описатель';
   |7: str:= 'Разрушены блоки управления памятью';
   |8: str:= 'Недостаточно памяти';
   |9: str:= 'Неверный адрес блока памяти';
   |15:str:= 'Задан неверный диск';
   |16:str:= 'Нельзя удалить тек. оглавление';
   |19:str:= 'Попытка записи на защищенный диск';
   |21:str:= 'Дисковод не готов';
  ELSE Str.CardToStr(LONGCARD(control_file),str,10,ok);
       Str.Concat(str,'код ошибки ДОС  ',str);
  END; (* case *)
 control:= Open_Shadow(wt_attantion);
 PutOnTop(wt_attantion);   Clear();
 control_file:= Str.Length(str);
 TextColor(White);
  GotoXY(25-control_file DIV 2,3); IO.WrStr(str);
 TextColor(Yellow);
  GotoXY(18,1); IO.WrStr('О Ш И Б К А !');
 TextColor(LightGray);
  GotoXY(7,5);  IO.WrStr('для продолжения нажмите любую клавишу');
  Soundock();
  answ:= IO.RdCharDirect();
  Hide(wt_attantion);
  Close_Shadow(control);
  RETURN FALSE;
 ELSE RETURN TRUE;
END; (* if *)
END Fio_check;

PROCEDURE Print_etiketka();
VAR
  output:    INTEGER;
  i,j:       INTEGER;
  control:   CARDINAL;
  prorez:    CARDINAL;
  distan:    CARDINAL;
  computer:  LONGCARD;
  data:      ARRAY [1..8] OF CHAR;
  objekt:    ARRAY [1..4] OF CHAR;
  obrab:     CARDINAL;
  ok:        BOOLEAN;
  file:      FIO.File;
  substring: ARRAY [0..79]  OF CHAR;
  realar:    ARRAY [2..17] OF REAL;
CONST Con_string= 'Дата эксперимента|'+
                  'Обьект|'+
                  'Bремя начала участка|'+
                  'Время конца участка|'+
                  'Частота дискретиз.|'+
                  'Количество точек реализ.|'+
                  'Прореживание|'+
                  'Минимум реализации|'+
                  'Максимум реализации|'+
                  'Матожидание|'+
                  'Нижняя граница фильтра|'+
                  'Верхняя граница фильтра|'+
                  'Дистанция прохода|'+
                  'Разрешение по частоте|'+
                  'Ширина спектра|'+
                  'Нижн.предел довер.интр.|'+
                  'Верх.предел довер.интр.|'+
                  'Доверит. вероятность';
      Anal_strng= 'ПРИЗНАКИ                  |'+
                  'ОБРАБОТКИ                 |'+
                  'статистическая обработка  |'+
                  'сглаживание окном Тьюки   |'+
                  'автокореляц обработка     |'+
                  'дифференцирование         |'+
                  'интегрирование            |'+
                  'фильтр. в полосе частот   |'+
                  'спектр реализации         |'+
                  'спектральная плотность    |'+
                  'сглаживание по Хеммингу   |'+
                  'сглаживание по Хеннингу   |'+
                  'сгл.спек.плотн.по ансамблю|'+
                  'сглаживание по частотам   |'+
                  'устранение выбросов       |'+
                  'устранение тренда         |'+
                  'калибровка                |'+
                  'тарировка                 ';

BEGIN
  file:= FIO.Open(FileInformArray[contdisk_contr].Name);

  (* два байта обработки *)
FIO.Seek(file,48);
  control:= FIO.RdBin(file,obrab,2);

FIO.Seek(file,2);
  (* дата эксперимента *)
  control:= FIO.RdBin(file,data,8);

  (* обьект *)
  control:= FIO.RdBin(file,objekt,4);

  (* время начала участка ввода *)
  control:= FIO.RdBin(file,realar[2],4);

  (* время конца участка ввода *)
  control:= FIO.RdBin(file,realar[3],4);

  (* частота дискретизации *)
  control:= FIO.RdBin(file,realar[4],4);

  (* количество точек реализации *)
  control:= FIO.RdBin(file,computer,4);

  (* прореживание *)
  control:= FIO.RdBin(file,prorez,2);

FIO.Seek(file,36);
  (* минимум реализации *)
  control:= FIO.RdBin(file,realar[7],4);

  (* максимум реализации *)
  control:= FIO.RdBin(file,realar[8],4);

  (* матожидание *)
  control:= FIO.RdBin(file,realar[9],4);

FIO.Seek(file,50);
  (* нижняя граница фильтра *)
  control:= FIO.RdBin(file,realar[10],4);

  (* верхняя граница фильтра *)
  control:= FIO.RdBin(file,realar[11],4);

  (* дистанция прохода *)
  control:= FIO.RdBin(file,distan,2);

  (* разрешение по частоте *)
  control:= FIO.RdBin(file,realar[13],4);

  (* ширина спектра *)
  control:= FIO.RdBin(file,realar[14],4);

  (* нижний интервал *)
  control:= FIO.RdBin(file,realar[15],4);

  (* верхний интервал *)
  control:= FIO.RdBin(file,realar[16],4);

  (* доверительная вероятность *)
  control:= FIO.RdBin(file,realar[17],4);

  FIO.WrStrAdj(4,'Этикетка файла',30);
  FIO.WrStrAdj(4,FileInformArray[contdisk_contr].Name,14);
  FIO.WrLn(4);  FIO.WrLn(4);

output:= 4;
FOR i:= 0 TO 17 DO
  Str.ItemS(substring,Con_string,'|',i);
  FIO.WrStrAdj(output,substring,-25);
  CASE i OF
                     0: FIO.WrStrAdj(output,data,11);
    |                1: FIO.WrStrAdj(output,objekt,11);
    |2..4,7..11,13..17: FIO.WrReal(output,realar[i],6,9);
    |                5: FIO.WrLngCard(output,computer,11);
    |                6: FIO.WrCard(output,prorez,11);
    |               12: FIO.WrCard(output,distan,11);
  END; (* case *)
  Str.ItemS(substring,Anal_strng,'|',i);
  FIO.WrStrAdj(output,substring,28);
  CASE i OF 2..17:
    j:= INTEGER(BITSET(obrab)*BITSET(i-2));
     IF   j= 0 THEN substring:= 'НЕТ';
               ELSE substring:= ' ДА';
     END; (* if *)
     FIO.WrStrAdj(output,substring,5);
  END; (* case *)
  FIO.WrLn(output);
END; (* for *)
  FIO.WrLn(output);
END Print_etiketka;

PROCEDURE Printer(answ: CHAR);
VAR
  wt_print:  WinType;
  wd_print:  WinDef;
  ok:        BOOLEAN;
  xcoord:    Coordinate_4;
  ycoord:    Coordinate_4;
BEGIN
LOOP
ok:= FALSE;
CASE answ OF
 CHAR(27): EXIT;
| 'P','p': ok:= TRUE;
           IF Print_ready() = 255
            THEN  Print_etiketka();
                  Screen();
            ELSE  xcoord[1]:= 120;    ycoord[1]:= 112;
                  xcoord[2]:= 520;    ycoord[2]:= 112;
                  xcoord[3]:= 520;    ycoord[3]:= 196;
                  xcoord[4]:= 120;    ycoord[4]:= 196;
                  Get_Image(119,110,520,199);
                  PolygonDoubleFr(xcoord,ycoord,4,15);
                  OutText(0,33, 9,8AH,'О Ш И Б К А !');
                  OutText(0,22,13,83H,'для продолжения нажмите любую клавишу');
                  OutText(0,31,11,8BH,'Принтер не готов');
                  Soundock();
           END; (* if *)
END; (* case *)
answ:= IO.RdCharDirect();
IF ok THEN Put_Image(119,110,520,199) END;
END(* loop *)
END Printer;

PROCEDURE WaitingOn(): CARDINAL;
 VAR
  shad_contr: CARDINAL;
BEGIN
 wt_wait:= Open(wd_wait);
 shad_contr:= Open_Shadow(wt_wait);
 Use(wt_wait);
 IO.WrStr('         ЖДИТЕ !!'); IO.WrLn();
 IO.WrStr('  Производятся вычисления');
 RETURN shad_contr;
END WaitingOn;

PROCEDURE WaitingOff(shad_contr: CARDINAL);
BEGIN
 Close(wt_wait);
 Close_Shadow(shad_contr);
END WaitingOff;


PROCEDURE InputAlfa(): INTEGER;
VAR
    ii:              INTEGER;
    answ:            CHAR;
    shadow:          CARDINAL;
    file:            FIO.File;
BEGIN
    Change(wt_range,45,6,57,19);
    shadow:= Open_Shadow(wt_range);
    PutOnTop(wt_range);
    Clear();
  FOR ii:= 0 TO 11 DO
    GotoXY(1,ii+1); IO.WrReal(alfa[ii],5,5);
  END; (* for *)
 Change(wt_invrange,46,7,56,7);
 PutOnTop(wt_invrange);
 Use(wt_invrange); Clear();
 IO.WrReal(alfa[0],5,5);
 ii:= 0;
 LOOP
  answ:= IO.RdCharDirect();
  CASE answ OF
       CHAR(13): EXIT;
      |CHAR(0) : answ:= IO.RdCharDirect();
                    CASE answ OF
                         CHAR(72): DEC(ii)
                        |CHAR(80): INC(ii)
                    END; (* case *)
  END; (* case *)
     IF ii< 0  THEN ii:= 11 END;
     IF ii> 11 THEN ii:= 0  END;
     Change(wt_invrange,46,ii+7,56,ii+7);
     Use(wt_invrange); Clear();
     IO.WrReal(alfa[ii],5,5);
 END; (* loop *)
    Hide(wt_range);
    Hide(wt_invrange);
    Close_Shadow(shadow);
    RETURN ii;
END InputAlfa;

PROCEDURE InputDrive();
VAR
   i:         INTEGER;
   answ:      CHAR;
   shadow:    CARDINAL;
   dr_name:   ARRAY [1..3]  OF CHAR;
LABEL
   lab1;
BEGIN
lab1:
  DownHelp012();
  GetAllDrives();
  Change(wt_range,5,8,9,9+drive_computer+2);
  shadow:= Open_Shadow(wt_range);
  PutOnTop(wt_range);    Clear();

  FOR i:= 1 TO drive_computer+2 DO
    GotoXY(2,i);  IO.WrChar(CHAR(DriveName[i]+40H));
  END; (* for *)
  Change(wt_invrange,6,9,8,9);
  PutOnTop(wt_invrange);  Clear();
  i:= 1;
  GotoXY(2,1); IO.WrChar(CHAR(DriveName[i]+40H));
 LOOP
  answ:= IO.RdCharDirect();
  CASE answ OF
       CHAR(13): Str.Concat(dr_name,CHAR(DriveName[i]+40H),':\');
                 FIO.ChDir(dr_name);
                 EXIT
      |CHAR(0) : answ:= IO.RdCharDirect();
                    CASE answ OF
                         CHAR(72): DEC(i)
                        |CHAR(80): INC(i)
                    END; (* case *)
  END; (* case *)
     IF i< 1 THEN i:= drive_computer+2 END;
     IF i> drive_computer+2 THEN i:= 1 END;
     Change(wt_invrange,6,i+8,8,i+8);
     Use(wt_invrange); Clear();
     GotoXY(2,1); IO.WrChar(CHAR(DriveName[i]+40H));
 END; (* loop *)

    Hide(wt_range);
    Hide(wt_invrange);
    Close_Shadow(shadow);
END InputDrive;

PROCEDURE InputShablon(quant: INTEGER; shablon: ARRAY OF CHAR);
VAR
   i:         INTEGER;
   answ:      CHAR;
   shadow:    CARDINAL;
   substring: ARRAY[1..6] OF CHAR;
BEGIN
    DownHelp01();
    Change(wt_range,5,7,15,8+quant);
    shadow:= Open_Shadow(wt_range);
    PutOnTop(wt_range);
    Clear();
  FOR i:= 0 TO quant DO
    Str.ItemS(substring,shablon,'+',i);
    GotoXY(3,i+1) ; IO.WrStr(substring);
  END; (* for *)
   Change(wt_invrange,7,8,13,8);
   Use(wt_invrange); Clear();
   PutOnTop(wt_invrange);
 i:= 0;
   Str.ItemS(substring,shablon,'+',i);
   GotoXY(2,1); IO.WrStr(substring);
 LOOP
  answ:= IO.RdCharDirect();
  CASE answ OF
       CHAR(13): Str.Copy(shablon_g,substring); EXIT
      |CHAR(0) : answ:= IO.RdCharDirect();
                    CASE answ OF
                         CHAR(72): DEC(i)
                        |CHAR(80): INC(i)
                    END; (* case *)
  END; (* case *)
     IF i< 0 THEN i:= quant-1 END;
     IF i> quant-1 THEN i:= 0 END;
     Change(wt_invrange,7,i+8,13,i+8);
     Use(wt_invrange); Clear();
     Str.ItemS(substring,shablon,'+',i);
     GotoXY(2,1);  IO.WrStr(substring);
 END; (* loop *)
    Hide(wt_range);
    Hide(wt_invrange);
    Close_Shadow(shadow);
END InputShablon;

PROCEDURE InputMethod(): INTEGER;
VAR
    ii:              INTEGER;
    answ:            CHAR;
    shadow:          CARDINAL;
    substring:       ARRAY[1..35] OF CHAR;
CONST
   contain= 'Фильтрация в полосе частот|'+
            'Сглаживание окном Тьюки|'+
            'Вычисление спектра|'+
            'Вычисление спектральной плотности|'+
            'Вычисление автокорр. функции|'+
            'Сглаж. спек. плотности по частотам|'+
            'Сг.спек.плотн. по ансамблю частот|'+
            'Сглаж. спек. плотности по Хеннингу|'+
            'Сглаж. спек. плотности по Хеммингу';
BEGIN
    Change(wt_range,25,6,62,16);
    (* SetTitle(wt_range,' Выбор метода ',CenterUpperTitle); *)
    shadow:= Open_Shadow(wt_range);
    PutOnTop(wt_range);
    Clear();
  FOR ii:= 0 TO 8 DO
    Str.ItemS(substring,contain,'|',ii);
    GotoXY(2,ii+1) ; IO.WrStr(substring);
  END; (* for *)
   Change(wt_invrange,26,7,61,7);
   Use(wt_invrange); Clear();
   GotoXY(2,1); IO.WrStr('Фильтрация в полосе частот');
   PutOnTop(wt_invrange);
 ii:= 0;
 LOOP
  answ:= IO.RdCharDirect();
  CASE answ OF
       CHAR(13): EXIT;
      |CHAR(27): ii:= MAX(INTEGER); EXIT;
      |CHAR(0) : answ:= IO.RdCharDirect();
                    CASE answ OF
                         CHAR(72): DEC(ii)
                        |CHAR(80): INC(ii)
                    END; (* case *)
  END; (* case *)
     IF ii< 0 THEN ii:= 8 END;
     IF ii> 8 THEN ii:= 0 END;
     Change(wt_invrange,26,ii+7,61,ii+7);
     Use(wt_invrange); Clear();
     Str.ItemS(substring,contain,'|',ii);
     GotoXY(2,1);  IO.WrStr(substring);
 END; (* loop *)
    Hide(wt_range);
    Hide(wt_invrange);
    Close_Shadow(shadow);
    RETURN ii;
END InputMethod;


PROCEDURE File_menu(): CARDINAL;
VAR
  a:        CARDINAL;
BEGIN
  DownHelp0();
  a:= Vert_menu(3,6,Black,4,TRUE,SingleFrame,Black,Cyan,
                TRUE,FALSE,CenterUpperTitle,'',
                'Выбор файла+Выбор шаблона+Выбор диска+Выход',13);
  CASE a OF
          0,3:  Hide(wt_menu);
                Hide(wt_invr);
  END; (* case *)
  RETURN a;
END File_menu;

PROCEDURE ReadEtiketka(file_name: ARRAY OF CHAR): CARDINAL;
VAR
     wd_etik:  WinDef;
     wt_etik:  WinType;
     file:     FIO.File;
     control:  CARDINAL;
     index:    CARDINAL;               (* индекс начала служебной информации *)
     index1:   ARRAY [1..5] OF CHAR;
     data:     ARRAY [1..8] OF CHAR;   (* дата эксперимента *)
     objekt:   ARRAY [1..4] OF CHAR;   (* объект *)
     timeb:    REAL;                   (* время начала участка ввода *)
     tbegin1:  ARRAY [1..16] OF CHAR;
     timeend:  REAL;                   (* время конца участка ввода *)
     tend1:    ARRAY [1..16] OF CHAR;
     chastota: REAL;                   (* частота дискретизации *)
     chastota1:ARRAY [1..16] OF CHAR;
     kol:      CARDINAL;               (* количество точек реализации *)
     kol1:     ARRAY [1..5] OF CHAR;
     prore:    CARDINAL;               (* прореживание *)
     prore1:   ARRAY [1..5] OF CHAR;
     in_real:  CARDINAL;               (* индекс начала экспериментальных данных *)
     in_real1: ARRAY [1..5] OF CHAR;
     ident:    ARRAY [1..2] OF CHAR;   (* идентификатор файла обработки *)
     min:      REAL;                   (* минимум  *)
     min1:     ARRAY [1..16] OF CHAR;
     max:      REAL;                   (* максимум *)
     max1:     ARRAY [1..16] OF CHAR;
     mo:       REAL;                   (* матожидание *)
     mo1:      ARRAY [1..16] OF CHAR;
     obr:      CARDINAL;               (* 2 байта обработки *)
     filtr1:   REAL;                   (* нижняя граница фильтрации *)
     filtr11:  ARRAY [1..16] OF CHAR;
     filtr2:   REAL;                   (* верхняя граница фильтрации *)
     filtr22:  ARRAY [1..16] OF CHAR;
     distan:   CARDINAL;               (* дистанция прохода *)
     distan1:  ARRAY [1..5] OF CHAR;
     OK,Eng:   BOOLEAN;
     answ:     CHAR;
     i:        SHORTCARD ;
     j:        CARDINAL ;
     reg,
     podreg:   ARRAY [1..2] OF CHAR ;
     kanal:    ARRAY [1..3] OF CHAR ;

BEGIN
file:=FIO.Open(file_name) ;
FIO.Seek(file,34);
   control:= FIO.RdBin(file,ident,2);
   IF NOT(Str.Match(ident,'SW')) THEN RETURN MAX(CARDINAL) END;

  wd_etik:= WinDef(0,0,79,24,LightCyan,Blue,FALSE,FALSE,FALSE,TRUE,DoubleFrame,Yellow,Blue);
  wt_etik:= Open(wd_etik);

(* формирование данных из имени файла *)
      Str.Slice(reg,file_name,1,2);
      Str.Slice(podreg,file_name,3,2);
      Str.Slice(kanal,file_name,5,3);

FIO.Seek(file,0);
      control:=FIO.RdBin(file,index,2);    (* индекс начала служебной информации *)
      control:=FIO.RdBin(file,data,8);     (* дата эксперимента *)
      control:=FIO.RdBin(file,objekt,4);   (* объект *)
      control:=FIO.RdBin(file,timeb,4);    (* время начала участка ввода *)
      control:=FIO.RdBin(file,timeend,4);  (* время конца участка ввода *)
      control:=FIO.RdBin(file,chastota,4); (* частота дискретизации *)
      control:=FIO.RdBin(file,kol,4);      (* количество точек реализации *)
      control:=FIO.RdBin(file,prore,2);    (* прореживание *)
      control:=FIO.RdBin(file,in_real,2);  (* индекс начала экспериментальных данных *)
      control:=FIO.RdBin(file,ident,2);    (* идентификатор файла обработки *)
      control:=FIO.RdBin(file,min,4);      (* минимум  *)
      control:=FIO.RdBin(file,max,4);      (* максимум *)
      control:=FIO.RdBin(file,mo,4);       (* матожидание *)
      control:=FIO.RdBin(file,obr,2);      (* 2 байта обработки *)
      control:=FIO.RdBin(file,filtr1,4);   (* нижняя граница фильтрации *)
      control:=FIO.RdBin(file,filtr2,4);   (* верхняя граница фильтрации *)
      control:=FIO.RdBin(file,distan,2);   (* дистанция прохода *)
FIO.Close(file);

      Eng:=TRUE ;
          Str.RealToStr(LONGREAL(timeb),10,Eng,tbegin1,OK);
          Str.RealToStr(LONGREAL(timeend),10,Eng,tend1,OK);
          Str.RealToStr(LONGREAL(chastota),10,Eng,chastota1,OK);
          Str.CardToStr(LONGINT(kol),kol1,10,OK);
          Str.CardToStr(LONGINT(prore),prore1,10,OK);
          Str.RealToStr(LONGREAL(min),10,Eng,min1,OK);
          Str.RealToStr(LONGREAL(max),10,Eng,max1,OK);
          Str.RealToStr(LONGREAL(mo),10,Eng,mo1,OK);
          Str.CardToStr(LONGINT(distan),distan1,10,OK);

(* распаковка двух байтов обработки *)
          j:=CARDINAL(BITSET(obr)*BITSET(1));
          IF j=0 THEN
                GotoXY(75,8); TextColor(LightCyan); IO.WrStr('НЕТ');
             ELSE
                GotoXY(75,8); TextColor(LightMagenta); IO.WrStr('ДА');
          END ; (* IF *)
          j:=CARDINAL(BITSET(obr)*BITSET(2));
          IF j=0 THEN
                GotoXY(75,9); TextColor(LightCyan); IO.WrStr('НЕТ');
             ELSE
                GotoXY(75,9); TextColor(LightMagenta); IO.WrStr('ДА');
          END ; (* IF *)
          j:=CARDINAL(BITSET(obr)*BITSET(4));
          IF j=0 THEN
                GotoXY(75,10); TextColor(LightCyan);  IO.WrStr('НЕТ');
             ELSE
                GotoXY(75,10); TextColor(LightMagenta);  IO.WrStr('ДА');
          END ; (* IF *)
          j:=CARDINAL(BITSET(obr)*BITSET(8));
          IF j=0 THEN
                GotoXY(75,11);  TextColor(LightCyan); IO.WrStr('НЕТ');
             ELSE
                GotoXY(75,11);  TextColor(LightMagenta); IO.WrStr('ДА');
          END ; (* IF *)
          j:=CARDINAL(BITSET(obr)*BITSET(16));
          IF j=0 THEN
                GotoXY(75,12); TextColor(LightCyan); IO.WrStr('НЕТ');
             ELSE
                GotoXY(75,12); TextColor(LightMagenta); IO.WrStr('ДА');
          END ; (* IF *)
          j:=CARDINAL(BITSET(obr)*BITSET(32));
          IF j=0 THEN
                GotoXY(75,13);  TextColor(LightCyan); IO.WrStr('НЕТ');
             ELSE
                GotoXY(75,13);  TextColor(LightMagenta); IO.WrStr('ДА');
                Str.RealToStr(LONGREAL(max),10,Eng,max1,OK);
                GotoXY(58,20); IO.WrStr(max1);
                Str.RealToStr(LONGREAL(max),10,Eng,max1,OK);
                GotoXY(58,21); IO.WrStr(max1);
          END ; (* IF *)
          j:=CARDINAL(BITSET(obr)*BITSET(0800H));
          IF j=0 THEN
                GotoXY(75,14); TextColor(LightCyan); IO.WrStr('НЕТ');
             ELSE
                GotoXY(75,14); IO.WrStr('ДА');
          END ; (* IF *)
          j:=CARDINAL(BITSET(obr)*BITSET(1000H));
          IF j=0 THEN
                GotoXY(75,15); TextColor(LightCyan); IO.WrStr('НЕТ');
             ELSE
                GotoXY(75,15); TextColor(LightMagenta); IO.WrStr('ДА');
          END ; (* IF *)
          j:=CARDINAL(BITSET(obr)*BITSET(2000H));
          IF j=0 THEN
                GotoXY(75,16); TextColor(LightCyan); IO.WrStr('НЕТ');
             ELSE
                GotoXY(75,16); TextColor(LightMagenta); IO.WrStr('ДА');
          END ; (* IF *)
          j:=CARDINAL(BITSET(obr)*BITSET(4000H));
          IF j=0 THEN
                GotoXY(75,17); TextColor(LightCyan); IO.WrStr('НЕТ');
             ELSE
                GotoXY(75,17); TextColor(LightMagenta); IO.WrStr('ДА');
          END ; (* IF *)
          j:=CARDINAL(BITSET(obr)*BITSET(8000H));
          IF j=0 THEN
                GotoXY(75,18); TextColor(LightCyan); IO.WrStr('НЕТ');
             ELSE
                GotoXY(75,18); TextColor(LightMagenta); IO.WrStr('ДА');
          END ; (* IF *)

        TextColor(LightCyan);
          GotoXY(15,3);  IO.WrStr('дата эксперимента');
          GotoXY(9,5);   IO.WrStr('номер режима');
          GotoXY(30,5);  IO.WrStr('номер подрежима');
          GotoXY(55,5);  IO.WrStr('номер канала');
          GotoXY(55,3);  IO.WrStr('объект');
          GotoXY(2,8);   IO.WrStr('время начала участка ввода');
          GotoXY(2,9);   IO.WrStr('время конца участка ввода');
          GotoXY(2,10);  IO.WrStr('частота дискретизации');
          GotoXY(2,11);  IO.WrStr('количество точек реализации');
          GotoXY(2,12);  IO.WrStr('прореживание') ;
          GotoXY(2,13);  IO.WrStr('минимум');
          GotoXY(2,14);  IO.WrStr('максимум');
          GotoXY(2,15);  IO.WrStr('матожидание');
          GotoXY(2,16);  IO.WrStr('дистанция прохода');
          GotoXY(48,8);  IO.WrStr('статистическая обработка');
          GotoXY(48,9);  IO.WrStr('спектральная обработка') ;
          GotoXY(48,10); IO.WrStr('корреляционная обработка');
          GotoXY(48,11); IO.WrStr('дифференцирование');
          GotoXY(48,12); IO.WrStr('интегрирование');
          GotoXY(48,13); IO.WrStr('фильтрация');
          GotoXY(48,14); IO.WrStr('сглаживание');
          GotoXY(48,15); IO.WrStr('устранение выбросов');
          GotoXY(48,16); IO.WrStr('устранение трендов');
          GotoXY(48,17); IO.WrStr('калибровка');
          GotoXY(48,18); IO.WrStr('тарировка');
          GotoXY(30,20); IO.WrStr('нижняя граница фильтрации');
          GotoXY(30,21); IO.WrStr('верхняя граница фильтрации');
        TextColor(LightMagenta);
          GotoXY(36,0);  IO.WrStr(' ЭТИКЕТКА ');
          GotoXY(31,1);  IO.WrStr('файл');
          GotoXY(31,16); IO.WrStr(distan1);
          GotoXY(55,7);  IO.WrStr('виды обработки');
          GotoXY(23,5);  IO.WrStr(reg);
          GotoXY(34,3);  IO.WrStr(data);
          GotoXY(47,5);  IO.WrStr(podreg);
          GotoXY(69,5);  IO.WrStr(kanal);
          GotoXY(63,3);  IO.WrStr(objekt);
          GotoXY(30,8);  IO.WrStr(tbegin1);
          GotoXY(30,9);  IO.WrStr(tend1);
          GotoXY(30,10); IO.WrStr(chastota1);
          GotoXY(31,11); IO.WrStr(kol1);
          GotoXY(31,12); IO.WrStr(prore1);
          GotoXY(30,13); IO.WrStr(min1);
          GotoXY(30,14); IO.WrStr(max1);
          GotoXY(30,15); IO.WrStr(mo1);
        TextColor(Yellow);
          GotoXY(37,1);  IO.WrStr(file_name);
        TextColor(LightGray);
          GotoXY(18,23); IO.WrStr('для продолжения работы нажмите любую клавишу');

          answ:= IO.RdCharDirect();
          Close(wt_etik);
          RETURN in_real;
END ReadEtiketka;

PROCEDURE Space_free(dig: LONGINT);
VAR
  control:     CARDINAL;
  length:      CARDINAL;
  bool:        BOOLEAN;
  answ:        CHAR;
  str:         ARRAY [1..45] OF CHAR;
BEGIN
    control:= Open_Shadow(wt_attantion);
    PutOnTop(wt_attantion); Clear();
    TextColor(LightGray);
    GotoXY(7,5);  IO.WrStr('для продолжения нажмите любую клавишу');
    TextColor(Yellow);
    GotoXY(18,1); IO.WrStr('О Ш И Б К А !');

IF      dig> 0   THEN  Str.IntToStr(dig,str,10,bool);
                       Str.Insert(str,'На диске не хватает ',0);
                       Str.Append(str,' байт');
  ELSIF  dig= -1 THEN  str:= 'Расширение должно быть .SPL';
  ELSIF  dig= -2 THEN  str:= 'Длинна файла короче базы';
  ELSIF  dig= -3 THEN  str:= 'Расширение должно быть .DAT, .REZ или .FL*';
  ELSE                 Str.IntToStr(ABS(dig),str,10,bool);
                       Str.Insert(str,'В  ОЗУ   не хватает ',0);
                       Str.Append(str,' байт');
END; (* if *)

 length:= Str.Length(str);
 TextColor(White);
 GotoXY(25-length DIV 2,3); IO.WrStr(str);

answ:= IO.RdCharDirect();
Close_Shadow(control);
Hide(wt_attantion);
END Space_free;

BEGIN
 wt_lipa:= Open(wd_lipa);
 FOR i:= 1 TO 25  DO
     GotoXY(1,i);
     IO.WrCharRep('░',80);
 END; (* for *)
 wt_zasw:= Open(wd_zasw);
 FOR i:= 1 TO 23  DO
     GotoXY(1,i);
     IO.WrCharRep('░',80);
 END; (* for *)
 wt_zshad:= Open(wd_zshad);
 wt_zast:= Open(wd_zast);
 wt_vertmenu:= Open(wd_vertmenu);
 wt_vertmenush:= Open(wd_vertmenush);
 wt_invvertmenu:= Open(wd_invvertmenu);
 wt_invrange:= Open(wd_invrange);
 wt_range:= Open(wd_range);
 wt_mathmet:= Open(wd_mathmet);
 wt_invmat:= Open(wd_invmat);
 wt_attantion:= Open(wd_attantion);
 FIO.IOcheck:= FALSE;
END Probr_lb.