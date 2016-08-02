MODULE LIST1;
 (******* Программа проставляет коды ВК и ПС в непрерывный файл *****)

FROM FIO    IMPORT Open,Close,Create,WrStr,RdStr,File,EOF,WrLn,RdChar,
                   WrChar,WrCharRep,WrCard   ;
IMPORT IO  ;
CONST
    name    ='e:\bbl\dgein.txt';
    name1   ='e:\bbl\dgein';
VAR a,b,c   : SHORTCARD ;
    simvol  : CHAR ;
    f,f1    : File ;
BEGIN
   f:=Open(name) ;
   f1:=Create(name1) ;
   LOOP
      simvol:=RdChar(f) ;
      IF EOF THEN  EXIT  END (* IF *) ;
      IF (simvol=CHAR(10))OR(simvol=CHAR(13))
         THEN
         ELSE b:=SHORTCARD(BITSET(simvol)*BITSET(0E0H)) ;
              IF b=0E0H THEN  a:=SHORTCARD(VAL(SHORTCARD,simvol)) ;
                             a:=a-50H ;
                             simvol:=CHAR(a) ;
                       END ;
              IF b=0A0H THEN  a:=SHORTCARD(VAL(SHORTCARD,simvol)) ;
                             a:=a-20H ;
                             simvol:=VAL(CHAR,a) ;
                       END ;
      END (* IF *) ;
   WrChar(f1,simvol) ;
   END ; (* loop *)
    Close(f) ;
    Close(f1) ;
END LIST1.