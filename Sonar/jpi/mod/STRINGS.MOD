(*$V-*)

IMPLEMENTATION MODULE Strings;

(* Core library interface for Str *)

PROCEDURE Assign ( source : ARRAY OF CHAR ;
                   VAR dest : ARRAY OF CHAR ) ;
BEGIN
  Str.Copy(dest,source) ;
END Assign ;

PROCEDURE Insert ( substr : ARRAY OF CHAR;
                   VAR str : ARRAY OF CHAR ;
                   inx : CARDINAL ) ;
BEGIN
  Str.Insert ( str,substr,inx ) ;
END Insert ;

PROCEDURE Pos    ( substr : ARRAY OF CHAR;
                   VAR str : ARRAY OF CHAR ) : CARDINAL ;
BEGIN
  RETURN Str.Pos(str,substr) ;
END Pos ;

PROCEDURE Copy   ( str : ARRAY OF CHAR ;
                   inx : CARDINAL ;
                   len : CARDINAL ;
                   VAR result : ARRAY OF CHAR ) ;
BEGIN
  Str.Slice(result,str,inx,len) ;
END Copy ;

PROCEDURE Concat ( s1,s2 : ARRAY OF CHAR ;
                   VAR result : ARRAY OF CHAR ) ;
BEGIN
  Str.Concat (result,s1,s2) ;
END Concat ;

END Strings.
