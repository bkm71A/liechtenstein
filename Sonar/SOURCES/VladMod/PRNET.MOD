IMPLEMENTATION MODULE PrnEt;

IMPORT Str,FIO;
FROM SearchFl   IMPORT FullPath;

PROCEDURE WaitOn(): CARDINAL;
BEGIN
RETURN 0
END WaitOn;


PROCEDURE WaitOff(shad: CARDINAL);
BEGIN
END WaitOff;


PROCEDURE PrintEtik(hdl: FIO.File; file_name:ARRAY OF CHAR):  CARDINAL;
TYPE a2 = ARRAY[0..1] OF CHAR;
     a3 = ARRAY[0..2] OF CHAR;
VAR str : ARRAY[0..79] OF CHAR ;
    ss  : ARRAY[0..14] OF CHAR ;
    cc,ind,b,j,obr,i,CH: CARDINAL ;
    Rrr,Fff : ARRAY[0..8] OF REAL ;
    longCA  : LONGCARD ;
    pr,bl1,bl2 : BOOLEAN ;
    Bufer    : ARRAY[0..1*512+FIO.BufferOverhead] OF BYTE ;
    ff       : FIO.File ;
    shadow:  CARDINAL;
    RazrACP: SHORTCARD;
LABEL con;

CONST Dlja   = '��� �த������� ������ ���� �������';
      shabl1 ='�६� ��砫� ���⪠ �����(c)|'+
              '�६� ���� ���⪠ ����� (c)|'+
              '���� ����⨧�樨    (��)|'+
              '������⢮ �祪 ॠ����樨|'+
              '��०������|'+
              '������|'+
              '���ᨬ�|'+
              '��⮦������|'+
              '���⠭�� ��室�         (�)|' ;

      shabl2 ='ᣫa������� �� ����|'+
              'ᣫ�������� ����� ��|'+
              '��⮪��५�樮���� ��ࠡo�|'+
              '����७�஢����|'+
              '��⥣�஢����|'+
              '䨫����� � ����� ����|'+
              'ᯥ���|'+
              'ᯥ��ࠫ쭠� ���⭮���|'+
              'ᣫ�������� �� ��������|'+
              'ᣫ�������� �� ��������|'+
              'ᣫ�������� �� ��ᠬ���|'+
              'ᣫ�������� �� ���⠬|'+
              '���࠭���� ���ᮢ|'+
              '���࠭���� �७��|'+
              '�����஢��|'+
              '��஢��|' ;

   etik   = '�������� ';
   fail   = '䠩�';
   nomreg = '����� ०��� ';
   nompod = '����� ���०��� ';
   nomkan = '����� ������ ';
   dataEk = '��� ��ᯥਬ��� ';
   obekt  = '��ꥪ� ';
    vid   = '��� ��ᯥਬ. ������ - ';
    neI   = '�� �������஢��';
   MET    = ' ������ ��������� ';
   GrFi   = '  ������  �࠭�� 䨫���(��)+  ������ �࠭�� 䨫���(��)';
   razr   = '  p���襭�� �� ����  (��)' ;
BEGIN
  shadow:= WaitOn();
  FIO.WrStr(hdl,a2(CHR(27),CHR(77)) );     (* ����� � 163 ᨬ���� �� ����� *)
  FIO.WrStr(hdl,a3(CHR(27),'3',CHR(32)) ); (* �������� ���ࢠ�  *)

(* �ନ�㥬 �������� *)
     Str.Concat(str,etik,fail) ;
     Str.Append(str,'a ') ;
     FIO.WrStrAdj(hdl,str,40) ;
     FIO.WrStr   (hdl,file_name) ; FIO.WrLn(hdl) ;
     FIO.WrLn(hdl) ;
(* -1- ����஢뢠�� ⨯ ���稪� *)
  Str.Concat(str,FullPath,'\type_dat') ; (* ��ନ஢��� ����� ���� type_dat.tar *)
  ff:=FIO.Open(str) ;
  IF FIO.IOresult()=0 THEN
       LOOP FIO.RdStr(ff,str) ;
            IF    str[0]=file_name[0] THEN
              Str.Delete(str,0,4) ; EXIT
            ELSIF FIO.EOF THEN
              Str.Copy(str,neI) ; EXIT
            END ;
       END ;
       FIO.Close(ff) ;
  END ;
  FIO.WrStrAdj(hdl,vid,43) ;
  FIO.WrStr   (hdl,str) ;  FIO.WrLn(hdl) ;

(* -2- *)
  ff:=FIO.Open(file_name) ;
  FIO.AssignBuffer(ff,Bufer) ;
    i :=FIO.RdBin(ff,i,2) ;
    CH:=FIO.RdBin(ff,ss,8) ;  ss[8] :=CHR(0) ;
    FIO.WrStrAdj(hdl,dataEk,34) ;
    FIO.WrStrAdj(hdl,ss,-13) ;

    CH:=FIO.RdBin(ff,ss,4) ;  ss[4] :=CHR(0) ;
    Str.Concat(str,obekt,ss) ;
    FIO.WrStr(hdl,str) ;
    FIO.WrLn(hdl) ;

      CH:=FIO.RdBin(ff,Rrr[0],4) ; (* �६� ��砫� ���⪠ ����� *)
      CH:=FIO.RdBin(ff,Rrr[1],4) ; (* �६� ���� ���⪠ ����� *)
      CH:=FIO.RdBin(ff,Rrr[2],4) ; (* ���� ����⨧�樨 *)
      CH:=FIO.RdBin(ff,longCA,4) ; (* ������⢮ �祪 ॠ����樨 *)
          Rrr[3] :=REAL(longCA) ;
      CH:=FIO.RdBin(ff,i,2)      ; (* ��०������ *)
          Rrr[4] :=REAL(i) ;
      CH:=FIO.RdBin(ff,ind,2) ;    (* ������ ��砫� ������ *)

      FIO.Seek(ff,36) ;
      CH:=FIO.RdBin(ff,Rrr[5],4) ; (* ������  *)
      CH:=FIO.RdBin(ff,Rrr[6],4) ; (* ���ᨬ� *)
      CH:=FIO.RdBin(ff,Rrr[7],4) ; (* ��⮦������ *)
      CH:=FIO.RdBin(ff,obr,2)    ; (* ���� ��ࠡ�⪨ *)

      CH:=FIO.RdBin(ff,Fff[0],4) ; (* 0 ������ �࠭�� 䨫��� *)
      CH:=FIO.RdBin(ff,Fff[1],4) ; (* 1 ������ �࠭�� 䨫��� *)

      CH:=FIO.RdBin(ff,i,2)      ; (* ���⠭�� ��室� *)
          Rrr[8] :=REAL(i) ;
      FOR i:=2 TO 6 DO               (* 2 ࠧ�襭�� �� ���� *)
        CH:=FIO.RdBin(ff,Fff[i],4) ; (* 3 �ਭ� ᯥ��� *)
      END ;                          (* 4 ������ �।�� �����.���.*)
                                     (* 5 ������ �।�� �����.���.*)
                                     (* 6 �����⥫쭠� ����⭮��� *)

(* -3- *)
(* �ନ஢���� ������ �� ����� 䠩�� *)
  FIO.WrStrAdj(hdl,nomreg,24) ;
    str[0]:= file_name[1] ;
    str[1]:= file_name[2] ;
    str[2]:=CHR(0)        ; FIO.WrStrAdj(hdl,str,-4) ;
  FIO.WrStrAdj(hdl,nompod,16) ;
    str[0]:= file_name[3] ;
    str[1]:= file_name[4] ; FIO.WrStrAdj(hdl,str,-4) ;
  FIO.WrStrAdj(hdl,nomkan,-13);
    str[0]:= file_name[5] ;
    str[1]:= file_name[6] ;
    str[2]:= file_name[7] ;
    str[3]:= CHR(0)       ; FIO.WrStr(hdl,str) ;
  FIO.WrLn(hdl) ;
(* -4- *)
  str[0] := '�' ;
  FOR i:=1 TO 6   DO str[i] := '�' END ;                  str[7] := CHR(0) ;
  Str.Append(str,MET) ;
    i:= Str.Length(str) ;
  FOR i:=i TO i+6 DO str[i] := '�' END ; str[i]  := '�' ; str[i+1]:= CHR(0) ;
  FIO.WrStrAdj(hdl,str,76);
  FIO.WrLn(hdl) ;
(* -5- *)

  bl1:= CARDINAL(BITSET(obr)*BITSET(0020H))#0 ;
  bl2:= CARDINAL(BITSET(obr)*BITSET(0FC0H))#0 ;
  i:= 0 ; CH:= 1 ;
  LOOP
       Str.ItemS(str,shabl1,'|',i) ;
       IF i<=9 THEN b:=0 ELSE b:=44 END ;
       IF Str.Length(str)#0 THEN  (* ��室 �� "��������� �������" *)
            FIO.WrStrAdj(hdl,str,-30) ;
            CASE i OF 3,4,8 : Str.CardToStr(LONGCARD(Rrr[i]),str,10,pr) ;
                              cc:= 13 ;INC(b) ;
                      ELSE  Str.RealToStr(LONGREAL(Rrr[i]),8,FALSE,str,pr) ;
                              cc:=-14
            END ;  (* case *)
            FIO.WrStrAdj(hdl,str,cc) ;
       END ; (* if *)

       CASE i OF
          9 : FOR j:=0 TO 41 DO str[j]:='�' END ; str[41]:=CHR(0) ;
              FIO.WrStrAdj(hdl,str,-44)
(* IF ��� 䠩��� .SPL � .SPR *)
     |10,11 : IF bl1 THEN FIO.WrStrAdj(hdl,GrFi[i-10],-30) ;
                          Str.RealToStr(LONGREAL(Fff[i-10]),8,FALSE,str,pr) ;
                          FIO.WrStrAdj(hdl,str,13) ; b:=1
              END ;
        |12 : FOR j:=0 TO 41 DO str[j]:='�' END ; str[41]:=CHR(0) ;
              FIO.WrStrAdj(hdl,str,-44) ; b:= 0
(* ��� 䠩��� ᯥ��ࠫ��� *)
        |13 : IF bl2 THEN FIO.WrStrAdj(hdl,razr,-30) ;
                          Str.RealToStr(LONGREAL(Fff[2]),8,FALSE,str,pr) ;
                          FIO.WrStrAdj(hdl,str,13) ; b:=1
              END ;
        |14 : IF bl2 THEN FIO.WrStrAdj(hdl,'  ��ਭ� ᯥ���',-14) ;
                          Str.RealToStr(LONGREAL(Fff[3]),8,FALSE,str,pr) ;
                          FIO.WrStrAdj(hdl,str,20) ; b:=8
              END ;
        |15 : IF bl2 THEN FIO.WrStrAdj(hdl,'  �����⥫�� ���ࢠ��',-43) ;
                          b:=1
              END ;
        |16 : IF bl2 THEN FIO.WrStrAdj(hdl,'  ������  �।��',-14) ;
                          Str.RealToStr(LONGREAL(Fff[4]),8,FALSE,str,pr) ;
                          FIO.WrStrAdj(hdl,str,20) ; b:=37
              ELSE b:=1
              END ;
        |17 : IF bl2 THEN FIO.WrStrAdj(hdl,'  ���孨� �।��',-14) ;
                          Str.RealToStr(LONGREAL(Fff[5]),8,FALSE,str,pr) ;
                          FIO.WrStrAdj(hdl,str,20) ;
              ELSE EXIT
              END ;
        |18 : IF bl2 THEN FIO.WrStrAdj(hdl,'  �����. ����⭮���',-24) ;
                          Str.FixRealToStr(LONGREAL(Fff[6]),3,str,pr) ;
                          FIO.WrStr(hdl,str) ;
              END ;
        |19 : EXIT
       END ; (* case *)

       Str.ItemS(str,shabl2,'|',i) ;
       IF i<=15 THEN
         FIO.WrStrAdj(hdl,'�',1+b) ;
         FIO.WrStrAdj(hdl,str,-27) ;
         IF CARDINAL(BITSET(obr)*BITSET(CH))=0 THEN
              FIO.WrStr(hdl,'���')
         ELSE FIO.WrStr(hdl,'�� ')
         END ;
         FIO.WrStr(hdl,'�') ;
         CH:=CH<<1 ;
       ELSIF i=16 THEN
         str[0] :='�' ; FOR j:=1 TO 30 DO str[j] := '�' END ;
         str[31]:='�' ; str[32] := CHR(0) ;
         FIO.WrStrAdj(hdl,str,77-b);
       END ; (* if *)
       FIO.WrLn(hdl) ;
       INC(i) ;
  END ; (* loop *)

  IF ind<=80 THEN GOTO con END ;
    FIO.Seek(ff,80) ;
    FIO.RdStr(ff,str);
    FIO.WrStr(hdl,'�����୮��� �� X - '); FIO.WrStr(hdl,str); FIO.WrLn(hdl);
    FIO.RdStr(ff,str);
    FIO.WrStr(hdl,'�����୮��� �� Y - '); FIO.WrStr(hdl,str); FIO.WrLn(hdl);

  IF ind<=96 THEN GOTO con END ;
    FIO.Seek(ff,96) ;
    CH:=FIO.RdBin(ff,RazrACP,1) ;
    FIO.WrStr(hdl,'����來���� ��� ');
    IF (RazrACP>=6)AND(RazrACP<=12) THEN
         FIO.WrShtCard(hdl,RazrACP,3)
    ELSE FIO.WrStr(hdl,'- ?')
    END ;
    CH:=FIO.RdBin(ff,Rrr[0],4) ;
    Str.FixRealToStr(LONGREAL(Rrr[0]),1,str,pr) ;
    FIO.WrStr(hdl,' ;  ������  �।�� ��� '); FIO.WrStrAdj(hdl,str,5); FIO.WrLn(hdl);

    CH:=FIO.RdBin(ff,Rrr[0],4) ;
    Str.FixRealToStr(LONGREAL(Rrr[0]),1,str,pr) ;
    FIO.WrStrAdj(hdl,'���孨� �।�� ��� ',42); FIO.WrStrAdj(hdl,str,5); FIO.WrLn(hdl);

con :
    FIO.WrLn(hdl) ;
    FIO.WrStr(hdl,'������ �ଠ�஢����� ������ �⨪�⪨ -') ;
    FIO.WrCard(hdl,ind,3) ;
    FIO.WrLn(hdl) ;
(* FIO.WrBin(hdl,CHR(12),1);     (* �ண���� ���� *) *)
 FIO.Close(ff) ;

 WaitOff(shadow);
 RETURN 0 ;
END PrintEtik;



END PrnEt.