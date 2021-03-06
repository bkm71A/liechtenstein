MODULE pr_obrab;
IMPORT IO,Str,Lib;
FROM Window   IMPORT  Color,WinType,WinDef,SingleFrame,Open,Close,Clear,TextColor,
                      SetTitle,GotoXY,FullScreen,Use,PutOnTop,Change,DoubleFrame,
                      CenterUpperTitle,LeftUpperTitle,Hide,FrameStr,SetFrame,
                      TitleMode,TextBackground,ClrEol;
FROM FIO      IMPORT  ChDir;
FROM ServisVl IMPORT  GetNameLastDrive;
FROM Difer    IMPORT  differ;
FROM Integr   IMPORT  integral;
FROM filtr    IMPORT  filtration;
FROM MakeMenu IMPORT  MenuMaker,FirstOpeningMenu,wt_menu,wt_pris,wd_pris,wt_invr,
                                                 wt_shpr,wd_shpr,wt_shad;
FROM SearchFl IMPORT  GetContainsCurrentDisk,FileInformArray,GetPath,PathName;

VAR a,a1,Length,Number:      INTEGER;
    LengthWind,LengthName:   INTEGER;
    ContrFiltr,Control:      LONGINT;
    LostGr,HighGr:           REAL;
    Range,
    Proverka,metka_vozvr,i:  CARDINAL;
    wt_info,wt_ishd,wt_por,
    wt_prist,wt_wait,wt_shwt:WinType;
    wd_info,wd_ishd,wd_por,
    wd_prist,wd_wait,wd_shwt:WinDef;
    LastDisk,answ:           CHAR;
    Proverka_vozvr:          BOOLEAN;
    PathExit:                ARRAY[0..52] OF CHAR;
    peremen:                 ARRAY[0..12] OF CHAR;


LABEL lab0,lab1,lab_d,lab_d1,lab_i;


PROCEDURE AnalizGr(min,max: REAL; X1,Y1: CARDINAL): REAL;
 VAR  digit: REAL;
BEGIN
   Change(wt_por,X1,Y1,X1+8,Y1);
   PutOnTop(wt_por);
   digit:=IO.RdReal();
   Hide(wt_por);
 IF (digit>=min)AND(digit<=max) THEN RETURN digit;   ELSE RETURN 0.;  END;
END AnalizGr;


PROCEDURE AnalizRange(min,max,X1: CARDINAL): CARDINAL;
 VAR  digit : CARDINAL;
BEGIN
   Change(wt_por,X1,wd_por.Y1,X1+4,wd_por.Y2);
   PutOnTop(wt_por);
   digit:=IO.RdCard();
   Hide(wt_por);
 IF (digit>=min)AND(digit<=max) THEN RETURN digit;   ELSE RETURN 0;  END;
END AnalizRange;


PROCEDURE FileOtobr(): CARDINAL;
VAR ret:  CARDINAL;
    long: CARDINAL;
    answ: CHAR;
BEGIN
(* -- ��⠭����� ⥪���� ���४���, �������� � ��� ��� ��࠭���� 䠩�� -- *)
GetPath();
Str.Append(PathName,FileInformArray[Number].Name);
Use(wt_info); Clear();
TextColor(LightRed);
TextBackground(Red);
GotoXY(3,1); IO.WrStr('���� ��࠭�� ���� ��� ��ࠡ�⪨');
GotoXY(5,3); IO.WrStr('���⢥ত���� �롮� <ENTER>');
GotoXY(8,4); IO.WrStr('��������� �롮� <ESC>');
GotoXY(4,5); IO.WrStr('�⪠� �� ����७�஢���� <Q>');
long:= Str.Length(PathName);
i:= (wd_info.X2 - wd_info.X1 - long) >> 1 ;
TextColor(White);
TextBackground(LightRed) ;
GotoXY(i,2); IO.WrStr(PathName);
TextBackground(Red) ;
PutOnTop(wt_ishd);
PutOnTop(wt_info);
LOOP
answ:= IO.RdCharDirect();
 CASE answ OF CHAR(13): ret:= 0;
                        EXIT
             |CHAR(27): ret:= 1;
                        EXIT
             |'Q','q':  ret:= 2;
                        EXIT
 END; (* case *)
END; (* loop *)
Hide(wt_ishd);
Hide(wt_info);
RETURN ret;
END FileOtobr;

PROCEDURE WaitingOn();
BEGIN
wt_shwt:= Open(wd_shwt);
wt_wait:= Open(wd_wait);
GotoXY(6,1); IO.WrStr('Processing');
GotoXY(2,2); IO.WrStr('Please waiting !!');
END WaitingOn;

PROCEDURE  WaitingOff();
BEGIN
Close(wt_wait);
Close(wt_shwt);
END WaitingOff;

BEGIN

(* ----------- ���������� � PathExit ⥪���� ���४��� �室� ------------ *)
GetPath();
Str.Copy(PathExit,PathName);
Length:= Str.Length(PathExit);
IF Length= 3 THEN INC(Length) END;
Str.Delete(PathExit,Length-1,1);
(* ----------- ����⥫� ��� ���� �᭮����� ⥫� �ணࠬ�� -------------- *)
wd_info:=WinDef(40,1,77,7,LightBlue,Red,FALSE,FALSE,TRUE,TRUE,SingleFrame,Yellow,Red);
wd_ishd:=WinDef(41,2,78,8,Red,Black,FALSE,FALSE,TRUE,FALSE,SingleFrame,Red,Red);
wd_por:= WinDef(59,7,63,7,White,LightGreen,TRUE,FALSE,TRUE,FALSE,SingleFrame,Red,Red);
wd_wait:=WinDef(29,10,49,13,White,LightRed,FALSE,FALSE,FALSE,TRUE,SingleFrame,Yellow,Red);
wd_shwt:=WinDef(30,11,50,14,Red,DarkGray,FALSE,FALSE,FALSE,FALSE,'........',Red,Red);

(* ------------------------ ���뢠�� �� ���� ---------------------------- *)
FirstOpeningMenu(TRUE,Cyan);
wt_ishd:= Open(wd_ishd);
wt_info:= Open(wd_info);
wt_por:=  Open(wd_por);
wt_pris:= Open(wd_pris);
wt_shpr:= Open(wd_shpr);
(* --------------------- �᭮���� ⥫� �ணࠬ�� -------------------- *)
  LOOP
     a:= MenuMaker(10,1,           (* ���न���� ���孥�� ������ 㣫� *)
                   White,          (* 梥� ⥪�� � ���� *)
                   8,              (* �������⢮ ����� � ���� *)
                   TRUE,           (* ����稥 ࠬ�� *)
                   SingleFrame,    (* ⨯ ࠬ�� *)
                   White,Blue,     (* 梥� ࠬ�� � 䮭� *)
                   TRUE,           (* ����稥 ⥭� *)
                   FALSE,          (* ����稥 ����ன�� *)
                   0,0,            (* ��ਧ��⠫�� � ���⨪���� ࠧ��� ����ன�� *)
                   TRUE,           (* ����稥 ��������� *)
                   CenterUpperTitle,
                   ' �।���⥫쭠� ��ࠡ�⪠ ',(* ᮤ�ঠ��� ��������� *)
                   '�롮� 䠩�� ������ ��� ��ࠡ�⪨+������᪠� ��ࠡ�⪠+�������� �室��� ᨣ�����+���᫥��� ᯥ��ࠫ��� �ࠪ���⨪+���᫥��� ���५�樮���� �ࠪ���⨪+����७�஢���� �����+��⥣�஢���� �����+��室 � ������� ����',
                   39                    (* ������ �������襣� ���� ����*) );
lab0:
    CASE a OF
(*  ---------- �롮� ����� 䠩�� ��� ��ࠡ�⪨ ---------------- *)
              0: Proverka_vozvr:= FALSE;
                 lab1:
                 Number:= GetContainsCurrentDisk('*.*');
                 IF Proverka_vozvr THEN a:= metka_vozvr;
                                        GOTO lab0
                 END;
(* ----------- ������᪠� ��ࠡ�⪠ --------------------- *)
             |1: LOOP
                   a1:= MenuMaker(35,7,LightRed,3,TRUE,SingleFrame,Yellow,Blue,
                                 TRUE,FALSE,0,0,TRUE,CenterUpperTitle,
                                 ' ������᪠� ��ࠡ�⪠ ',
                                 '���冷� �ந�������+�����+��室',26);
                   CASE a1 OF 0:
                             |1:
                             |2: EXIT
                   END; (* case *)
                 END; (* loop *)
(* -------- 䨫����� �室��� ᨣ����� ---------------------- *)
             |2: LOOP
                   a1:= MenuMaker(35,7,LightRed,4,TRUE,DoubleFrame,Yellow,Blue,
                                  TRUE,TRUE,9,4,TRUE,LeftUpperTitle,
                                 ' �������� �室��� ᨣ����� ',
                                 '������ �࠭�� (1-10)+������ �࠭��(100-1000)+�����+��室',24);
                   CASE a1 OF 0: LostGr:= AnalizGr(1.,10.,66,9);
                                 IF LostGr=0. THEN
                                           Use(wt_pris);
                                           TextBackground(LightBlue);
                                           TextColor(White);
                                           GotoXY(1,2); ClrEol();
                                           IO.WrStr('ERROR');
                                           TextBackground(Blue);
                                    ELSE   Use(wt_pris);
                                           GotoXY(0,2); ClrEol();
                                           IO.WrReal(LostGr,5,5)
                                 END; (* if *)
                             |1: HighGr:= AnalizGr(100.,1000.,66,10);
                                 IF HighGr=0. THEN
                                           Use(wt_pris);
                                           TextBackground(LightBlue);
                                           TextColor(White);
                                           GotoXY(1,3); ClrEol();
                                           IO.WrStr('ERROR');
                                           TextBackground(Blue);
                                    ELSE   Use(wt_pris);
                                           GotoXY(0,3); ClrEol();
                                           IO.WrReal(HighGr,5,5)
                                 END; (* if *)
                             |2: Proverka:= FileOtobr();
                                 CASE Proverka OF
                                      0: WaitingOn();
(* ������ �������� - ��⠢��� *)         ContrFiltr:= filtration(TRUE,LostGr,HighGr,FileInformArray[Number].Name);
                                         WaitingOff();
                                     |1: Hide(wt_menu); Hide(wt_pris);
                                         Hide(wt_shad); Hide(wt_shpr);
                                         Hide(wt_invr);
                                         Proverka_vozvr:= TRUE;
                                         metka_vozvr:= 2;
                                         GOTO lab1
                                     |2: GOTO lab_d1
                                 END; (* case *)

                             |3: GOTO lab_d1;
                   END; (* case *)
                 END; (* loop *)
(* -------- ���᫥��� ᯥ��ࠫ��� �ࠪ���⨪ ------------- *)
             |3: LOOP
                   a1:= MenuMaker(35,7,LightRed,3,TRUE,SingleFrame,Yellow,Blue,
                                   TRUE,FALSE,0,0,TRUE,CenterUpperTitle,
                                 ' ���᫥���  ᯥ��ࠫ��� �ࠪ���⨪ ',
                                 '���冷� �ந�������+�롮� 䠩��+��室',38);
                   CASE a1 OF 0:
                             |1:
                             |2: EXIT
                   END; (* case *)
                 END; (* loop *)
(* --------- ���᫥��� ���५�樮���� �ࠪ���⨪ ------------- *)
             |4: LOOP
                   a1:= MenuMaker(35,7,LightRed,3,TRUE,SingleFrame,Yellow,Blue,
                                  TRUE,FALSE,0,0,TRUE,CenterUpperTitle,
                                 ' ���᫥��� ���५�樮���� �ࠪ���⨪ ',
                                 '���冷� �ந�������+�롮� 䠩��+��室',38);
                   CASE a1 OF 0:
                             |1:
                             |2: EXIT
                   END; (* case *)
                 END; (* loop *)
(* ---------- ����७�஢���� ����� -------------------------- *)
             |5: Use(wt_pris); Clear();
                 LOOP
                   a1:= MenuMaker(30,5,LightRed,3,TRUE,DoubleFrame,Yellow,Blue,
                                   TRUE,TRUE,5,3,TRUE,LeftUpperTitle,
                                 ' ����७�஢���� ����� ',
                                 '���冷� �ந�������(1-3)+�����+��室',22);
                   CASE a1 OF 0: Range:= AnalizRange(1,3,59);
                                 IF Range= 0 THEN
                                    lab_d: Use(wt_pris); Clear();
                                           TextBackground(LightBlue);
                                           TextColor(White);
                                           GotoXY(1,2); IO.WrStr('ERROR');
                                           TextBackground(Blue);
                                    ELSE   Use(wt_pris); Clear();
                                           GotoXY(3,2);IO.WrCard(Range,1)
                                 END; (* if *)
                             |1: IF (Range>3)OR(Range<1) THEN GOTO lab_d END;
                                 Proverka:= FileOtobr();
                                 CASE Proverka OF
                                        0: WaitingOn();
                                           Control:= differ(Range,FileInformArray[Number].Name);
                                           WaitingOff();
                                       |1: Hide(wt_menu); Hide(wt_pris);
                                           Hide(wt_shad); Hide(wt_shpr);
                                           Hide(wt_invr);
                                           Proverka_vozvr:= TRUE;
                                           metka_vozvr:= 5;
                                           GOTO lab1
                                       |2: GOTO lab_d1
                                 END; (* case *)
                             |2: lab_d1:
                                 Hide(wt_pris);
                                 Hide(wt_shpr);
                                 EXIT
                   END; (* case *)
                 END; (* loop *)
(* ------------ ��⥣�஢���� ����� -------------------- *)
             |6: Use(wt_pris); Clear();
                 LOOP
                   a1:= MenuMaker(30,5,LightRed,3,TRUE,DoubleFrame,Yellow,Blue,
                                  TRUE,TRUE,5,3,TRUE,LeftUpperTitle,
                                 ' ��⥣�஢���� ����� ',
                                 '���冷� ��⥣�஢����(1-2)+�����+��室',25);
                   CASE a1 OF 0: Range:= AnalizRange(1,2,62);
                                 IF Range= 0 THEN
                                    lab_i: Use(wt_pris); Clear();
                                           TextBackground(LightBlue);
                                           TextColor(White);
                                           GotoXY(1,2); IO.WrStr('ERROR');
                                           TextBackground(Blue);
                                    ELSE   Use(wt_pris); Clear();
                                           GotoXY(3,2);IO.WrCard(Range,1)
                                 END; (* if *)


                             |1: IF (Range>2)OR(Range<1) THEN GOTO lab_i END;
                                 Proverka:= FileOtobr();
                                 CASE Proverka OF
                                        0: WaitingOn();
                                           LastDisk:= GetNameLastDrive();
                                           Control:= integral(LastDisk,Range,FileInformArray[Number].Name);
                                           WaitingOff();
                                       |1: Hide(wt_menu); Hide(wt_pris);
                                           Hide(wt_shad); Hide(wt_shpr);
                                           Hide(wt_invr);
                                           Proverka_vozvr:= TRUE;
                                           metka_vozvr:= 6;
                                           GOTO lab1
                                       |2: GOTO lab_d1
                                 END; (* case *)
                             |2: Hide(wt_pris);
                                 Hide(wt_shpr);
                                 EXIT;
                   END; (* case *)
                 END; (* loop *)
(* ------------ ��室 �� �������� ���� ------------------------ *)
             |7: EXIT
    END; (* case *)
  END ; (* loop *)
(* -------------- ��室�� �㤠-��, ��㤠 ��諨 --------------- *)
ChDir(PathExit);
END pr_obrab.

