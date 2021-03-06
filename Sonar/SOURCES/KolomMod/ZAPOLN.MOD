MODULE zapoln ;

IMPORT FIO,IO,MATHLIB,Lib ;

VAR FileName     : ARRAY [1..12] OF CHAR ;
    ff           : FIO.File ;
    i            : LONGCARD ;
    i1           : CARDINAL ;
    x            : REAL ;
    buf          : ARRAY[0..2047+FIO.BufferOverhead] OF BYTE ;
    priznak      : CARDINAL ;
    ot           : CHAR ;

(* ��६���� ��� �⨪�⪨ *)
    index        : CARDINAL ; (* ������ ��砫� �㦥���� ���ଠ樨 *)
    data         : ARRAY [1..8] OF CHAR ; (* ��� ��ᯥਬ��� *)
    objekt       : ARRAY [1..4] OF CHAR ; (* ��ꥪ� *)
    tbegin       : REAL ;   (* �६� ��砫� ���⪠ ����� *)
    tend         : REAL ;   (* �६� ���� ���⪠ ����� *)
    chastota     : REAL ;   (* ���� ����⨧�樨 *)
    kol          : LONGCARD ; (* ������⢮ �祪 ॠ����樨 *)
    prore        : CARDINAL ; (* ��०������ *)
    in_real      : CARDINAL ; (* ������ ��砫� ��ᯥਬ��⠫��� ������ *)
    ident        : ARRAY [1..2] OF CHAR ; (* �����䨪��� 䠩�� ��ࠡ�⪨ *)
    min          : REAL ; (* ������  *)
    max          : REAL ; (* ���ᨬ� *)
    mo           : REAL ; (* ��⮦������ *)
    obr          : CARDINAL ; (* 2 ���� ��ࠡ�⪨ *)
    filtr1       : REAL ; (* ������ �࠭�� 䨫���樨 *)
    filtr2       : REAL ; (* ������ �࠭�� 䨫���樨 *)
    distan       : CARDINAL ; (* ���⠭�� ��室� *)
    rez          : ARRAY [1..20 ] OF CHAR ; (* १�� �������� ������������ *)

BEGIN

   max := -1.2E-38 ;
   min :=  1.2E+38 ;
   mo  :=  0.0 ;

   FileName:="Ssssssss.dat" ;
   ff:=FIO.Create(FileName) ;
   FIO.AssignBuffer(ff,buf) ;
(* ���������� �⨪�⪨ *)

    index        :=34 ;
    data         :='19/11/91' ;
    objekt       :='EKS5' ; (* ��ꥪ� *)
    tbegin       :=0.0 ;   (* �६� ��砫� ���⪠ ����� *)
    tend         :=10.0 ;   (* �६� ���� ���⪠ ����� *)
    chastota     :=1000.0 ;   (* ���� ����⨧�樨 *)
    kol          :=1024 ;  (* ������⢮ �祪 ॠ����樨 *)
    prore        :=0 ; (* ��०������ *)
    in_real      :=80 ; (* ������ ��砫� ��ᯥਬ��⠫��� ������ *)
    ident        :='SW' ; (* �����䨪��� 䠩�� ��ࠡ�⪨ *)
    obr          :=0FFFFH ; (* 2 ���� ��ࠡ�⪨ *)
    filtr1       :=0.0 ; (* ������ �࠭�� 䨫���樨 *)
    filtr2       :=0.0 ; (* ������ �࠭�� 䨫���樨 *)
    distan       :=0 ; (* ���⠭�� ��室� *)
    rez          :='                    ' ; (* १�� �������� ������������ *)

(* ������ �⨪�⪨ � 䠩� *)

    FIO.WrBin(ff,index,2) ;  (* ������ ��砫� �㦥���� ���ଠ樨 *)
    FIO.WrBin(ff,data,8) ;      (* ��� ��ᯥਬ��� *)
    FIO.WrBin(ff,objekt,4) ;    (* ��ꥪ� *)
    FIO.WrBin(ff,tbegin,4) ;  (* �६� ��砫� ���⪠ ����� *)
    FIO.WrBin(ff,tend,4) ;    (* �६� ���� ���⪠ ����� *)
    FIO.WrBin(ff,chastota,4); (* ���� ����⨧�樨 *)
    FIO.WrBin(ff,kol,4) ;    (* ������⢮ �祪 ॠ����樨 *)
    FIO.WrBin(ff,prore,2) ;  (* ��०������ *)
    FIO.WrBin(ff,in_real,2); (* ������ ��砫� ��ᯥਬ��⠫��� ������ *)
    FIO.WrBin(ff,ident,2) ;         (* �����䨪��� 䠩�� ��ࠡ�⪨ *)
    FIO.WrBin(ff,min,4) ;         (* ������  *)
    FIO.WrBin(ff,max,4) ;         (* ���ᨬ� *)
    FIO.WrBin(ff,mo,4)  ;         (* ��⮦������ *)
    FIO.WrBin(ff,obr,2);         (* 2 ���� ��ࠡ�⪨ *)
    FIO.WrBin(ff,filtr1,4) ;      (* ������ �࠭�� 䨫���樨 *)
    FIO.WrBin(ff,filtr2,4) ;      (* ������ �࠭�� 䨫���樨 *)
    FIO.WrBin(ff,distan,2) ;     (* ���⠭�� ��室� *)
    FIO.WrBin(ff,rez,20) ;           (* १�� �������� ������������ *)

   Lib.RANDOMIZE ;
(* ���������� ���ᨢ� ���ଠ樥� *)
   FOR i:=1 TO kol DO
(* 1-� ᨣ��� -  ��ଠ�쭮� ��।������ *)
(*        x:=REAL(i)+20.0+REAL(Lib.RAND())+REAL(Lib.RAND())+REAL(Lib.RAND())+REAL(Lib.RAND())+REAL(Lib.RAND())+REAL(Lib.RAND()) ;*)
          x:=REAL(i) ;

(* 2-� ᨣ��� -  �����-�㭪�� *)
(*        IF i<1000 THEN
              x:=0.0 ;
           ELSE
              x:=1.0 ;
        END ; (* IF *)
*)
(* 3-� ᨣ��� -  ��אַ㣮��� ������ *)
(*        IF i<1000 THEN
              x:=0.0 ;
             ELSE
                IF i>4000 THEN
                      x:=0.0 ;
                   ELSE
                      x:=1.0 ;
                END ; (* IF *)
          END ; (* IF *)
*)
(* ���������� ����஫��� �ਬ�஢ *)
(*   x[1]  :=2.5 ;
   x[2]  :=5.15 ;
   x[3]  :=3.05 ;
   x[4]  :=1.1 ;
   x[5]  :=1.7 ;
   x[6]  :=3.6 ;
   x[7]  :=4.7 ;
   x[8]  :=4.65 ;
   x[9]  :=6.8 ;
   x[10] :=5.6 ;
   x[11] :=2.3 ;
   x[12] :=2.9 ;
   x[13] :=3.2 ;
   x[14] :=3.8 ;
   x[15] :=4.2 ;
   x[16] :=3.5 ;
   x[17] :=4.8 ;
   x[18] :=5.7 ;
   x[19] :=4.9 ;
   x[20] :=7.5 ;*)

(* ���᫥��� ���. �ࠪ���⨪ *)
                       (* ���������� ��������� � �������� + ��⮦������ *)
         IF max < x THEN
               max := x ;
         END ; (* IF *)
         IF min > x THEN
               min := x ;
         END ; (* IF *)
         mo:=mo+x ;

         FIO.WrBin(ff,x,4) ;
   END ; (* FOR *)
   mo:=mo/REAL(kol) ;

      FIO.Seek(ff,36) ;
      FIO.WrBin(ff,min,4) ;
      FIO.WrBin(ff,max,4) ;
      FIO.WrBin(ff,mo,4) ;

   FIO.Close(ff) ;

(* �஢�ઠ �⥭�� �⨪�⪨ *)
   (* �⥭�� �⨪�⪨ �� 䠩�� *)

    ff:=FIO.Open(FileName) ;
    FIO.AssignBuffer(ff,buf) ;

    priznak:=FIO.RdBin(ff,index,2) ;  (* ������ ��砫� �㦥���� ���ଠ樨 *)
    IO.WrStr('������ ��砫� �㦥���� ���ଠ樨');
    IO.WrCard(index,6) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,data,8) ;      (* ��� ��ᯥਬ��� *)
    IO.WrStr('��� ��ᯥਬ���') ;
    IO.WrStr(data) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,objekt,4) ;     (* ��ꥪ� *)
    IO.WrStr('��ꥪ�') ;
    IO.WrStr(objekt)  ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,tbegin,4) ;  (* �६� ��砫� ���⪠ ����� *)
    IO.WrStr('�६� ��砫� ���⪠ �����') ;
    IO.WrReal(tbegin,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,tend,4) ;    (* �६� ���� ���⪠ ����� *)
    IO.WrStr('�६� ���� ���⪠ �����') ;
    IO.WrReal(tend,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,chastota,4); (* ���� ����⨧�樨 *)
    IO.WrStr('���� ����⨧�樨') ;
    IO.WrReal(chastota,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,kol,4) ;     (* ������⢮ �祪 ॠ����樨 *)
    IO.WrStr('������⢮ �祪 ॠ����樨') ;
    IO.WrLngCard(kol,6) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,prore,2) ;   (* ��०������ *)
    IO.WrStr('��०������') ;
    IO.WrCard(prore,6) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,in_real,2); (* ������ ��砫� ��ᯥਬ��⠫��� ������ *)
    IO.WrStr('������ ��砫� ��ᯥਬ��⠫��� ������') ;
    IO.WrCard(in_real,6) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,ident,2) ;       (* �����䨪��� 䠩�� ��ࠡ�⪨ *)
    IO.WrStr('�����䨪��� 䠩�� ��ࠡ�⪨') ;
    IO.WrStr(ident) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,min,4) ;         (* ������  *)
    IO.WrStr('������') ;
    IO.WrReal(min,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,max,4) ;         (* ���ᨬ� *)
    IO.WrStr('���ᨬ�') ;
    IO.WrReal(max,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,mo,4)  ;         (* ��⮦������ *)
    IO.WrStr('��⮦������') ;
    IO.WrReal(mo,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,obr,2);                   (* 2 ���� ��ࠡ�⪨ *)
    IO.WrStr('2 ���� ��ࠡ�⪨') ;
    IO.WrCard(obr,6) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,filtr1,4) ;      (* ������ �࠭�� 䨫���樨 *)
    IO.WrStr('������ �࠭�� 䨫���樨') ;
    IO.WrReal(filtr1,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,filtr2,4) ;      (* ������ �࠭�� 䨫���樨 *)
    IO.WrStr('������ �࠭�� 䨫���樨') ;
    IO.WrReal(filtr2,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,distan,2) ;     (* ���⠭�� ��室� *)
    IO.WrStr('���⠭�� ��室�') ;
    IO.WrCard(distan,6) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,rez,20) ;        (* १�� �������� ������������ *)
    IO.WrStr('१�� �������� ������������') ;
    IO.WrStr(rez) ; IO.WrLn ;

    FIO.Close(ff) ;
END zapoln.