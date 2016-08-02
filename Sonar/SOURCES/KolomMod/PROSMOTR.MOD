IMPLEMENTATION MODULE prosmotr ;

FROM FIO      IMPORT WrStr, WrChar, WrLn, WrLngCard, WrReal, WrCard, WrHex, WrBin ;
              IMPORT Str,SYSTEM,Lib,FIO,IO ;
              IMPORT MATHLIB ;
FROM Graph    IMPORT GraphMode,TextMode,HLine,Line ;
FROM Gra      IMPORT Set1Char,Get_Image,Put_Image ;

TYPE g              = ARRAY [1..5] OF CHAR ;

VAR

      OK , Eng        : BOOLEAN ;
      kol             : LONGCARD ; (* количество точек реализации *)
      kol1            : ARRAY [1..5] OF CHAR ; (* количество точек реализации *)
      MIN,MAX,
      MO,D,ASSIM,
      EKC,M           : REAL ;
      MIN1,MAX1,
      MO1,D1,ASSIM1,
      EKC1, M1        : ARRAY [1..16] OF CHAR ;
      CKO             : REAL ;
      CKO1            : ARRAY [1..16] OF CHAR ;
      GIST            : ARRAY [0..15] OF CARDINAL ;
      GIST1           : ARRAY [0..15] OF g ;
PROCEDURE ramka (x1,y1,x2,y2,Color : CARDINAL) ;
      (* рисует рамку *)
BEGIN
   HLine(x1,y1,x2,Color) ;
   HLine(x1,y2,x2,Color) ;
   Line(x1,y1,x1,y2,Color) ;
   Line(x2,y1,x2,y2,Color) ;
END ramka ;

PROCEDURE kvadrat (x1,y1,x2,y2,Color: CARDINAL ) ;
      (* рисует закрашенный квадрат *)
VAR i : CARDINAL ;
BEGIN
   FOR i:=y1 TO y2 DO
      HLine(x1,i,x2,Color) ;
   END ; (* for *)
END kvadrat ;

PROCEDURE WriteStr(col,row,cwet:SHORTCARD; str:ARRAY OF CHAR);
      (* вывод строки текста на экран *)
BEGIN
   r.AX := 1300H ;              (* писать строку(АН), не трогать курсор(AL)  *)
   r.BX := CARDINAL(cwet)   ;   (* номер видео страницы [0] + атрибут строки *)
   r.CX :=  Str.Length(str) ;   (* длинна строки - считаем только символы   *)
   r.DH :=   row ;              (* строка начала вывода                     *)
   r.DL :=   col ;              (* колонка начала вывода                    *)
   r.BP := SYSTEM.Ofs(str)  ;   (*         выводимая                        *)
   r.ES := SYSTEM.Seg(str)  ;   (*            строка                        *)
   Lib.Intr(r,10H);
END WriteStr;

PROCEDURE Write1Str(col,row,cwet:SHORTCARD; str:ARRAY OF CHAR);
      (* вывод строки текста на экран *)
BEGIN
   r.AX := 1300H ;              (* писать строку(АН), не трогать курсор(AL)  *)
   r.BX := 0100H+CARDINAL(cwet);(* номер видео страницы [1] + атрибут строки *)
   r.CX :=  Str.Length(str) ;   (* длинна строки - считаем только символы   *)
   r.DH :=   row ;              (* строка начала вывода                     *)
   r.DL :=   col ;              (* колонка начала вывода                    *)
   r.BP := SYSTEM.Ofs(str)  ;   (*         выводимая                        *)
   r.ES := SYSTEM.Seg(str)  ;   (*            строка                        *)
   Lib.Intr(r,10H);
END Write1Str;



PROCEDURE analiz (file_name : ARRAY OF CHAR ) : BOOLEAN ;
VAR       p          : BOOLEAN ;
          ident      : ARRAY [1..2] OF CHAR ;
          kol        : LONGCARD ;
          index      : CARDINAL ; (* начало служебной информации *)
BEGIN
   ff:=FIO.Open(file_name) ;
   FIO.AssignBuffer(ff,buf) ;
   priznak:=FIO.RdBin(ff,index,2) ;
   FIO.Seek(ff,LONGCARD(index)) ;
   (* количество точек ркализации *)
   FIO.Seek(ff,26) ;
   priznak:=FIO.RdBin(ff,kol,4) ;
   (* идентификатор файла обработки *)
   FIO.Seek(ff,LONGCARD(index)) ;
   priznak:=FIO.RdBin(ff,ident,2) ;
   (* количество точек ркализации *)
   FIO.Seek(ff,26) ;
   priznak:=FIO.RdBin(ff,kol,4) ;
   FIO.Close(ff) ;
   IF (Str.Match(ident,'SW')) AND (NOT FIO.EOF) AND ( kol > 0) THEN
         p:=TRUE ;
      ELSE
         p:=FALSE ;
         (* неправильный формат данных в файле *)
         Lib.Sound(400) ;
         Get_Image(56,128,584,204) ;
(*         kvadrat(56,128,584,204,0) ;*)
         kvadrat(60,132,580,200,4) ;
         ramka(56,128,584,204,15) ;
         WriteStr(34,10,8BH,'О Ш И Б К А !');
         WriteStr(24,11,8BH,'неправильный формат данных в файле');
         WriteStr(22,13,83H,'для продолжения нажмите любую клавишу');
         Lib.NoSound ;
         ot:=IO.RdCharDirect() ;
         Put_Image(56,128,584,204) ;
   END ; (* IF *)

   RETURN p ;
END analiz ;

PROCEDURE prosm(file_name: ARRAY OF CHAR ) ;
VAR ident      : ARRAY [1..2] OF CHAR ;
    nach_sl    : CARDINAL ;
    kol        : LONGCARD ;
BEGIN
                    ff:=FIO.Open(file_name) ;
                    FIO.AssignBuffer(ff,buf) ;
                    priznak:=FIO.RdBin(ff,nach_sl,2) ;
                    (* количество точек ркализации *)
                    FIO.Seek(ff,26) ;
                    priznak:=FIO.RdBin(ff,kol,4) ;
                    (* идентификатор файла обработки *)
                    FIO.Seek(ff,LONGCARD(nach_sl)) ;
                    priznak:=FIO.RdBin(ff,ident,2) ;
                    FIO.Close(ff) ;
  IF (Str.Match(ident,'SW')) AND (kol>0) AND (NOT FIO.EOF) THEN
                          Get_Image(56,128,584,204) ;
                       (*   kvadrat(56,128,584,204,0) ;*)
                          kvadrat(60,132,580,200,1) ;
                          ramka(56,128,584,204,15) ;
                          WriteStr(32,11,8CH,'ПОДОЖДИТЕ НЕМНОГО !');
         WriteStr(26,12,86H,'идет распаковка этикетки файла');
(* распаковка и вывод этикетки файла *)
                     titl(file_name) ;
                        ELSE
                    (* неправильный формат данных в файле *)
                          Lib.Sound(400) ;
                          Get_Image(56,128,584,204) ;
                       (*   kvadrat(56,128,584,204,0) ;*)
                          kvadrat(60,132,580,200,4) ;
                          ramka(56,128,584,204,15) ;
                          WriteStr(34,10,8BH,'О Ш И Б К А !');
         WriteStr(24,11,8BH,'неправильный формат данных в файле');
         WriteStr(22,13,83H,'для продолжения нажмите любую клавишу');
                          Lib.NoSound ;
                          ot:=IO.RdCharDirect() ;
                          Put_Image(56,128,584,204) ;
                     END ; (* IF *)
END prosm ;

PROCEDURE titl(file_name : ARRAY OF CHAR ) ;
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
    f        : FIO.File ;
BEGIN
      data  [HIGH(data)]   :=CHR(0) ;
      objekt[HIGH(objekt)] :=CHR(0) ;
      ff:=FIO.Open(file_name) ;
      FIO.AssignBuffer(ff,buf) ;
(* заполнение фона 2-й страницы экрана *)
      SYSTEM.Out(3CEH,1) ;  (* разрешаем запись во все битовые плоскости *)
      SYSTEM.Out(3CFH,0EH) ;
         Lib.WordFill([0A800H:0000H],14000,0FFFFH) ;
      SYSTEM.Out(3CEH,1) ;  (* восстанавливаем ВСЕ *)
      SYSTEM.Out(3CFH,0) ;
(* окантовочка всего экрана *)
      Set1Char(0,0,SHORTCARD('╒'),1,8AH) ;
      Set1Char(1,0,SHORTCARD('═'),34,8AH) ;
      Set1Char(45,0,SHORTCARD('═'),34,8AH) ;
      Set1Char(79,0,SHORTCARD('╕'),1,8AH) ;
      FOR i := 1 TO 23 DO
          Set1Char(0,SHORTCARD(i),SHORTCARD('│'),1,8AH) ;
          Set1Char(79,SHORTCARD(i),SHORTCARD('│'),1,8AH) ;
      END ;
      Set1Char(0,24,SHORTCARD('╘'),1,8AH) ;
      Set1Char(79,24,SHORTCARD('╛'),1,8AH) ;
      Set1Char(1,24,SHORTCARD('═'),15,8AH) ;
      Set1Char(64,24,SHORTCARD('═'),15,8AH) ;
         Set1Char(1,16,SHORTCARD('─'),46,86H) ;
         Set1Char(1,19,SHORTCARD('─'),46,86H) ;
         Set1Char(1,21,SHORTCARD('─'),46,86H) ;
(* окантовочка поля методов обработки *)
      Set1Char(47,6,SHORTCARD('╒'),1,8BH) ;
      Set1Char(48,6,SHORTCARD('═'),6,8BH) ;
      Set1Char(72,6,SHORTCARD('═'),6,8BH) ;
      Set1Char(78,6,SHORTCARD('╕'),1,8BH) ;
      FOR i := 7 TO 22 DO
          Set1Char(47,SHORTCARD(i),SHORTCARD('│'),1,8BH) ;
          Set1Char(78,SHORTCARD(i),SHORTCARD('│'),1,8BH) ;
      END ;
      Set1Char(47,23,SHORTCARD('╘'),1,8BH) ;
      Set1Char(78,23,SHORTCARD('╛'),1,8BH) ;
      Set1Char(48,23,SHORTCARD('═'),30,8BH) ;


(* формирование заглавия *)
      Write1Str(36,0,8CH,'ЭТИКЕТКА') ;
      Write1Str(31,1,8CH,'файл') ;
      Write1Str(37,1,8FH,file_name) ;
      Write1Str(18,24,86H,'для продолжения работы нажмите любую клавишу') ;
(* расшифровываем тип датчика *)
   Str.Concat(stroka,paht1,type_dat) ; (* сформировали полный путь type_dat *)
   f:=FIO.Open(stroka) ;
   IF FIO.IOresult()=0 THEN
       Write1Str(15,2,8AH,'вид эксперим. данных') ;
       LOOP FIO.RdStr(f,stroka) ;
            IF stroka[0]=file_name[0] THEN
              Str.Delete(stroka,0,4) ;
              Write1Str(38,2,8CH,stroka) ; EXIT
            END ;
            IF FIO.EOF THEN
                Write1Str(38,2,8CH,'не идентифицирован') ; EXIT
            END ;
       END ;
       FIO.Close(f) ;
   END ;

(* формирование данных из имени файла *)
   Str.Slice(stroka,file_name,1,2) ;
      Write1Str(9,4,8AH,'номер режима');
      Write1Str(23,4,8CH,stroka);
   Str.Slice(stroka,file_name,3,2) ;
      Write1Str(30,4,8AH,'номер подрежима');
      Write1Str(47,4,8CH,stroka);
   Str.Slice(stroka,file_name,5,3) ;
      Write1Str(55,4,8AH,'номер канала');
      Write1Str(69,4,8CH,stroka);

(* чтение этикетки *)
      CH:=FIO.RdBin(ff,index,2) ;   (* индекс начала служебной информации *)
      CH:=FIO.RdBin(ff,data,8) ;    (* дата эксперимента *)
   Write1Str(15,3,8AH,'дата эксперимента') ;
   Write1Str(34,3,8CH,data)  ;
      CH:=FIO.RdBin(ff,objekt  ,4) ; (* объект *)
   Write1Str(55,3,8AH,'объект') ;
   Write1Str(63,3,8CH,objekt) ;
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
         Write1Str(2,SHORTCARD(7+j),8AH,stroka) ;
         CASE j OF 3,4,8 : Str.CardToStr(LONGCARD(Perem[j]),stroka,10,ok) ;
                           i:=32 ;
                     ELSE  Str.RealToStr(LONGREAL(Perem[j]),10,FALSE,stroka,ok) ;
                           i:=31 ;
         END ;
         Write1Str(SHORTCARD(i),SHORTCARD(7+j),8CH,stroka) ;
         INC(j) ;
     END ; (* loop *)

(*   текст для вывода методов обработки      *)
(* и распаковка двух байтов метода обработки *)
    Write1Str(55,6,8BH,'МЕТОДЫ ОБРАБОТКИ') ;
         (* рисуем каемочку для ВИДА ОБРАБОТКИ *)
    i:= 0 ; CH:= 1 ;
    LOOP
         Str.ItemS(stroka,shabl2,'|',i) ;
         IF Str.Length(stroka)=0 THEN EXIT END ;
         Write1Str(48,SHORTCARD(7+i),8AH,stroka) ;
         j:=CARDINAL(BITSET(obr)*BITSET(CH)) ;
         IF j=0 THEN
              Write1Str(75,SHORTCARD(7+i),8AH,'НЕТ')
         ELSE Write1Str(75,SHORTCARD(7+i),8CH,'ДА') ;
(*            IF  для файлов .SPL и .SPR   *)
              IF CH=20H THEN (* если есть фильтрация то определяем границы *)
                    Write1Str(5,17,8AH,'нижняя  граница фильтра') ;
                     Str.RealToStr(LONGREAL(filtr1),10,FALSE,stroka,ok) ;
                    Write1Str(31,17,8CH,stroka) ;
                    Write1Str(5,18,8AH,'верхняя граница фильтра') ;
                     Str.RealToStr(LONGREAL(filtr2),10,FALSE,stroka,ok) ;
                    Write1Str(31,18,8CH,stroka) ;
              END ; (* if   фильтрации *)
(* для файлов спектральных *)
              IF (bool)AND(CH>=40H)AND(CH<=0800H) THEN
                  Write1Str(4,20,8AH,'pазрешение по частоте  (Гц)') ;
                  Str.RealToStr(LONGREAL(Perem[9]),8,FALSE,stroka,ok) ;
                  Write1Str(32,20,8CH,stroka) ;
                  bool:= FALSE;
              END ;

         END ; (* IF *)
         CH:=CH<<1 ;   INC(i) ;
    END ; (* loop *)

    r.AX := 0501H ;  Lib.Intr(r,10H) ;
    Put_Image(56,128,584,204) ;
    j := 0 ;
    LOOP                                          (* мигает строка внизу *)
         IF IO.KeyPressed() THEN ot := IO.RdCharDirect() ; EXIT END ;
         IF j<=500 THEN
              INC(j)
         ELSE j:=0 ;
              Write1Str(18,24,86H,'для продолжения работы нажмите любую клавишу') ;
         END ;
    END ;

    r.AX := 0500H ;  Lib.Intr(r,10H);

END titl ;

PROCEDURE analiz_print(): BOOLEAN ;

VAR      r               : SYSTEM.Registers ;
         soob            : ARRAY [0..25] OF CHAR ;
(*         ok              : BOOLEAN ;*)
         p               : BOOLEAN ;
         r1              : SHORTCARD ;
BEGIN
         p:=FALSE ;


   LOOP
      r.DX:=0 ;
      r.AH:=02H ;
      Lib.Intr(r,17H) ;
      IO.WrShtCard(r.AH,3) ;
      CASE r.AH OF 144 : (* печатаем *)
                         p:=TRUE ;
                         EXIT ;
                 |  48,
                     8,
                   216 : (* принтер отсоединен *)
                         soob:='    принтер отсоединен   ';
                 | 200,
                   136 : (* принтер выключен *)
                         soob:='     принтер выключен    ';
                 |  32,
                    56 : (* нет бумаги *)
                         soob:='        нет бумаги       ';
                 |   0,
                    24 : (* off line *)
                         soob:=' нет готовности принтера ';
               ELSE
                         soob:='принтер не готов к работе';
      END ; (* CASE *)
(* печать не готова *)
      Lib.Sound(400) ;
      Get_Image(56,128,584,204) ;
      kvadrat(60,132,580,200,4) ;
      ramka(56,128,584,204,15) ;
      WriteStr(34,10,8AH,'О Ш И Б К А');
      WriteStr(26,12,8AH,soob);
      Lib.NoSound ;
(* строка подсказки *)
      kvadrat(0,335,639,349,6) ;
      WriteStr(3,24,86H,'Устраните неисправность принтера и нажмите любую клавишу') ;
      WriteStr(62,24,89H,'[Esc]') ;
      WriteStr(68,24,86H,'Выход') ;
(* анализ действий при не готовности принтера *)
      ot:=IO.RdCharDirect() ;
      Put_Image(56,128,584,204) ;
      IF ot=CHAR(27) THEN
            RETURN p ;
      END ; (* IF *)
   END ; (* LOOP *)

   RETURN p ;

END analiz_print ;

PROCEDURE print ;
VAR
    j               : CARDINAL ; (* количество записей в файле *)
    i,i1,j1,i2,i3   : CARDINAL ; (* переменная цикла                       *)
    kol             : LONGCARD ; (* количества точек реализации            *)
    nach            : CARDINAL ; (* индекс начала экспериментальных данных *)
    index           : CARDINAL ; (* индекс начала служебной информации     *)
    x,x1            : REAL ;     (*  переменные для чтения из файла        *)
    priznak         : CARDINAL ; (* признак для контроля операции чтения   *)
    MIN,MAX,                     (* минимум и максимум                     *)
    MO,D,ASSIM,                  (* матожидание, дисперсия и ассимметрия   *)
    EKC,M           : REAL ;     (* эксцесс и ???? *)
    M1,M2,M3,M4     : REAL ;     (* накопление сумм 1-й  -  4-й степеней   *)
    CKO             : REAL ; (* среднеквадратичное отклонение          *)
    DEL_X           : REAL ;     (* шаг при построении гистограмм          *)
    GIST            : ARRAY [0..15] OF CARDINAL ;(* данные для гистограммы *)
    g1,g2,g3,g4,
    g5,g6,g7,g8,
    g9,g10,g11,g12,
    g13,g14,g15     : REAL ;      (* интервалы для гистограммы             *)
    data            : ARRAY [0..7] OF CHAR ; (* дата эксперимента          *)
    objekt          : ARRAY [0..4] OF CHAR ; (* объект                     *)
    tbegin          : REAL ;                 (* время начала участка ввода *)
    tend            : REAL ;                 (* время конца  участка ввода *)
    chastota        : REAL ;                 (* частота дискретизации      *)
    pror            : CARDINAL ;             (* прореживание               *)
    obr             : CARDINAL ;             (* признаки обработки         *)
    filtr1          : REAL     ;             (* нижняя граница фильтрации  *)
    filtr2          : REAL     ;             (* верхняя граница фильтрации *)
    distan          : CARDINAL ;             (* дистанция прохода          *)
    nom             : CARDINAL ;      (* признак успешности открытия файла *)
    FileName        : ARRAY[0..12] OF CHAR ; (* имя файла                  *)
    CH              : CARDINAL ;       (* для определения маски обработки  *)
    stroka          : ARRAY[0..320] OF CHAR ; (* строка для вывода гистограммы *)
    str,str1        : CARDINAL ;
    g               : ARRAY[0..15] OF CARDINAL ;
    pg              : ARRAY[0..15] OF BOOLEAN ;
    mg              : CARDINAL ;
    mk              : REAL ;
    pprint          : SHORTCARD ;
BEGIN
   j:=CARDINAL(FIO.Size(ff)) ;
   j:=CARDINAL(REAL(j)/111.0) ;
   FIO.Seek(ff,0) ;

   FOR i:=1 TO j DO

(* данные из этикетки файла *)
      priznak:=FIO.RdBin(ff,FileName,13) ;
      priznak:=FIO.RdBin(ff,data,8) ;
      priznak:=FIO.RdBin(ff,objekt,4) ;
      priznak:=FIO.RdBin(ff,tbegin,4) ;
      priznak:=FIO.RdBin(ff,tend,4) ;
      priznak:=FIO.RdBin(ff,chastota,4) ;
      priznak:=FIO.RdBin(ff,pror,2) ;
      priznak:=FIO.RdBin(ff,obr,2) ;
      priznak:=FIO.RdBin(ff,filtr1,2) ;
      priznak:=FIO.RdBin(ff,filtr2,2) ;
      priznak:=FIO.RdBin(ff,distan,2) ;
(* результаты стат.обработки *)
      priznak:=FIO.RdBin(ff,kol,4) ;
      priznak:=FIO.RdBin(ff,MIN,4) ;
      priznak:=FIO.RdBin(ff,MAX,4) ;
      priznak:=FIO.RdBin(ff,MO,4) ;
      priznak:=FIO.RdBin(ff,D,4) ;
      priznak:=FIO.RdBin(ff,CKO,4) ;
      priznak:=FIO.RdBin(ff,ASSIM,4) ;
      priznak:=FIO.RdBin(ff,EKC,4) ;
      FOR i1:=0 TO 15 DO
         priznak:=FIO.RdBin(ff,GIST[i1],2) ;
      END ; (* FOR *)
(* печатать или нет файл *)
      Get_Image(56,128,584,204) ;
      kvadrat(60,132,580,200,1) ;
      ramka(56,128,584,204,15) ;
      WriteStr(34,10,8AH,'ВНИМАНИЕ');
      WriteStr(24,12,8AH,'к печати готов файл');
      WriteStr(44,12,8CH,FileName);
(* строка подсказки *)
      kvadrat(0,335,639,349,6) ;
      WriteStr(7,24,89H,'[P]') ;
      WriteStr(11,24,86H,'Печать результатов') ;
      WriteStr(37,24,89H,'[С]') ;
      WriteStr(41,24,86H,'Пропустить файл') ;
      WriteStr(62,24,89H,'[Esc]') ;
      WriteStr(68,24,86H,'Выход') ;
(* конец строки подсказки *)
      pprint:=0 ;
      LOOP
         ot:=IO.RdCharDirect() ;
         CASE  ot OF 'p','P' :  (* печать результатов по файлам *)
                                pprint:=1 ;
                                EXIT ;
                   | 'c','C' :  (* пропустить результаты по файлу *)
                                pprint:=2 ;
                                EXIT ;
                   | CHAR(27) : (* отказаться от печати *)
                                Put_Image(56,128,584,204) ;
                                RETURN ;
         END ; (* CASE *)
      END ; (* LOOP *)
      Put_Image(56,128,584,204) ;
      IF pprint=1 THEN
         IF analiz_print() THEN
(* очистка табуляции *)
               pprint:=1 ;
               WrChar(4,CHAR(27)) ; WrChar(4,CHAR(68)) ; WrChar(4,CHAR(0)) ;
(* установка табуляции *)
               WrChar(4,CHAR(27)) ;WrChar(4,CHAR(68)) ;WrChar(4,CHAR(1)) ;WrChar(4,CHAR(23)) ;
               WrChar(4,CHAR(39)) ; WrChar(4,CHAR(58)) ;WrChar(4,CHAR(0)) ;
(* вывод на принтер результатов расчета *)
               WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrChar(4,CHAR(9)) ; WrStr(4,'ЭКСПРЕСС ОБРАБОТКА') ;
               WrLn(4) ;  WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'ЭТИКЕТКА ФАЙЛА ') ; WrStr(4,FileName) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'РЕЗУЛЬТАТЫ ОБРАБОТКИ') ;
               WrLn(4) ; WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'Дата эксперимента') ;
               WrChar(4,CHAR(9)) ; WrStr(4,data) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'Минимум реализации') ;
               WrChar(4,CHAR(9)) ; WrReal(4,MIN,7,1) ;
               WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'Объект') ;
               WrChar(4,CHAR(9)) ; WrStr(4,objekt) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'Максимум реализации') ;
               WrChar(4,CHAR(9)) ; WrReal(4,MAX,7,1) ;
               WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'Время начала участка') ;
               WrChar(4,CHAR(9)) ; WrReal(4,tbegin,7,1) ; WrStr(4,' c.') ;
               WrChar(4,CHAR(9)) ; WrStr(4,'Мат. ожидание') ;
               WrChar(4,CHAR(9)) ; WrReal(4,MO,7,1) ;
               WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'Время конца участка') ;
               WrChar(4,CHAR(9)) ; WrReal(4,tend,7,1) ; WrStr(4,' c.') ;
               WrChar(4,CHAR(9)) ; WrStr(4,'Дисперсия') ;
               WrChar(4,CHAR(9)) ; WrReal(4,D,7,1) ;
               WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'Частота дискретизации') ;
               WrChar(4,CHAR(9)) ; WrReal(4,chastota,7,1) ; WrStr(4,' Гц') ;
               WrChar(4,CHAR(9)) ; WrStr(4,'СКО') ;
               WrChar(4,CHAR(9)) ; WrReal(4,CKO,7,1) ;
               WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'Количество точек') ;
               WrChar(4,CHAR(9)) ; WrLngCard(4,kol,5) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'Асимметрия') ;
               WrChar(4,CHAR(9)) ; WrReal(4,ASSIM,7,1) ;
               WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'Прореживание') ;
               WrChar(4,CHAR(9)) ; WrCard(4,pror,1) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'Эксцесс') ;
               WrChar(4,CHAR(9)) ; WrReal(4,EKC,7,1) ;
               WrLn(4) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'Дистанция прохода') ;
               WrChar(4,CHAR(9)) ; WrCard(4,distan,1) ;
               WrLn(4) ; WrLn(4) ;
               WrLn(4) ; WrLn(4) ;
               WrLn(4) ; WrLn(4) ;
(* вывод гистограммы *)
(* очистка табуляции *)
               WrChar(4,CHAR(27)) ; WrChar(4,CHAR(68)) ; WrChar(4,CHAR(0)) ;
(* установка табуляции *)
               WrChar(4,CHAR(27)) ; WrChar(4,CHAR(68)) ; WrChar(4,CHAR(4)) ;
               WrChar(4,CHAR(10)) ; WrChar(4,CHAR(55)) ; WrChar(4,CHAR(0)) ;
(* вычисление масштаба для гистограммы *)
               mg:=GIST[0] ;
               FOR i1:=1 TO 15 DO
                   IF mg<GIST[i1] THEN
                         mg:=GIST[i1] ;
                   END ; (* IF *)
               END ; (* FOR *)
               mk:=200.0/REAL(mg) ;
(* очистить буффер принтера *)
               WrChar(4,CHAR(24)) ;
(* перевод строки на 8 точек *)
               WrChar(4,CHAR(27)) ; WrChar(4,CHAR(51)) ; WrChar(4,CHAR(24)) ;
               WrLn(4) ;
               FOR i1:=0 TO 15 DO
                  pg[i1]:=TRUE ;
               END ; (* FOR *)
               FOR j1:=1 TO 25 DO
(* заполнение горизонтальной черты *)
                  FOR i1:=0 TO 320 DO
                     stroka[i1]:=CHAR(0) ;
                  END ; (* FOR *)
(* заполнение горизонтальной черты *)
                  IF j1=1 THEN
                        FOR i1:=0 TO 320 DO
                           stroka[i1]:=CHAR(128) ;
                        END ; (* FOR *)
                     ELSE
                        FOR i1:=0 TO 320 BY 4 DO
                           stroka[i1]:=CHAR(128) ;
                        END ; (* FOR *)
                  END ; (* IF *)
(* заполнение вертикальной черты *)
                  FOR i1:=0 TO 320 BY 20 DO
                     stroka[i1]:=CHAR(170) ;
                  END ; (* FOR *)
(* заполнения рамки *)
                  stroka[0]:=CHAR(255) ;
                  stroka[320]:=CHAR(255) ;
(* вычисление заполненности гистограммы *)
                  FOR i1:=0 TO 15 DO
                     IF REAL(200-(j1-1)*8-8)<(REAL(GIST[i1])*mk) THEN
                           str:=0 ;
                           i3:=0 ;
                           FOR i2:=8 TO 1 BY -1 DO
                               IF REAL(200-(j1-1)*8-i2)<(REAL(GIST[i1])*mk) THEN
                                     str:=str+CARDINAL(MATHLIB.Pow(2.0,LONGREAL(i3))) ;
                               END ; (* if *)
                               i3:=i3+1 ;
                           END ; (* FOR *)
(* определение верхней полочки *)
                           IF pg[i1] THEN
                                 pg[i1]:=FALSE ;
                                 str1:=128 ;
                                 LOOP
                                    IF CARDINAL(BITSET(str1)*BITSET(str))<>0 THEN
                                           EXIT ;
                                        ELSE
                                           str1:=str1>>1 ;
                                    END ; (* IF *)
                                 END ; (* LOOP *)
                                 FOR i2:=i1*20 TO i1*20+19 DO
                                    stroka[i2]:=CHAR(BITSET(CARDINAL(stroka[i2]))+BITSET(str1)) ;
                                 END ; (* FOR *)
                           END ; (* IF *)
                           FOR i2:=i1*20 TO i1*20+20 BY 2 DO
                              stroka[i2]:=CHAR(BITSET(CARDINAL(stroka[i2]))+BITSET(str)) ;
                           END ; (* FOR *)
                           stroka[i1*20+1]:=CHAR(BITSET(CARDINAL(stroka[i1*20+1]))+BITSET(str)) ;
                           stroka[i1*20+19]:=CHAR(BITSET(CARDINAL(stroka[i1*20+19]))+BITSET(str)) ;
                     END ; (* IF *)
                  END ; (* FOR *)
(* печать левых значений *)
                  IF j1=1 THEN
                        WrChar(4,CHAR(9)) ; WrCard(4,mg,5) ; WrChar(4,CHAR(9)) ;
                     ELSE
                        IF j1=25 THEN
                              WrChar(4,CHAR(9)) ; WrStr(4,'    0') ; WrChar(4,CHAR(9)) ;
                           ELSE
                              IF (CARDINAL((j1)DIV(5))*5)=j1 THEN
                                    WrChar(4,CHAR(9)) ; WrCard(4,CARDINAL(REAL(mg)*REAL(25-j1)/25.0),5) ; WrChar(4,CHAR(9)) ;
                                 ELSE
                                    WrChar(4,CHAR(9)) ; WrChar(4,CHAR(9)) ;
                              END ; (* IF *)
                        END ; (* IF *)
                  END ; (* IF *)
(* перевод принтера в графический режим *)
                  WrChar(4,CHAR(27)) ; WrChar(4,CHAR(42)) ;
                  WrChar(4,CHAR(0)) ;
                  WrChar(4,CHAR(65)) ; WrChar(4,CHAR(1)) ;
(* печать сформированной строки *)
                  WrBin(4,stroka,321) ;
                  WrLn(4) ;
(* конец вывода гистограммы *)
               END ; (* FOR *)

(* сдвиг графика *)
               WrChar(4,CHAR(9)) ; WrChar(4,CHAR(9)) ;
(* перевод принтера в графический режим *)
               WrChar(4,CHAR(27)) ; WrChar(4,CHAR(42)) ;
               WrChar(4,CHAR(0)) ;
               WrChar(4,CHAR(65)) ; WrChar(4,CHAR(1)) ;
(* печать нижней строки *)
               FOR i1:=0 TO 320 DO
                  stroka[i1]:=CHAR(128) ;
               END ; (* FOR *)
               stroka[0]:=CHAR(255) ; stroka[320]:=CHAR(255) ;
               WrBin(4,stroka,321) ;
(* перевод строки на текстовом экране *)
               WrChar(4,CHAR(27)) ; WrChar(4,CHAR(50)) ;
               WrLn(4) ;
(* печать нижнего текста *)
               WrChar(4,CHAR(9)) ; WrReal(4,MIN,7,1) ;
               WrChar(4,CHAR(9)) ; WrStr(4,'   ') ;WrReal(4,MAX,7,1) ; WrLn(4) ;
               WrStr(4,'                            ') ;
               WrStr(4,'шаг = ') ; WrReal(4,(MAX-MIN)/16.0,7,1) ; WrLn(4) ;
(* прогон страницы *)
               WrChar(4,CHAR(12)) ;
         END ; (* анализ готовности принтера *)
      END ; (* IF печатать или нет *)
   END ; (* FOR *)
END print ;

PROCEDURE view ;

VAR i               : LONGCARD ; (* количество обработанных файлов *)
    i1              : CARDINAL ;

    pm              : CARDINAL ;
    nom             : CARDINAL ;
    nom_f           : CARDINAL ;
    p               : BOOLEAN ;  (* признак не вывода новой картинки *)
BEGIN
   p:=TRUE ;
   (* контексная подсказка *)
   kvadrat(0,335,639,349,6) ;
   WriteStr(7,24,89H,'[^V]') ;
   WriteStr(12,24,86H,'Перемещение курсора') ;
   WriteStr(37,24,89H,'[Enter]') ;
   WriteStr(45,24,86H,'Выбор режима') ;
   WriteStr(62,24,89H,'[Esc]') ;
   WriteStr(68,24,86H,'Выход') ;
   (* подменю для опции 'вывод' *)
   Get_Image(345,26,518,60) ;
   kvadrat(345,26,518,60,88H) ;
   ramka(345,26,518,60,82H) ;
   nom_f := 0 ;
   pm:=1 ;
(* выбор режима вывода информации *)
   LOOP
      IF pm=1 THEN
            kvadrat(346,27,517,42,88H) ;
            kvadrat(346,44,517,59,3) ;
            WriteStr(44,2,86H,'вывод файла на экран') ;
            WriteStr(44,3,86H,' печать всех файлов') ;
         ELSE
            kvadrat(346,27,517,42,3) ;
            kvadrat(346,44,517,59,88H) ;
            WriteStr(44,2,86H,'вывод файла на экран') ;
            WriteStr(44,3,86H,' печать всех файлов') ;
      END ; (* IF *)
      ot:=IO.RdCharDirect() ;
      CASE ot OF (CHAR(72))  : (* вверх *)
                               pm:=1 ;
               | (CHAR(80))  : (* вниз  *)
                               pm:=2 ;
               | (CHAR(0DH)) : (* ввод  *)
                               EXIT ;
               | (CHAR(27))  : (* Esc   *)
                               pm:=3 ;
                               EXIT ;
      END ; (* CASE *)
   END ; (* LOOP *)
   ff:=FIO.Open('STAT.REZ') ;
   nom:=FIO.IOresult() ;
   IF nom<>0 THEN
      pm:=3 ;
   END ; (* IF *)
   IF pm<>3 THEN
      FIO.AssignBuffer(ff,buf) ;
      i:=FIO.Size(ff) ;
      i:=LONGCARD(REAL(i)/111.0) ;
   END ;
LOOP
CASE pm OF 1 : (* вывод исходных данных на экран *)
   (* контексная подсказка *)
   kvadrat(0,335,639,349,6) ;
   WriteStr(7,24,89H,'[^V]') ;
   WriteStr(12,24,86H,'Перемещение курсора') ;
   WriteStr(33,24,89H,'[Enter]') ;
   WriteStr(41,24,86H,'Просмотр результатов') ;
   WriteStr(62,24,89H,'[Esc]') ;
   WriteStr(68,24,86H,'Выход') ;

   (*Get_Image(6,68,410,328) ;*)
   vibor (INTEGER(i)) ;
(* очистка левого экрана *)
(*   Put_Image(6,68,410,328) ;*)
(*   Fon_Screen ;
   put() ;
   Spisok() ;*)
   EXIT ;
         | 2 : (* вывод всех файлов на печать *)
                  print ;
                  EXIT ;
              ELSE
                  (* нет обработанных файлов *)
                  EXIT ;
   END ; (* CASE *)
END ; (* LOOP *)
   FIO.Close(ff) ;
(* очистка подменю *)
   Put_Image(345,26,518,60) ;
END view ;

PROCEDURE vibor (n : INTEGER ) ;
(* выбор просматриваемого файла, n - количество файлов *)
VAR i         : INTEGER ;

BEGIN
   FOR i:=0 TO n-1 DO
      FIO.Seek(ff,LONGCARD(i*111)) ;
      priznak:=FIO.RdBin(ff,name_file[i+1],13) ;
      pri_file[i+1]:=FALSE ;
   END ;
(* вывод всех имен на экран *)
   FOR i:=1 TO n DO
      IF i>16 THEN
            kvadrat(536,CARDINAL(i-10)*14,536+96,CARDINAL(i-9)*14,3) ;
            WriteStr(67,SHORTCARD(i-10),83H,name_file[i]);
         ELSE
            kvadrat(432,CARDINAL(i+6)*14,432+96,CARDINAL(i+7)*14,3) ;
            WriteStr(54,SHORTCARD(i+6),83H,name_file[i]);
      END ; (* IF *)
   END ; (* FOR *)
(* выбор нужного файла *)
   i:=1 ;
   LOOP

      IF i>16 THEN
            WriteStr(67,SHORTCARD(i-10),0FH,name_file[i]);
         ELSE
            WriteStr(54,SHORTCARD(i+6),0FH,name_file[i]);
      END ; (* IF *)

      ot:=IO.RdCharDirect () ;
      CASE ot OF (CHAR(00))  : ot:=IO.RdCharDirect() ;

      CASE ot OF (CHAR(72))  : (* вверх *)
                               IF i>1 THEN

      IF i>16 THEN
            kvadrat(536,CARDINAL(i-10)*14,536+96,CARDINAL(i-9)*14,3) ;
            WriteStr(67,SHORTCARD(i-10),83H,name_file[i]);
         ELSE
            kvadrat(432,CARDINAL(i+6)*14,432+96,CARDINAL(i+7)*14,3) ;
            WriteStr(54,SHORTCARD(i+6),83H,name_file[i]);
      END ; (* IF *)
                                     i:=i-1 ;
                               END ; (* IF *)

               | (CHAR(80))  : (* вниз  *)
                               IF i<n THEN

      IF i>16 THEN
            kvadrat(536,CARDINAL(i-10)*14,536+96,CARDINAL(i-9)*14,3) ;
            WriteStr(67,SHORTCARD(i-10),83H,name_file[i]);
         ELSE
            kvadrat(432,CARDINAL(i+6)*14,432+96,CARDINAL(i+7)*14,3) ;
            WriteStr(54,SHORTCARD(i+6),83H,name_file[i]);
      END ; (* IF *)
                                     i:=i+1 ;
                               END ; (* IF *)

               | (CHAR(75))  : (* влево *)
                               IF i>16 THEN

      IF i>16 THEN
            kvadrat(536,CARDINAL(i-10)*14,536+96,CARDINAL(i-9)*14,3) ;
            WriteStr(67,SHORTCARD(i-10),83H,name_file[i]);
         ELSE
            kvadrat(432,CARDINAL(i+6)*14,432+96,CARDINAL(i+7)*14,3) ;
            WriteStr(54,SHORTCARD(i+6),83H,name_file[i]);
      END ; (* IF *)
                                     i:=i-16 ;
                               END ; (* IF *)
               | (CHAR(77))  : (* вправо*)
                               IF i+16 <=n THEN

      IF i>16 THEN
            kvadrat(536,CARDINAL(i-10)*14,536+96,CARDINAL(i-9)*14,3) ;
            WriteStr(67,SHORTCARD(i-10),83H,name_file[i]);
         ELSE
            kvadrat(432,CARDINAL(i+6)*14,432+96,CARDINAL(i+7)*14,3) ;
            WriteStr(54,SHORTCARD(i+6),83H,name_file[i]);
      END ; (* IF *)
                                    i:=i+16 ;
                               END ; (* IF *)
      END ; (* CASE *)
               | (CHAR(27))  : (* Esc   *)
                               EXIT ;
               | (CHAR(0DH)) : (* Enter *)
                               (* просмотр одного файла *)
                               rez_list(LONGCARD(i)) ;
      END ; (* CASE *)
   END ; (* LOOP *)

   IF i>16 THEN
         kvadrat(536,CARDINAL(i-10)*14,536+96,CARDINAL(i-9)*14,3) ;
         WriteStr(67,SHORTCARD(i-10),83H,name_file[i]);
      ELSE
         kvadrat(432,CARDINAL(i+6)*14,432+96,CARDINAL(i+7)*14,3) ;
         WriteStr(54,SHORTCARD(i+6),83H,name_file[i]);
   END ; (* IF *)

END vibor ;

PROCEDURE rez_list(n : LONGCARD ) ;

VAR il             : CARDINAL ;
(*    name           : ARRAY [0..12] OF CHAR ;*)
   m                 : CARDINAL ; (* максимальное значение для гистограммы *)
BEGIN
   Eng:=FALSE ;
   FIO.Seek(ff,(n-1)*111+13+34) ;
(*   priznak:=FIO.RdBin(ff,name,13) ;*)
   priznak:=FIO.RdBin(ff,kol,4) ;
          Str.CardToStr(LONGINT(kol),kol1,10,OK) ;
   priznak:=FIO.RdBin(ff,MIN,4) ;
          Str.RealToStr(LONGREAL(MIN),10,Eng,MIN1,OK) ;
   priznak:=FIO.RdBin(ff,MAX,4) ;
          Str.RealToStr(LONGREAL(MAX),10,Eng,MAX1,OK) ;
   priznak:=FIO.RdBin(ff,MO,4) ;
          Str.RealToStr(LONGREAL(MO),10,Eng,MO1,OK) ;
   priznak:=FIO.RdBin(ff,D,4) ;
          Str.RealToStr(LONGREAL(D),10,Eng,D1,OK) ;
   priznak:=FIO.RdBin(ff,CKO,4) ;
          Str.RealToStr(LONGREAL(CKO),10,Eng,CKO1,OK) ;
   priznak:=FIO.RdBin(ff,ASSIM,4) ;
          Str.RealToStr(LONGREAL(ASSIM),10,Eng,ASSIM1,OK) ;
   priznak:=FIO.RdBin(ff,EKC,4) ;
          Str.RealToStr(LONGREAL(EKC),10,Eng,EKC1,OK) ;
   FOR il:=0 TO 15 DO
         priznak:=FIO.RdBin(ff,GIST[il],2) ;
   END ; (* FOR *)


      kvadrat(6,68,410,328,1) ;
      ramka(6,68,410,328,15) ;
      WriteStr(15,5,8AH,'файл ');
      WriteStr(20,5,8CH,name_file[CARDINAL(n)]);
      WriteStr(5,6,8AH,'количество точек');
      WriteStr(33,6,8CH,kol1 );
      WriteStr(5,7,8AH,'максимум реализации');
      WriteStr(32,7,8CH,MAX1 );
      WriteStr(5,8,8AH,'минимум реализации');
      WriteStr(32,8,8CH,MIN1 );
      WriteStr(5,9,8AH,'математическое ожидание');
      WriteStr(32,9,8CH,MO1 );
      WriteStr(5,10,8AH,'дисперсия');
      WriteStr(32,10,8CH,D1 );
      WriteStr(5,11,8AH,'СКО');
      WriteStr(32,11,8CH,CKO1 );
      WriteStr(5,12,8AH,'ассимметрия');
      WriteStr(32,12,8CH,ASSIM1 );
      WriteStr(5,13,8AH,'эксцесс');
      WriteStr(32,13,8CH,EKC1 );
      m := GIST[0] ;
      FOR il:=1 TO 15 DO
         IF m<GIST[il] THEN
               m := GIST[il] ;
         END ;
      END ; (* FOR *)

      FOR il:=0 TO 15 DO
         kvadrat(il*14+14+80,CARDINAL(300.0-100.0*(REAL(GIST[il])/REAL(m))),il*14+26+80,300,0DH) ;
      END ; (* FOR *)
END rez_list ;

PROCEDURE Fon_Screen ; (* запись ░ *)
VAR i,j : CARDINAL ;
BEGIN
      SYSTEM.Out(3CEH,1)  ; (* регистр разрешения установки цвета *)
      SYSTEM.Out(3CFH,00H); (* разрешаем изменять биты в плоскостях /белый/*)
      SYSTEM.Out(3C4H,2)  ; (* регистр маски битовых плоскостей *)
      SYSTEM.Out(3C5H,0FH); (* разрешаем изменять все плоскости *)
      FOR i := 36 TO 334 BY 2 DO
           j := i*80 ;
           Lib.WordFill([0A000H:j],40,1111H) ;
           Lib.WordFill([0A000H:j+80],40,4444H) ;
      END ; (* for *)
      SYSTEM.Out(3CEH,1)  ; (* регистр разрешения установки цвета *)
      SYSTEM.Out(3CFH,0)  ; (* 1 - ЗАПРЕЩАЕТ  установку цвета *)
END Fon_Screen ;


END prosmotr.