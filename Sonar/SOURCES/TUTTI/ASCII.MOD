MODULE ascii;
IMPORT FIO;
VAR p                  : SHORTCARD;
    i                  : CARDINAL;
    f                  : FIO.File;
    buf                : ARRAY[1..2048] OF BYTE;
BEGIN
(* 1  ������ 䠩� *)
  f:=FIO.Create('ASCII.TXT');
  FIO.AssignBuffer(f,buf);
    FOR i:=0 TO 255 DO
    p:=SHORTCARD(i);
    IF (i MOD 16)=0 THEN FIO.WrLn(f);END;
    FIO.WrBin(f,p,1);
    END;
(* 3 �����⨥ 䠩�a *)
  FIO.Close(f);
END ascii.