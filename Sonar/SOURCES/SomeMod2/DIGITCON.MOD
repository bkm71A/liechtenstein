(* ------------------------ полностью готово -------------------------------- *)

IMPLEMENTATION MODULE DigitCon; (* ----------- цифровая обработка ----------- *)

IMPORT IO,Str,SYSTEM,Lib;
FROM   Window   IMPORT Open,PutOnTop,SetTitle,CenterUpperTitle,CenterLowerTitle,
                       Change,Use,Clear,GotoXY,Hide,TextColor;
FROM   Down_hlp IMPORT DownHelp0,DownHelp121,DownHelp122,DownHelp220_30,
                       DownHelp124,DownHelp125,DownHelpAny;
FROM   Probr_lb IMPORT Soundock,WaitingOn,WaitingOff,Space_free,contdisk_contr,
                       wt_inverhormenu,wt_range,wt_invrange;
FROM   SYSTEM   IMPORT Registers;
FROM   SearchFl IMPORT FileInformArray;
FROM   _Window  IMPORT Open_Shadow,Close_Shadow;
FROM   DFiltr   IMPORT filtration;
FROM   Tuki     IMPORT window;
FROM   DFazAmp  IMPORT afaza;
FROM   DSPlot   IMPORT s_pect;
FROM   DAuto    IMPORT correl;
FROM   Iron     IMPORT iron;
FROM   DEnsembl IMPORT katok;
FROM   Sglaj    IMPORT heing;
FROM   Current  IMPORT LineMov,InitScr,DeInitScr;
FROM   fufa     IMPORT fuflo;
VAR
   r           :Registers;

PROCEDURE Output1();
BEGIN
  DownHelpAny();
  Change(wt_out,15,9,65,11);
  shadow_o:= Open_Shadow(wt_out);
  PutOnTop(wt_out);  Clear();
TextColor(White);
  GotoXY(3,1); IO.WrStrAdj('Имя выходного файла' ,-32);
TextColor(LightMagenta);
  IO.WrStr(out_name);
END Output1;

PROCEDURE Control();
VAR
  answ: CHAR;
BEGIN
 IF space<> 0
    THEN  Space_free(space)
    ELSE  Output1();
          answ:= IO.RdCharDirect();
          Hide(wt_out);
          Close_Shadow(shadow_o)
 END;
END Control;

(* --------------- фильтрация в полосе частот ---------------------- *)
PROCEDURE Meth_1();
VAR
 dlinna:         CARDINAL;
 answ:           CHAR;
 OK:             BOOLEAN;
 attant_control: CARDINAL;
 math_control:   CARDINAL;
 wait_control:   CARDINAL;
 dig1,dig2:      REAL;
 string:         ARRAY [1..10] OF CHAR;
LABEL lab0,lab_end;
BEGIN

    Use(wt_inverhormenu); Clear();
    IO.WrStr(' Фильтрация в полосе частот');
    dlinna:= Str.Length(FileInformArray[contdisk_contr].Name);
    LOOP
     CASE  FileInformArray[contdisk_contr].Name[dlinna-2]
        OF 'a','A','l','L','e','E': EXIT
       ELSE space:= -3;
            Control();
            GOTO lab_end
     END; (* case *)
    END; (* loop *)
    Change(wt_mathmet,20,7,61,11);
    math_control:= Open_Shadow(wt_mathmet);
    PutOnTop(wt_mathmet); Clear(); TextColor(White);
    GotoXY(2,1); IO.WrStr('Нижняя  граница'); GotoXY(38,1); IO.WrStr('Гц');
    GotoXY(2,3); IO.WrStr('Верхняя граница'); GotoXY(38,3); IO.WrStr('Гц');
lab0:
 DownHelp121();
(* ------------------------ ввод нижней границы ---------------------------- *)
  Change(wt_invmat,38,8,56,8);
  PutOnTop(wt_invmat); Clear();
LOOP
  dig1:= IO.RdReal();
  IF IO.OK THEN Use(wt_mathmet);
                TextColor(LightMagenta);
                GotoXY(19,1); IO.WrReal(dig1,8,-15);
                EXIT
  END ;
  Soundock();
END ; (* loop *)

(* ---------------- ввод и проверка верхней границы ----------------------- *)
 Change(wt_invmat,38,10,56,10);
 PutOnTop(wt_invmat); Clear();
LOOP
  dig2 :=IO.RdReal() ;
  IF (IO.OK) AND (dig1< dig2) THEN
                Use(wt_mathmet);
                GotoXY(19,3); IO.WrReal(dig2,8,-15);
                Hide(wt_invmat);
                EXIT
  END ;
  Soundock();
END ; (* loop *)

(* -------------------- проверка перед запуском на счет -------------------- *)
DownHelp122();
LOOP
 answ:= IO.RdCharDirect();
  CASE answ OF
     CHAR(13): Hide(wt_mathmet);
               Close_Shadow(math_control);
               wait_control:= WaitingOn();
               space:= filtration(dig1,dig2,FileInformArray[contdisk_contr].Name,
                                out_name);
               WaitingOff(wait_control);
               Control();
               EXIT
    |CHAR(27): Hide(wt_mathmet);
               Close_Shadow(math_control);
               GOTO lab_end
    |CHAR(32): GOTO lab0
  END; (* case *)
END; (* loop *)
lab_end:
END Meth_1;

PROCEDURE Meth_2();
VAR
  dlinna:   CARDINAL;
  answ:     CHAR;
  ret:      LONGINT;
  wait:     CARDINAL;
LABEL       lab_end;
BEGIN
 Use(wt_inverhormenu); Clear();
 IO.WrStr(' Сглаживание окном Тьюки');
 dlinna:= Str.Length(FileInformArray[contdisk_contr].Name);
 LOOP
  CASE  FileInformArray[contdisk_contr].Name[dlinna-2]
     OF 'a','A','l','L','e','E': EXIT
    ELSE space:= -3;
         Control();
         GOTO lab_end
  END; (* case *)
 END; (* loop *)
 wait:= WaitingOn();
 window(FileInformArray[contdisk_contr].Name);
 WaitingOff(wait);
 Str.Copy(out_name,FileInformArray[contdisk_contr].Name);
 Output1();
 answ:= IO.RdCharDirect();
 Hide(wt_out);
 Close_Shadow(shadow_o);
lab_end:
END Meth_2;

PROCEDURE Meth_3();
VAR
  dlinna:   CARDINAL;
  answ:     CHAR;
  wait:     CARDINAL;
  fazf:     ARRAY [0..12] OF CHAR;
  ampf:     ARRAY [0..12] OF CHAR;
LABEL       lab_end;
PROCEDURE Output();
BEGIN
  DownHelpAny();
  Change(wt_out,15,9,65,12);
  shadow_o:= Open_Shadow(wt_out);
  PutOnTop(wt_out);  Clear();
TextColor(White);
  GotoXY(3,1); IO.WrStrAdj('Имя выходного файла амплитуды',-32);
TextColor(LightMagenta);
  IO.WrStr(ampf);
TextColor(White);
  GotoXY(3,2); IO.WrStrAdj('Имя выходного файла фазы',-32);
TextColor(LightMagenta);
  IO.WrStr(fazf);
END Output;
BEGIN
 Use(wt_inverhormenu); Clear();
 IO.WrStr(' Вычисление спектра');
 dlinna:= Str.Length(FileInformArray[contdisk_contr].Name);
 LOOP
  CASE  FileInformArray[contdisk_contr].Name[dlinna-2]
     OF 'a','A','l','L','e','E': EXIT
    ELSE space:= -3;
         Control();
         GOTO lab_end
  END; (* case *)
 END; (* loop *)
 wait:= WaitingOn();
space:= afaza(FileInformArray[contdisk_contr].Name,ampf,fazf);
 WaitingOff(wait);
 IF space<> 0
    THEN  Space_free(space)
    ELSE  Output();
          answ:= IO.RdCharDirect();
          Hide(wt_out);
          Close_Shadow(shadow_o)
 END;
lab_end:
END Meth_3;

PROCEDURE Inputbeta(): SHORTCARD;
VAR
    ii:              INTEGER;
    answ:            CHAR;
    shadow:          CARDINAL;
BEGIN
    Change(wt_range,45,5,57,20);
    shadow:= Open_Shadow(wt_range);
    PutOnTop(wt_range);
    Clear();
  FOR ii:= 0 TO 13 DO
    GotoXY(1,ii+1); IO.WrReal(beta[ii],5,5);
  END; (* for *)
 Change(wt_invrange,46,6,56,6);
 PutOnTop(wt_invrange);
 Use(wt_invrange); Clear();
 IO.WrReal(beta[0],5,5);
 ii:= 0;
 LOOP
  answ:= IO.RdCharDirect();
  CASE answ OF
       CHAR(13): EXIT;
      |CHAR(0) : answ:= IO.RdCharDirect();
                    CASE answ OF
                         CHAR(72): DEC(ii)
                        |CHAR(80): INC(ii)
                    END; (* case *)
  END; (* case *)
     IF ii< 0  THEN ii:= 13 END;
     IF ii> 13 THEN ii:= 0  END;
     Change(wt_invrange,46,ii+6,56,ii+6);
     Use(wt_invrange); Clear();
     IO.WrReal(beta[ii],5,5);
 END; (* loop *)
    Hide(wt_range);
    Hide(wt_invrange);
    Close_Shadow(shadow);
    RETURN SHORTCARD(ii);
END Inputbeta;

PROCEDURE Meth_4();
VAR
  dlinna:   CARDINAL;
  answ:     CHAR;
  shadow_w: CARDINAL;
  betka:    SHORTCARD;
  shir:     REAL;
  dov1:     REAL;
  dov2:     REAL;
LABEL       lab_end;
PROCEDURE Output();
BEGIN
  DownHelpAny();
  Change(wt_out,15,8,65,14);
  shadow_o:= Open_Shadow(wt_out);
  PutOnTop(wt_out);  Clear();
TextColor(White);
  GotoXY(4,1); IO.WrStrAdj('Имя выходного файла',-32);
TextColor(LightMagenta);
  IO.WrStr(out_name);
TextColor(White);
  GotoXY(4,3); IO.WrStrAdj('Ширина спектра',-31);
TextColor(LightMagenta);
  IO.WrReal(shir,5,8);
TextColor(White);
  GotoXY(4,4); IO.WrStrAdj('Нижний доверительный инт-л',-31);
TextColor(LightMagenta);
  IO.WrReal(dov1,5,8);
TextColor(White);
  GotoXY(4,5); IO.WrStrAdj('Верхний доверительный инт-л',-31);
TextColor(LightMagenta);
  IO.WrReal(dov2,5,8);
END Output;
BEGIN
 Use(wt_inverhormenu); Clear();
 IO.WrStr(' Вычисление спектральной плотности');
 dlinna:= Str.Length(FileInformArray[contdisk_contr].Name);
 LOOP
  CASE  FileInformArray[contdisk_contr].Name[dlinna-2]
     OF 'a','A','l','L','e','E': EXIT
    ELSE space:= -3;
         Control();
         GOTO lab_end
  END; (* case *)
 END; (* loop *)
 DownHelp124();
 betka:= Inputbeta();
 shadow_w:= WaitingOn();
space:= s_pect(betka,shir,dov1,dov2,FileInformArray[contdisk_contr].Name,out_name);
 WaitingOff(shadow_w);
 IF space<> 0
   THEN Space_free(space);
   ELSE Output();
        answ:= IO.RdCharDirect();
        Hide(wt_out);
        Close_Shadow(shadow_o)
 END;
lab_end:
END Meth_4;

PROCEDURE Meth_5();
VAR
 dlinna:   CARDINAL;
 answ:     CHAR;
 wait:     CARDINAL;
LABEL      lab_end;
BEGIN
 Use(wt_inverhormenu); Clear();
 IO.WrStr(' Вычисление автокорреляционной функции');
 dlinna:= Str.Length(FileInformArray[contdisk_contr].Name);
 LOOP
  CASE  FileInformArray[contdisk_contr].Name[dlinna-2]
     OF 'a','A','l','L','e','E': EXIT
    ELSE space:= -3;
         Control();
         GOTO lab_end
  END; (* case *)
 END; (* loop *)
 wait:= WaitingOn();
 space:= correl(FileInformArray[contdisk_contr].Name,out_name);
 WaitingOff(wait);
 Control();
lab_end:
END Meth_5;

PROCEDURE Meth_6();
VAR
 dlinna:   CARDINAL;
 answ:     CHAR;
 wait:     CARDINAL;
BEGIN
 Use(wt_inverhormenu); Clear();
 IO.WrStr(' Сглаживание спектральной плотности по частотам');
dlinna:= Str.Length(FileInformArray[contdisk_contr].Name);
IF   ( (FileInformArray[contdisk_contr].Name[dlinna-1] = 'l') OR
       (FileInformArray[contdisk_contr].Name[dlinna-1] = 'L')  )
 AND
     ( (FileInformArray[contdisk_contr].Name[dlinna-2] = 'p') OR
       (FileInformArray[contdisk_contr].Name[dlinna-2] = 'P')  )
 AND
     ( (FileInformArray[contdisk_contr].Name[dlinna-3] = 's') OR
       (FileInformArray[contdisk_contr].Name[dlinna-3] = 'S')  )
 THEN
 wait:= WaitingOn();
 space:= iron(1,FileInformArray[contdisk_contr].Name,out_name);
 WaitingOff(wait);
 Control();
ELSE space:= -1;
     Control();
END; (* if *)
END Meth_6;

PROCEDURE Meth_7();
VAR
  dlinna:   CARDINAL;
  answ:     CHAR;
  shadow_m: CARDINAL;
  shadow_w: CARDINAL;
  dig1:     SHORTCARD;
  dig2:     CARDINAL;
LABEL   lab0,lab_end;
BEGIN
 Use(wt_inverhormenu); Clear();
 IO.WrStr(' Сглаживание спектральной плотности по ансамблю частот');
dlinna:= Str.Length(FileInformArray[contdisk_contr].Name);
IF   ( (FileInformArray[contdisk_contr].Name[dlinna-1] = 'l') OR
       (FileInformArray[contdisk_contr].Name[dlinna-1] = 'L')  )
 AND
     ( (FileInformArray[contdisk_contr].Name[dlinna-2] = 'p') OR
       (FileInformArray[contdisk_contr].Name[dlinna-2] = 'P')  )
 AND
     ( (FileInformArray[contdisk_contr].Name[dlinna-3] = 's') OR
       (FileInformArray[contdisk_contr].Name[dlinna-3] = 'S')  )
 THEN
  Change(wt_mathmet,20,7,61,11);
  shadow_m:= Open_Shadow(wt_mathmet);
  PutOnTop(wt_mathmet); Clear(); TextColor(White);
  GotoXY(2,1); IO.WrStrAdj('Количество отрезков реализации',-33);
  GotoXY(2,3); IO.WrStrAdj('Сдвиг точек',-33);
 lab0:
  DownHelp121();
  Change(wt_invmat,55,8,60,8);
  PutOnTop(wt_invmat); Clear();
 LOOP
   dig1:= IO.RdShtCard();
   IF IO.OK THEN Use(wt_mathmet);
                 TextColor(LightMagenta);
                 GotoXY(35,1); IO.WrShtCard(dig1,-5);
                 EXIT
   END ;
   Soundock();
 END ; (* loop *)
  Change(wt_invmat,55,10,60,10);
  Use(wt_invmat);  Clear();
 LOOP
   dig2:= IO.RdCard();
   IF (IO.OK) AND (dig2< 9999) THEN Use(wt_mathmet);
                 TextColor(LightMagenta);
                 GotoXY(35,3); IO.WrCard(dig2,-5);
                 EXIT
   END ;
   Soundock();
 END ; (* loop *)
  Hide(wt_invmat);
  DownHelp125();
 LOOP
 answ:= IO.RdCharDirect();
  CASE answ OF
    CHAR(13):
      Hide(wt_mathmet);
      Close_Shadow(shadow_m);
      shadow_w:= WaitingOn();
      (* InitScr(); *)
      space:= katok(dig1,dig2,FileInformArray[contdisk_contr].Name,out_name);
      (* DeInitScr(); *)
      WaitingOff(shadow_w);
      Control();
      EXIT
   |CHAR(32): GOTO lab0
   |CHAR(27): Hide(wt_mathmet);
              Close_Shadow(shadow_m);
              GOTO lab_end
  END; (* case *)
 END; (* loop *)
ELSE space:= -1;
     Control();
END; (* if *)
lab_end:
END Meth_7;

PROCEDURE Meth_8(number: CARDINAL);
VAR
  dlinna:   CARDINAL;
  answ:     CHAR;
  bool:     BOOLEAN;
  wait:     CARDINAL;
  string:   ARRAY [1..50] OF CHAR;
BEGIN
  CASE number OF
              7:  bool:= TRUE;
                  string:= ' Сглаживание спектральной плотности по Хеннингу';
             |8:  bool:= FALSE;
                  string:= ' Сглаживание спектральной плотности по Хеммингу';
  END; (* case *)
  Use(wt_inverhormenu); Clear();
  IO.WrStr(string);
dlinna:= Str.Length(FileInformArray[contdisk_contr].Name);
IF   ( (FileInformArray[contdisk_contr].Name[dlinna-1] = 'l') OR
       (FileInformArray[contdisk_contr].Name[dlinna-1] = 'L')  )
 AND
     ( (FileInformArray[contdisk_contr].Name[dlinna-2] = 'p') OR
       (FileInformArray[contdisk_contr].Name[dlinna-2] = 'P')  )
 AND
     ( (FileInformArray[contdisk_contr].Name[dlinna-3] = 's') OR
       (FileInformArray[contdisk_contr].Name[dlinna-3] = 'S')  )
 THEN
  wait:= WaitingOn();
  InitScr();
(*  fuflo; *)
  space:= heing(bool,FileInformArray[contdisk_contr].Name,out_name);
  DeInitScr();
  WaitingOff(wait);
  Control();
ELSE space:= -1;
     Control();
END; (* if *)
END Meth_8;

BEGIN
beta[0] := 0.8;
beta[1] := 0.82;
beta[2] := 0.84;
beta[3] := 0.86;
beta[4] := 0.88;
beta[5] := 0.9;
beta[6] := 0.92;
beta[7] := 0.94;
beta[8] := 0.95;
beta[9] := 0.96;
beta[10]:= 0.97;
beta[11]:= 0.98;
beta[12]:= 0.99;
beta[13]:= 0.999;
wt_out:= Open(wd_out);
END DigitCon.