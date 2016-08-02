MODULE color;
VAR  ColorScreen[0B800H:0] : ARRAY[1..25] OF
                                ARRAY[1..80] OF
                                   RECORD
                                   Chr : CHAR;
                                   Atr : SHORTCARD;
                                   END;
     ch                  : CHAR;
     i,j,p               : CARDINAL;
BEGIN
   p:=0;
   FOR j:=1 TO 4 DO
      FOR i:=1 TO 40 DO
      ColorScreen[j,i*2].Atr:=SHORTCARD(p);
      ColorScreen[j,i*2].Chr:='°';
      INC(p);
      IF p>128 THEN p:=127;END;
      END;
   END;
   p:=0;
   FOR j:=5 TO 9 DO
      FOR i:=1 TO 40 DO
      ColorScreen[j,i*2].Atr:=SHORTCARD(p);
      ColorScreen[j,i*2].Chr:='A';
      INC(p);
      IF p>128 THEN p:=127;END;
      END;
   END;
   p:=0;
   FOR j:=10 TO 13 DO
      FOR i:=1 TO 40 DO
      ColorScreen[j,i*2].Atr:=SHORTCARD(p);
      ColorScreen[j,i*2].Chr:='Í';
      INC(p);
      IF p>128 THEN p:=127;END;
      END;
   END;

END color.