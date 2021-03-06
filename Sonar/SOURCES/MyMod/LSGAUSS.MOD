IMPLEMENTATION MODULE LSGauss;
IMPORT MATHLIB,FIO,IO;
CONST pi2=0.2820948;
      sqrt2=1.414214;
PROCEDURE prover(VAR sname:ARRAY OF CHAR;VAR p:REAL):CARDINAL;
(* �室�� : 䠩� ������� REAL,c �⨪�⪮�          *)
VAR  i,rsize               : LONGCARD;(*���稪 横��,p����p 䠩��*)
     res,j,commence        : CARDINAL;(*p������ �⥭�� ��᪠*)
     a,s1,s2,xi_2,teor     : REAL;  (*�᫮ � �㬬� �⥯����:1,2*)
     k,r                   : CARDINAL;(* �᫮ ���ࢠ��� *)
     count                 : ARRAY[0..140] OF CARDINAL;
     prob                  : ARRAY[0..38] OF REAL;
     min,max,mo,d,sko,del  : REAL;
     gr1,gr2,pi,xi2        : LONGREAL;
     bound                 : ARRAY[0..10] OF LONGCARD;
     f                     : FIO.File;
     buffer                : ARRAY[0..1023] OF BYTE;(*����p ��� 䠩��*)

PROCEDURE normal(d1,d2:LONGREAL):LONGREAL;
(* ��室�� ��⥣ࠫ ��� ��ଠ�쭮�� ��।������  *)
(* d1<d2 - ��ନ஢����,����⠡�஢���� �������� *)
VAR s,spr,fact,powd1,powd2 : LONGREAL;
    n                      : CARDINAL;
    sign                   : INTEGER;
  BEGIN
  s:=2.0*(d2-d1);
  sign:=-1;
  fact:=1.0;
  n:=1;
  powd1:=1.0;
  powd2:=1.0;
     REPEAT
     spr:=s;
     powd1:=powd1*d1*d1;
     powd2:=powd2*d2*d2;
     s:=s+LONGREAL(sign)*(powd2*d2-powd1*d1)/(fact*(LONGREAL(n)+0.5));
     n:=n+1;
     sign:=sign*(-1);
     fact:=fact*LONGREAL(n);
     UNTIL ABS(spr-s)<0.0000001;
  s:=s*pi2;
  RETURN LONGREAL(s);
  END normal;

  PROCEDURE Probability(ksi:LONGREAL;free:CARDINAL):LONGREAL;
(* �㭪�� ������ ��⥣ࠫ �� ������ *)
(* ��।��� : �� ������, free-�⥯��� ᢮���� ������ ���� �⭮�*)
  VAR fact,pow,sum,p : LONGREAL;
      i              : CARDINAL;
   BEGIN
   free:=free DIV 2 -1;
   ksi:=ksi/2.0;
   sum:=0.0;
   fact:=1.0;
   pow:=1.0;
      FOR i:=0 TO free DO
      sum:=sum+pow/fact;
      pow:=pow*ksi;
      fact:=fact*LONGREAL(i+1);
      END;
   p:=MATHLIB.Exp(ksi);
   p:=1.0-sum/p;
   RETURN p;
   END Probability;

   BEGIN
(* 1 ��᢮���� ��砫��� ���祭��*)
   FOR j:=0 TO 140 DO
   count[j]:=0;
   END;
   f:=FIO.Open(sname);
   FIO.AssignBuffer(f,buffer);
(* 2  ����� � �⨪�⪮�,����� ����� *)
   FIO.Seek(f,26);
   res:=FIO.RdBin(f,rsize,4);
   FIO.Seek(f,32);
   res:=FIO.RdBin(f,commence,2);
   FIO.Seek(f,36);
   res:=FIO.RdBin(f,min,4);
   res:=FIO.RdBin(f,max,4);
   res:=FIO.RdBin(f,mo,4);
(* 3 �஢�ઠ �� ����� ����� 200 *)
   IF rsize<200 THEN FIO.Close(f);RETURN 1;END;
(* 4 ������� �������� �� ���ࢠ�� *)
   k:=CARDINAL(MATHLIB.Pow(LONGREAL(rsize),LONGREAL(0.4)));
   IF k MOD 2 = 0 THEN k:=k+1;END;
(* 5 ��⠥� ��������� ���祭�� � ���ࢠ� � ��ᯥ��� *)
   FIO.Seek(f,LONGCARD(commence));
   s1:=0.0;s2:=0.0;
   del:=(max-min)/REAL(k);
      FOR i:=1 TO rsize DO
      res:=FIO.RdBin(f,a,4);
      s1:=s1+a;
      s2:=s2+a*a;
      j:=CARDINAL((a-min)/del);
      count[j]:=count[j]+1;
      END;
   mo:=s1/REAL(rsize);
   d:=(s2-mo*mo*REAL(rsize))/(REAL(rsize-1));
   sko:=REAL(MATHLIB.Sqrt(LONGREAL(d)));
   FIO.Close(f);
(* 6 ��室�� ���祭�� �� - ������ *)
   xi2:=0.0;
(**)IO.WrStr('���������� �����  ');IO.WrCard(k,5);IO.WrLn();
      FOR j:=0 TO k-1 DO
      gr1:=LONGREAL(min+REAL(j)*del);
      gr2:=gr1+LONGREAL(del);
(**)IO.WrStr('���ࢠ� �����  ');IO.WrCard(j,5);IO.WrLn();
      gr1:=(gr1-LONGREAL(mo))/LONGREAL(sko)/sqrt2;
      gr2:=(gr2-LONGREAL(mo))/LONGREAL(sko)/sqrt2;
(**)IO.WrStr('�࠭��� ���ࢠ�� ');IO.WrLngReal(gr1,4,5);IO.WrChar(' ');
(**)IO.WrLngReal(gr2,4,5);IO.WrLn();
(**)IO.WrStr('������  � ���� ');IO.WrCard(count[j],5);IO.WrLn();
      IF ABS(gr1)>5.0 THEN gr1:=ABS(gr1)/gr1*5.3;END;
      IF ABS(gr2)>5.0 THEN gr2:=ABS(gr2)/gr2*5.3;END;
      pi:=ABS(normal(gr1,gr2));
(**)IO.WrStr('������᪠�  ');IO.WrLngReal(pi,4,5);IO.WrLn();
      xi2:=xi2+(LONGREAL(count[j])-LONGREAL(rsize)*pi)*
               (LONGREAL(count[j])-LONGREAL(rsize)*pi)/(LONGREAL(rsize)*pi);
(**)IO.WrStr('�㬬� ��  ');IO.WrLngReal(xi2,4,5);IO.WrLn();
      END;
(* 7 ����� ����⭮��,��⥣ࠫ� �� xi^2  *)
   r:=k-3;        (* �᫮ �⥯���� ᢮���� *)
   IF xi2>2700.0 THEN p:=1.0;
                 ELSE p:=REAL(Probability(xi2,r));
                 END;
   p:=1.0-p;
   RETURN 0;
END prover;
BEGIN
END LSGauss.
