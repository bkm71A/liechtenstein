MODULE Exsubd;

              IMPORT IO,FIO,Str;
FROM Window   IMPORT Open,Close,GotoXY,Use,Color,TextColor,Change,Clear;

FROM MakeMenu IMPORT wt_menu,wt_invr;
FROM Subd     IMPORT wt_main,wt_hormenu,wt_inverhormenu,wt_blank,
                     wt_field,wt_current,
                     wd_main,wd_hormenu,wd_inverhormenu,
                     AppendBase,ViewAllBase;

VAR
  j:         CARDINAL;
  i:         CARDINAL;
  a:         CARDINAL;
  x1,x2:     CARDINAL;
  answ:      CHAR;
  substring: ARRAY [0..15] OF CHAR;

CONST contains= 'Просмотр+Пополнение+Коррекция+Выход';
LABEL lab1,lab11;

BEGIN
 wt_main:= Open(wd_main);
 FOR j:= 1 TO 23 DO
  GotoXY(1,j);  IO.WrCharRep('░',78);
 END; (* for *)
 wt_hormenu:= Open(wd_hormenu);
 wt_inverhormenu:= Open(wd_inverhormenu);

lab1:   Use(wt_hormenu); Clear(); TextColor(White);
        GotoXY(4,1);     IO.WrStr('Просмотр');
        GotoXY(16,1);    IO.WrStr('Пополнение');
        GotoXY(30,1);    IO.WrStr('Коррекция');
        GotoXY(64,1);    IO.WrStr('Выход');
        Change(wt_inverhormenu,5,3,14,3);
        substring:= 'Просмотр';
        Use(wt_inverhormenu);
        GotoXY(2,1); IO.WrStr(substring);
        a:= 1;
LOOP
  answ:= IO.RdCharDirect();
   CASE answ OF
       CHAR(0):  answ:= IO.RdCharDirect();
                 CASE answ OF
                   CHAR(77): INC(a)
                  |CHAR(75): DEC(a)
                 END; (* case *)
      |CHAR(27): EXIT
      |CHAR(13): Change(wt_inverhormenu,4,3,73,3); Clear();
                 GotoXY(2,1); IO.WrStr(substring);
              CASE a OF
                 |1: (* --- просмотр всей базы по разным параметрам --- *)
                     a:= 1;
                     ViewAllBase('d:\jpi\base\base.dat');
                     GOTO lab11;
                 |2: (* --- пополнение базы --- *)
                     a:= 2;
                     AppendBase('d:\jpi\base\base.dat');
                     GOTO lab11;
                 |3: (* --- процедура коррекции --- *)
                     a:= 3;
                     GOTO lab11;
                 |4: EXIT
              END; (* case *)
   END; (* case *)
lab11:    IF a< 1 THEN a:= 4 END;
          IF a> 4 THEN a:= 1 END;
          CASE a OF
             1:  x1:=  5; x2:= 14;
            |2:  x1:= 17; x2:= 28;
            |3:  x1:= 31; x2:= 41;
            |4:  x1:= 65; x2:= 71;
          END; (* case *)
          Change(wt_inverhormenu,x1,3,x2,3);
          Use(wt_inverhormenu); Clear(); TextColor(White);
          Str.ItemS(substring,contains,'+',a-1);
          GotoXY(2,1); IO.WrStr(substring);
END; (* loop *)

Close(wt_main);
Close(wt_hormenu);
Close(wt_inverhormenu);
Close(wt_blank);
Close(wt_field);
Close(wt_current);
Close(wt_menu);
Close(wt_invr);

END Exsubd.