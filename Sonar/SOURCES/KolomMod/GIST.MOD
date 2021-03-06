MODULE gist ;
FROM FIO      IMPORT WrStr, WrChar, WrLn, WrStrAdj, WrReal, WrCard, WrHex, WrBin ;
              IMPORT Str,SYSTEM,Lib,FIO,IO ;
              IMPORT MATHLIB ;
VAR i,j,i1,j1,i2: CARDINAL ;
    stroka      : ARRAY[0..320] OF CHAR ;
    g           : ARRAY[0..15] OF CARDINAL ;
    pg          : ARRAY[0..15] OF BOOLEAN ;
    mg          : CARDINAL ;
    mk          : REAL ;
    str,str1    : CARDINAL ;
    i3          : CARDINAL ;

BEGIN
(* �ନ஢���� ���⮣ࠬ�� *)
   FOR i:=0 TO 15 DO
         g[i]:=i*10 ;
   END ; (* FOR *)
(* ���᫥��� ����⠡� ��� ���⮣ࠬ�� *)
   mg:=g[0] ;
   FOR i:=1 TO 15 DO
      IF mg<g[i] THEN
            mg:=g[i] ;
      END ; (* IF *)
   END ; (* FOR *)
   mk:=200.0/REAL(mg) ;

(* �뢮� ���⮣ࠬ�� *)
(* ������ ����� �ਭ�� *)
   WrChar(4,CHAR(24)) ;
(* ��ॢ�� ��ப� �� 8 �祪 *)
   WrChar(4,CHAR(27)) ; WrChar(4,CHAR(51)) ; WrChar(4,CHAR(24)) ;
   WrLn(4) ;
   FOR i1:=0 TO 15 DO
      pg[i1]:=TRUE ;
   END ; (* FOR *)
   FOR j1:=1 TO 25 DO
(* ���������� ��ਧ��⠫쭮� ���� *)
      FOR i1:=0 TO 320 DO
         stroka[i1]:=CHAR(0) ;
      END ; (* FOR *)
(* ���������� ��ਧ��⠫쭮� ���� *)
      IF j1=1 THEN
            FOR i1:=0 TO 320 DO
               stroka[i1]:=CHAR(128) ;
            END ; (* FOR *)
         ELSE
            FOR i1:=0 TO 320 BY 4 DO
               stroka[i1]:=CHAR(128) ;
            END ; (* FOR *)
      END ; (* IF *)
(* ���������� ���⨪��쭮� ���� *)
      FOR i1:=0 TO 320 BY 20 DO
         stroka[i1]:=CHAR(170) ;
      END ; (* FOR *)
(* ���������� ࠬ�� *)
      stroka[0]:=CHAR(255) ;
      stroka[320]:=CHAR(255) ;
(* ���᫥��� ������������ ���⮣ࠬ�� *)
      FOR i1:=0 TO 15 DO
         IF REAL(200-(j1-1)*8-8)<(REAL(g[i1])*mk) THEN
               str:=0 ;
               i3:=0 ;
               FOR i2:=8 TO 1 BY -1 DO
                  IF REAL(200-(j1-1)*8-i2)<(REAL(g[i1])*mk) THEN
                        str:=str+CARDINAL(MATHLIB.Pow(2.0,LONGREAL(i3))) ;
                  END ; (* if *)
                  i3:=i3+1 ;
               END ; (* FOR *)
               (* ��।������ ���孥� ����窨 *)
               IF pg[i1] THEN
                     pg[i1]:=FALSE ;
                     str1:=128 ;
                     LOOP
                        IF CARDINAL(BITSET(str1)*BITSET(str))<>0 THEN
                              EXIT ;
                           ELSE
                              str1:=str1>>1 ;
                        END ; (* IF *)
                     END ; (* LOOP *)
                     FOR i2:=i1*20 TO i1*20+19 DO
                        stroka[i2]:=CHAR(BITSET(CARDINAL(stroka[i2]))+BITSET(str1)) ;
                     END ; (* FOR *)
               END ; (* IF *)
               FOR i2:=i1*20 TO i1*20+20 BY 2 DO
                  stroka[i2]:=CHAR(BITSET(CARDINAL(stroka[i2]))+BITSET(str)) ;
               END ; (* FOR *)
               stroka[i1*20+1]:=CHAR(BITSET(CARDINAL(stroka[i1*20+1]))+BITSET(str)) ;
               stroka[i1*20+19]:=CHAR(BITSET(CARDINAL(stroka[i1*20+19]))+BITSET(str)) ;
         END ; (* IF *)
      END ; (* FOR *)
(* ����祭�� �������ࠢ������ ���� *)
(*      WrChar(4,CHAR(27)) ; WrChar(4,CHAR(85)) ; WrChar(4,CHAR(0)) ;*)
(* ��ॢ�� �ਭ�� � ����᪨� ०�� *)
      WrChar(4,CHAR(27)) ; WrChar(4,CHAR(42)) ;
      WrChar(4,CHAR(0)) ;
      WrChar(4,CHAR(65)) ; WrChar(4,CHAR(1)) ;
(* ����� ��ନ஢����� ��ப� *)
      WrBin(4,stroka,321) ;
      WrLn(4) ;
(* ����� �뢮�� ���⮣ࠬ�� *)
   END ; (* FOR *)
(* ��ॢ�� �ਭ�� � ����᪨� ०�� *)
   WrChar(4,CHAR(27)) ; WrChar(4,CHAR(42)) ;
   WrChar(4,CHAR(0)) ;
   WrChar(4,CHAR(65)) ; WrChar(4,CHAR(1)) ;
(* ����� ��ନ஢����� ��ப� *)
   FOR i1:=0 TO 320 DO
      WrChar(4,CHAR(128)) ;
   END ; (* FOR *)
(* ��ॢ�� ��ப� �� ⥪�⮢�� ��࠭� *)
   WrChar(4,CHAR(27)) ; WrChar(4,CHAR(50)) ;
END gist .