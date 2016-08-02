IMPLEMENTATION MODULE FILE ;

FROM FIO      IMPORT GetDir,ChDir,IOresult,ReadFirstEntry,ReadNextEntry,
                     GetPos,RdBin,Seek,Close,Open,IOresult,Size,AssignBuffer,
                     RdStr,
                     BufferOverhead,
                     EOF,File,IOcheck,FileAttr,DirEntry,directory,archive ;

              IMPORT SYSTEM,Str,Lib,IO   ;

FROM mouse    IMPORT MousX,MousY,MousOn,MousGet,MousOff,Trigger,r   ;
FROM Etiketka IMPORT Analiz ;
              IMPORT AsmImage,Gra  ;


PROCEDURE Ochistka ;
VAR i  : CARDINAL ;
BEGIN FOR i:=1 TO HIGH(FILE.Spisok) DO
         FILE.Spisok[i] := 0
      END ;
      FILE.otm := 0 ;
END Ochistka ;

PROCEDURE Komponovka(aa : CARDINAL ) ;
VAR i : CARDINAL ;
BEGIN FILE.Spisok[aa] := 0 ;
      IF aa >= HIGH(FILE.Spisok) THEN RETURN END ;
      FOR i:=aa TO HIGH(FILE.Spisok)-1 DO
           FILE.Spisok[i] := FILE.Spisok[i+1]  ;
      END ;
      FILE.Spisok[HIGH(FILE.Spisok)] := 0 ;
END Komponovka ;


PROCEDURE GetPut() ;
VAR fff : ARRAY[0..5] OF CHAR ;
BEGIN r.AH:=19H   ;                   (* определили текущий диск *)
      Lib.Dos(r)  ;
        tek_drive:=CHAR(41H+r.AL)  ;
        fff[0]:=tek_drive ;
        fff[1]:=':' ;
        fff[2]:=CHR(0) ;
        GetDir(0,tek_put) ; (* определяем текущую директорию для текущего диска *)
                            (* DOS может выдать сообщение в I24_Graph.mod *)
        IF IOresult()#0 THEN okk := FALSE ; RETURN END ;
        IF Str.Length(tek_put)#0 THEN Str.Append(fff,'\') END ;
        Str.Concat(tek_put,fff,tek_put) ;
        okk := TRUE ;
END GetPut ;

PROCEDURE Katalog() ;
VAR atrib   : FileAttr  ;
    otvet   : DirEntry  ;
    Path    : ARRAY[0..63] OF CHAR ;
PROCEDURE  PPPPP(): BOOLEAN  ;
BEGIN  INC(KolFile) ;
       Str.Copy(Name[KolFile],otvet.Name) ;
       IF otvet.attr=FileAttr{directory} THEN
             Str.Insert(Name[KolFile],'\',0) ;  RETURN TRUE
       END ;
       RETURN FALSE
END PPPPP ;

PROCEDURE POISK_DIR ;
VAR pr      : BOOLEAN ;
    put_net : ARRAY[0..63] OF CHAR ; (* путь текущего директория сетевых дисков *)
LABEL DDD,Dalsh ;
BEGIN pr := ReadFirstEntry(Path,FileAttr{directory},otvet) ;
                           (* просмотр директорий сетевых дисков *)
      IF otvet.rsvd[0]=SHORTCARD('Z') THEN
            r.AH := 47H ;               (* дать оглавление диска *)
            r.DL := SHORTCARD(tek_drive)-40H ;
            r.DS := SYSTEM.Seg(put_net) ;
            r.SI := SYSTEM.Ofs(put_net) ;
            Lib.Dos(r) ;
            IF Str.Length(put_net)#0 THEN
                  INC(KolFile) ;
                  Name[KolFile] := '\..' ;
                  IF pr THEN GOTO DDD END ;
            END ;
      END ;
                           (* обычный просмотр *)
      IF pr THEN
            IF otvet.Name[0]='.' THEN GOTO Dalsh END ;
    DDD   : IF NOT(PPPPP()) THEN DEC(KolFile) END ;
    Dalsh : LOOP
                IF NOT(ReadNextEntry(otvet)) THEN EXIT END ;
                IF NOT(PPPPP()) THEN DEC(KolFile) END ;
            END ; (*   loop   *)
      END ;  (*  if  *)
END POISK_DIR;

PROCEDURE POISK_FILE ;
BEGIN IF ReadFirstEntry(Path,FileAttr{directory},otvet) THEN
          IF PPPPP() THEN DEC(KolFile) END ;
          LOOP
             IF NOT(ReadNextEntry(otvet)) THEN EXIT END ;
             IF PPPPP() THEN DEC(KolFile) END ;
          END ; (*   loop   *)
      END ;  (*  if  *)
END POISK_FILE;

BEGIN
      KolFile := 0 ;
      Str.Copy(Path,tek_put) ;
      Str.Append(Path,'\*.*') ;
    POISK_DIR ;    (****** изменяется глобальная KolFile ******)
      Str.Copy(Path,tek_put) ;
      Str.Append(Path,Cur_Shabl) ;
    POISK_FILE ;   (****** изменяется глобальная KolFile ******)
END Katalog ;

PROCEDURE ChangeDir( sss : ARRAY OF CHAR ) ;
BEGIN Str.Append(tek_put,sss) ;
      ChDir(tek_put) ;
      GetPut() ;
END ChangeDir ;

PROCEDURE Select_File(kkkk : CARDINAL) ;
    (* kkkk - макс. колич. отмечиваемых файлов *)
TYPE Ygli = ARRAY[0..2] OF CARDINAL ;
CONST x = 11 ;  (* координаты начала окна просмотра каталога *)
      y = 4 ;
      st  = 'выход' ;
VAR z,i,j,n,Kol, XX, Na,kk   : CARDINAL ;
    Color   : SHORTCARD ;
    string  : ARRAY[0..64] OF CHAR ;
LABEL M1,M2,M3,   G1  ;
BEGIN
    MousX(x<<3,(x+4*13+2)<<3-3) ;
    MousY(y*14,(y+11)*14-2) ;
(* меню выхода *)
    Gra.BoxFull((x-1)<<3+4,(y+10)*14,(x+4*13)<<3-4,(y+11)*14,05H); (* малиновость *)
    Gra.Box    ((x-1)<<3+2,(y+10)*14,(x+4*13)<<3-2,(y+11)*14,15) ; (* окантовка ее *)
    Gra.WriteStr(0,x+23,y+10,8AH,st); (* пишем слово "ВЫХОД" под окном с перечнем файлами *)

(* стрелочки и ползунок выбора файлов *)
    Gra.Terka((x+4*13-1)<<3,y*14-13,(x+4*13+2)<<3  ,(y+10)*14-1 );
    Gra.Box  ((x+4*13)<<3-1,y*14-7 ,(x+4*13+2)<<3-1,(y+10)*14,15); (* окантовка ее *)

    AsmImage.WriteStr_XY(0,(x+4*13)<<3+4, y*14-5    ,89H,'') ;
    AsmImage.WriteStr_XY(0,(x+4*13)<<3+4, (y+9)*14+1,89H,'') ;

M1 :
    Ochistka ;
    n := 0 ;
    Gra.Terka((x-1)<<3  ,y*14-13   ,(x+4*13-1)<<3,(y+10)*14-1 ) ;
    Gra.Box  ((x-1)<<3+2,(y-1)*14+7,(x+4*13)<<3-2,(y+11)*14,15) ; (*белая окант. поля подменю*)
    Str.Concat(string,tek_put,Cur_Shabl) ;
    i := Str.Length(string) ;
    Gra.WriteStr(0,(52-SHORTCARD(i)) >> 1+x,y-1,0FH,string) ;
M3 :
    Gra.BoxFull((x+4*13)<<3+2,(y+1)*14-5,(x+4*13+2)<<3-4,(y+9)*14 ,07H);(* фон ползунка *)
    IF KolFile>0 THEN
          z := 113 DIV ((KolFile-1) DIV 40 + 1 )        (* общее количество линий *)
    ELSE  z := 113 ; Name[1,0] := CHR(0)
    END ;
    Na := ((y+1)*14-3)+((n DIV 40)*z) ;
    Gra.BoxFull((x+4*13)<<3+4,Na,(x+4*13+2)<<3-6,Na+z,0CH) ;     (* ползунок *)

    z   := 0 ; (* текущее значение номера выводимого файла *)
    Kol := 0 ; (* количество выведенных файлов в одно окно не более 40 *)
               (* n - номер первого выведенного файла из списка ( кратно 40)*)
    LOOP  j := z>>2              ;    (* выводим имена файлов *)
          i := (z-(j<<2))*13 + x ;
          j := j + y ;
          XX := 1 ;
          LOOP
             IF XX>otm           THEN Color:=0BH ; EXIT END ;
             IF Spisok[XX]=n+z+1 THEN Color:=0EH ; EXIT END ;
             INC(XX) ;
          END ;  (* loop *)
          IF ((z+n)>=KolFile) OR (Kol>=40) THEN EXIT END ;
          AsmImage.WriteStr_XY(0,i<<3,j*14,CARDINAL(Color),Name[n+z+1]) ;
          INC(z)  ;  INC(Kol) ;
    END ;  (* loop *)
M2 :
    MousOn ;
    Trigger ;
    LOOP  MousGet ;
          IF (r.BX=1)OR(r.BX=2) THEN
              i := (r.CX>>3 -x) DIV 13     ; (* X *)
              j :=  r.DX        DIV 14 - y ; (* Y *)
              z := j<<2 + i + 1 ;
              XX := r.CX ; kk := r.BX ;
              MousOff ;
              IF XX < (x+52)<<3-2 THEN
                 IF j<10 THEN                         (* бегаем по перечню *)
                   IF (z#0)AND((z+n)<=KolFile) THEN
                      IF kk=1 THEN   (* сделать желтым - клав. 1 *)
                         IF Name[z+n,0]= '\' THEN
                            ChangeDir(Name[z+n]) ;
                            Katalog ;
                            GOTO M1
                         ELSE
                            kk := z+n ;
                            z  := 1 ;
                            LOOP  (* проверка на наличие уже отмеченного файлa *)
                                IF z>otm THEN EXIT END ; (* файл в списке не найден *)
                                IF Spisok[z]=kk THEN
                                   DEC(otm) ; Komponovka(z)  ;
                                   GOTO G1 ;
                                END ;
                                INC(z) ;
                            END ; (* loop *)
                            IF NOT(Analiz(Name[kk])) THEN GOTO M2 END ;
                            IF otm<kkkk THEN INC(otm) (*кол.отмеч.файлов*) END ;
                            Spisok[otm] := kk ;
G1 :                        Gra.WriteStr(0,SHORTCARD(i*13+x),SHORTCARD(j+y),85H,Name[kk]);
                            IF otm=kkkk THEN Lib.Delay(120) ; EXIT END ;
                            GOTO M2
                         END ;  (* каталог / не каталог *)
                      ELSE                     (*  смотрим этикетку клав -2 *)
                          (* здесь был просмотр этикетки *)
                      END ; (* клавиша 1 или 2 *)
                   END ;
                 ELSIF (j>=10)AND(kk=1) THEN          (* выход *)
                   EXIT
                 END ; (* if по Y *)
              ELSIF XX < (x+52)<<3 + 2 THEN
              ELSE
                 IF j<=1 THEN
                   IF n>= 40 THEN                                (*  *)
                       Gra.Terka(x<<3,y*14,(x+4*13-1)<<3,(y+10)*14-1) ;
                       n:= n-40 ; GOTO M3
                   END ;
                 ELSIF j<=8 THEN
                 ELSIF j<=9 THEN                                  (*  *)
                   IF (z#0)AND((Kol+n)<KolFile) THEN
                      Gra.Terka(x<<3,y*14,(x+4*13-1)<<3,(y+10)*14-1) ;
                      n := n+40 ;  GOTO M3 ;
                   END ;
                 END ;
              END ; (* if по X *)
              MousOn ;
          END ;    (* if по нажатой клавише  *)
          IF r.BX = 4 THEN                     (* ВЫХОД ПО "4" *)
               MousOff ; EXIT
          END ;
     END ; (* loop *)

END Select_File ;

PROCEDURE DiskFree(long:LONGCARD):BOOLEAN ;
(* long - количесво требуемой памяти *)
VAR baijt: LONGCARD;
    r    : SYSTEM.Registers ;
BEGIN
   r.AH:= 36H;
   r.DL:= 0;
   Lib.Intr(r,21H);
   IF   r.AX#0FFFFH THEN
       baijt:= LONGCARD(r.BX)*LONGCARD(r.AX)*LONGCARD(r.CX);
       IF baijt>long THEN RETURN TRUE END
   END; (* if *)
   RETURN FALSE
END DiskFree;


BEGIN
  IOcheck:=FALSE ;
  Ochistka ;
END FILE.