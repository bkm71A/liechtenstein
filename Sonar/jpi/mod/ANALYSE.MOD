

IMPLEMENTATION MODULE Analyse;		(* Lexical analyser *)

FROM FIO IMPORT
  File, RdChar, WrStr, WrLn,		(* Modula-2 File I/O *)
  WrInt, WrChar, Open;
IMPORT IO;				(* Modula-2 Screen I/O *)
FROM SymbolTable IMPORT
  Insert, Lookup, Symtab;
FROM ASCII IMPORT
  nul, lf, cr, sub;

CONST
  BUFFERSIZE = 29;			(* Size of input buffer *)

TYPE
  setofchar = SET OF CHAR;		(* Declare a character base type *)

VAR
  LineNo : INTEGER;			(* Current line number *)
  In : File;				(* Input file *)
  TokenSize : INTEGER;			(* Size of token found *)
  Ident : ARRAY [0..BUFFERSIZE] OF CHAR;(* Declare buffer *)
  UnGetCh : BOOLEAN;			(* Set if the buffer is full *)
  ch : CHAR;				(* One character buffer *)

PROCEDURE Error (str : ARRAY OF CHAR);	(* Called when an error is detected *)
BEGIN
  IO.WrStr  (str);
  IO.WrStr  ('Line: ');
  IO.WrCard (LineNo, 0);
  IO.WrLn;
END Error;

PROCEDURE Lex () : TOKEN;
BEGIN
  LOOP
    IF NOT UnGetCh THEN
      ch := RdChar (In)
    ELSE
      UnGetCh := FALSE;
    END;
    IF ch IN setofchar {'0'..'9'} THEN  (* Token is a Number *)
      tokenval := ORD (ch) - ORD ('0');
      ch := RdChar (In);
      WHILE ch IN setofchar {'0'..'9'} DO
	tokenval := ORD (ch) - ORD ('0') + CARDINAL (tokenval * 10);
	ch := RdChar (In);
      END;
      UnGetCh := TRUE;
      RETURN NUM;
    ELSE
      IF ch IN setofchar {'A'..'Z'} THEN        (* Token is Ident or Keyword *)
	TokenSize := 0;
	REPEAT
	  Ident [TokenSize] := ch;
	  ch := RdChar (In);
	  INC (TokenSize);		(* Increment token size *)
	UNTIL NOT (ch IN setofchar {'A'..'Z', '0'..'9', '_'})
		   OR (TokenSize > BUFFERSIZE);
	IF TokenSize > BUFFERSIZE THEN
	  Error ('Token too large');
	END;
	Ident [TokenSize] := 0C;	(* End of string marker *)
	tokenval := Lookup (Ident);	(* Is it in the symbol table? *)
	IF tokenval = 0 THEN		(* If not add it to the table *)
	(* Tokenval now contains token's position in the symbol table *)
	  tokenval := Insert (Ident, ID, TokenSize);
	END;
	UnGetCh := TRUE;		(* Push current ch onto input *)
	RETURN Symtab [tokenval].t;	(* Return token type *)
      ELSE  (* Special characters *)
	CASE ch OF
	  '(' :
	    RETURN LBRACKET|
	  ')' :
	    RETURN RBRACKET|
	  '*' :
	    RETURN MULT|
	  '/' :
	    RETURN DIVI|
	  '+' :
	    RETURN PLUS|
	  '-' :
	    RETURN MINUS|
	  ';' :
	    RETURN SEMICOLON|
	  '=' :
	    RETURN EQUALS|
	  ':' :
	    IF RdChar (In) # '=' THEN  (* Scan for ':=' *)
	      Error ('Equals expected');
	    ELSE
	      RETURN BECOMES;
	    END|
	  cr :
	    INC (LineNo)|	(* Newline *)
	  nul, lf, ' ' : |      (* Ignore LF, NUL, SPACE chars *)
	  sub :
	    RETURN DONE;	(* EOF found *)
	ELSE
	  Error ('Unknown character');
	END;
      END;
    END;
  END;
END Lex;

BEGIN
  UnGetCh := FALSE;		(* Initially no character in the buffer *)
  LineNo := 1;
  tokenval := Insert ('IF', TIF, 3);            (* Insert keywords *)
  tokenval := Insert ('THEN', TTHEN, 5);        (* in the symbol table *)
  tokenval := Insert ('ELSE', TELSE, 5);
  tokenval := Insert ('ENDIF', TENDIF, 6);
  tokenval := Insert ('REPEAT', TREPEAT, 7);
  tokenval := Insert ('UNTIL', TUNTIL, 6);
  tokenval := Insert ('BEGIN', TBEGIN, 6);
  tokenval := Insert ('END', TEND, 4);
  In := Open ("fred");                          (* Open input file *)
END Analyse.
