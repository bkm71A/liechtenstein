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

(* переменные для этикетки *)
    index        : CARDINAL;
    data         : ARRAY [1..8] OF CHAR ; (* дата эксперимента *)
    objekt       : ARRAY [1..4] OF CHAR ; (* объект *)
    tbegin       : REAL ;   (* время начала участка ввода *)
    tend         : REAL ;   (* время конца участка ввода *)
    chastota     : REAL ;   (* частота дискретизации *)
    computer     : LONGCARD ; (* количество точек реализации *)
    prore        : CARDINAL ; (* прореживание *)
    ident        : ARRAY [0..2] OF CHAR ; (* идентификатор файла обработки *)
    min          : REAL ; (* минимум  *)
    max          : REAL ; (* максимум *)
    mo           : REAL ; (* матожидание *)
    obr          : CARDINAL ; (* 2 байта обработки *)
    filtr1       : REAL ; (* нижняя граница фильтрации *)
    filtr2       : REAL ; (* верхняя граница фильтрации *)
    distan       : CARDINAL ; (* дистанция прохода *)
    razpochast   : REAL;
    shirsp       : REAL;
    nizgpr       : REAL;
    verhpr       : REAL;
    doverv       : REAL;
    razmx        : ARRAY [0..8] OF CHAR;
    razmy        : ARRAY [0..8] OF CHAR;
BEGIN

mo  :=  0.0 ;
IO.WrStr('Введите имя файла');
IO.WrLn();
IO.RdItem(file_name);
Str.Insert(file_name,'d:\jpi\proba\',0);
Str.Append(file_name,'.dat');
IO.WrLn();
IO.WrStr(file_name);
IO.WrLn();
file:= FIO.Create(file_name);
FIO.AssignBuffer(file,buf) ;

                         (* заполнение этикетки *)
    index        := 34;
    data         := '27/11/91' ;
    objekt       := 'игор' ; (* объект *)
    tbegin       := 0.0 ;   (* время начала участка ввода *)
    tend         := 10.0 ;   (* время конца участка ввода *)
    chastota     := 1000.0 ;   (* частота дискретизации *)
    prore        := 0 ; (* прореживание *)
    ident        := 'SW' ; (* идентификатор файла обработки *)
    obr          := 0 ; (* 2 байта обработки *)
    filtr1       := 0.0 ; (* нижняя граница фильтрации *)
    filtr2       := 0.0 ; (* верхняя граница фильтрации *)
    distan       := 0 ; (* дистанция прохода *)
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
                                       (* синус с трендом *)
(* digit:= REAL(computer);*)           (* равномерное распределение *)
(*  IF (computer > 100) & (computer < 301) THEN digit:= 1.0
     ELSE digit:= 0.0                  (* прямоугольный импульс *)
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
 digit:=digit1;+digit2+digit3;*)      (* полигармонический сигнал *)
 (* digit:= (15.*REAL(computer)+2.)*REAL(Sin(LONGREAL((2.*REAL(computer)+1.75)*REAL(computer)+RAND()))); *)
                                      (* модель нестационарного процесса *)

 (*digit:= 2.5 + REAL( Pow (LONGREAL (-1),LONGREAL (2.*REAL(computer))))*RAND();*)
                                        (* прямая с выбросами *)

   FIO.WrBin(file,digit,4);
   IF digit> max THEN  max := digit  END;
   IF digit< min THEN  min := digit  END;
   mo :=mo + digit
END; (* for *)

 computer:=computer-1;
 mo := mo/REAL(computer);

                     (* запись этикетки в файл *)

FIO.Seek(file,0);
  FIO.WrBin(file,index,2);
  FIO.WrBin(file,data,8);
  FIO.WrBin(file,objekt,4) ;     (* объект *)
  FIO.WrBin(file,tbegin,4) ;     (* время начала участка ввода *)
  FIO.WrBin(file,tend,4) ;       (* время конца участка ввода *)
  FIO.WrBin(file,chastota,4);    (* частота дискретизации *)
  FIO.WrBin(file,computer,4);    (* количество *)
  FIO.WrBin(file,prore,2) ;      (* прореживание *)
  index := 96 ;
  FIO.WrBin(file,index,2);       (* индекс начала эксп. данных *)
  FIO.WrBin(file,ident,2);       (* SW *)
  FIO.WrBin(file,min,4);         (* минимум *)
  FIO.WrBin(file,max,4);         (* максимум *)
  FIO.WrBin(file,mo,4);          (* матожидание *)
  FIO.WrBin(file,obr,2);         (* 2 байта обработки *)
  FIO.WrBin(file,filtr1,4);      (* нижняя граница фильтрации *)
  FIO.WrBin(file,filtr2,4);      (* верхняя граница фильтрации *)
  FIO.WrBin(file,distan,2);      (* дистанция прохода *)
  FIO.WrBin(file,razpochast,4);  (* разрешение по частоте *)
  FIO.WrBin(file,shirsp,4);      (* ширина спектра *)
  FIO.WrBin(file,nizgpr,4);      (* нижний предел *)
  FIO.WrBin(file,verhpr,4);      (* верхний предел *)
  FIO.WrBin(file,doverv,4);      (* доверительная вероятность *)
  FIO.WrBin(file,0,16) ;
FIO.Close(file) ;

(* проверка чтения этикетки из файла *)

    file:=FIO.Open(file_name);
    FIO.AssignBuffer(file,buf) ;

FIO.Seek(file,2);
    priznak:=FIO.RdBin(file,data,8) ;      (* дата эксперимента *)
    IO.WrStr('дата эксперимента') ;
    IO.WrStr(data) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,objekt,4) ;     (* объект *)
    IO.WrStr('объект') ;
    IO.WrStr(objekt)  ; IO.WrLn ;

    priznak:=FIO.RdBin(file,tbegin,4) ;  (* время начала участка ввода *)
    IO.WrStr('время начала участка ввода') ;
    IO.WrReal(tbegin,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,tend,4) ;    (* время конца участка ввода *)
    IO.WrStr('время конца участка ввода') ;
    IO.WrReal(tend,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,chastota,4); (* частота дискретизации *)
    IO.WrStr('частота дискретизации') ;
    IO.WrReal(chastota,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,computer,4) ;     (* количество точек реализации *)
    IO.WrStr('количество точек реализации') ;
    IO.WrLngCard(computer,6) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,prore,2) ;   (* прореживание *)
    IO.WrStr('прореживание') ;
    IO.WrCard(prore,6) ; IO.WrLn ;

FIO.Seek(file,36);
    priznak:=FIO.RdBin(file,min,4) ;         (* минимум  *)
    IO.WrStr('минимум') ;
    IO.WrReal(min,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,max,4) ;         (* максимум *)
    IO.WrStr('максимум') ;
    IO.WrReal(max,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,mo,4)  ;         (* матожидание *)
    IO.WrStr('матожидание') ;
    IO.WrReal(mo,4,10) ; IO.WrLn ;

FIO.Seek(file,50);
    priznak:=FIO.RdBin(file,filtr1,4) ;      (* нижняя граница фильтрации *)
    IO.WrStr('нижняя граница фильтрации') ;
    IO.WrReal(filtr1,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,filtr2,4);      (* верхняя граница фильтрации *)
    IO.WrStr('верхняя граница фильтрации');
    IO.WrReal(filtr2,4,10) ; IO.WrLn;

    priznak:=FIO.RdBin(file,distan,2);      (* дистанция прохода *)
    IO.WrStr('дистанция прохода') ;
    IO.WrCard(distan,6) ; IO.WrLn ;

    priznak:=FIO.RdBin(file,razpochast,4);  (* разрешение по частоте *)
    IO.WrStr('разрешение по частоте');
    IO.WrReal(razpochast,4,10) ; IO.WrLn;

    priznak:=FIO.RdBin(file,shirsp,4);      (* ширина спектра *)
    IO.WrStr('ширина спектра граница фильтрации');
    IO.WrReal(shirsp,4,10) ; IO.WrLn ;


    priznak:=FIO.RdBin(file,nizgpr,4);      (* нижний предел *)
    IO.WrStr('нижняя граница фильтрации');
    IO.WrReal(nizgpr,4,10) ; IO.WrLn ;

    FIO.WrBin(file,verhpr,4);               (* верхний предел *)
    IO.WrStr('верхняя граница фильтрации');
    IO.WrReal(verhpr,4,10) ; IO.WrLn ;

    FIO.WrBin(file,doverv,4);               (* доверительная вероятность *)
    IO.WrStr('доверительная вероятность');
    IO.WrReal(doverv,4,10) ; IO.WrLn ;

FIO.Close(file) ;

END modeli.

