MODULE spacefre ;

   IMPORT Storage ;
   IMPORT FIO,IO ;
   IMPORT SYSTEM ;
   IMPORT Lib ;

VAR     r        : SYSTEM.Registers ;
        size     : CARDINAL ;
        size1    : LONGCARD ;
        ot       : CHAR ;
BEGIN

(*   r.AH:=48H ;
   r.BX:=0FFFFH ;

   FIO.WrStr(1,'���� ') ;
   FIO.WrCard(1,r.BX,6) ;
   FIO.WrStr(1,' ���� ����⨢��� �����') ;

   Lib.Dos(r) ;

   FIO.WrStr(1,' ������� AX ࠢ�� ') ;
   FIO.WrCard(1,r.AX,6) ;
*)
   size:=Storage.HeapAvail(Storage.MainHeap) ;
   size1:=LONGCARD(size)*16 ;
   FIO.WrStr(1,' ����㯭� ') ;
   FIO.WrLngCard(1,size1,6) ;
   FIO.WrStr(1,' ���� ����⨢��� �����') ;
   ot:=IO.RdCharDirect() ;
END spacefre.
