IMPLEMENTATION MODULE rs;
IMPORT SYSTEM, Lib, IO;

CONST Com1        = 3F8H;
      Com1INr     = 4;
      Com2        = 2F8H;
      Com2INr     = 3;

      IntEnable   = 1;
      DivisorMsb  = 1;
      IntId       = 2;
      LineCont    = 3;
      ModemCont   = 4;
      LineStatus  = 5;
      ModemStatus = 6;
TYPE b = SET OF SHORTCARD[0..7];
VAR IOBase,ComINr : CARDINAL;

CONST
      TXBuffer    ::= IOBase;
      RXBuffer    ::= IOBase;
      DivisorLsb  ::= IOBase;


      BufferSize  = 256;
      TRMax       = BufferSize-16;
      Noise       = FALSE;

VAR WorkSpace             : ARRAY[0..7FFH] OF CHAR;
    MainProc              : ADDRESS;
    IP                    : ADDRESS;
    OldC                  : PROC;
    Term                  : PROC;
(*$W+*)
    TXReady,CTS,CTSH     : BOOLEAN;
    RTS                  : BOOLEAN;
    TXCount,TXI,TXO      : CARDINAL;
    RXCount,RXI,RXO      : CARDINAL;
(*$W-*)
    IBuf,OBuf            : ARRAY[0..BufferSize-1] OF SHORTCARD;

PROCEDURE TX;
BEGIN
  IF CTS OR NOT CTSH THEN
     TXReady := FALSE;
     SYSTEM.Out( TXBuffer,OBuf[TXO] );
     TXO := (TXO+1) MOD BufferSize;
     DEC(TXCount);
  END;
END TX;

PROCEDURE RX;
BEGIN
  IF RXCount >= TRMax THEN
     SYSTEM.Out( IOBase+ModemCont, SHORTCARD( b{0,3} ) );
     RTS := FALSE;
  END;
  IBuf[RXI] := SYSTEM.In( RXBuffer );
  IF Noise AND (Lib.RANDOM(500)=0) THEN
     IBuf[RXI] := SHORTCARD(Lib.RANDOM(256));
  END;
  RXI := (RXI+1) MOD BufferSize;
  INC(RXCount);
END RX;

VAR GotBreak : BOOLEAN;

(*$C FF,J+*)
PROCEDURE Int;
VAR i  : SHORTCARD;
    s  : b;
BEGIN
  LOOP
    i := SYSTEM.In( IOBase+IntId );
    IF i=1 THEN EXIT; END;
    CASE i DIV 2 OF
    |  0 : (* Modem status *)
           s := b(SYSTEM.In( IOBase+ModemStatus ));
           CTS :=4 IN s;
           IF CTS AND (TXCount >0) AND TXReady THEN TX END;

    |  1 : (* TXEmpty      *)
           TXReady := TRUE;
           IF TXCount > 0 THEN TX; END;

    |  2 : (* RXReady      *)

           RX;

    |  3 : (* LineStatus   *)

           s := b(SYSTEM.In( IOBase+LineStatus ));
           (*
           IF 1 IN s THEN IO.WrStr('OR-Error'); END;
           IF 2 IN s THEN IO.WrStr('PE-Error'); END;
           IF 4 IN s THEN IO.WrStr('Break');
           ELSIF 3 IN s THEN IO.WrStr('FE-Error'); END;

           SYSTEM.Out(20H,20H);
           HALT;*)
      ELSE (*IO.WrStr('Unknown Int'); HALT; *)
    END;
  END;
  SYSTEM.Out(20H,20H);
END Int;

(*$C F0,J-*)

PROCEDURE RxCount():CARDINAL;
BEGIN
  RETURN RXCount;
END RxCount;

PROCEDURE TxCount():CARDINAL;
BEGIN
  RETURN TXCount;
END TxCount;

PROCEDURE TxFree ():CARDINAL;
BEGIN
  RETURN TRMax-TXCount;
END TxFree;

VAR lc : SHORTCARD;

PROCEDURE Break( Time : CARDINAL );
BEGIN
  SYSTEM.Out( IOBase+LineCont,SHORTCARD( b(SYSTEM.In(IOBase+LineCont))+b{6})) ;
  Lib.Delay( Time );
  SYSTEM.Out( IOBase+LineCont,SHORTCARD( b(SYSTEM.In(IOBase+LineCont))-b{6}));
END Break;

PROCEDURE Init( Baud       : CARDINAL;
                WordLength : wl;
                Parity     : pt;
                OneStopBit : BOOLEAN;
                HandShake  : BOOLEAN);

VAR d  : CARDINAL; i : SHORTCARD;
BEGIN
  SYSTEM.DI;
  TXI     := 0;
  TXO     := 0;
  RXI     := 0;
  RXO     := 0;
  RXCount := 0;
  TXCount := 0;
  SYSTEM.EI;
  CTSH := HandShake;
  lc := (WordLength-5) MOD 4;
  IF NOT OneStopBit THEN lc := lc+4; END;
  CASE Parity OF
  | None  :;
  | Even  : lc := lc+18H;
  | Odd   : lc := lc+ 8H;
  | Mark  : lc := lc+38H;
  | Space : lc := lc+28H;
  END;
  SYSTEM.Out( IOBase+LineCont,80H );
  d := CARDINAL( 115200 DIV LONGCARD( Baud ) );
  SYSTEM.Out( DivisorLsb, SHORTCARD(d));
  SYSTEM.Out( IOBase+DivisorMsb, SHORTCARD(d DIV 100H));
  SYSTEM.Out( IOBase+LineCont,lc );
  TXReady := TRUE;
  SYSTEM.Out( IOBase+ModemCont,SHORTCARD(b{0,1,3}));
  CTS     := 4 IN b(SYSTEM.In( IOBase+ModemStatus ));
  LOOP
    i := SYSTEM.In( IOBase+IntId );
    IF i=1 THEN EXIT; END;
    CASE i DIV 2 OF
    |  0 : (* Modem status *)
           i := SYSTEM.In( IOBase+ModemStatus );
    |  1 : (* TXEmpty      *)
    |  2 : (* RXReady      *)
    |  3 : (* LineStatus   *)
           i := SYSTEM.In( IOBase+LineStatus );
    END;
  END;
END Init;


(*$V-*)

PROCEDURE Receive(VAR Buf : ARRAY OF BYTE; Len : CARDINAL );
VAR i : CARDINAL;
BEGIN
  FOR i := 0 TO Len-1 DO
      WHILE RXCount = 0 DO END;
      Buf[i] := IBuf[RXO];
      DEC( RXCount );
      RXO := (RXO+1) MOD BufferSize;
  END;
  IF NOT RTS AND (RXCount < TRMax-16) THEN
     SYSTEM.Out( IOBase+ModemCont, SHORTCARD( b{0,1,3} ) );
     RTS := TRUE;
  END;
END Receive;


PROCEDURE Send( Buf : ARRAY OF BYTE; Len : CARDINAL );
VAR i : CARDINAL;
BEGIN
  FOR i := 0 TO Len-1 DO
      OBuf[TXI] := Buf[i];
      INC(TXCount);
      TXI := (TXI+1) MOD BufferSize;
      IF TXReady THEN TX; END;
  END;
END Send;

TYPE dp=POINTER TO PROC;

PROCEDURE CloseDown;
BEGIN
  [0:4*(8+ComINr) dp]^ := OldC;
  SYSTEM.Out( IOBase+IntEnable,00H );
  SYSTEM.Out( IOBase+ModemCont,SHORTCARD(b{}));
  Term;
END CloseDown;

PROCEDURE Install( Port : CARDINAL );
BEGIN
  IF Port= 1 THEN
     Install2( Com1,Com1INr );
  ELSE
     Install2( Com2,Com2INr );
  END;
END Install;

PROCEDURE Install2( Port,Intr : CARDINAL);
TYPE bs = SET OF SHORTCARD[0..7];
VAR  s  : SHORTCARD; i : CARDINAL;
BEGIN
  IOBase := Port;
  ComINr := Intr;
  SYSTEM.Out( IOBase+IntEnable,00H );
  SYSTEM.Out( IOBase+LineStatus,0 );
  TXI     := 0;
  TXO     := 0;
  RXI     := 0;
  RXO     := 0;
  RXCount := 0;
  TXCount := 0;
  OldC    := [0:4*(8+ComINr) dp]^;
  [0:4*(8+ComINr) dp]^    := PROC(ADR(Int));
  Lib.Terminate( CloseDown,Term );
  SYSTEM.NewPriority( CARDINAL(BITSET( SYSTEM.CurrentPriority() )-{ComINr} ) );
  TXReady := TRUE;
  RTS     := TRUE;
  SYSTEM.Out( IOBase+IntEnable,0BH );
  SYSTEM.Out( IOBase+ModemCont,SHORTCARD(b{0,1,3}));
END Install2;


PROCEDURE BreakTest():BOOLEAN;
BEGIN
  RETURN 4 IN b(SYSTEM.In( IOBase+LineStatus ));
END BreakTest;

BEGIN
  lc := SYSTEM.In( IOBase+LineCont );
END rs.
