IMPLEMENTATION MODULE _Int24; (* ��ࠡ�⪠ ��� ��ࠡ��稪�� �訡�� INT24H *)

IMPORT SYSTEM,AsmLib,Str,IO;

(* -------------------------- My addition -------------------------- *)

FROM Lib      IMPORT  Dos;
FROM Window   IMPORT  WinDef,WinType,Open,Close,GotoXY,Use,Color,TextColor,
                      SingleFrame;
FROM _Window  IMPORT  Open_Shadow,Close_Shadow;
FROM Probr_lb IMPORT  Soundock;

(*
   The pop stack inline code is required if the program should
   continue after an abort (returning 255 to the calling program).
   If ContinueProg is set to FALSE then the program will terminate
   on 'abort' ;
*)

CONST
  ContinueProg = TRUE ;

TYPE
  Code = ARRAY[0..27] OF SHORTCARD ;
CONST
PopStackCode = Code(
 58H,             (* POP    AX    *)
 58H,             (* POP    AX    *)
 58H,             (* POP    AX    *)
 5BH,             (* POP    BX    *)
 89H,0C4H,        (* MOV    SP,AX *)
 9DH,             (* POPF         *)
 58H,             (* POP    AX    *)
 5BH,             (* POP    BX    *)
 59H,             (* POP    CX    *)
 5AH,             (* POP    DX    *)
 5EH,             (* POP    SI    *)
 5FH,             (* POP    DI    *)
 58H,             (* POP    AX    *)
 1FH,             (* POP    DS    *)
 07H,             (* POP    ES    *)
 89H,0E5H,        (* MOV    BP,SP *)
 80H,4EH,04H,01H, (* OR     Byte Ptr [BP+04],01 ; set carry *)
 89H,0C5H,        (* MOV    BP,AX *)
 0B8H,0FFH,00H,   (* MOV    AX,00FF *)  (* Return error *)
 0CFH) ;          (* IRET         *)

TYPE PopStackProc = PROCEDURE ( VAR CARDINAL ) ;

(*$C 00,N*) PROCEDURE (*$F*) ForceSave(p : CARDINAL) : CARDINAL; FORWARD; (*$C F0,F*)

(* NB! Has to be forward otherwise compiler will spot that
       registers are not being used
*)

(*$C FF,J+*)
PROCEDURE Int24Handler( Dummy : CARDINAL );

TYPE IntReg1 = RECORD
                 DI,SI,ES,DS : CARDINAL;
                 CASE : BOOLEAN OF
                   TRUE  : BX,DX,CX,AX : CARDINAL; |
                   FALSE : BL,BH,DL,DH,CL,CH,AL,AH : SHORTCARD;
                 END;
               END;
VAR
    RegP1 : POINTER TO IntReg1;
    PopStack : PopStackProc ;
    saveipf : BOOLEAN ;
    s : ARRAY[0..45] OF CHAR ;
    k : CHAR ;
(* ------------------------------ My addition ------------------------------ *)
VAR
    wt_error: WinType;
    wd_error: WinDef;
    shad:     CARDINAL;
    r:        SYSTEM.Registers;
BEGIN
     RegP1 := [SYSTEM.Seg( Dummy ):ForceSave(0)+2]; (* must be first in procedure *)
     saveipf := AsmLib.GetInProgramFlag() ;
     AsmLib.SetInProgramFlag( TRUE );
     WITH RegP1^ DO
(* ------------------------------ My addition ------------------------------ *)
      r.AH:= 59H;
      r.BX:= 0H;
      Dos(r);
      CASE CARDINAL(r.AX) OF
                 1: s := '������ ����� �㭪樨'
                |2: s := '���� �� ������'
                |3: s := '���� �� ������'
                |4: s := '���誮� ����� ������� 䠩���'
                |5: s := '����� �⢥࣭��'
                |6: s := '������ ����⥫�'
                |7: s := '�����襭� ����� �ࠢ����� �������'
                |8: s := '�������筮 �����'
                |9: s := '������ ���� ����� �����'
               |10: s := '����୮� ���㦥���'
               |11: s := '������ �ଠ�'
               |12: s := '������ ��� ����㯠'
               |13: s := '����ୠ� ���'
               |14: s := '?????????????'
               |15: s := '����� ������ ���'
               |16: s := '����� 㤠���� ⥪ ����������'
               |17: s := '�� � �� ᠬ�� ���ன�⢮'
               |18: s := '����� ��� �᪮��� 䠩���'
               |19: s := '����⪠ ����� �� ���饭�� ���'
               |20: s := '��������� ID �����ன�⢠'
               |21: s := '��᪮��� �� ��⮢'
               |22: s := '�������⭠� �������'
               |23: s := '�訡�� ������ ��᪠ (�訡�� CRC)'
               |24: s := '����ୠ� ������ �������� �����'
               |25: s := '�訡�� ���᪠ �� ��᪥'
               |26: s := '��������� ⨯ ���⥫� ��᪠'
               |27: s := '����� �� ������'
               |28: s := '����� �㬠�� �� �ਭ��'
               |29: s := '�訡�� �����'
               |30: s := '�訡�� �⥭��'
               |31: s := '���� �訡��'
               |32: s := '����襭�� ࠧ������� 䠩���'
               |33: s := '����襭�� �����஢�� 䠩��'
               |34: s := '����ୠ� ������ ��᪠'
               |35: s := 'FCB ������㯥� (᫨誮� ����� ������� FCB)'
               |80: s := '���� 㦥 �������'
      END; (* case *)
         wd_error:= WinDef(15,8,65,14,White,Red,FALSE,FALSE,FALSE,TRUE,SingleFrame,White,Red);
         wt_error:= Open(wd_error);
         shad:= Open_Shadow(wt_error);
         Use(wt_error);
           GotoXY(25 - Str.Length(s) DIV 2,3);  IO.WrStr(s);
           GotoXY(2,5);  IO.WrStr('[A]');
           GotoXY(17,5); IO.WrStr('[R]');
           GotoXY(33,5); IO.WrStr('[I]');
         TextColor(Yellow);
           GotoXY(20,1); IO.WrStr('� � � � � � !');
         TextColor(Black);
           GotoXY(6,5);  IO.WrStr('�⬥����');
           GotoXY(21,5); IO.WrStr('�������');
           GotoXY(37,5); IO.WrStr('�����஢���');
         Soundock();

        REPEAT
          k := CAP(IO.RdKey()) ;
        UNTIL (k='R') OR (k='I') OR (k='A');

(* ------------------------------ My addition ------------------------------ *)
        Close(wt_error);
        Close_Shadow(shad);

        IF k='I'    THEN AL := 0 ;  (* ignore *)
        ELSIF k='R' THEN AL := 1 ;  (* retry  *)
        ELSE                        (* abort  *)
           IF ContinueProg THEN
             PopStack := PopStackProc(ADR(PopStackCode)) ;
             PopStack(Dummy);
             (* Remove MSDOS call frame and Return 255 to caller *)
             (* Does not return here *)
           ELSE
             HALT ;
           END ;
        END ;
     END;
     AsmLib.SetInProgramFlag( saveipf ); (* returning to DOS *)
END Int24Handler;
(*$C F0,J-*)

PROCEDURE ForceSave( p : CARDINAL): CARDINAL;
BEGIN
  RETURN SYSTEM.Ofs( p );
END ForceSave;

VAR
  Int24Vec[0:24H*4]   : PROCEDURE ( CARDINAL ) ;

BEGIN
  SYSTEM.DI ;
  (* Install interrupt 24 *)
  Int24Vec := Int24Handler ;
  SYSTEM.EI ;
END _Int24.
