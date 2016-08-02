IMPLEMENTATION MODULE Etiketka ;

              IMPORT SYSTEM,Lib,Str  ,FIO ;
FROM IO       IMPORT RdCharDirect,KeyPressed ;

FROM Gra      IMPORT Get_Image,Put_Image,WriteStr,BoxFull,Box,SetChar ;
FROM mouse    IMPORT Wait,MousFunc,Trigger,r ;

VAR  ff    : FIO.File ;
     Bufer : ARRAY[0..2047+FIO.BufferOverhead] OF BYTE ;

PROCEDURE OutPut_Eticet_Screen(file_name : ARRAY OF CHAR ) ; FORWARD ;

PROCEDURE Paint_Box(a,b : CARDINAL) ;
BEGIN  BoxFull(68,141,572,195,0) ;
       BoxFull(68+4,141+4,572-4,195-4,a) ;
       Box(68,141,572,195,b) ;
END Paint_Box ;

PROCEDURE Error(aa : CARDINAL) ;
BEGIN Get_Image(68,141,572,195) ;
      Lib.Sound(400) ;
      Paint_Box(4,15) ;
      WriteStr(0,10,11,8AH,'О Ш И Б К А !');
      CASE aa OF 1 : WriteStr(0,26,11,8BH,'Формат данных не соответствует требуемому.');
               | 2 : WriteStr(0,26,11,8BH,'Отмеченных файлов не может быть более 32-ух.');
               | 3 : WriteStr(0,26,11,8BH,'Не было определено устройство ввода данных.');
               | 4 : WriteStr(0,30,11,8BH,'Не определены файлы для обработки.');
               | 5 :

               |80H: WriteStr(0,30,11,8BH,'Диск защищен от записи')
               |82H: WriteStr(0,32,11,8BH,'Устройство не готово');
               |89H: WriteStr(0,29,11,8BH,'На принтере конец бумаги') ;
      ELSE           WriteStr(0,28,11,8BH,'Ошибка при работе с диском') ;
      END ;
      Lib.NoSound  ;
      WriteStr(0,22,12,83H,'для продолжения нажмите любую клавишу');
      Trigger ;
      Wait ;
      Put_Image(68,141,572,195) ;
END Error ;

PROCEDURE Warning(aa : CARDINAL): BOOLEAN ;
VAR zavershit : BOOLEAN ;
BEGIN Get_Image(68,141,572,195) ;
      Get_Image(0,336,630,349)  ; (* сохраняем строку подсказки *)
      Lib.Sound(1000) ;
      Paint_Box(1,0AH) ;
      WriteStr(0,26,11,8CH,'П Р Е Д У П Р Е Ж Д Е Н И Е.') ;
      CASE aa OF 1 : WriteStr(0,11,12,8AH,'Процесс рассчета и автоматической коррекции приостановлен.');
                     BoxFull(352,336,630,349,6) ;
                     WriteStr(0,44,24,8BH,'завершить пакетную обработку');
                |2 :
      END ;
      Lib.NoSound  ;
      Trigger ;
      LOOP
          MousFunc(3,0,0,0) ;     (* была ли нажата "Esc" *)
          IF r.BX=4             THEN zavershit := TRUE ; EXIT END ;
          IF (r.BX=2)OR(r.BX=1) THEN zavershit := FALSE; EXIT END ;
      END ; (* loop *)

      Put_Image(0,336,630,349)  ; (* восстанавливаем строку подсказки *)
      Put_Image(68,141,572,195) ;
      MousFunc(5,2,0,0) ;  (* сбросили счетчик если нажимали средн.клав. *)
      RETURN zavershit ;
END Warning ;


PROCEDURE Analiz (file_name : ARRAY OF CHAR ) : BOOLEAN ;
VAR  ident    : ARRAY [0..2] OF CHAR ;
     CH,index : CARDINAL ;
BEGIN
   ident[HIGH(ident)] :=CHR(0) ;
   ff:=FIO.Open(file_name) ;
   FIO.AssignBuffer(ff,Bufer) ;
   CH := FIO.RdBin(ff,index,2) ;
   FIO.Seek(ff,LONGCARD(index)); (* устанавливаем указ. на начало СЛУЖ. ИНФ. *)
   (* идентификатор файла обработки *)
   CH:=FIO.RdBin(ff,ident,2) ;
   FIO.Close(ff) ;
   IF Str.Match(ident,'SW') THEN RETURN TRUE
                            ELSE (* неправильный формат данных в файле *)
                                 Error(1) ;
                                 RETURN FALSE
   END ; (* IF *)
END Analiz ;

PROCEDURE Prosmotr(file_name: ARRAY OF CHAR ) ;
VAR ident    : ARRAY [0..2] OF CHAR ;
    CH,index : CARDINAL ;
BEGIN
      ident[HIGH(ident)] :=CHR(0) ;
      ff:=FIO.Open(file_name) ;
      FIO.AssignBuffer(ff,Bufer) ;
      CH:= FIO.RdBin(ff,index,2) ;  (* определили инд. служебной информ. *)
      FIO.Seek(ff,LONGCARD(index)) ;

      CH:=FIO.RdBin(ff,ident,2) ;   (* идентификатор файла обработки *)
      FIO.Close(ff) ;
      IF Str.Match(ident,'SW')
      THEN   (* правильный формат данных в файле *)
           Get_Image(68,141,572,195) ;
           Paint_Box(1,0AH) ;
           WriteStr(0,38,11,8CH,'ЖДИТЕ !');
           WriteStr(0,26,12,86H,'идет распаковка этикетки файла');
                   (* распаковка и вывод этикетки файла *)
           OutPut_Eticet_Screen(file_name) ;
      ELSE                            (* неправильный формат данных в файле *)
           Error(1) ;
      END ; (* IF *)
      Trigger ;
END Prosmotr ;

PROCEDURE OutPut_Eticet_Screen(file_name : ARRAY OF CHAR ) ;
(*****************************************************)
(*              просмотр этикетки !!!!!!!!            *)
(*****************************************************)
CONST shabl1 ='время начала участка ввода|'+
              'время конца участка ввода|'+
              'частота дискретизации|'+
              'количество точек реализации|'+
              'прореживание|'+
              'минимум|'+
              'максимум|'+
              'матожидание|'+
              'дистанция прохода|' ;
      shabl2 ='статистическая обработка|'+
              'сглаживанием окном Тьюки|'+
              'автокорреляционная обрабoт|'+
              'дифференцирование|'+
              'интегрирование|'+
              'фильтрация в полосе частот|'+
              'спектр|'+
              'спектральная плотность|'+
              'сглаживание по Хеммингу|'+
              'сглаживание по Хеннингу|'+
              'сглаживание по ансамблю|'+
              'сглаживание по частотам|'+
              'устранение выбросов|'+
              'устранение тренда|'+
              'калибровка|'+
              'тарировка|' ;

VAR
    index    : CARDINAL ; (* индекс начала служебной информации *)
    stroka   : ARRAY[0..25] OF CHAR ;
    Perem    : ARRAY[0.. 9] OF REAL ;
    Long     : LONGCARD ;

    data     : ARRAY [0..8] OF CHAR ; (* дата эксперимента *)
    objekt   : ARRAY [0..4] OF CHAR ; (* объект *)

    obr      : CARDINAL ;

    filtr1   : REAL     ; (* нижняя граница фильтрации *)
    filtr2   : REAL     ; (* верхняя граница фильтрации *)
    distan   : CARDINAL ; (* дистанция прохода *)

    i,j,CH   : CARDINAL ;
    ok       : BOOLEAN ;
    ot       : CHAR ;

BEGIN
      data  [HIGH(data)]   :=CHR(0) ;
      objekt[HIGH(objekt)] :=CHR(0) ;
      ff:=FIO.Open(file_name) ;
      FIO.AssignBuffer(ff,Bufer) ;
(* заполнение фона 2-й страницы экрана *)
      SYSTEM.Out(3CEH,1)  ;    (* разрешаем запись во все битовые плоскости *)
      SYSTEM.Out(3CFH,0EH) ;
         Lib.WordFill([0A800H:0000H],14000,0FFFFH) ;
      SYSTEM.Out(3CEH,1) ;    (* восстанавливаем ВСЕ *)
      SYSTEM.Out(3CFH,0) ;
(* окантовочка всего экрана *)
      SetChar(1, 0,0,SHORTCARD('╒'),1,8AH) ;
      SetChar(1, 1,0,SHORTCARD('═'),34,8AH) ;
      SetChar(1,45,0,SHORTCARD('═'),34,8AH) ;
      SetChar(1,79,0,SHORTCARD('╕'),1,8AH) ;
      FOR i := 1 TO 23 DO
          SetChar(1, 0,SHORTCARD(i),SHORTCARD('│'),1,8AH) ;
          SetChar(1,79,SHORTCARD(i),SHORTCARD('│'),1,8AH) ;
      END ;
      SetChar(1,0,24,SHORTCARD('╘'),1,8AH) ;
      SetChar(1,79,24,SHORTCARD('╛'),1,8AH) ;
      SetChar(1, 1,24,SHORTCARD('═'),15,8AH) ;
      SetChar(1,64,24,SHORTCARD('═'),15,8AH) ;
         SetChar(1,1,16,SHORTCARD('─'),46,86H) ;
         SetChar(1,1,19,SHORTCARD('─'),46,86H) ;
         SetChar(1,1,21,SHORTCARD('─'),46,86H) ;
(* окантовочка поля методов обработки *)
      SetChar(1,47,6,SHORTCARD('╒'),1,8BH) ;
      SetChar(1,48,6,SHORTCARD('═'),6,8BH) ;
      SetChar(1,72,6,SHORTCARD('═'),6,8BH) ;
      SetChar(1,78,6,SHORTCARD('╕'),1,8BH) ;
      FOR i := 7 TO 22 DO
          SetChar(1,47,SHORTCARD(i),SHORTCARD('│'),1,8BH) ;
          SetChar(1,78,SHORTCARD(i),SHORTCARD('│'),1,8BH) ;
      END ;
      SetChar(1,47,23,SHORTCARD('╘'),1,8BH) ;
      SetChar(1,78,23,SHORTCARD('╛'),1,8BH) ;
      SetChar(1,48,23,SHORTCARD('═'),30,8BH) ;

(* формирование заглавия *)
      WriteStr(1,36,0,8CH,'ЭТИКЕТКА') ;
      WriteStr(1,31,1,8CH,'файл') ;
      WriteStr(1,37,1,8FH,file_name) ;
      WriteStr(1,18,24,86H,'для продолжения работы нажмите любую клавишу') ;
(* формирование данных из имени файла *)
   Str.Slice(stroka,file_name,1,2) ;
      WriteStr(1,9,4,8AH,'номер режима');
      WriteStr(1,23,4,8CH,stroka);
   Str.Slice(stroka,file_name,3,2) ;
      WriteStr(1,30,4,8AH,'номер подрежима');
      WriteStr(1,47,4,8CH,stroka);
   Str.Slice(stroka,file_name,5,3) ;
      WriteStr(1,55,4,8AH,'номер канала');
      WriteStr(1,69,4,8CH,stroka);

(* чтение этикетки *)
      CH:=FIO.RdBin(ff,index,2) ;   (* индекс начала служебной информации *)
      CH:=FIO.RdBin(ff,data,8) ;    (* дата эксперимента *)
   WriteStr(1,15,3,8AH,'дата эксперимента') ;
   WriteStr(1,34,3,8CH,data)  ;
      CH:=FIO.RdBin(ff,objekt  ,4) ; (* объект *)
   WriteStr(1,55,3,8AH,'объект') ;
   WriteStr(1,63,3,8CH,objekt) ;
      CH:=FIO.RdBin(ff,Perem[0],4) ; (* время начала участка ввода *)
      CH:=FIO.RdBin(ff,Perem[1],4) ; (* время конца участка ввода *)
      CH:=FIO.RdBin(ff,Perem[2],4) ; (* частота дискретизации *)
      CH:=FIO.RdBin(ff,Long    ,4) ; (* количество точек реализации *)
          Perem[3] :=REAL(Long) ;
      CH:=FIO.RdBin(ff,j,2)        ; (* прореживание *)
          Perem[4] :=REAL(j) ;

      CH:=FIO.RdBin(ff,j,2) ; (*индекс начала эксперим. данных- уже анализир.*)
      FIO.Seek(ff,LONGCARD(index)) ;
      CH:=FIO.RdBin(ff,j,2) ; (*идентификатор файла обработки - уже анализир.*)
      CH:=FIO.RdBin(ff,Perem[5],4) ; (* минимум  *)
      CH:=FIO.RdBin(ff,Perem[6],4) ; (* максимум *)
      CH:=FIO.RdBin(ff,Perem[7],4) ; (* матожидание *)
      CH:=FIO.RdBin(ff,obr,2) ;      (* 2 байта обработки *)
      CH:=FIO.RdBin(ff,filtr1,4)   ; (* нижняя граница фильтрации *)
      CH:=FIO.RdBin(ff,filtr2,4)   ; (* верхняя граница фильтрации *)
      CH:=FIO.RdBin(ff,j,2)        ; (* дистанция прохода *)
          Perem[8] :=REAL(j) ;
      FIO.Close(ff) ;

(* вывод этикетки *)
     j  := 0 ;
     LOOP
         Str.ItemS(stroka,shabl1,'|',j) ;
         IF Str.Length(stroka)=0 THEN EXIT END ;
         WriteStr(1,2,SHORTCARD(7+j),8AH,stroka) ;
         CASE j OF 3,4,8 : Str.CardToStr(LONGCARD(Perem[j]),stroka,10,ok) ;
                           i:=31
                     ELSE  Str.RealToStr(LONGREAL(Perem[j]),10,FALSE,stroka,ok) ;
                           i:=30
         END ;
         WriteStr(1,SHORTCARD(i),SHORTCARD(7+j),8CH,stroka) ;
         INC(j) ;
     END ; (* loop *)

(*   текст для вывода методов обработки      *)
(* и распаковка двух байтов метода обработки *)
    WriteStr(1,55,6,8BH,'МЕТОДЫ ОБРАБОТКИ') ;
         (* рисуем каемочку для ВИДА ОБРАБОТКИ *)
    i:= 0 ; CH:= 1 ;
    LOOP
         Str.ItemS(stroka,shabl2,'|',i) ;
         IF Str.Length(stroka)=0 THEN EXIT END ;
         WriteStr(1,48,SHORTCARD(7+i),8AH,stroka) ;
         j:=CARDINAL(BITSET(obr)*BITSET(CH)) ;
         IF j=0 THEN
              WriteStr(1,75,SHORTCARD(7+i),8AH,'НЕТ')
         ELSE WriteStr(1,75,SHORTCARD(7+i),8CH,'ДА') ;
              IF CH=20H THEN (* если есть фильтрация то определяем границы *)
                    WriteStr(1,5,17,8AH,'нижняя  граница фильтра') ;
                     Str.RealToStr(LONGREAL(filtr1),10,FALSE,stroka,ok) ;
                    WriteStr(1,30,17,8CH,stroka) ;
                    WriteStr(1,5,18,8AH,'верхняя граница фильтра') ;
                     Str.RealToStr(LONGREAL(filtr2),10,FALSE,stroka,ok) ;
                    WriteStr(1,30,18,8CH,stroka) ;
              END ; (* if   фильтрации *)
(*            IF  для файлов .SPL и .SPR   *)
         END ; (* IF *)
         CH:=CH<<1 ;   INC(i) ;
    END ; (* loop *)

    r.AX := 0501H ;  Lib.Intr(r,10H) ;
    Put_Image(68,141,572,195) ;

    j := 0 ;
    LOOP                                          (* мигает строка внизу *)
         IF KeyPressed() THEN ot := RdCharDirect() ; EXIT END ;
         MousFunc(3,0,0,0) ;
         IF r.BX#0 THEN EXIT END ;
         IF j<=440 THEN
              INC(j)
         ELSE j:=0 ;
              WriteStr(1,18,24,86H,'для продолжения работы нажмите любую клавишу') ;
         END ;
    END ;
    r.AX := 0500H ;  Lib.Intr(r,10H);
END OutPut_Eticet_Screen ;

END Etiketka.