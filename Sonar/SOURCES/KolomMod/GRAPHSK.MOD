IMPLEMENTATION MODULE GraphSk ;

IMPORT SYSTEM,Lib,Str,IO ,FIO;
FROM Graph    IMPORT HLine,Line ;

VAR
  k:        CARDINAL;
  stroka:   ARRAY[0..79]  OF CHAR;

PROCEDURE Box    (X1,Y1,X2,Y2,Col : CARDINAL) ;
BEGIN
   HLine(X1,Y1 ,X2    ,Col);
   Line (X2,Y1 ,X2,Y2 ,Col);
   HLine(X1,Y2 ,X2    ,Col);
   Line (X1,Y2 ,X1,Y1 ,Col);
END Box ;

PROCEDURE BoxFull(X1,Y1,X2,Y2,Col : CARDINAL) ;
VAR i : CARDINAL ;
BEGIN
   FOR i:=Y1  TO  Y2 DO
      HLine(X1,i,X2,Col)
   END ;
END BoxFull ;

PROCEDURE Terka(X1,Y1,X2,Y2   : CARDINAL) ;
VAR i,j      : CARDINAL ;
    VideoAdr : ADDRESS  ;
BEGIN
    j := (X2-X1) >> 3  ;
    VideoAdr:=[0A000H:Y1*80+X1>>3] ;
    FOR i:=Y1 TO Y2 DO
      Lib.Fill(VideoAdr,j,0)  ;
      Lib.IncAddr(VideoAdr,80) ;
    END ;
END Terka ;

PROCEDURE Get_Image(XX1,YY1,XX2,YY2 : CARDINAL) ;
   (****** противоположные координаты улов прямоугольного спрайта *)
   (**************** ИСПОЛЬЗУЕТСЯ БУФЕР 4 * 8кБ *******************)
VAR    Kol_word,i,j,n    : CARDINAL ;
       AdrBuf,AdrVideo,a : ADDRESS ;
BEGIN
       Kol_word :=(XX2-XX1) >> 4 + 1 ;
       j := 0 ;
       LOOP  IF (NomIzobr[j].Nom=0) OR (j>=5) THEN
                        EXIT END ;
             INC(j) ;
       END ;

       n := j + 1 ;
       NomIzobr[j].Nom :=n ;
       AdrBuf := NomIzobr[j].addr ;
       AdrVideo :=[0A000H:(YY1*80+(XX1 >> 3))] ;
       a        :=AdrVideo ;

       FOR j:=3 TO 0 BY -1 DO             (* изменяем битовые плоскости    *)
          SYSTEM.Out(3CEH,4) ;            (* регистр выбора карты чтения   *)
          SYSTEM.Out(3CFH,SHORTCARD(j)) ; (* читаем из битовой плоскости j *)

          FOR i:=0 TO YY2-YY1 DO
               Lib.WordMove(AdrVideo,AdrBuf,Kol_word) ;
               Lib.IncAddr(AdrVideo,80) ;
               Lib.IncAddr(AdrBuf,(Kol_word << 1)) ;
          END ;
          AdrVideo := a ;
       END ; (* for *)
       NomIzobr[n].addr := AdrBuf ;
END Get_Image ;

PROCEDURE Put_Image(XX1,YY1,XX2,YY2 : CARDINAL) ;
   (****** противоположные координаты улов прямоугольного спрайта *)
   (************** ИСПОЛЬЗУЕТСЯ БУФЕР 4 * 8кБ *********************)
VAR    Kol_word,i,j      : CARDINAL ;
       AdrBuf,AdrVideo,a : ADDRESS ;
BEGIN
       Kol_word :=(XX2-XX1) >> 4 + 1 ;
       j := 5 ;
       LOOP IF (NomIzobr[j].Nom#0) OR (j<=0) THEN (* поиск стека изображений *)
                 EXIT
            END ;
            DEC(j) ;
       END ;
       NomIzobr[j].Nom :=0 ;

       AdrBuf := NomIzobr[j].addr ;
       AdrVideo :=[0A000H:(YY1*80+(XX1 >> 3))] ;
       a        :=AdrVideo ;
       FOR j:=0 TO 3 DO           (* изменяем битовые плоскости    *)
          SYSTEM.Out(3CEH,8)    ; (* регистр маски *)
          SYSTEM.Out(3CFH,0FFH) ; (* разрешаем изменять все биты в байте *)
          SYSTEM.Out(3C4H,2)    ; (* регистр маски битовой плоскости *)
                                  (* разрешаем изменять изображение в плоск. *)
          SYSTEM.Out(3C5H,SHORTCARD(8>>j)) ;

          FOR i:=0 TO YY2-YY1 DO
               Lib.WordMove(AdrBuf,AdrVideo,Kol_word) ;
               Lib.IncAddr(AdrVideo,80) ;
               Lib.IncAddr(AdrBuf,(Kol_word << 1)) ;
          END ;

          AdrVideo := a ;
       END ; (* for *)
       SYSTEM.Out(3CEH,1) ;   (* регистр разрешения установки цвета *)
       SYSTEM.Out(3CFH,0) ;   (* 1 - ЗАПРЕЩАЕТ  установку цвета *)
END Put_Image ;

BEGIN
      FOR ii:= 0 TO 5 DO  NomIzobr[ii].Nom  := 0 ;
                          NomIzobr[ii].addr := ADR(Buffer) ;
      END ;
END GraphSk.