IMPLEMENTATION MODULE Gra ;
           IMPORT SYSTEM,Lib,Str ;

VAR ii : CARDINAL ;

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

PROCEDURE Set1Char(kolon,strok,Simv:SHORTCARD;Kol:CARDINAL;Cvet:SHORTCARD) ;
   VAR r            : SYSTEM.Registers ;

BEGIN r.AH := 2     ; (* установка курсора                     *)
      r.BH := 1     ; (* текущая видео страница                *)
      r.DH := strok ; (* текстовая строка,начинаем считать с 0 *)
      r.DL := kolon ; (* текстовая колонка (поз.курс.в строке) *)
   Lib.Intr(r,10H);
      r.AH := 9    ;  (* зап.символа в текущей поз. кур *)
      r.AL := Simv ;
      r.BH := 1    ;  (* текущая видео страница        *)
      r.BL := Cvet ;  (* цвет символа ( XOR если +80H) *)
      r.CX := Kol  ;  (* кол-во выводимых символов     *)
   Lib.Intr(r,10H);
END Set1Char ;

BEGIN
      FOR ii:=0 TO 5 DO
                 NomIzobr[ii].Nom  := 0 ;
                 NomIzobr[ii].addr := ADR(Buffer) ;
      END ;
END Gra.