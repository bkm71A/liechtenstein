IMPLEMENTATION MODULE FFT;
(* ��室�� �८�ࠧ������ ����;*)
IMPORT MATHLIB;
CONST pi=3.1415926;
PROCEDURE nfft(n,m:CARDINAL;VAR a1,a2:ARRAY OF REAL);
(*��।���: n - �������᭠� �����,m - log 2 ����� ���ᨢ�
  ������쭮 ��।��� ���ᨢ� a1,a2 *)
VAR d,w1,w2,u1,u2,t1,t2,u3  : REAL;        (*�㦥��� ���祭�� *)
    i,j,k,l1,l2,l           : CARDINAL;    (*�������            *)
    n2                      : CARDINAL;
BEGIN
(* ����⠭���� �室��� ��᫥����⥫쭮�� *)
n2:=(n DIV 2);
j:=0;
   FOR i:=0 TO n-2 DO
   IF i<j THEN (* ���塞 ��� ����� ���⠬� *)
               d:=a1[j];
               a1[j]:=a1[i];
               a1[i]:=d;
               d:=a2[j];
               a2[j]:=a2[i];
               a2[i]:=d;
               END;
   k:=n2;
   WHILE k<j+1 DO
             j:=j-k;
             k:=k DIV 2;
             END;
   j:=j+k;
   END;

(* ����  ��� *)
l1:=1;
   FOR l:=1 TO m DO
   l1:=l1*2;
   l2:=l1 DIV 2;
   u1:=1.0;
   u2:=0.0;
   w1:=REAL(MATHLIB.Cos(LONGREAL(pi/REAL(l2))));
   w2:=-REAL(MATHLIB.Sin(LONGREAL(pi/REAL(l2))));
       FOR j:=0 TO l2-1 DO
              i:=j;
              WHILE i<=n-1 DO
              k:=i+l2;
              t1:=a1[k]*u1-a2[k]*u2;
              t2:=a2[k]*u1+a1[k]*u2;
              a1[k]:=a1[i]-t1;
              a2[k]:=a2[i]-t2;
              a1[i]:=a1[i]+t1;
              a2[i]:=a2[i]+t2;
              i:=i+l1;
              END;
       u3:=u1;
       u1:=u1*w1-u2*w2;
       u2:=u2*w1+u3*w2;
       END;
   END;
END nfft;

BEGIN
END FFT.