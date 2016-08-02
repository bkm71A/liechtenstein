IMPLEMENTATION MODULE I24_Grap ;

         IMPORT FIO,Graph,SYSTEM,AsmLib ;
         IMPORT FILE,mouse,Etiketka ;
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

(*$C 00,N*) PROCEDURE (*$F*) ForceSave(p : CARDINAL) : CARDINAL; FORWARD;
(*$C F0,F*)

(*$C FF*)
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
BEGIN
     RegP1 := [SYSTEM.Seg( Dummy ):ForceSave(0)+2]; (* must be first in procedure *)
     saveipf := AsmLib.GetInProgramFlag() ;
     AsmLib.SetInProgramFlag( TRUE );

     Etiketka.Error(80H+RegP1^.DI) ;

     PopStack := PopStackProc(ADR(PopStackCode)) ;
     PopStack(Dummy);
     AsmLib.SetInProgramFlag( saveipf );
END Int24Handler;
(*$C F0*)

PROCEDURE ForceSave( p : CARDINAL): CARDINAL;
BEGIN
  RETURN SYSTEM.Ofs( p );
END ForceSave;

VAR
  Int24Vec[0:24H*4] : PROCEDURE (CARDINAL) ; (* завершение по фатальной ошибке *)
BEGIN
  SYSTEM.DI ;
   Int24Vec := Int24Handler ;
  SYSTEM.EI ;

END I24_Grap.
