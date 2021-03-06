IMPLEMENTATION MODULE Etiketka ;

              IMPORT SYSTEM,Lib,Str  ,FIO ;
FROM IO       IMPORT RdCharDirect,KeyPressed ;

FROM Gra      IMPORT Get_Image,Put_Image,WriteStr,BoxFull,Box,SetChar ;
FROM mouse    IMPORT Wait,MousFunc,Trigger,r ;

VAR  ff    : FIO.File ;
     Bufer : ARRAY[0..2047+FIO.BufferOverhead] OF BYTE ;

PROCEDURE OutPut_Eticet_Screen(file_name : ARRAY OF CHAR ) ; FORWARD ;

PROCEDURE Paint_Box(a,b : CARDINAL) ;
BEGIN  BoxFull(68,141,572,195,0) ;
       BoxFull(68+4,141+4,572-4,195-4,a) ;
       Box(68,141,572,195,b) ;
END Paint_Box ;

PROCEDURE Error(aa : CARDINAL) ;
BEGIN Get_Image(68,141,572,195) ;
      Lib.Sound(400) ;
      Paint_Box(4,15) ;
      WriteStr(0,10,11,8AH,'� � � � � � !');
      CASE aa OF 1 : WriteStr(0,26,11,8BH,'��ଠ� ������ �� ᮮ⢥����� �ॡ㥬���.');
               | 2 : WriteStr(0,26,11,8BH,'�⬥祭��� 䠩��� �� ����� ���� ����� 32-��.');
               | 3 : WriteStr(0,26,11,8BH,'�� �뫮 ��।����� ���ன�⢮ ����� ������.');
               | 4 : WriteStr(0,30,11,8BH,'�� ��।����� 䠩�� ��� ��ࠡ�⪨.');
               | 5 :

               |80H: WriteStr(0,30,11,8BH,'��� ���饭 �� �����')
               |82H: WriteStr(0,32,11,8BH,'���ன�⢮ �� ��⮢�');
               |89H: WriteStr(0,29,11,8BH,'�� �ਭ�� ����� �㬠��') ;
      ELSE           WriteStr(0,28,11,8BH,'�訡�� �� ࠡ�� � ��᪮�') ;
      END ;
      Lib.NoSound  ;
      WriteStr(0,22,12,83H,'��� �த������� ������ ���� �������');
      Trigger ;
      Wait ;
      Put_Image(68,141,572,195) ;
END Error ;

PROCEDURE Warning(aa : CARDINAL): BOOLEAN ;
VAR zavershit : BOOLEAN ;
BEGIN Get_Image(68,141,572,195) ;
      Get_Image(0,336,630,349)  ; (* ��࠭塞 ��ப� ���᪠��� *)
      Lib.Sound(1000) ;
      Paint_Box(1,0AH) ;
      WriteStr(0,26,11,8CH,'� � � � � � � � � � � � � �.') ;
      CASE aa OF 1 : WriteStr(0,11,12,8AH,'����� ����� � ��⮬���᪮� ���४樨 �ਮ�⠭�����.');
                     BoxFull(352,336,630,349,6) ;
                     WriteStr(0,44,24,8BH,'�������� ������� ��ࠡ���');
                |2 :
      END ;
      Lib.NoSound  ;
      Trigger ;
      LOOP
          MousFunc(3,0,0,0) ;     (* �뫠 �� ����� "Esc" *)
          IF r.BX=4             THEN zavershit := TRUE ; EXIT END ;
          IF (r.BX=2)OR(r.BX=1) THEN zavershit := FALSE; EXIT END ;
      END ; (* loop *)

      Put_Image(0,336,630,349)  ; (* ����⠭�������� ��ப� ���᪠��� *)
      Put_Image(68,141,572,195) ;
      MousFunc(5,2,0,0) ;  (* ��ᨫ� ���稪 �᫨ �������� �।�.����. *)
      RETURN zavershit ;
END Warning ;


PROCEDURE Analiz (file_name : ARRAY OF CHAR ) : BOOLEAN ;
VAR  ident    : ARRAY [0..2] OF CHAR ;
     CH,index : CARDINAL ;
BEGIN
   ident[HIGH(ident)] :=CHR(0) ;
   ff:=FIO.Open(file_name) ;
   FIO.AssignBuffer(ff,Bufer) ;
   CH := FIO.RdBin(ff,index,2) ;
   FIO.Seek(ff,LONGCARD(index)); (* ��⠭�������� 㪠�. �� ��砫� ����. ���. *)
   (* �����䨪��� 䠩�� ��ࠡ�⪨ *)
   CH:=FIO.RdBin(ff,ident,2) ;
   FIO.Close(ff) ;
   IF Str.Match(ident,'SW') THEN RETURN TRUE
                            ELSE (* ���ࠢ���� �ଠ� ������ � 䠩�� *)
                                 Error(1) ;
                                 RETURN FALSE
   END ; (* IF *)
END Analiz ;

PROCEDURE Prosmotr(file_name: ARRAY OF CHAR ) ;
VAR ident    : ARRAY [0..2] OF CHAR ;
    CH,index : CARDINAL ;
BEGIN
      ident[HIGH(ident)] :=CHR(0) ;
      ff:=FIO.Open(file_name) ;
      FIO.AssignBuffer(ff,Bufer) ;
      CH:= FIO.RdBin(ff,index,2) ;  (* ��।����� ���. �㦥���� ����. *)
      FIO.Seek(ff,LONGCARD(index)) ;

      CH:=FIO.RdBin(ff,ident,2) ;   (* �����䨪��� 䠩�� ��ࠡ�⪨ *)
      FIO.Close(ff) ;
      IF Str.Match(ident,'SW')
      THEN   (* �ࠢ���� �ଠ� ������ � 䠩�� *)
           Get_Image(68,141,572,195) ;
           Paint_Box(1,0AH) ;
           WriteStr(0,38,11,8CH,'����� !');
           WriteStr(0,26,12,86H,'���� �ᯠ����� �⨪�⪨ 䠩��');
                   (* �ᯠ����� � �뢮� �⨪�⪨ 䠩�� *)
           OutPut_Eticet_Screen(file_name) ;
      ELSE                            (* ���ࠢ���� �ଠ� ������ � 䠩�� *)
           Error(1) ;
      END ; (* IF *)
      Trigger ;
END Prosmotr ;

PROCEDURE OutPut_Eticet_Screen(file_name : ARRAY OF CHAR ) ;
(*****************************************************)
(*              ��ᬮ�� �⨪�⪨ !!!!!!!!            *)
(*****************************************************)
CONST shabl1 ='�६� ��砫� ���⪠ �����|'+
              '�६� ���� ���⪠ �����|'+
              '���� ����⨧�樨|'+
              '������⢮ �祪 ॠ����樨|'+
              '��०������|'+
              '������|'+
              '���ᨬ�|'+
              '��⮦������|'+
              '���⠭�� ��室�|' ;
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

VAR
    index    : CARDINAL ; (* ������ ��砫� �㦥���� ���ଠ樨 *)
    stroka   : ARRAY[0..25] OF CHAR ;
    Perem    : ARRAY[0.. 9] OF REAL ;
    Long     : LONGCARD ;

    data     : ARRAY [0..8] OF CHAR ; (* ��� ��ᯥਬ��� *)
    objekt   : ARRAY [0..4] OF CHAR ; (* ��ꥪ� *)

    obr      : CARDINAL ;

    filtr1   : REAL     ; (* ������ �࠭�� 䨫���樨 *)
    filtr2   : REAL     ; (* ������ �࠭�� 䨫���樨 *)
    distan   : CARDINAL ; (* ���⠭�� ��室� *)

    i,j,CH   : CARDINAL ;
    ok       : BOOLEAN ;
    ot       : CHAR ;

BEGIN
      data  [HIGH(data)]   :=CHR(0) ;
      objekt[HIGH(objekt)] :=CHR(0) ;
      ff:=FIO.Open(file_name) ;
      FIO.AssignBuffer(ff,Bufer) ;
(* ���������� 䮭� 2-� ��࠭��� ��࠭� *)
      SYSTEM.Out(3CEH,1)  ;    (* ࠧ�蠥� ������ �� �� ��⮢� ���᪮�� *)
      SYSTEM.Out(3CFH,0EH) ;
         Lib.WordFill([0A800H:0000H],14000,0FFFFH) ;
      SYSTEM.Out(3CEH,1) ;    (* ����⠭�������� ��� *)
      SYSTEM.Out(3CFH,0) ;
(* ����⮢�窠 �ᥣ� ��࠭� *)
      SetChar(1, 0,0,SHORTCARD('�'),1,8AH) ;
      SetChar(1, 1,0,SHORTCARD('�'),34,8AH) ;
      SetChar(1,45,0,SHORTCARD('�'),34,8AH) ;
      SetChar(1,79,0,SHORTCARD('�'),1,8AH) ;
      FOR i := 1 TO 23 DO
          SetChar(1, 0,SHORTCARD(i),SHORTCARD('�'),1,8AH) ;
          SetChar(1,79,SHORTCARD(i),SHORTCARD('�'),1,8AH) ;
      END ;
      SetChar(1,0,24,SHORTCARD('�'),1,8AH) ;
      SetChar(1,79,24,SHORTCARD('�'),1,8AH) ;
      SetChar(1, 1,24,SHORTCARD('�'),15,8AH) ;
      SetChar(1,64,24,SHORTCARD('�'),15,8AH) ;
         SetChar(1,1,16,SHORTCARD('�'),46,86H) ;
         SetChar(1,1,19,SHORTCARD('�'),46,86H) ;
         SetChar(1,1,21,SHORTCARD('�'),46,86H) ;
(* ����⮢�窠 ���� ��⮤�� ��ࠡ�⪨ *)
      SetChar(1,47,6,SHORTCARD('�'),1,8BH) ;
      SetChar(1,48,6,SHORTCARD('�'),6,8BH) ;
      SetChar(1,72,6,SHORTCARD('�'),6,8BH) ;
      SetChar(1,78,6,SHORTCARD('�'),1,8BH) ;
      FOR i := 7 TO 22 DO
          SetChar(1,47,SHORTCARD(i),SHORTCARD('�'),1,8BH) ;
          SetChar(1,78,SHORTCARD(i),SHORTCARD('�'),1,8BH) ;
      END ;
      SetChar(1,47,23,SHORTCARD('�'),1,8BH) ;
      SetChar(1,78,23,SHORTCARD('�'),1,8BH) ;
      SetChar(1,48,23,SHORTCARD('�'),30,8BH) ;

(* �ନ஢���� �������� *)
      WriteStr(1,36,0,8CH,'��������') ;
      WriteStr(1,31,1,8CH,'䠩�') ;
      WriteStr(1,37,1,8FH,file_name) ;
      WriteStr(1,18,24,86H,'��� �த������� ࠡ��� ������ ���� �������') ;
(* �ନ஢���� ������ �� ����� 䠩�� *)
   Str.Slice(stroka,file_name,1,2) ;
      WriteStr(1,9,4,8AH,'����� ०���');
      WriteStr(1,23,4,8CH,stroka);
   Str.Slice(stroka,file_name,3,2) ;
      WriteStr(1,30,4,8AH,'����� ���०���');
      WriteStr(1,47,4,8CH,stroka);
   Str.Slice(stroka,file_name,5,3) ;
      WriteStr(1,55,4,8AH,'����� ������');
      WriteStr(1,69,4,8CH,stroka);

(* �⥭�� �⨪�⪨ *)
      CH:=FIO.RdBin(ff,index,2) ;   (* ������ ��砫� �㦥���� ���ଠ樨 *)
      CH:=FIO.RdBin(ff,data,8) ;    (* ��� ��ᯥਬ��� *)
   WriteStr(1,15,3,8AH,'��� ��ᯥਬ���') ;
   WriteStr(1,34,3,8CH,data)  ;
      CH:=FIO.RdBin(ff,objekt  ,4) ; (* ��ꥪ� *)
   WriteStr(1,55,3,8AH,'��ꥪ�') ;
   WriteStr(1,63,3,8CH,objekt) ;
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
         WriteStr(1,2,SHORTCARD(7+j),8AH,stroka) ;
         CASE j OF 3,4,8 : Str.CardToStr(LONGCARD(Perem[j]),stroka,10,ok) ;
                           i:=31
                     ELSE  Str.RealToStr(LONGREAL(Perem[j]),10,FALSE,stroka,ok) ;
                           i:=30
         END ;
         WriteStr(1,SHORTCARD(i),SHORTCARD(7+j),8CH,stroka) ;
         INC(j) ;
     END ; (* loop *)

(*   ⥪�� ��� �뢮�� ��⮤�� ��ࠡ�⪨      *)
(* � �ᯠ����� ���� ���⮢ ��⮤� ��ࠡ�⪨ *)
    WriteStr(1,55,6,8BH,'������ ���������') ;
         (* ��㥬 ������� ��� ���� ��������� *)
    i:= 0 ; CH:= 1 ;
    LOOP
         Str.ItemS(stroka,shabl2,'|',i) ;
         IF Str.Length(stroka)=0 THEN EXIT END ;
         WriteStr(1,48,SHORTCARD(7+i),8AH,stroka) ;
         j:=CARDINAL(BITSET(obr)*BITSET(CH)) ;
         IF j=0 THEN
              WriteStr(1,75,SHORTCARD(7+i),8AH,'���')
         ELSE WriteStr(1,75,SHORTCARD(7+i),8CH,'��') ;
              IF CH=20H THEN (* �᫨ ���� 䨫����� � ��।��塞 �࠭��� *)
                    WriteStr(1,5,17,8AH,'������  �࠭�� 䨫���') ;
                     Str.RealToStr(LONGREAL(filtr1),10,FALSE,stroka,ok) ;
                    WriteStr(1,30,17,8CH,stroka) ;
                    WriteStr(1,5,18,8AH,'������ �࠭�� 䨫���') ;
                     Str.RealToStr(LONGREAL(filtr2),10,FALSE,stroka,ok) ;
                    WriteStr(1,30,18,8CH,stroka) ;
              END ; (* if   䨫���樨 *)
(*            IF  ��� 䠩��� .SPL � .SPR   *)
         END ; (* IF *)
         CH:=CH<<1 ;   INC(i) ;
    END ; (* loop *)

    r.AX := 0501H ;  Lib.Intr(r,10H) ;
    Put_Image(68,141,572,195) ;

    j := 0 ;
    LOOP                                          (* ������ ��ப� ����� *)
         IF KeyPressed() THEN ot := RdCharDirect() ; EXIT END ;
         MousFunc(3,0,0,0) ;
         IF r.BX#0 THEN EXIT END ;
         IF j<=440 THEN
              INC(j)
         ELSE j:=0 ;
              WriteStr(1,18,24,86H,'��� �த������� ࠡ��� ������ ���� �������') ;
         END ;
    END ;
    r.AX := 0500H ;  Lib.Intr(r,10H);
END OutPut_Eticet_Screen ;

END Etiketka.