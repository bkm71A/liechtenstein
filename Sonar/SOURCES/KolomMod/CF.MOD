MODULE cf ;

FROM Window IMPORT Open,TextColor,GotoXY,Close,Clear,CursorOff,SetTitle,Use,
                   WinType,WinDef,DoubleFrame,SingleFrame,Color,CenterUpperTitle,
                   FrameStr,RightUpperTitle,DirectWrite,Hide,TextBackground,
                   SetFrame,Change,Used,WhereY,CenterLowerTitle,ClrEol,
                   PutOnTop ;
(*FROM Window  IMPORT Open,WinType,WinDef,Color,DoubleFrame,GotoXY,Close,
                   TextColor,TextBackground,PutOnTop,SetTitle,CenterUpperTitle ;*)

FROM IO      IMPORT RdCharDirect,WrStr,WrShtCard,WrCard,WrChar,KeyPressed ;
             IMPORT Storage,Lib,SYSTEM,FIO,Str  ;
             IMPORT Int24 ;
             IMPORT TxtImage ;

FROM prosmotr IMPORT r ;

FROM _Window IMPORT Shadow,Close_Sh,Open_Sh ;

CONST reg1     = '  Загрузка   ' ;
      reg2     = ' Сохранение  ' ;
      reg3     = 'Архивирование' ;
      reg4     = ' Перепаковка ' ;
      reg5     = '    Выход    ' ;
      shablon  = ' *.*   |'+
                 ' *.fl* |'+
                 ' *.dat |'+
                (* ' *.rez |'+*)
                 ' *.spl |'+
                 ' *.df* |'+
                 ' *.in* |'+
                 ' *.sg* |'+
                 ' *.spr |' ;
    pod_menu   = '  Выбор файла  |' +
                 '  Выбор диска  |' +
                 ' Выбор шаблона |' +
                 '     Выход     |' ;
    sl          = '\' ;
TYPE reg               = ARRAY[0..12] OF CHAR ;

VAR  Aaa,Bbb,Ccc,Ddd,
     Sss,Yyy           : WinType ; (* окна для вывода основного меню *)
     AA,BB,CC,DD,SS,YY : WinDef ;
     ot                : CHAR ;
     i,j               : CARDINAL ;
     regim             : ARRAY[0..4] OF reg ;
     m                 : CARDINAL ;             (* активный пункт меню    *)
     disk              : SHORTCARD ;
     tek_drive         : CHAR ;                 (* текущий накопитель     *)
     tek_put           : ARRAY[0..65] OF CHAR ; (* текущий путь           *)
     buf_in            : ARRAY[0..4095+FIO.BufferOverhead] OF BYTE ;
     buf_out           : ARRAY[0..4095+FIO.BufferOverhead] OF BYTE ;
     ff_in             : FIO.File ;
     ff_out            : FIO.File ;
     put               : ARRAY[0..65] OF CHAR ; (* путь для выхода        *)
     spis_drive        : ARRAY[0..30] OF CHAR ; (* список накопителей     *)
     fff               : ARRAY[0..79] OF CHAR ; (* список накопителей с | *)
     a,s               : CARDINAL ;
     shabl             : ARRAY[0..12] OF CHAR ; (* шаблон для выбора файлов   *)
     n_file      : ARRAY[1..512] OF FIO.PathTail ;(* список файлов в директории *)
     p_file      : ARRAY[1..512] OF BOOLEAN ;     (* признак выбранности файла  *)
     D           : FIO.DirEntry ;                 (* для чтения имен файлов     *)
     nom         : CARDINAL ;                   (* количество файлов в каталоге *)
     pv          : BOOLEAN ;                  (* признак отказа от выбора файла *)
     file_in     : ARRAY[0..65] OF CHAR ;     (* выходной файл          *)
     file_out    : ARRAY[0..65] OF CHAR ;     (* входной файл           *)
     buf         : ARRAY[0..4095] OF CHAR ;   (* перекачка              *)
     p_in        : CARDINAL ;
     p_size      : BOOLEAN ;                  (* нет места на диске     *)
     put_out     : ARRAY[0..65] OF CHAR ;    (* путь для сохранения файлов *)

PROCEDURE NR() ;
VAR AA         : WinDef ;
    Aaa        : WinType ;
    a          : CARDINAL ;
BEGIN
AA:=WinDef(20,8,60,13,Yellow,Cyan,FALSE,FALSE,FALSE,TRUE,DoubleFrame,LightGreen,Cyan) ;
Aaa:=Open(AA) ;
a:=Open_Sh(Aaa) ;
PutOnTop(Aaa) ;
GotoXY(8,2) ;
WrStr('Данный режим предназначен') ;
GotoXY(3,3) ;
WrStr('для дальнейшего расширения системы') ;

ot:=RdCharDirect() ;
Close_Sh(a) ;
Close(Aaa) ;
END NR ;

PROCEDURE aktiv_m(m:CARDINAL) ;
BEGIN
   TextColor(Yellow) ;
   TextBackground(Magenta) ;
   GotoXY(m*14+1,1) ;
   WrStr(regim[m]) ;
END aktiv_m;

PROCEDURE pasiv_m(m:CARDINAL) ;
BEGIN
   PutOnTop(Bbb) ;
   TextColor(Magenta) ;
   TextBackground(Cyan) ;
   GotoXY(m*14+1,1) ;
   WrStr(regim[m]) ;
END pasiv_m ;


PROCEDURE Find_Drive() ;
VAR
    www   : ARRAY[0..63] OF CHAR ;
    save  : CARDINAL ;
BEGIN

     fff        :=' A | B |' ;
     spis_drive :='AB'      ;
     FOR save := 3 TO 26 DO
        FIO.GetDir(SHORTCARD(save),www) ;
        IF FIO.IOresult()=0 THEN Str.Append(fff,' ') ;
              Str.Append(fff,CHAR(save+40H)) ;
              Str.Append(fff,' |') ;
              Str.Append(spis_drive,CHAR(save+40H)) ;
        END ;
     END ; (* for *)
                          (* для повторного вхождения в PodMenu *)
END Find_Drive ;

PROCEDURE write_menu (VAR m : CARDINAL ; VAR Aaa: WinType ;
                      stroka : ARRAY OF CHAR ; x,y: CARDINAL ;
                      text,fon,ramka : Color ) ;
(*   m - номер подпункта меню для возврата      *)

VAR
   i       : CARDINAL ;      (* переменная цикла                     *)
   line    : ARRAY[0..40] OF CHAR ; (* передаваемая строка меню      *)
   k       : CARDINAL ;      (* количество записей в меню            *)
   l       : CARDINAL ;      (* максимальная длина записи            *)
   a,b     : CARDINAL ;      (* для открытия тени окна               *)
   x1,y1   : CARDINAL ;      (* вычисляемые координаты для окна меню *)

BEGIN
(* установление цвета для открываемого меню *)
   TextColor(text) ;
   TextBackground(fon) ;
   SetFrame(Aaa,DoubleFrame,ramka,fon) ;
(* определяем максимальную длину строки *)
   k:=0 ;
   l:=0 ;
   LOOP
      Str.ItemS(line,stroka,'|',k) ;
      IF Str.Compare(line,CHAR(0))=0 THEN
            EXIT ;
         ELSE
            k:=k+1 ;
            IF Str.Length(line) > l THEN
                  l:=Str.Length(line) ;
            END ; (* IF *)
      END ; (* IF *)
   END ; (* LOOP *)
(* переопределяем координаты окна *)
   x1:=x+l+1 ; y1:=y+k+1;
   Change(Aaa,x,y,x1,y1) ;
   PutOnTop(Aaa) ;
(* вывод всего меню на экран *)
   FOR i:=0 TO k DO
      Str.ItemS(line,stroka,'|',i) ;
      GotoXY(1,i+1) ;
      WrStr(line) ;
   END ; (* FOR *)
END write_menu ;

PROCEDURE vibor_menu (VAR m : CARDINAL ; VAR Aaa: WinType ; VAR p : BOOLEAN;
                      stroka : ARRAY OF CHAR ; x,y: CARDINAL ;
                      text,fon,text_a,fon_a: Color ) ;
(*   m - номер подпункта меню для возврата      *)

VAR
   i       : CARDINAL ;      (* переменная цикла                     *)
   line    : ARRAY[0..40] OF CHAR ; (* передаваемая строка меню       *)
   k       : CARDINAL ;      (* количество записей в меню            *)
   l       : CARDINAL ;      (* максимальная длина записи            *)
   x1,y1   : CARDINAL ;      (* вычисляемые координаты для окна меню *)


PROCEDURE aktiv_pm(m:CARDINAL) ; (* процедура вывода активного пункта меню  *)
BEGIN
   PutOnTop(Aaa) ;
   TextColor(text_a) ;
   TextBackground(fon_a) ;
   GotoXY(1,m+1) ;
   Str.ItemS(line,stroka,'|',m) ;
   WrStr(line) ;
END aktiv_pm;

PROCEDURE pasiv_pm(m:CARDINAL) ;  (* процедура вывода пассивного пункта меню *)
BEGIN
   PutOnTop(Aaa) ;
   TextColor(text) ;
   TextBackground(fon) ;
   GotoXY(1,m+1) ;
   Str.ItemS(line,stroka,'|',m) ;
   WrStr(line) ;
END pasiv_pm ;

BEGIN
(* определяем максимальную длину строки *)
   k:=0 ;
   l:=0 ;
   LOOP
      Str.ItemS(line,stroka,'|',k) ;
      IF Str.Compare(line,CHAR(0))=0 THEN
            EXIT ;
         ELSE
            k:=k+1 ;
            IF Str.Length(line) > l THEN
                  l:=Str.Length(line) ;
            END ; (* IF *)
      END ; (* IF *)
   END ; (* LOOP *)
(* Выбор подпункта меню *)
   aktiv_pm(m) ;
   LOOP
      ot:=RdCharDirect() ;
      CASE ot OF
         | (CHAR(0DH)) : (* Enter *)
                         (* выход с возвратом номера подменю *)
                         p:=TRUE ;
                         RETURN ;
         | (CHAR(27))  : (* Esc *)
                         p:=FALSE ;
                         EXIT ;
         | (CHAR(00))  : ot:=RdCharDirect() ;
                         CASE ot OF
                            | (CHAR(72))  : (* вверх *)
                              IF m=0 THEN
                                    pasiv_pm(m) ;
                                    m:=k-1 ;
                                    aktiv_pm(m) ;
                                 ELSE
                                    pasiv_pm(m) ;
                                    m:=m-1 ;
                                    aktiv_pm(m) ;
                              END ; (* IF *)
                            | (CHAR(80))  : (* вниз *)
                              IF m=k-1 THEN
                                    pasiv_pm(m) ;
                                    m:=0 ;
                                    aktiv_pm(m) ;
                                 ELSE
                                    pasiv_pm(m) ;
                                    m:=m+1 ;
                                    aktiv_pm(m) ;
                              END ; (* IF *)
                          END ; (* CASE *)
      END ; (* case *)
   END ; (* LOOP *)
   RETURN  ;
END vibor_menu ;

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
    s1       =FrameStr('╒═╕││╘═╛') ;
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
    ff       : FIO.File ;
    AA       : WinDef ;
    Aaa      : WinType ;
    f        : FIO.File ;

BEGIN
AA:=WinDef(0,0,79,24,LightCyan,Blue,FALSE,FALSE,TRUE,TRUE,s1,LightCyan,Blue) ;
   Aaa:=Open(AA) ;
   data  [HIGH(data)]   :=CHR(0) ;
   objekt[HIGH(objekt)] :=CHR(0) ;
   ff:=FIO.Open(file_name) ;
   FIO.AssignBuffer(ff,buf) ;
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
   Str.Concat(stroka,put,type_dat) ; (* сформировали полный путь type_dat *)
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
                  GotoXY(5,17) ; WrStr('нижняя  граница фильтра') ;
                  Str.RealToStr(LONGREAL(filtr1),10,FALSE,stroka,ok) ;
                  TextColor(LightMagenta) ;
                  GotoXY(31,17) ; WrStr(stroka) ;
                  TextColor(LightCyan) ;
                  GotoXY(5,18)  ; WrStr('верхняя граница фильтра') ;
                  Str.RealToStr(LONGREAL(filtr2),10,FALSE,stroka,ok) ;
                  TextColor(LightMagenta) ;
                  GotoXY(31,18) ; WrStr(stroka) ;
            END ; (* if   фильтрации *)
(* для файлов спектральных *)
              IF (bool)AND(CH>=40H)AND(CH<=0800H) THEN
                  TextColor(LightCyan) ;
                  GotoXY(4,20) ; WrStr('pазрешение по частоте  (Гц)') ;
                  Str.RealToStr(LONGREAL(Perem[9]),8,FALSE,stroka,ok) ;
                  TextColor(LightMagenta) ;
                  GotoXY(32,20) ; WrStr(stroka) ;
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
END titl ;

PROCEDURE prosm(file_name: ARRAY OF CHAR ) ;
VAR ident      : ARRAY [1..2] OF CHAR ;
    nach_sl    : CARDINAL ;
    ff         : FIO.File ;
    priznak    : CARDINAL ;
    AA         : WinDef ;
    Aaa        : WinType ;
    a          : CARDINAL ;
BEGIN
   ff:=FIO.Open(file_name) ;
   FIO.AssignBuffer(ff,buf) ;
   priznak:=FIO.RdBin(ff,nach_sl,2) ;
   FIO.Seek(ff,LONGCARD(nach_sl)) ;
   (* идентификатор файла обработки *)
   priznak:=FIO.RdBin(ff,ident,2) ;
   FIO.Close(ff) ;
   IF Str.Match(ident,'SW') THEN
AA:=WinDef(20,8,60,13,Magenta,Blue,FALSE,FALSE,FALSE,TRUE,SingleFrame,Magenta,Blue) ;
         Aaa:=Open(AA) ;
         a:=Open_Sh(Aaa) ;
         PutOnTop(Aaa) ;
         GotoXY(12,2) ;
         WrStr('ПОДОЖДИТЕ НЕМНОГО !');
         TextColor(LightGray) ;
         GotoXY(6,3) ;
         WrStr('идет распаковка этикетки файла');
         (*  распаковка и вывод этикетки файла *)
         titl(file_name) ;
         Close_Sh(a) ;
         Close(Aaa) ;

      ELSE
         (* неправильный формат данных в файле *)
AA:=WinDef(20,8,60,13,Yellow,Red,FALSE,FALSE,FALSE,TRUE,SingleFrame,White,Red) ;
         Aaa:=Open(AA) ;
         a:=Open_Sh(Aaa) ;
         PutOnTop(Aaa) ;
         Lib.Sound(400) ;
         SetTitle(Aaa,' О Ш И Б К А ! ',CenterUpperTitle);
         GotoXY(3,2) ;
         WrStr('неправильный формат данных в файле');
         TextBackground(LightRed) ;
         TextColor(LightGray) ;
         GotoXY(2,4) ;
         WrStr('для продолжения нажмите любую клавишу');
         Lib.NoSound ;
         ot:=RdCharDirect() ;
         Close_Sh(a) ;
         Close(Aaa) ;
   END ; (* IF *)
END prosm ;



PROCEDURE read_dir(chablon1 : ARRAY OF CHAR) ;
(* чтение каталога диска *)
   VAR  p         : CARDINAL ;
   pr             : BOOLEAN ;
   chablon        : ARRAY[0..65] OF CHAR ;
   put_net        : ARRAY[0..63] OF CHAR ;
BEGIN
   Str.Copy(chablon,tek_put) ;
(* вырезаем пробелы *)
   Str.Delete(chablon1,0,1) ;
   p:=Str.Length(chablon) ;
   IF Str.Match(chablon[p-1],'\') THEN
         Str.Concat(chablon,chablon,chablon1) ;
      ELSE
         Str.Append(chablon,'\') ;
         Str.Concat(chablon,chablon,chablon1) ;
   END ; (* IF *)

   FOR i :=1 TO 512 DO
      n_file[i]:='' ;
      p_file[i]:=FALSE ;
   END ; (*FOR *)
   nom := 1 ;
(* чтение директорий *)
   pr:=FIO.ReadFirstEntry('*.*',FIO.FileAttr{FIO.directory},D) ;
                              (* просмотр директорий сетевых дисков *)
   IF D.rsvd[0]=SHORTCARD('Z') THEN
         r.AH := 47H ;               (* дать оглавление диска *)
         r.DL := SHORTCARD(tek_drive)-40H ;
         r.DS := SYSTEM.Seg(put_net) ;
         r.SI := SYSTEM.Ofs(put_net) ;
         Lib.Dos(r) ;
         IF Str.Length(put_net)#0 THEN
               n_file[nom] := '\..' ;
               INC(nom) ;
         END ;
   END ;
   IF pr THEN
      IF D.attr=FIO.FileAttr{FIO.directory} THEN
            IF Str.Match(D.Name,'.') THEN
               ELSE
                  Str.Concat(n_file[nom],'\',D.Name) ;
                  INC(nom) ;
            END ; (* IF *)
      END ; (* IF *)
   END ; (* IF *)
   LOOP
      IF FIO.ReadNextEntry(D) THEN
            IF D.attr=FIO.FileAttr{FIO.directory} THEN
                  IF Str.Match(D.Name,'.') THEN
                     ELSE
                        Str.Concat(n_file[nom],'\',D.Name) ;
                        INC(nom) ;
                  END ; (* IF *)
            END ; (* if *)
         ELSE   EXIT ;
      END ; (* IF *)
   END ; (* loop *)

(* чтение имен файлов *)
   IF FIO.ReadFirstEntry(chablon,FIO.FileAttr{FIO.archive,
                        FIO.readonly},D) THEN
            n_file[nom]:=D.Name ;
            INC(nom) ;
   END ; (* IF *)
   LOOP
      IF FIO.ReadNextEntry(D) THEN
                  n_file[nom]:=D.Name ;
                  INC(nom) ;
         ELSE DEC(nom) ; EXIT ;
      END ; (* IF *)
   END ; (* loop *)
END read_dir ;


PROCEDURE write_dir(line:INTEGER) ; (* номер первой выводимой строки *)
(* вывод каталога на экран, line - номер первой выводимой строки *)

VAR z    : INTEGER  ;
    x,y  : CARDINAL ;
    i    : INTEGER  ;

BEGIN
   PutOnTop(Sss) ;
   Clear ;
   IF nom > 40 THEN
         z := 40+line*4 ;
         IF z > INTEGER(nom) THEN
               z:=nom ;
         END ; (* IF *)
      ELSE
         z:=nom ;
   END ; (* IF *)

   x:=2 ; y:=1 ;
   FOR i:=line*4+1 TO z DO
      IF x>41 THEN
            x:=2 ; y:=y+1 ;
      END ; (* IF *)
      IF p_file[i] THEN
            GotoXY(x,y) ;
            TextColor(Yellow) ;
            WrStr(n_file[i]);
         ELSE
            GotoXY(x,y) ;
            TextColor(LightCyan) ;
            WrStr(n_file[i]);
      END ;
      x:=x+13 ;
   END ; (* FOR *)
END write_dir ;

PROCEDURE put_title() ;
VAR      title             : ARRAY[0..50] OF CHAR ;
         p                 : CARDINAL ;
BEGIN
(* формирование title *)
   Str.Concat(title,' ',tek_put) ;
   p:=Str.Length(title) ;
   IF Str.Match(title[p-1],'\') THEN
      ELSE
         Str.Concat(title,title,'\') ;
   END ; (* IF *)
Str.Concat(title,title,shabl) ;
SetTitle(Sss,title,CenterUpperTitle) ;
END put_title ;

PROCEDURE ReadWrite(ff_in: FIO.File;ff_out:FIO.File;file_in:ARRAY OF CHAR;
                     Ooo:WinType ; o:CARDINAL) ;
CONST
    kol   = 8192 ;

VAR i       : CARDINAL ;
    r       : SYSTEM.Registers ;
    buf     : ARRAY[0..8192] OF BYTE ;
    AA      : WinDef ;
    Aaa     : WinType ;
    a       : CARDINAL ;
    len     : CARDINAL ;
    x1,x2   : CARDINAL ;
    stroka  : ARRAY[0..65] OF CHAR ;
    stroka1 : ARRAY[0..65] OF CHAR ;
    razmer  : LONGCARD ;
    kol1    : CARDINAL ;
    x3      : CARDINAL ;

PROCEDURE Write(i:CARDINAL) ;
BEGIN
   r.DS:=SYSTEM.Seg(buf) ;
   r.DX:=SYSTEM.Ofs(buf) ;
   r.AH:=40H ;  (* запись в файл *)
   r.BX:=ff_out ;
   r.CX:=i ;
   Lib.Dos(r) ;
END Write ;

BEGIN
   Str.Copy(stroka,'░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░') ;
(* переопределяем размер окна *)
   len:=Str.Length(file_in) ;
   Str.Delete(stroka,len,65-len) ;
   IF len<23 THEN
         x1:=28 ;
         x2:=52 ;
      ELSE
         x1:=(80-len+2) DIV 2 ;
         x2:=x1+len+3 ;
   END ; (* IF *)
   Change(Ooo,x1,8,x2,12) ;
   o:=Open_Sh(Ooo) ;
   PutOnTop(Ooo) ;
   Clear ;
   x1:=(x2-x1-len) DIV 2 ;
   GotoXY(x1+1,1) ;
   GotoXY(x1+1,2) ;
   WrStr(file_in) ;
   GotoXY(x1+1,3) ;
   WrStr(stroka) ;
   razmer:=FIO.Size(ff_in) ;
   Str.Copy(stroka,'████████████████████████████████████████████████████████████') ;
   i:=0 ;
   LOOP
      i:=i+1 ;
      r.DS:=SYSTEM.Seg(buf) ;
      r.DX:=SYSTEM.Ofs(buf) ;
      r.AH:=3FH ;  (* чтение из файла *)
      r.BX:=ff_in ;
      r.CX:=kol ;
      Lib.Dos(r) ;
(* анализ ошибки при чтении *)
      IF (BITSET{SYSTEM.CarryFlag} * r.Flags) # BITSET{} THEN
            (* обработка ошибки при чтении *)

         ELSE
            IF r.AX=kol THEN
                  (* пишем в выходной файл *)
                  kol1:=CARDINAL((LONGCARD(kol)*LONGCARD(i*len))DIV(razmer)) ;
                  Str.Slice(stroka1,stroka,0,kol1) ;
                  GotoXY(x1+1,3) ;
                  WrStr(stroka1) ;
                  Write(kol) ;

               ELSE
                  (* пишем в выходной файл последний кусок *)
                  Str.Slice(stroka1,stroka,0,len) ;
                  GotoXY(x1+1,3) ;
                  WrStr(stroka1) ;
                  Write(r.AX) ;
                  (* изменение атрибутов файла *)
                  r.AH:=57H ;
                  r.AL:=0 ;
                  r.BX:=ff_in ;
                  Lib.Dos(r) ;
                  r.AH:=57H ;
                  r.AL:=1 ;
                  r.BX:=ff_out ;
                  Lib.Dos(r) ;
                  EXIT ;
            END ; (* IF *)
      END ; (* IF *)
   END ; (* LOOP *)
   Close_Sh(o) ;
END ReadWrite ;

PROCEDURE analiz_disk (disk : SHORTCARD ; ff_in: FIO.File):BOOLEAN ;
VAR

    razmer       : LONGCARD ;           (* размер корируемого файла      *)
    r            : SYSTEM.Registers ;
    klaster,
    sektor,
    bate         : LONGCARD ;
    p_size       : BOOLEAN ;
    AA           : WinDef ;    (* окно для вывода сообщения об ошибке *)
    Aaa          : WinType ;
    a            : CARDINAL ;

BEGIN
   AA:=WinDef(20,8,60,13,Yellow,Red,FALSE,FALSE,FALSE,TRUE,SingleFrame,White,Red) ;
   (* хватит ли места для записи файла *)
   razmer:=FIO.Size(ff_in) ;
   r.AH:=36H ;
   r.DL:=disk ;
   Lib.Dos(r) ;
   klaster:=LONGCARD(r.BX) ;
   sektor:=LONGCARD(r.AX) ;
   bate:=LONGCARD(r.CX) ;
   IF razmer<(klaster*sektor*bate) THEN
         p_size:=TRUE ;
      ELSE
         p_size:=FALSE ;
         (* нет места на диске *)
         Aaa:=Open(AA) ;
         SetTitle(Aaa,' B Н И М А Н И Е ! ',CenterUpperTitle) ;
         GotoXY(12,2) ;
         WrStr('Диск переполнен') ;
         GotoXY(2,4) ;
         TextColor(LightGray) ;
         TextBackground(LightRed) ;
         WrStr('Для продолжения нажмите любую клавишу') ;
         a:=Open_Sh(Aaa) ;
         ot:=RdCharDirect() ;
         Close_Sh(a) ;
         Close(Aaa) ;
   END ; (* IF *)
   RETURN p_size ;
END analiz_disk ;

PROCEDURE edit_line(VAR line : ARRAY OF CHAR ) ;
(* редактор одной строки *)
VAR   rez    : CARDINAL ;
      x      : CARDINAL ;
BEGIN
x:=1 ;
LOOP
   GotoXY(1,1) ;
   WrStr(line) ;
   GotoXY(x,1) ;
   ot:=RdCharDirect() ;
   CASE ot OF  |  (CHAR(0DH)) : (* Enter *)
                                EXIT ;
               |  (CHAR(27))  : (* Esc *)
                                EXIT ;
               |  (CHAR(08H)) : (* Backspace *)
                     IF x>1 THEN
                           Clear ;
                           Str.Delete(line,x-2,1) ;
                           x:=x-1 ;
                     END ; (* IF *)
               | (CHAR(00))   : ot:=RdCharDirect() ;
                     CASE ot OF CHAR(83) : (* Del *)
                                Clear ;
                                Str.Delete(line,x-1,1) ;
                              | (CHAR(75))  : (* влево *)
                                IF x>1 THEN
                                      x:=x-1 ;
                                END ; (* IF *)
                              | (CHAR(77))  : (* вправо*)
                                IF x<=Str.Length(line) THEN
                                      x:=x+1 ;
                                END ; (* IF *)
                              | (CHAR(79))  : (* End *)
                                x:=Str.Length(line)+1 ;
                              | (CHAR(71))  : (* Home *)
                                x:=1 ;
                     END ; (* CASE *)
         ELSE (* CASE *)
            Str.Insert(line,ot,x-1) ;
            x:=x+1 ;
      END ; (* case *)
END ; (* LOOP *)

END edit_line ;

PROCEDURE otmetka ( r : CARDINAL ) ;
(* выбор списка файлов *)
VAR x,y          : CARDINAL ;           (* координаты для выбора файла   *)
    x1,y1        : CARDINAL ;           (* координаты для графич. экрана *)
    z            : CARDINAL ;           (* номер текущего файла          *)
    line         : INTEGER ;            (* номер первой выводимой строки *)
    p            : CARDINAL ;           (* длинна пути                   *)
    i            : CARDINAL ;           (* переменная цикла              *)
    j            : CARDINAL ;           (* переменная цикла              *)
    AA,BB,OO,PP,
    WW,HH        : WinDef ;             (* окно для выбора файлов        *)
    Aaa,Bbb,Ooo,
    Ppp,Www,Hhh  : WinType ;            (* окно для выдачи сообщений     *)
    o,pp,w       : CARDINAL ;           (* тень окна для копирования     *)
    pr           : BOOLEAN ;            (* проверка наличия каталога     *)
    rrr          : SYSTEM.Registers ;
    h            : CARDINAL ;
BEGIN
   AA:=WinDef(0,0,0,0,Black,LightGray,FALSE,FALSE,TRUE,FALSE,DoubleFrame,Blue,Blue) ;
   Aaa:=Open(AA) ;
   BB:=WinDef(0,0,0,0,Black,LightGray,FALSE,FALSE,TRUE,FALSE,DoubleFrame,Blue,Blue) ;
   Bbb:=Open(BB) ;
   OO:=WinDef(20,8,60,12,Black,LightGray,FALSE,FALSE,TRUE,TRUE,SingleFrame,Yellow,LightGray) ;
   PP:=WinDef(10,10,70,12,Black,LightGray,TRUE,FALSE,FALSE,TRUE,SingleFrame,Yellow,LightGray) ;
   WW:=WinDef(20,9,60,14,White,Red,FALSE,FALSE,FALSE,TRUE,SingleFrame,White,Red) ;
   HH:=WinDef(20,8,60,17,White,Brown,FALSE,FALSE,FALSE,TRUE,SingleFrame,White,Brown) ;

(* вывод файлов на экран *)
   line:=0 ;
   write_dir(line) ;
   z:=1 ; x:=15 ; y:=6 ;

   pv:=TRUE ;
   LOOP
   PutOnTop(Yyy) ;
   Clear ;
   GotoXY(32,1) ;
   TextColor(White) ;
   WrStr('[F1] ') ;
   TextColor(Black) ;
   WrStr('Подсказка') ;
   PutOnTop(Aaa) ;
      x1:=x+11 ;
      Change(Aaa,x,y,x1,y) ;
      PutOnTop(Aaa) ;
      IF p_file[z] THEN
            TextColor(Yellow) ;
            Clear ;
            WrStr(n_file[z]) ;
         ELSE
            TextColor(LightCyan) ;
            Clear ;
            WrStr(n_file[z]) ;
      END ; (* IF *)
      ot:=RdCharDirect() ;

      CASE ot OF (CHAR(00))  : ot:=RdCharDirect() ;
      CASE ot OF (CHAR(72))  : (* вверх *)
                               IF z>4 THEN
                                     z:=z-4 ;
                                     IF y>6 THEN
                                           y:=y-1
                                        ELSE
                                           line:=line-1 ;
                                           write_dir(line) ;
                                     END ; (* IF *)
                               END ; (* IF *)
               | (CHAR(59))  : (*  F1 - HELP *)
                               Hhh:=Open(HH) ;
                               h:=Open_Sh(Hhh) ;
                               PutOnTop(Hhh) ;
                               SetTitle(Hhh,' ОКНО ПОДСКАЗКИ ',CenterUpperTitle) ;
                               GotoXY(5,2) ;
                               TextColor(White) ;
                               WrStr('[^V<>] ') ;
                               TextColor(Black) ;
                               GotoXY(16,2) ;
                               WrStr('Перемещение курсора') ;
                               GotoXY(5,3) ;
                               TextColor(White) ;
                               WrStr('[Enter] ') ;
                               TextColor(Black) ;
                               GotoXY(16,3) ;
                               WrStr('Выбор поддиректории') ;
                               GotoXY(5,4) ;
                               TextColor(White) ;
                               WrStr('[Ins] ') ;
                               TextColor(Black) ;
                               GotoXY(16,4) ;
                               WrStr('Отметить файл') ;
                               GotoXY(5,5) ;
                               TextColor(White) ;
                               WrStr('[SpaseBar] ') ;
                               TextColor(Black) ;
                               GotoXY(16,5) ;
                               WrStr('Просмотр этикетки') ;
                               GotoXY(5,6) ;
                               TextColor(White) ;
                               WrStr('[F5] ') ;
                               TextColor(Black) ;
                               GotoXY(16,6) ;
                               WrStr('Копирование файлов') ;
                               GotoXY(5,7) ;
                               TextColor(White) ;
                               WrStr('[Esc] ') ;
                               TextColor(Black) ;
                               GotoXY(16,7) ;
                               WrStr('Выход') ;

                               ot:=RdCharDirect() ;
                               Close(Hhh) ;
                               Close_Sh(h) ;
                               Shadow(Sss) ;
               | (CHAR(63))  :
                               IF r=1 THEN
                               (*  F5 - копирование файлов на D:\DATA *)
                               Ooo:=Open(OO) ;
   SetTitle(Ooo,' К О П И Р О В А Н И Е ',CenterUpperTitle) ;
                               FOR i:=1 TO nom DO
                                  IF p_file[i] THEN
                                          (* переписываем файл *)
                                        Str.Concat(file_in,tek_put,'\') ;
                                        Str.Append(file_in,n_file[i]) ;
                                        j:=Str.Pos(file_in,'\\') ;
                                        IF j<MAX(CARDINAL) THEN
                                              Str.Delete(file_in,j,1) ;
                                        END ; (* IF *)
                                        Str.Concat(file_out,'d:/data/',n_file[i]) ;
                                        ff_in:=FIO.Open(file_in) ;
                                        ff_out:=FIO.Create(file_out) ;

                                              p_size:=analiz_disk(4,ff_in) ;
                                              IF p_size THEN
                                                    ReadWrite(ff_in,ff_out,file_in,Ooo,o) ;
                                                    p_file[i]:=FALSE ;
                                                 ELSE
                                                    i:=nom+1 ;
                                              END ; (* IF *)

                                        FIO.Close(ff_in) ;
                                        FIO.Close(ff_out) ;
                                  END ; (* IF *)
                               END ; (* FOR *)
                               Close(Ooo) ;
                               write_dir(line) ;
                               ELSE

(*  F5 - сохранение файлов с D:\DATA *)
                               (* задание пути для сохранения *)
                               FOR i:=1 TO nom DO
                                  IF p_file[i] THEN
                                        Ppp:=Open(PP) ;
                                        SetTitle(Ppp,
         ' Введите полное имя пути для сохранения файлов ',CenterUpperTitle) ;
                                        pp:=Open_Sh(Ppp) ;
                                        PutOnTop(Ppp) ;
                                        edit_line(put_out) ;

                                        j:=Str.Pos(put_out,'\') ;
                                        IF j=MAX(CARDINAL) THEN
                                              Str.Append(put_out,'\') ;
                                        END ; (* IF *)
                                        FIO.ChDir(put_out) ;
                                        j:=FIO.IOresult() ;
                                        IF j=0 THEN
                                        rrr.AH:=19H ;
                                        Lib.Dos(rrr) ;
                                        disk:=rrr.AL+1 ;
                                              i:=nom+1 ;
                                           ELSE
                                              (* сообщение об ошибке *)
                                               Lib.Sound(400) ;
                                               Www:=Open(WW) ;
                  SetTitle(Www,' О Ш И Б К А  ! ',CenterUpperTitle);
                  GotoXY(13,2) ;
                  TextColor(Yellow) ;
                  WrStr('Путь не найден');
                  GotoXY(2,4) ;
                  TextBackground(LightRed) ;
                  TextColor(LightGray) ;
                  WrStr('для продолжения нажмите любую клавишу');
                                               Lib.NoSound ;
                                               ot:=RdCharDirect() ;
                                               Close(Www) ;
                                              (*                     *)
                                              i:=i-1 ;
                                         END ; (* IF *)

                                         FIO.ChDir(tek_put) ;
                                         Close_Sh(pp) ;
                                         Close(Ppp) ;
                                         Shadow(Sss) ;
                                  END ; (* IF *)
                               END ; (* FOR *)
                               Ooo:=Open(OO) ;
         SetTitle(Ooo,' К О П И Р О В А Н И Е ',CenterUpperTitle) ;
                               FOR i:=1 TO nom DO
                                  IF p_file[i] THEN
                                          (* переписываем файл *)
                                        Str.Concat(file_in,tek_put,'\') ;
                                        Str.Append(file_in,n_file[i]) ;
                                        j:=Str.Pos(file_in,'\\') ;
                                        IF j<MAX(CARDINAL) THEN
                                              Str.Delete(file_in,j,1) ;
                                        END ; (* IF *)
                                        Str.Concat(file_out,put_out,'\') ;
                                        Str.Append(file_out,n_file[i]) ;
                                        j:=Str.Pos(file_out,'\\') ;
                                        IF j<MAX(CARDINAL) THEN
                                              Str.Delete(file_out,j,1) ;
                                        END ; (* IF *)
                                        ff_in:=FIO.Open(file_in) ;
                                        ff_out:=FIO.Create(file_out) ;
                                        j:=FIO.IOresult() ;
                                        IF j<>5 THEN
                                        p_size:=analiz_disk(disk,ff_in) ;
                                        IF p_size THEN
                                              ReadWrite(ff_in,ff_out,file_in,Ooo,o) ;
                                              p_file[i]:=FALSE ;
                                           ELSE
                                              i:=nom+1 ;
                                        END ; (* IF *)
                                           ELSE
                                              (* Сообщение об ошибке *)
(*:=WinDef(20,8,60,13,Yellow,Red,FALSE,FALSE,FALSE,TRUE,SingleFrame,White,Red) ;*)
         Www:=Open(WW) ;
         w:=Open_Sh(Www) ;
         PutOnTop(Www) ;
         Lib.Sound(400) ;
         SetTitle(Www,' О Ш И Б К А ! ',CenterUpperTitle);
         GotoXY(6,2) ;
         WrStr('директория защищена от записи');
         TextBackground(LightRed) ;
         TextColor(LightGray) ;
         GotoXY(2,4) ;
         WrStr('для продолжения нажмите любую клавишу');
         Lib.NoSound ;
         ot:=RdCharDirect() ;
         Close_Sh(w) ;
         Close(Www) ;
         i:=nom ;
                                        END ; (* IF *)
                                        FIO.Close(ff_in) ;
                                        FIO.Close(ff_out) ;
                                  END ; (* IF *)
                               END ; (* FOR *)
                               Close(Ooo) ;
                               write_dir(line) ;
                               END ; (* IF r *)
               | (CHAR(80))  : (* вниз  *)
                               IF ((x=15)AND((z+4)<=nom))OR
                                  ((x=28)AND((z+3)<=nom))OR
                                  ((x=41)AND((z+2)<=nom))OR
                                  ((x=54)AND((z+1)<=nom)) THEN
                                     IF z+4<=nom THEN
                                           z:=z+4 ;
                                           IF y=15 THEN
                                                 (* смещение по директории *)
                                                 line:=line+1 ;
                                                 write_dir(line) ;
                                              ELSE
                                                 y:=y+1 ;
                                           END ; (* IF *)
                                        ELSE
                                           (* смещение по директории с
                                              изменением координаты x *)
                                           IF y=15 THEN
                                                 line:=line+1 ;
                                                 write_dir(line) ;
                                              ELSE
                                                 y:=y+1 ;
                                           END ; (* IF *)
                                           IF x=15 THEN
                                              z:=z+4 ;
                                           END ; (* IF *)
                                           IF x=28 THEN
                                                 IF z+3=nom THEN
                                                       x:=15 ; z:=z+3 ;
                                                 END ; (* IF *)
                                           END ; (* IF *)
                                           IF x=41 THEN
                                                 IF z+3=nom THEN
                                                       x:=28 ; z:=z+3 ;
                                                    ELSE
                                                       x:=15 ; z:=z+2 ;
                                                 END ; (* IF *)
                                           END ; (* IF *)
                                           IF x=54 THEN
                                                 IF z+3=nom THEN
                                                       x:=41 ; z:=z+3 ;
                                                    ELSE
                                                       IF z+2=nom THEN
                                                             x:=28 ; z:=z+2 ;
                                                          ELSE
                                                             x:=15 ; z:=z+1 ;
                                                       END ; (* IF *)
                                                 END ; (* IF *)
                                           END ; (* IF *)
                                     END ; (* IF *)
                               END ; (* if *)

               | (CHAR(75))  : (* влево *)
                               IF z>1 THEN
                                     z:=z-1 ;
                                     IF x=15 THEN
                                           x:=54 ;
                                           IF y=6 THEN
                                                 line:=line-1 ;
                                                 write_dir(line) ;
                                              ELSE
                                                 y:=y-1 ;
                                           END ;(* IF *)
                                        ELSE
                                           x:=x-13 ;
                                     END ; (* IF *)
                               END ; (* IF *)
               | (CHAR(77))  : (* вправо*)
                               IF z < nom THEN
                                     z:=z+1 ;
                                     IF x=54 THEN
                                           IF y<15 THEN
                                                 x:=15 ; y:=y+1 ;
                                              ELSE
                                                 (* смещение по директории *)
                                                 line:=line+1 ;
                                                 write_dir(line) ;
                                                 x:=15 ;
                                           END ; (* IF *)
                                        ELSE
                                           x:=x+13;
                                     END ; (* IF *)
                               END ; (* IF *)
               | (CHAR(82)) : (* Insert *)
                               IF Str.Pos(n_file[z],sl)=0 THEN
                                  ELSE
                                     p_file[z] := NOT(p_file[z]) ;
                                     IF z< nom THEN
                                     (* перерисовать другим цветом *)
                                           PutOnTop(Sss) ;
                                           IF p_file[z] THEN
                                                 TextColor(Yellow) ;
                                                 GotoXY(x-13,y-5) ;
                                                 WrStr(n_file[z]);
                                              ELSE
                                                 TextColor(LightCyan) ;
                                                 GotoXY(x-13,y-5) ;
                                                 WrStr(n_file[z]);
                                           END ; (* IF *)
                                           z:=z+1 ;
                                           IF x=54 THEN
                                                 IF y<15 THEN
                                                       x:=15 ; y:=y+1 ;
                                                    ELSE
                                                       (* смещение по директории *)
                                                       line:=line+1 ;
                                                       write_dir(line) ;
                                                       x:=15 ;
                                                 END ; (* IF *)
                                              ELSE
                                                 x:=x+13;
                                           END ; (* IF *)
                                        ELSE
                                           (* перерисовать другим цветом *)
                                           PutOnTop(Sss) ;
                                           IF p_file[z] THEN
                                                 TextColor(Yellow) ;
                                                 GotoXY(x-13,y-5) ;
                                                 WrStr(n_file[z]);
                                              ELSE
                                                 TextColor(LightCyan) ;
                                                 GotoXY(x-13,y-5) ;
                                                 WrStr(n_file[z]);
                                           END ; (* IF *)
                                     END ; (* IF *)
                               END ; (* IF *)
      END ; (* case *)
               | (CHAR(27))  : (* Esc   *)
                               EXIT ;
               | (CHAR(0DH)) : (* Enter *)
                               IF Str.Pos(n_file[z],sl)=0 THEN
                                     (* изменить директорию *)
                                     IF Str.Pos(n_file[z],'\..')=0 THEN
                                           (* движение вверх *)
                                           p:=Str.Length(tek_put) ;
                                           LOOP
                                              Str.Delete(tek_put,p-1,1) ;
                                              DEC(p) ;
                                              IF Str.Match(tek_put[p-1],'\') THEN
                                                    IF p>3 THEN
                                                           Str.Delete(tek_put,p-1,1) ;
                                                    END ; (* IF *)
                                                    FIO.ChDir(tek_put) ;
                                                    read_dir(shabl) ;
                                                    line:=0 ;
                                                    write_dir(line) ;
                                                    put_title() ;
                                                    z:=1 ; x:=15 ; y:=6 ;
                                                    EXIT ;
                                              END ; (* IF *)
                                           END ; (* LOOP *)
                                        ELSE
                                           (* движение вниз *)
                                           p:=Str.Length(tek_put) ;
                                           IF Str.Match(tek_put[p-1],'\') THEN
                                                 Str.Delete(tek_put,p-1,1) ;
                                           END ; (* IF *)
                                           Str.Concat(tek_put,tek_put,n_file[z]) ;
                                           FIO.ChDir(tek_put) ;
                                           read_dir(shabl) ;
                                           line:=0 ;
                                           put_title() ;
                                           write_dir(line) ;
                                           z:=1 ; x:=15 ; y:=6 ;
                                     END ; (* IF *)
                               END ; (* if *)
               | (CHAR(32))   : (* Spase Bar *)
                                (* просмотр этикетки *)
                                prosm(n_file[z]) ;
      END ; (* case *)
   END ; (* loop *)
(* стирание окна выбора файлов *)
   Close(Aaa) ;
END otmetka ;




PROCEDURE zagr () ;

VAR  m1,m2,m3,m4       : CARDINAL ; (* номера подменю                 *)
     p1,p2,p3,p4       : BOOLEAN ; (* признаки открытости окон       *)
     Aaa,Bbb,Ccc,Ddd   : WinType ;  (* окна для вывода подменю        *)
     AA,BB,CC,DD       : WinDef ;
     a,b,c,d           : CARDINAL ;            (* для указателей на тени *)
     put               : ARRAY [0..65] OF CHAR ;

BEGIN
(* окно подрежима 1 *)
   AA:=WinDef(0,0,0,0,Black,Black,FALSE,FALSE,TRUE,TRUE,DoubleFrame,Black,Black) ;
   CC:=WinDef(0,0,0,0,Black,Black,FALSE,FALSE,TRUE,TRUE,DoubleFrame,Black,Black) ;
   DD:=WinDef(0,0,0,0,Black,Black,FALSE,FALSE,TRUE,TRUE,DoubleFrame,Black,Black) ;

   Aaa:=Open(AA) ;
   m1:=0 ;
   m4:=0 ;
   p1:=FALSE ;
   p3:=FALSE ;
   p4:=FALSE ;

LOOP
PutOnTop(Yyy) ;
Clear ;
GotoXY(9,1) ;
TextColor(White) ;
WrStr('[^V] ') ;
TextColor(Black) ;
WrStr('Перемещение курсора') ;
GotoXY(38,1) ;
TextColor(White) ;
WrStr('[Enter] ') ;
TextColor(Black) ;
WrStr('Выбор режима') ;
GotoXY(63,1) ;
TextColor(White) ;
WrStr('[Esc] ') ;
TextColor(Black) ;
WrStr('Выход') ;
   IF p1 THEN
         PutOnTop(Aaa) ;
      ELSE
         Aaa:=Open(AA) ;
   END ; (* IF *)
   write_menu (m1,Aaa,pod_menu,7,3,LightGray,Black,White ) ;
   a:=Open_Sh(Aaa) ;
   vibor_menu (m1,Aaa,p1,pod_menu,7,3,LightGray,Black,Yellow,LightGray) ;
   IF p1 THEN (* если окно осталось открытым *)
         (* выбор подрежимов *)
         CASE m1 OF 0 : (* выбор файлов     *)
                        read_dir (shabl) ;
                        Sss:=Open(SS) ;
                        put_title() ;
                        s:=Open_Sh(Sss) ;
                        PutOnTop(Sss) ;
                        otmetka(1) ;
                        Close_Sh(s) ;
                        Close(Sss) ;

                  | 1 : (* выбор устройства *)

   Find_Drive() ;
   m3:=Str.Pos(spis_drive,tek_drive) ;
   Ccc:=Open(CC) ;

   write_menu (m3,Ccc,fff,14,6,LightGray,Black,White ) ;
   c:=Open_Sh(Ccc) ;
   vibor_menu (m3,Ccc,p3,fff,14,6,LightGray,Black,Yellow,LightGray) ;
(* переопределяем текущее устройство *)
   Str.Slice(tek_drive,spis_drive,m3,1) ;
   Str.Concat(tek_put,tek_drive,':\') ;
   FIO.ChDir(tek_put) ;
   FIO.GetDir(0,put) ;
   Str.Concat(tek_put,tek_put,put) ;
   Close_Sh(c) ;
   Close(Ccc) ;
                  | 2 : (* выбор шаблона    *)
   Ddd:=Open(DD) ;
   write_menu (m4,Ddd,shablon,14,6,LightGray,Black,White ) ;
   d:=Open_Sh(Ddd) ;
   vibor_menu (m4,Ddd,p4,shablon,14,7,LightGray,Black,Yellow,LightGray) ;
(* выбор шаблона *)
   Str.ItemS(shabl,shablon,'|',m4) ;
   Close_Sh(d) ;
   Close(Ddd) ;
                  | 3 : (* выход *)
                    Close_Sh(a) ;
                    Close(Aaa) ;
                    EXIT ;
         END ; (* CASE *)

      ELSE
         Close_Sh(a) ;
         Close(Aaa) ;
         EXIT ;
   END ; (* IF *)
END ; (* LOOP *)
END zagr ;


BEGIN ; (*  основная программа   *)
FIO.IOcheck:=FALSE ;
put_out:='';
(* определение пути для возврата *)
   r.AH:=19H ; Lib.Dos(r) ;
   Str.Copy(tek_drive,CHAR(r.AL+41H)) ;
   FIO.GetDir(0,tek_put) ;
   Str.Concat(put,tek_drive,':\') ;
   Str.Concat(put,put,tek_put);

   FIO.ChDir('O:\IN_DAT') ;
   j:=FIO.IOresult() ;
   IF j<>0 THEN
         FIO.ChDir('D:\DATA') ;
         Str.Copy(tek_put,'D:\DATA') ;
         Str.Copy(tek_drive,'D') ;
      ELSE
         Str.Copy(tek_put,'O:\IN_DAT') ;
         Str.Copy(tek_drive,'O') ;
   END ; (* IF *)
(* задание текущего шаблона *)
   Str.Copy(shabl,' *.* ') ;
(* заполнение экрана псевдографикой *)
   DD:=WinDef(0,0,79,24,White,Black,FALSE,TRUE,TRUE,FALSE,DoubleFrame,White,Red) ;
   Ddd:=Open(DD) ;
   FOR i:=0 TO 24 DO
      FOR j:=0 TO 79 DO
         WrChar('░') ;
      END ; (* FOR *)
   END ; (* FOR *)
   PutOnTop(Ddd) ;
(* формирование верхнего меню *)
   Str.Copy(regim[0],reg1) ;
   Str.Copy(regim[1],reg2) ;
   Str.Copy(regim[2],reg3) ;
   Str.Copy(regim[3],reg4) ;
   Str.Copy(regim[4],reg5) ;
(*****      Окно подсказки      *****)
YY:=WinDef(0,24,79,24,White,Brown,FALSE,FALSE,FALSE,FALSE,' ',White,Blue) ;
Yyy:=Open(YY) ;
(* окно для вывода основного меню *)
   AA:=WinDef(3,1,76,3,White,Black,FALSE,TRUE,FALSE,TRUE,SingleFrame,White,Black) ;
   Aaa:=Open(AA) ;
   Shadow(Aaa) ;
(* окно для вывода основного титра *)
   CC:=WinDef(23,1,56,1,Yellow,Black,FALSE,TRUE,FALSE,FALSE,DoubleFrame,White,Cyan) ;
   Ccc:=Open(CC) ;
(* окно для вывода списка файлов *)
   SS:=WinDef(13,5,67,16,LightCyan,Black,FALSE,FALSE,FALSE,TRUE,DoubleFrame,White,Black) ;
   WrStr(' Загрузка информационных массивов') ;
(* вывод пунктов меню *)
   BB:=WinDef(5,2,75,2,Magenta,Black,FALSE,TRUE,FALSE,FALSE,DoubleFrame,White,Black) ;
   Bbb:=Open(BB) ;


   TextBackground(Cyan) ;
   FOR i:=0 TO 4 DO
      GotoXY(i*14+1,1) ;
      WrStr(regim[i]) ;
   END ; (* FOR *)


(* вывод активного пункта меню *)

   m:=0 ;

   aktiv_m(m) ;
(* выбор режима работы *)
   LOOP
PutOnTop(Yyy) ;
Clear ;
GotoXY(9,1) ;
TextColor(White) ;
WrStr('[<>] ') ;
TextColor(Black) ;
WrStr('Перемещение курсора') ;
GotoXY(38,1) ;
TextColor(White) ;
WrStr('[Enter] ') ;
TextColor(Black) ;
WrStr('Выбор режима') ;
GotoXY(63,1) ;
TextColor(White) ;
WrStr('[Esc] ') ;
TextColor(Black) ;
WrStr('Выход') ;
PutOnTop(Ccc) ;
      ot:=RdCharDirect() ;
      CASE ot OF
         | (CHAR(0DH)) : (* Enter *)
                         CASE m OF
                            | 0 : (* загрузка      *)
                                  zagr() ;
                                  Shadow(Aaa) ;
                            | 1 : (* сохранение    *)
                                  tek_put:='d:\data' ;
                                  FIO.ChDir(tek_put) ;
                                  read_dir (shabl) ;
                                  Sss:=Open(SS) ;
                                  put_title() ;
                                  s:=Open_Sh(Sss) ;
                                  PutOnTop(Sss) ;
                                  otmetka(2) ;
                                  Close_Sh(s) ;
                                  Close(Sss) ;
                                  Shadow(Aaa) ;
                            | 2 : (* архивирование *)
                                  NR() ;
                                  Shadow(Aaa) ;
                            | 3 : (* перепаковка   *)
                                  NR() ;
                                  Shadow(Aaa) ;
                            | 4 : (* выход         *)
                                  EXIT ;
                         END ; (* CASE *)
         | (CHAR(27))  : (* Esc *)
                          EXIT ;
         | (CHAR(00))  : ot:=RdCharDirect() ;
                         CASE ot OF
                            | (CHAR(75))  : (* влево *)
                              IF m=0 THEN
                                    pasiv_m(m) ;
                                    m:=4 ;
                                    aktiv_m(m) ;
                                 ELSE
                                    pasiv_m(m) ;
                                    m:=m-1 ;
                                    aktiv_m(m) ;
                              END ; (* IF *)
                            | (CHAR(77))  : (* вправо*)
                              IF m=4 THEN
                                    pasiv_m(m) ;
                                    m:=0 ;
                                    aktiv_m(m) ;
                                 ELSE
                                    pasiv_m(m) ;
                                    m:=m+1 ;
                                    aktiv_m(m) ;
                              END ; (* IF *)
                          END ; (* CASE *)
      END ; (* case *)
   END ; (* LOOP *)
   FIO.ChDir(put) ;
   Close(Bbb) ;
   Close(Ccc) ;
   Close(Aaa) ;
   Close(Ddd) ;
   Close(Yyy) ;
END cf.
