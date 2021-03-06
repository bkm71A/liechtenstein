IMPLEMENTATION MODULE prosmotr ;

FROM FIO      IMPORT WrStr, WrChar, WrLn, WrLngCard, WrReal, WrCard, WrHex, WrBin ;
              IMPORT Str,SYSTEM,Lib,FIO,IO ;
              IMPORT MATHLIB ;
FROM Graph    IMPORT GraphMode,TextMode,HLine,Line ;
FROM Gra      IMPORT Set1Char,Get_Image,Put_Image ;

TYPE g              = ARRAY [1..5] OF CHAR ;

VAR

      OK , Eng        : BOOLEAN ;
      kol             : LONGCARD ; (* ������⢮ �祪 ॠ����樨 *)
      kol1            : ARRAY [1..5] OF CHAR ; (* ������⢮ �祪 ॠ����樨 *)
      MIN,MAX,
      MO,D,ASSIM,
      EKC,M           : REAL ;
      MIN1,MAX1,
      MO1,D1,ASSIM1,
      EKC1, M1        : ARRAY [1..16] OF CHAR ;
      CKO             : REAL ;
      CKO1            : ARRAY [1..16] OF CHAR ;
      GIST            : ARRAY [0..15] OF CARDINAL ;
      GIST1           : ARRAY [0..15] OF g ;
PROCEDURE ramka (x1,y1,x2,y2,Color : CARDINAL) ;
      (* ���� ࠬ�� *)
BEGIN
   HLine(x1,y1,x2,Color) ;
   HLine(x1,y2,x2,Color) ;
   Line(x1,y1,x1,y2,Color) ;
   Line(x2,y1,x2,y2,Color) ;
END ramka ;

PROCEDURE kvadrat (x1,y1,x2,y2,Color: CARDINAL ) ;
      (* ���� ����襭�� ������ *)
VAR i : CARDINAL ;
BEGIN
   FOR i:=y1 TO y2 DO
      HLine(x1,i,x2,Color) ;
   END ; (* for *)
END kvadrat ;

PROCEDURE WriteStr(col,row,cwet:SHORTCARD; str:ARRAY OF CHAR);
      (* �뢮� ��ப� ⥪�� �� ��࠭ *)
BEGIN
   r.AX := 1300H ;              (* ����� ��ப�(��), �� �ண��� �����(AL)  *)
   r.BX := CARDINAL(cwet)   ;   (* ����� ����� ��࠭��� [0] + ��ਡ�� ��ப� *)
   r.CX :=  Str.Length(str) ;   (* ������ ��ப� - ��⠥� ⮫쪮 ᨬ����   *)
   r.DH :=   row ;              (* ��ப� ��砫� �뢮��                     *)
   r.DL :=   col ;              (* ������� ��砫� �뢮��                    *)
   r.BP := SYSTEM.Ofs(str)  ;   (*         �뢮�����                        *)
   r.ES := SYSTEM.Seg(str)  ;   (*            ��ப�                        *)
   Lib.Intr(r,10H);
END WriteStr;

PROCEDURE Write1Str(col,row,cwet:SHORTCARD; str:ARRAY OF CHAR);
      (* �뢮� ��ப� ⥪�� �� ��࠭ *)
BEGIN
   r.AX := 1300H ;              (* ����� ��ப�(��), �� �ண��� �����(AL)  *)
   r.BX := 0100H+CARDINAL(cwet);(* ����� ����� ��࠭��� [1] + ��ਡ�� ��ப� *)
   r.CX :=  Str.Length(str) ;   (* ������ ��ப� - ��⠥� ⮫쪮 ᨬ����   *)
   r.DH :=   row ;              (* ��ப� ��砫� �뢮��                     *)
   r.DL :=   col ;              (* ������� ��砫� �뢮��                    *)
   r.BP := SYSTEM.Ofs(str)  ;   (*         �뢮�����                        *)
   r.ES := SYSTEM.Seg(str)  ;   (*            ��ப�                        *)
   Lib.Intr(r,10H);
END Write1Str;



PROCEDURE analiz (file_name : ARRAY OF CHAR ) : BOOLEAN ;
VAR       p          : BOOLEAN ;
          ident      : ARRAY [1..2] OF CHAR ;
          kol        : LONGCARD ;
          index      : CARDINAL ; (* ��砫� �㦥���� ���ଠ樨 *)
BEGIN
   ff:=FIO.Open(file_name) ;
   FIO.AssignBuffer(ff,buf) ;
   priznak:=FIO.RdBin(ff,index,2) ;
   FIO.Seek(ff,LONGCARD(index)) ;
   (* ������⢮ �祪 ઠ����樨 *)
   FIO.Seek(ff,26) ;
   priznak:=FIO.RdBin(ff,kol,4) ;
   (* �����䨪��� 䠩�� ��ࠡ�⪨ *)
   FIO.Seek(ff,LONGCARD(index)) ;
   priznak:=FIO.RdBin(ff,ident,2) ;
   (* ������⢮ �祪 ઠ����樨 *)
   FIO.Seek(ff,26) ;
   priznak:=FIO.RdBin(ff,kol,4) ;
   FIO.Close(ff) ;
   IF (Str.Match(ident,'SW')) AND (NOT FIO.EOF) AND ( kol > 0) THEN
         p:=TRUE ;
      ELSE
         p:=FALSE ;
         (* ���ࠢ���� �ଠ� ������ � 䠩�� *)
         Lib.Sound(400) ;
         Get_Image(56,128,584,204) ;
(*         kvadrat(56,128,584,204,0) ;*)
         kvadrat(60,132,580,200,4) ;
         ramka(56,128,584,204,15) ;
         WriteStr(34,10,8BH,'� � � � � � !');
         WriteStr(24,11,8BH,'���ࠢ���� �ଠ� ������ � 䠩��');
         WriteStr(22,13,83H,'��� �த������� ������ ���� �������');
         Lib.NoSound ;
         ot:=IO.RdCharDirect() ;
         Put_Image(56,128,584,204) ;
   END ; (* IF *)

   RETURN p ;
END analiz ;

PROCEDURE prosm(file_name: ARRAY OF CHAR ) ;
VAR ident      : ARRAY [1..2] OF CHAR ;
    nach_sl    : CARDINAL ;
    kol        : LONGCARD ;
BEGIN
                    ff:=FIO.Open(file_name) ;
                    FIO.AssignBuffer(ff,buf) ;
                    priznak:=FIO.RdBin(ff,nach_sl,2) ;
                    (* ������⢮ �祪 ઠ����樨 *)
                    FIO.Seek(ff,26) ;
                    priznak:=FIO.RdBin(ff,kol,4) ;
                    (* �����䨪��� 䠩�� ��ࠡ�⪨ *)
                    FIO.Seek(ff,LONGCARD(nach_sl)) ;
                    priznak:=FIO.RdBin(ff,ident,2) ;
                    FIO.Close(ff) ;
  IF (Str.Match(ident,'SW')) AND (kol>0) AND (NOT FIO.EOF) THEN
                          Get_Image(56,128,584,204) ;
                       (*   kvadrat(56,128,584,204,0) ;*)
                          kvadrat(60,132,580,200,1) ;
                          ramka(56,128,584,204,15) ;
                          WriteStr(32,11,8CH,'��������� ������� !');
         WriteStr(26,12,86H,'���� �ᯠ����� �⨪�⪨ 䠩��');
(* �ᯠ����� � �뢮� �⨪�⪨ 䠩�� *)
                     titl(file_name) ;
                        ELSE
                    (* ���ࠢ���� �ଠ� ������ � 䠩�� *)
                          Lib.Sound(400) ;
                          Get_Image(56,128,584,204) ;
                       (*   kvadrat(56,128,584,204,0) ;*)
                          kvadrat(60,132,580,200,4) ;
                          ramka(56,128,584,204,15) ;
                          WriteStr(34,10,8BH,'� � � � � � !');
         WriteStr(24,11,8BH,'���ࠢ���� �ଠ� ������ � 䠩��');
         WriteStr(22,13,83H,'��� �த������� ������ ���� �������');
                          Lib.NoSound ;
                          ot:=IO.RdCharDirect() ;
                          Put_Image(56,128,584,204) ;
                     END ; (* IF *)
END prosm ;

PROCEDURE titl(file_name : ARRAY OF CHAR ) ;
(*****************************************************)
(*              ��ᬮ�� �⨪�⪨ !!!!!!!!           *)
(*****************************************************)

CONST shabl1 ='�६� ��砫� ���⪠ �����(�)|'+
              '�६� ���� ���⪠ ����� (�)|'+
              '���� ����⨧�樨 (��)|'+
              '������⢮ �祪 ॠ����樨|'+
              '��०������|'+
              '������|'+
              '���ᨬ�|'+
              '��⮦������|'+
              '���⠭�� ��室� (�)|' ;
      shabl2 ='������᪠� ��ࠡ�⪠|'+
              'ᣫ��������� ����� ��|'+
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
   type_dat = '\type_dat' ;

VAR index    : CARDINAL ; (* ������ ��砫� �㦥���� ���ଠ樨 *)
    stroka   : ARRAY[0..28] OF CHAR ;
    Perem    : ARRAY[0.. 9] OF REAL ;
    Long     : LONGCARD ;

    data     : ARRAY [0..7] OF CHAR ; (* ��� ��ᯥਬ��� *)
    objekt   : ARRAY [0..4] OF CHAR ; (* ��ꥪ� *)

    obr      : CARDINAL ;

    filtr1   : REAL     ; (* ������ �࠭�� 䨫���樨 *)
    filtr2   : REAL     ; (* ������ �࠭�� 䨫���樨 *)
    distan   : CARDINAL ; (* ���⠭�� ��室� *)

    i,j,CH   : CARDINAL ;
    ok,bool  : BOOLEAN ;
    ot       : CHAR ;
    f        : FIO.File ;
BEGIN
      data  [HIGH(data)]   :=CHR(0) ;
      objekt[HIGH(objekt)] :=CHR(0) ;
      ff:=FIO.Open(file_name) ;
      FIO.AssignBuffer(ff,buf) ;
(* ���������� 䮭� 2-� ��࠭��� ��࠭� *)
      SYSTEM.Out(3CEH,1) ;  (* ࠧ�蠥� ������ �� �� ��⮢� ���᪮�� *)
      SYSTEM.Out(3CFH,0EH) ;
         Lib.WordFill([0A800H:0000H],14000,0FFFFH) ;
      SYSTEM.Out(3CEH,1) ;  (* ����⠭�������� ��� *)
      SYSTEM.Out(3CFH,0) ;
(* ����⮢�窠 �ᥣ� ��࠭� *)
      Set1Char(0,0,SHORTCARD('�'),1,8AH) ;
      Set1Char(1,0,SHORTCARD('�'),34,8AH) ;
      Set1Char(45,0,SHORTCARD('�'),34,8AH) ;
      Set1Char(79,0,SHORTCARD('�'),1,8AH) ;
      FOR i := 1 TO 23 DO
          Set1Char(0,SHORTCARD(i),SHORTCARD('�'),1,8AH) ;
          Set1Char(79,SHORTCARD(i),SHORTCARD('�'),1,8AH) ;
      END ;
      Set1Char(0,24,SHORTCARD('�'),1,8AH) ;
      Set1Char(79,24,SHORTCARD('�'),1,8AH) ;
      Set1Char(1,24,SHORTCARD('�'),15,8AH) ;
      Set1Char(64,24,SHORTCARD('�'),15,8AH) ;
         Set1Char(1,16,SHORTCARD('�'),46,86H) ;
         Set1Char(1,19,SHORTCARD('�'),46,86H) ;
         Set1Char(1,21,SHORTCARD('�'),46,86H) ;
(* ����⮢�窠 ���� ��⮤�� ��ࠡ�⪨ *)
      Set1Char(47,6,SHORTCARD('�'),1,8BH) ;
      Set1Char(48,6,SHORTCARD('�'),6,8BH) ;
      Set1Char(72,6,SHORTCARD('�'),6,8BH) ;
      Set1Char(78,6,SHORTCARD('�'),1,8BH) ;
      FOR i := 7 TO 22 DO
          Set1Char(47,SHORTCARD(i),SHORTCARD('�'),1,8BH) ;
          Set1Char(78,SHORTCARD(i),SHORTCARD('�'),1,8BH) ;
      END ;
      Set1Char(47,23,SHORTCARD('�'),1,8BH) ;
      Set1Char(78,23,SHORTCARD('�'),1,8BH) ;
      Set1Char(48,23,SHORTCARD('�'),30,8BH) ;


(* �ନ஢���� �������� *)
      Write1Str(36,0,8CH,'��������') ;
      Write1Str(31,1,8CH,'䠩�') ;
      Write1Str(37,1,8FH,file_name) ;
      Write1Str(18,24,86H,'��� �த������� ࠡ��� ������ ���� �������') ;
(* ����஢뢠�� ⨯ ���稪� *)
   Str.Concat(stroka,paht1,type_dat) ; (* ��ନ஢��� ����� ���� type_dat *)
   f:=FIO.Open(stroka) ;
   IF FIO.IOresult()=0 THEN
       Write1Str(15,2,8AH,'��� ��ᯥਬ. ������') ;
       LOOP FIO.RdStr(f,stroka) ;
            IF stroka[0]=file_name[0] THEN
              Str.Delete(stroka,0,4) ;
              Write1Str(38,2,8CH,stroka) ; EXIT
            END ;
            IF FIO.EOF THEN
                Write1Str(38,2,8CH,'�� �������஢��') ; EXIT
            END ;
       END ;
       FIO.Close(f) ;
   END ;

(* �ନ஢���� ������ �� ����� 䠩�� *)
   Str.Slice(stroka,file_name,1,2) ;
      Write1Str(9,4,8AH,'����� ०���');
      Write1Str(23,4,8CH,stroka);
   Str.Slice(stroka,file_name,3,2) ;
      Write1Str(30,4,8AH,'����� ���०���');
      Write1Str(47,4,8CH,stroka);
   Str.Slice(stroka,file_name,5,3) ;
      Write1Str(55,4,8AH,'����� ������');
      Write1Str(69,4,8CH,stroka);

(* �⥭�� �⨪�⪨ *)
      CH:=FIO.RdBin(ff,index,2) ;   (* ������ ��砫� �㦥���� ���ଠ樨 *)
      CH:=FIO.RdBin(ff,data,8) ;    (* ��� ��ᯥਬ��� *)
   Write1Str(15,3,8AH,'��� ��ᯥਬ���') ;
   Write1Str(34,3,8CH,data)  ;
      CH:=FIO.RdBin(ff,objekt  ,4) ; (* ��ꥪ� *)
   Write1Str(55,3,8AH,'��ꥪ�') ;
   Write1Str(63,3,8CH,objekt) ;
      CH:=FIO.RdBin(ff,Perem[0],4) ; (* �६� ��砫� ���⪠ ����� *)
      CH:=FIO.RdBin(ff,Perem[1],4) ; (* �६� ���� ���⪠ ����� *)
      CH:=FIO.RdBin(ff,Perem[2],4) ; (* ���� ����⨧�樨 *)
      CH:=FIO.RdBin(ff,Long    ,4) ; (* ������⢮ �祪 ॠ����樨 *)
          Perem[3] :=REAL(Long) ;
      CH:=FIO.RdBin(ff,j,2)        ; (* ��०������ *)
          Perem[4] :=REAL(j) ;

      CH:=FIO.RdBin(ff,j,2) ; (*������ ��砫� ��ᯥਬ. ������- 㦥 ��������.*)
      FIO.Seek(ff,LONGCARD(index)) ;
      CH:=FIO.RdBin(ff,j,2) ; (*�����䨪��� 䠩�� ��ࠡ�⪨ - 㦥 ��������.*)
      CH:=FIO.RdBin(ff,Perem[5],4) ; (* ������  *)
      CH:=FIO.RdBin(ff,Perem[6],4) ; (* ���ᨬ� *)
      CH:=FIO.RdBin(ff,Perem[7],4) ; (* ��⮦������ *)
      CH:=FIO.RdBin(ff,obr,2) ;      (* 2 ���� ��ࠡ�⪨ *)
      CH:=FIO.RdBin(ff,filtr1,4)   ; (* ������ �࠭�� 䨫���樨 *)
      CH:=FIO.RdBin(ff,filtr2,4)   ; (* ������ �࠭�� 䨫���樨 *)
      CH:=FIO.RdBin(ff,j,2)        ; (* ���⠭�� ��室� *)
          Perem[8] :=REAL(j) ;
      FIO.Close(ff) ;

(* �뢮� �⨪�⪨ *)
     j  := 0 ;
     LOOP
         Str.ItemS(stroka,shabl1,'|',j) ;
         IF Str.Length(stroka)=0 THEN EXIT END ;
         Write1Str(2,SHORTCARD(7+j),8AH,stroka) ;
         CASE j OF 3,4,8 : Str.CardToStr(LONGCARD(Perem[j]),stroka,10,ok) ;
                           i:=32 ;
                     ELSE  Str.RealToStr(LONGREAL(Perem[j]),10,FALSE,stroka,ok) ;
                           i:=31 ;
         END ;
         Write1Str(SHORTCARD(i),SHORTCARD(7+j),8CH,stroka) ;
         INC(j) ;
     END ; (* loop *)

(*   ⥪�� ��� �뢮�� ��⮤�� ��ࠡ�⪨      *)
(* � �ᯠ����� ���� ���⮢ ��⮤� ��ࠡ�⪨ *)
    Write1Str(55,6,8BH,'������ ���������') ;
         (* ��㥬 ������� ��� ���� ��������� *)
    i:= 0 ; CH:= 1 ;
    LOOP
         Str.ItemS(stroka,shabl2,'|',i) ;
         IF Str.Length(stroka)=0 THEN EXIT END ;
         Write1Str(48,SHORTCARD(7+i),8AH,stroka) ;
         j:=CARDINAL(BITSET(obr)*BITSET(CH)) ;
         IF j=0 THEN
              Write1Str(75,SHORTCARD(7+i),8AH,'���')
         ELSE Write1Str(75,SHORTCARD(7+i),8CH,'��') ;
(*            IF  ��� 䠩��� .SPL � .SPR   *)
              IF CH=20H THEN (* �᫨ ���� 䨫����� � ��।��塞 �࠭��� *)
                    Write1Str(5,17,8AH,'������  �࠭�� 䨫���') ;
                     Str.RealToStr(LONGREAL(filtr1),10,FALSE,stroka,ok) ;
                    Write1Str(31,17,8CH,stroka) ;
                    Write1Str(5,18,8AH,'������ �࠭�� 䨫���') ;
                     Str.RealToStr(LONGREAL(filtr2),10,FALSE,stroka,ok) ;
                    Write1Str(31,18,8CH,stroka) ;
              END ; (* if   䨫���樨 *)
(* ��� 䠩��� ᯥ��ࠫ��� *)
              IF (bool)AND(CH>=40H)AND(CH<=0800H) THEN
                  Write1Str(4,20,8AH,'p���襭�� �� ����  (��)') ;
                  Str.RealToStr(LONGREAL(Perem[9]),8,FALSE,stroka,ok) ;
                  Write1Str(32,20,8CH,stroka) ;
                  bool:= FALSE;
              END ;

         END ; (* IF *)
         CH:=CH<<1 ;   INC(i) ;
    END ; (* loop *)

    r.AX := 0501H ;  Lib.Intr(r,10H) ;
    Put_Image(56,128,584,204) ;
    j := 0 ;
    LOOP                                          (* ������ ��ப� ����� *)
         IF IO.KeyPressed() THEN ot := IO.RdCharDirect() ; EXIT END ;
         IF j<=500 THEN
              INC(j)
         ELSE j:=0 ;
              Write1Str(18,24,86H,'��� �த������� ࠡ��� ������ ���� �������') ;
         END ;
    END ;

    r.AX := 0500H ;  Lib.Intr(r,10H);

END titl ;

PROCEDURE analiz_print(): BOOLEAN ;

VAR      r               : SYSTEM.Registers ;
         soob            : ARRAY [0..25] OF CHAR ;
(*         ok              : BOOLEAN ;*)
         p               : BOOLEAN ;
         r1              : SHORTCARD ;
BEGIN
         p:=FALSE ;


   LOOP
      r.DX:=0 ;
      r.AH:=02H ;
      Lib.Intr(r,17H) ;
      IO.WrShtCard(r.AH,3) ;
      CASE r.AH OF 144 : (* ���⠥� *)
                         p:=TRUE ;
                         EXIT ;
                 |  48,
                     8,
                   216 : (* �ਭ�� ��ᮥ����� *)
                         soob:='    �ਭ�� ��ᮥ�����   ';
                 | 200,
                   136 : (* �ਭ�� �몫�祭 *)
                         soob:='     �ਭ�� �몫�祭    ';
                 |  32,
                    56 : (* ��� �㬠�� *)
                         soob:='        ��� �㬠��       ';
                 |   0,
                    24 : (* off line *)
                         soob:=' ��� ��⮢���� �ਭ�� ';
               ELSE
                         soob:='�ਭ�� �� ��⮢ � ࠡ��';
      END ; (* CASE *)
(* ����� �� ��⮢� *)
      Lib.Sound(400) ;
      Get_Image(56,128,584,204) ;
      kvadrat(60,132,580,200,4) ;
      ramka(56,128,584,204,15) ;
      WriteStr(34,10,8AH,'� � � � � �');
      WriteStr(26,12,8AH,soob);
      Lib.NoSound ;
(* ��ப� ���᪠��� *)
      kvadrat(0,335,639,349,6) ;
      WriteStr(3,24,86H,'���࠭�� ����ࠢ����� �ਭ�� � ������ ���� �������') ;
      WriteStr(62,24,89H,'[Esc]') ;
      WriteStr(68,24,86H,'��室') ;
(* ������ ����⢨� �� �� ��⮢���� �ਭ�� *)
      ot:=IO.RdCharDirect() ;
      Put_Image(56,128,584,204) ;
      IF ot=CHAR(27) THEN
            RETURN p ;
      END ; (* IF *)
   END ; (* LOOP *)

   RETURN p ;

END analiz_print ;

PROCEDURE print ;
VAR
    j               : CARDINAL ; (* ������⢮ ����ᥩ � 䠩�� *)
    i,i1,j1,i2,i3   : CARDINAL ; (* ��६����� 横��                       *)
    kol             : LONGCARD ; (* ������⢠ �祪 ॠ����樨            *)
    nach            : CARDINAL ; (* ������ ��砫� ��ᯥਬ��⠫��� ������ *)
    index           : CARDINAL ; (* ������ ��砫� �㦥���� ���ଠ樨     *)
    x,x1            : REAL ;     (*  ��६���� ��� �⥭�� �� 䠩��        *)
    priznak         : CARDINAL ; (* �ਧ��� ��� ����஫� ����樨 �⥭��   *)
    MIN,MAX,                     (* ������ � ���ᨬ�                     *)
    MO,D,ASSIM,                  (* ��⮦������, ��ᯥ��� � ��ᨬ�����   *)
    EKC,M           : REAL ;     (* ������ � ???? *)
    M1,M2,M3,M4     : REAL ;     (* ���������� �㬬 1-�  -  4-� �⥯����   *)
    CKO             : REAL ; (* �।��������筮� �⪫������          *)
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
    nom             : CARDINAL ;      (* �ਧ��� �ᯥ譮�� ������ 䠩�� *)
    FileName        : ARRAY[0..12] OF CHAR ; (* ��� 䠩��                  *)
    CH              : CARDINAL ;       (* ��� ��।������ ��᪨ ��ࠡ�⪨  *)
    stroka          : ARRAY[0..320] OF CHAR ; (* ��ப� ��� �뢮�� ���⮣ࠬ�� *)
    str,str1        : CARDINAL ;
    g               : ARRAY[0..15] OF CARDINAL ;
    pg              : ARRAY[0..15] OF BOOLEAN ;
    mg              : CARDINAL ;
    mk              : REAL ;
    pprint          : SHORTCARD ;
BEGIN
   j:=CARDINAL(FIO.Size(ff)) ;
   j:=CARDINAL(REAL(j)/111.0) ;
   FIO.Seek(ff,0) ;

   FOR i:=1 TO j DO

(* ����� �� �⨪�⪨ 䠩�� *)
      priznak:=FIO.RdBin(ff,FileName,13) ;
      priznak:=FIO.RdBin(ff,data,8) ;
      priznak:=FIO.RdBin(ff,objekt,4) ;
      priznak:=FIO.RdBin(ff,tbegin,4) ;
      priznak:=FIO.RdBin(ff,tend,4) ;
      priznak:=FIO.RdBin(ff,chastota,4) ;
      priznak:=FIO.RdBin(ff,pror,2) ;
      priznak:=FIO.RdBin(ff,obr,2) ;
      priznak:=FIO.RdBin(ff,filtr1,2) ;
      priznak:=FIO.RdBin(ff,filtr2,2) ;
      priznak:=FIO.RdBin(ff,distan,2) ;
(* १����� ���.��ࠡ�⪨ *)
      priznak:=FIO.RdBin(ff,kol,4) ;
      priznak:=FIO.RdBin(ff,MIN,4) ;
      priznak:=FIO.RdBin(ff,MAX,4) ;
      priznak:=FIO.RdBin(ff,MO,4) ;
      priznak:=FIO.RdBin(ff,D,4) ;
      priznak:=FIO.RdBin(ff,CKO,4) ;
      priznak:=FIO.RdBin(ff,ASSIM,4) ;
      priznak:=FIO.RdBin(ff,EKC,4) ;
      FOR i1:=0 TO 15 DO
         priznak:=FIO.RdBin(ff,GIST[i1],2) ;
      END ; (* FOR *)
(* ������ ��� ��� 䠩� *)
      Get_Image(56,128,584,204) ;
      kvadrat(60,132,580,200,1) ;
      ramka(56,128,584,204,15) ;
      WriteStr(34,10,8AH,'��������');
      WriteStr(24,12,8AH,'� ���� ��⮢ 䠩�');
      WriteStr(44,12,8CH,FileName);
(* ��ப� ���᪠��� *)
      kvadrat(0,335,639,349,6) ;
      WriteStr(7,24,89H,'[P]') ;
      WriteStr(11,24,86H,'����� १���⮢') ;
      WriteStr(37,24,89H,'[�]') ;
      WriteStr(41,24,86H,'�ய����� 䠩�') ;
      WriteStr(62,24,89H,'[Esc]') ;
      WriteStr(68,24,86H,'��室') ;
(* ����� ��ப� ���᪠��� *)
      pprint:=0 ;
      LOOP
         ot:=IO.RdCharDirect() ;
         CASE  ot OF 'p','P' :  (* ����� १���⮢ �� 䠩��� *)
                                pprint:=1 ;
                                EXIT ;
                   | 'c','C' :  (* �ய����� १����� �� 䠩�� *)
                                pprint:=2 ;
                                EXIT ;
                   | CHAR(27) : (* �⪠������ �� ���� *)
                                Put_Image(56,128,584,204) ;
                                RETURN ;
         END ; (* CASE *)
      END ; (* LOOP *)
      Put_Image(56,128,584,204) ;
      IF pprint=1 THEN
         IF analiz_print() THEN
(* ���⪠ ⠡��樨 *)
               pprint:=1 ;
               WrChar(4,CHAR(27)) ; WrChar(4,CHAR(68)) ; WrChar(4,CHAR(0)) ;
(* ��⠭���� ⠡��樨 *)
               WrChar(4,CHAR(27)) ;WrChar(4,CHAR(68)) ;WrChar(4,CHAR(1)) ;WrChar(4,CHAR(23)) ;
               WrChar(4,CHAR(39)) ; WrChar(4,CHAR(58)) ;WrChar(4,CHAR(0)) ;
(* �뢮� �� �ਭ�� १���⮢ ���� *)
               WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrChar(4,CHAR(9)) ; WrStr(4,'�������� ���������') ;
               WrLn(4) ;  WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'�������� ����� ') ; WrStr(4,FileName) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'���������� ���������') ;
               WrLn(4) ; WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'��� ��ᯥਬ���') ;
               WrChar(4,CHAR(9)) ; WrStr(4,data) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'������ ॠ����樨') ;
               WrChar(4,CHAR(9)) ; WrReal(4,MIN,7,1) ;
               WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'��ꥪ�') ;
               WrChar(4,CHAR(9)) ; WrStr(4,objekt) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'���ᨬ� ॠ����樨') ;
               WrChar(4,CHAR(9)) ; WrReal(4,MAX,7,1) ;
               WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'�६� ��砫� ���⪠') ;
               WrChar(4,CHAR(9)) ; WrReal(4,tbegin,7,1) ; WrStr(4,' c.') ;
               WrChar(4,CHAR(9)) ; WrStr(4,'���. ��������') ;
               WrChar(4,CHAR(9)) ; WrReal(4,MO,7,1) ;
               WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'�६� ���� ���⪠') ;
               WrChar(4,CHAR(9)) ; WrReal(4,tend,7,1) ; WrStr(4,' c.') ;
               WrChar(4,CHAR(9)) ; WrStr(4,'��ᯥ���') ;
               WrChar(4,CHAR(9)) ; WrReal(4,D,7,1) ;
               WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'����� ����⨧�樨') ;
               WrChar(4,CHAR(9)) ; WrReal(4,chastota,7,1) ; WrStr(4,' ��') ;
               WrChar(4,CHAR(9)) ; WrStr(4,'���') ;
               WrChar(4,CHAR(9)) ; WrReal(4,CKO,7,1) ;
               WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'������⢮ �祪') ;
               WrChar(4,CHAR(9)) ; WrLngCard(4,kol,5) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'�ᨬ�����') ;
               WrChar(4,CHAR(9)) ; WrReal(4,ASSIM,7,1) ;
               WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'��०������') ;
               WrChar(4,CHAR(9)) ; WrCard(4,pror,1) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'������') ;
               WrChar(4,CHAR(9)) ; WrReal(4,EKC,7,1) ;
               WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'���⠭�� ��室�') ;
               WrChar(4,CHAR(9)) ; WrCard(4,distan,1) ;
               WrLn(4) ; WrLn(4) ;
               WrLn(4) ; WrLn(4) ;
               WrLn(4) ; WrLn(4) ;
(* �뢮� ���⮣ࠬ�� *)
(* ���⪠ ⠡��樨 *)
               WrChar(4,CHAR(27)) ; WrChar(4,CHAR(68)) ; WrChar(4,CHAR(0)) ;
(* ��⠭���� ⠡��樨 *)
               WrChar(4,CHAR(27)) ; WrChar(4,CHAR(68)) ; WrChar(4,CHAR(4)) ;
               WrChar(4,CHAR(10)) ; WrChar(4,CHAR(55)) ; WrChar(4,CHAR(0)) ;
(* ���᫥��� ����⠡� ��� ���⮣ࠬ�� *)
               mg:=GIST[0] ;
               FOR i1:=1 TO 15 DO
                   IF mg<GIST[i1] THEN
                         mg:=GIST[i1] ;
                   END ; (* IF *)
               END ; (* FOR *)
               mk:=200.0/REAL(mg) ;
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
                     IF REAL(200-(j1-1)*8-8)<(REAL(GIST[i1])*mk) THEN
                           str:=0 ;
                           i3:=0 ;
                           FOR i2:=8 TO 1 BY -1 DO
                               IF REAL(200-(j1-1)*8-i2)<(REAL(GIST[i1])*mk) THEN
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
(* ����� ����� ���祭�� *)
                  IF j1=1 THEN
                        WrChar(4,CHAR(9)) ; WrCard(4,mg,5) ; WrChar(4,CHAR(9)) ;
                     ELSE
                        IF j1=25 THEN
                              WrChar(4,CHAR(9)) ; WrStr(4,'    0') ; WrChar(4,CHAR(9)) ;
                           ELSE
                              IF (CARDINAL((j1)DIV(5))*5)=j1 THEN
                                    WrChar(4,CHAR(9)) ; WrCard(4,CARDINAL(REAL(mg)*REAL(25-j1)/25.0),5) ; WrChar(4,CHAR(9)) ;
                                 ELSE
                                    WrChar(4,CHAR(9)) ; WrChar(4,CHAR(9)) ;
                              END ; (* IF *)
                        END ; (* IF *)
                  END ; (* IF *)
(* ��ॢ�� �ਭ�� � ����᪨� ०�� *)
                  WrChar(4,CHAR(27)) ; WrChar(4,CHAR(42)) ;
                  WrChar(4,CHAR(0)) ;
                  WrChar(4,CHAR(65)) ; WrChar(4,CHAR(1)) ;
(* ����� ��ନ஢����� ��ப� *)
                  WrBin(4,stroka,321) ;
                  WrLn(4) ;
(* ����� �뢮�� ���⮣ࠬ�� *)
               END ; (* FOR *)

(* ᤢ�� ��䨪� *)
               WrChar(4,CHAR(9)) ; WrChar(4,CHAR(9)) ;
(* ��ॢ�� �ਭ�� � ����᪨� ०�� *)
               WrChar(4,CHAR(27)) ; WrChar(4,CHAR(42)) ;
               WrChar(4,CHAR(0)) ;
               WrChar(4,CHAR(65)) ; WrChar(4,CHAR(1)) ;
(* ����� ������ ��ப� *)
               FOR i1:=0 TO 320 DO
                  stroka[i1]:=CHAR(128) ;
               END ; (* FOR *)
               stroka[0]:=CHAR(255) ; stroka[320]:=CHAR(255) ;
               WrBin(4,stroka,321) ;
(* ��ॢ�� ��ப� �� ⥪�⮢�� ��࠭� *)
               WrChar(4,CHAR(27)) ; WrChar(4,CHAR(50)) ;
               WrLn(4) ;
(* ����� ������� ⥪�� *)
               WrChar(4,CHAR(9)) ; WrReal(4,MIN,7,1) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'   ') ;WrReal(4,MAX,7,1) ; WrLn(4) ;
               WrStr(4,'                            ') ;
               WrStr(4,'蠣 = ') ; WrReal(4,(MAX-MIN)/16.0,7,1) ; WrLn(4) ;
(* �ண�� ��࠭��� *)
               WrChar(4,CHAR(12)) ;
         END ; (* ������ ��⮢���� �ਭ�� *)
      END ; (* IF ������ ��� ��� *)
   END ; (* FOR *)
END print ;

PROCEDURE view ;

VAR i               : LONGCARD ; (* ������⢮ ��ࠡ�⠭��� 䠩��� *)
    i1              : CARDINAL ;

    pm              : CARDINAL ;
    nom             : CARDINAL ;
    nom_f           : CARDINAL ;
    p               : BOOLEAN ;  (* �ਧ��� �� �뢮�� ����� ���⨭�� *)
BEGIN
   p:=TRUE ;
   (* ���⥪᭠� ���᪠��� *)
   kvadrat(0,335,639,349,6) ;
   WriteStr(7,24,89H,'[^V]') ;
   WriteStr(12,24,86H,'��६�饭�� �����') ;
   WriteStr(37,24,89H,'[Enter]') ;
   WriteStr(45,24,86H,'�롮� ०���') ;
   WriteStr(62,24,89H,'[Esc]') ;
   WriteStr(68,24,86H,'��室') ;
   (* ������� ��� ��樨 '�뢮�' *)
   Get_Image(345,26,518,60) ;
   kvadrat(345,26,518,60,88H) ;
   ramka(345,26,518,60,82H) ;
   nom_f := 0 ;
   pm:=1 ;
(* �롮� ०��� �뢮�� ���ଠ樨 *)
   LOOP
      IF pm=1 THEN
            kvadrat(346,27,517,42,88H) ;
            kvadrat(346,44,517,59,3) ;
            WriteStr(44,2,86H,'�뢮� 䠩�� �� ��࠭') ;
            WriteStr(44,3,86H,' ����� ��� 䠩���') ;
         ELSE
            kvadrat(346,27,517,42,3) ;
            kvadrat(346,44,517,59,88H) ;
            WriteStr(44,2,86H,'�뢮� 䠩�� �� ��࠭') ;
            WriteStr(44,3,86H,' ����� ��� 䠩���') ;
      END ; (* IF *)
      ot:=IO.RdCharDirect() ;
      CASE ot OF (CHAR(72))  : (* ����� *)
                               pm:=1 ;
               | (CHAR(80))  : (* ����  *)
                               pm:=2 ;
               | (CHAR(0DH)) : (* ����  *)
                               EXIT ;
               | (CHAR(27))  : (* Esc   *)
                               pm:=3 ;
                               EXIT ;
      END ; (* CASE *)
   END ; (* LOOP *)
   ff:=FIO.Open('STAT.REZ') ;
   nom:=FIO.IOresult() ;
   IF nom<>0 THEN
      pm:=3 ;
   END ; (* IF *)
   IF pm<>3 THEN
      FIO.AssignBuffer(ff,buf) ;
      i:=FIO.Size(ff) ;
      i:=LONGCARD(REAL(i)/111.0) ;
   END ;
LOOP
CASE pm OF 1 : (* �뢮� ��室��� ������ �� ��࠭ *)
   (* ���⥪᭠� ���᪠��� *)
   kvadrat(0,335,639,349,6) ;
   WriteStr(7,24,89H,'[^V]') ;
   WriteStr(12,24,86H,'��६�饭�� �����') ;
   WriteStr(33,24,89H,'[Enter]') ;
   WriteStr(41,24,86H,'��ᬮ�� १���⮢') ;
   WriteStr(62,24,89H,'[Esc]') ;
   WriteStr(68,24,86H,'��室') ;

   (*Get_Image(6,68,410,328) ;*)
   vibor (INTEGER(i)) ;
(* ���⪠ ������ ��࠭� *)
(*   Put_Image(6,68,410,328) ;*)
(*   Fon_Screen ;
   put() ;
   Spisok() ;*)
   EXIT ;
         | 2 : (* �뢮� ��� 䠩��� �� ����� *)
                  print ;
                  EXIT ;
              ELSE
                  (* ��� ��ࠡ�⠭��� 䠩��� *)
                  EXIT ;
   END ; (* CASE *)
END ; (* LOOP *)
   FIO.Close(ff) ;
(* ���⪠ ������� *)
   Put_Image(345,26,518,60) ;
END view ;

PROCEDURE vibor (n : INTEGER ) ;
(* �롮� ��ᬠ�ਢ������ 䠩��, n - ������⢮ 䠩��� *)
VAR i         : INTEGER ;

BEGIN
   FOR i:=0 TO n-1 DO
      FIO.Seek(ff,LONGCARD(i*111)) ;
      priznak:=FIO.RdBin(ff,name_file[i+1],13) ;
      pri_file[i+1]:=FALSE ;
   END ;
(* �뢮� ��� ���� �� ��࠭ *)
   FOR i:=1 TO n DO
      IF i>16 THEN
            kvadrat(536,CARDINAL(i-10)*14,536+96,CARDINAL(i-9)*14,3) ;
            WriteStr(67,SHORTCARD(i-10),83H,name_file[i]);
         ELSE
            kvadrat(432,CARDINAL(i+6)*14,432+96,CARDINAL(i+7)*14,3) ;
            WriteStr(54,SHORTCARD(i+6),83H,name_file[i]);
      END ; (* IF *)
   END ; (* FOR *)
(* �롮� �㦭��� 䠩�� *)
   i:=1 ;
   LOOP

      IF i>16 THEN
            WriteStr(67,SHORTCARD(i-10),0FH,name_file[i]);
         ELSE
            WriteStr(54,SHORTCARD(i+6),0FH,name_file[i]);
      END ; (* IF *)

      ot:=IO.RdCharDirect () ;
      CASE ot OF (CHAR(00))  : ot:=IO.RdCharDirect() ;

      CASE ot OF (CHAR(72))  : (* ����� *)
                               IF i>1 THEN

      IF i>16 THEN
            kvadrat(536,CARDINAL(i-10)*14,536+96,CARDINAL(i-9)*14,3) ;
            WriteStr(67,SHORTCARD(i-10),83H,name_file[i]);
         ELSE
            kvadrat(432,CARDINAL(i+6)*14,432+96,CARDINAL(i+7)*14,3) ;
            WriteStr(54,SHORTCARD(i+6),83H,name_file[i]);
      END ; (* IF *)
                                     i:=i-1 ;
                               END ; (* IF *)

               | (CHAR(80))  : (* ����  *)
                               IF i<n THEN

      IF i>16 THEN
            kvadrat(536,CARDINAL(i-10)*14,536+96,CARDINAL(i-9)*14,3) ;
            WriteStr(67,SHORTCARD(i-10),83H,name_file[i]);
         ELSE
            kvadrat(432,CARDINAL(i+6)*14,432+96,CARDINAL(i+7)*14,3) ;
            WriteStr(54,SHORTCARD(i+6),83H,name_file[i]);
      END ; (* IF *)
                                     i:=i+1 ;
                               END ; (* IF *)

               | (CHAR(75))  : (* ����� *)
                               IF i>16 THEN

      IF i>16 THEN
            kvadrat(536,CARDINAL(i-10)*14,536+96,CARDINAL(i-9)*14,3) ;
            WriteStr(67,SHORTCARD(i-10),83H,name_file[i]);
         ELSE
            kvadrat(432,CARDINAL(i+6)*14,432+96,CARDINAL(i+7)*14,3) ;
            WriteStr(54,SHORTCARD(i+6),83H,name_file[i]);
      END ; (* IF *)
                                     i:=i-16 ;
                               END ; (* IF *)
               | (CHAR(77))  : (* ��ࠢ�*)
                               IF i+16 <=n THEN

      IF i>16 THEN
            kvadrat(536,CARDINAL(i-10)*14,536+96,CARDINAL(i-9)*14,3) ;
            WriteStr(67,SHORTCARD(i-10),83H,name_file[i]);
         ELSE
            kvadrat(432,CARDINAL(i+6)*14,432+96,CARDINAL(i+7)*14,3) ;
            WriteStr(54,SHORTCARD(i+6),83H,name_file[i]);
      END ; (* IF *)
                                    i:=i+16 ;
                               END ; (* IF *)
      END ; (* CASE *)
               | (CHAR(27))  : (* Esc   *)
                               EXIT ;
               | (CHAR(0DH)) : (* Enter *)
                               (* ��ᬮ�� ������ 䠩�� *)
                               rez_list(LONGCARD(i)) ;
      END ; (* CASE *)
   END ; (* LOOP *)

   IF i>16 THEN
         kvadrat(536,CARDINAL(i-10)*14,536+96,CARDINAL(i-9)*14,3) ;
         WriteStr(67,SHORTCARD(i-10),83H,name_file[i]);
      ELSE
         kvadrat(432,CARDINAL(i+6)*14,432+96,CARDINAL(i+7)*14,3) ;
         WriteStr(54,SHORTCARD(i+6),83H,name_file[i]);
   END ; (* IF *)

END vibor ;

PROCEDURE rez_list(n : LONGCARD ) ;

VAR il             : CARDINAL ;
(*    name           : ARRAY [0..12] OF CHAR ;*)
   m                 : CARDINAL ; (* ���ᨬ��쭮� ���祭�� ��� ���⮣ࠬ�� *)
BEGIN
   Eng:=FALSE ;
   FIO.Seek(ff,(n-1)*111+13+34) ;
(*   priznak:=FIO.RdBin(ff,name,13) ;*)
   priznak:=FIO.RdBin(ff,kol,4) ;
          Str.CardToStr(LONGINT(kol),kol1,10,OK) ;
   priznak:=FIO.RdBin(ff,MIN,4) ;
          Str.RealToStr(LONGREAL(MIN),10,Eng,MIN1,OK) ;
   priznak:=FIO.RdBin(ff,MAX,4) ;
          Str.RealToStr(LONGREAL(MAX),10,Eng,MAX1,OK) ;
   priznak:=FIO.RdBin(ff,MO,4) ;
          Str.RealToStr(LONGREAL(MO),10,Eng,MO1,OK) ;
   priznak:=FIO.RdBin(ff,D,4) ;
          Str.RealToStr(LONGREAL(D),10,Eng,D1,OK) ;
   priznak:=FIO.RdBin(ff,CKO,4) ;
          Str.RealToStr(LONGREAL(CKO),10,Eng,CKO1,OK) ;
   priznak:=FIO.RdBin(ff,ASSIM,4) ;
          Str.RealToStr(LONGREAL(ASSIM),10,Eng,ASSIM1,OK) ;
   priznak:=FIO.RdBin(ff,EKC,4) ;
          Str.RealToStr(LONGREAL(EKC),10,Eng,EKC1,OK) ;
   FOR il:=0 TO 15 DO
         priznak:=FIO.RdBin(ff,GIST[il],2) ;
   END ; (* FOR *)


      kvadrat(6,68,410,328,1) ;
      ramka(6,68,410,328,15) ;
      WriteStr(15,5,8AH,'䠩� ');
      WriteStr(20,5,8CH,name_file[CARDINAL(n)]);
      WriteStr(5,6,8AH,'������⢮ �祪');
      WriteStr(33,6,8CH,kol1 );
      WriteStr(5,7,8AH,'���ᨬ� ॠ����樨');
      WriteStr(32,7,8CH,MAX1 );
      WriteStr(5,8,8AH,'������ ॠ����樨');
      WriteStr(32,8,8CH,MIN1 );
      WriteStr(5,9,8AH,'��⥬���᪮� ��������');
      WriteStr(32,9,8CH,MO1 );
      WriteStr(5,10,8AH,'��ᯥ���');
      WriteStr(32,10,8CH,D1 );
      WriteStr(5,11,8AH,'���');
      WriteStr(32,11,8CH,CKO1 );
      WriteStr(5,12,8AH,'��ᨬ�����');
      WriteStr(32,12,8CH,ASSIM1 );
      WriteStr(5,13,8AH,'������');
      WriteStr(32,13,8CH,EKC1 );
      m := GIST[0] ;
      FOR il:=1 TO 15 DO
         IF m<GIST[il] THEN
               m := GIST[il] ;
         END ;
      END ; (* FOR *)

      FOR il:=0 TO 15 DO
         kvadrat(il*14+14+80,CARDINAL(300.0-100.0*(REAL(GIST[il])/REAL(m))),il*14+26+80,300,0DH) ;
      END ; (* FOR *)
END rez_list ;

PROCEDURE Fon_Screen ; (* ������ � *)
VAR i,j : CARDINAL ;
BEGIN
      SYSTEM.Out(3CEH,1)  ; (* ॣ���� ࠧ�襭�� ��⠭���� 梥� *)
      SYSTEM.Out(3CFH,00H); (* ࠧ�蠥� �������� ���� � ���᪮���� /����/*)
      SYSTEM.Out(3C4H,2)  ; (* ॣ���� ��᪨ ��⮢�� ���᪮�⥩ *)
      SYSTEM.Out(3C5H,0FH); (* ࠧ�蠥� �������� �� ���᪮�� *)
      FOR i := 36 TO 334 BY 2 DO
           j := i*80 ;
           Lib.WordFill([0A000H:j],40,1111H) ;
           Lib.WordFill([0A000H:j+80],40,4444H) ;
      END ; (* for *)
      SYSTEM.Out(3CEH,1)  ; (* ॣ���� ࠧ�襭�� ��⠭���� 梥� *)
      SYSTEM.Out(3CFH,0)  ; (* 1 - ���������  ��⠭���� 梥� *)
END Fon_Screen ;


END prosmotr.