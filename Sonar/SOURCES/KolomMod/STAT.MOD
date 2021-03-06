IMPLEMENTATION MODULE stat ;
              IMPORT FIO ;
              IMPORT IO ;
              IMPORT Lib ;
              IMPORT MATHLIB ;
              IMPORT Window ;
              IMPORT InOut ;
FROM prosmotr IMPORT ff,buf(*, r, ot*) ;

PROCEDURE stat2(FileName : ARRAY OF CHAR; p: BOOLEAN ) ;
VAR
    i               : CARDINAL ; (* ��६����� 横��                       *)
    kol             : LONGCARD ; (* �������o �祪 ॠ����樨            *)
    nach            : CARDINAL ; (* ������ ��砫� ��ᯥਬ��⠫��� ������ *)
    index           : CARDINAL ; (* ������ ��砫� �㦥���� ���ଠ樨     *)
    x,x1            : REAL ;     (*  ��६���� ��� �⥭�� �� 䠩��        *)
    priznak         : CARDINAL ; (* �ਧ��� ��� ����஫� ����樨 �⥭��   *)
    MIN,MAX,                     (* ������ � ���ᨬ�                     *)
    MO,D,ASSIM,                  (* ��⮦������, ��ᯥ��� � ��ᨬ�����   *)
    EKC,M           : REAL ;     (* ������ � ???? *)
    M1,M2,M3,M4     : LONGREAL ; (* ���������� �㬬 1-�  -  4-� �⥯����   *)
    CKO             : REAL ;     (* �।��������筮� �⪫������          *)
    DEL_X           : REAL ;     (* 蠣 �� ����஥��� ���⮣ࠬ�          *)
    GIST            : ARRAY [0..15] OF CARDINAL ;(* ����� ��� ���⮣ࠬ�� *)
    g1,g2,g3,g4,
    g5,g6,g7,g8,
    g9,g10,g11,g12,
    g13,g14,g15     : REAL ;      (* ���ࢠ�� ��� ���⮣ࠬ��             *)
    data            : ARRAY [0..7] OF CHAR ; (* ��� ��ᯥਬ���          *)
    objekt          : ARRAY [0..4] OF CHAR ; (* ��ꥪ�                     *)
    tbegin          : REAL ;                 (* �६� ��砫� ���⪠ ����� *)
    tend            : REAL ;                 (* �६� ����  ���⪠ ����� *)
    chastota        : REAL ;                 (* ���� ����⨧�樨      *)
    pror            : CARDINAL ;             (* ��०������               *)
    obr             : CARDINAL ;             (* �ਧ���� ��ࠡ�⪨         *)
    filtr1          : REAL     ;             (* ������ �࠭�� 䨫���樨  *)
    filtr2          : REAL     ;             (* ������ �࠭�� 䨫���樨 *)
    distan          : CARDINAL ;             (* ���⠭�� ��室�          *)


    LABEL             metka1 ;

BEGIN
   ff:=FIO.Open(FileName) ;
   FIO.AssignBuffer(ff,buf) ;
   D   :=  0.0 ;
   M1  :=  0.0 ;
   M2  :=  0.0 ;
   M3  :=  0.0 ;
   M4  :=  0.0 ;
                   (* ���������� ��������� � �������� + ��⮦������ *)
                         (* � ������⢠ �祪 ॠ����樨 *)
   FIO.Seek(ff,2) ;
   priznak := FIO.RdBin(ff,data,8) ;
   priznak := FIO.RdBin(ff,objekt,4) ;
   priznak := FIO.RdBin(ff,tbegin,4) ;
   priznak := FIO.RdBin(ff,tend,4) ;
   priznak := FIO.RdBin(ff,chastota,4) ;
   priznak := FIO.RdBin(ff,kol,4) ;
   priznak := FIO.RdBin(ff,pror,2) ;
   priznak:=FIO.RdBin(ff,nach,2) ;

   FIO.Seek(ff,36) ;
   priznak := FIO.RdBin(ff,MIN,4) ;
   priznak := FIO.RdBin(ff,MAX,4) ;
   priznak := FIO.RdBin(ff,MO,4) ;
   priznak := FIO.RdBin(ff,obr,2) ;
   priznak := FIO.RdBin(ff,filtr1,2) ;
   priznak := FIO.RdBin(ff,filtr2,2) ;
   priznak := FIO.RdBin(ff,distan,2) ;


(* ���᫥��� ���ࢠ��� ��� ���⮣ࠬ�� *)
   DEL_X:=(MAX-MIN)/16.0 ;
   FOR i:=0 TO 15 DO
      GIST[i]:=0 ;
   END ; (* FOR *)
   g1:=MIN+DEL_X ;
   g2:=g1+DEL_X ;
   g3:=g2+DEL_X ;
   g4:=g3+DEL_X ;
   g5:=g4+DEL_X ;
   g6:=g5+DEL_X ;
   g7:=g6+DEL_X ;
   g8:=g7+DEL_X ;
   g9:=g8+DEL_X ;
   g10:=g9+DEL_X ;
   g11:=g10+DEL_X ;
   g12:=g11+DEL_X ;
   g13:=g12+DEL_X ;
   g14:=g13+DEL_X ;
   g15:=g14+DEL_X ;



   FIO.Seek(ff,LONGCARD(nach)) ;
   FOR i:=1 TO 65000 DO
      priznak := FIO.RdBin(ff,x,4) ;
      IF FIO.EOF THEN
            GOTO metka1
      END ; (* IF *)
      M1 := M1 + LONGREAL(x) ;             (* ���������� 1-� �⥯��� *)
      M2 := M2 + LONGREAL(x)*LONGREAL(x) ;             (* ���������� 2-� �⥯��� *)
      M3 := M3 + LONGREAL(x)*LONGREAL(x)*LONGREAL(x) ;         (* ���������� 3-� �⥯��� *)
      M4 := M4 + LONGREAL(x)*LONGREAL(x)*LONGREAL(x)*LONGREAL(x) ;  (* ���������� 4-� �⥯��� *)
         IF x<g8 THEN
               IF x<g4 THEN
                     IF x<g2 THEN
                           IF x<g1 THEN
                                 GIST[0]:=GIST[0]+1 ;
                              ELSE
                                 GIST[1]:=GIST[1]+1 ;
                           END ; (* IF *)
                        ELSE
                           IF x<g3 THEN
                                 GIST[2]:=GIST[2]+1 ;
                              ELSE
                                 GIST[3]:=GIST[3]+1 ;
                           END ; (* IF *)
                     END ; (* IF *)
                  ELSE
                     IF x<g6 THEN
                           IF x<g5 THEN
                                 GIST[4]:=GIST[4]+1 ;
                              ELSE
                                 GIST[5]:=GIST[5]+1 ;
                           END ; (* IF *)
                        ELSE
                           IF x<g7 THEN
                                 GIST[6]:=GIST[6]+1 ;
                              ELSE
                                 GIST[7]:=GIST[7]+1 ;
                           END ; (* IF *)
                     END ; (* IF *)
               END ; (* IF *)
            ELSE
               IF x<g12 THEN
                     IF x<g10 THEN
                           IF x<g9 THEN
                                 GIST[8]:=GIST[8]+1 ;
                              ELSE
                                 GIST[9]:=GIST[9]+1 ;
                           END ; (* IF *)
                        ELSE
                           IF x<g11 THEN
                                 GIST[10]:=GIST[10]+1 ;
                              ELSE
                                 GIST[11]:=GIST[11]+1 ;
                           END ; (* IF *)
                     END ; (* IF *)
                  ELSE
                     IF x<g14 THEN
                           IF x<g13 THEN
                                 GIST[12]:=GIST[12]+1 ;
                              ELSE
                                 GIST[13]:=GIST[13]+1 ;
                           END ; (* IF *)
                        ELSE
                           IF x<g15 THEN
                                 GIST[14]:=GIST[14]+1 ;
                              ELSE
                                 GIST[15]:=GIST[15]+1 ;
                           END ; (* IF *)
                     END ; (* IF *)
               END ; (* IF *)
         END ; (* IF *)
   END ; (* FOR *)
metka1 :

                   (* ���᫥��� ��⮦������ *)
      MO := REAL(M1)/REAL(kol) ;
                   (* ���᫥��� ��ᯥ�ᨨ   *)
      D  :=ABS(REAL(M2)/REAL(kol)-MO*MO) ;
                   (* ���᫥��� ���         *)
      CKO :=REAL(MATHLIB.Sqrt(LONGREAL(D))) ;
                   (* ���᫥��� ��ᨬ���ਨ *)
      ASSIM :=((REAL(M3)-3.0*MO*REAL(M2))/REAL(kol)+2.0*MO*MO*MO)/(CKO*CKO*CKO) ;
                   (* ���᫥��� ������    *)
      EKC := ((REAL(M4)-4.0*MO*REAL(M3)+6.0*MO*MO*REAL(M2))/REAL(kol)-3.0*MO*MO*MO*MO)/REAL(CKO*CKO*CKO*CKO)-3.0;
(* ������ ����������� *)
   FIO.Seek(ff,44) ;
   FIO.WrBin(ff,MO,4);
   FIO.Close(ff) ;
(* ������ १���⮢ ���� � 䠩� STAT.REZ  *)
   IF p THEN
         ff:=FIO.Create('STAT.REZ') ;
      ELSE
         ff:=FIO.Append('STAT.REZ') ;
   END ; (* IF *)


   FIO.AssignBuffer(ff,buf) ;
   FIO.WrBin(ff,FileName,13) ;
(* ����� �� �⨪�⪨ 䠩�� *)

   FIO.WrBin(ff,data,8) ;
   FIO.WrBin(ff,objekt,4) ;
   FIO.WrBin(ff,tbegin,4) ;
   FIO.WrBin(ff,tend,4) ;
   FIO.WrBin(ff,chastota,4) ;
   FIO.WrBin(ff,pror,2) ;
   FIO.WrBin(ff,obr,2) ;
   FIO.WrBin(ff,filtr1,2) ;
   FIO.WrBin(ff,filtr2,2) ;
   FIO.WrBin(ff,distan,2) ;

   FIO.WrBin(ff,kol,4) ;
   FIO.WrBin(ff,MIN,4) ;
   FIO.WrBin(ff,MAX,4) ;
   FIO.WrBin(ff,MO,4) ;
   FIO.WrBin(ff,D,4) ;
   FIO.WrBin(ff,CKO,4) ;
   FIO.WrBin(ff,ASSIM,4) ;
   FIO.WrBin(ff,EKC,4) ;
   FOR i:=0 TO 15 DO
      FIO.WrBin(ff,GIST[i],2) ;
(*      FIO.WrCard(4,GIST[i],3) ;*)
   END ; (* FOR *)
(*      FIO.WrLn(4) ;*)
   FIO.Close(ff) ;
END stat2 ;

END stat.

