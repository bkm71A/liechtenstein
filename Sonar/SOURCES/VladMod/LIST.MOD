MODULE LIST;
 (******* Программа проставляет коды ВК и ПС в непрерывный файл *****)

FROM Window IMPORT Clear,Color,TextColor ;
FROM FIO    IMPORT Open,Close,Create,WrStr,RdStr,File,EOF,WrLn,
                   WrChar,WrCharRep,WrCard   ;
IMPORT IO  ;
VAR a,b,i,f : CARDINAL ;
    in,out  : File ;
    STR     : ARRAY[1..256] OF CHAR ;
    screen  : ARRAY[1..256] OF CHAR ;
LABEL MM ;

BEGIN
     Clear ;
     IO.WrStr(' Введите полное имя файла для преобразования ') ;
     IO.RdItem(screen) ;
     f:=1 ;
     LOOP
     IF screen[f]=CHAR(0) THEN EXIT
                          ELSE INC(f)
                          END ;
     END ;
     DEC(f) ;
     in:=Open(screen) ;
     IF f<3 THEN IO.WrStr(' Правильно введите полное имя файла !') ; IO.WrLn ;
                 HALT  END ;
     screen[f-2]:='B' ;
     out:=Create(screen) ;
     IO.WrStr(' Преобразованным будет файл с именем  -      ') ;
     IO.WrStr(screen) ;
     IO.WrLn ; IO.WrLn ;
     IO.WrStr('   С какого номера начинать отсчет страниц ? ') ; IO.WrLn ;
     IO.WrStr(' Будьте внимательны. Контроль не производится. ') ;
     a:=IO.RdCard() ;   IO.WrLn ; f:=a ;

LOOP
     WrCharRep(out,' ',30) ; WrChar(out,'-') ; WrCard(out,a,4) ;
     WrChar(out,' ') ; WrChar(out,'-') ;   WrLn(out) ;
     FOR i:=1 TO 56 DO                   (* кол-во строк в странице *)
          RdStr(in,STR) ;
          b:=1 ;
          LOOP
          IF STR[b]=CHAR(0) THEN EXIT END ;
          IF STR[b]=CHAR(0CH) THEN GOTO MM   ;
                              ELSE INC(b)
                              END ;
          END ;
          IF EOF THEN EXIT END ;
          WrStr(out,STR) ;
          WrLn(out) ;
     END ;
MM:  WrChar(out,CHAR(0CH)) ;
     INC(a) ;
END ; (* loop *)
WrStr(out,STR) ;
Close(in) ;
Close(out) ;
IO.WrStr(' В файле страниц -') ;
f:=a-f ; IO.WrCard(f,5) ;
END LIST.