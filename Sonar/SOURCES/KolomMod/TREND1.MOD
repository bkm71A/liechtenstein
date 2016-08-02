MODULE trend1 ;

         IMPORT IO,FIO,Str,Window,Lib ;

VAR file : ARRAY [0..65] OF CHAR ;

PROCEDURE TREND (file_name: ARRAY OF CHAR ) ;

VAR i,j          : CARDINAL ;
    m0           : REAL ; (* сумма первой полубазы  *)
    m1           : REAL ; (* сумма текущей полубазы *)
    d            : REAL ; (* поправка для устранения тренда *)
    buf          : ARRAY[0..4095+FIO.BufferOverhead] OF BYTE ;
    buf1         : ARRAY[0..4095+FIO.BufferOverhead] OF BYTE ;
    MO           : REAL ; (* матожидание         *)
    MIN          : REAL ; (* минимум реализации  *)
    MAX          : REAL ; (* максимум реализации *)
    priznak      : CARDINAL ;
    ff           : FIO.File ;
    ff1          : FIO.File ;
    x            : REAL ;
    nach         : CARDINAL ;
    kol          : LONGCARD ;
    ot           : CHAR ;
(*    k,k1,k2,k3   : CARDINAL ;*)
    obr          : CARDINAL ;

LABEL              metka1 ,
                   metka2 ;
BEGIN
   ff:=FIO.Open(file_name) ;
   FIO.AssignBuffer(ff,buf) ;
   ff1:=FIO.Open(file_name) ;
   FIO.AssignBuffer(ff1,buf1) ;
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
   priznak:=FIO.RdBin(ff,obr,2) ;

   m0:=0.0 ;
   m1:=0.0 ;
   FIO.Seek(ff,LONGCARD(nach)) ;
   FOR i:=0 TO CARDINAL(kol-1) DO
      priznak := FIO.RdBin(ff,x,4) ;
      IF FIO.EOF THEN
            GOTO metka1
      END ; (* IF *)
      m0:=m0+x ;
      m1:=m1+x*REAL(i+1) ;

   END ; (* FOR *)

metka1 :
   d:=(12.0*m1-6.0*REAL(kol+1)*m0)/(REAL(kol)*REAL(kol-1)*REAL(kol+1)) ;

(*   FIO.WrStr(1,'d=') ;
   FIO.WrReal(1,d,8,4) ;
   ot:=IO.RdCharDirect() ;*)

   MO:=0.0 ;
   MAX := -1.2E-38 ;
   MIN :=  1.2E+38 ;
   FIO.Seek(ff,LONGCARD(nach)) ;
   FIO.Seek(ff1,LONGCARD(nach)) ;
   FOR i:=0 TO CARDINAL(kol-1) DO
      priznak := FIO.RdBin(ff,x,4) ;
      IF FIO.EOF THEN
            GOTO metka2
      END ; (* IF *)
(*   FIO.WrCard(1,i,6) ;
   FIO.WrReal(1,x,8,4) ;*)

      x:=x-REAL(i)*d ;

(*   FIO.WrReal(1,x,8,4) ;
   FIO.WrLn(1) ;*)

      MO:=MO+x ;
      IF x>MAX THEN
            MAX:=x ;
         ELSE
            IF x<MIN THEN
                  MIN:=x ;
            END ; (* IF *)
      END ; (* IF *)
      FIO.WrBin(ff1,x,4) ;
   END ; (* FOR *)

metka2 :

   MO:=MO/REAL(kol) ;
   obr:=CARDINAL(BITSET(obr) + BITSET(8192)) ;
(* записываем статистические характеристики *)
   FIO.Seek(ff,36) ;
   FIO.WrBin(ff,MIN,4) ;
   FIO.WrBin(ff,MAX,4) ;
   FIO.WrBin(ff,MO,4) ;
   FIO.WrBin(ff,obr,2) ;

(*   FIO.WrReal(1,MIN,6,3) ;
   FIO.WrReal(1,MAX,6,3) ;
   FIO.WrReal(1,MO,6,3) ;
   FIO.WrLn(1) ;
   ot:=IO.RdCharDirect() ;*)

(*   GOTO metka2 ;
metka1 :*)
   (* не можем производить вычисления с такой базой *)
   Lib.Sound(4000) ;
   Lib.Delay(1000) ;
   Lib.NoSound ;

   FIO.WrLn(1) ;
(*metka2 :*)
   FIO.Close(ff) ;
   FIO.Close(ff1) ;
(*   FIO.Close(ff2) ;
   FIO.Close(ff3) ;*)


END TREND ;



BEGIN
   Str.Copy(file,'serega4.dat') ;
   TREND (file) ;
END trend1 .