IMPLEMENTATION MODULE Etiketka;

IMPORT FIO,Str;
FROM Window    IMPORT WinDef,WinType,Open,Close,Color,TextColor,TextBackground,
                      PutOnTop,FrameStr,GotoXY;
FROM IO        IMPORT WrStr,RdCharDirect;
FROM SearchFl  IMPORT FullPath;

PROCEDURE title(file_name : ARRAY OF CHAR ) ;
(*****************************************************)
(*              просмотр этикетки !!!!!!!!           *)
(*****************************************************)

CONST shabl1 ='время начала участка ввода(с)|'+
              'время конца участка ввода (с)|'+
              'частота дискретизации (Гц)|'+
              'количество точек реализации|'+
              'прореживание|'+
              'минимум|'+
              'максимум|'+
              'матожидание|'+
              'дистанция прохода (м)|' ;
      shabl2 ='сглаживание по базе|'+
              'сглаживание окном Тьюки|'+
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
    s1      = FrameStr('╒═╕││╘═╛') ;
   type_dat = '\type_dat' ;

VAR index    : CARDINAL ; (* индекс начала служебной информации *)
    stroka   : ARRAY[0..28] OF CHAR ;

    Perem    : ARRAY[0.. 9] OF REAL ;
    Long     : LONGCARD ;

    data     : ARRAY [0..7] OF CHAR ; (* дата эксперимента *)
    objekt   : ARRAY [0..4] OF CHAR ; (* объект *)

    obr      : CARDINAL ;

    filtr1   : REAL     ; (* нижняя граница фильтрации *)
    filtr2   : REAL     ; (* верхняя граница фильтрации *)
    distan   : CARDINAL ; (* дистанция прохода *)

    i,j,CH   : CARDINAL ;
    ok,bool  : BOOLEAN ;
    ot       : CHAR ;
    ff,f     : FIO.File ;
    AA       : WinDef ;
    Aaa      : WinType ;

BEGIN
AA:=WinDef(0,0,79,24,LightCyan,Blue,FALSE,FALSE,TRUE,TRUE,s1,LightCyan,Blue) ;
   Aaa:=Open(AA) ;
   data  [HIGH(data)]   :=CHR(0) ;
   objekt[HIGH(objekt)] :=CHR(0) ;
   ff:=FIO.Open(file_name) ;
(* окантовочка всего экрана *)
   TextColor(LightGray) ;
   FOR i:=1 TO 46 DO
      GotoXY(i,16) ; WrStr('─') ;
      GotoXY(i,19) ; WrStr('─') ;
      GotoXY(i,21) ; WrStr('─') ;
   END ; (* FOR *)
(* окантовочка поля методов обработки *)
   TextColor(LightGreen) ;
   GotoXY(47,6) ;  WrStr('╒') ;
   GotoXY(48,6) ;  WrStr('══════') ;
   GotoXY(72,6) ;  WrStr('══════') ;
   GotoXY(78,6) ;  WrStr('╕') ;
   FOR i := 7 TO 22 DO
      GotoXY(47,i) ; WrStr('│') ;
      GotoXY(78,i) ; WrStr('│') ;
   END ;
   GotoXY(47,23) ;  WrStr('╘') ;
   GotoXY(78,23) ;  WrStr('╛') ;
   FOR i := 48 TO 77 DO
      GotoXY(i,23) ;  WrStr('═') ;
   END ; (* FOR *)
(* формирование заглавия *)
   TextColor(LightMagenta) ;
   GotoXY(35,0) ; WrStr(' ЭТИКЕТКА ') ;
   TextColor(LightCyan) ;
   GotoXY(31,1) ;   WrStr('файл') ;
   TextColor(Yellow) ;
   GotoXY(37,1) ;   WrStr(file_name) ;
(* расшифровываем тип датчика *)
   Str.Concat(stroka,FullPath,type_dat) ; (* сформировали полный путь type_dat *)
   f:=FIO.Open(stroka) ;
   IF FIO.IOresult()=0 THEN
      TextColor(LightCyan) ;
       GotoXY(15,2) ; WrStr('вид эксперим. данных') ;
       LOOP FIO.RdStr(f,stroka) ;
            IF stroka[0]=file_name[0] THEN
              Str.Delete(stroka,0,4) ;
              TextColor(Yellow) ;
              GotoXY(38,2) ; WrStr(stroka) ; EXIT
            END ;
            IF FIO.EOF THEN
                TextColor(Yellow) ;
                GotoXY(38,2) ; WrStr('не идентифицирован') ; EXIT
            END ;
       END ;
       FIO.Close(f) ;
   END ;
(* формирование данных из имени файла *)
   Str.Slice(stroka,file_name,1,2) ;
   TextColor(LightCyan) ;
   GotoXY(9,4) ;  WrStr('номер режима');
   TextColor(LightMagenta) ;
   GotoXY(23,4) ; WrStr(stroka);
   Str.Slice(stroka,file_name,3,2) ;
   TextColor(LightCyan) ;
   GotoXY(30,4) ; WrStr('номер подрежима');
   TextColor(LightMagenta) ;
   GotoXY(47,4) ; WrStr(stroka);
   Str.Slice(stroka,file_name,5,3) ;
   TextColor(LightCyan) ;
   GotoXY(55,4) ; WrStr('номер канала');
   TextColor(LightMagenta) ;
   GotoXY(69,4) ; WrStr(stroka);
(* чтение этикетки *)
   CH:=FIO.RdBin(ff,index,2) ;   (* индекс начала служебной информации *)
   CH:=FIO.RdBin(ff,data,8) ;    (* дата эксперимента *)
   TextColor(LightCyan) ;
   GotoXY(15,3) ; WrStr('дата эксперимента') ;
   TextColor(LightMagenta) ;
   GotoXY(34,3) ; WrStr(data)  ;
   CH:=FIO.RdBin(ff,objekt  ,4) ; (* объект *)
   TextColor(LightCyan) ;
   GotoXY(55,3) ; WrStr('объект') ;
   TextColor(LightMagenta) ;
   GotoXY(63,3) ; WrStr(objekt) ;
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
   CH:=FIO.RdBin(ff,Perem[9],4);
   FIO.Close(ff) ;
(* вывод этикетки *)
   j  := 0 ;
   LOOP
      Str.ItemS(stroka,shabl1,'|',j) ;
      IF Str.Length(stroka)=0 THEN EXIT END ;
      TextColor(LightCyan) ;
      GotoXY(2,(7+j)) ; WrStr(stroka) ;
      CASE j OF 3,4,8 : Str.CardToStr(LONGCARD(Perem[j]),stroka,10,ok) ;
                        i:=32 ;
          ELSE  Str.RealToStr(LONGREAL(Perem[j]),10,FALSE,stroka,ok) ;
                        i:=31 ;
      END ;
      TextColor(LightMagenta) ;
      GotoXY(i,(7+j)) ; WrStr(stroka) ;
      INC(j) ;
   END ; (* loop *)

(*   текст для вывода методов обработки      *)
(* и распаковка двух байтов метода обработки *)
   TextColor(LightGreen) ;
   GotoXY(55,6) ; WrStr('МЕТОДЫ ОБРАБОТКИ') ;
         (* рисуем каемочку для ВИДА ОБРАБОТКИ *)
   i:= 0 ; CH:= 1 ;
   LOOP
      Str.ItemS(stroka,shabl2,'|',i) ;
      IF Str.Length(stroka)=0 THEN EXIT END ;
      TextColor(LightCyan) ;
      GotoXY(48,(7+i)) ; WrStr(stroka) ;
      j:=CARDINAL(BITSET(obr)*BITSET(CH)) ;
      IF j=0 THEN
            TextColor(LightCyan) ;
            GotoXY(75,(7+i)) ; WrStr('НЕТ') ;
         ELSE
            TextColor(LightMagenta) ;
            GotoXY(75,(7+i)) ; WrStr('ДА') ;
            IF CH=20H THEN (* если есть фильтрация то определяем границы *)
                  TextColor(LightCyan) ;
                  GotoXY(2,17) ; WrStr('нижняя  граница фильтра') ;
                  Str.RealToStr(LONGREAL(filtr1),10,FALSE,stroka,ok) ;
                  TextColor(LightMagenta) ;
                  GotoXY(31,17) ; WrStr(stroka) ;
                  TextColor(LightCyan) ;
                  GotoXY(2,18)  ; WrStr('верхняя граница фильтра') ;
                  Str.RealToStr(LONGREAL(filtr2),10,FALSE,stroka,ok) ;
                  TextColor(LightMagenta) ;
                  GotoXY(31,18) ; WrStr(stroka) ;
            END ; (* if   фильтрации *)
(* для файлов спектральных *)
              IF (bool)AND(CH>=40H)AND(CH<=0800H) THEN
                  TextColor(LightCyan) ;
                  GotoXY(2,20) ; WrStr('pазрешение по частоте  (Гц)') ;
                  Str.RealToStr(LONGREAL(Perem[9]),10,FALSE,stroka,ok) ;
                  TextColor(LightMagenta) ;
                  GotoXY(31,20) ; WrStr(stroka) ;
                  bool:= FALSE;
              END ;

      END ; (* IF *)
      CH:=CH<<1 ;   INC(i) ;
   END ; (* loop *)
   TextColor(LightGray) ;
   TextBackground(LightBlue) ;
   GotoXY(18,24) ;
   WrStr(' для продолжения работы нажмите любую клавишу ') ;
   PutOnTop(Aaa) ;
   ot:=RdCharDirect() ;
   Close(Aaa) ;
END title;

END Etiketka.