MODULE Exmath;   (* основное тело отдельной программы математическ. обработки *)

IMPORT _Int24;
IMPORT IO,FIO,Str;
FROM Probr_lb  IMPORT SetOnHorMenu,SetOffHorMenu,File_error,Space_free,
                      InputShablon,InputDrive,File_menu,
                      contdisk_contr,
                      wt_hormenu,wt_inverhormenu,wt_zasw,wd_zasw,
                      shablon_g,wt_attantion;
(*  ------------ Mathematics  Convertional ----------------  *)
FROM MathCon   IMPORT Differen,Integral;
FROM DigitCon  IMPORT wt_out,wt_mathmet,wt_invmat;
FROM Addition  IMPORT Addit;
FROM Down_hlp  IMPORT SetOnDownhlp,SetOffDownhlp,DownHelp0,DownHelp011,
                      DownHelp120,DownHelpPlus1,DownHelpPlus2,wt_downhlp;
FROM EraseFl   IMPORT OutErase;
FROM SearchFl  IMPORT GetContainsCurrentDisk,GetCurrentDrive,
                      FileInformArray,FullPath,wt_flwindow;
FROM _Window   IMPORT Open_Shadow,Close_Shadow,Shadow;
FROM Window    IMPORT Open,Close,SetTitle,CenterUpperTitle,RightUpperTitle,
                      Use,GotoXY,Clear,Change,Color,TextColor;
VAR
    answ:                                           CHAR;
    control_wait:                                   CARDINAL; (* тень *)
    control_hormenu:                                CARDINAL; (* тень *)
    control_downhlp:                                CARDINAL; (* тень *)
    quant_shablon:                                  CARDINAL;
    space_disk:                                     LONGINT;
    i,a,x,long:                                     INTEGER;
    substring,string:                               ARRAY [0..25] OF CHAR;
    first_file,second_file:                         ARRAY [0..12] OF CHAR;
    tmp:                                            INTEGER;
CONST  cont_math ='Файл+Дифференциров.+Интегрирование+Сложение+Вычитание+Выход';
LABEL  lab21;

PROCEDURE CloseHorMenu();
BEGIN
  SetOffHorMenu(control_hormenu);
  SetOffDownhlp(control_downhlp);
END CloseHorMenu;

PROCEDURE Write_filename();
VAR
 substring: ARRAY [0..15] OF CHAR;
BEGIN
 substring:= ' ';
 Str.Append(substring,FileInformArray[contdisk_contr].Name);
 Str.Append(substring,' ');
 SetTitle(wt_zasw,substring,RightUpperTitle);
END Write_filename;

PROCEDURE Write_reg();
BEGIN
 Change(wt_inverhormenu,4,2,73,2);
 Clear(); TextColor(Black);
 IO.WrStr(substring);
END Write_reg;

PROCEDURE Zasvetka();
VAR x: CARDINAL;
BEGIN
  FOR x:= 1 TO 23  DO
     GotoXY(1,x);
     IO.WrCharRep('░',80)
  END;
END Zasvetka;

BEGIN (* --------------- начало основного тела программы ------------------- *)
FIO.GetDir(0,FullPath);
a:= Str.Length(FullPath);
IF a<> 0 THEN Str.Insert(FullPath,':\',0)
         ELSE Str.Insert(FullPath,':',0)
END;
answ:= GetCurrentDrive();
Str.Insert(FullPath,answ,0); FIO.ChDir('D:\DATA');

 wt_zasw:= Open(wd_zasw);
 Zasvetka();

 control_hormenu:= SetOnHorMenu(); (* откр все окна относящиеся к гориз меню *)
 control_downhlp:= SetOnDownhlp(); (* откр окна для подстрочной подсказки *)
 SetTitle(wt_hormenu,' Математическая обработка ',CenterUpperTitle);
 Change(wt_inverhormenu,4,2,9,2);
 substring:= 'Файл';
 a:= 1;
   Use(wt_hormenu); Clear();
      long:= 0; x:= 0;
     FOR i:= 0 TO 5 DO
       Str.ItemS(string,cont_math,'+',i);
       x:= x+ long+ 3;
       GotoXY(x,1); IO.WrStr(string);
       long:= Str.Length(string);
     END; (* for *)
       Use(wt_inverhormenu);  Clear(); TextColor(Black);
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
          |CHAR(27): EXIT
          |CHAR(13): Write_reg();
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
                       |1: InputShablon(5,'*.*+*.dat+*.df*+*.in*+*.sl*')
                       |2: InputDrive()
                       |3: EXIT
                     END; (* case *)
                   END; (* loop *)
 (* -- дифференцирование файлов ---------------------------------- *)
               |2: DownHelp120();
                   IF NOT File_error() THEN a:= 1;
                      ELSE Differen();
                   END; (* if *)
                   GOTO lab21;
 (* -- интегрирование файлов ------------------------------------- *)
               |3: DownHelp120();
                   IF NOT File_error() THEN a:= 1;
                      ELSE Integral();
                   END; (* if *)
                   GOTO lab21;
 (* -- cложение файлов ------------------------------------------- *)
               |4: shablon_g:= '*.dat';
                   SetTitle(wt_zasw,'',RightUpperTitle);
                (* --------- первое слагаемое ------- *)
                   DownHelpPlus1();
                   contdisk_contr:= GetContainsCurrentDisk(shablon_g);
                  IF contdisk_contr<> MAX(INTEGER)
                   THEN
                     Str.Copy(first_file,FileInformArray[contdisk_contr].Name);
                     Use(wt_inverhormenu); GotoXY(23,1); IO.WrStr(first_file);
                   ELSE GOTO lab21
                  END; (* if *)
                (* --------- второе слагаемое ------- *)
                   DownHelpPlus2();
                   contdisk_contr:= GetContainsCurrentDisk(shablon_g);
                  IF contdisk_contr<> MAX(INTEGER)
                   THEN
                     Str.Copy(second_file,FileInformArray[contdisk_contr].Name);
                     Use(wt_inverhormenu); IO.WrStr(' + ');
                                           IO.WrStr(second_file);
                  END; (* if *)
                (* ----------------- самое вычисление сложения ------------ *)
                  tmp:= Addit(TRUE,first_file,second_file);
                  FileInformArray[contdisk_contr].Name:= CHAR(0);
                  IF tmp<> 0 THEN Space_free(LONGINT(tmp)) END;
 (* -- вычитание файлов ------------------------------------------- *)
               |5: shablon_g:= '*.dat';
                   SetTitle(wt_zasw,'',RightUpperTitle);
                (* --------- первое слагаемое ------- *)
                   DownHelpPlus1();
                   contdisk_contr:= GetContainsCurrentDisk(shablon_g);
                  IF contdisk_contr<> MAX(INTEGER)
                   THEN
                     Str.Copy(first_file,FileInformArray[contdisk_contr].Name);
                     Use(wt_inverhormenu); GotoXY(23,1); IO.WrStr(first_file);
                   ELSE GOTO lab21
                  END; (* if *)
                (* --------- второе слагаемое ------- *)
                   DownHelpPlus2();
                   contdisk_contr:= GetContainsCurrentDisk(shablon_g);
                  IF contdisk_contr<> MAX(INTEGER)
                   THEN
                     Str.Copy(second_file,FileInformArray[contdisk_contr].Name);
                     Use(wt_inverhormenu); IO.WrStr(' - ');
                                           IO.WrStr(second_file);
                  END; (* if *)
                (* ----------------- самое вычисление сложения ------------ *)
                  tmp:= Addit(FALSE,first_file,second_file);
                  FileInformArray[contdisk_contr].Name:= CHAR(0);
                  IF tmp<> 0 THEN Space_free(LONGINT(tmp)) END;
               |6: EXIT
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
          Use(wt_inverhormenu); Clear(); TextColor(Black);
          Str.ItemS(substring,cont_math,'+',a-1);
          GotoXY(2,1); IO.WrStr(substring);
  END; (* loop *)

OutErase();
Close(wt_flwindow);
Close(wt_zasw);
Close(wt_attantion);
Close(wt_out);
CloseHorMenu();
FIO.ChDir(FullPath);

END Exmath.