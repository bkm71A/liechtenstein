MODULE LIST;
 (******* �ணࠬ�� ���⠢��� ���� �� � �� � �����뢭� 䠩� *****)

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
     IO.WrStr(' ������ ������ ��� 䠩�� ��� �८�ࠧ������ ') ;
     IO.RdItem(screen) ;
     f:=1 ;
     LOOP
     IF screen[f]=CHAR(0) THEN EXIT
                          ELSE INC(f)
                          END ;
     END ;
     DEC(f) ;
     in:=Open(screen) ;
     IF f<3 THEN IO.WrStr(' �ࠢ��쭮 ������ ������ ��� 䠩�� !') ; IO.WrLn ;
                 HALT  END ;
     screen[f-2]:='B' ;
     out:=Create(screen) ;
     IO.WrStr(' �८�ࠧ������ �㤥� 䠩� � ������  -      ') ;
     IO.WrStr(screen) ;
     IO.WrLn ; IO.WrLn ;
     IO.WrStr('   � ������ ����� ��稭��� ����� ��࠭�� ? ') ; IO.WrLn ;
     IO.WrStr(' ���� �����⥫��. ����஫� �� �ந��������. ') ;
     a:=IO.RdCard() ;   IO.WrLn ; f:=a ;

LOOP
     WrCharRep(out,' ',30) ; WrChar(out,'-') ; WrCard(out,a,4) ;
     WrChar(out,' ') ; WrChar(out,'-') ;   WrLn(out) ;
     FOR i:=1 TO 56 DO                   (* ���-�� ��ப � ��࠭�� *)
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
IO.WrStr(' � 䠩�� ��࠭�� -') ;
f:=a-f ; IO.WrCard(f,5) ;
END LIST.