MODULE POISK ;



PROCEDURE Poisk_file  ;
 VAR x,y,z,l,k,n : CARDINAL ;
     atrib   : FIO.FileAttr ;
     Imja    : ARRAY[1..3],[1..6] OF CHAR ;
     spisok  : ARRAY[1..255],[1..13] OF CHAR ;
     Aaa,Bbb,VoprT,NewImT : WinType ;
     AA,BB,VoprD,NewImD   : WinDef ;
LABEL M1,M3 ;

PROCEDURE  PPPPP(tt:CARDINAL): BOOLEAN  ;
VAR  ii : CARDINAL ;
     pr : BOOLEAN  ;
BEGIN
ADDR:=AddAddr(ADR(otvet),30) ;

ii:=1 ;
pr:=FALSE ;
LOOP
    OT:= ADDR^ ;
    IF OT=CHAR(0) THEN EXIT END ;
    spisok[tt,ii]:=OT ;
    IncAddr(ADDR,1)  ;
    INC(ii) ;
END ;
IF otvet.attr=FIO.FileAttr{FIO.directory}
          THEN spisok[tt,ii]:='\' ; spisok[tt,ii+1]:=OT ; RETURN TRUE
          ELSE spisok[tt,ii]:=OT ; RETURN FALSE END ;
END PPPPP ;

PROCEDURE POISK_DIR ;
VAR dir : BOOLEAN ;
BEGIN
    Put[z]:='*' ; Put[z+1]:='.' ;  Put[z+2]:='*' ; Put[z+3]:=CHAR(0) ;
    IF FIO.ReadFirstEntry(Put,FIO.FileAttr{FIO.directory},otvet)
                     THEN  INC(i) ; dir:=PPPPP(i) ;
                           IF NOT(dir) THEN DEC(i) END ;
                           LOOP
                              IF NOT(FIO.ReadNextEntry(otvet)) THEN EXIT END ;
                              INC(i) ; dir:=PPPPP(i) ;
                              IF NOT(dir) THEN DEC(i) END ;
                           END ; (*   loop   *)
                       END ;  (*  if  *)
      Put[z]:=CHAR(0) ;
END POISK_DIR;

PROCEDURE POISK_FILE ;
VAR dir : BOOLEAN ;
BEGIN
   IF FIO.ReadFirstEntry(Put,FIO.FileAttr{FIO.directory,FIO.archive},otvet)
                    THEN INC(i) ; dir:=PPPPP(i) ;
                         IF dir THEN DEC(i) END ;
                         LOOP
                            IF NOT(FIO.ReadNextEntry(otvet)) THEN EXIT END ;
                            INC(i) ; dir:=PPPPP(i) ;
                            IF dir THEN DEC(i) END ;
                         END ; (*   loop   *)
                     END ;  (*  if  *)
END POISK_FILE;

PROCEDURE Sozdanie ;
VAR kkk : FIO.File  ;
    WinErrD : WinDef ;
    WinErrT : WinType ;
    Res : CARDINAL ;
    WARN : BOOLEAN ;
LABEL Nazad ;

PROCEDURE Warning() : BOOLEAN ;
VAR warnD : WinDef  ;
    warnT : WinType ;
BEGIN
warnD:=WinDef(14,10,64,16,White,Red,FALSE,TRUE,FALSE,TRUE,DoubleFrame,Black,Red) ;
warnT:=Open(warnD) ;
GotoXY(7,2) ; WrStr('���� � ⠪�� ������ 㦥 ������� !') ;
GotoXY(1,4) ; WrStr('�᫨ Enter, � ���ଠ�� � 䠩�� �㤥� ����ﭠ.') ;
TextColor(Yellow) ;
GotoXY(7,3) ; WrStr('Esc - �⬥���� ; Enter - �த������') ;
OT:=RdCharDirect() ;
Close(warnT) ;
LOOP
CASE OT OF CHAR(13) : OT:='Y' ; RETURN FALSE
         | CHAR(27) : OT:='N' ; RETURN TRUE
                END ;
END ; (* loop *)
END Warning;

BEGIN

     (*******  ����  ��� �뤠� �訡�� �� �६� ᮧ����� 䠩��   ********)
 WinErrD:=WinDef(10,8,60,13,LightRed,Red,FALSE,TRUE,FALSE,TRUE,DoubleFrame,White,Red) ;
        i:=Str.Length(Put) ;
        NewImD.X2:=NewImD.X1+i+14 ;
        NewImT:=Open(NewImD) ;
        WrStr(Put) ;
Nazad : LOOP
           OT:=RdCharDirect() ;
           CASE OT OF CHAR(0) : OT:=RdCharDirect() ; GOTO Nazad
                  | CHAR(0DH) : EXIT
                  | CHAR(27)  : Close(NewImT) ; OT:='N' ; RETURN
                  | CHAR(8)   : IF i>=1 THEN Put[i]:=CHAR(0) ;
                                             i:=Str.Length(Put) ;
                                             Clear ; WrStr(Put) ;
                                         END ;
           END ; (*  case  *)
           IF (VAL(SHORTCARD,OT)>0)AND(VAL(SHORTCARD,OT)<=(20H)) THEN GOTO Nazad END ;
           INC(i) ;
           Put[i]:=OT ;
           WrChar(OT) ;
       END ; (* loop *)
       Put[i+1]:=CHAR(0) ;
       Close(NewImT) ;
       IF (Put[i]='\')OR(Put[i]=':')OR(i=0) THEN OT:='N' ; RETURN END ;

   (*    IF FIO.Exists(Put) THEN IF Warning() THEN RETURN END END ;*)

       kkk:=FIO.Create(Put) ;
       IF FIO.IOcheck  THEN OT:='N' ; RETURN
                       ELSE Res:=FIO.IOresult()  ;
                            WrCard(Res,5) ;
                           (* IF Res=0 THEN (* OT:='Y' ; RETURN ;*)
                                     ELSE WinErrT:=Open(WinErrD) ; *)
  WrStr('��� ���������� ᮧ���� 䠩� �� ⠪��� ��������. ��� ������ DOS') ;
  GotoXY(1,3) ;  WrStr('����� ���㬥���� �� MS DOS � �㤥� ����� ��稭� �⪠�� ��⥬� �믮����� ��� �ਪ��') ;
  GotoXY(22,2) ; WrStr('ࠢ��') ; TextColor(Yellow) ;
  GotoXY(10,4) ; WrStr('��� �த������� ࠡ��� ������ ���� �������') ;
                                         OT:=RdCharDirect() ; OT:='N' ;
(*                                     END                             *)
                        END ;
(*Use(Aaa) ; WrStr('�㩭� !!!! ') ;
       IF kkk=MAX(CARDINAL) THEN OT:='N'
                            ELSE OT:='Y' ; FIO.Close(kkk) END ;*)
END Sozdanie ;

PROCEDURE GETDIR ;
BEGIN
    FIO.GetDir(r.AL+1,Put) ;
    FOR x:=1 TO 3 DO
    FOR y:=(SIZE(Put)-1) TO 2 BY -1 DO
                    Put[y]:=Put[y-1] ;
                    IF Put[y]=CHAR(0) THEN z:=y END ;
    END ;    (*  for  *)
    END ;    (*  for  *)
    Put[1]:=TecDisk ;
    Put[2]:=':' ;
    Put[3]:='\' ;
    IF z<=3 THEN z:=4 END ;
    IF Put[z-1]='\' THEN Put[z]:=CHAR(0)
                    ELSE Put[z]:='\' ; Put[z+1]:=CHAR(0) ; INC(z) END ;
END GETDIR ;

BEGIN
     (*******  ����  ��� ��ᬮ�� 䠩��� � ��⠫���  ********)
 AA:=WinDef(32,2,60,19,Red,LightGray,FALSE,TRUE,FALSE,TRUE,DoubleFrame,White,LightGray) ;

     (**  ��६���饥�� ���� ��� �롮� 䠩��, ����� ����室��� ������� **)
 BB:=WinDef(33,3,45,3,LightCyan,Blue,FALSE,TRUE,FALSE,FALSE,' ',White,Blue) ;

     (**  ���� ��� �����, ����� 䠩� ����室��� �᪠�� ��� ᮧ������ **)
 VoprD:=WinDef(28,6,50,8,DarkGray,Cyan,FALSE,TRUE,FALSE,TRUE,SingleFrame,White,Cyan) ;

     (*********  ���� ��� ��।������ ����� ᮧ��������� 䠩�� **********)
 NewImD:=WinDef(30,7,0,9,LightCyan,Blue,TRUE,TRUE,FALSE,TRUE,DoubleFrame,White,Blue) ;

 Imja[1]:='*.*   ' ;  Imja[1,4]:=CHAR(0) ;
 Imja[2]:='*.dat ' ;  Imja[2,6]:=CHAR(0) ;
 Imja[3]:='���� '  ; Imja[3,6]:=CHAR(0) ;

 FOR y:=(SIZE(Put)-1) TO 2 BY -1 DO
                    IF Put[y]=CHAR(0) THEN z:=y END ;
 END ;    (*  for  *)

 VoprT:=Open(VoprD) ;
 n:=1 ;
 LOOP
      FOR i:=1 TO 3 DO IF n=i THEN TextColor(LightCyan) ; TextBackground(Blue)
                              ELSE TextColor(DarkGray) ; TextBackground(Cyan) END ;
                       GotoXY(((i-1)*8),1) ; WrStr(Imja[i]) END ;
      OT:=RdCharDirect() ;
      CASE OT OF CHAR(75) :  IF n>1 THEN DEC(n)
                                    ELSE n:=3   END
               | CHAR(77) :  IF n<3 THEN INC(n)
                                    ELSE n:=1   END
               | CHAR(0DH):  CASE n OF 1 :
                                    |  2 :
                                    |  3 : GETDIR ;
                                           Sozdanie ;
                                         IF OT='Y' THEN prizfile:=TRUE
                                                   ELSE prizfile:=FALSE END ;
                                         Close(VoprT) ;
                                         RETURN
                             END ; (* CASE *)
                             EXIT
      END ;
 END ; (* loop *)
 Close(VoprT) ;

    Aaa:=Open(AA) ;
M3: GETDIR ;
    i:=0 ; (********* ��।���� ������⢮ �������� 䠩��� ***********)
    POISK_DIR ;  (******   �����⢫�� ���� ��ਪ�ਥ�
                           ��������� ������쭠� i ******)
    y:=1 ;
    LOOP
         Put[z]:=Imja[n,y] ;
         IF Imja[n,y]=CHAR(0) THEN EXIT END ;
         INC(y) ;    INC(z) ;
    END ; (* loop *)
    SetTitle(Aaa,Put,CenterUpperTitle) ;

    POISK_FILE ;
    z:=i ;

 i:=1  ; (* i - ⥪�騩 䠩� ; z - ������⢮ 䠩��� � ⥪�饬 ��४�ਨ  *)
 x:=3  ; (* x - ���न��� �� Y ��砫� ��ப� ����饣� ����  *)
 j:=33 ; (* j - ��砫쭠� ���न��� �� � ����饣� ����      *)

 M1: Use(Aaa) ;
     Clear ;
     l:=1 ;
     LOOP  (* ��襬 ����� ����� 䠩��� ⥪�饣� ��४���  *)
         IF (l>32)OR(l>z) THEN EXIT END ;
         IF l>16 THEN  GotoXY(15,l-16)
                 ELSE  GotoXY(1,l)     END ;
         WrStr(spisok[l+i-1]) ;
         INC(l) ;
    END ; (* loop *)

 LOOP
    BB.Y1:=x ; BB.Y2:=x ;
    BB.X1:=j ; BB.X2:=BB.X1+12 ;
        (*********** ��� � ��६���饬�� ���� ***************)
    Bbb:=Open(BB) ;
    IF j=33 THEN WrStr(spisok[i+x-3])
            ELSE WrStr(spisok[i+x+13]) END ;

    OT:=RdCharDirect() ;
    CASE OT OF
                                            (* ����� *)
      CHAR(72) : IF (x<=3)AND(j=47) THEN x:=19 ; j:=33 END ;
                 IF (x<=3)AND(j=33) THEN IF i>1 THEN DEC(i) ; Hide(Bbb) ; GOTO M1 END
                                    ELSE DEC(x)
                                     END
   |  CHAR(80) : INC(x) ;                   (* ����  *)
                 CASE j OF 33 : IF (x-3+i)>z  THEN DEC(x)
                                              ELSE IF x>18 THEN x:=3 ; j:=47 END
                                              END
                         | 47 : IF (x+13+i)>z THEN DEC(x)
                                              ELSE IF x>18 THEN DEC(x) ;
                                                                INC(i) ; Hide(Bbb) ;
                                                                GOTO M1
                                                            END
                                               END ;
                          END ; (* CASE *)
   |  CHAR(27) : prizfile:=FALSE ; GETDIR ;
                 Close(Bbb) ;  Close(Aaa) ; RETURN
   |  CHAR(75) : IF j#33  THEN j:=33 END
   |  CHAR(77) : IF (j#47)AND(x+12+i<z) THEN j:=47 END
   |  CHAR(13) : EXIT
    END ;  (* CASE *)
    Hide(Bbb) ;
END ;  (*loop*)

    IF j=33 THEN k:=i+x-3
            ELSE k:=i+x+13 END ;
   j:=1 ;
   LOOP IF Put[j]=CHAR(0) THEN FOR x:=j TO 2 BY -1 DO
                                    IF Put[x]='\' THEN EXIT END ;
                               END ;
                           END ;
        INC(j) ;
   END ; (* loop *)
   l:=1 ;  INC(x) ;
   LOOP
        Put[x]:=spisok[k,l] ;
        IF Put[x]=CHAR(0) THEN EXIT END ;
        INC(x) ; INC(l) ;
   END ; (* loop *)
   Hide(Bbb) ;
   IF (Put[x-1]='\') THEN z:=x-1 ; Put[x-1]:=CHAR(0) ;
                          FIO.ChDir(Put) ; GOTO M3  END ;
   IF (Put[x-1]='.')AND(Put[x-2]='.') THEN FIO.ChDir(Put) ; GOTO M3 END ;

  prizfile:=TRUE ;
  Close(Bbb) ;
  Close(Aaa) ;
END Poisk_file ;

