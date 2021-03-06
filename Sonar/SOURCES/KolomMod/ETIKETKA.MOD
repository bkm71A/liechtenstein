IMPLEMENTATION MODULE Etiketka ;

              IMPORT Graph,SYSTEM,Lib,Str  ,FIO ;
FROM IO       IMPORT RdCharDirect,KeyPressed ;

FROM Gra      IMPORT Set_Out_Adapter,WriteStr,
                     BoxFull,Box,SetChar ;
FROM mouse    IMPORT Wait,MousFunc,MousGet,Trigger,r,answ_mouse ;
              IMPORT AsmImage,FILE ;

TYPE  asas   = ARRAY[0..1],[0..28] OF CHAR ;

CONST Dlja   = '��� �த������� ������ ���� �������';

                (* ��࠭���� ����� ��ࢮ� � ��ன ��࠭�楩 *)
PROCEDURE SavePiceImage(A0:CARDINAL) ;
CONST X1 = 68 ; Y1 = 141;
      X2 = 572; Y2 = 195;
VAR i,b,rr,nn : CARDINAL ;
    ofs1,ofs2 : CARDINAL ;
BEGIN nn := Y1*80+(X1>>3); (* �a砫� ����ࠦ���� *)
      rr := ((X2>>3)-(X1>>3))+1 ;
     b:=28080 ;
     SYSTEM.Out(3CEH,8) ;  (* ॣ���� ��᪨ *)
     SYSTEM.Out(3CFH,0) ;  (* 0 ����頥� ��������� ��⮢ � ���� ����ࠦ���� *)
     FOR i:=Y1 TO Y2 DO
        Lib.Move([0A000H:nn],[A0:b],rr) ;
        nn := nn+80 ;
        b  := b +rr ;
     END ;
     Set_Out_Adapter ;
END SavePiceImage ;

PROCEDURE RestorePiceImage(A0:CARDINAL) ;
CONST X1 = 68 ; Y1 = 141;
      X2 = 572; Y2 = 195;
VAR b,i,rr,nn : CARDINAL ;
BEGIN nn := Y1*80+(X1>>3); (* ��砫� ����ࠦ���� *)
      rr := ((X2>>3)-(X1>>3))+1 ;
     b := 28080 ;
     SYSTEM.Out(3CEH,8) ;  (* ॣ���� ��᪨ *)
     SYSTEM.Out(3CFH,0) ;  (* 0 ����頥� ��������� ��⮢ � ���� ����ࠦ���� *)
     FOR i:=Y1 TO Y2 DO
        Lib.Move([A0:b],[0A000H:nn],rr) ;
        nn := nn+80 ;
        b  := b +rr ;
     END ;
     Set_Out_Adapter ;
END RestorePiceImage ;

PROCEDURE Get_Kol_Byte_Font():CARDINAL ;
BEGIN
    r.AX := 1130H ; (* ���� ���ଠ�� � ⥪�饬 ���ﭨ� EGA  *)
    r.BH :=    1H ; (* ⥪�騩 ���� 䮭⮢ EGA *)
    Lib.Intr(r,10H) ;
               (* ������ - ������⢮ ���⮢ 䮭� �� ᨬ��� *)
    RETURN r.CX
END Get_Kol_Byte_Font ;

PROCEDURE Paint_Box(a,b : CARDINAL) ;
VAR i : CARDINAL ;
BEGIN BoxFull(68+3,141+3,572-3,195-3,a) ;
      FOR i:=0 TO 2 DO
         Box(68+i,141+i,572-i,195-i,b) ;
         IF i=0 THEN b:=0 END ;
      END;
END Paint_Box ;

PROCEDURE Error(aa : CARDINAL) ;
CONST nol = 0 ;
VAR bb,cc : SHORTCARD ;
    str   : ARRAY[0..12] OF CHAR ;
    pr    : BOOLEAN ;
LABEL con ;
BEGIN
      SavePiceImage(0A000H) ;
      Lib.Sound(300) ;
      Paint_Box(4,15) ;
      IF  Get_Kol_Byte_Font()<14 THEN
           bb:=19; cc:=3
      ELSE bb:=11; cc:=1
      END ;
      IF aa#10H THEN WriteStr(nol,10,bb,8AH,'� � � � � � !') END ;
      CASE aa OF 1 : WriteStr(nol,26,bb,8BH,'��ଠ� ������ �� ᮮ⢥����� �ॡ㥬���.')
               | 2 : WriteStr(nol,24,bb,8BH,'����७�� 䠩�a �� ᮮ⢥����� �ॡ������.')
               | 3 : WriteStr(nol,26,bb,8BH,'�� �뫮 ��।����� ���ன�⢮ ����� ������.')
               | 4 : WriteStr(nol,30,bb,8BH,'�� ��।����� 䠩�� ��� ��ࠡ�⪨.')
               | 5 : WriteStr(nol,30,bb,8BH,'� ����� ��� ���� ��� ����㧪� ���૥�.')
               | 6 : WriteStr(nol,25,bb,8BH,'��� ���������� ����㧨�� ���૥�. ��� ') ;

               | 7 : WriteStr(nol,32,bb,8BH,'�� ��᪥ �������筮 ����.') ;
               | 8 : WriteStr(nol,32,bb,8BH,'���ன�⢮ ���� �� ��⮢�');

               |10H: WriteStr(nol,10,bb,8AH,'����� ०�� �।�����祭 ��� ���쭥�襣� ���७�� ��⥬�')

               |80H: WriteStr(nol,30,bb,8BH,'��� ���饭 �� �����')
               |82H: WriteStr(nol,32,bb,8BH,'���ன�⢮ �� ��⮢�');
               |89H: WriteStr(nol,29,bb,8BH,'�� �ਭ�� ����� �㬠��') ;
      ELSE           WriteStr(nol,28,bb,8BH,'�訡�� �� ࠡ�� � ��᪮�') ;
      END ;
      Lib.NoSound ;
      IF aa=8 THEN (* Blinc_ImageMouse2(st) ; *) GOTO con
      ELSE         WriteStr(nol,22,bb+cc,83H,Dlja)
      END ;
      Trigger ;
      Wait ;
con :
     RestorePiceImage(0A000H) ;
END Error ;


PROCEDURE One_Minute_On ;
BEGIN SavePiceImage(0A800H) ;
      Paint_Box(1,0AH) ;
      AsmImage.WriteStr_XY(0,210,165,8CH,'�਩����� ������� ���������...') ;
END One_Minute_On ;

PROCEDURE One_Minute_Off ;
BEGIN RestorePiceImage(0A800H) ;
END One_Minute_Off ;


PROCEDURE Analiz (file_name : ARRAY OF CHAR ) : BOOLEAN ;
VAR  ident    : ARRAY [0..2] OF CHAR ;
     CH,index : CARDINAL ;
     ff       : FIO.File ;
     Bufer    : ARRAY[0..1*512+FIO.BufferOverhead] OF BYTE ;
BEGIN
   ident[HIGH(ident)] :=CHR(0) ;
   ff:=FIO.Open(file_name) ;
   FIO.AssignBuffer(ff,Bufer) ;
   CH := FIO.RdBin(ff,index,2) ;
   FIO.Seek(ff,LONGCARD(index)); (* ��⠭�������� 㪠�. �� ��砫� ����. ���. *)
   (* �����䨪��� 䠩�� ��ࠡ�⪨ *)
   CH:=FIO.RdBin(ff,ident,2) ;
   FIO.Close(ff) ;
   IF (ident[0]='S')AND(ident[1]='W') THEN (* 'SW' ��������� � 䠩�� *)
      RETURN TRUE
   ELSE (* ���ࠢ���� �ଠ� ������ � 䠩�� *)
      Error(1) ;
      RETURN FALSE
   END ; (* IF *)
END Analiz ;


END Etiketka.