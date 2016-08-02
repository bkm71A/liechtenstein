MODULE trend ;

         IMPORT IO,FIO,Str,Window,Lib ;

VAR file : ARRAY [0..65] OF CHAR ;

PROCEDURE TREND (file_name: ARRAY OF CHAR; baza : CARDINAL ) ;

VAR i,j          : CARDINAL ;
    m0           : REAL ; (* сумма первой полубазы  *)
    m1           : REAL ; (* сумма текущей полубазы *)
    d            : REAL ; (* поправка для устранения тренда *)
    buf          : ARRAY[0..2047+FIO.BufferOverhead] OF BYTE ;
    buf1         : ARRAY[0..2047+FIO.BufferOverhead] OF BYTE ;
    buf2         : ARRAY[0..2047+FIO.BufferOverhead] OF BYTE ;
    buf3         : ARRAY[0..2047+FIO.BufferOverhead] OF BYTE ;
    MO           : REAL ; (* матожидание         *)
    MIN          : REAL ; (* минимум реализации  *)
    MAX          : REAL ; (* максимум реализации *)
    priznak      : CARDINAL ;
    ff           : FIO.File ;
    ff1          : FIO.File ;
    ff2          : FIO.File ;
    ff3          : FIO.File ;
    x            : REAL ;
    nach         : CARDINAL ;
    kol          : LONGCARD ;
    ot           : CHAR ;
    k,k1,k2,k3   : CARDINAL ;

LABEL              metka1 ,
                   metka2 ;
BEGIN
   m0:=0.0 ;
   MO:=0.0 ;
   ff:=FIO.Open(file_name) ;
   FIO.AssignBuffer(ff,buf) ;
   ff1:=FIO.Open(file_name) ;
   FIO.AssignBuffer(ff1,buf1) ;
   ff2:=FIO.Open(file_name) ;
   FIO.AssignBuffer(ff2,buf2) ;
   ff3:=FIO.Open(file_name) ;
   FIO.AssignBuffer(ff3,buf3) ;
(* определяем количество точек реализации *)
   FIO.Seek(ff,26) ;
   priznak:=FIO.RdBin(ff,kol,4) ;

(* определяем начало экспериментальных данных *)
   FIO.Seek(ff,32) ;
   priznak:=FIO.RdBin(ff,nach,2) ;
(* определяем статистические характеристики *)
   FIO.Seek(ff,36) ;
   priznak:=FIO.RdBin(ff,MIN,4) ;
   priznak:=FIO.RdBin(ff,MAX,4) ;
   priznak:=FIO.RdBin(ff,MO,4) ;


   FIO.Seek(ff,LONGCARD(nach)) ;
   FIO.Seek(ff1,LONGCARD(nach+4)) ;
   FIO.Seek(ff2,LONGCARD(nach+(baza)DIV 2 *4)) ;
   FIO.Seek(ff3,LONGCARD(nach+(baza)DIV 2 *4)) ;

   k:=0 ;
   k1:=1 ;
   k2:=baza DIV 2+1 ;


   FIO.WrLngCard(1,kol,6) ;
   FIO.WrReal(1,MIN,6,3) ;
   FIO.WrReal(1,MAX,6,3) ;
   FIO.WrReal(1,MO,6,3) ;
   FIO.WrLn(1) ;
   ot:=IO.RdCharDirect() ;

   FOR i:=1 TO baza DO
      k:=k+1 ;
      priznak := FIO.RdBin(ff,x,4) ;
      IF FIO.EOF THEN
            GOTO metka1
      END ; (* IF *)
      m0:=m0+1.0 ;
      IF k<=baza DIV 2 THEN
            MO := MO + x ;      (* вычисление базового матожидания *)
      END ; (* IF *)
   END ; (* FOR *)
   m1:=m0 ;

   FIO.WrCard(1,k,6) ;
   FIO.WrCard(1,k1,6) ;
   FIO.WrCard(1,k2,6) ;
   FIO.WrLn(1) ;
   ot:=IO.RdCharDirect() ;

   FOR i:=1 TO (CARDINAL(kol)-baza) DO

      k:=k+1 ;
      k1:=k1+1 ;
      k2:=k2+1 ;

      priznak := FIO.RdBin(ff1,x,4) ;
      m1:=m1-x ;
(*      FIO.WrCard(1,k1,6) ;
      FIO.WrReal(1,x,8,4) ;*)

      priznak := FIO.RdBin(ff,x,4) ;
      m1:=m1+x ;
(*      FIO.WrCard(1,k,6) ;
      FIO.WrReal(1,x,8,4) ;*)

      d:=(m1-m0)/REAL(baza) ;
(*      FIO.WrStr(1,'d') ;
      FIO.WrReal(1,d,8,4) ;*)

      priznak := FIO.RdBin(ff2,x,4) ;
(*      FIO.WrReal(1,x,8,4) ;*)
      x:=x-d ;
      MO:=MO+x ;

(*      FIO.WrReal(1,x,8,4) ;*)


      IF x>MAX THEN
            MAX:=x ;
         ELSE
            IF x<MIN THEN
                  MIN:=x ;
            END ; (* IF *)
      END ; (* IF *)
(*      FIO.WrBin(ff3,x,4) ;
      FIO.WrLn(1) ;*)
   END ; (* FOR *)

   FIO.WrCard(1,k,6) ;
   FIO.WrCard(1,k1,6) ;
   FIO.WrCard(1,k2,6) ;
   FIO.WrLn(1) ;
   ot:=IO.RdCharDirect() ;


   FOR i:=1 TO (baza DIV 2) DO
      k2:=k2+1 ;
      priznak := FIO.RdBin(ff2,x,4) ;
      x:=x-d ;
      IF x>MAX THEN
            MAX:=x ;
         ELSE
            IF x<MIN THEN
                  MIN:=x ;
            END ; (* IF *)
      END ; (* IF *)

      FIO.WrBin(ff3,x,4) ;

   END ; (* FOR *)

   FIO.WrCard(1,k,6) ;
   FIO.WrCard(1,k1,6) ;
   FIO.WrCard(1,k2,6) ;
   FIO.WrLn(1) ;
   ot:=IO.RdCharDirect() ;

   MO:=MO/REAL(kol) ;
(* записываем статистические характеристики *)
   FIO.Seek(ff2,36) ;
   FIO.WrBin(ff2,MIN,4) ;
   FIO.WrBin(ff2,MAX,4) ;
   FIO.WrBin(ff2,MO,4) ;

   FIO.WrReal(1,MIN,6,3) ;
   FIO.WrReal(1,MAX,6,3) ;
   FIO.WrReal(1,MO,6,3) ;
   FIO.WrLn(1) ;
   ot:=IO.RdCharDirect() ;

   GOTO metka2 ;
metka1 :
   (* не можем производить вычисления с такой базой *)
   Lib.Sound(4000) ;
   Lib.Delay(1000) ;
   Lib.NoSound ;

   FIO.WrLn(1) ;
metka2 :
   FIO.Close(ff) ;
   FIO.Close(ff1) ;
   FIO.Close(ff2) ;
   FIO.Close(ff3) ;

END TREND ;



BEGIN
   Str.Copy(file,'s1111111.dat') ;
   TREND (file,1024) ;
END trend .