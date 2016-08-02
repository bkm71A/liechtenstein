MODULE Poln;
IMPORT IO,FIO,Sounds;
VAR
   digit: REAL;
   file:  FIO.File;
BEGIN
file:= FIO.Create('d:\jpi\proba\monstr.dat');

LOOP
 digit:= FIO.RdReal(1);
 IF (NOT FIO.OK) THEN Sounds.Siren;
                      EXIT
 END;
 FIO.WrReal(1,digit,5,5); FIO.WrLn(1);
 FIO.WrBin(file,digit,4);
END; (* loop *)
FIO.Close(file);
END Poln.

