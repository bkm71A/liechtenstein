IMPLEMENTATION MODULE Errors; (* Copyright 1991, M.V.N. *)

FROM Window    IMPORT WinType,WinDef,Open,Close,Color,TextColor,GotoXY,Use;
FROM IO        IMPORT RdCharDirect,WrStr;
FROM Str       IMPORT ItemS,Length;
FROM SYSTEM    IMPORT EI,DI,Registers,Seg,Ofs;
FROM Lib       IMPORT Dos;

FROM WindowSk  IMPORT Open_Ten,Close_Ten;


PROCEDURE RedirectCheckEr();
VAR
  r:  Registers;
BEGIN
 DI();
(* -- �����a�� ���� �� ���஬� ��室���� �⠭����� ��ࠡ��稪 �訡�� -- *)
  r.AH:= 35H;
  r.AL:= 24H;
 Dos(r);
  adr_int24H := [r.ES:r.BX];  (* ------------ ES - Seg; BX - Ofs ---------- *)

(* -- �����뢠�� �� �⮬� ����� ᢮� �ணࠬ�� ---- *)
  r.AH:= 25H;
  r.AL:= 24H;
  r.DS:= Seg(CheckExtDosEr);
  r.DX:= Ofs(CheckExtDosEr);
 Dos(r);
 EI();
END RedirectCheckEr;

PROCEDURE RestoreCheckEr();
VAR
  r:  Registers;
BEGIN
 DI();
 WITH r DO
  AH:= 25H;
  AL:= 24H;
  DS:= Seg(adr_int24H);
  DX:= Ofs(adr_int24H);
 END; (* with *)
 Dos(r);
 EI();
END RestoreCheckEr;

(*$J+,C FF *)
PROCEDURE CheckExtDosEr();
VAR
  r:         Registers;
  str:       ARRAY [0..45] OF CHAR;
  shad:      CARDINAL;
  answ:      CHAR;
BEGIN
(* -------- ����頥� ��⥬�� ���뢠��� �� ������ �믮������ ------------- *)
 DI();


(*  ��뢠�� 59� �㭪�� 21� ���뢠��� - ���७��� ���ଠ�� �� �訡 ���  *)
  r.AH:= 59H;
  r.BX:= 0H;
 Dos(r);
 EI();
(* ---------- ��������㥬 �����饭�� ॣ����� ----------------------------- *)
 IF CARDINAL(r.AX) <> 0
   THEN
       wt_error:= Open(wd_error);
       shad:= Open_Ten(wt_error);
       Use(wt_error);
        ItemS(str,error_message,'|',CARDINAL(r.AX)-1);
          GotoXY((25-Length(str)) DIV 2,3); WrStr(str);
        ItemS(str,recomend_message,'|',CARDINAL(r.BH)-1);
        TextColor(LightCyan);
         GotoXY((25-Length(str)) DIV 2,5); WrStr(str);
        TextColor(Yellow);
         GotoXY(19,1); WrStr('� � � � � � !');
 END; (* if *)
 answ:= RdCharDirect();
 Close(wt_error);
 Close_Ten(shad);
 END CheckExtDosEr;
(*J-,C F0 *)

END Errors.