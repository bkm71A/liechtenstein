(* ---------------------- Полностью готово ------------------------------ *)

IMPLEMENTATION MODULE Lawid; (* Дифференц. и интегральный з-ны распределения *)
IMPORT FIO,IO,Str,Assa;
FROM   Window    IMPORT Use,Clear;
FROM   Graph     IMPORT EGAGraphMode,TextMode,Line,HLine;
(* FROM   Assa      IMPORT Print_ready,Screen; *)
FROM   GraphVl   IMPORT OutText,PunkHLine,PunkVLine,PolygonFr;
FROM   GraphSk   IMPORT Put_Image,Get_Image;
FROM   Window    IMPORT CursorOff,GotoXY,TextColor,TextBackground,
                        Color,Open,Close,PutOnTop;
FROM   _Window   IMPORT Close_Shadow,Open_Shadow ;
FROM   SearchFl  IMPORT FileInformArray;
FROM   TxtImage  IMPORT SaveScreen,RestoreScreen;
FROM   AsmImage  IMPORT WriteStr_XY;
FROM   Down_hlp  IMPORT wt_downhlp,DownHelpLaw;
FROM   Probr_lb  IMPORT Space_free,WaitingOn,WaitingOff,Soundock,
                        wt_inverhormenu,contdisk_contr;
FROM   statish   IMPORT wt_contain;
FROM   PrnEt     IMPORT PrintEtik;
                 IMPORT AsmPrint ;
                 IMPORT Lib ;
VAR col_otr   : CARDINAL ;

PROCEDURE DownHelp();
VAR i:   INTEGER;
BEGIN
 FOR i:= 336 TO 349 DO
  HLine(8,i,590,6);
 END; (* for *)
 OutText(0,12,24,89H,'[P,p] -');
 OutText(0,20,24,86H,'печать');
 OutText(0,52,24,89H,'[Esc] -');
 OutText(0,60,24,86H,'выход');
END DownHelp;

PROCEDURE Trafaret(ARRAYY: ARRAY OF REAL; ARRAYX: ARRAY OF REAL);
VAR
  i,j:    INTEGER;
  ok:     BOOLEAN;
  str:    ARRAY [1..10] OF CHAR;
  k:      SHORTCARD ;
BEGIN
(* рисуем вертикальные линии*)
j:=INTEGER(512 DIV col_otr)-1 ;
k:=0 ;
FOR i:= 46 TO 558 DO
   PunkVLine(22,i,316,2,8) ;

   IF (k MOD 10)=0 THEN
       Line(i,316,i,320,7); Line(i+1,316,i+1,320,7);
   END; (* if *)

   i:=i+j ;
   k:=k+1 ;
   IF k=SHORTCARD(col_otr+1) THEN
         k:=SHORTCARD(i DIV 8) ;
         i:=559 ;
   END ;
END;
(* рисуем горизонтальные линии *)
FOR i:= 316 TO 21 BY -42 DO
   PunkHLine(40,i,CARDINAL(k)*8,3,8);
END;
 i:= 7;
  Line(45,10,45,315,i);   HLine(45,315,569,i);    (* координатные оси *)
  Line(47,10,47,317,i);   HLine(45,317,569,i);
  Line(43,12,46,9,i);     Line(567,313,570,316,i);
  Line(46,12,46,9,i);     Line(46,316,570,316,i);
  Line(49,12,46,9,i);     Line(567,319,570,316,i);

FOR i:= 7 TO 0 BY -1  DO
 Str.FixRealToStr(LONGREAL(ARRAYY[i]),3,str,ok);
 OutText(0,0,SHORTCARD(i*3+1),8BH,str);
END;

Str.RealToStr(LONGREAL(ARRAYX[0]),2,FALSE,str,ok);
OutText(0,1,23,8BH,str);
OutText(0,(k DIV 2 -8),23,8BH,'шаг гистограммы');
Str.RealToStr(LONGREAL(ARRAYX[1]),2,FALSE,str,ok);
OutText(0,(k DIV 2+8),23,8BH,str);
Str.RealToStr(LONGREAL(ARRAYX[2]),2,FALSE,str,ok);
OutText(0,(k-4),23,8BH,str);

END Trafaret;

PROCEDURE vvod_col_otr() : CARDINAL ;
VAR WW     : WinDef ;
    Www    : WinType ;
    w      : CARDINAL ;
LABEL  M1 ;
BEGIN
    WW:= WinDef(50,6,63,8,White,Blue,FALSE,TRUE,FALSE,TRUE,
                SingleFrame,Yellow,Blue);
    Www:= Open(WW);
    w:= Open_Shadow(Www);
    Use(Www);
M1: GotoXY(6,1);
    col_otr:= IO.RdCard();
    IF (col_otr<8) OR (col_otr>255) OR (NOT IO.OK) THEN
         Lib.Sound(300) ;
         Lib.Delay(100) ;
         Lib.NoSound() ;
         Clear ;
         GOTO M1;
    END;
    Close_Shadow(w);
    Close(Www) ;
RETURN col_otr ;
END vvod_col_otr ;

PROCEDURE IntDif_law(law_name: CHAR);
VAR
   file:            FIO.File;
   size:            LONGCARD;
   lbegin:          LONGCARD;
   diskret:         CARDINAL;
   polz,prom:       CARDINAL;
   x_coord:         CARDINAL;
   begin:           CARDINAL;
   control:         CARDINAL;
   control_shadow:  CARDINAL;
   i,j,x1,x2,y:     INTEGER;
   x11,x22:         REAL ;
   max,min:         REAL;
   deltaX,deltaY:   REAL;
   digit,lbor,hbor: REAL;
   answ:            CHAR;
   computer:        ARRAY [1..256] OF LONGINT;
   arrayY:          ARRAY [0..7]  OF REAL ;
   arrayX:          ARRAY [0..2]  OF REAL ;

BEGIN
SaveScreen();
Use(wt_inverhormenu); Clear();
CASE law_name OF
         'i','I' : IO.WrStr(' Вычисление интегрального закона распpеделения');
        |'d','D' : IO.WrStr(' Вычисление дифференциального закона распpеделения');
END; (* case *)

DownHelpLaw();
col_otr:= vvod_col_otr() ;

control_shadow:= WaitingOn();
file:= FIO.Open(FileInformArray[contdisk_contr].Name);
FIO.AssignBuffer(file,buffer);
FIO.Seek(file,26);  control:= FIO.RdBin(file,size,4);
FIO.Seek(file,32);  control:= FIO.RdBin(file,begin,2); lbegin:= LONGCARD(begin);
FIO.Seek(file,36);  control:= FIO.RdBin(file,min,4);
                    control:= FIO.RdBin(file,max,4);
                    deltaX:= REAL(max - min) /REAL(col_otr);
(* -------------- подготовка к рисованию ползунка --------------------- *)
  x_coord:= 1;
  polz:= 0;
  prom:= 1;
  diskret:= CARDINAL(size) DIV 66;
  Use(wt_downhlp);
  GotoXY(0,1);  TextBackground(LightGray); TextColor(Black); IO.WrCharRep('░',66);
  GotoXY(71,1); TextBackground(Red);       TextColor(White); IO.WrStr(' %  ');
(* -------------------------------------------------------------------- *)
(*
FOR i:= 0 TO col_otr BY 4 DO
 arrayX[i>>2]:= min + REAL(i) * REAL(deltaX) ;
END;
*)
arrayX[0]:=min;
arrayX[1]:=deltaX;
arrayX[2]:=max;
FOR i:= 1 TO col_otr DO  computer[i]:= 0  END;
FIO.Seek(file,lbegin);
LOOP
  control:= FIO.RdBin(file,digit,4);
  INC(prom);
  lbor:= REAL(min);
  hbor:= REAL(min) + deltaX;
  i:= 1;
 LOOP
   IF (digit> lbor) AND (digit<= hbor)
     THEN  INC(computer[i]);
           INC(polz);
           EXIT;
     ELSIF i> INTEGER(col_otr) THEN EXIT
     ELSE  lbor:= hbor;
           hbor:= hbor + deltaX;
           INC(i);
   END; (* if *)
 END; (* loop *)

 IF (polz>= diskret) THEN
    Use(wt_downhlp);
    TextColor(Red);   GotoXY(x_coord,1); IO.WrChar('█');
    TextColor(White); GotoXY(66,1);
    IF x_coord<= 66
       THEN  IO.WrCard(CARDINAL(REAL(x_coord)/66.*100.),5);
             INC(x_coord);
    END; (* if *)
    polz:= 0;
 END; (* if *)
 IF prom= CARDINAL(size) (* в маленьких файлах, когда точек меньше 66 *)
     THEN TextColor(Red);   GotoXY(0,1);  IO.WrCharRep('█',66);
          TextColor(White); GotoXY(66,1); IO.WrCard(100,5);
 END; (* if *)
IF FIO.EOF THEN EXIT END;
END; (* loop *)
(* computer[col_otr]:=computer[col_otr]+1 ;*)
FIO.Close(file);
(* -- восстанавливаем цвета в окне подсказки ипользованном ползунком -- *)
  Use(wt_downhlp);
  TextColor(White);
  TextBackground(Brown);
(* -------------------------------------------------------------------- *)
IF (law_name= 'i') OR (law_name= 'I') THEN
    FOR i:= 1 TO col_otr DO
      computer[i+1]:=  computer[i]+ computer[i+1] ;
    END; (* for *)
END; (* if *)


lbor:= min;
(* -------- пересчет количества попаданий в координаты экрана ------- *)
max:= MIN(REAL);
FOR i:= 1 TO col_otr DO
  IF REAL(computer[i])> max THEN max:=REAL(computer[i]) END;
END; (* for *)
deltaY:=max / 289.;
max   := max / 7.  ;
FOR i:= 7 TO 0 BY -1 DO
 arrayY[i]:= REAL( max * REAL(7-i) )/REAL(size) ;
END; (* for *)
IF (law_name= 'i') OR (law_name= 'I') THEN
   arrayY[0]:=1.;
END ; (* IF *)
WaitingOff(control_shadow);
EGAGraphMode;
OutText(0,30,0,8FH,'имя файла -');
OutText(0,42,0,8CH,FileInformArray[contdisk_contr].Name);
DownHelp();
x1:=46;
x2:= x1+INTEGER(512 DIV col_otr);
FOR i:= 1 TO col_otr DO
  computer[i]:= LONGINT(REAL(computer[i]) / REAL(deltaY));
  FOR j:= 313 TO 313-INTEGER(computer[i]) BY -1 DO
      HLine(x1,j,x2,9);
  END; (* for *)
  x1:= x2+1;
  x2:= x2+INTEGER(512 DIV col_otr);
END; (* for *)
Trafaret(arrayY,arrayX);
LOOP
answ:= IO.RdCharDirect();
 CASE answ OF   'p','P':
 (* ---------- печатаем сначала этикетку а потом график ---------------- *)
                        IF AsmPrint.Ready()= 0FFH THEN
                         i:= PrintEtik(4,FileInformArray[contdisk_contr].Name);
                         AsmPrint.Print_In_File(4) ;
                         EXIT
                         ELSE Soundock();
                        END; (* if *)
             |CHAR(27): EXIT
 END; (* case *)
END; (* loop *)

(* ------------ место для вставки печати экрана и этикетки -------------- *)
TextMode();
RestoreScreen();
CursorOff();
END IntDif_law;

END Lawid.