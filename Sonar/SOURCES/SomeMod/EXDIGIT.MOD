MODULE  Exdigit;   (* основное тело отдельной программы цифровой обработки *)
IMPORT _Int24;
IMPORT IO,FIO,Str;
FROM Probr_lb  IMPORT SetOnHorMenu,SetOffHorMenu,File_error,InputMethod,
                      InputShablon,InputDrive,WaitingOn,WaitingOff,Space_free,
                      File_menu,Soundock,contdisk_contr,
                      wt_hormenu,wt_inverhormenu,wt_zasw,wd_zasw,
                      shablon_g,wt_attantion,wt_range;

(*  ------------------ Digit Convertion - готово полностью --------------  *)
FROM DigitCon  IMPORT Meth_1,Meth_2,Meth_3,Meth_4,Meth_5,Meth_6,Meth_7,Meth_8,
                      wt_mathmet,wt_invmat,wt_out;
FROM statish   IMPORT wt_contain;
FROM Down_hlp  IMPORT SetOnDownhlp,SetOffDownhlp,wt_downhlp,
                      DownHelp0, DownHelp011,DownHelp120;
FROM EraseFl   IMPORT OutErase;
FROM SearchFl  IMPORT GetContainsCurrentDisk,GetCurrentDrive,
                      FileInformArray,FullPath,wt_flwindow;
FROM _Window   IMPORT Open_Shadow,Close_Shadow,Shadow;
FROM Window    IMPORT Open,Close,Hide,Use,GotoXY,Clear,Change,
                      SetTitle,CenterUpperTitle,RightUpperTitle;
VAR
    answ           : CHAR;
    control_wait   : CARDINAL; (* тень *)
    control_hormenu: CARDINAL; (* тень *)
    control_downhlp: CARDINAL; (* тень *)
    x1,x2          : CARDINAL; (* координ. курсора меню *)
    method_number,
    i,a            : INTEGER;
    substring      : ARRAY [0..25] OF CHAR;
CONST
    cont_digit='Файл+Методы обработки+Выход';
LABEL
    lab1,lab101,lab11;

PROCEDURE Write_filename();
VAR
 substring: ARRAY [0..20] OF CHAR;
BEGIN
 substring:= ' ';
 Str.Append(substring,FileInformArray[contdisk_contr].Name);
 Str.Append(substring,' ');
 SetTitle(wt_zasw,substring,RightUpperTitle);
END Write_filename;

PROCEDURE Zasvetka();
VAR x: CARDINAL;
BEGIN
  FOR x:= 1 TO 23  DO
     GotoXY(1,x);
     IO.WrCharRep('░',80)
  END;
END Zasvetka;

BEGIN
FIO.GetDir(0,FullPath);
a:= Str.Length(FullPath);
IF a<> 0 THEN Str.Insert(FullPath,':\',0)
         ELSE Str.Insert(FullPath,':',0)
END;
answ:= GetCurrentDrive();
Str.Insert(FullPath,answ,0);
FIO.ChDir('D:\DATA');
(* --------------- окно засветки экрана рыхлым цветом --------------------- *)
  wt_zasw:= Open(wd_zasw);
  Zasvetka();
(* ------------- начальный вывод горизонтального меню на экран ------------ *)
  control_hormenu:= SetOnHorMenu(); (* откр все окна относящиеся к гориз меню *)
  control_downhlp:= SetOnDownhlp(); (* откр окна для подстрочной подсказки *)
  SetTitle(wt_hormenu,' Цифровая обработка ',CenterUpperTitle);
lab1:
        Change(wt_inverhormenu,6,2,11,2);
        substring:= 'Файл';
        a:= 1;
        Use(wt_hormenu); Clear();
        GotoXY(5,1);     IO.WrStr('Файл');
        GotoXY(12,1);    IO.WrStr('Методы обработки');
        GotoXY(64,1);    IO.WrStr('Выход');
        Use(wt_inverhormenu); Clear();
        GotoXY(2,1); IO.WrStr(substring);
LOOP
  DownHelp0();
  answ:= IO.RdCharDirect();
   CASE answ OF
       CHAR(0):  answ:= IO.RdCharDirect();
                 CASE answ OF
                   CHAR(77): INC(a)
                  |CHAR(75): DEC(a)
                 END; (* case *)
      |CHAR(27): EXIT
      |CHAR(13): Change(wt_inverhormenu,4,2,73,2);
                 Clear();  IO.WrStr(substring);
              CASE a OF
                  1: (* --- процедура выбора файлов --- *)
                     LOOP
                       i:= File_menu();
                       CASE i OF
                          0: DownHelp011();
                             contdisk_contr:= GetContainsCurrentDisk(shablon_g);
                             IF contdisk_contr= MAX(INTEGER)
                              THEN  SetTitle(wt_zasw,'',RightUpperTitle);
                              ELSE  Write_filename();
                             END;
                             EXIT
                         |1: InputShablon(4,'*.*+*.dat+*.sp*+*.fl*')
                         |2: InputDrive()
                         |3: EXIT
                       END; (* case *)
                     END; (* loop *)
                 |2: DownHelp120();
                     IF NOT File_error() THEN a:= 1; GOTO lab11 END;
lab101:              method_number:= InputMethod();
                     CASE method_number OF
                          0: Meth_1();
                         |1: Meth_2();
                         |2: Meth_3();
                         |3: Meth_4();
                         |4: Meth_5();
                         |5: Meth_6();

                       (*  |6: Meth_7();
                       |7,8: Meth_8(method_number);*)

                       |6,7: Meth_8(method_number+1);

                       |MAX(INTEGER): GOTO lab11
                     END ; (* case *)
                     Use(wt_inverhormenu); Clear();
                     IO.WrStr(' Методы обработки'); DownHelp120();
                     GOTO lab101;
                 |3: EXIT
              END; (* case *)
   END; (* case *)
lab11:    IF a< 1 THEN a:= 3 END;
          IF a> 3 THEN a:= 1 END;
          CASE a OF
             1:  x1:=  6; x2:= 11;
            |2:  x1:= 13; x2:= 30;
            |3:  x1:= 65; x2:= 71;
          END; (* case *)
          Change(wt_inverhormenu,x1,2,x2,2);
          Use(wt_inverhormenu); Clear();
          Str.ItemS(substring,cont_digit,'+',a-1);
          GotoXY(2,1); IO.WrStr(substring);
END; (* loop *)

OutErase();
Close(wt_contain);
Close(wt_flwindow);
Close(wt_zasw);
Close(wt_attantion);
Close(wt_out);
Close(wt_mathmet);
Close(wt_invmat);
Close(wt_range);
SetOffHorMenu(control_hormenu);
SetOffDownhlp(control_downhlp);

FIO.ChDir(FullPath);

END Exdigit.