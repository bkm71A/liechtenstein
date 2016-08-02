MODULE kod;
IMPORT IO;
VAR c  : CHAR;
    i  : CARDINAL;
BEGIN
   FOR i:=1 TO 20 DO
   c:=IO.RdCharDirect();
   IO.WrCard(ORD(c),5);
   IO.WrLn;
   END;
END kod.
