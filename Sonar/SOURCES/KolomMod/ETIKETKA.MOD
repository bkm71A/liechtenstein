IMPLEMENTATION MODULE Etiketka ;

              IMPORT Graph,SYSTEM,Lib,Str  ,FIO ;
FROM IO       IMPORT RdCharDirect,KeyPressed ;

FROM Gra      IMPORT Set_Out_Adapter,WriteStr,
                     BoxFull,Box,SetChar ;
FROM mouse    IMPORT Wait,MousFunc,MousGet,Trigger,r,answ_mouse ;
              IMPORT AsmImage,FILE ;

TYPE  asas   = ARRAY[0..1],[0..28] OF CHAR ;

CONST Dlja   = 'для продолжения нажмите любую клавишу';

                (* сохранение между первой и второй страницей *)
PROCEDURE SavePiceImage(A0:CARDINAL) ;
CONST X1 = 68 ; Y1 = 141;
      X2 = 572; Y2 = 195;
VAR i,b,rr,nn : CARDINAL ;
    ofs1,ofs2 : CARDINAL ;
BEGIN nn := Y1*80+(X1>>3); (* нaчало изображения *)
      rr := ((X2>>3)-(X1>>3))+1 ;
     b:=28080 ;
     SYSTEM.Out(3CEH,8) ;  (* регистр маски *)
     SYSTEM.Out(3CFH,0) ;  (* 0 запрещаем изменение битов в байте изображения *)
     FOR i:=Y1 TO Y2 DO
        Lib.Move([0A000H:nn],[A0:b],rr) ;
        nn := nn+80 ;
        b  := b +rr ;
     END ;
     Set_Out_Adapter ;
END SavePiceImage ;

PROCEDURE RestorePiceImage(A0:CARDINAL) ;
CONST X1 = 68 ; Y1 = 141;
      X2 = 572; Y2 = 195;
VAR b,i,rr,nn : CARDINAL ;
BEGIN nn := Y1*80+(X1>>3); (* начало изображения *)
      rr := ((X2>>3)-(X1>>3))+1 ;
     b := 28080 ;
     SYSTEM.Out(3CEH,8) ;  (* регистр маски *)
     SYSTEM.Out(3CFH,0) ;  (* 0 запрещаем изменение битов в байте изображения *)
     FOR i:=Y1 TO Y2 DO
        Lib.Move([A0:b],[0A000H:nn],rr) ;
        nn := nn+80 ;
        b  := b +rr ;
     END ;
     Set_Out_Adapter ;
END RestorePiceImage ;

PROCEDURE Get_Kol_Byte_Font():CARDINAL ;
BEGIN
    r.AX := 1130H ; (* дать информацию о текущем состоянии EGA  *)
    r.BH :=    1H ; (* текущий адрес фонтов EGA *)
    Lib.Intr(r,10H) ;
               (* возврат - количество байтов фонта на символ *)
    RETURN r.CX
END Get_Kol_Byte_Font ;

PROCEDURE Paint_Box(a,b : CARDINAL) ;
VAR i : CARDINAL ;
BEGIN BoxFull(68+3,141+3,572-3,195-3,a) ;
      FOR i:=0 TO 2 DO
         Box(68+i,141+i,572-i,195-i,b) ;
         IF i=0 THEN b:=0 END ;
      END;
END Paint_Box ;

PROCEDURE Error(aa : CARDINAL) ;
CONST nol = 0 ;
VAR bb,cc : SHORTCARD ;
    str   : ARRAY[0..12] OF CHAR ;
    pr    : BOOLEAN ;
LABEL con ;
BEGIN
      SavePiceImage(0A000H) ;
      Lib.Sound(300) ;
      Paint_Box(4,15) ;
      IF  Get_Kol_Byte_Font()<14 THEN
           bb:=19; cc:=3
      ELSE bb:=11; cc:=1
      END ;
      IF aa#10H THEN WriteStr(nol,10,bb,8AH,'О Ш И Б К А !') END ;
      CASE aa OF 1 : WriteStr(nol,26,bb,8BH,'Формат данных не соответствует требуемому.')
               | 2 : WriteStr(nol,24,bb,8BH,'Расширение файлa не соответствует требованиям.')
               | 3 : WriteStr(nol,26,bb,8BH,'Не было определено устройство ввода данных.')
               | 4 : WriteStr(nol,30,bb,8BH,'Не определены файлы для обработки.')
               | 5 : WriteStr(nol,30,bb,8BH,'В памяти нет места для загрузки оверлея.')
               | 6 : WriteStr(nol,25,bb,8BH,'Нет возможности загрузить оверлей. Код ') ;

               | 7 : WriteStr(nol,32,bb,8BH,'На диске недостаточно места.') ;
               | 8 : WriteStr(nol,32,bb,8BH,'Устройство печати не готово');

               |10H: WriteStr(nol,10,bb,8AH,'Данный режим предназначен для дальнейшего расширения системы')

               |80H: WriteStr(nol,30,bb,8BH,'Диск защищен от записи')
               |82H: WriteStr(nol,32,bb,8BH,'Устройство не готово');
               |89H: WriteStr(nol,29,bb,8BH,'На принтере конец бумаги') ;
      ELSE           WriteStr(nol,28,bb,8BH,'Ошибка при работе с диском') ;
      END ;
      Lib.NoSound ;
      IF aa=8 THEN (* Blinc_ImageMouse2(st) ; *) GOTO con
      ELSE         WriteStr(nol,22,bb+cc,83H,Dlja)
      END ;
      Trigger ;
      Wait ;
con :
     RestorePiceImage(0A000H) ;
END Error ;


PROCEDURE One_Minute_On ;
BEGIN SavePiceImage(0A800H) ;
      Paint_Box(1,0AH) ;
      AsmImage.WriteStr_XY(0,210,165,8CH,'прийдется немного подождать...') ;
END One_Minute_On ;

PROCEDURE One_Minute_Off ;
BEGIN RestorePiceImage(0A800H) ;
END One_Minute_Off ;


PROCEDURE Analiz (file_name : ARRAY OF CHAR ) : BOOLEAN ;
VAR  ident    : ARRAY [0..2] OF CHAR ;
     CH,index : CARDINAL ;
     ff       : FIO.File ;
     Bufer    : ARRAY[0..1*512+FIO.BufferOverhead] OF BYTE ;
BEGIN
   ident[HIGH(ident)] :=CHR(0) ;
   ff:=FIO.Open(file_name) ;
   FIO.AssignBuffer(ff,Bufer) ;
   CH := FIO.RdBin(ff,index,2) ;
   FIO.Seek(ff,LONGCARD(index)); (* устанавливаем указ. на начало СЛУЖ. ИНФ. *)
   (* идентификатор файла обработки *)
   CH:=FIO.RdBin(ff,ident,2) ;
   FIO.Close(ff) ;
   IF (ident[0]='S')AND(ident[1]='W') THEN (* 'SW' присутствует в файле *)
      RETURN TRUE
   ELSE (* неправильный формат данных в файле *)
      Error(1) ;
      RETURN FALSE
   END ; (* IF *)
END Analiz ;


END Etiketka.