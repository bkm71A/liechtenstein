IMPLEMENTATION MODULE Edjv;
IMPORT MATHLIB,FIO,IO;
FROM Down_hlp IMPORT wt_downhlp;
FROM Probr_lb IMPORT Space_free;
FROM Window   IMPORT Use,Color,TextColor,TextBackground,GotoXY;

PROCEDURE Charly(VAR sname:ARRAY OF CHAR;VAR del:ARRAY OF REAL);
(* Входные : файл даннных REAL,c этикеткой          *)
(*Выход:  массив дельта                             *)
VAR  i,rsize               : LONGCARD;(*счетчик цикла,pазмеp файла*)
     computer,diskret:       LONGCARD;
     x_coord:                CARDINAL;
     A,B                   : ARRAY[0..7] OF REAL;
     res,j,commence        : CARDINAL;(*pезультат чтения диска*)
     a,s1,s2,s3,s4,buf     : REAL;  (*число и суммы степеней:1,2,3,4*)
     m,d,ek,as,sko         : REAL;
     f                     : FIO.File;
     buffer                : ARRAY[0..1023] OF BYTE;(*буффеp для файла*)
LABEL lab_end;
   BEGIN
(* 1 Присвоение начальных значений*)
   s1:=0.0;
   s2:=0.0;
   s3:=0.0;
   s4:=0.0;
   buf:=1.0;
   f:=FIO.Open(sname);
   FIO.AssignBuffer(f,buffer);
(* 2  Работа с этикеткой,считать данные *)
   FIO.Seek(f,26);
   res:=FIO.RdBin(f,rsize,4);
   FIO.Seek(f,32);
   res:=FIO.RdBin(f,commence,2);
   FIO.Seek(f,LONGCARD(commence));

(* ------------------------- My Addition ------------------------------ *)
(* --------- подготавливаем данные для рисования ползунка ------------- *)
 computer:= 0;
 x_coord:=  1;
 IF rsize= 0
   THEN Space_free(-13);
        GOTO lab_end
 END;
  diskret:= rsize DIV 66;
  Use(wt_downhlp);
  GotoXY(0,1);  TextBackground(LightGray); TextColor(Black); IO.WrCharRep('░',66);
  GotoXY(71,1); TextBackground(Red);   TextColor(White); IO.WrStr(' %  ');
(* ------------------------------------------------------------------------ *)
(* Расчет сумм 1,2,3,4 степени*)
  FOR i:=1 TO rsize DO
       res:=FIO.RdBin(f,a,4);
       buf:=buf*a;
       s1:=s1+buf;
       buf:=buf*a;
       s2:=s2+buf;
       buf:=buf*a;
       s3:=s3+buf;
       buf:=buf*a;
       s4:=s4+buf;
       buf:=1.0;
(* ------------------------- My Addition ------------------------------- *)
    INC(computer);
    IF (computer>= diskret) THEN
       Use(wt_downhlp);
       TextColor(Red);   GotoXY(x_coord,1); IO.WrChar('█');
       TextColor(White); GotoXY(66,1);
      IF x_coord<= 66
         THEN  IO.WrCard(CARDINAL(REAL(x_coord)/66.*100.),5);
               INC(x_coord);
      END; (* if *)
      computer:= 0;
      IF i= rsize (* в маленьких файлах, когда точек меньше 66 *)
         THEN TextColor(Red);   GotoXY(0,1);  IO.WrCharRep('█',66);
              TextColor(White); GotoXY(66,1); IO.WrCard(100,5);
      END; (* if *)
    END; (* if *)
(* --------------------------------------------------------------------- *)
  END; (* for *)
   (*Расчет статхарактеристик*)
   m:=s1/REAL(rsize);
   d:=(s2-m*m*REAL(rsize))/(REAL(rsize-1));
   sko:=REAL(MATHLIB.Sqrt(LONGREAL(d)));
   as:=(s3-3.*s2*m+m*m*m*REAL(2*rsize))/(REAL(rsize)*d*sko);
   ek:=(s4-4.*s3*m+6.*s2*m*m-m*m*m*m*REAL(3*rsize))/
                          (REAL(rsize)*d*d)-3.0;
A[0]:=0.0;   A[1]:=2.7;    A[2]:=4.4;  A[3]:=2.3;   A[4]:=-2.3;
B[0]:=-0.16; B[1]:=-1.45;  B[2]:=0.0;  B[3]:=-2.02; B[4]:=-2.02;(* ----- *)
A[5]:=-4.4;  A[6]:=-2.7;   A[7]:=0.0;
B[5]:=0.0;   B[6]:=-1.45;  B[7]:=-0.16;
       FOR j:=0 TO 7 DO
       del[j]:=as*A[j]+ek*B[j];
       END;
lab_end:
FIO.Close(f);
(* -- восстанавливаем цвета в окне подсказки ипользованном ползунком -- *)
  Use(wt_downhlp);
  TextColor(White);
  TextBackground(Brown);
END Charly;
BEGIN
END Edjv.
