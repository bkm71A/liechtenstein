IMPLEMENTATION MODULE BAR;
IMPORT IO,SYSTEM;
(*VAR aa[0A800H:0]       : CARDINAL;*)
VAR i                  : CARDINAL;
    OldInt             : ADDRESS;
    MyInt[0:1CH]       : ADDRESS;
PROCEDURE Init(VAR aa: CARDINAL);
(*$W+,$J+,$C FF*)
PROCEDURE line();
  BEGIN
(*  SYSTEM.DI();*)
  IF aa>i  THEN INC(i);IO.WrChar('v'); END;
  IF aa>63 THEN MyInt:=OldInt;END;
(*  SYSTEM.EI();*)
  END line;
(*$W-,$J-$C F0*)
  BEGIN
  aa:=0;
  i:=0;
  OldInt:=MyInt;
  MyInt:=ADR(line);
  END Init;

PROCEDURE DeInit();
  BEGIN
  END DeInit;
BEGIN
END BAR.