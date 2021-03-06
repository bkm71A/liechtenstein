IMPLEMENTATION MODULE Etiketka;

IMPORT FIO,Str;
FROM Window    IMPORT WinDef,WinType,Open,Close,Color,TextColor,TextBackground,
                      PutOnTop,FrameStr,GotoXY;
FROM IO        IMPORT WrStr,RdCharDirect;
FROM SearchFl  IMPORT FullPath;

PROCEDURE title(file_name : ARRAY OF CHAR ) ;
(*****************************************************)
(*              ��ᬮ�� �⨪�⪨ !!!!!!!!           *)
(*****************************************************)

CONST shabl1 ='�६� ��砫� ���⪠ �����(�)|'+
              '�६� ���� ���⪠ ����� (�)|'+
              '���� ����⨧�樨 (��)|'+
              '������⢮ �祪 ॠ����樨|'+
              '��०������|'+
              '������|'+
              '���ᨬ�|'+
              '��⮦������|'+
              '���⠭�� ��室� (�)|' ;
      shabl2 ='ᣫ�������� �� ����|'+
              'ᣫ�������� ����� ��|'+
              '��⮪��५�樮���� ��ࠡo�|'+
              '����७�஢����|'+
              '��⥣�஢����|'+
              '䨫����� � ����� ����|'+
              'ᯥ���|'+
              'ᯥ��ࠫ쭠� ���⭮���|'+
              'ᣫ�������� �� ��������|'+
              'ᣫ�������� �� ��������|'+
              'ᣫ�������� �� ��ᠬ���|'+
              'ᣫ�������� �� ���⠬|'+
              '���࠭���� ���ᮢ|'+
              '���࠭���� �७��|'+
              '�����஢��|'+
              '��஢��|' ;
    s1      = FrameStr('�͸���;') ;
   type_dat = '\type_dat' ;

VAR index    : CARDINAL ; (* ������ ��砫� �㦥���� ���ଠ樨 *)
    stroka   : ARRAY[0..28] OF CHAR ;

    Perem    : ARRAY[0.. 9] OF REAL ;
    Long     : LONGCARD ;

    data     : ARRAY [0..7] OF CHAR ; (* ��� ��ᯥਬ��� *)
    objekt   : ARRAY [0..4] OF CHAR ; (* ��ꥪ� *)

    obr      : CARDINAL ;

    filtr1   : REAL     ; (* ������ �࠭�� 䨫���樨 *)
    filtr2   : REAL     ; (* ������ �࠭�� 䨫���樨 *)
    distan   : CARDINAL ; (* ���⠭�� ��室� *)

    i,j,CH   : CARDINAL ;
    ok,bool  : BOOLEAN ;
    ot       : CHAR ;
    ff,f     : FIO.File ;
    AA       : WinDef ;
    Aaa      : WinType ;

BEGIN
AA:=WinDef(0,0,79,24,LightCyan,Blue,FALSE,FALSE,TRUE,TRUE,s1,LightCyan,Blue) ;
   Aaa:=Open(AA) ;
   data  [HIGH(data)]   :=CHR(0) ;
   objekt[HIGH(objekt)] :=CHR(0) ;
   ff:=FIO.Open(file_name) ;
(* ����⮢�窠 �ᥣ� ��࠭� *)
   TextColor(LightGray) ;
   FOR i:=1 TO 46 DO
      GotoXY(i,16) ; WrStr('�') ;
      GotoXY(i,19) ; WrStr('�') ;
      GotoXY(i,21) ; WrStr('�') ;
   END ; (* FOR *)
(* ����⮢�窠 ���� ��⮤�� ��ࠡ�⪨ *)
   TextColor(LightGreen) ;
   GotoXY(47,6) ;  WrStr('�') ;
   GotoXY(48,6) ;  WrStr('������') ;
   GotoXY(72,6) ;  WrStr('������') ;
   GotoXY(78,6) ;  WrStr('�') ;
   FOR i := 7 TO 22 DO
      GotoXY(47,i) ; WrStr('�') ;
      GotoXY(78,i) ; WrStr('�') ;
   END ;
   GotoXY(47,23) ;  WrStr('�') ;
   GotoXY(78,23) ;  WrStr('�') ;
   FOR i := 48 TO 77 DO
      GotoXY(i,23) ;  WrStr('�') ;
   END ; (* FOR *)
(* �ନ஢���� �������� *)
   TextColor(LightMagenta) ;
   GotoXY(35,0) ; WrStr(' �������� ') ;
   TextColor(LightCyan) ;
   GotoXY(31,1) ;   WrStr('䠩�') ;
   TextColor(Yellow) ;
   GotoXY(37,1) ;   WrStr(file_name) ;
(* ����஢뢠�� ⨯ ���稪� *)
   Str.Concat(stroka,FullPath,type_dat) ; (* ��ନ஢��� ����� ���� type_dat *)
   f:=FIO.Open(stroka) ;
   IF FIO.IOresult()=0 THEN
      TextColor(LightCyan) ;
       GotoXY(15,2) ; WrStr('��� ��ᯥਬ. ������') ;
       LOOP FIO.RdStr(f,stroka) ;
            IF stroka[0]=file_name[0] THEN
              Str.Delete(stroka,0,4) ;
              TextColor(Yellow) ;
              GotoXY(38,2) ; WrStr(stroka) ; EXIT
            END ;
            IF FIO.EOF THEN
                TextColor(Yellow) ;
                GotoXY(38,2) ; WrStr('�� �������஢��') ; EXIT
            END ;
       END ;
       FIO.Close(f) ;
   END ;
(* �ନ஢���� ������ �� ����� 䠩�� *)
   Str.Slice(stroka,file_name,1,2) ;
   TextColor(LightCyan) ;
   GotoXY(9,4) ;  WrStr('����� ०���');
   TextColor(LightMagenta) ;
   GotoXY(23,4) ; WrStr(stroka);
   Str.Slice(stroka,file_name,3,2) ;
   TextColor(LightCyan) ;
   GotoXY(30,4) ; WrStr('����� ���०���');
   TextColor(LightMagenta) ;
   GotoXY(47,4) ; WrStr(stroka);
   Str.Slice(stroka,file_name,5,3) ;
   TextColor(LightCyan) ;
   GotoXY(55,4) ; WrStr('����� ������');
   TextColor(LightMagenta) ;
   GotoXY(69,4) ; WrStr(stroka);
(* �⥭�� �⨪�⪨ *)
   CH:=FIO.RdBin(ff,index,2) ;   (* ������ ��砫� �㦥���� ���ଠ樨 *)
   CH:=FIO.RdBin(ff,data,8) ;    (* ��� ��ᯥਬ��� *)
   TextColor(LightCyan) ;
   GotoXY(15,3) ; WrStr('��� ��ᯥਬ���') ;
   TextColor(LightMagenta) ;
   GotoXY(34,3) ; WrStr(data)  ;
   CH:=FIO.RdBin(ff,objekt  ,4) ; (* ��ꥪ� *)
   TextColor(LightCyan) ;
   GotoXY(55,3) ; WrStr('��ꥪ�') ;
   TextColor(LightMagenta) ;
   GotoXY(63,3) ; WrStr(objekt) ;
   CH:=FIO.RdBin(ff,Perem[0],4) ; (* �६� ��砫� ���⪠ ����� *)
   CH:=FIO.RdBin(ff,Perem[1],4) ; (* �६� ���� ���⪠ ����� *)
   CH:=FIO.RdBin(ff,Perem[2],4) ; (* ���� ����⨧�樨 *)
   CH:=FIO.RdBin(ff,Long    ,4) ; (* ������⢮ �祪 ॠ����樨 *)
   Perem[3] :=REAL(Long) ;
   CH:=FIO.RdBin(ff,j,2)        ; (* ��०������ *)
   Perem[4] :=REAL(j) ;

   CH:=FIO.RdBin(ff,j,2) ; (*������ ��砫� ��ᯥਬ. ������- 㦥 ��������.*)
   FIO.Seek(ff,LONGCARD(index)) ;
   CH:=FIO.RdBin(ff,j,2) ; (*�����䨪��� 䠩�� ��ࠡ�⪨ - 㦥 ��������.*)
   CH:=FIO.RdBin(ff,Perem[5],4) ; (* ������  *)
   CH:=FIO.RdBin(ff,Perem[6],4) ; (* ���ᨬ� *)
   CH:=FIO.RdBin(ff,Perem[7],4) ; (* ��⮦������ *)
   CH:=FIO.RdBin(ff,obr,2) ;      (* 2 ���� ��ࠡ�⪨ *)
   CH:=FIO.RdBin(ff,filtr1,4)   ; (* ������ �࠭�� 䨫���樨 *)
   CH:=FIO.RdBin(ff,filtr2,4)   ; (* ������ �࠭�� 䨫���樨 *)
   CH:=FIO.RdBin(ff,j,2)        ; (* ���⠭�� ��室� *)
   Perem[8] :=REAL(j) ;
   CH:=FIO.RdBin(ff,Perem[9],4);
   FIO.Close(ff) ;
(* �뢮� �⨪�⪨ *)
   j  := 0 ;
   LOOP
      Str.ItemS(stroka,shabl1,'|',j) ;
      IF Str.Length(stroka)=0 THEN EXIT END ;
      TextColor(LightCyan) ;
      GotoXY(2,(7+j)) ; WrStr(stroka) ;
      CASE j OF 3,4,8 : Str.CardToStr(LONGCARD(Perem[j]),stroka,10,ok) ;
                        i:=32 ;
          ELSE  Str.RealToStr(LONGREAL(Perem[j]),10,FALSE,stroka,ok) ;
                        i:=31 ;
      END ;
      TextColor(LightMagenta) ;
      GotoXY(i,(7+j)) ; WrStr(stroka) ;
      INC(j) ;
   END ; (* loop *)

(*   ⥪�� ��� �뢮�� ��⮤�� ��ࠡ�⪨      *)
(* � �ᯠ����� ���� ���⮢ ��⮤� ��ࠡ�⪨ *)
   TextColor(LightGreen) ;
   GotoXY(55,6) ; WrStr('������ ���������') ;
         (* ��㥬 ������� ��� ���� ��������� *)
   i:= 0 ; CH:= 1 ;
   LOOP
      Str.ItemS(stroka,shabl2,'|',i) ;
      IF Str.Length(stroka)=0 THEN EXIT END ;
      TextColor(LightCyan) ;
      GotoXY(48,(7+i)) ; WrStr(stroka) ;
      j:=CARDINAL(BITSET(obr)*BITSET(CH)) ;
      IF j=0 THEN
            TextColor(LightCyan) ;
            GotoXY(75,(7+i)) ; WrStr('���') ;
         ELSE
            TextColor(LightMagenta) ;
            GotoXY(75,(7+i)) ; WrStr('��') ;
            IF CH=20H THEN (* �᫨ ���� 䨫����� � ��।��塞 �࠭��� *)
                  TextColor(LightCyan) ;
                  GotoXY(2,17) ; WrStr('������  �࠭�� 䨫���') ;
                  Str.RealToStr(LONGREAL(filtr1),10,FALSE,stroka,ok) ;
                  TextColor(LightMagenta) ;
                  GotoXY(31,17) ; WrStr(stroka) ;
                  TextColor(LightCyan) ;
                  GotoXY(2,18)  ; WrStr('������ �࠭�� 䨫���') ;
                  Str.RealToStr(LONGREAL(filtr2),10,FALSE,stroka,ok) ;
                  TextColor(LightMagenta) ;
                  GotoXY(31,18) ; WrStr(stroka) ;
            END ; (* if   䨫���樨 *)
(* ��� 䠩��� ᯥ��ࠫ��� *)
              IF (bool)AND(CH>=40H)AND(CH<=0800H) THEN
                  TextColor(LightCyan) ;
                  GotoXY(2,20) ; WrStr('p���襭�� �� ����  (��)') ;
                  Str.RealToStr(LONGREAL(Perem[9]),10,FALSE,stroka,ok) ;
                  TextColor(LightMagenta) ;
                  GotoXY(31,20) ; WrStr(stroka) ;
                  bool:= FALSE;
              END ;

      END ; (* IF *)
      CH:=CH<<1 ;   INC(i) ;
   END ; (* loop *)
   TextColor(LightGray) ;
   TextBackground(LightBlue) ;
   GotoXY(18,24) ;
   WrStr(' ��� �த������� ࠡ��� ������ ���� ������� ') ;
   PutOnTop(Aaa) ;
   ot:=RdCharDirect() ;
   Close(Aaa) ;
END title;

END Etiketka.