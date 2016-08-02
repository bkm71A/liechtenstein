MODULE tarir ;

             IMPORT Str ;
             IMPORT FIO ;

VAR  buf            : ARRAY[0..20475+FIO.BufferOverhead] OF BYTE ;
     ff             : FIO.File ;
     file           : ARRAY[0..65] OF CHAR ;
     buf1           : ARRAY[0..2047+FIO.BufferOverhead] OF BYTE ;
     ff1            : FIO.File ;
     file1          : ARRAY[0..65] OF CHAR ;
     tx             : ARRAY[0..4095] OF REAL ;
     nach,nach1     : CARDINAL ;
     kol,kol1       : LONGCARD ;
     i,j,obrab      : CARDINAL ;
     nacp,nacp1     : SHORTCARD ;
     vmin,vmin1,
     vmax,vmax1,x   : REAL ;
     max,min,MO     : REAL ;

LABEL     con ;

BEGIN ;
(* исходные файлы *)

    Str.Copy(file,'d:\data\serega1.dat') ;
    Str.Copy(file1,'d:\data\1.tar') ;

   (* открываем файл с тарировочными характеристиками *)
   ff1:=FIO.Open(file1) ;
   FIO.Seek(ff1,26) ;
   j:=FIO.RdBin(ff1,kol1,4) ;
   FIO.Seek(ff1,32) ;
   j:=FIO.RdBin(ff1,nach1,2) ;
   FIO.Seek(ff1,96) ;
   j:=FIO.RdBin(ff1,nacp1,1) ;
   j:=FIO.RdBin(ff1,vmin1,4) ;
   j:=FIO.RdBin(ff1,vmax1,4) ;

   (* открываем файл с данными *)
   ff:=FIO.Open(file) ;
   ff:=FIO.Open(file1) ;
   FIO.Seek(ff,26) ;
   j:=FIO.RdBin(ff,kol,4) ;
   FIO.Seek(ff,32) ;
   j:=FIO.RdBin(ff,nach,2) ;
   FIO.Seek(ff,48) ;
   j:=FIO.RdBin(ff,obrab,2) ;
   FIO.Seek(ff,96) ;
   j:=FIO.RdBin(ff,nacp,1) ;
   j:=FIO.RdBin(ff,vmin,4) ;
   j:=FIO.RdBin(ff,vmax,4) ;

(* контроль на возможность проведения тарировок *)
   j:=CARDINAL(BITSET(obrab) * BITSET(1000000000000000B)) ;
   IF j=0 THEN ELSE  (* была проведена тарировка *) GOTO con ; END ;

   IF nacp=nacp1 THEN ELSE (* не совподает разрядность *) GOTO con ; END ;

   IF (vmin=vmin1) AND (vmax=vmax1) THEN
         ELSE (* не совподает динамический диапазон *) GOTO con ; END ;

(* считываем тарировочные характеристики *)
   FIO.Seek(ff1,LONGCARD(nach1)) ;
   FOR i:=1 TO CARDINAL(kol1) DO
      j:=FIO.RdBin(ff1,tx[i],4) ;
   END ; (* FOR *)

(*  закрываем файл с характеристиками *)
   FIO.Close(ff1) ;

(* открываем файл для записи *)
   ff1:=FIO.Open(file) ;
   FIO.Seek(ff1,LONGCARD(nach)) ;
   MO:=0. ;
   max:=MIN(REAL) ;
   min:=MAX(REAL) ;
(* цикл проведения через тарировки *)
   FOR i:=1 TO CARDINAL(kol) DO
      (* читаем *)
      j:=FIO.RdBin(ff,x,4) ;
      IF (x<0.) OR (x>REAL(kol1)) THEN (* не правильный формат данных *)
                                                  GOTO con ; END ;
      (* преобразовываем *)
      j:=CARDINAL(x) ;
      x:=tx[j] ;
      (* вычисляем статистические характеристики *)
      MO:=MO+x ;
      IF x>max THEN
            max:=x ;
      END ; (* IF *)
      IF x<min THEN
            min:=x
      END ; (* IF *)
      (* пишем *)
      FIO.WrBin(ff1,x,4) ;
   END ; (* FOR *)

(* запись статистики *)

   MO:=MO/REAL(kol) ;
   FIO.Seek(ff1,36) ;
   FIO.WrBin(ff1,min,4) ;
   FIO.WrBin(ff1,max,4) ;
   FIO.WrBin(ff1,MO,4) ;

con :

   FIO.Close(ff)  ;
   FIO.Close(ff1) ;

END tarir.
