MODULE PrObr;  (*  Основное тело программы предварительной обработки  *)
IMPORT _Int24;
IMPORT IO,FIO,Str;

FROM Probr_lb  IMPORT SetOnHorMenu,SetOffHorMenu,Zastavka,File_error,
                      InputAlfa,InputMethod,InputShablon,InputDrive,
                      WaitingOn,WaitingOff,Space_free,File_menu,
                      Soundock,contdisk_contr,
                      wt_hormenu,wt_inverhormenu,wt_zasw,wt_lipa,
                      shablon_g,wt_contain,wt_attantion;
(*  ------------ Statistics Convertional ------------------  *)
FROM Lawid     IMPORT IntDif_law,wd_lawid,wt_lawid;
FROM Normal    IMPORT Check_hi2,Check_shed;
FROM statish   IMPORT stat;

(*  ------------ Digit Convertional - готово полностью ----  *)
FROM DigitCon  IMPORT Meth_1,Meth_2,Meth_3,Meth_4,Meth_5,Meth_6,Meth_7,Meth_8,
                      wt_mathmet,wt_invmat,wt_out;

(*  ------------ Mathematics  Convertional ----------------  *)
FROM MathCon   IMPORT Differen,Integral;

FROM Down_hlp  IMPORT SetOnDownhlp,SetOffDownhlp,
                      DownHelp0, DownHelp011,DownHelp02,DownHelp03,DownHelp031,
                      DownHelp04,DownHelp120,DownHelp220_30,wt_downhlp;
FROM SearchFl  IMPORT GetContainsCurrentDisk,FileInformArray,wt_flwindow;
FROM _Window   IMPORT Open_Shadow,Close_Shadow,Shadow;
FROM Window    IMPORT WinType,WinDef,Open,Close,PutOnTop,Hide,Color,TextColor,
                      SetTitle,CenterUpperTitle,RightUpperTitle,
                      SingleFrame,DoubleFrame,Use,GotoXY,Clear,Change,At;
VAR
    answ:                                           CHAR;
    stat_control:                                   BOOLEAN;
    control_wait:                                   CARDINAL; (* тень *)
    control_hormenu:                                CARDINAL; (* тень *)
    control_downhlp:                                CARDINAL; (* тень *)
    control_stat:                                   CARDINAL; (* тень *)
    quant_shablon:                                  CARDINAL;
    space_disk:                                     LONGINT;
    tuki:                                           LONGINT;
    menu_ret:                                       INTEGER;
    method_number:                                  INTEGER;
    i,a,x,long:                                     INTEGER;
    substring,string:                               ARRAY [0..25] OF CHAR;
    str_shablon:                                    ARRAY [0..45] OF CHAR;
(*    zatuk:                                          ARRAY [0..10000] OF REAL;*)
CONST
    cont_stat ='Файл+З-н распред.+Пров-ка нормальн.+Пров-ка стационар.+Выход';
    cont_digit='Файл+Методы обработки+Выход';
    cont_math ='Файл+Дифференциров.+Интегрирование+Сложение+Вычитание+Выход';
LABEL
    lab_begin,lab_end,lab0,lab01,lab1,lab101,lab11,lab2,lab21,lab_select;

PROCEDURE CloseHorMenu();
BEGIN
  SetOffHorMenu(control_hormenu);
  SetOffDownhlp(control_downhlp);
END CloseHorMenu;

PROCEDURE Write_filename();
VAR
 substring: ARRAY [0..20] OF CHAR;
BEGIN
 substring:= ' ';
 Str.Append(substring,FileInformArray[contdisk_contr].Name);
 Str.Append(substring,' ');
 SetTitle(wt_zasw,substring,RightUpperTitle);
END Write_filename;

PROCEDURE Write_reg();
BEGIN
 Change(wt_inverhormenu,4,2,73,2);
 Clear();
 IO.WrStr(substring);
END Write_reg;

PROCEDURE Write_met();
BEGIN
 Use(wt_inverhormenu); Clear();
 IO.WrStr(' Методы обработки');
 DownHelp120();
END Write_met;

BEGIN  (* ---------------- начало основного тела программы ----------------- *)

(*FOR menu_ret:= 1 TO 10000 DO
 zatuk[menu_ret]:= 1000.
END;
*)
lab_begin:
menu_ret:= Zastavka();
   control_hormenu:= SetOnHorMenu(); (* откр все окна относящиеся к гориз меню *)
   control_downhlp:= SetOnDownhlp(); (* откр окна для подстрочной подсказки *)

CASE menu_ret OF
(*  ------------------ статистическая  обработка сигнала ------------------ *)
0:      SetTitle(wt_hormenu,' Статистическая обработка ',CenterUpperTitle);
        Change(wt_inverhormenu,4,2,9,2);
        substring:= 'Файл';
        a:= 1;
lab0:   Use(wt_hormenu); Clear();
         long:= 0; x:= 0;
        FOR i:= 0 TO 4 DO
           Str.ItemS(string,cont_stat,'+',i);
           x:= x+ long+ 3;
           GotoXY(x,1);  IO.WrStr(string);
           long:= Str.Length(string);
        END; (* for *)
        Use(wt_inverhormenu);  Clear();
        GotoXY(2,1);  IO.WrStr(substring);
       (* ----------------- анализ положения курсора меню --------------- *)
LOOP
   DownHelp0();
   answ:= IO.RdCharDirect();
     CASE answ OF
         CHAR(0): answ:= IO.RdCharDirect();
             CASE answ OF
                CHAR(77): INC(a);
               |CHAR(75): DEC(a);
             END; (* case *)
        |CHAR(13): Write_reg();
              CASE a OF
                 1: str_shablon:= '*.*+*.dat+*.fl*+*.df*+*.in*+*.res';
                    quant_shablon:= 6;
                    GOTO lab_select;
                |2: DownHelp02();
                  IF NOT File_error() THEN  a:= 1; GOTO lab01 END;
                  LOOP
                  answ:= IO.RdCharDirect();	
                   CASE answ OF
                    'I','i','D','d':IntDif_law(answ);
                   |CHAR(27):       GOTO lab01
                   END; (* case *)
                  END; (* loop *)
                |3: DownHelp03();
                  IF NOT File_error() THEN  a:= 1; GOTO lab01 END;
                  LOOP
                   answ:= IO.RdCharDirect();	
                   CASE answ OF
                    'H','h': DownHelp031();
                             Check_hi2(InputAlfa());  GOTO lab01
                   |'S','s': Check_shed();            GOTO lab01
                   |CHR(27): GOTO lab01
                   END; (* case *)
                  END; (* loop *)
                |4:
                |5: CloseHorMenu();
                    GOTO lab_begin;
              END; (* case *)
     END; (* case *)
lab01:    IF a< 1 THEN a:= 5 END;
          IF a> 5 THEN a:= 1 END;
          CASE a OF
             1:  Change(wt_inverhormenu,4,2,9,2);
            |2:  Change(wt_inverhormenu,11,2,24,2);
            |3:  Change(wt_inverhormenu,26,2,44,2);
            |4:  Change(wt_inverhormenu,46,2,65,2);
            |5:  Change(wt_inverhormenu,67,2,73,2);
          END; (* case *)
          Use(wt_inverhormenu); Clear();
          Str.ItemS(substring,cont_stat,'+',a-1);
          GotoXY(2,1); IO.WrStr(substring);
END; (* loop *)

(*  ------------------ цифровая обработка сигнала ----------------------- *)
|1:    SetTitle(wt_hormenu,' Цифровая обработка ',CenterUpperTitle);
       Change(wt_inverhormenu,6,2,11,2);
       substring:= 'Файл';
       a:= 1;
lab1:  Use(wt_hormenu); Clear();
                GotoXY(5,1);  IO.WrStr('Файл');
                GotoXY(29,1); IO.WrStr('Методы обработки');
                GotoXY(64,1); IO.WrStr('Выход');
       Use(wt_inverhormenu); Clear();
       GotoXY(2,1); IO.WrStr(substring);
LOOP
  DownHelp0();
  answ:= IO.RdCharDirect();
   CASE answ OF
       CHAR(0): answ:= IO.RdCharDirect();
                CASE answ OF
                  CHAR(77): INC(a);
                 |CHAR(75): DEC(a);
                END; (* case *)
      |CHAR(13): Write_reg();
              CASE a OF
                  1: str_shablon:= '*.*+*.fl*+*.dat+*.res';
                     quant_shablon:= 4;
                     GOTO lab_select;
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
                         |6: Meth_7();
                       |7,8: Meth_8(method_number);
                         |MAX(INTEGER): GOTO lab11
                     END; (* case *)
                     Write_met();
                     GOTO lab101;
                 |3: CloseHorMenu();
                     GOTO lab_begin;
              END; (* case *)
   END; (* case *)
lab11:    IF a< 1 THEN a:= 3 END;
          IF a> 3 THEN a:= 1 END;
          CASE a OF
             1:  Change(wt_inverhormenu,6,2,11,2);
            |2:  Change(wt_inverhormenu,30,2,47,2);
            |3:  Change(wt_inverhormenu,65,2,71,2);
          END; (* case *)
          Use(wt_inverhormenu); Clear();
          Str.ItemS(substring,cont_digit,'+',a-1);
          GotoXY(2,1); IO.WrStr(substring);
END; (* loop *)

(*  ------------------ математическая обработка сигнала ----------------- *)
|2:     SetTitle(wt_hormenu,' Математическая обработка ',CenterUpperTitle);
        Change(wt_inverhormenu,4,2,9,2);
        substring:= 'Файл';
        a:= 1;
lab2:   Use(wt_hormenu); Clear();
         long:= 0; x:= 0;
        FOR i:= 0 TO 5 DO
           Str.ItemS(string,cont_math,'+',i);
           x:= x+ long+ 3;
           GotoXY(x,1); IO.WrStr(string);
           long:= Str.Length(string);
        END; (* for *)
        Use(wt_inverhormenu);  Clear();
        GotoXY(2,1); IO.WrStr(substring);
  LOOP
        DownHelp0();
        answ:= IO.RdCharDirect();
         CASE answ OF
           CHAR(0): answ:= IO.RdCharDirect();
               CASE answ OF
                  CHAR(77): INC(a);
                 |CHAR(75): DEC(a);
               END; (* case *)
          |CHAR(13): Write_reg();
              CASE a OF
                  1: quant_shablon:= 6;
                     str_shablon:= '*.*+*.dat+*.fl*+*.df*+*.in*+*.res';
                     GOTO lab_select;
                 |2: IF NOT File_error() THEN a:= 1;
                        ELSE Differen();
                     END; (* if *)
                     GOTO lab21;
                 |3: IF NOT File_error() THEN a:= 1;
                        ELSE Integral();
                     END; (* if *)
                     GOTO lab21;
                 |4: GOTO lab21;
                 |5: GOTO lab21;
                 |6: CloseHorMenu();
                     GOTO lab_begin;
              END; (* case *)
         END; (* case *)
lab21:    IF a< 1 THEN a:= 6 END;
          IF a> 6 THEN a:= 1 END;
          CASE a OF
             1:  Change(wt_inverhormenu,4,2,9,2);
            |2:  Change(wt_inverhormenu,11,2,26,2);
            |3:  Change(wt_inverhormenu,28,2,43,2);
            |4:  Change(wt_inverhormenu,45,2,54,2);
            |5:  Change(wt_inverhormenu,56,2,66,2);
            |6:  Change(wt_inverhormenu,68,2,74,2);
          END; (* case *)
          Use(wt_inverhormenu); Clear();
          Str.ItemS(substring,cont_math,'+',a-1);
          GotoXY(2,1); IO.WrStr(substring);
  END; (* loop *)

(*  ----------------------- выход в главное меню  ----------------------- *)
(* |3: *)

END; (* case *)

GOTO lab_end;
(* ------------------------- процедура выбора файлов -------------------- *)
lab_select:
            LOOP
              i:= File_menu();
              CASE i OF
                    0: DownHelp011();
                       contdisk_contr:= GetContainsCurrentDisk(shablon_g);
                       IF contdisk_contr= MAX(INTEGER)
                        THEN  SetTitle(wt_zasw,'',RightUpperTitle);
                              stat_control:= FALSE;
                        ELSE  Write_filename();
                              stat_control:= TRUE;
                       END;
                       CASE menu_ret OF
                                  0: IF stat_control THEN stat();
                                                          PutOnTop(wt_contain)
                                     END; (* if *)
                                     GOTO lab01
                                 |1: GOTO lab11
                                 |2: GOTO lab21
                       END; (* case *)
                   |1: InputShablon(quant_shablon,str_shablon);
                   |2: InputDrive();
                   |3: CASE menu_ret OF
                                  0: GOTO lab01
                                 |1: GOTO lab11
                                 |2: GOTO lab21
                       END; (* case *)
              END; (* case *)
            END; (* loop *)

lab_end:
Close(wt_flwindow);
Close(wt_zasw);
Close(wt_lipa);
Close(wt_contain);
Close(wt_attantion);
Close(wt_out);
Close(wt_mathmet);
Close(wt_invmat);

CloseHorMenu();
FIO.ChDir('D:\JPI');
END PrObr.