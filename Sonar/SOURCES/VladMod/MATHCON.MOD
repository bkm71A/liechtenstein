IMPLEMENTATION MODULE MathCon; (* Процедуры математической обработки *)
IMPORT IO,Str;
FROM Difer    IMPORT differ;
FROM DIntegr   IMPORT integral;
(*
FROM Current  IMPORT InitScr,DeInitScr;
*)
FROM SearchFl IMPORT FileInformArray;
FROM DigitCon IMPORT wt_out,wd_out,out_name;
FROM Probr_lb IMPORT Space_free,WaitingOn,WaitingOff,
                     wt_range,wt_invrange,contdisk_contr,wt_inverhormenu;
FROM Down_hlp IMPORT DownHelp221_31,DownHelpAny;
FROM _Window  IMPORT Open_Shadow,Close_Shadow;
FROM Window   IMPORT PutOnTop,Hide,Change,Use,Clear,GotoXY,TextColor,Color,
                     SetTitle,CenterUpperTitle;

PROCEDURE Output();
VAR
  ii: INTEGER;
BEGIN
  DownHelpAny();
  Change(wt_out,15,9,65,11);
  shadow_o:= Open_Shadow(wt_out);
  PutOnTop(wt_out);  Clear();
TextColor(White);
  GotoXY(3,1); IO.WrStrAdj('Имя выходного файла' ,-32);
TextColor(LightMagenta);
  IO.WrStr(out_name);
END Output;

PROCEDURE Control(contr: LONGINT);
BEGIN
 IF contr<> 0
    THEN  Space_free(contr)
    ELSE  Output();
          answ:= IO.RdCharDirect();
          Hide(wt_out);
          Close_Shadow(shadow_o)
 END;
END Control;

PROCEDURE InputRange(type: CHAR): INTEGER;
VAR
  ii:     INTEGER;
  shadow: CARDINAL;
BEGIN
 Change(wt_invrange,46,7,53,7);
 CASE type OF
       'i': Change(wt_range,44,6,65,8);
            computer:= 1
      |'d': Change(wt_range,44,6,75,8);
            computer:= 2
 END; (* case *)
 shadow:= Open_Shadow(wt_range);
 PutOnTop(wt_range);
 Clear();
FOR ii:= 0 TO computer DO
 GotoXY(ii*10+3,1); IO.WrStr(conteins[ii]);
END; (* for *)
 ii:= 0;
 Use(wt_invrange);  Clear();
 GotoXY(2,1);       IO.WrStr(conteins[ii]);
 PutOnTop(wt_invrange);
LOOP
 answ:= IO.RdCharDirect();
 CASE answ OF
      CHAR(13): EXIT;
     |CHAR(27): Hide(wt_range);
                Hide(wt_invrange);
                Close_Shadow(shadow);
                RETURN MAX(INTEGER)
     |CHAR(0) : answ:= IO.RdCharDirect();
                CASE answ OF
                     CHAR(75): DEC(ii)
                    |CHAR(77): INC(ii)
                END; (* case *)
 END; (* case *)
 IF ii< 0 THEN ii:= computer END;
 IF ii> computer THEN ii:= 0 END;
 Change(wt_invrange,ii*10+46,7,ii*10+53,7);
 Use(wt_invrange); Clear();
 GotoXY(2,1); IO.WrStr(conteins[ii]);
END; (* loop *)
 Hide(wt_range);
 Hide(wt_invrange);
 Close_Shadow(shadow);
 RETURN ii;
END InputRange;

PROCEDURE Differen();
VAR
  range:     INTEGER;
  dlinna:    INTEGER;
  shadow:    CARDINAL;
  control:   LONGINT;
LABEL lab_end;
BEGIN
 DownHelp221_31();
  dlinna:= Str.Length(FileInformArray[contdisk_contr].Name);
  LOOP
   CASE  FileInformArray[contdisk_contr].Name[dlinna-2]
      OF 'a','A','f','F','e','E': EXIT
    ELSE Control(-4);
         GOTO lab_end
   END; (* case *)
  END; (* loop *)
  range:= InputRange('d');
 IF range<> MAX(INTEGER) THEN
  shadow:= WaitingOn();
  (* InitScr(); *)
  control:= differ(range+1,FileInformArray[contdisk_contr].Name,out_name);
  (* DeInitScr(); *)
  WaitingOff(shadow);
  Control(control);
 END;
lab_end:
END Differen;

PROCEDURE Integral();
VAR
  dlinna:  INTEGER;
  range:   INTEGER;
  shadow:  CARDINAL;
  control: LONGINT;
LABEL    lab_end;
BEGIN
 DownHelp221_31();
  dlinna:= Str.Length(FileInformArray[contdisk_contr].Name);
  LOOP
   CASE  FileInformArray[contdisk_contr].Name[dlinna-2]
      OF 'a','A','n','N','e','E': EXIT
    ELSE Control(-5);
         GOTO lab_end
   END; (* case *)
  END; (* loop *)
  range:= InputRange('i');
 IF range<> MAX(INTEGER) THEN
  shadow:= WaitingOn();
  (* InitScr(); *)
  control:= integral('e',range+1,FileInformArray[contdisk_contr].Name,out_name);
  (* DeInitScr(); *)
  WaitingOff(shadow);
  Control(control);
 END;
lab_end:
END Integral;
BEGIN
 conteins[0]:= 'первый';
 conteins[1]:= 'второй';
 conteins[2]:= 'третий';
END MathCon.