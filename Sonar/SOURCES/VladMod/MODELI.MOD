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

(* --------------------- заполнение этикетки ------------------------- *)
    index        := 34;
    data         := '27/11/91' ;
    objekt       := 'mod1' ; (* объект *)
    tbegin       := 0.0 ;   (* время начала участка ввода *)
    tend         := 1.0 ;   (* время конца участка ввода *)
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

digit:= REAL(Sin(LONGREAL(computer) / 25.)) ; (* синус *)

FIO.WrBin(file,digit,4);
   IF digit> max THEN  max := digit  END;
   IF digit< min THEN  min := digit  END;
   mo:= mo + digit
END; (* for *)

 computer:=computer;
 mo := mo/REAL(computer);

(* --------------------- запись этикетки в файл -------------------------- *)
  FIO.Seek(file,0);
  FIO.WrBin(file,index,2);
  FIO.WrBin(file,data,8);
  FIO.WrBin(file,objekt,4) ;     (* объект *)
  FIO.WrBin(file,tbegin,4) ;     (* время начала участка ввода *)
  FIO.WrBin(file,tend,4) ;       (* время конца участка ввода *)
  FIO.WrBin(file,chastota,4);    (* частота дискретизации *)
  FIO.WrBin(file,computer,4);    (* количество *)
  FIO.WrBin(file,prore,2) ;      (* прореживание *)
  index :=105 ;
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
  FIO.WrBin(file,0,16) ;            (* размерность *)
  FIO.WrBin(file,SHORTCARD(12),1);  (* разрядность АЦП *)
  FIO.WrBin(file,REAL(-5),4);       (* нижний *)
  FIO.WrBin(file,REAL(5),4);        (* верхний *)
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


(*
  digit:= 10.*REAL(Sin(LONGREAL(2. * 3.1415 * 8.* REAL(REAL(computer)*delta)))) ;
  IF INTEGER(computer)=INTEGER(10.*del+RAND()*100.) THEN
     digit:=digit+REAL(Pow(LONGREAL(-1),LONGREAL(RAND()*10.)))*RAND()*10.;
  END; (* if *)
  del:=digit+digit*digit*10.+del;
*)


(*digit:= 2.5 + REAL( Pow (LONGREAL (-1),LONGREAL (2.*REAL(computer))))*RAND();*)
                                        (* прямая с выбросами *)

 (* digit:= (15.*REAL(computer)+2.)*REAL(Sin(LONGREAL((2.*REAL(computer)+1.75)*REAL(computer)+RAND()))); *)
                                      (* модель нестационарного процесса *)
(*digit:= REAL(Sin(LONGREAL(2. * 3.1415 * REAL(REAL(computer)/0.05)))) + 500. * REAL(REAL(computer)/1100.)+1.4;
                                       (* синус с трендом *)
*)
(*
IF ((computer >= 65) & (computer <= 166)) OR
   ((computer >= 365) & (computer <= 466))
   THEN digit:= 1.0
   ELSE digit:= 0.0                  (* прямоугольный импульс 2 раза*)
END; (* if *)
*)
(*
IF (computer = 260) THEN digit:= 1.0
                    ELSE digit:= 0.0   (* delta функция *)
END; (* if *)
*)
(*
 digit1:= 10.*REAL(Sin(LONGREAL(2. * 3.1415 * 16.* REAL(REAL(computer)*delta)))) ;
 digit2:= 5.*REAL(Sin(LONGREAL(2. * 3.1415 *  10.* REAL(REAL(computer)*delta)))) ;
 digit3:= 4.*REAL(Sin(LONGREAL(2. * 3.1415 * 80.* REAL(REAL(computer)*delta)))) ;
 digit:=digit1+digit2+digit3;      (* полигармонический сигнал *)
*)
(*
IF (computer>=120)&(computer<=321) THEN digit:= 3.0
                                   ELSE digit:= 0.0(* прямоугольный импульс *)
END; (* if *)
*)
(*
digit:= REAL(computer); (* равномерное распределение *)
*)
(*
digit:= REAL(Sin(LONGREAL(computer) / 25.)) ; (* синус *)
*)
(*
digit:= RAND();  (* случайный процесc *)
*)
(*
INC(schet);
IF schet>=45 THEN schet:= 0;
                  IF ODD(computer) THEN  digit:= REAL(1+RANDOM(2))
                                   ELSE  digit:= -(REAL(1+RANDOM(2)));
                                   (* выбросы на прямой *)
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


 (* полигармонический сигнал *)
*)
