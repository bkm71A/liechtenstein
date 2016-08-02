IMPLEMENTATION MODULE Normal;
IMPORT FIO, IO;
FROM MATHLIB   IMPORT Sqrt,Exp;
FROM Lib       IMPORT Delay,Sound,NoSound;
FROM Sounds    IMPORT Siren;
FROM _Window   IMPORT Shadow;
FROM TxtImage  IMPORT SaveScreen,RestoreScreen;
FROM SearchFl  IMPORT FileInformArray;
FROM Probr_lb  IMPORT WaitingOn,WaitingOff,wt_contain,contdisk_contr;



PROCEDURE Check_hi2(value: INTEGER);
VAR
   file:            FIO.File;
   control:         CARDINAL;
   control_shadow:  CARDINAL;
   quant:           CARDINAL;
   liberty:         CARDINAL;
   i,j:             INTEGER;
   expr_hi2:        REAL;
   teor_hi2:        REAL;
   max,min:         REAL;
   deltaX,deltaY:   REAL;
   digit,lbor,hbor: REAL;
   answ:            CHAR;
   computer:        ARRAY [1..16] OF REAL;
   border:          ARRAY [1..16] OF REAL;
BEGIN
SaveScreen();
control_shadow:= WaitingOn();
file:= FIO.Open(FileInformArray[contdisk_contr].Name);
(* FIO.AssignBuffer(file,buffer); *)
FIO.Seek(file,26);
  control:= FIO.RdBin(file,quant,2);
FIO.Seek(file,36);
  control:= FIO.RdBin(file,min,4);
  control:= FIO.RdBin(file,max,4);
deltaX:=  (max - min) / 16.;
FOR i:= 1 TO 16 DO  computer[i]:= 0.  END;

FIO.Seek(file,80);
LOOP
  control := FIO.RdBin(file,digit,4);
  IF FIO.EOF THEN EXIT END;
  lbor:= min;
  hbor:= min + deltaX;
  i:= 1;
    LOOP
       IF (digit>= lbor) AND (digit< hbor)
                THEN  computer[i]:= computer[i] + 1. ;
                EXIT;
          ELSIF i= 16 THEN EXIT
          ELSE  lbor:= hbor;
                hbor:= hbor + deltaX;
                INC(i);
       END; (* if *)
    END; (* loop *)
END; (* loop *)

  lbor:= min;
  hbor:= min + deltaX;
  border[1]:= min;
  liberty:= 1;
  i:= 1;
REPEAT
 IF computer[i]> 5. THEN  INC(liberty);
                          border[liberty+1]:= hbor;
                          lbor:= hbor;
                          hbor:= hbor+ deltaX;
                    ELSE  computer[i+1]:= computer[i+1]+ computer[i];
                          hbor:= hbor+ deltaX;
 END; (* if *)
 INC(i);
UNTIL(hbor>= max);
FIO.Close(file);
(* -------------------------- формулa hi2 -------------------------------- *)
expr_hi2:=  0.;
FOR i:= 1 TO liberty DO
 digit:=
 REAL(1./Sqrt(6.28)*Exp(-( LONGREAL(border[i+1])*LONGREAL(border[i+1]) / 2. )) -
      1./Sqrt(6.28)*Exp(-( LONGREAL(border[i]) * LONGREAL(border[i]) / 2. )));
 computer[i]:=(computer[i] * computer[i] / REAL(quant) / digit) - REAL(quant);
 expr_hi2:=  expr_hi2+ computer[i];
 lbor:= hbor;
 hbor:= hbor + deltaX;
END; (* for *)

file:= FIO.Open('d:\jpi\tbl\liberty.tbl');
FIO.Seek(file,LONGCARD((liberty-3)*12+CARDINAL(value)));
teor_hi2:= FIO.RdReal(file);

IF expr_hi2<= teor_hi2 THEN Siren();
 ELSE Sound(300);
      Delay(1000);
      NoSound();
END; (* if *)
WaitingOff(control_shadow);
RestoreScreen();
FIO.Close(file);

END Check_hi2;






PROCEDURE Check_shed();
BEGIN
END Check_shed;

BEGIN
 alfa[0]:=   0.99;
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

END Normal.