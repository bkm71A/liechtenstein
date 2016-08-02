MODULE GS ;
FROM Graph    IMPORT GraphMode,TextMode,HLine,Line ;
FROM IO       IMPORT RdCharDirect,KeyPressed ;
FROM Gra      IMPORT Get_Image,Put_Image ;
FROM prosmotr IMPORT titl,analiz,prosm,view,name_file,pri_file,vibor,
                     ff,buf,priznak,ot,Fon_Screen,paht1 ;
FROM stat     IMPORT stat2 ;
              IMPORT Lib,SYSTEM,Str,FIO ;
CONST s           = '\' ;

VAR  r            : SYSTEM.Registers ;
     paht         : ARRAY[0..80] OF CHAR ;    (* путь к файлам              *)
(*   paht1        : ARRAY[0..80] OF CHAR ;    (* текущий путь               *)*)
     nom          : CARDINAL ;                (* номер выбранного файла     *)
     n_file       : ARRAY[1..512] OF FIO.PathTail ;(* список файлов в директории *)
     p_file       : ARRAY[1..512] OF BOOLEAN ; (* признак выбранности файла *)
     D            : FIO.DirEntry ;                (* для чтения имен файлов *)
     p            : BOOLEAN ;           (* для отказа от режима выбора пути *)
     pv           : BOOLEAN ;           (* признак отказа от выбора файлов  *)
     ps           : BOOLEAN ;           (* признак обработанных файлов      *)
     adr          : ADDRESS ;           (* адрес для запуска модулей        *)
     adrlen       : CARDINAL ;          (* длина блока в байтах             *)
PROCEDURE ramka (x1,y1,x2,y2,Color : CARDINAL) ;
                (*       рисует рамку      *)
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
(* вывод строки текста на первую страницу графического экрана *)
BEGIN

   r.AX := 1300H ;              (* писать строку(А), не трогать курсор(AL)  *)
   r.BX := CARDINAL(cwet)   ;   (* номер видео страницы [0] + атрибут строки *)
   r.CX :=  Str.Length(str) ;   (* длинна строки - считаем только символы   *)
   r.DH :=   row ;              (* строка начала вывода                     *)
   r.DL :=   col ;              (* колонка начала вывода                    *)
   r.BP := SYSTEM.Ofs(str)  ;   (*         выводимая                        *)
   r.ES := SYSTEM.Seg(str)  ;   (*            строка                        *)
   Lib.Intr(r,10H);
END WriteStr;

PROCEDURE tek_put ;
   VAR    i         : SHORTCARD ;
          path_name : ARRAY [0..80] OF CHAR ;
BEGIN
   r.AH:=19H ; Lib.Dos(r) ;
   i := r.AL+1 ;
   Str.Copy(paht1,CHAR(i+40H)) ;
   FIO.GetDir(0,path_name) ;
   Str.Concat(paht1,paht1,':\') ;
   Str.Concat(paht1,paht1,path_name)
END tek_put ;

PROCEDURE put;
BEGIN
(* вывод текущего пути *)
   kvadrat(6,40,639,56,3) ;
   ramka(6,40,639,56,15) ;
   WriteStr(2,3,82H,'путь: ');
(* задание текущего пути *)
   Str.Caps(paht) ;
   WriteStr(8,3,82H,paht);
END put;

PROCEDURE vvod ;
(* процедура для ввода пути на диске *)
VAR  i    : CARDINAL ;
BEGIN
   p:=TRUE ;
   Fon_Screen ;
(*   kvadrat(421,68,639,328,0) ;*)
   i:=1 ;
   kvadrat(6,40,639,56,3) ;
   ramka(6,40,639,56,15) ;
   WriteStr(2,3,82H,'путь: ');
   LOOP
(* вывод текущего пути *)
   WriteStr(8,3,02H,paht);
(* рисует курсор *)
      HLine((i+8-1)*8,54,(i+8)*8,15) ;
      ot:=RdCharDirect() ;
      CASE ot OF  |  (CHAR(0DH)) : (* Enter *)

                     FIO.ChDir(paht) ;
                     nom:=FIO.IOresult() ;
                     IF nom=0 THEN
                           EXIT ;
                        ELSE
                           Lib.Sound(400) ;
                           Get_Image(56,128,584,204) ;
                           kvadrat(60,132,580,200,4) ;
                           ramka(56,128,584,204,15) ;
                           WriteStr(34,10,8BH,'О Ш И Б К А  !');
                           WriteStr(34,11,8BH,'путь не найден');
                           WriteStr(21,13,83H,'для продолжения нажмите любую клавишу');
                           Lib.NoSound ;
                           ot:=RdCharDirect() ;
                           Put_Image(56,128,584,204) ;

                     END ; (* IF *)
                  |  (CHAR(27))  : (* Esc *)
                     p:=FALSE ;
(*                     kvadrat(6,40,639,56,0) ;*)
                     EXIT ;
                  |  (CHAR(08H)) : (* Backspace *)
                     IF i>1 THEN
                           IF i<=Str.Length(paht) THEN
                                 HLine((i+8-1)*8,54,(i+8)*8,0) ;
                              ELSE
                                 HLine((i+8-1)*8,54,(i+8)*8,3) ;
                           END ; (* if *)
                           kvadrat((Str.Length(paht)+8-1)*8,41,(Str.Length(paht)+8)*8,55,3) ;
                           Str.Delete(paht,i-2,1) ;
                           i:=i-1 ;
                     END ; (* IF *)
                   | (CHAR(00))   : ot:=RdCharDirect() ;
                     CASE ot OF CHAR(83) :
                                kvadrat((Str.Length(paht)+8-1)*8,41,(Str.Length(paht)+8)*8,55,3) ;
                                Str.Delete(paht,i-1,1) ;
                              | (CHAR(75))  : (* влево *)
                                IF i>1 THEN
                                      IF i<=Str.Length(paht) THEN
                                            HLine((i+8-1)*8,54,(i+8)*8,0) ;
                                         ELSE
                                            HLine((i+8-1)*8,54,(i+8)*8,3) ;
                                      END ; (* if *)
                                      i:=i-1 ;
                                END ; (* IF *)
                              | (CHAR(77))  : (* вправо*)
                                IF i<=Str.Length(paht) THEN
                                      HLine((i+8-1)*8,54,(i+8)*8,0) ;
                                      i:=i+1 ;
                                END ; (* IF *)
                     END ; (* CASE *)
         ELSE (* CASE *)
            Str.Insert(paht,ot,i-1) ;
            HLine((i+8-1)*8,54,(i+8)*8,0) ;
            i:=i+1 ;
      END ; (* case *)
   END ; (* LOOP *)
   put ;
END vvod ;

PROCEDURE read_dir(chablon : ARRAY OF CHAR) ;
(* чтение каталога диска *)
   VAR  p         : CARDINAL ;
   chablon1       : ARRAY [1..64] OF CHAR ;
   pr             : BOOLEAN ;
   put_net        : ARRAY[0..63] OF CHAR ;
BEGIN
   p:=Str.Length(chablon) ;
   IF Str.Match(chablon[p-1],'\') THEN
         Str.Concat(chablon1,chablon,'*.*') ;
         Str.Concat(chablon,chablon,'*.DAT') ;
      ELSE
         Str.Concat(chablon1,chablon,'\*.*') ;
         Str.Concat(chablon,chablon,'\*.DAT') ;
   END ; (* IF *)
   FOR nom :=1 TO 512 DO
      n_file[nom]:='' ;
      p_file[nom]:=FALSE ;
   END ; (*FOR *)
   nom := 1 ;
(* чтение директорий *)
   pr:=FIO.ReadFirstEntry(chablon1,FIO.FileAttr{FIO.directory},D) ;
                              (* просмотр директорий сетевых дисков *)
   IF D.rsvd[0]=SHORTCARD('Z') THEN
         r.AH := 47H ;               (* дать оглавление диска *)
         r.DL := SHORTCARD(paht[0])-40H ;
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
                        nom:=nom+1 ;
                  END ; (* IF *)
            END ; (* if *)
         ELSE   EXIT ;
      END ; (* IF *)
   END ; (* loop *)

(* чтение имен файлов *)
   IF FIO.ReadFirstEntry(chablon,FIO.FileAttr{FIO.archive,
                        FIO.readonly},D) THEN
            n_file[nom]:=D.Name ;
            nom:=nom+1 ;
   END ; (* IF *)
   LOOP
      IF FIO.ReadNextEntry(D) THEN
                  n_file[nom]:=D.Name ;
                  nom:=nom+1 ;
         ELSE nom:=nom-1 ; EXIT ;
      END ; (* IF *)
   END ; (* loop *)
END read_dir ;

PROCEDURE write_dir(line:INTEGER) ; (* номер первой выводимой строки *)
(* вывод каталога на экран, line - номер первой выводимой строки *)
VAR z    : INTEGER ;
    x,y  : SHORTCARD ;
    i    : INTEGER ;
BEGIN
   IF nom>48 THEN
         z:=48+line*3 ;
         IF z>INTEGER(nom) THEN
               z:=nom ;
         END ; (* IF *)
      ELSE
         z:=nom ;
   END ; (* IF *)
   x:=3 ; y:=7 ;
   FOR i:=line*3+1 TO z DO
      IF x>35 THEN
            x:=3 ; y:=y+1 ;
      END ; (* IF *)
      IF p_file[i] THEN
            WriteStr(x,y,8DH,n_file[i]);
         ELSE
            WriteStr(x,y,83H,n_file[i]);
      END ;
      x:=x+16 ;
   END ; (* FOR *)
END write_dir ;

PROCEDURE spisok() : BOOLEAN ;
(* вывод списка обработанных файлов *)
VAR  i         : CARDINAL ;
     nom       : CARDINAL ;
     j1        : CARDINAL ;
     p         : BOOLEAN ;
BEGIN
   (* определение обработанных файлов *)
   p:=TRUE ;
   ff:=FIO.Open('STAT.REZ') ;
   nom:=FIO.IOresult() ;
   IF nom=0 THEN
      j1:=CARDINAL(FIO.Size(ff)) ;
      j1:=CARDINAL(REAL(j1)/111.0) ;
      FIO.AssignBuffer(ff,buf) ;
      kvadrat(421,68,639,328,3) ;
      ramka(421,68,639,328,15) ;
      WriteStr(53,5,83H,'список обработанных файлов');
         FOR i:=0 TO j1-1 DO
            FIO.Seek(ff,LONGCARD(i*111)) ;
               priznak:=FIO.RdBin(ff,name_file[i+1],13) ;
               pri_file[i+1]:=FALSE ;
         END ; (* FOR *)
         FOR i:=1 TO j1 DO
            IF i>16 THEN
                   WriteStr(67,SHORTCARD(i-10),83H,name_file[i]);
                ELSE
                   WriteStr(54,SHORTCARD(i+6),83H,name_file[i]);
            END ; (* IF *)
         END ; (* FOR *)
      FIO.Close(ff) ;
      ELSE
(* анализ ошибки на открытие файла *)

         kvadrat(421,68,639,328,3) ;
         ramka(421,68,639,328,15) ;
         WriteStr(54,5,83H,'нет обработанных файлов');

(*         kvadrat(421,68,639,328,0) ;*)
         p:=FALSE ;
   END ; (* IF *)
   RETURN p ;
END spisok ;

PROCEDURE otmetka ;
(* выбор списка файлов *)
VAR x,y          : SHORTCARD ;          (* координаты для выбора файла   *)
    x1,y1        : CARDINAL ;           (* координаты для графич. экрана *)
    z            : CARDINAL ;           (* номер текущего файла          *)
    line         : INTEGER ;            (* номер первой выводимой строки *)
    p            : CARDINAL ;           (* длинна пути                   *)
    i            : CARDINAL ;           (* переменная цикла              *)
    j            : CARDINAL ;           (* переменная цикла              *)
BEGIN
(* запомнить левый экран *)
(*   Get_Image(6,68,410,328) ;*)
(* рисование рамок для каталогов *)
   kvadrat(6,68,410,328,3) ;
   ramka(6,68,410,328,15) ;
   WriteStr(12,5,82H,' список файлов для выбора ');
(* вывод списка обработанных файлов, если они есть *)
   ps:=spisok() ;
(* чтение текущего подкаталога *)
   read_dir(paht) ;
(* вывод файлов на экран *)
   line:=0 ;
   write_dir(line) ;
   z:=1 ; x:=3 ; y:=7 ;
   pv:=TRUE ;
   LOOP
      x1:=CARDINAL(x)*8 ; y1:=CARDINAL(y)*14 ;
      IF p_file[z] THEN
            WriteStr(x,y,0EH,n_file[z]) ;
         ELSE
            WriteStr(x,y,0FH,n_file[z]) ;
      END ; (* IF *)
      ot:=RdCharDirect() ;

      CASE ot OF (CHAR(00))  : ot:=RdCharDirect() ;
      CASE ot OF (CHAR(72))  : (* вверх *)
                               IF z>3 THEN
                                     kvadrat(x1,y1,x1+96,y1+14,3) ;
                                     IF p_file[z] THEN
                                           WriteStr(x,y,8DH,n_file[z]);
                                        ELSE
                                           WriteStr(x,y,83H,n_file[z]) ;
                                     END ; (* IF *)
                                     z:=z-3 ;
                                     IF y>7 THEN
                                           y:=y-1
                                        ELSE
                                           line:=line-1 ;
                                           kvadrat(24,95,402,320,3) ;
                                           write_dir(line) ;
                                     END ; (* IF *)
                               END ; (* IF *)
               | (CHAR(59))  : (*  F1 - HELP *)
                               (* вывод окна - подсказки *)
                               kvadrat(0,335,639,349,6) ;
                               WriteStr(22,24,86H,'Для продолжения нажмите любую клавишу') ;
                               (* вывод  подсказки *)
                               Get_Image(140,90,500,232) ;
                               kvadrat(140,95,500,232,6) ;
                               ramka(145,95,495,227,15) ;
                               WriteStr(33,8,89H,'ОКНО ПОДСКАЗКИ') ;
                               WriteStr(22,10,89H,'[<>^V]') ;
                               WriteStr(36,10,86H,'Перемещение курсора') ;
                               WriteStr(22,11,89H,'[Ins]') ;
                               WriteStr(36,11,86H,'Отметить файл') ;
                               WriteStr(22,12,89H,'[SpaseBar]') ;
                               WriteStr(36,12,86H,'Просмотр этикетки') ;
                               WriteStr(22,13,89H,'[Enter]') ;
                               WriteStr(36,13,86H,'Выбор отмеченных файлов') ;
                               WriteStr(22,14,89H,'[Esc]') ;
                               WriteStr(36,14,86H,'Отказ') ;
                               ot:=RdCharDirect () ;
                               Put_Image(140,90,500,232) ;
                               (* вывод строки - подсказки *)
                               kvadrat(0,335,639,349,6) ;
                               WriteStr(32,24,89H,'[F1]') ;
                               WriteStr(38,24,86H,'Подсказка') ;
               | (CHAR(80))  : (* вниз  *)
                               IF ((x=3)AND((z+3)<=nom))OR
                                    ((x=19)AND((z+2)<=nom))OR
                                      ((x=35)AND((z+1)<=nom)) THEN
                                     kvadrat(x1,y1,x1+96,y1+14,3) ;
                                     IF p_file[z] THEN
                                           WriteStr(x,y,8DH,n_file[z]);
                                        ELSE
                                           WriteStr(x,y,83H,n_file[z]) ;
                                     END ; (* IF *)
                                     IF z+3<=nom THEN
                                           z:=z+3 ;
                                           IF y=22 THEN
                                                 (* смещение по директории *)
                                                 line:=line+1 ;
                                                 kvadrat(24,95,402,320,3) ;
                                                 write_dir(line) ;
                                              ELSE
                                                 y:=y+1 ;
                                           END ; (* IF *)
                                        ELSE
                                           (* смещение по директории с
                                              изменением координаты x *)
                                           IF y=22 THEN
                                                 line:=line+1 ;
                                                 kvadrat(24,95,402,320,3) ;
                                                 write_dir(line) ;
                                              ELSE
                                                 y:=y+1 ;
                                           END ; (* IF *)
                                           IF x=3 THEN
                                              z:=z+3 ;
                                           END ; (* IF *)
                                           IF x=19 THEN
                                                 IF z+2=nom THEN
                                                       x:=3 ; z:=z+2 ;
                                                    ELSE
                                                       z:=z+3 ;
                                                 END ; (* IF *)
                                           END ; (* IF *)
                                           IF x=35 THEN
                                                 IF z+2=nom THEN
                                                       x:=19 ; z:=z+2 ;
                                                    ELSE
                                                       x:=3 ; z:=z+1 ;
                                                 END ; (* IF *)
                                           END ; (* IF *)
                                     END ; (* IF *)
                               END ; (* if *)
               | (CHAR(75))  : (* влево *)
                               IF z>1 THEN
                                     kvadrat(x1,y1,x1+96,y1+14,3) ;
                                     IF p_file[z] THEN
                                           WriteStr(x,y,8DH,n_file[z]);
                                        ELSE
                                           WriteStr(x,y,83H,n_file[z]) ;
                                     END ; (* IF *)
                                     z:=z-1 ;
                                     IF x=3 THEN
                                           x:=35 ;
                                           IF y=7 THEN
                                                 line:=line-1 ;
                                                 kvadrat(24,95,402,320,3) ;
                                                 write_dir(line) ;
                                              ELSE
                                                 y:=y-1 ;

                                           END ;(* IF *)
                                        ELSE
                                           x:=x-16 ;
                                     END ; (* IF *)
                               END ; (* IF *)
               | (CHAR(77))  : (* вправо*)
                               IF z< nom THEN
                                     kvadrat(x1,y1,x1+96,y1+14,3) ;
                                     IF p_file[z] THEN
                                           WriteStr(x,y,8DH,n_file[z]);
                                        ELSE
                                           WriteStr(x,y,83H,n_file[z]) ;
                                     END ; (* IF *)
                                     z:=z+1 ;
                                     IF x>30 THEN
                                           IF y<22 THEN
                                                 x:=3 ; y:=y+1 ;
                                              ELSE
                                                 (* смещение по директории *)
                                                 line:=line+1 ;
                                                 kvadrat(24,95,402,320,3) ;
                                                 write_dir(line) ;
                                                 x:=3 ;
                                           END ; (* IF *)
                                        ELSE
                                           x:=x+16;
                                     END ; (* IF *)
                               END ; (* IF *)
               | (CHAR(82)) : (* Insert *)
                               IF Str.Pos(n_file[z],s)=0 THEN
                                  ELSE
                                  IF analiz(n_file[z]) THEN
                                     p_file[z]	:= NOT(p_file[z]) ;
                                     IF z< nom THEN
                                           kvadrat(x1,y1,x1+96,y1+14,3) ;
                                           IF p_file[z] THEN
                                                 WriteStr(x,y,8DH,n_file[z]);
                                              ELSE
                                                 WriteStr(x,y,83H,n_file[z]) ;
                                           END ; (* IF *)
                                           z:=z+1 ;
                                           IF x>30 THEN
                                                 IF y<20 THEN
                                                       x:=3 ; y:=y+1 ;
                                                    ELSE
                                                       (* смещение по директории *)
                                                       line:=line+1 ;
                                                       kvadrat(24,95,402,320,3) ;
                                                       write_dir(line) ;
                                                       x:=3 ;
                                                 END ; (* IF *)
                                              ELSE
                                                 x:=x+16;
                                           END ; (* IF *)
                                     END ; (* IF *)
                                  END ; (* IF *)
                               END ; (* IF *)
      END ; (* case *)
               | (CHAR(27))  : (* Esc   *)
                               pv:=FALSE ;
                               EXIT ;
               | (CHAR(0DH)) : (* Enter *)
                               IF Str.Pos(n_file[z],s)=0 THEN
                                     (* изменить директорию *)
                                     IF Str.Pos(n_file[z],'\..')=0 THEN
                                           (* движение вверх *)
                                           p:=Str.Length(paht) ;
                                           LOOP
                                              Str.Delete(paht,p-1,1) ;
                                              DEC(p) ;
                                              IF Str.Match(paht[p-1],'\') THEN
                                                    IF p>3 THEN
                                                           Str.Delete(paht,p-1,1) ;
                                                    END ; (* IF *)
                                                    FIO.ChDir(paht) ;
                                                    read_dir(paht) ;
                                                    kvadrat(24,95,402,320,3) ;
                                                    line:=0 ;
                                                    write_dir(line) ;
                                                    z:=1 ; x:=3 ; y:=7 ;
                                                    put ;
                                                    ps:=spisok() ;
                                                    EXIT ;
                                              END ; (* IF *)
                                           END ; (* LOOP *)

(*                                           FIO.IOcheck:=FALSE ;
                                           LOOP
                                              p:=Str.Length(paht) ;
                                              Str.Delete(paht,p-1,1) ;
                                              FIO.ChDir(paht) ;
                                              nom:=FIO.IOresult() ;
                                              IF nom=0 THEN
                                                    read_dir(paht) ;
                                                    kvadrat(24,95,402,320,3) ;
                                                    line:=0 ;
                                                    write_dir(line) ;
                                                    z:=1 ; x:=3 ; y:=7 ;
                                                    put ;
                                                    ps:=spisok() ;
                                                    EXIT ;
                                              END ; (* IF *)
                                           END ; (* loop *)
*)
                                        ELSE
                                           (* движение вниз *)
                                           p:=Str.Length(paht) ;
                                           IF Str.Match(paht[p-1],'\') THEN
                                                 Str.Delete(paht,p-1,1) ;
                                           END ; (* IF *)
                                           Str.Concat(paht,paht,n_file[z]) ;
                                           FIO.ChDir(paht) ;
                                           read_dir(paht) ;
                                           kvadrat(24,95,402,320,3) ;
                                           line:=0 ;
                                           write_dir(line) ;
                                           z:=1 ; x:=3 ; y:=7 ;
                                           put ;
                                           ps:=spisok() ;
                                     END ; (* IF *)
                                  ELSE
                                        EXIT ;
                               END ; (* if *)
               | (CHAR(32))   : (* Spase Bar *)
                                (* просмотр этикетки *)
                                prosm(n_file[z]) ;
      END ; (* case *)
   END ; (* loop *)
(* стирание окна выбора файлов *)
Fon_Screen ;
put() ;
ps:=spisok() ;
   IF pv THEN   (* если мы вышли через Esc *)
      j:=1 ;
      LOOP
         FOR i:=1 TO nom DO
            IF p_file[i] THEN
                  Str.Copy(name_file[j],n_file[i]) ;
                  pri_file[j]:=TRUE ;
                  j:=j+1 ;
                  IF j>32 THEN
                     nom:=32 ;
                     EXIT ;
                  END ; (* IF *)
            END ; (* IF *)
         END ; (* for *)
         nom:= j-1 ;
         EXIT ;
      END ; (* loop *)
      nom:=j-1 ;       (* количество выбранных файлов *)
      IF nom=0 THEN    (* если вышли через ввод без выбора *)
            pv:=FALSE ;
         ELSE
(* запись выбранных файлов в правое окно *)
            kvadrat(421,68,639,328,3) ;
            ramka(421,68,639,328,15) ;
            WriteStr(55,5,83H,'список выбранных файлов');
            FOR i:=1 TO nom DO
               IF i>16 THEN
                     WriteStr(67,SHORTCARD(i-10),8DH,name_file[i]);
                  ELSE
                     WriteStr(54,SHORTCARD(i+6),8DH,name_file[i]);
               END ; (* IF *)
            END ; (* FOR *)
      END ; (* IF *)
   END ; (* IF *)
END otmetka ;

PROCEDURE obrabotka ;
VAR    i         : CARDINAL ;  (* переменная цикла                  *)
       pri       : BOOLEAN ;   (* признак для создания нового файла *)
       po        : BOOLEAN ;   (* признак приостанова обработки     *)

LABEL  otkaz ;

BEGIN
   IF pv THEN
         pri:=TRUE ;
         Get_Image(7,120,409,200) ;
(* формирование транспоранта при обработке файлов *)
         kvadrat(6,120,410,200,1) ;
         ramka(6,120,410,200,15) ;
         WriteStr(20,10,8AH,'ВНИМАНИЕ !') ;
         WriteStr(10,12,8AH,'идет обработка файла') ;

         FOR i:=1 TO nom DO
         IF pri_file[i] THEN
               pri_file[i]:=FALSE ;
               IF i>16 THEN
                     WriteStr(67,SHORTCARD(i-10),0FH,name_file[i]);
                  ELSE
                     WriteStr(54,SHORTCARD(i+6),0FH,name_file[i]);
               END ; (* IF *)
(* формирование транспоранта при обработке файлов *)
               kvadrat(260,160,370,180,1) ;
               WriteStr(33,12,8CH,name_file[i]) ;

(* обработка выбранного файла с запись результатов в файл STAT.REZ *)
               stat2(name_file[i],pri) ;
               IF i>16 THEN
                     kvadrat(536,CARDINAL(i-10)*14,536+96,CARDINAL(i-9)*14,3) ;
                     WriteStr(67,SHORTCARD(i-10),83H,name_file[i]);
                  ELSE
                     kvadrat(432,CARDINAL(i+6)*14,432+96,CARDINAL(i+7)*14,3) ;
                     WriteStr(54,SHORTCARD(i+6),83H,name_file[i]);
               END ; (* IF *)
         END ; (* if *)
(* анализ на приостонов расчета *)
         po:=KeyPressed() ;
         IF po THEN
              ot:=RdCharDirect() ;
              IF ot=CHAR(27) THEN
                    LOOP
                       kvadrat(7,121,409,199,1) ;
                       WriteStr(15,10,8DH,'процесс приостановлен') ;
                       WriteStr(5,12,8CH,'для продолжения счета нажмите любую клавишу') ;
                       WriteStr(10,13,8CH,'для выхода нажмите клавишу " Esc "') ;

                       ot:=RdCharDirect() ;
                       CASE ot OF (CHAR(27)) :
                                   ps:=spisok() ;
                                   GOTO otkaz ;
                                ELSE
(* формирование транспоранта при обработке файлов *)

                                   kvadrat(7,121,409,199,1) ;
                                   WriteStr(20,10,8AH,'ВНИМАНИЕ !') ;
                                   WriteStr(10,12,8AH,'идет обработка файла') ;
                                   EXIT ;
                       END ; (* CASE *)
                    END ; (* LOOP *)
              END ; (* IF *)
         END ; (* IF *)
         pri:= FALSE ;
         END ; (* FOR *)
               Put_Image(7,120,409,200) ;
               kvadrat(422,69,638,83,3) ;
               WriteStr(53,5,83H,'список обработанных файлов');
               pv:=FALSE ;
      ELSE
         (* нет выбранных файлов для обработки *)
         Lib.Sound(400) ;
         Get_Image(56,128,584,204) ;
     (*    kvadrat(56,128,584,204,0) ;*)
         kvadrat(60,132,580,200,4) ;
         ramka(56,128,584,204,15) ;
         WriteStr(34,10,8BH,'О Ш И Б К А !');
         WriteStr(24,11,8BH,'нет выбранных файлов для обработки');
         WriteStr(22,13,83H,'для продолжения нажмите любую клавишу');
         Lib.NoSound ;
         ot:=RdCharDirect() ;
         Put_Image(56,128,584,204) ;
   END ; (* IF *)
otkaz :
END obrabotka ;

PROCEDURE menu ;
TYPE string      =  ARRAY [1..16] OF CHAR ;
VAR x1,del_x1    :  CARDINAL ;                  (* координаты меню *)
    m            :  CARDINAL ;                  (* активный пункт меню *)
    stroka       :  ARRAY[1..4] OF string ;     (* список пунктов меню *)

   PROCEDURE akt_wind (i:CARDINAL) ;
   (* выделение активного окна *)
   BEGIN
      kvadrat(16+(i-1)*del_x1,14,16+(i-1)*del_x1+127,28,88H) ;
      ramka(16+(i-1)*del_x1,14,16+(i-1)*del_x1+127,28,82H) ;
      WriteStr(2+SHORTCARD((del_x1 DIV 8)*(i-1)),1,86H,stroka[CARDINAL(i)]) ;
   END akt_wind ;

   PROCEDURE pas_wind (i:CARDINAL) ;
   (* отмена активного окна *)
   BEGIN
      kvadrat(16+(i-1)*del_x1,14,16+(i-1)*del_x1+127,28,3) ;
      WriteStr(2+SHORTCARD((del_x1 DIV 8)*(i-1)),1,86H,stroka[CARDINAL(i)]) ;
   END pas_wind ;

BEGIN
   GraphMode ;
(* заполнение фона экрана *)
   Fon_Screen ;

(* признак выбранности файлов для обработки *)
   pv:= FALSE ;
   FIO.IOcheck:=FALSE ;
(* общая рамка для всего меню *)
   ramka(6,9,639,33,15) ;
   WriteStr(20,0,0EH,'  Э К С П Р Е С С    О Б Р А Б О Т К А  ');
(* координаты для графики *)
   x1:=16 ;
   del_x1:=160 ;
(* список режимов *)
   stroka[1]:='  Выбор файлов  ' ;   stroka[2]:=' Запуск на счет ' ;
   stroka[3]:='    В ы в о д   ' ;   stroka[4]:='    В ы х о д   ' ;
(* вывод на экран пассивных пунктов меню *)
   FOR m :=1 TO 4 DO
      pas_wind(m) ;
   END ; (* for *)
   FIO.GetDir(0,paht1) ;
   tek_put ;       (* определение текущего пути  для возврата *)
(*   Str.Copy(paht,paht1) ;*)
   FIO.ChDir('D:\DATA') ;
   Str.Copy(paht,'D:\DATA') ;
   ;
(* вывод строки - подсказки *)
      kvadrat(0,335,639,349,6) ;
      WriteStr(7,24,89H,'[<>]') ;
      WriteStr(12,24,86H,'Перемещение курсора') ;
      WriteStr(37,24,89H,'[Enter]') ;
      WriteStr(45,24,86H,'Выбор режима') ;
      WriteStr(62,24,89H,'[Esc]') ;
      WriteStr(68,24,86H,'Выход') ;
(* номер пункта меню *)
   m:=1 ;
(* выбор пункта меню *)
   LOOP
      akt_wind(m) ;

      ot:=RdCharDirect() ;
      CASE ot OF (CHAR(75))  : (* влево  *)
                               pas_wind(m) ;
                               IF m=1 THEN
                                     m:=4 ;
                                  ELSE
                                     m:=m-1 ;
                               END ; (* if *)
               | (CHAR(77))  : (* вправо *)
                               pas_wind(m) ;
                               IF m=4 THEN
                                     m:=1 ;
                                  ELSE
                                     m:=m+1 ;
                               END ; (* if *)
               | (CHAR(0DH)) : (* ENTER  *)
                               CASE m OF 1  : (* работа с файлами *)
(* вывод строки - подсказки *)
      kvadrat(0,335,639,349,6) ;
      WriteStr(0,24,89H,'[<>]') ;
      WriteStr(5,24,86H,'Перемещение курсора') ;
      WriteStr(25,24,89H,'[BackSpace,Del]') ;
      WriteStr(41,24,86H,'Убрать символ') ;
      WriteStr(55,24,89H,'[Enter]') ;
      WriteStr(63,24,86H,'Ввод') ;
      WriteStr(68,24,89H,'[Esc]') ;
      WriteStr(74,24,86H,'Отказ') ;

                                              vvod ;
                                              IF p THEN

(* вывод строки - подсказки *)
      kvadrat(0,335,639,349,6) ;
      WriteStr(32,24,89H,'[F1]') ;
      WriteStr(38,24,86H,'Подсказка') ;
                                              otmetka ;
                                              END ; (* IF *)
                                      |  2  : (* запуск на счет   *)
      kvadrat(0,335,639,349,6) ;
      WriteStr(26,24,89H,'[Esc]') ;
      WriteStr(32,24,86H,'Приостановить расчет') ;
                                              obrabotka ;
                                              pv:= FALSE ;
                                      |  3  : (* вывод            *)
                                              ps:=spisok() ;
                                              IF ps THEN
      kvadrat(0,335,639,349,6) ;
      WriteStr(7,24,89H,'[^V]') ;
      WriteStr(12,24,86H,'Перемещение курсора') ;
      WriteStr(37,24,89H,'[Enter]') ;
      WriteStr(45,24,86H,'Выбор режима') ;
      WriteStr(62,24,89H,'[Esc]') ;
      WriteStr(68,24,86H,'Выход') ;
                                              view ;
                                              Fon_Screen ;
                                              put() ;
                                              ps:=spisok() ;
                                              ELSE
                                              Lib.Sound(400) ;
         Get_Image(56,128,584,204) ;
(*         kvadrat(56,128,584,204,0) ;*)
         kvadrat(60,132,580,200,4) ;
         ramka(56,128,584,204,15) ;
         WriteStr(34,10,8BH,'О Ш И Б К А !');
         WriteStr(29,11,8BH,'нет обработанных файлов');
         WriteStr(22,13,83H,'для продолжения нажмите любую клавишу');
                                              Lib.NoSound ;
         ot:=RdCharDirect() ;
         Put_Image(56,128,584,204) ;
                                              END ; (* IF *)

                                      |  4  : (* выход            *)
                                              (*Storage.ALLOCATE(adr,20000) ;
                                              adrlen:=Lib.Execute("ds.exe",,adr,20000 DIV 16) ;
                                              Storage.DEALLOCATE(adr,2000) ;*)
                                              EXIT ;
                               END ; (* CASE *)
      kvadrat(0,335,639,349,6) ;
      WriteStr(7,24,89H,'[<>]') ;
      WriteStr(12,24,86H,'Перемещение курсора') ;
      WriteStr(37,24,89H,'[Enter]') ;
      WriteStr(45,24,86H,'Выбор режима') ;
      WriteStr(62,24,89H,'[Esc]') ;
      WriteStr(68,24,86H,'Выход') ;

               | (CHAR(27))  : (* Esc    *)
                               (* возврат в подкаталог входа *)
                               EXIT ;
      END ; (* case *)
   END ; (* loop *)
   FIO.ChDir(paht1) ;
   TextMode ;
END menu ;

BEGIN
   menu ;
END GS.