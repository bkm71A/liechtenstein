MODULE longfile;
    (* Pисуем синус на консоли или пеpедаем его по RS232 *)
FROM SYSTEM IMPORT Out,In ;

            IMPORT FIO,MATHLIB,IO,Lib;
CONST Nach_data = 105 ;
      pi  = 3.141592 ;
      kol = 65000. ;

VAR  x1,x2,i,j  : CARDINAL ;
     massiv1    : ARRAY[0..640] OF CARDINAL ;
     massiv2    : ARRAY[0..640] OF CARDINAL ;
     amp,a,chas,mat  : LONGREAL ;

     OT,OTT   : CHAR ;

     kol_t : LONGCARD ;
     re,per,min,max : REAL ;
     f        : FIO.File ;

BEGIN
(*Graph.EGAGraphMode;*)

a:=0. ;     (* минимальное значение пилы *)
amp  := 16. ; (* амплитуда сигнала *)
chas := 80. ; (* частота дискретизации *)

min := MAX(REAL) ;
max := 0. ;

f:=FIO.Create('d:\data\longfile.dat') ;
FOR i:=0 TO Nach_data-1 DO
    FIO.WrBin(f,0,1)
END ;

(*  per:= 249. ; (* начало *)
*)
LOOP
(*  per := REAL(amp)+
    REAL(amp*MATHLIB.Sin(LONGREAL(a/chas))*MATHLIB.Sin(LONGREAL(40.*a/chas))) ;*)

  per:= REAL(amp)+REAL(amp)*REAL(MATHLIB.Sin(LONGREAL(2.*pi*a/(65000./512.) )))
                 +REAL(amp)*REAL(MATHLIB.Sin(LONGREAL(pi/2.*a/(65000./512.) )))
                 +REAL(amp/4.)*REAL(MATHLIB.Sin(LONGREAL(20.*pi*a/(65000./512.) ))) ;

(*  per:= REAL(amp)*REAL(MATHLIB.Sin(LONGREAL((2.*pi*a/(kol*2.)+pi/2.) )) ) ;*)
(*  per:= REAL(amp)*REAL(MATHLIB.Sin(LONGREAL(a/chas)))+REAL(a) ;*)
(*  per:=REAL(a)+1. ; *)
(*  per:=REAL(a) ; *)
(*  per:=per+1. ;*)
  x1 := INTEGER(per) +150 ; (* для вывода на экран графика *)

(*  IF (a=454.) OR (a=454.+768.) OR (a=454.+768.*2.) OR (a=454.+768.*3.)
     OR (a=454.+768.*4.) OR (a=454.+768.*5.) OR (a=454.+768.*6.) OR (a=454.+768.*7.)
     OR (a=454.+768.*8.) OR (a=454.+768.*9.)  THEN
     re:=per+23. ;
     FIO.WrBin(f,re,4) ;
     per:=per+1. ;
     a:=a+1. ;
     re:=per+23. ;
     FIO.WrBin(f,re,4) ;
     per:=per+1. ;
     a:=a+1. ;
     re:=per+23. ;
     FIO.WrBin(f,re,4) ;
     per:=per+1. ;
     a:=a+1. ;
  END ; (* IF *)
*)
  FIO.WrBin(f,per,4) ;

(*  per:=per+1. ;*)
(*  IF per > 376. THEN per:=249. ; END ; (* IF *)
*)


(*    Graph.Plot(i,massiv1[i],0);
    massiv1[i]:=x1 ;
    Graph.Plot(i,x1,15);
*)
(* IF IO.KeyPressed() THEN OT:=IO.RdCharDirect() ;
                         CASE OT OF
                          | CHR(0)  : OT :=IO.RdCharDirect() ;
           CASE OT OF
             CHR(50H) :  IF amp>=1.   THEN amp:=amp-1. END
           | CHR(48H) :  IF amp<=500. THEN amp:=amp+1. END
           | CHR(4BH) :  IF chas>=2.  THEN chas:=chas-1. END
           | CHR(4DH) :                    chas:=chas+1.
(*           | CHR(0A0H) :  IF amp>=1.   THEN amp:=amp-10. END
(*           END ;
           CASE OT OF   *)
           | CHR(98H) :  IF amp<=500. THEN amp:=amp+10. END *)
           | CHR(4FH) :  IF chas>=2.  THEN chas:=chas-34. END
           | CHR(51H) :                    chas:=chas+34.
            END  ;
                          | CHR(27) : EXIT
                          END ;
                     END ;
*)
(* IF i>=640 THEN i := 0
           ELSE INC(i)
 END ; (* if *)
*)
 a:=a+1. ;
 IF a>=kol THEN EXIT END ;
END ; (* loop *)

mat   := 0. ;
kol_t := 0 ;
FIO.Seek(f,LONGCARD(Nach_data)) ;
LOOP            (* определяем минимум максимум *)
    i:=FIO.RdBin(f,per,4) ;
    IF FIO.EOF THEN EXIT END ;
    IF per>max THEN max := per END  ;
    IF per<min THEN min := per END  ;
    INC(kol_t) ;
    mat:=mat+LONGREAL(per) ;
END ;
mat := mat / LONGREAL(kol_t) ;


FIO.Seek(f,0) ;
FIO.WrBin(f,34,2) ; (* индекс начала поля "СЛУЖЕБНАЯ ИНФОРМАЦИЯ" /всегда 34/ *)

FIO.WrBin(f,'11/11/11',8) ;
FIO.WrBin(f,'KOLO',4) ;
re := 1111. ;
FIO.WrBin(f,re,4) ;   (* время начала участка ввода *)
re := 2222. ;
FIO.WrBin(f,re,4) ;   (* время конца  участка ввода *)
re := REAL(chas)   ;     (* частота дискретизации *)
FIO.WrBin(f,re,4) ;      (* записываем частоту дискретизации REAL *)
FIO.WrBin(f,kol_t,4) ;   (* количество точек реализации *)
FIO.WrBin(f,0,2) ;       (* прореживание *)

FIO.Seek(f,32) ;
FIO.WrBin(f,Nach_data,2) ; (* начало пола "ДАННЫЕ" *)
FIO.WrBin(f,'SW',2);(* идентификатор файла данных 'SW' /всегда/*)
FIO.WrBin(f,min,4) ;  (* пишем минимум *)
FIO.WrBin(f,max,4) ;  (* пишем максимум *)
re := REAL(mat) ;
FIO.WrBin(f,re,4) ;   (* матожидание *)

FIO.Seek(f,80) ;      (* записываем наименование осей 2 STRING всего 16 байт *)
FIO.WrStr(f,' sec') ; FIO.WrBin(f,0DH,1) ;
(*FIO.WrStr(f,'');*)  FIO.WrBin(f,0DH,1) ;

FIO.Seek(f,96) ;
FIO.WrBin(f,10,1) ;

min:=-5.0 ;
FIO.WrBin(f,min,4);
min:=5.0 ;
FIO.WrBin(f,min,4) ;

FIO.Close(f) ;
END longfile.

