IMPLEMENTATION MODULE Code;	(* Module contains the code generator *)

FROM FIO IMPORT
  File, RdChar, WrStr, WrLn,	(* Modula-2 file I/O *)
  WrInt, WrChar, Create;
FROM SymbolTable IMPORT
  Symtab;			(* To access identifiers *)

VAR
  Out : File;			(* Output file *)
  Last : RECORD 		(* Last token  *)
	   Tok : TOKEN;
	   Value : INTEGER;
	 END;
  FreeSpace : CARDINAL; 	(* Marks free space data area *)
  POPPED : BOOLEAN;		(* Last op was a POP *)

PROCEDURE Declare (s : ARRAY OF CHAR);	(* Allocate space for variables *)
BEGIN
  WrStr (Out, s);
  WrStr (Out, " EQ ");
  WrInt (Out, FreeSpace, 0);
  WrLn (Out);
  FreeSpace := FreeSpace + 2;	(* Assuming byte addressing *)
END Declare;

PROCEDURE PrintOp (Operator : ARRAY OF CHAR);	(* Print Operator *)
BEGIN
  WrStr (Out, Operator);
  IF POPPED THEN
    WrStr (Out, ' _TMP');       (* Last op was a pop so load from TMP *)
    POPPED := FALSE;
  ELSE
    IF Last.Tok = NUM THEN
      WrInt (Out, Last.Value, 0);		(* A litteral *)
    ELSE
      WrStr (Out, Symtab [Last.Value].Entry^);	(* A memory location *)
    END;
  END;
  WrLn (Out);
END PrintOp;

PROCEDURE PrintLabel (X : INTEGER);
BEGIN
  WrChar (Out, 'L');
  WrInt (Out, X, 0);
  WrChar (Out, ':');
  WrLn (Out);
END PrintLabel;

PROCEDURE Generate (Tok : TOKEN; Value : INTEGER);
(* Generates code for each construct in a simple pseudo-assembler. *)
(* All operations are of the form: [LABEL:] OPERATOR OPERAND	   *)
BEGIN
  CASE Tok OF
    PLUS :
      PrintOp (' ADD ')|
    MINUS :
      PrintOp (' SUB ')|
    MULT :
      PrintOp (' MUL ')|
    DIVI :
      PrintOp (' DIV ')|
    BECOMES :
      PrintOp (' STORE ')|
    EQUALS :
      PrintOp (' XOR ')|
    LBRACKET :
      WrStr (Out, ' PUSH ');
      WrLn (Out)|
    RBRACKET :
      WrStr (Out, ' POP  _TMP');
      WrLn (Out);
      POPPED := TRUE|
    ID :
      IF NOT Loaded THEN       (* Start of expression *)
	WrStr (Out, ' LOAD ');
	WrStr (Out, Symtab [Value].Entry^);
	WrLn (Out);
      END|
    NUM :
      IF NOT Loaded THEN       (* Start of expression *)
	WrStr (Out, ' LOAD ');
	WrInt (Out, Value, 0);
	WrLn (Out);
      END|
    TLABEL :
      PrintLabel (Value)|
    GOFALSE :
      WrStr (Out, 'JNZ ');
      PrintLabel (Value)|
    TGOTO :
      WrStr (Out, 'JMP ');
      PrintLabel (Value)|
  ELSE;
    (* If you don't know what it is, don't translate it! *)
  END;
  Last.Tok := Tok;		(* Store token and value     *)
  Last.Value := Value;
  Loaded := TRUE;		(* Register is loaded now    *)
END Generate;

BEGIN
  Out := Create ('Out');        (* Open new output file      *)
  FreeSpace := 1000;		(* Start of Data area	     *)
  Declare ('_TMP');             (* Declare temporary storage *)
  NextLabel := 1;		(* Set first label's value   *)
  Loaded := FALSE;		(* Accumulator is not loaded *)
END Code.
