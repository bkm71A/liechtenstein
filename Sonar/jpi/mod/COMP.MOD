MODULE COMP;	(* Main module of the compiler *)

FROM Analyse IMPORT
  Lex, Error, TOKEN, tokenval;
FROM Code IMPORT
  Generate, NextLabel, Loaded, NONE;

VAR
  NextToken : TOKEN;

(* These procedures are used before they are declared *)
PROCEDURE expr; FORWARD;
PROCEDURE statement; FORWARD;

PROCEDURE match (wanted : TOKEN);	(* Move to next token *)
BEGIN
  IF wanted = NextToken THEN		(* If the token is expected *)
    NextToken := Lex ();		(* Read in next token *)
  ELSE
    Error ('Syntax error');             (* Otherwise output an error message *)
  END;
END match;

PROCEDURE term; 			(* Checks terms are well formed *)
VAR
  Temp : INTEGER;	(* Stores unique number for temporary	*)
BEGIN
  CASE NextToken OF  (* Term is one of: 			*)
    LBRACKET :			(* - a bracketted expression	*)
      match (LBRACKET);
      Generate (LBRACKET, NONE);
      expr;
      match (RBRACKET);
      Generate (LBRACKET, NONE)|
    NUM :			(* - a number			*)
      Generate (NUM, tokenval);
      match (NUM)|
    ID :			(* - an identifier		*)
      Generate (ID, tokenval);
      match (ID)|
  ELSE
    Error ('Syntax error');
  END;
END term;

PROCEDURE expr; 		(* Parses expressions	*)
VAR
  LastToken : TOKEN;
(* An expression is a term followed by zero or more	*)
(* repetitions of an operator followed by a term	*)
BEGIN
  Loaded := FALSE;		(* Register has to be loaded	*)
  term; 			(* Match a term 		*)
  LOOP				(* followed by zero or more	*)
    CASE NextToken OF		(* repetitions of		*)
      PLUS, MINUS, DIVI,	(* Operator			*)
      MULT, EQUALS :
	LastToken := NextToken;
	match (NextToken);
	term;			(* followed by term		*)
	(* Generate code for OP after term			*)
	Generate (LastToken, NONE)|
    ELSE
	RETURN; 		(* End of expression		*)
    END;
  END;
END expr;

PROCEDURE ParseIF;
VAR
  Out, Endif : INTEGER;
BEGIN
  match (TIF);			(* Find IF *)
  expr; 			(* Parse the expression *)
  Out := NextLabel;		(* Get a unique label *)
  INC (NextLabel);
  Generate (GOFALSE, Out);	(* Goto it if the result is fales *)
  match (TTHEN);
  statement;			(* Parse a statement *)
  IF NextToken = TELSE THEN	(* If there is an ELSE clause *)
    match (TELSE);
    Endif := NextLabel; 	(* Get another label *)
    INC (NextLabel);
    Generate (TGOTO, Endif);	(* Place a GOTO to the end of the IF *)
    Generate (TLABEL, Out);	(* Target label for false result *)
    statement;
    Generate (TLABEL, Endif);	(* Generate label for end of IF *)
  ELSE				(* No ELSE part *)
    Generate (TLABEL, Out);	(* Generate label for false result *)
  END;
  match (TENDIF);
END ParseIF;

PROCEDURE ParseREPEAT;
VAR
  Start : INTEGER;
BEGIN
  match (TREPEAT);
  Start := NextLabel;	(* Generate label for start of loop *)
  INC (NextLabel);
  Generate (TLABEL, Start);
  REPEAT
    statement;			(* Parse statement *)
  UNTIL (NextToken = TUNTIL) OR (NextToken = DONE);
  match (TUNTIL);
  expr; 			(* Parse expression *)
  Generate (GOFALSE, Start);	(* Generate GOTO start of loop *)
END ParseREPEAT;

PROCEDURE ParseASSIGN;
VAR
  Tmp : INTEGER;
BEGIN
  Tmp := tokenval;		(* Store identifier *)
  match (ID);
  match (BECOMES);
  expr; 			(* Parse expression *)
  Generate (ID, Tmp);		(* Generate code for the assignment *)
  Generate (BECOMES, NONE);
END ParseASSIGN;

PROCEDURE statement;
BEGIN
  CASE NextToken OF
    TIF :
      ParseIF|
    TREPEAT :
      ParseREPEAT|
    ID :
      ParseASSIGN;
  END;
  match (SEMICOLON);		(* All statements are terminated with a ';' *)
END statement;

PROCEDURE parse;
BEGIN
  NextToken := Lex ();
  match (TBEGIN);
  WHILE ((NextToken # DONE) AND (NextToken # TEND)) DO
    statement;
  END;
  match (TEND);
END parse;

BEGIN
  parse;
END COMP.
