MODULE modeli;

IMPORT FIO,IO,Str,MATHLIB,Lib,Sounds;
FROM Lib IMPORT RAND,RANDOMIZE;

FROM MATHLIB IMPORT Sin,Pow;

VAR
  file_name       : ARRAY [0..79] OF CHAR;
  substring       : ARRAY [0..12] OF CHAR;
  file            : FIO.File;
  control         : CARDINAL;
  digit,delta,del : REAL;
  digit1,digit2,digit3: REAL;

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

mo  :=  0.0 ;
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

                         (* ���������� �⨪�⪨ *)
    index        := 34;
    data         := '27/11/91' ;
    objekt       := '����' ; (* ��ꥪ� *)
    tbegin       := 0.0 ;   (* �६� ��砫� ���⪠ ����� *)
    tend         := 10.0 ;   (* �६� ���� ���⪠ ����� *)
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

   FIO.EOF:= FALSE;
   max := MIN(REAL);
   min := MAX(REAL);
   delta:=1./chastota;
RANDOMIZE;
FIO.Seek(file,96);
FOR computer :=1 TO 1024 DO

(* digit:= REAL(Sin(LONGREAL(2. * 3.1415 * REAL(REAL(computer)/0.05)))) + 500. * REAL(REAL(computer)/1100.)+1.4;*)
                                       (* ᨭ�� � �७��� *)
(* digit:= REAL(computer);*)           (* ࠢ����୮� ��।������ *)
(*  IF (computer > 100) & (computer < 301) THEN digit:= 1.0
     ELSE digit:= 0.0                  (* ��אַ㣮��� ������ *)
  END; (* if *)
*)


(*
digit:= 10.*REAL(Sin(LONGREAL(2. * 3.1415 * 8.* REAL(REAL(computer)*delta)))) ;
  IF INTEGER(computer)=INTEGER(10.*del+RAND()*100.) THEN
     digit:=digit+REAL(Pow(LONGREAL(-1),LONGREAL(RAND()*10.)))*RAND()*10.;
  END; (* if *)
  del:=digit+digit*digit*10.+del;

*)
   digit:=1.;

(* digit1:= 10.*REAL(Sin(LONGREAL(2. * 3.1415 * 8.* REAL(REAL(computer)*delta)))) ;*)
(* digit2:= 5.*REAL(Sin(LONGREAL(2. * 3.1415 *  REAL(REAL(computer)*delta)))) ;
 digit3:= 2.*REAL(Sin(LONGREAL(2. * 3.1415 * 80.* REAL(REAL(computer)*delta)))) ;
 digit:=digit1;+digit2+digit3;*)      (* ������ମ���᪨� ᨣ��� *)
 (* digit:= (15.*REAL(computer)+2.)*REAL(Sin(LONGREAL((2.*REAL(computer)+1.75)*REAL(computer)+RAND()))); *)
                                      (* ������ ����樮��୮�� ����� *)

 (*digit:= 2.5 + REAL( Pow (LONGREAL (-1),LONGREAL (2.*REAL(computer))))*RAND();*)
                                        (* ��ﬠ� � ���ᠬ� *)

   FIO.WrBin(file,digit,4);
   IF digit> max THEN  max := digit  END;
   IF digit< min THEN  min := digit  END;
   mo :=mo + digit
END; (* for *)

 computer:=computer-1;
 mo := mo/REAL(computer);

                     (* ������ �⨪�⪨ � 䠩� *)

FIO.Seek(file,0);
  FIO.WrBin(file,index,2);
  FIO.WrBin(file,data,8);
  FIO.WrBin(file,objekt,4) ;     (* ��ꥪ� *)
  FIO.WrBin(file,tbegin,4) ;     (* �६� ��砫� ���⪠ ����� *)
  FIO.WrBin(file,tend,4) ;       (* �६� ���� ���⪠ ����� *)
  FIO.WrBin(file,chastota,4);    (* ���� ����⨧�樨 *)
  FIO.WrBin(file,computer,4);    (* ������⢮ *)
  FIO.WrBin(file,prore,2) ;      (* ��०������ *)
  index := 96 ;
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
  FIO.WrBin(file,0,16) ;
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

