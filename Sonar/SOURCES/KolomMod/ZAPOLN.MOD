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

(* переменные для этикетки *)
    index        : CARDINAL ; (* индекс начала служебной информации *)
    data         : ARRAY [1..8] OF CHAR ; (* дата эксперимента *)
    objekt       : ARRAY [1..4] OF CHAR ; (* объект *)
    tbegin       : REAL ;   (* время начала участка ввода *)
    tend         : REAL ;   (* время конца участка ввода *)
    chastota     : REAL ;   (* частота дискретизации *)
    kol          : LONGCARD ; (* количество точек реализации *)
    prore        : CARDINAL ; (* прореживание *)
    in_real      : CARDINAL ; (* индекс начала экспериментальных данных *)
    ident        : ARRAY [1..2] OF CHAR ; (* идентификатор файла обработки *)
    min          : REAL ; (* минимум  *)
    max          : REAL ; (* максимум *)
    mo           : REAL ; (* матожидание *)
    obr          : CARDINAL ; (* 2 байта обработки *)
    filtr1       : REAL ; (* нижняя граница фильтрации *)
    filtr2       : REAL ; (* верхняя граница фильтрации *)
    distan       : CARDINAL ; (* дистанция прохода *)
    rez          : ARRAY [1..20 ] OF CHAR ; (* резерв главного командования *)

BEGIN

   max := -1.2E-38 ;
   min :=  1.2E+38 ;
   mo  :=  0.0 ;

   FileName:="Ssssssss.dat" ;
   ff:=FIO.Create(FileName) ;
   FIO.AssignBuffer(ff,buf) ;
(* заполнение этикетки *)

    index        :=34 ;
    data         :='19/11/91' ;
    objekt       :='EKS5' ; (* объект *)
    tbegin       :=0.0 ;   (* время начала участка ввода *)
    tend         :=10.0 ;   (* время конца участка ввода *)
    chastota     :=1000.0 ;   (* частота дискретизации *)
    kol          :=1024 ;  (* количество точек реализации *)
    prore        :=0 ; (* прореживание *)
    in_real      :=80 ; (* индекс начала экспериментальных данных *)
    ident        :='SW' ; (* идентификатор файла обработки *)
    obr          :=0FFFFH ; (* 2 байта обработки *)
    filtr1       :=0.0 ; (* нижняя граница фильтрации *)
    filtr2       :=0.0 ; (* верхняя граница фильтрации *)
    distan       :=0 ; (* дистанция прохода *)
    rez          :='                    ' ; (* резерв главного командования *)

(* запись этикетки в файл *)

    FIO.WrBin(ff,index,2) ;  (* индекс начала служебной информации *)
    FIO.WrBin(ff,data,8) ;      (* дата эксперимента *)
    FIO.WrBin(ff,objekt,4) ;    (* объект *)
    FIO.WrBin(ff,tbegin,4) ;  (* время начала участка ввода *)
    FIO.WrBin(ff,tend,4) ;    (* время конца участка ввода *)
    FIO.WrBin(ff,chastota,4); (* частота дискретизации *)
    FIO.WrBin(ff,kol,4) ;    (* количество точек реализации *)
    FIO.WrBin(ff,prore,2) ;  (* прореживание *)
    FIO.WrBin(ff,in_real,2); (* индекс начала экспериментальных данных *)
    FIO.WrBin(ff,ident,2) ;         (* идентификатор файла обработки *)
    FIO.WrBin(ff,min,4) ;         (* минимум  *)
    FIO.WrBin(ff,max,4) ;         (* максимум *)
    FIO.WrBin(ff,mo,4)  ;         (* матожидание *)
    FIO.WrBin(ff,obr,2);         (* 2 байта обработки *)
    FIO.WrBin(ff,filtr1,4) ;      (* нижняя граница фильтрации *)
    FIO.WrBin(ff,filtr2,4) ;      (* верхняя граница фильтрации *)
    FIO.WrBin(ff,distan,2) ;     (* дистанция прохода *)
    FIO.WrBin(ff,rez,20) ;           (* резерв главного командования *)

   Lib.RANDOMIZE ;
(* заполнение массива информацией *)
   FOR i:=1 TO kol DO
(* 1-й сигнал -  нормальное распределение *)
(*        x:=REAL(i)+20.0+REAL(Lib.RAND())+REAL(Lib.RAND())+REAL(Lib.RAND())+REAL(Lib.RAND())+REAL(Lib.RAND())+REAL(Lib.RAND()) ;*)
          x:=REAL(i) ;

(* 2-й сигнал -  дельта-функция *)
(*        IF i<1000 THEN
              x:=0.0 ;
           ELSE
              x:=1.0 ;
        END ; (* IF *)
*)
(* 3-й сигнал -  прямоугольный импульс *)
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
(* заполнение контрольных примеров *)
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

(* вычисление стат. характеристик *)
                       (* НАХОЖДЕНИЕ МАКСИМУМА И МИНИМУМА + матожидание *)
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

(* проверка чтения этикетки *)
   (* чтение этикетки из файла *)

    ff:=FIO.Open(FileName) ;
    FIO.AssignBuffer(ff,buf) ;

    priznak:=FIO.RdBin(ff,index,2) ;  (* индекс начала служебной информации *)
    IO.WrStr('индекс начала служебной информации');
    IO.WrCard(index,6) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,data,8) ;      (* дата эксперимента *)
    IO.WrStr('дата эксперимента') ;
    IO.WrStr(data) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,objekt,4) ;     (* объект *)
    IO.WrStr('объект') ;
    IO.WrStr(objekt)  ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,tbegin,4) ;  (* время начала участка ввода *)
    IO.WrStr('время начала участка ввода') ;
    IO.WrReal(tbegin,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,tend,4) ;    (* время конца участка ввода *)
    IO.WrStr('время конца участка ввода') ;
    IO.WrReal(tend,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,chastota,4); (* частота дискретизации *)
    IO.WrStr('частота дискретизации') ;
    IO.WrReal(chastota,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,kol,4) ;     (* количество точек реализации *)
    IO.WrStr('количество точек реализации') ;
    IO.WrLngCard(kol,6) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,prore,2) ;   (* прореживание *)
    IO.WrStr('прореживание') ;
    IO.WrCard(prore,6) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,in_real,2); (* индекс начала экспериментальных данных *)
    IO.WrStr('индекс начала экспериментальных данных') ;
    IO.WrCard(in_real,6) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,ident,2) ;       (* идентификатор файла обработки *)
    IO.WrStr('идентификатор файла обработки') ;
    IO.WrStr(ident) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,min,4) ;         (* минимум  *)
    IO.WrStr('минимум') ;
    IO.WrReal(min,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,max,4) ;         (* максимум *)
    IO.WrStr('максимум') ;
    IO.WrReal(max,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,mo,4)  ;         (* матожидание *)
    IO.WrStr('матожидание') ;
    IO.WrReal(mo,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,obr,2);                   (* 2 байта обработки *)
    IO.WrStr('2 байта обработки') ;
    IO.WrCard(obr,6) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,filtr1,4) ;      (* нижняя граница фильтрации *)
    IO.WrStr('нижняя граница фильтрации') ;
    IO.WrReal(filtr1,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,filtr2,4) ;      (* верхняя граница фильтрации *)
    IO.WrStr('верхняя граница фильтрации') ;
    IO.WrReal(filtr2,4,10) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,distan,2) ;     (* дистанция прохода *)
    IO.WrStr('дистанция прохода') ;
    IO.WrCard(distan,6) ; IO.WrLn ;

    priznak:=FIO.RdBin(ff,rez,20) ;        (* резерв главного командования *)
    IO.WrStr('резерв главного командования') ;
    IO.WrStr(rez) ; IO.WrLn ;

    FIO.Close(ff) ;
END zapoln.