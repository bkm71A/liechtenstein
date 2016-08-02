MODULE LIST;
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
    priz    : BOOLEAN ;
LABEL M1 ;
BEGIN
   f:=Open(name) ;
   f1:=Create(name1) ;
   priz := FALSE ;
   LOOP
      simvol:=RdChar(f) ;
      IF EOF THEN  EXIT  END (* IF *) ;
      IF (simvol=CHAR(10))OR(simvol=CHAR(13))OR(simvol=' ')OR(simvol='-')
         THEN
         ELSE
         IF priz THEN priz:=FALSE ; GOTO M1
              ELSE b:=SHORTCARD(BITSET(simvol)*BITSET(90H)) ;
              IF b=90H THEN  a:=SHORTCARD(VAL(SHORTCARD,simvol)) ;
                             a:=a+50H ;
                             simvol:=CHAR(a) ;
                       END ;
              IF b=80H THEN  a:=SHORTCARD(VAL(SHORTCARD,simvol)) ;
                             a:=a+20H ;
                             simvol:=VAL(CHAR,a) ;
                       END ;
         END ; (* IF *)
      IF (simvol='.')OR(simvol='!')OR(simvol='?')OR(simvol='-') THEN priz:=TRUE END  ;
      END (* IF *) ;
M1 :  WrChar(f1,simvol) ;
   END ; (* loop *)
    Close(f) ;
    Close(f1) ;
END LIST.