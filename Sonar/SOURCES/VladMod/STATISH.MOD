IMPLEMENTATION MODULE statish ;

IMPORT FIO,IO,Str,MATHLIB;
FROM SearchFl IMPORT  FileInformArray;
FROM Probr_lb IMPORT  Space_free,WaitingOn,WaitingOff,wt_inverhormenu,
                      contdisk_contr;
FROM Down_hlp IMPORT  wt_downhlp;
FROM _Window  IMPORT  Shadow;
FROM Window   IMPORT  Open,GotoXY,Use,Clear,SetTitle,CenterUpperTitle,PutOnTop,
                      Hide,TextColor,TextBackground,Color;

PROCEDURE stat();
VAR
 file:        FIO.File;
 prom:        CARDINAL; (* ���稪 �� �६� �⥭�� ॠ����樨 �� 䠩�� *)
 diskret:     CARDINAL; (* ���-�� �祪 ��室����� �� ���� ������ ����㭠 *)
 polz:        CARDINAL; (* �஬������ ���稪 ��� �ࠢ����� � diskret *)
 control:     CARDINAL;
 begin:       CARDINAL;
 x_coord:     CARDINAL;
 computer:    LONGCARD;
 digit:       REAL;
 M2,M3,M4,
 MMM        : LONGREAL ;
 substring:   ARRAY [0..15] OF CHAR;
 stat:        ARRAY [0..4]  OF LONGREAL;
 control_sh:  CARDINAL;
CONST
 contains= '��⮦������...|��ᯥ���.....|�KO...........|�ᨬ�����....|'+
           '������.......';
LABEL lab_end;
BEGIN
Use(wt_inverhormenu); Clear();
TextColor(Black); IO.WrStr(' ���᫥��� ����ࠪ���⨪');
  x_coord:= 1;
  polz:= 0;
file:= FIO.Open(FileInformArray[contdisk_contr].Name);
FIO.Seek(file,26);  control:= FIO.RdBin(file,computer,4);
FIO.Seek(file,32);  control:= FIO.RdBin(file,begin,2);
FIO.Seek(file,44);  control:= FIO.RdBin(file,digit,4);  stat[0]:= LONGREAL(digit);
FIO.Seek(file,LONGCARD(begin));
M2 := 0. ;
M3 := 0. ;
M4 := 0. ;
(* --------------- �����⠢������ ����� ��� �ᮢ���� ����㭪� ------------- *)
 IF computer= 0
   THEN Space_free(-13);
        GOTO lab_end
 END;
 control_sh:= WaitingOn();
  diskret:= CARDINAL(computer) DIV 66;
  Use(wt_downhlp);
  GotoXY(0,1);  TextBackground(LightGray); TextColor(Black); IO.WrCharRep('�',66);
  GotoXY(71,1); TextBackground(Red);   TextColor(White); IO.WrStr(' %  ');
 LOOP
   control := FIO.RdBin(file,digit,4) ;
   IF FIO.EOF OR (FIO.IOresult()<> 0) THEN EXIT END;
   MMM := LONGREAL(digit)*LONGREAL(digit);
   M2  := M2 + MMM;                  (* ���������� 2-� �⥯��� *)
   M3  := M3 + MMM*LONGREAL(digit);  (* ���������� 3-� �⥯��� *)
   M4  := M4 + MMM*MMM;              (* ���������� 4-� �⥯��� *)
  INC(polz);
  INC(prom);
 IF (polz>= diskret) THEN
    Use(wt_downhlp);
    TextColor(Red);   GotoXY(x_coord,1); IO.WrChar('�');
    TextColor(White); GotoXY(66,1);
    IF x_coord<= 66
       THEN  IO.WrCard(CARDINAL(REAL(x_coord)/66.*100.),5);
             INC(x_coord);
    END; (* if *)
    polz:= 0;
        IF prom= CARDINAL(computer) (* � �����쪨� 䠩���, ����� �祪 ����� 66 *)
           THEN TextColor(Red);   GotoXY(0,1);  IO.WrCharRep('�',66);
                TextColor(White); GotoXY(66,1); IO.WrCard(100,5);
        END; (* if *)
 END; (* if *)
 END; (* loop *)
(* -- ����⠭�������� 梥� � ���� ���᪠��� ����짮������ ����㭪�� -- *)
  Use(wt_downhlp);
  TextColor(White);
  TextBackground(Brown);
(* ------------------- ���᫥��� ��ᯥ�ᨨ -----------------------  *)
stat[1]:= ABS(M2/LONGREAL(computer) - stat[0]*stat[0]);
(* ------------------- ����e��� ��� -----------------------------  *)
stat[2]:= MATHLIB.Sqrt(stat[1]);
(* ------------------- ���᫥��� ��ᨬ���ਨ ---------------------  *)
stat[3]:=((M3-3.0*stat[0]*M2)/LONGREAL(computer)+
                     (2.0*stat[0]*stat[0]*stat[0]))/(stat[2]*stat[2]*stat[2]) ;
(* ------------------- ���᫥��� ������ ------------------------  *)
(* EKC := ((M4-4.0*MO*M3+6.0*MO*MO*M2)/REAL(kol)-3.0*MO*MO*MO*MO)/REAL(CKO*CKO*CKO*CKO)-3.0;*)
stat[4]:= ((M4-4.0*stat[0]*M3+6.0*stat[0]*stat[0]*M2)/LONGREAL(computer)
          - (3.0*stat[0]*stat[0]*stat[0]*stat[0]))/(stat[2]*stat[2]*stat[2]*stat[2]) - 3. ;
WaitingOff(control_sh);

SetTitle(wt_contain,' ���. �ࠪ���⨪� ',CenterUpperTitle);
Shadow(wt_contain);
PutOnTop(wt_contain);
Clear();
FOR control:= 0 TO 4 DO
 Str.ItemS(substring,contains,'|',INTEGER(control));
 GotoXY(2,INTEGER(control)+2);
 IO.WrStr(substring);
 IO.WrLngReal(stat[control],9,12);
END; (* for *)
lab_end:
FIO.Close(file);
END stat ;

BEGIN
 wt_contain:= Open(wd_contain) ;

END statish.