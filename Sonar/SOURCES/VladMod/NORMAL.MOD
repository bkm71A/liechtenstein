IMPLEMENTATION MODULE Normal;
IMPORT FIO,IO,Str;
FROM Lib       IMPORT Delay,Sound,NoSound;
FROM _Window   IMPORT Open_Shadow,Close_Shadow;
FROM TxtImage  IMPORT SaveScreen,RestoreScreen;
FROM SearchFl  IMPORT FileInformArray;
FROM Probr_lb  IMPORT Space_free,WaitingOn,WaitingOff,
                      wt_inverhormenu,contdisk_contr;
FROM Gauss     IMPORT prover;
FROM Edjv      IMPORT Charly;
FROM Down_hlp  IMPORT DownHelpAny;
FROM Window    IMPORT WinType,WinDef,Open,Close,Color,TextColor,SingleFrame,
                      GotoXY,Use,Clear;

PROCEDURE Check_hi2();
VAR
 control_sh:       CARDINAL;
 control:          CARDINAL;
 ret:              REAL;
 answ:             CHAR;
 wt_hi2:           WinType;
CONST
 wd_hi2= WinDef(37,6,75,11,White,Blue,FALSE,FALSE,FALSE,TRUE,SingleFrame,Yellow,Blue);
BEGIN
 Use(wt_inverhormenu); Clear();
 IO.WrStr(' Проверка на нормальность по Hi^2');
 SaveScreen();
 control_sh:= WaitingOn();
 control:= prover(FileInformArray[contdisk_contr].Name,ret);
 WaitingOff(control_sh);
 RestoreScreen();
 IF     control= 1 THEN Space_free(-14); RestoreScreen();
  ELSIF control= 2 THEN Space_free(-15); RestoreScreen();
  ELSE  wt_hi2:= Open(wd_hi2);
        GotoXY(1,1);  IO.WrStr('Гипотеза о нормальности распределения');
        GotoXY(10,2); IO.WrStr('верна с вероятностью');
        TextColor(Yellow);
        GotoXY(1,3);  IO.WrCharRep('─',37);
        TextColor(LightMagenta);
        ret:= ABS(ret);
        GotoXY(15,4); IO.WrReal(ret,3,7);
        control:= Open_Shadow(wt_hi2);
        DownHelpAny();
        answ:= IO.RdCharDirect();
        Close_Shadow(control);
        Close(wt_hi2);
 END; (* if *)

Use(wt_inverhormenu); Clear();
IO.WrStr(' Проверка на нормальность');
END Check_hi2;


PROCEDURE Check_shed();
VAR
 answ:        CHAR;
 i:           CARDINAL;
 control:     CARDINAL;
 control_sh:  CARDINAL;
 str:         ARRAY [0..4]  OF CHAR;
 charl:       ARRAY [0..7]  OF REAL;
 wt_charl:    WinType;
CONST
 wd_charl= WinDef(37,6,75,17,White,Blue,FALSE,FALSE,FALSE,TRUE,SingleFrame,Yellow,Blue);
 m= '-2.0,-1.5,-1.0,-0.5,0.0,0.5,1.0,1.5,2.0';
BEGIN
 Use(wt_inverhormenu); Clear();
 IO.WrStr(' Проверка на нормальность по Шарлье-Эджворту');
 SaveScreen();
 control_sh:= WaitingOn();
 Charly(FileInformArray[contdisk_contr].Name,charl);
 WaitingOff(control_sh);
 RestoreScreen();
 wt_charl:= Open(wd_charl);
 control:= Open_Shadow(wt_charl);
 Use(wt_charl);
 GotoXY(1,1);  IO.WrStr('Границы интервалов   Величина расхожд');
 TextColor(Yellow); GotoXY(20,0); IO.WrChar('╥');
                    GotoXY(20,1); IO.WrChar('║');
                    GotoXY(20,2); IO.WrChar('║');
                    GotoXY(1,2);  IO.WrStr('─────────┬─────────╫─────────────────');
 FOR i:= 0 TO 7 DO
  GotoXY(1,i+3);
  Str.ItemS(str,m,',',i);   TextColor(White);        IO.WrStrAdj(str,6);
                            TextColor(Yellow);       IO.WrStrAdj('│',4);
  Str.ItemS(str,m,',',i+1); TextColor(White);        IO.WrStrAdj(str,6);
                            TextColor(Yellow);       IO.WrStrAdj('║',4);
                            TextColor(LightMagenta); IO.WrReal(charl[i],5,14);
 END;
 TextColor(Yellow); GotoXY(20,16); IO.WrChar('║');
                    GotoXY(20,17); IO.WrChar('╨');
                    GotoXY(10,16); IO.WrChar('│');
                    GotoXY(10,17); IO.WrChar('┴');
 DownHelpAny();
 answ:= IO.RdCharDirect();
 Use(wt_inverhormenu); Clear();
 IO.WrStr(' Проверка на нормальность');
 Close(wt_charl);
 Close_Shadow(control);
END Check_shed;

BEGIN
(* alfa[0]:=   0.99;
   alfa[1]:=   0.95;
   alfa[2]:=   0.80;
   alfa[3]:=   0.70;
   alfa[4]:=   0.50;
   alfa[5]:=   0.30;
   alfa[6]:=   0.20;
   alfa[7]:=   0.10;
   alfa[8]:=   0.05;
   alfa[9]:=   0.02;
   alfa[10]:=  0.005;
   alfa[11]:=  0.001;
*)
END Normal.