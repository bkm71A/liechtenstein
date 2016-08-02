(* ----------- Отображение текущего процесса линейкой на экране ------------ *)
IMPLEMENTATION MODULE Current;

FROM Timer     IMPORT Ystanovka,Reset;
FROM Lib       IMPORT Sound,NoSound,Delay;
FROM IO        IMPORT WrCard,WrChar,WrCharRep,WrStr,RdCharDirect;
FROM Window    IMPORT WinType,WinDef,Open,Close,Clear,TextColor,TextBackground,
                      Color,GotoXY,SingleFrame,Use;

PROCEDURE InitScr();
VAR
 answ: CHAR;
BEGIN
 i:= 0;
 aa:=0;
 wt_line:= Open(wd_line);
 Use(wt_line);
 GotoXY(1,1); WrCharRep('█',2);
 TextColor(Black); TextBackground(LightGray); WrCharRep('░',64);
 TextColor(White); TextBackground(Red);       GotoXY(70,1); WrStr(' % ');
 GotoXY(1,1);
 Ystanovka();
END InitScr;

PROCEDURE LineMov();
VAR prom: CARDINAL;
BEGIN
IF aa> i THEN
  prom:= aa- i;
  TextColor(Red);      GotoXY(i+2,1); WrCharRep('█',prom);
  i:= i+ prom;
  TextColor(White);  TextBackground(Red); GotoXY(67,1);
  IF aa>= 62 THEN WrCard(100,3);
                  TextColor(Red); GotoXY(63,1); WrStr('████')
             ELSE WrCard(CARDINAL(REAL(i)/64.*100.),3);
  END;
END;
END LineMov;

PROCEDURE Soundend();
 VAR i: CARDINAL;
BEGIN
 FOR i:= 1 TO 300 BY 10 DO
  Sound(i* 10);
  Delay(25+ 300 DIV i);
 END;
 NoSound;
END Soundend;


PROCEDURE DeInitScr();
VAR answ: CHAR;
BEGIN
 Reset();
 Soundend();
 Close(wt_line);
END DeInitScr;

END Current.