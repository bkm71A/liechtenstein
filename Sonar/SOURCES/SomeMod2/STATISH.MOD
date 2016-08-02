IMPLEMENTATION MODULE statish ;

IMPORT FIO,IO,Str,MATHLIB;
FROM SearchFl IMPORT  FileInformArray;
FROM Probr_lb IMPORT  WaitingOn,WaitingOff,contdisk_contr,
                      wd_contain,wt_contain;
FROM _Window  IMPORT  Shadow;
FROM Window   IMPORT  Open,GotoXY,Use,Clear,SetTitle,CenterUpperTitle,PutOnTop,
                      Hide;

PROCEDURE stat();
VAR
 file:        FIO.File;
 computer:    LONGCARD;
 digit:       REAL;
 control:     CARDINAL;
 min,max,
 MO,D,ASSIM,
 EKC,M:       REAL;
 M1,M2,M3,M4: REAL;
 CKO:         LONGREAL;
 buf:         ARRAY [0..2047+FIO.BufferOverhead] OF BYTE;
 substring:   ARRAY [0..15] OF CHAR;
 stat:        ARRAY [0..4]  OF REAL;
 sh_waiting:  CARDINAL;
CONST
 contains= 'Матожидание...|'+
           'Дисперсия.....|'+
           'СKO...........|'+
           'Асимметрия....|'+
           'Эксцесс.......';

BEGIN
   max:= MIN(REAL);
   min:= MAX(REAL);
   MO:=  0.0 ;
   D:=   0.0 ;
   M1:=  0.0 ;
   M2:=  0.0 ;
   M3:=  0.0 ;
   M4:=  0.0 ;

sh_waiting:= WaitingOn();

(* ------------------ НАХОЖДЕНИЕ МАКСИМУМА И МИНИМУМА -------------------- *)
file:=FIO.Open(FileInformArray[contdisk_contr].Name);
FIO.AssignBuffer(file,buf);
FIO.Seek(file,80);
FIO.EOF:= FALSE;
LOOP
  control := FIO.RdBin(file,digit,4) ;
  IF FIO.EOF THEN  EXIT   END;
  IF max< digit THEN  max:= digit   END;
  IF min> digit THEN  min:= digit   END;
END ; (* loop *)
FIO.Close(file) ;

file:=FIO.Open(FileInformArray[contdisk_contr].Name);
FIO.AssignBuffer(file,buf) ;
FIO.Seek(file,80);
FIO.EOF:= FALSE;
LOOP
  control := FIO.RdBin(file,digit,4) ;
  IF FIO.EOF THEN EXIT  END;
  M1 := M1 + digit;                        (* накопление 1-й степени *)
  M2 := M2 + digit*digit;                  (* накопление 2-й степени *)
  M3 := M3 + digit*digit*digit;            (* накопление 3-й степени *)
  M4 := M4 + digit*digit*digit*digit;      (* накопление 4-й степени *)
END; (* loop *)
FIO.Seek(file,26);
control:= FIO.RdBin(file,computer,4);
FIO.Close(file);

(* ------------------- вычисление матожидания ---------------------  *)
stat[0]:= M1/REAL(computer);
(* ------------------- вычисление дисперсии -----------------------  *)
stat[1]:= M2/REAL(computer)- MO*MO;
(* ------------------- вычисление СКО -----------------------------  *)
stat[2]:= REAL(MATHLIB.Sqrt(LONGREAL(D)));
(* ------------------- вычисление ассимметрии ---------------------  *)
stat[3]:= ((M3-3.0*MO*M2)/REAL(computer)+2.0*MO*MO*MO)/REAL(CKO*CKO*CKO);
(* ------------------- вычисление эксцесса ------------------------  *)
stat[4]:= ((M4-4.0*MO*M3+6.0*MO*MO*M2)/REAL(computer)-3.0*MO*MO*MO*MO)/
            REAL(CKO*CKO*CKO*CKO)-3.0;

WaitingOff(sh_waiting);

SetTitle(wt_contain,' Стат. характеристики ',CenterUpperTitle);
Shadow(wt_contain);
PutOnTop(wt_contain);
Clear();
(*
Use(wt_contain);
*)
FOR control:= 0 TO 4 DO
 Str.ItemS(substring,contains,'|',INTEGER(control));
 GotoXY(2,INTEGER(control)+2);
 IO.WrStr(substring);
 IO.WrReal(stat[control],8,12);
END; (* for *)
END stat ;

BEGIN

wt_contain:= Open(wd_contain) ;

END statish.