IMPLEMENTATION MODULE Probr_lb;
IMPORT FIO,Str,IO,Lib;
FROM   Assa     IMPORT  Screen,Print_ready;
FROM   GraphVl  IMPORT  PolygonDoubleFr,OutText;
FROM   ServisVl IMPORT  DiskFree,CheckDrive;
FROM   TxtImage IMPORT  SaveScreen,RestoreScreen;
FROM   MakeMenu IMPORT  Vert_menu,wt_menu,wt_invr;
FROM   GraphSk  IMPORT  Put_Image,Get_Image;
FROM   Etiketka IMPORT  title;
FROM   SearchFl IMPORT  FileInformArray,GetCurrentDrive,DriveName,GetAllDrives,
                        drive_computer;
FROM   Down_hlp IMPORT  DownHelp0,DownHelp01,DownHelp012,DownHelp120,DownHelp221_31;
FROM   _Window  IMPORT  Open_Shadow,Close_Shadow,Shadow;
FROM   DigitCon IMPORT  wd_mathmet,wd_invmat, wt_mathmet,wt_invmat;
FROM   Window   IMPORT  WinDef,WinType,Color,TextColor,DoubleFrame,SingleFrame,
                        Open,Close,GotoXY,Use,SetTitle,Clear,CenterUpperTitle,
                        LeftLowerTitle,Change,TextBackground,PutOnTop,Hide,
                        SetFrame;
VAR    i:       CARDINAL;
       drive:   SHORTCARD;

PROCEDURE Soundock();
BEGIN
  Lib.Sound(400);
  Lib.Delay(250);
  Lib.NoSound();
END Soundock;

PROCEDURE SetOnHorMenu(): CARDINAL;
VAR
 shad_control: CARDINAL;
BEGIN
  wt_hormenu:= Open(wd_hormenu);
  shad_control:= Open_Shadow(wt_hormenu);
  wt_inverhormenu:= Open(wd_inverhormenu);
  RETURN shad_control;
END SetOnHorMenu;

PROCEDURE SetOffHorMenu(shad_control: CARDINAL);
BEGIN
  Close(wt_hormenu);
  Close(wt_inverhormenu);
  Close_Shadow(shad_control);
END SetOffHorMenu;

PROCEDURE Zaglu();
VAR
    wd_wd:   WinDef;
    wt_wd:   WinType;
    answ:    CHAR;
    control: CARDINAL;
    sh_contr:CARDINAL;
BEGIN
 SaveScreen();
   wd_wd:= WinDef(8,8,71,11,White,Red,FALSE,FALSE,FALSE,TRUE,SingleFrame,Cyan,Red);
   wt_wd:= Open(wd_wd);
   sh_contr:= Open_Shadow(wt_wd);
   Use(wt_wd);
   GotoXY(2,1); IO.WrStr('����� ०�� �।�����祭 ��� ���쭥�襣� ���७�� ��⥬�');
   TextColor(LightGray);
   GotoXY(12,2);  IO.WrStr('��� �த������� ������ ���� �������');
   Soundock();
   answ:= IO.RdCharDirect();
   Close(wt_wd);
   Close_Shadow(sh_contr);
 RestoreScreen();
END Zaglu;



PROCEDURE Attantion(file_name: ARRAY OF CHAR): BOOLEAN;
VAR
    wd_wd:   WinDef;
    wt_wd:   WinType;
    answ:    CHAR;
    sizek:   LONGCARD;
    control: CARDINAL;
    sh_contr:CARDINAL;
    file:    FIO.File;
    ident:   ARRAY[1..2] OF CHAR;
BEGIN
   wd_wd:= WinDef(15,8,65,14,White,Red,FALSE,FALSE,FALSE,TRUE,SingleFrame,Cyan,Red);
   file:= FIO.Open(file_name);
   FIO.Seek(file,26); control:= FIO.RdBin(file,sizek,4);
   FIO.Seek(file,34); control:= FIO.RdBin(file,ident,2);
   FIO.Close(file);
 IF NOT(Str.Match(ident,'SW')) OR (sizek<= 0) THEN
        wt_wd:= Open(wd_wd);
        sh_contr:= Open_Shadow(wt_wd);
        Use(wt_wd);
        GotoXY(6,3); IO.WrStr('�ଠ� ������ �� ᮮ⢥����� ��⥬�');
       TextColor(Yellow);
        GotoXY(18,1); IO.WrStr('� � � � � � !');
       TextColor(LightGray);
        GotoXY(7,5);  IO.WrStr('��� �த������� ������ ���� �������');
        Soundock();
  ELSIF Str.Match(ident,'SW') THEN RETURN TRUE;
 END; (* if *)
answ:= IO.RdCharDirect();
Close(wt_wd);
Close_Shadow(sh_contr);
RETURN FALSE;
END Attantion;

PROCEDURE WaitingOn(): CARDINAL;
 VAR
  shad_contr: CARDINAL;
BEGIN
 wt_wait:= Open(wd_wait);
 shad_contr:= Open_Shadow(wt_wait);
 Use(wt_wait);
 IO.WrStr('   �믮������� �����...');
 RETURN shad_contr;
END WaitingOn;

PROCEDURE WaitingOff(shad_contr: CARDINAL);
BEGIN
 Close(wt_wait);
 Close_Shadow(shad_contr);
END WaitingOff;

PROCEDURE InputDrive();
VAR
   i:         INTEGER;
   answ:      CHAR;
   shadow:    CARDINAL;
   dr_name:   ARRAY [1..3]  OF CHAR;
LABEL
   lab1;
BEGIN
SaveScreen();
lab1:
  DownHelp012();
  GetAllDrives();
  Change(wt_range,5,8,9,9+drive_computer+2);
  shadow:= Open_Shadow(wt_range);
  PutOnTop(wt_range);    Clear();

  FOR i:= 1 TO drive_computer+2 DO
    GotoXY(2,i);  IO.WrChar(CHAR(DriveName[i]+40H));
  END; (* for *)
  Change(wt_invrange,6,9,8,9);
  PutOnTop(wt_invrange);  Clear();
  i:= 1;
  GotoXY(2,1); IO.WrChar(CHAR(DriveName[i]+40H));
 LOOP
  answ:= IO.RdCharDirect();
  CASE answ OF
       CHAR(13): Str.Concat(dr_name,CHAR(DriveName[i]+40H),':\');
                 FIO.ChDir(dr_name);
                 EXIT
      |CHAR(0) : answ:= IO.RdCharDirect();
                    CASE answ OF
                         CHAR(72): DEC(i)
                        |CHAR(80): INC(i)
                    END; (* case *)
  END; (* case *)
     IF i< 1 THEN i:= drive_computer+2 END;
     IF i> drive_computer+2 THEN i:= 1 END;
     Change(wt_invrange,6,i+8,8,i+8);
     Use(wt_invrange); Clear();
     GotoXY(2,1); IO.WrChar(CHAR(DriveName[i]+40H));
 END; (* loop *)

    Hide(wt_range);
    Hide(wt_invrange);
    Close_Shadow(shadow);
RestoreScreen();
END InputDrive;

PROCEDURE InputShablon(quant: INTEGER; shablon: ARRAY OF CHAR);
VAR
   i:         INTEGER;
   answ:      CHAR;
   shadow:    CARDINAL;
   substring: ARRAY[1..6] OF CHAR;
BEGIN
SaveScreen();
    DownHelp01();
    Change(wt_range,5,7,15,8+quant);
    shadow:= Open_Shadow(wt_range);
    PutOnTop(wt_range);
    Clear();
  FOR i:= 0 TO quant DO
    Str.ItemS(substring,shablon,'+',i);
    GotoXY(3,i+1) ; IO.WrStr(substring);
  END; (* for *)
   Change(wt_invrange,7,8,13,8);
   Use(wt_invrange); Clear();
   PutOnTop(wt_invrange);
 i:= 0;
   Str.ItemS(substring,shablon,'+',i);
   GotoXY(2,1); IO.WrStr(substring);
 LOOP
  answ:= IO.RdCharDirect();
  CASE answ OF
       CHAR(13): Str.Copy(shablon_g,substring); EXIT
      |CHAR(0) : answ:= IO.RdCharDirect();
                    CASE answ OF
                         CHAR(72): DEC(i)
                        |CHAR(80): INC(i)
                    END; (* case *)
  END; (* case *)
     IF i< 0 THEN i:= quant-1 END;
     IF i> quant-1 THEN i:= 0 END;
     Change(wt_invrange,7,i+8,13,i+8);
     Use(wt_invrange); Clear();
     Str.ItemS(substring,shablon,'+',i);
     GotoXY(2,1);  IO.WrStr(substring);
 END; (* loop *)
    Hide(wt_range);
    Hide(wt_invrange);
    Close_Shadow(shadow);
RestoreScreen();
END InputShablon;

PROCEDURE InputMethod(): INTEGER;
VAR
    ii:              INTEGER;
    answ:            CHAR;
    shadow:          CARDINAL;
    substring:       ARRAY[1..35] OF CHAR;
CONST
   contain= '�������� � ����� ����|'+
            '����������� ����� ��|'+
            '���᫥��� ᯥ���|'+
            '���᫥��� ᯥ��ࠫ쭮� ���⭮��|'+
            '���᫥��� ��⮪���. �㭪樨|'+
            '�����. ᯥ�. ���⭮�� �� ���⠬|'+
(*          '��.ᯥ�.����. �� ��ᠬ��� ����|'+       *)
            '�����. ᯥ�. ���⭮�� �� ��������|'+
            '�����. ᯥ�. ���⭮�� �� ��������';
BEGIN
    Change(wt_range,25,6,62,15);                         (* 16 -> 15 *)
    shadow:= Open_Shadow(wt_range);
    PutOnTop(wt_range);
    Clear();
  FOR ii:= 0 TO 7 DO                         (* ������� �� 7 ��⮤�� *)
    Str.ItemS(substring,contain,'|',ii);
    GotoXY(2,ii+1) ; IO.WrStr(substring);
  END; (* for *)
   Change(wt_invrange,26,7,61,7);
   Use(wt_invrange); Clear();
   GotoXY(2,1); IO.WrStr('�������� � ����� ����');
   PutOnTop(wt_invrange);
 ii:= 0;
 LOOP
  answ:= IO.RdCharDirect();
  CASE answ OF
       CHAR(13): EXIT;
      |CHAR(32): SaveScreen();
                 title(FileInformArray[contdisk_contr].Name);
                 RestoreScreen();
      |CHAR(27): ii:= MAX(INTEGER); EXIT;
      |CHAR(0) : answ:= IO.RdCharDirect();
                    CASE answ OF
                         CHAR(72): DEC(ii)
                        |CHAR(80): INC(ii)
                    END; (* case *)
  END; (* case *)
     IF ii< 0 THEN ii:= 7 END;       (* �।��� 8 �� 7 *)
     IF ii> 7 THEN ii:= 0 END;       (* �।��� 8 �� 7 *)
     Change(wt_invrange,26,ii+7,61,ii+7);
     Use(wt_invrange); Clear();
     Str.ItemS(substring,contain,'|',ii);
     GotoXY(2,1);  IO.WrStr(substring);
 END; (* loop *)
    Hide(wt_range);
    Hide(wt_invrange);
    Close_Shadow(shadow);
    RETURN ii;
END InputMethod;

PROCEDURE File_error(): BOOLEAN;
VAR
 file:           FIO.File;
 control:        CARDINAL;
 control_file:   CARDINAL;
 answ:           CHAR;
 ok:             BOOLEAN;
 str:            ARRAY [0..30] OF CHAR;
BEGIN
 file:= FIO.Open(FileInformArray[contdisk_contr].Name);
 FIO.Close(file);
 control_file:= FIO.IOresult();
IF control_file <> 0 THEN
  CASE control_file OF
    2: str:= '���� �� ������';
   |3: str:= '���� �� ������';
   |4: str:= '���誮� ����� ������� 䠩���';
   |6: str:= '�� ��࠭� ��� 䠩��';
   |8: str:= '�������筮 �����';
   |21:str:= '��᪮��� �� ��⮢';
  ELSE Str.CardToStr(LONGCARD(control_file),str,10,ok);
       Str.Concat(str,'��� �訡�� ���  ',str);
  END; (* case *)
 control:= Open_Shadow(wt_attantion);
 PutOnTop(wt_attantion);   Clear();
 control_file:= Str.Length(str);
 TextColor(White);
  GotoXY(25-control_file DIV 2,3); IO.WrStr(str);
 TextColor(Yellow);
  GotoXY(18,1); IO.WrStr('� � � � � � !');
 TextColor(LightGray);
  GotoXY(7,5);  IO.WrStr('��� �த������� ������ ���� �������');
  Soundock();
  answ:= IO.RdCharDirect();
  Hide(wt_attantion);
  Close_Shadow(control);
  RETURN FALSE;
 ELSE RETURN TRUE
END; (* if *)
END File_error;

PROCEDURE File_menu(): CARDINAL;
VAR
  mm:        CARDINAL;
BEGIN
  DownHelp0();
  mm:= Vert_menu(3,6,LightCyan,4,TRUE,SingleFrame,Yellow,Blue,
                FALSE,TRUE,FALSE,CenterUpperTitle,'',
                '�롮� 䠩��+�롮� 蠡����+�롮� ��᪠+��室',13);
  CASE mm OF
          3,0:  Hide(wt_menu);
                Hide(wt_invr);
  END; (* case *)
  RETURN mm;
END File_menu;

PROCEDURE Space_free(dig: LONGINT);
VAR
  control:     CARDINAL;
  length:      CARDINAL;
  bool:        BOOLEAN;
  answ:        CHAR;
  str:         ARRAY [1..45] OF CHAR;
BEGIN
    control:= Open_Shadow(wt_attantion);
    PutOnTop(wt_attantion); Clear();
    TextColor(LightGray);
    GotoXY(7,5);  IO.WrStr('��� �த������� ������ ���� �������');
    TextColor(Yellow);
    GotoXY(19,1); IO.WrStr('� � � � � � !');
IF       dig> 0  THEN  Str.IntToStr(dig,str,10,bool);
                       Str.Insert(str,'�� ��᪥ �� 墠⠥� ',0);
                       Str.Append(str,' ����');
  ELSIF  dig=  1 THEN  str:= '�㫫�� ���� �����';
  ELSIF  dig=  2 THEN  str:= '��� �����, � ��।� �� ����� �����';
  ELSIF  dig=  3 THEN  str:= '��㡠� �訡�� �� ࠡ�� � �ਭ�஬ ';
  ELSIF  dig= -1 THEN  str:= '����७�� ������ ���� .SPL';
  ELSIF  dig= -2 THEN  str:= '������ 䠩�� ���� ����';
  ELSIF  dig= -3 THEN  str:= '����७�� ������ ���� .DAT ��� .FL*';
  ELSIF  dig= -4 THEN  str:= '����७�� ������ ���� .DAT ��� .DF*';
  ELSIF  dig= -5 THEN  str:= '����७�� ������ ���� .DAT ��� .IN*';
  ELSIF  dig= -6 THEN  str:= '����७�� ������ ���� .DAT';
  ELSIF  dig= -7 THEN  str:= '����� ��ᮢ���⨬� �� �஢������ ��ࠡ�⪠�';
  ELSIF  dig= -8 THEN  str:= '����� ��ᮢ���⨬� �� ��०������';
  ELSIF  dig= -9 THEN  str:= '����� ��ᮢ���⨬� �� ������ ०���';
  ELSIF  dig=-10 THEN  str:= '����� ��ᮢ���⨬� �� ���� ����⨧�樨';
  ELSIF  dig=-11 THEN  str:= '����� ��ᮢ���⨬� �� ⨯� ��쥪�';
  ELSIF  dig=-12 THEN  str:= '�� ���� ᮧ���� 䠩� � ⠪�� ��࠭�� ������';
  ELSIF  dig=-13 THEN  str:= '����� 䠩�� 㪠������ � �⨪�⪥ 0 ����';
  ELSIF  dig=-14 THEN  str:= '����� ॠ����樨 ���e� 200 ���祭��';
  ELSIF  dig=-15 THEN  str:= '�� ��᪥ ��������� 䠩� hi2.tbl';
  ELSE                 Str.IntToStr(ABS(dig),str,10,bool);
                       Str.Insert(str,'�  ���   �� 墠⠥� ',0);
                       Str.Append(str,' ����');
END; (* if *)
 length:= Str.Length(str);
 TextColor(White);
 GotoXY(25-length DIV 2,3); IO.WrStr(str);
 Soundock();
answ:= IO.RdCharDirect();
Close_Shadow(control);
Hide(wt_attantion);
END Space_free;

BEGIN
 wt_invrange:= Open(wd_invrange);
 wt_range:= Open(wd_range);
 wt_mathmet:= Open(wd_mathmet);
 wt_invmat:= Open(wd_invmat);
 wt_attantion:= Open(wd_attantion);
 FIO.IOcheck:= FALSE;
END Probr_lb.


(*
PROCEDURE Fio_check(): BOOLEAN;
VAR
 control:        CARDINAL;
 control_file:   CARDINAL;
 ok:             BOOLEAN;
 answ:           CHAR;
 str:            ARRAY [0..35] OF CHAR;
BEGIN
 control_file:= FIO.IOresult();
IF control_file <> 0 THEN
  CASE control_file OF
    2: str:= '���� �� ������';
   |3: str:= '���� �� ������';
   |4: str:= '���誮� ����� ������� 䠩���';
   |5: str:= '����� �⢥࣭��';
   |6: str:= '������ ����⥫�';
   |7: str:= '�����襭� ����� �ࠢ����� �������';
   |8: str:= '�������筮 �����';
   |9: str:= '������ ���� ����� �����';
   |15:str:= '����� ������ ���';
   |16:str:= '����� 㤠���� ⥪. ����������';
   |19:str:= '����⪠ ����� �� ���饭�� ���';
   |21:str:= '��᪮��� �� ��⮢';
  ELSE Str.CardToStr(LONGCARD(control_file),str,10,ok);
       Str.Concat(str,'��� �訡�� ���  ',str);
  END; (* case *)
 control:= Open_Shadow(wt_attantion);
 PutOnTop(wt_attantion);   Clear();
 control_file:= Str.Length(str);
 TextColor(White);
  GotoXY(25-control_file DIV 2,3); IO.WrStr(str);
 TextColor(Yellow);
  GotoXY(18,1); IO.WrStr('� � � � � � !');
 TextColor(LightGray);
  GotoXY(7,5);  IO.WrStr('��� �த������� ������ ���� �������');
  Soundock();
  answ:= IO.RdCharDirect();
  Hide(wt_attantion);
  Close_Shadow(control);
  RETURN FALSE;
 ELSE RETURN TRUE;
END; (* if *)
END Fio_check;
*)
