(* ---------------------- Полностью готово ------------------------------ *)

IMPLEMENTATION MODULE Lawid; (* Дифференц. и интегральный з-ны распределения *)
IMPORT FIO,IO,Str;
FROM   Graph     IMPORT EGAGraphMode,TextMode,Line,HLine;
FROM   Assa      IMPORT Print_ready,Screen;
FROM   GraphVl   IMPORT OutText,PunkHLine,PunkVLine;
FROM   Window    IMPORT CursorOff;
FROM   SearchFl  IMPORT FileInformArray;
FROM   TxtImage  IMPORT SaveScreen,RestoreScreen;
FROM   Probr_lb  IMPORT WaitingOn,WaitingOff,Printer,wt_contain,contdisk_contr;

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

PROCEDURE Trafaret(ARRAYY: ARRAY OF LONGINT; ARRAYX: ARRAY OF REAL);
VAR
  i:    INTEGER;
  ok:   BOOLEAN;
  str:  ARRAY [1..10] OF CHAR;
BEGIN
FOR i:= 46 TO 558 BY 32 DO
   PunkVLine(22,i,316,2,8);
   CASE i OF
            46,174,302,430,558: Line(i,316,i,320,7);
                                Line(i+1,316,i+1,320,7);
   END; (* case *)
END;
FOR i:= 316 TO 21 BY -42 DO
   PunkHLine(40,i,558,3,8);
END;
 i:= 7;
  Line(45,10,45,315,i);   HLine(45,315,569,i);    (* координатные оси *)
  Line(47,10,47,317,i);   HLine(45,317,569,i);
  Line(43,12,46,9,i);     Line(567,313,570,316,i);
  Line(46,12,46,9,i);     Line(46,316,570,316,i);
  Line(49,12,46,9,i);     Line(567,319,570,316,i);
FOR i:= 7 TO 0 BY -1  DO
 Str.IntToStr(ARRAYY[i],str,10,ok);
 OutText(0,0,SHORTCARD(i*3+1),83H,str);
END;
FOR i:= 0 TO 4 DO
 Str.RealToStr(LONGREAL(ARRAYX[i]),2,FALSE,str,ok);
 OutText(0,1+SHORTCARD(i*16),23,83H,str);
END;
END Trafaret;


PROCEDURE IntDif_law(law_name: CHAR);
VAR
   file:            FIO.File;
   control:         CARDINAL;
   control_shadow:  CARDINAL;
   begin:           CARDINAL;
   i,j,x1,x2,y:     INTEGER;
   max,min:         REAL;
   deltaX,deltaY:   REAL;
   digit,lbor,hbor: REAL;
   answ:            CHAR;
   computer:        ARRAY [1..16] OF LONGINT;
   arrayY:          ARRAY [0..7]  OF LONGINT;
   arrayX:          ARRAY [0..4]  OF REAL;
BEGIN
SaveScreen();
control_shadow:= WaitingOn();
file:= FIO.Open(FileInformArray[contdisk_contr].Name);
FIO.AssignBuffer(file,buffer);
FIO.Seek(file,36);
  control := FIO.RdBin(file,min,4);
  control := FIO.RdBin(file,max,4);
  deltaX:= (max - min) / 16.;
FOR i:= 0 TO 16 BY 4 DO
 arrayX[i>>2]:= min + REAL(i) * deltaX
END;
FOR i:= 1 TO 16 DO  computer[i]:= 0  END;
FIO.Seek(file,80);
LOOP
  control := FIO.RdBin(file,digit,4);
  IF FIO.EOF THEN EXIT END;
  lbor:= min;
  hbor:= min + deltaX;
  i:= 1;
 LOOP
   IF (digit>= lbor) AND (digit<= hbor)
     THEN  INC(computer[i]);
           EXIT;
     ELSIF i= 16 THEN EXIT
     ELSE  lbor:= hbor;
           hbor:= hbor + deltaX;
           INC(i);
   END; (* if *)
  END; (* loop *)
END; (* loop *)
FIO.Close(file);
IF (law_name= 'i') OR (law_name= 'I') THEN
    FOR i:= 1 TO 16 DO
      computer[i+1]:=  computer[i]+ computer[i+1]
    END; (* for *)
END; (* if *)
lbor:= min;
(* -------- пересчет количества попаданий в координаты экрана ------- *)
max:= MIN(REAL);
FOR i:= 1 TO 16 DO
  IF REAL(computer[i])> max THEN  max:= REAL(computer[i]) END;
END; (* for *)
deltaY:= max / 289.;
max:= max/7. ;
FOR i:= 7 TO 0 BY -1 DO
 arrayY[i]:= LONGINT( max * REAL(7-i) );
END; (* for *)
WaitingOff(control_shadow);
EGAGraphMode;
OutText(0,30,0,8FH,'имя файла -');
OutText(0,42,0,8CH,FileInformArray[contdisk_contr].Name);
DownHelp();
x1:= 46;
x2:= 78;
FOR i:= 1 TO 16 DO
computer[i]:= LONGINT(REAL(computer[i]) / deltaY);
 FOR j:= 313 TO 313-INTEGER(computer[i]) BY -1 DO
   HLine(x1,j,x2,9);
 END; (* for *)
x1:= x2+1;
x2:= x2+32;
END; (* for *)
Trafaret(arrayY,arrayX);
Printer(IO.RdCharDirect());
TextMode();
RestoreScreen();
CursorOff();
END IntDif_law;

END Lawid.