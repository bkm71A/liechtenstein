IMPLEMENTATION MODULE SymbolTable;

FROM Storage IMPORT
  ALLOCATE;		(* Procedure to allocate space on the heap *)
FROM Str IMPORT
  Compare, Copy;	(* String manipulation routines *)
FROM Analyse IMPORT
  Error;
FROM Code IMPORT
  Declare;

VAR
  LastEntry : INTEGER;	(* Last entry in the symbol table *)

PROCEDURE Lookup (str : ARRAY OF CHAR) : INTEGER;
(* Searches symbol table for identifier *)
VAR
  index : INTEGER;
BEGIN
  FOR index := 1 TO LastEntry DO
    IF Compare (str, Symtab [index].Entry^) = 0 THEN
      RETURN index;
    END;
  END;
  RETURN 0;
END Lookup;

PROCEDURE Insert (str : ARRAY OF CHAR; tok : TOKEN; Size : INTEGER) : INTEGER;
(* Adds Identifier and token type to symbol table *)
BEGIN
  IF LastEntry = MAXTAB THEN
    Error ('Symbol table full');
  ELSE
    INC (LastEntry);
    Symtab [LastEntry].t := tok;
    ALLOCATE (Symtab [LastEntry].Entry, Size);
    Copy (Symtab [LastEntry].Entry^, str);
    IF tok = ID THEN
      Declare (str);		(* Allocate space for identifier *)
    END;
    RETURN LastEntry;
  END;
END Insert;

BEGIN
  LastEntry := 0;		(* No entries in the Symbol table *)
END SymbolTable.
