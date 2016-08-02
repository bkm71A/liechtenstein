MODULE Exstat; (* ---- основное тело программы статистической обработки ---- *)

IMPORT _Int24;
IMPORT IO,FIO,Str;

FROM Probr_lb  IMPORT SetOnHorMenu,SetOffHorMenu,File_error,Soundock,Space_free,
                      Zaglu,InputShablon,InputDrive,File_menu,
                      contdisk_contr,control_stat,stat_control,
                      wt_hormenu,wt_inverhormenu,wt_zasw,wd_zasw,
                      shablon_g,wt_attantion;
(*  ------------ Statistics Convertional ------------------  *)
FROM Lawid    IMPORT IntDif_law;
FROM Normal   IMPORT Check_shed,Check_hi2;
FROM statish  IMPORT stat,wt_contain;
FROM Down_hlp IMPORT SetOnDownhlp,SetOffDownhlp,DownHelpAny,
                     DownHelp0, DownHelp011,DownHelp02,DownHelp03,(*DownHelp031,*)
                     DownHelp04,DownHelp120,DownHelp220_30,wt_downhlp;
FROM SearchFl IMPORT GetContainsCurrentDisk,GetCurrentDrive,
                     FileInformArray,FullPath,wt_flwindow;
FROM _Window  IMPORT Open_Shadow,Close_Shadow,Shadow;
FROM Window   IMPORT WinType,WinDef,Open,Close,PutOnTop,Hide,Color,TextColor,
                     SetTitle,CenterUpperTitle,RightUpperTitle,
                     SingleFrame,DoubleFrame,Use,GotoXY,Clear,Change,At;
VAR
 answ:                                           CHAR;
 control_wait:                                   CARDINAL; (* тень *)
 control_hormenu:                                CARDINAL; (* тень *)
 control_downhlp:                                CARDINAL; (* тень *)
 i,a,x,long:                                     INTEGER;
 substring,string:                               ARRAY [0..25] OF CHAR;
 str_shablon:                                    ARRAY [0..45] OF CHAR;
 space,dlinna:                                   INTEGER;
 shadow_o:                                       CARDINAL;
 wt_out:                                         WinType;
 out_name:                                       ARRAY [0..12] OF CHAR;
CONST
 wd_out= WinDef(12,8,68,13,White,Blue,FALSE,FALSE,TRUE,TRUE,SingleFrame,Cyan,Blue);
 cont_stat ='Файл+З-н распред.+Пров-ка нормальн.+Выход';
LABEL
 lab0,lab01;

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

PROCEDURE Zasvetka();
VAR x: CARDINAL;
BEGIN
  FOR x:= 1 TO 23  DO
     GotoXY(1,x);
     IO.WrCharRep('░',80)
  END;
END Zasvetka;

PROCEDURE Output1();
BEGIN
  DownHelpAny();
  wt_out:= Open(wd_out);
  Change(wt_out,15,9,65,11);
  PutOnTop(wt_out);
  shadow_o:= Open_Shadow(wt_out);
TextColor(White);
  GotoXY(3,1); IO.WrStrAdj('Имя выходного файла' ,-32);
TextColor(LightMagenta);
  IO.WrStr(out_name);
END Output1;

PROCEDURE Control();
VAR
  answ: CHAR;
BEGIN
 IF space<> 0
    THEN  Space_free(LONGINT(space))
    ELSE  Output1();
          answ:= IO.RdCharDirect();
          Close(wt_out);
          Close_Shadow(shadow_o)
 END;
END Control;


BEGIN  (* ---------------- начало основного тела программы ----------------- *)
FIO.GetDir(0,FullPath);
a:= Str.Length(FullPath);
IF a<> 0 THEN Str.Insert(FullPath,':\',0)
         ELSE Str.Insert(FullPath,':',0)
END;
answ:= GetCurrentDrive();
Str.Insert(FullPath,answ,0);
FIO.ChDir('D:\DATA');
  wt_zasw:= Open(wd_zasw);
  Zasvetka();
(* ------------- начальный вывод горизонтального меню на экран ------------ *)
  control_hormenu:= SetOnHorMenu(); (* откр все окна относящиеся к гориз меню *)
  control_downhlp:= SetOnDownhlp(); (* откр окна для подстрочной подсказки *)
  SetTitle(wt_hormenu,' Статистическая обработка ',CenterUpperTitle);
lab0:
  Change(wt_inverhormenu,4,2,9,2);
  substring:= 'Файл';
  a:= 1;
  Use(wt_hormenu); Clear();
  long:= 0; x:= 0;
    FOR i:= 0 TO 2 DO
       Str.ItemS(string,cont_stat,'+',i);
       x:= x+ long+ 3;
       GotoXY(x,1);  IO.WrStr(string);
       long:= Str.Length(string);
    END; (* for *)
    Str.ItemS(string,cont_stat,'+',3);
    GotoXY(66,1);  IO.WrStr(string);
    Use(wt_inverhormenu);  Clear();
    GotoXY(2,1);  IO.WrStr(substring);
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
                                stat_control:= FALSE;
                                Hide(wt_contain);
                          ELSE  dlinna:= Str.Length(FileInformArray[contdisk_contr].Name);
                               LOOP
                                CASE FileInformArray[contdisk_contr].Name[dlinna-2]
                                    OF 'a','A': Write_filename();
                                                stat_control:= TRUE;
                                                EXIT
                                    ELSE space:= -6;
                                         Control();
                                         a:= 1;
                                         GOTO lab01
                                END; (* case *)
                               END; (* loop *)
                         END; (* if *)
                         IF stat_control THEN Hide(wt_contain); stat() END;
                         GOTO lab01;
                     |1: InputShablon(1,'*.dat')
                     |2: InputDrive()
                     |3: EXIT
                  END; (* case *)
                 END; (* loop *)
                |2: DownHelp02();
                  IF NOT File_error() THEN  a:= 1; GOTO lab01 END;
                  LOOP
                  answ:= IO.RdCharDirect();	
                   CASE answ OF
                    'I','i','D','d': IntDif_law(answ);
                   |CHAR(27):        GOTO lab01
                   END; (* case *)
                  END; (* loop *)
                |3:
                  IF NOT File_error() THEN  a:= 1; GOTO lab01 END;
                  LOOP
                   DownHelp03();
                   answ:= IO.RdCharDirect();	
                   CASE answ OF
                    'H','h': Check_hi2();
                   |'S','s': Check_shed();
                   |CHR(27): GOTO lab01
                   END; (* case *)
                  END; (* loop *)
                |4: EXIT
              END; (* case *)
     END; (* case *)
lab01:    IF a< 1 THEN a:= 4 END;
          IF a> 4 THEN a:= 1 END;
          CASE a OF
             1:  Change(wt_inverhormenu,4,2,9,2);
            |2:  Change(wt_inverhormenu,11,2,24,2);
            |3:  Change(wt_inverhormenu,26,2,44,2);
            |4:  Change(wt_inverhormenu,67,2,73,2);
          END; (* case *)
          Use(wt_inverhormenu); Clear();
          Str.ItemS(substring,cont_stat,'+',a-1);
          GotoXY(2,1); IO.WrStr(substring);
END; (* loop *)


CloseHorMenu();
Close(wt_flwindow);
Close(wt_zasw);
Close(wt_contain);
Close(wt_attantion);
FIO.ChDir(FullPath);

END Exstat.