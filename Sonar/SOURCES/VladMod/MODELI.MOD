MODULE modeli;

IMPORT FIO,IO,Str;
FROM Lib     IMPORT RANDOM,RAND,RANDOMIZE;
FROM MATHLIB IMPORT Sin,Pow;

VAR
  schet:          CARDINAL;
  file_name       : ARRAY [0..79] OF CHAR;
  substring       : ARRAY [0..12] OF CHAR;
  file            : FIO.File;
  control         : CARDINAL;
  digit,delta,del : REAL;
  digit1,digit2,digit3,digit4,digit5,digit6,digit7,
  digit15,digit16,digit17,digit18,digit19,digit20,digit21,
  digit22,digit23,digit24,digit25,
  
  digit8,digit9,digit10,digit11,digit12,digit13,digit14 : REAL;
  buf             : ARRAY[0..2047+FIO.BufferOverhead] OF BYTE ;
  priznak         : CARDINAL ;

(* ��६���� ��� �⨪�⪨ *)
    index        : CARDINAL;
    data         : ARRAY [1..8] OF CHAR ; (* ��� ��ᯥਬ��� *)
    objekt       : ARRAY [1..4] OF CHAR ; (* ��ꥪ� *)
    tbegin       : REAL ;   (* �६� ��砫� ���⪠ ����� *)
    tend         : REAL ;   (* �६� ���� ���⪠ ����� *)
    chastota     : REAL ;   (* ���� ����⨧�樨 *)
    computer     : LONGCARD ; (* ������⢮ �祪 ॠ����樨 *)
    prore        : CARDINAL ; (* ��०������ *)
    ident        : ARRAY [0..2] OF CHAR ; (* �����䨪��� 䠩�� ��ࠡ�⪨ *)
    min          : REAL ; (* ������  *)
    max          : REAL ; (* ���ᨬ� *)
    mo           : REAL ; (* ��⮦������ *)
    obr          : CARDINAL ; (* 2 ���� ��ࠡ�⪨ *)
    filtr1       : REAL ; (* ������ �࠭�� 䨫���樨 *)
    filtr2       : REAL ; (* ������ �࠭�� 䨫���樨 *)
    distan       : CARDINAL ; (* ���⠭�� ��室� *)
    razpochast   : REAL;
    shirsp       : REAL;
    nizgpr       : REAL;
    verhpr       : REAL;
    doverv       : REAL;
    razmx        : ARRAY [0..8] OF CHAR;
    razmy        : ARRAY [0..8] OF CHAR;
BEGIN
IO.WrStr('������ ��� 䠩��');
IO.WrLn();
IO.RdItem(file_name);
Str.Insert(file_name,'d:\jpi\proba\',0);
Str.Append(file_name,'.dat');
IO.WrLn();
IO.WrStr(file_name);
IO.WrLn();
file:= FIO.Create(file_name);
FIO.AssignBuffer(file,buf) ;

(* --------------------- ���������� �⨪�⪨ ------------------------- *)
    index        := 34;
    data         := '27/11/91' ;
    objekt       := 'mod1' ; (* ��ꥪ� *)
    tbegin       := 0.0 ;   (* �६� ��砫� ���⪠ ����� *)
    tend         := 1.0 ;   (* �६� ���� ���⪠ ����� *)
    chastota     := 1000.0 ;   (* ���� ����⨧�樨 *)
    prore        := 0 ; (* ��०������ *)
    ident        := 'SW' ; (* �����䨪��� 䠩�� ��ࠡ�⪨ *)
    obr          := 0 ; (* 2 ���� ��ࠡ�⪨ *)
    filtr1       := 0.0 ; (* ������ �࠭�� 䨫���樨 *)
    filtr2       := 0.0 ; (* ������ �࠭�� 䨫���樨 *)
    distan       := 0 ; (* ���⠭�� ��室� *)
    razpochast   := 0.;
    shirsp       := 0.;
    nizgpr       := 0.;
    verhpr       := 0.;
    doverv       := 0.;

RANDOMIZE;
max := MIN(REAL);
min := MAX(REAL);
delta:=1./chastota;
mo:=0.0;
computer:= 0;
schet:= 0;

FIO.EOF:= FALSE;
FIO.Seek(file,105);

FOR computer:= 0 TO 1023 DO

digit:= REAL(Sin(LONGREAL(computer) / 25.)) ; (* ᨭ�� *)

FIO.WrBin(file,digit,4);
   IF digit> max THEN  max := digit  END;
   IF digit< min THEN  min := digit  END;
   mo:= mo + digit
END; (* for *)

 computer:=computer;
 mo := mo/REAL(computer);

(* --------------------- ������ �⨪�⪨ � 䠩� -------------------------- *)
  FIO.Seek(file,0);
  FIO.WrBin(file,index,2);
  FIO.WrBin(file,data,8);
  FIO.WrBin(file,objekt,4) ;     (* ��ꥪ� *)
  FIO.WrBin(file,tbegin,4) ;     (* �६� ��砫� ���⪠ ����� *)
  FIO.WrBin(file,tend,4) ;       (* �६� ���� ���⪠ ����� *)
  FIO.WrBin(file,chastota,4);    (* ���� ����⨧�樨 *)
  FIO.WrBin(file,computer,4);    (* ������⢮ *)
  FIO.WrBin(file,prore,2) ;      (* ��०������ *)
  index :=105 ;
  FIO.WrBin(file,index,2);       (* ������ ��砫� ���. ������ *)
  FIO.WrBin(file,ident,2);       (* SW *)
  FIO.WrBin(file,min,4);         (* ������ *)
  FIO.WrBin(file,max,4);         (* ���ᨬ� *)
  FIO.WrBin(file,mo,4);          (* ��⮦������ *)
  FIO.WrBin(file,obr,2);         (* 2 ���� ��ࠡ�⪨ *)
  FIO.WrBin(file,filtr1,4);      (* ������ �࠭�� 䨫���樨 *)
  FIO.WrBin(file,filtr2,4);      (* ������ �࠭�� 䨫���樨 *)
  FIO.WrBin(file,distan,2);      (* ���⠭�� ��室� *)
  FIO.WrBin(file,razpochast,4);  (* ࠧ�襭�� �� ���� *)
  FIO.WrBin(file,shirsp,4);      (* �ਭ� ᯥ��� *)
  FIO.WrBin(file,nizgpr,4);      (* ������ �।�� *)
  FIO.WrBin(file,verhpr,4);      (* ���孨� �।�� *)
  FIO.WrBin(file,doverv,4);      (* �����⥫쭠� ����⭮��� *)
  FIO.WrBin(file,0,16) ;            (* ࠧ��୮��� *)
  FIO.WrBin(file,SHORTCARD(12),1);  (* ࠧ�來���� ��� *)
  FIO.WrBin(file,REAL(-5),4);       (* ������ *)
  FIO.WrBin(file,REAL(5),4);        (* ���孨� *)
FIO.Close(file) ;

(* �஢�ઠ �⥭�� �⨪�⪨ �� 䠩�� *)

    file:=FIO.Open(file_name);
    FIO.AssignBuffer(file,buf) ;

FIO.Seek(file,2);
    priznak:=FIO.RdBin(file,data,8) ;      (* ��� ��ᯥਬ��� *)
    IO.WrStr('��� ��ᯥਬ���') ;
    IO.WrStr(data) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,objekt,4) ;     (* ��ꥪ� *)
    IO.WrStr('��ꥪ�') ;
    IO.WrStr(objekt)  ; IO.WrLn ;

    priznak:=FIO.RdBin(file,tbegin,4) ;  (* �६� ��砫� ���⪠ ����� *)
    IO.WrStr('�६� ��砫� ���⪠ �����') ;
    IO.WrReal(tbegin,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,tend,4) ;    (* �६� ���� ���⪠ ����� *)
    IO.WrStr('�६� ���� ���⪠ �����') ;
    IO.WrReal(tend,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,chastota,4); (* ���� ����⨧�樨 *)
    IO.WrStr('���� ����⨧�樨') ;
    IO.WrReal(chastota,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,computer,4) ;     (* ������⢮ �祪 ॠ����樨 *)
    IO.WrStr('������⢮ �祪 ॠ����樨') ;
    IO.WrLngCard(computer,6) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,prore,2) ;   (* ��०������ *)
    IO.WrStr('��०������') ;
    IO.WrCard(prore,6) ; IO.WrLn ;

FIO.Seek(file,36);
    priznak:=FIO.RdBin(file,min,4) ;         (* ������  *)
    IO.WrStr('������') ;
    IO.WrReal(min,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,max,4) ;         (* ���ᨬ� *)
    IO.WrStr('���ᨬ�') ;
    IO.WrReal(max,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,mo,4)  ;         (* ��⮦������ *)
    IO.WrStr('��⮦������') ;
    IO.WrReal(mo,4,10) ; IO.WrLn ;

FIO.Seek(file,50);
    priznak:=FIO.RdBin(file,filtr1,4) ;      (* ������ �࠭�� 䨫���樨 *)
    IO.WrStr('������ �࠭�� 䨫���樨') ;
    IO.WrReal(filtr1,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,filtr2,4);      (* ������ �࠭�� 䨫���樨 *)
    IO.WrStr('������ �࠭�� 䨫���樨');
    IO.WrReal(filtr2,4,10) ; IO.WrLn;

    priznak:=FIO.RdBin(file,distan,2);      (* ���⠭�� ��室� *)
    IO.WrStr('���⠭�� ��室�') ;
    IO.WrCard(distan,6) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,razpochast,4);  (* ࠧ�襭�� �� ���� *)
    IO.WrStr('ࠧ�襭�� �� ����');
    IO.WrReal(razpochast,4,10) ; IO.WrLn;

    priznak:=FIO.RdBin(file,shirsp,4);      (* �ਭ� ᯥ��� *)
    IO.WrStr('�ਭ� ᯥ��� �࠭�� 䨫���樨');
    IO.WrReal(shirsp,4,10) ; IO.WrLn ;


    priznak:=FIO.RdBin(file,nizgpr,4);      (* ������ �।�� *)
    IO.WrStr('������ �࠭�� 䨫���樨');
    IO.WrReal(nizgpr,4,10) ; IO.WrLn ;

    FIO.WrBin(file,verhpr,4);               (* ���孨� �।�� *)
    IO.WrStr('������ �࠭�� 䨫���樨');
    IO.WrReal(verhpr,4,10) ; IO.WrLn ;

    FIO.WrBin(file,doverv,4);               (* �����⥫쭠� ����⭮��� *)
    IO.WrStr('�����⥫쭠� ����⭮���');
    IO.WrReal(doverv,4,10) ; IO.WrLn ;
FIO.Close(file) ;

END modeli.


(*
  digit:= 10.*REAL(Sin(LONGREAL(2. * 3.1415 * 8.* REAL(REAL(computer)*delta)))) ;
  IF INTEGER(computer)=INTEGER(10.*del+RAND()*100.) THEN
     digit:=digit+REAL(Pow(LONGREAL(-1),LONGREAL(RAND()*10.)))*RAND()*10.;
  END; (* if *)
  del:=digit+digit*digit*10.+del;
*)


(*digit:= 2.5 + REAL( Pow (LONGREAL (-1),LONGREAL (2.*REAL(computer))))*RAND();*)
                                        (* ��ﬠ� � ���ᠬ� *)

 (* digit:= (15.*REAL(computer)+2.)*REAL(Sin(LONGREAL((2.*REAL(computer)+1.75)*REAL(computer)+RAND()))); *)
                                      (* ������ ����樮��୮�� ����� *)
(*digit:= REAL(Sin(LONGREAL(2. * 3.1415 * REAL(REAL(computer)/0.05)))) + 500. * REAL(REAL(computer)/1100.)+1.4;
                                       (* ᨭ�� � �७��� *)
*)
(*
IF ((computer >= 65) & (computer <= 166)) OR
   ((computer >= 365) & (computer <= 466))
   THEN digit:= 1.0
   ELSE digit:= 0.0                  (* ��אַ㣮��� ������ 2 ࠧ�*)
END; (* if *)
*)
(*
IF (computer = 260) THEN digit:= 1.0
                    ELSE digit:= 0.0   (* delta �㭪�� *)
END; (* if *)
*)
(*
 digit1:= 10.*REAL(Sin(LONGREAL(2. * 3.1415 * 16.* REAL(REAL(computer)*delta)))) ;
 digit2:= 5.*REAL(Sin(LONGREAL(2. * 3.1415 *  10.* REAL(REAL(computer)*delta)))) ;
 digit3:= 4.*REAL(Sin(LONGREAL(2. * 3.1415 * 80.* REAL(REAL(computer)*delta)))) ;
 digit:=digit1+digit2+digit3;      (* ������ମ���᪨� ᨣ��� *)
*)
(*
IF (computer>=120)&(computer<=321) THEN digit:= 3.0
                                   ELSE digit:= 0.0(* ��אַ㣮��� ������ *)
END; (* if *)
*)
(*
digit:= REAL(computer); (* ࠢ����୮� ��।������ *)
*)
(*
digit:= REAL(Sin(LONGREAL(computer) / 25.)) ; (* ᨭ�� *)
*)
(*
digit:= RAND();  (* ��砩�� ����c *)
*)
(*
INC(schet);
IF schet>=45 THEN schet:= 0;
                  IF ODD(computer) THEN  digit:= REAL(1+RANDOM(2))
                                   ELSE  digit:= -(REAL(1+RANDOM(2)));
                                   (* ����� �� ��אַ� *)
                  END; (* if *)
             ELSE digit:= 0.;
END; (* if *)
*)
(*
digit1:=   REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit2:=   REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit3:=   REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit4:=   REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit5:=   REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit6:=   REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit7:=   REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit8:=   REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit9:=   REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit10:=  REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit11:=  REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit12:=  REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit13:=  REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit14:=  REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit15:=  REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit16:=  REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit17:=  REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit18:=  REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit19:=  REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit20:=  REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit21:=  REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit22:=  REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit23:=  REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit24:=  REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));
digit25:=  REAL(1 DIV 2+RANDOM(MAX(CARDINAL)));

digit:= digit1+digit2+digit3+digit4+digit5+digit6+digit7+digit8+digit9+
        digit10+digit11+digit12+digit13+digit14+digit15+digit16+digit17+
        digit18+digit19+digit20+digit21+digit22+digit23+digit24+digit25;

*)

(*
 digit1:= 5.*REAL(Sin(LONGREAL(2. * 3.1415 * 200.* REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit2:= 5.*REAL(Sin(LONGREAL(2. * 3.1415 * 10.*  REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit3:= 5.*REAL(Sin(LONGREAL(2. * 3.1415 * 80.*  REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit4:= 5.*REAL(Sin(LONGREAL(2. * 3.1415 * 20.*  REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit5:= 5.*REAL(Sin(LONGREAL(2. * 3.1415 * 40.*  REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit6:= 5.*REAL(Sin(LONGREAL(2. * 3.1415 * 50.*  REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit7:= 5.*REAL(Sin(LONGREAL(2. * 3.1415 * 60.*  REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit8:= 5.*REAL(Sin(LONGREAL(2. * 3.1415 * 70.*  REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit9:= 5.*REAL(Sin(LONGREAL(2. * 3.1415 * 30.*  REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit10:=5.*REAL(Sin(LONGREAL(2. * 3.1415*  90.*  REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit11:=5.*REAL(Sin(LONGREAL(2. * 3.1415 * 100.* REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit12:=5.*REAL(Sin(LONGREAL(2. * 3.1415 * 110.* REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit13:=5.*REAL(Sin(LONGREAL(2. * 3.1415 * 120.* REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit14:=5.*REAL(Sin(LONGREAL(2. * 3.1415 * 130.* REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit15:=5.*REAL(Sin(LONGREAL(2. * 3.1415 * 140.* REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit16:=5.*REAL(Sin(LONGREAL(2. * 3.1415 * 150.* REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit17:=5.*REAL(Sin(LONGREAL(2. * 3.1415 * 160.* REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit18:=5.*REAL(Sin(LONGREAL(2. * 3.1415 * 170.* REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit19:=5.*REAL(Sin(LONGREAL(2. * 3.1415 * 180.* REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);
 digit20:=5.*REAL(Sin(LONGREAL(2. * 3.1415*  190.* REAL(REAL(computer)*delta))) + RAND(360) *2. *3.1415);

digit:= digit1+digit2+digit3+digit4+digit5+digit6+digit7+digit8+digit9+
        digit10+digit11+digit12+digit13+digit14+digit15+digit16+digit17+
        digit18+digit19+digit20;


 (* ������ମ���᪨� ᨣ��� *)
*)
