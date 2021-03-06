MODULE mainproc ;
FROM Window IMPORT Open,TextColor,GotoXY,Close,Clear,CursorOff,SetTitle,Use,
                   WinType,WinDef,DoubleFrame,SingleFrame,Color,CenterUpperTitle,
                   FrameStr,RightUpperTitle,DirectWrite,Hide,TextBackground,
                   SetFrame,Change,Used,WhereY,CenterLowerTitle,PutOnTop ;

FROM IO      IMPORT RdCharDirect,WrStr,WrShtCard,WrCard,WrChar ;
             IMPORT Storage,Lib,SYSTEM ;
             IMPORT IO,Str  ;
             IMPORT TxtImage ;
FROM _Window IMPORT Shadow,Close_Sh,Open_Sh ;
CONST mline =' ������� ����� � ��������������� ��������� |'+
    (* ������� ���� *)
            ' ���� � ��࠭���� ������ |'+
            ' ������ ��ࠡ�⪠ |'+
            ' ��ᬮ�� � ���४�� ��ᯥਬ��⠫��� ������ |'+
            ' �।���⥫쭠� ��ࠡ�⪠ |'+
            ' ������ � �।��饥 ���� |'+
    (* ���� ��ࢮ�� ०��� *)
            ' ����� ��஢�� |'+
            ' ����㧪� � ��࠭���� ���ଠ樮���� ���ᨢ�� |'+
            ' ��室 � ������� ���� |'+
    (* ���� �⢥�⮣� ०��� *)
            ' ������᪠� ��ࠡ�⪠ ᨣ���� |'+
            ' ���஢�� ��ࠡ�⪠ ᨣ���� |'+
            ' ��⥬���᪠� ��ࠡ�⪠ ᨣ���� |'+
            ' ��室 � ������� ���� |'+
    (* ���� ०��� ��஢�� *)
            ' ����� �������� ��஢�� |'+
            ' ����� ���������� ��஢�� |'+
(*            ' ������� ⠡���� ��஢�� |'+*)
            ' ��室 � ������� ���� |' ;


 VAR  Aaa,Bbb,Ccc,Ddd,Eee,Ggg,
      Hhh,Fff,Yyy : WinType ;
      AA,BB,CC,DD,EE,GG,HH,FF,YY      : WinDef ;
      a,b,c,d                         : CARDINAL ;
      OT                              : CHAR ;
      i,j,k                           : CARDINAL ;
      t1,t2                           : CARDINAL ;
      kol                             : INTEGER ;
      fon,tex                         : Color ;
      w1                              : ARRAY[1..2],[1..4] OF CARDINAL ;
      (* �뢮� ��ப� ���� *)
      line                            : ARRAY[1..47] OF CHAR ;
      adr          : ADDRESS ;           (* ���� ��� ����᪠ ���㫥� *)
      kod          : CARDINAL ;          (* ��� ������ DOS *)
      kod1         : SHORTCARD ;         (* ��� �����襭�� �ணࠬ�� *)
      pri_mamory   : BOOLEAN ; (* �ਧ��� ���������� ����㧪� �ணࠬ�� *)
      m,m1,m2,m4   : CARDINAL ;          (* ��⨢�� �㭪� ���� *)
PROCEDURE GetReturnCode() : SHORTCARD ;
VAR   r            : SYSTEM.Registers ;
BEGIN ;
   r.AH:=4DH ;
   Lib.Dos(r) ;
   kod1:=r.AL ;
RETURN kod1 ;
END GetReturnCode ;

PROCEDURE WrWin (w:CARDINAL) ;
                (* ��楤�� ���������� ���� �롮� ०���� *)
BEGIN
   FOR k:=1 TO w1[2,w] DO
      Str.ItemS(line,mline,'|',k+w1[1,w]-1) ;
      GotoXY(3,k) ;
      WrStr(line) ;
   END ; (* FOR *)
END WrWin ;

PROCEDURE MLINE (VAR m : CARDINAL; x1,y1,x2,w:CARDINAL; fon,tex:Color) ;
                (* ��楤�� �롮� ०��� �� ���� *)
BEGIN
   i:=m ;
   j:=y1+m-1 ;
   LOOP
      EE.Y1:=j ;  EE.X1:=x1 ;
      EE.Y2:=j ;  EE.X2:=x2+x1 ;
      EE.Foreground:=fon ;
      EE.Background:=tex ;
      Eee:=Open(EE) ;
      GotoXY(2,1) ;
      Str.ItemS(line,mline,'|',i+w1[1,w]-1) ;
      WrStr(line) ;
      OT:=RdCharDirect() ;
      CASE OT OF (CHAR(72)) : DEC(i) ; DEC(j) ;
                              IF i<1 THEN i:=w1[2,w] ;
                                 j:=y1+i-1 ;
                                 END ;
              |  (CHAR(80)) : INC(i) ; INC(j) ;
                              IF i>w1[2,w] THEN i:=1 ;
                                 j:=y1 ;
                              END ;
              | (CHAR(0DH)) : Hide(Eee) ;
                              m:=i ;
                              RETURN ;
              | (CHAR(27))  : Close(Eee) ; EXIT ;
      END ;  (* CASE *)
      Close(Eee) ;
   END ;     (* LOOP *)
END MLINE ;

PROCEDURE FreeMamory ( SizeMamory: CARDINAL ): BOOLEAN ;

VAR SM      :  CARDINAL ; (* ࠧ��� ����㯭�� ����� *)
    t       :  CARDINAL ; (* ����⥫� ⥭� *)
BEGIN
   HH:=WinDef(18,6,62,15,White,Red,FALSE,FALSE,FALSE,TRUE,DoubleFrame,White,Red) ;
   SM:=Storage.HeapAvail(Storage.MainHeap) ;
   IF SM > SizeMamory THEN
         pri_mamory:=TRUE ;
      ELSE
         pri_mamory:=FALSE ;
(*  �뤠� ᮮ�饭�� �� �訡��, �᫨ �� 墠⠥� ����� *)
         Hhh:=Open(HH);
         GotoXY(16,1) ; WrStr("� � � � � � !") ;
         TextColor(Yellow) ;
         GotoXY(8,3) ;  WrStr("�� 墠⠥� ���� ��� ����㧪�") ;
         GotoXY(13,4) ; WrStr("���૥����� �����") ;
         TextColor(LightGray) ;
         TextBackground(LightRed) ;
         GotoXY(8,7) ;  WrStr("��� �த������� ࠡ��� ������") ;
         GotoXY(16,8) ; WrStr("���� �������") ;
         t:=Open_Sh(Hhh) ;
         OT:=RdCharDirect() ;
         Close_Sh(t) ;
         Close(Hhh) ;
   END ; (* IF *)
RETURN pri_mamory ;
END FreeMamory ;

PROCEDURE NR() ;      (* ��楤�� �� ॠ���������� ०���� *)
VAR  Fff  : WinType ;
     FF   : WinDef ;
BEGIN
                  (*****  ���� ��� ᮮ�饭��  *****)
FF:=WinDef(5,21,75,25,Cyan,Red,FALSE,TRUE,FALSE,TRUE,DoubleFrame,Cyan,Red) ;

   Fff:=Open(FF) ;
   GotoXY(5,1) ;
   WrStr('����� ०�� �।�����祭 ��� ���쭥�襣� ���७�� ��⥬�') ;
   GotoXY(13,2) ;
   WrStr('��� �த������� ࠡ��� ������ ���� �������.') ;
   OT:=RdCharDirect() ;
   Close(Fff) ;
END NR ;


BEGIN
      (************** ������� 梥� ��࠭� ******************)
FF:=WinDef(0,0,79,24,White,Black,FALSE,FALSE,FALSE,FALSE,CHR(0),Blue,LightGray) ;
Fff:=Open(FF);
   FOR i:=0 TO 24 DO
      IO.WrCharRep('�',80) ; GotoXY(1,i+1) ;
   END ; (* FOR *)

(* ������� ���न��� ��� ���� *)
w1[1,1]:=1 ; w1[1,2]:=6 ; w1[1,3]:=9 ; w1[1,4]:=13 ;
w1[2,1]:=5 ; w1[2,2]:=3 ; w1[2,3]:=4 ; w1[2,4]:=3 ;

        (******************** ������� ���� ***********************)
AA:=WinDef(6,6,58,12,LightCyan,Blue,FALSE,TRUE,FALSE,TRUE,DoubleFrame,Yellow,Blue) ;
      (**************   ���� ��� ��ࢮ�� ०���   ******************)
BB:=WinDef(22,8,74,12,Blue,Cyan,FALSE,TRUE,FALSE,TRUE,DoubleFrame,Yellow,Cyan) ;
      (**************   ���� ��� ��ࢮ�� ०���   ******************)
CC:=WinDef(22,11,74,16,Blue,Cyan,FALSE,TRUE,FALSE,TRUE,DoubleFrame,Yellow,Cyan) ;
      (**************   ���� ��� ०��� ��஢��  ******************)
DD:=WinDef(34,11,76,15,Blue,LightGray,FALSE,TRUE,FALSE,TRUE,DoubleFrame,Yellow,LightGray) ;
                  (*****      ��६���饥�� ����       *****)
EE:=WinDef(10,7,48,7,Brown,Cyan,FALSE,FALSE,FALSE,FALSE,' ',White,Blue) ;
                  (*****      ���� ���᪠���      *****)
YY:=WinDef(0,24,79,24,White,Brown,FALSE,FALSE,FALSE,FALSE,' ',White,Blue) ;


Yyy:=Open(YY) ;
GotoXY(9,1) ;
WrStr('[^V] ') ;
TextColor(Black) ;
WrStr('��६�饭�� �����') ;
GotoXY(38,1) ;
TextColor(White) ;
WrStr('[Enter] ') ;
TextColor(Black) ;
WrStr('�롮� ०���') ;
GotoXY(63,1) ;
TextColor(White) ;
WrStr('[Esc] ') ;
TextColor(Black) ;
WrStr('��室') ;

Aaa:=Open(AA) ;
a:=Open_Sh(Aaa) ;
Str.ItemS(line,mline,'|',0) ;
SetTitle(Aaa,line,CenterUpperTitle) ;
PutOnTop(Aaa) ;
WrWin(1) ;

                          (***** ������� ���� ****)
GG:=WinDef(24,12,39,12,Yellow,Blue,FALSE,TRUE,FALSE,FALSE,DoubleFrame,Yellow,Blue) ;
Ggg:=Open(GG) ;
IO.WrStr('  ������� ���� ') ;
m:=1 ;
m1:=1 ;
m2:=1 ;
m4:=1 ;
LOOP
   MLINE(m,8,7,48,1,Brown,Cyan) ;
   IF OT=CHAR(27) THEN
       i:=5 ;
   END (* IF *) ;
   CASE i OF 1 : Bbb:=Open(BB) ;
                 b:=Open_Sh(Bbb) ;
                 Str.ItemS(line,mline,'|',1) ;
                 SetTitle(Bbb,line,CenterUpperTitle) ;
                 PutOnTop(Bbb) ;
                 WrWin(2) ;

                 LOOP
                    MLINE(m1,24,9,48,2,Cyan,Blue) ;
                    IF OT=CHAR(27) THEN
                       i:=3 ;
                    END (* IF *) ;
                    CASE i OF 1 : (* ���� ��஢�� *)

Ddd:=Open(DD) ;
                 d:=Open_Sh(Ddd) ;
                 Str.ItemS(line,mline,'|',6) ;
                 SetTitle(Ddd,line,CenterUpperTitle) ;
                 PutOnTop(Ddd) ;
                 WrWin(4) ;

                 LOOP
                    MLINE(m4,36,12,38,4,Cyan,Blue) ;
                    IF OT=CHAR(27) THEN
                       i:=3 ;
                    END (* IF *) ;
                    CASE i OF 1 : (* �������� ��஢�� *)
                                  TxtImage.SaveScreen() ;
                                  pri_mamory:=FreeMamory(15000) ;
                                  IF pri_mamory=TRUE THEN
                                     Storage.HeapAllocate(Storage.MainHeap,adr,15000) ;
                                     kod:=Lib.Execute("lt.ovl"," ",adr,15000 ) ;
                                     Storage.HeapDeallocate(Storage.MainHeap,adr,15000) ;
                                  END ; (* IF *)
                                  TxtImage.RestoreScreen();
                           |  2 : (* ���������� ��஢�� *)
                                  TxtImage.SaveScreen() ;
                                  pri_mamory:=FreeMamory(15000) ;
                                  IF pri_mamory=TRUE THEN
                                     Storage.HeapAllocate(Storage.MainHeap,adr,15000) ;
                                     kod:=Lib.Execute("kt.ovl"," ",adr,15000 ) ;
                                     Storage.HeapDeallocate(Storage.MainHeap,adr,15000) ;
                                  END ; (* IF *)
                                  TxtImage.RestoreScreen();
                   (*        |  3 : (* ⠡��� ��஢�� *)
                                  NR() ;*)
                           |  3 : Close_Sh(d) ;
                                  Close(Ddd) ;
                                  Shadow(Bbb) ;
                                  EXIT ;
                    END ; (* CASE *)
                 END ;
                           |  2 : (* ����㧪� � ��࠭���� *)
                                  TxtImage.SaveScreen() ;
                                  pri_mamory:=FreeMamory(15000) ;
                                  IF pri_mamory=TRUE THEN
                                     Storage.HeapAllocate(Storage.MainHeap,adr,15000) ;
                                     kod:=Lib.Execute("cf.ovl"," ",adr,15000 ) ;
                                     Storage.HeapDeallocate(Storage.MainHeap,adr,15000) ;
                                  END ; (* IF *)
                                  TxtImage.RestoreScreen();
                           |  3 : Close_Sh(b) ;
                                  Close(Bbb) ;
                                  Shadow(Aaa) ;
                                  EXIT ;
                    END ; (* CASE *)
                 END ;
          |  2 : TxtImage.SaveScreen() ;
                 pri_mamory:=FreeMamory(15000) ;
                 IF pri_mamory=TRUE THEN
                       Storage.HeapAllocate(Storage.MainHeap,adr,15000) ;
                       kod:=Lib.Execute("gs.ovl"," ",adr,15000 ) ;
                       Storage.HeapDeallocate(Storage.MainHeap,adr,15000) ;
                 END ; (* IF *)
                 TxtImage.RestoreScreen();
          |  3 : TxtImage.SaveScreen() ;
                 pri_mamory:=FreeMamory(15000) ;
                 IF pri_mamory=TRUE THEN
                       Storage.HeapAllocate(Storage.MainHeap,adr,15000) ;
                       kod:=Lib.Execute("start.exe"," ",adr,15000 ) ;
                       Storage.HeapDeallocate(Storage.MainHeap,adr,15000) ;
                 END ; (* IF *)
                 TxtImage.RestoreScreen();
          |  4 : Ccc:=Open(CC) ;
                 c:=Open_Sh(Ccc) ;
                 PutOnTop(Ccc) ;
                 Str.ItemS(line,mline,'|',4) ;
                 SetTitle(Ccc,line,CenterUpperTitle) ;
                 WrWin(3) ;
                 LOOP
                    MLINE(m2,24,12,48,3,Cyan,Blue) ;
                    IF OT=CHAR(27) THEN
                       i:=4 ;
                    END (* IF *) ;
                    CASE i OF 1 : (* ������᪠� ��ࠡ�⪠ *)
                           TxtImage.SaveScreen() ;
                           pri_mamory:=FreeMamory(20000) ;
                           IF pri_mamory=TRUE THEN
                              Storage.HeapAllocate(Storage.MainHeap,adr,20000) ;
                              kod:=Lib.Execute("exstat.ovl"," ",adr,20000 ) ;
                              Storage.HeapDeallocate(Storage.MainHeap,adr,20000) ;
                           END ; (* IF *)
                           TxtImage.RestoreScreen();

                           |  2 : (* ��஢�� ��ࠡ�⪠ ᨣ���� *)
                           TxtImage.SaveScreen() ;
                           pri_mamory:=FreeMamory(20000) ;
                           IF pri_mamory=TRUE THEN
                              Storage.HeapAllocate(Storage.MainHeap,adr,20000) ;
                              kod:=Lib.Execute("exdigit.ovl"," ",adr,20000 ) ;
                              Storage.HeapDeallocate(Storage.MainHeap,adr,20000) ;
                           END ; (* IF *)
                           (* OT:=RdCharDirect() ; *)
                           TxtImage.RestoreScreen();
                           |  3 : (* ��⥬���᪠� ��ࠡ�⪠ *)
                           TxtImage.SaveScreen() ;
                           pri_mamory:=FreeMamory(20000) ;
                           IF pri_mamory=TRUE THEN
                              Storage.HeapAllocate(Storage.MainHeap,adr,20000) ;
                              kod:=Lib.Execute("exmath.ovl"," ",adr,20000 ) ;
                              Storage.HeapDeallocate(Storage.MainHeap,adr,20000) ;
                           END ; (* IF *)
                           TxtImage.RestoreScreen();
                           |  4 : Close_Sh(c) ;
                                  Close(Ccc) ;
                                  Shadow(Aaa) ;
                                  EXIT ;
                    END ; (* CASE *)
                 END ;
          |  5 : EXIT ;
   END ; (* CASE *)
END ; (* LOOP *)
Close_Sh(a) ;
Close(Ggg) ;
Close(Aaa) ;
Close(Yyy) ;
Close(Fff) ;
END mainproc.
