MODULE sa2034 ; (* клавиатура на экране -  работа с мышью *)
  IMPORT Lib,SYSTEM,FIO,Str,IO,Storage ;
  IMPORT Letter,GraphVl,FioVl,assa  ;
  FROM Graph  IMPORT InitEGA,EGAGraphMode,Polygon,TextMode,HLine,Line;
  FROM Timer  IMPORT Ystanovka,Reset;
  FROM mouse  IMPORT moufunc,pa,pb,pc,pd ;

TYPE                  Fill    = RECORD
                 	   Filename : ARRAY [1..13] OF CHAR;
                      END ;
VAR
  schet_pos               : ARRAY [0..10]             OF CARDINAL;
  rec                     : ARRAY [1..255]            OF Fill ;
  path                    : ARRAY [1..64]             OF CHAR ;
  stretik                 : ARRAY [1..82]             OF CHAR ;
  Fname                   : ARRAY [1..24]             OF CHAR ;
  buffer                  : ARRAY [1..8]              OF CHAR ;
  Name                    : ARRAY [1..30]             OF CHAR ;

  reg,r	                  : SYSTEM.Registers;
  file                    : FIO.File;
  aa                      : FioVl.Str24 ;
  px_quit,py_quit,
          py_quit_m,
  px_ekr, py_ekr,
  px_m,   py_m            : GraphVl.Coordinate_4 ;
  px_fn,  py_fn	          : GraphVl.Coordinate_6 ;

  i,j,p,l,z,xx,yy,tic,
  baseX,baseY,
  mouse_X,mouse_Y,
  prov_open_file,
  kolichestvo             : CARDINAL ;
  str,poz_kurs,chas,min   : SHORTCARD;
  dlinna,kkoo,f           : INTEGER ;
  answ,OT                 : CHAR;
  priz,proverka           : BOOLEAN;

CONST
   string       ::= GraphVl.str     ;
    color       ::= GraphVl.Color   ;
       px       ::= GraphVl.p_x     ;
       py       ::= GraphVl.p_y     ;

 basaX1= 30;    basaX8 =348;                 basaY1= 43;
 basaX2= 80;    basaX9 =390;                 basaY2= 84;
 basaX3=122;    basaX10=432;                 basaY3=123;
 basaX4=164;    basaX11=474;                 basaY4=163;
 basaX5=214;    basaX12=516;                 basaY5=203;
 basaX6=256;    basaX13=558;                 basaY6=243;
 basaX7=298;    basaX14=600;                 basaY7=283;

 quit       = 'QUIT'                     ;
 next       = 'MONITOR'                  ;
 previous   = 'DIRECT PANEL'             ;
 proc       = 'PROCESSING'               ;
 print      = 'PRINT'                    ;
 load       = 'LOAD'                     ;
 up         = 'PAGE UP'                  ;
 down       = 'PAGE DOWN'                ;
 save       = 'SAVE'                     ;
 help       = 'HELP'                     ;
 yes        = 'YES'                      ;
 no         = 'NO'                       ;
 transf     = 'TRANSFER'                 ;
 you        = 'ВЫ ДЕЙСТВИТЕЛЬНО'         ;
 want       = 'ХОТИТЕ ПОКИНУТЬ'          ;
 sred       = 'СРЕДУ ?'                  ;
 printer    = 'ПРИНТЕР НЕ ГОТОВ'         ;
 sost       = 'СОСТОЯНИЕ'                ;
 prod       = 'ПРОДОЛЖИТЬ'               ;
 otkaz      = 'ОТКАЗАТЬ'                 ;
 inp        = 'ВВЕДИТЕ ИМЯ ФАЙЛА'        ;
 sohr       = 'ДЛЯ СОХРАНЕНИЯ'           ;
 dat        = 'ДАННЫХ'                   ;
 etik       = 'ЭТИКЕТКА'                 ;
 osu        = 'ОСУЩЕСТВЛЯТЬ';
 pro        = 'ПРОСМОТР ЭТИКЕТКИ ?';
 s_str      = 'ТИП ОБЬЕКТА|'+
              'ДАТА ВЫХОДА|'+
              'ИНТЕРВ.ДИСКРЕТ.(мкС)|'+
              'КОЛ-ВО ТОЧEK РЕАЛИЗ.|'+
              'КОЛ-ВО ТОЧEK ПРОРЕЖ.|'+
              'МЕТОД ОБРАБОТКИ|'+
              'ИМЯ ФАЙЛА|'+
              'ПРОСМОТР|'+
              'ОТКАЗ|' ;

 LABEL	lab1,lab2,lab3,lab4,end,lab_otkaz,new_f,M1;

PROCEDURE MasageWindow(line : BOOLEAN) ;
BEGIN
GraphVl.PolygonFr(px_quit,py_quit  ,9,15);
GraphVl.PolygonFr(px_quit,py_quit_m,4,15);
IF line THEN Line(baseX+90,baseY+71,baseX+90,baseY+86,15) END ;
END MasageWindow ;

PROCEDURE Podkl_OVL(III:CARDINAL ; Nazv:ARRAY OF CHAR) ;
 VAR a   : ADDRESS ;
     i   : CARDINAL ;
BEGIN
 i:=Storage.HeapTotalAvail(Storage.MainHeap)  ;
 IF i<III THEN
              GraphVl.PWriteString(9,12,'В памяти нет места для',CHAR(8FH));
              GraphVl.PWriteString(9,13,'загрузки оверлея',CHAR(8FH)) ;
              GraphVl.PWriteString(23,13,Nazv,CHAR(8FH)) ;
              GraphVl.PWriteString(9,14,'По всей видимости в памяти',CHAR(8FH));
              GraphVl.PWriteString(9,15,' находится  слишком много',CHAR(8FH));
              GraphVl.PWriteString(9,16,'  резидентных программ.',CHAR(8FH)) ;
           RETURN  ;
 END ;
 Storage.HeapAllocate(Storage.MainHeap,a,III) ;
 i:=Lib.Execute(Nazv,' ',a,III) ;
 IF i#0 THEN
             GraphVl.PWriteString(4,5,'Нет возможности загрузить оверлей',CHAR(8FH)) ;
             GraphVl.PWriteString(15,6,Nazv,CHAR(83H)) ;
             GraphVl.PWriteString(12,8,'Код возврата = ',CHAR(84H)) ;
      r.AH := 02H;        (* установка курсора      *)
      r.BH :=  0H;        (* текущая видео страница *)
      r.DH :=   8;        (* текстовая строка       *)
      r.DL :=  27;        (* поз. курсopa в строке  *)
      Lib.Intr(r,10H);
      r.AH := 09H;                   (* зап.символа в текущей поз. кур *)
      r.AL := VAL(SHORTCARD,i+30H);  (* символ , который пишем    *)
      r.BH :=  0H;                   (* текущая видео страница    *)
      r.BL := 84H;                   (* цвет символа ( XOR )      *)
      r.CX :=   1;                   (* кол-во выводимых символов *)
      Lib.Intr(r,10H);

          IF i=2 THEN
             GraphVl.PWriteString(7,10,'Его нет в текущем каталоге.',CHAR(8FH)) ;
           ELSE
             GraphVl.PWriteString( 4,10,'Изучите документацию по MS-DOS и',CHAR(8FH));
             GraphVl.PWriteString(11,11,'узнаете причину.',CHAR(8FH)) ;
          END ;
 END ;
Storage.HeapDeallocate(Storage.MainHeap,a,III) ;
OT := IO.RdCharDirect();
END Podkl_OVL ;

PROCEDURE Poisk_file():CARDINAL  ;
 VAR x,y,z   : CARDINAL ;
     atrib   : FIO.FileAttr ;
     otvet   : FIO.DirEntry ;
     TecDisk : CHAR ;

PROCEDURE  PPPPP(tt:CARDINAL): BOOLEAN  ;
BEGIN
Str.Copy(rec[tt].Filename,otvet.Name) ;
IF otvet.attr=FIO.FileAttr{FIO.directory}
          THEN Str.Append(rec[tt].Filename,'\') ;  RETURN TRUE END ;
RETURN FALSE
END PPPPP ;

PROCEDURE POISK_DIR ;
VAR dir : BOOLEAN ;
LABEL Dalsh ;
BEGIN
    Str.Append(path,'*.*') ;
    IF FIO.ReadFirstEntry(path,FIO.FileAttr{FIO.directory},otvet)
                     THEN IF otvet.Name[0]='.' THEN GOTO Dalsh END ;
                          INC(i) ; dir:=PPPPP(i) ;
                          IF NOT(dir) THEN DEC(i) END ;
    Dalsh :               LOOP
                              IF NOT(FIO.ReadNextEntry(otvet)) THEN EXIT END ;
                              INC(i) ; dir:=PPPPP(i) ;
                              IF NOT(dir) THEN DEC(i) END ;
                           END ; (*   loop   *)
                       END ;  (*  if  *)
    path[z]:=CHAR(0)  ;
END POISK_DIR;

PROCEDURE POISK_FILE ;
VAR dir : BOOLEAN ;
BEGIN
   Str.Append(path,'*.b&k') ;
   IF FIO.ReadFirstEntry(path,FIO.FileAttr{FIO.directory,FIO.archive},otvet)
                    THEN INC(i) ; dir:=PPPPP(i) ;
                         IF dir THEN DEC(i) END ;
                         LOOP
                            IF NOT(FIO.ReadNextEntry(otvet)) THEN EXIT END ;
                            INC(i) ; dir:=PPPPP(i) ;
                            IF dir THEN DEC(i) END ;
                         END ; (*   loop   *)
                     END ;  (*  if  *)
END POISK_FILE;

PROCEDURE GETDIR ;
BEGIN      (********** дать текущий диск ************)
    r.AH:=19H ; Lib.Dos(r) ; TecDisk:=CHAR(r.AL+SHORTCARD(41H)) ;
           (********** дать директорию **************)
    FIO.GetDir(0,path) ;
    FOR i:=1 TO 3 DO
        FOR y:=(SIZE(path)-1) TO 2 BY -1 DO
                  path[y]:=path[y-1] ;
                  IF path[y]=CHAR(0) THEN z:=y END ;
        END ;    (*  for  *)
    END ;    (*  for  *)
    path[1]:=TecDisk ;
    path[2]:=':' ;
    path[3]:='\' ;
    IF z<=3 THEN z:=4 END ;
    IF path[z-1]='\' THEN path[z]:=CHAR(0)
                     ELSE path[z]:='\' ;  INC(z) ; path[z]:=CHAR(0)  END ;
END GETDIR ;

BEGIN
    GETDIR ;      (****** определяем текущий директорий ********)
    i:=0 ;
    POISK_DIR ;      (******   осуществляет поиск дирикториев
                                           изменяется глобальная i ******)
    POISK_FILE ;
    RETURN i ;
END Poisk_file ;

PROCEDURE Question(baseX,baseY : CARDINAL);
VAR
px, py,px_p,
py_men,py_p  : ARRAY [1..4]  OF CARDINAL;
         sw  : ARRAY [1..2]  OF CHAR;
          r  : SYSTEM.Registers;
        adr  : GraphVl.Address ;
xxx,yyy,i,j,
ych,nomer,abc: CARDINAL;
           m : INTEGER;
        answ : CHAR ;
LABEL  lab22,lab11;
BEGIN
lab11 :
       z := Poisk_file() ;
       m := 0 ;
px[1] := baseX;      py[1] := baseY;	    py_men[1] := baseY+222;
px[2] := baseX+475;  py[2] := baseY;	    py_men[2] := baseY+222;
px[3] := baseX+475;  py[3] := baseY+220;    py_men[3] := baseY+242;
px[4] := baseX;      py[4] := baseY+220;    py_men[4] := baseY+242;

abc:=Str.Length(path)*9+25 ;
px_p[1] := baseX+233-abc >> 1 ;   py_p[1] := baseY;
px_p[2] := baseX+233+abc >> 1 ;   py_p[2] := baseY;
px_p[3] := baseX+233+abc >> 1 ;   py_p[3] := baseY+13;
px_p[4] := baseX+233-abc >> 1 ;   py_p[4] := baseY+13;

moufunc(2,0,0,0) ;
GraphVl.PolygonFr(px,py,9,14);
GraphVl.PolygonFr(px,py_men,4,14);
Line(baseX+130,baseY+222,baseX+130,baseY+242,14);
Line(baseX+330,baseY+222,baseX+330,baseY+242,14);

GraphVl.PaintString(ADR(up),  baseX+ 35,baseY+228,15);
GraphVl.PaintString(ADR(down),baseX+195,baseY+228,15);
GraphVl.PaintString(ADR(quit),baseX+385,baseY+228,15);

lab22:
j   := 1 ;
ych := 1 ;
Polygon(4,px,py,9);
GraphVl.PolygonFr(px_p,py_p,4,14);
GraphVl.PaintString(ADR(path),baseX+248-abc >> 1 ,baseY+3,15);

LOOP
   FOR i:= 0 TO 3 DO
   nomer:=j+CARDINAL(m);
         IF nomer > z THEN EXIT END ;
   GraphVl.PaintString(ADR(rec[nomer].Filename),
                                               baseX+5+i*120,baseY+ych*20,15);
   INC(j);
         IF (INTEGER(j)>=m+41)OR(j>=z+1) THEN EXIT END ;
   END; (* for *)
   INC(ych);
END; (* loop *)
  moufunc(7,0,baseX,baseX+475);
  moufunc(8,0,baseY,baseY+242);
LOOP
  moufunc(1,0,0,0);
  moufunc(3,0,0,0);
FOR j := 0  TO  9 DO
 FOR i:= 1  TO  4 DO
     yyy := baseY+20*(j+1) ;
     xxx := baseX+5+120*(i-1) ;
   IF (pc>=xxx)AND(pc<=xxx+90)AND(pd>=yyy)AND(pd<=yyy+9)
      THEN  IF pb = 1 THEN moufunc(2,0,0,0);
                           nomer:=(j << 2)+i+CARDINAL(m);
                           IF (nomer <= z) THEN
                             Str.Copy(aa,rec[nomer].Filename) ;
                             kkoo:=Str.Length(aa) ;

                             IF aa[kkoo]='\' THEN
                                aa[kkoo]:=CHAR(0) ;
                                kkoo:=Str.Length(path)  ;
                                LOOP
                                   IF (path[kkoo]='\')OR(kkoo<=0) THEN EXIT END ;
                                   DEC(kkoo) ;
                                END ; (* loop *)
                                path[kkoo+1]:=CHAR(0) ;
                                Str.Append(path,aa) ;
                                FIO.ChDir(path) ;
                                GOTO lab11
                              END ;
                              EXIT
                            END ; (* if *)
            END ; (* if *)
   END; (* if *)
 END; (* for *)
END;  (* for *)
 IF (pd>=baseY+222)AND(pd<=baseY+242) THEN
   IF      (pc>=baseX)    AND (pc<baseX+130)  THEN (* field "page up"   *)
             IF pb=1 THEN moufunc(2,0,0,0);
                          m := m-40;
                          IF m <= 0 THEN m := 0 END;
                          GOTO lab22
             END; (* if *)

     ELSIF (pc>baseX+130) AND (pc<baseX+330)  THEN (* field "page down" *)
             IF pb=1 THEN moufunc(2,0,0,0);
                          m := m+40;
                          IF m >= INTEGER(z)+40 THEN m:=0 END;
                          GOTO lab22
             END; (* if *)

     ELSIF (pc>baseX+330) AND (pc<=baseX+475) THEN (* field "quit"      *)
             IF pb=1 THEN moufunc(2,0,0,0) ;
                          proverka := TRUE ;
                          EXIT
             END;
   END; (* if *)
 END ; (* if *)
END; (* loop *)
END Question;

PROCEDURE Analiz;
BEGIN
MasageWindow(TRUE);
GraphVl.PaintString(ADR(yes),baseX+15, baseY+75,15);
GraphVl.PaintString(ADR(no) ,baseX+140,baseY+75,15);
GraphVl.PaintString(ADR(you) ,baseX+17,baseY   ,15);
GraphVl.PaintString(ADR(want),baseX+21,baseY+22,15);
GraphVl.PaintString(ADR(sred),baseX+68,baseY+44,15);
LOOP
 moufunc(1,0,0,0);
 moufunc(3,0,0,0);
 IF (pd>=baseY+71) AND (pd<=baseY+86) THEN
    IF pb = 1 THEN    IF    (pc>=baseX-30) AND (pc<baseX+90) THEN
                                                        proverka := TRUE;
                                                        EXIT
                      ELSIF (pc>baseX+90) AND (pc<=baseX+210) THEN
                                                        proverka := FALSE;
                                                        EXIT
                      END ; (* if *)
    END; (* if *)
 END ; (* if *)
END ; (* loop *)
moufunc(2,0,0,0);
END Analiz;

PROCEDURE Print_r;
VAR  h : ARRAY [1..3] OF CHAR ;
  priz : BOOLEAN              ;
BEGIN
h[3]:=CHAR(0) ;
MasageWindow(TRUE);
GraphVl.PaintString(ADR(prod) ,baseX-12 ,baseY+75,15);
GraphVl.PaintString(ADR(otkaz),baseX+118,baseY+75,15);
GraphVl.PaintString(ADR(printer),baseX+17,baseY+10,15);
GraphVl.PaintString(ADR(sost)   ,baseX+35,baseY+35,15);
Str.CardToStr(LONGCARD(i),h,16,priz);
GraphVl.PaintString(ADR(h),baseX+135,baseY+35,15);
LOOP
 moufunc(1,0,0,0);
 moufunc(3,0,0,0);
 IF (pd>=baseY+71) AND (pd<=baseY+86) THEN
    IF pb = 1 THEN    IF    (pc>=baseX-30) AND (pc<baseX+90) THEN
                                                        proverka := TRUE;
                                                        EXIT
                      ELSIF (pc>baseX+90) AND (pc<=baseX+210) THEN
                                                        proverka := FALSE;
                                                        EXIT
                      END ; (* if *)
    END; (* if *)
 END ; (* if *)
END ; (* loop *)
moufunc(2,0,0,0);
END Print_r;

PROCEDURE(*$C FF*) Time ;
VAR
    h,m 	       : ARRAY [0..2] OF CHAR;
   priz                : BOOLEAN;
  px,py 	       : GraphVl.Coordinate_4   ;
      i 	       : CARDINAL ;
BEGIN
   Lib.Intr(r,81H) ;
   IF tic>=1092 THEN moufunc(2,0,0,0); INC(min) ; tic:=0 ;
		ELSE INC(tic) ;  (*$J+*) RETURN (*$J-*) ;
   END ;
   IF  min>=60 THEN min:=0  ; INC(chas) ;	 END ;
   IF chas>=24 THEN chas:=0			 END ;

px := GraphVl.Coordinate_4(571,619,619,571);
py := GraphVl.Coordinate_4(  9,  9, 24, 24);
 FOR i := 0 TO 2 DO
  h[i]:=CHAR(0);
  m[i]:=CHAR(0)
 END;
GraphVl.PolygonFr(px,py,0,15);
IF chas < 10 THEN  Str.CardToStr(LONGCARD(chas),h,10,priz) ;
		   GraphVl.PaintString(ADR(h),585,13,15)
	     ELSE  Str.CardToStr(LONGCARD(chas),h,10,priz) ;
		   GraphVl.PaintString(ADR(h),575,13,15)
  END ;
  Letter.let2POINT(594,13,15);
  Letter.let2POINT(595,13,15);
IF min	< 10 THEN  Str.CardToStr(LONGCARD(min),m,10,priz) ;
		   GraphVl.PaintString(ADR(m),611,13,15)
	     ELSE  Str.CardToStr(LONGCARD(min),m,10,priz) ;
		   GraphVl.PaintString(ADR(m),601,13,15)
  END;
 moufunc(1,0,0,0);
 (*$J+ *)
END Time ;
 (*$J-,C F0*)


BEGIN      (* начало основного тела программы *)
(* подготавливаемся к перехвату прерывания от аппаратного таймера *)
     r.AH:=2CH   ;
     Lib.Dos(r)  ;
     chas:= r.CH ;
      min:= r.CL ;
     tic := 1091 ;
  Ystanovka(ADR(Time)) ; (* стандартный вектор ставим на место 81H *)
  InitEGA     ;
  EGAGraphMode;
  mouse_X:=320 ;
  mouse_Y:=175 ;

  r.AX := 1123H ;        (* (AL) - выбор обращения к стандартным фонтам *)
  r.BL :=    3H ;        (* выбор "фонта" с размером 8 х 8 точек        *)
Lib.Intr(r,10H) ;
py[1]  := GraphVl.Coordinate_4(basaY1-1, basaY1-1, basaY1+16, basaY1+16);
py[2]  := GraphVl.Coordinate_4(basaY2-1, basaY2-1, basaY2+16, basaY2+16);
py[3]  := GraphVl.Coordinate_4(basaY3-1, basaY3-1, basaY3+16, basaY3+16);
py[4]  := GraphVl.Coordinate_4(basaY4-1, basaY4-1, basaY4+16, basaY4+16);
py[5]  := GraphVl.Coordinate_4(basaY5-1, basaY5-1, basaY5+16, basaY5+16);
py[6]  := GraphVl.Coordinate_4(basaY6-1, basaY6-1, basaY6+16, basaY6+16);
py[7]  := GraphVl.Coordinate_4(basaY7-1, basaY7-1, basaY7+16, basaY7+16);

px[1]  := GraphVl.Coordinate_4(basaX1 -1,basaX1 +26,basaX1 +26,basaX1 -1);
px[2]  := GraphVl.Coordinate_4(basaX2 -1,basaX2 +26,basaX2 +26,basaX2 -1);
px[3]  := GraphVl.Coordinate_4(basaX3 -1,basaX3 +26,basaX3 +26,basaX3 -1);
px[4]  := GraphVl.Coordinate_4(basaX4 -1,basaX4 +26,basaX4 +26,basaX4 -1);
px[5]  := GraphVl.Coordinate_4(basaX5 -1,basaX5 +26,basaX5 +26,basaX5 -1);
px[6]  := GraphVl.Coordinate_4(basaX6 -1,basaX6 +26,basaX6 +26,basaX6 -1);
px[7]  := GraphVl.Coordinate_4(basaX7 -1,basaX7 +26,basaX7 +26,basaX7 -1);
px[8]  := GraphVl.Coordinate_4(basaX8 -1,basaX8 +26,basaX8 +26,basaX8 -1);
px[9]  := GraphVl.Coordinate_4(basaX9 -1,basaX9 +26,basaX9 +26,basaX9 -1);
px[10] := GraphVl.Coordinate_4(basaX10-1,basaX10+26,basaX10+26,basaX10-1);
px[11] := GraphVl.Coordinate_4(basaX11-1,basaX11+26,basaX11+26,basaX11-1);
px[12] := GraphVl.Coordinate_4(basaX12-1,basaX12+26,basaX12+26,basaX12-1);
px[13] := GraphVl.Coordinate_4(basaX13-1,basaX13+26,basaX13+26,basaX13-1);
px[14] := GraphVl.Coordinate_4(basaX14-1,basaX14+26,basaX14+26,basaX14-1);

px_fn:=GraphVl.Coordinate_6(20,569,569,620,620, 20);
py_fn:=GraphVl.Coordinate_6( 9,  9, 25, 25,322,322);

px_m := GraphVl.Coordinate_4( 20,620,620, 20);
py_m := GraphVl.Coordinate_4(323,323,340,340);

px_ekr := GraphVl.Coordinate_4(30,300,300,30);
py_ekr := GraphVl.Coordinate_4(15,15,155,155);

(* базовые точки и описатели полигонов для окон Analiz, Print_r *)
baseX :=  210 ;
baseY :=  140 ;
px_quit[1] := baseX- 30 ; py_quit[1] := baseY-25 ; py_quit_m[1] := baseY+71 ;
px_quit[2] := baseX+210 ; py_quit[2] := baseY-25 ; py_quit_m[2] := baseY+71 ;
px_quit[3] := baseX+210 ; py_quit[3] := baseY+70 ; py_quit_m[3] := baseY+86 ;
px_quit[4] := baseX- 30 ; py_quit[4] := baseY+70 ; py_quit_m[4] := baseY+86 ;

FOR i := 1 TO 14 DO
 FOR j:= 1 TO  7 DO
  color[i,j] := 12
 END;
END;

lab1:
     Lib.NoSound;
     Polygon(6,px_fn,py_fn,0);		    (* фоновый полигон *)
     GraphVl.PolygonFr(px_m,py_m,0,15);     (* блок описывает "поле" меню *)
     Line(568,323,568,340,15);
     Line(426,323,426,340,15);
     Line( 91,323, 91,340,15);
     Line(156,323,156,340,15);
     Line(221,323,221,340,15);
     Line(286,323,286,340,15);

      GraphVl.PaintString(ADR(quit),577,327,15); (* пишет "QUIT" *)
      GraphVl.PaintString(ADR(next),469,327,15); (* пишет "NEXT SCREEN" *)
      GraphVl.PaintString(ADR(help), 37,327,15); (* пишет "HELP"   *)
      GraphVl.PaintString(ADR(load),107,327,15); (* пишет "LOAD"   *)
      GraphVl.PaintString(ADR(save),170,327,15); (* пишет "SAVE"   *)
      GraphVl.PaintString(ADR(proc),313,327,15); (* пишет "PROCESSING"  *)


     HLine(19,  9,621,15);		     (* линии очерчиваюt клаву *)
     HLine(19,341,621,15);
     Line(621,341,621,	9,15);
     Line( 19,341, 19,	9,15);
lab3:
Lib.NoSound();
GraphVl.PolygonFr(px_ekr,py_ekr,8,14);  (* полигон экрана *)

(*  ---------- рисуем ряды клавиш с 1 по  7 (считаем сверху) -------- *)

  FOR j:=1 TO 7 DO
     CASE j OF  5 : xx:= 2 ; yy:= 7
              | 6 : xx:= 1 ; yy:= 7
              | 7 : xx:= 1 ; yy:=10
          ELSE      xx:=9  ; yy:=13
     END ; (* case *)
     FOR i := xx TO yy  DO
             GraphVl.PolygonFr(px[i],py[j],color[i,j],14)
     END;
  END;  (* for *)

(*PWriteString(21, 0,'Dual Chanel Signal Analyzer  Type 2034',CHAR(8FH));
GraphVl.PWriteString(56,25,'Field Entry',CHAR(8FH));*)
GraphVl.PWriteString(47,3, '  ┌──── Digital I/O ─────┐',CHAR(8FH));
GraphVl.PWriteString(47,4, ' Input Outp Plot Stop Local',CHAR(8FH));
GraphVl.PWriteString(47,8, 'Generat      ┌─Recorder─┐',CHAR(8FH));
GraphVl.PWriteString(47,9, '  On        Star Stop  Cal.',CHAR(8FH));
GraphVl.PWriteString(47,13,'  ┌── Specil Function ───┐',CHAR(8FH));
GraphVl.PWriteString(47,14,'   1    2    3     4    5',CHAR(8FH));
GraphVl.PWriteString(47,18,'  ┌── Specil Function ───┐',CHAR(8FH));
GraphVl.PWriteString(47,19,'   6    7    8     9   10',CHAR(8FH));
GraphVl.PWriteString(3,22,'       ┌──Control───┐  ┌───Display───┐',CHAR(8FH));
GraphVl.PWriteString(3,23,'         Averaging     Auto       Meas',CHAR(8FH));
GraphVl.PWriteString(3,24,'       Strt Proc Stop  Scal. Form.Set.',CHAR(8FH));
GraphVl.PWriteString(3,28,'Input  ┌── Record ──┐  Spec. Align  ',CHAR(8FH));
GraphVl.PWriteString(3,29,'Autor  Cont Sing Stop    Cursors  Text',CHAR(8FH));
GraphVl.PWriteString(3,33,' Sys  Manual┌ Memor ┐  ┌SaveSet.┐       ┌SetupLab┐  ',CHAR(8FH));
GraphVl.PWriteString(3,34,'Reset  Trig Enab Stor  Meas. Disp.Alph  Meas  Disp Curs ',CHAR(8FH));

 moufunc(8,0,10,340);	      (* Установка крайней позиции по оси Y *)
 moufunc(7,0,20,620);         (* Установка крайней позиции по оси X *)
 moufunc(1,0,0,0);            (* Высветить курсор *)
 moufunc(4,0,mouse_X,mouse_Y);(* Установ курсор в координаты mouse_X,mouseY *)

LOOP
    moufunc(3,0,0,0);  (* Устанавливаем позицию миши и статус  клавиши *)
    Lib.NoSound;

(*  ------- АНАЛИЗИРУЕМ РЯДЫ КЛАВИШ С 1 ПО 4 (считаем сверху) -------- *)
FOR j := 1  TO  4 DO
 FOR i:= 9  TO 13 DO
   CASE  j  OF  1 : yy := basaY1
              | 2 : yy := basaY2
              | 3 : yy := basaY3
              | 4 : yy := basaY4
   END; (* case *)
   CASE  i  OF  9 : xx := basaX9
              |10 : xx := basaX10
              |11 : xx := basaX11
              |12 : xx := basaX12
              |13 : xx := basaX13

   END; (* case *)
    IF (pc>=xx)AND(pc<=xx+25)AND(pd>=yy)AND(pd<=yy+15)
       THEN
       END ;
 END; (* for *)
END;  (* for *)

(*  ------- АНАЛИЗИРУЕМ РЯДЫ КЛАВИШ С 5 ПО 7 (считаем сверху) -------- *)
FOR j := 5  TO  7 DO
 FOR i:= 2  TO  7 DO
   CASE  j  OF  5 : yy := basaY5
              | 6 : yy := basaY6
              | 7 : yy := basaY7
   END; (* case *)
   CASE  i  OF 2 : xx := basaX2
              |3 : xx := basaX3
              |4 : xx := basaX4
              |5 : xx := basaX5
              |6 : xx := basaX6
              |7 : xx := basaX7
   END; (* case *)
    IF (pc>=xx)AND(pc<=xx+25)AND(pd>=yy)AND(pd<=yy+15)
       THEN
       END ;
 END; (* for *)
END;  (* for *)

(*  - АНЛИЗИРУЕМ КЛАВИШИ,ВЫХОДЯЩИЕ ЗА РАМКИ "ПРЯМОУГОЛЬНИКА" НИЖНИХ РЯДОВ - *)
 FOR i:= 8  TO 10 DO
   CASE  i  OF 8 : xx := basaX8
              |9 : xx := basaX9
              |10: xx := basaX10
   END; (* case *)
    IF (pc>=xx)AND(pc<=xx+25)AND(pd>=basaY7)AND(pd<=basaY7+15)
       THEN
       END ;
 END; (* for *)

 FOR j := 6  TO 7 DO
   CASE  j  OF 6 : yy := basaY6
              |7 : yy := basaY7
   END; (* case *)
    IF (pc>=basaX1)AND(pc<=basaX1+25)AND(pd>=yy)AND(pd<=yy+15)
       THEN
       END ;
 END; (* for *)

(*  ------------------- конец  анализа клавиш ----------------------- *)

(* **************** АНАЛИЗ ПОЛЯ МЕНЮ ПЕРВОГО ЭКРАНА ***************** *)
IF (pd >=  323) AND (pd <= 340) THEN
 IF (pc>=427)AND(pc<=567)                            (* NEXT SCREEN *)
   THEN IF pb = 1 THEN   Lib.Sound(1000);
                         moufunc(2,0,0,0);
                         GOTO lab2 ;
                  END;	 (* if *)

 ELSIF (pc>=569)AND(pc<=620)                         (* QUIT *)
   THEN IF pb = 1  THEN  moufunc(2,0,0,0) ;
                         proverka := TRUE ;
                         Analiz;
		         IF proverka THEN   FOR i:=600 TO 2000 DO
                                             FOR j:=1 TO 60 DO END ;
			                       Lib.Sound(i) ;
		                            END ; (* for *)
		                            GOTO end
		         ELSE GOTO lab1
		         END;   (* if *)
	END; (* if *)	

 ELSIF (pc>=20)AND(pc<=90)                            (* HELP *)
   THEN IF pb = 1 THEN   moufunc(2,0,0,0);
                         FioVl.Help('d:\br__kr\screen1.hlp',201,50);
                         mouse_X:=50 ; mouse_Y:=330 ;
                         GOTO lab1
         END; (* if *)

 ELSIF (pc>=92)AND(pc<=155)                           (* LOAD *)
   THEN IF pb = 1   THEN   moufunc(2,0,0,0);
                       	   FioVl.FileLoad('d:\br__kr\br__kr.cfg');
                           mouse_X:=125;
                           Polygon(6,px_fn,py_fn,0);
                       	   GOTO lab3
        END; (* if *)

 ELSIF (pc>=157)AND(pc<220)                          (* поле "SAVE" *)
   THEN IF pb  = 1  THEN   Lib.Sound(2000);
                           moufunc(2,0,0,0);
                           FioVl.FileSave('d:\br__kr\br__kr.cfg');
                           mouse_X:=200;
        END; (* if *)

 ELSIF (pc>300)AND(pc<427)                          (* поле "PROCESSING" *)
   THEN IF pb  = 1  THEN  (* Reset;*)
                           moufunc(2,0,0,0);
                           Podkl_OVL(4000,'valera.ovl') ;
                           GOTO lab1;
        END; (* if *)

 END ; (* if *)
END ; (* if *)
(* ************** КОНЕЦ АНАЛИЗА ПОЛЯ МЕНЮ ПЕРВОГО ЭКРАНА ************** *)

moufunc(1,0,0,0);
END ; (* loop *)

lab2:  (* описание второго экрана *)
	   Lib.NoSound;
	   HLine(19,  9,621,15);	      (* линии очерчивающие клаву *)
	   HLine(19,341,621,15);
	    Line(621,341,621,  9,15);
	    Line( 19,341, 19,  9,15);

	   Polygon(6,px_fn,py_fn,0);	      (* блок описывает "поле" меню *)
	   HLine(19,323,621,15);
	   Polygon(4,px_m,py_m,0);
	    Line(568,323,568,340,15);
	    Line(156,323,156,340,15);
	    Line(426,323,426,340,15);
	    Line( 91,323, 91,340,15);
	    Line(274,323,274,340,15);
	    Line(221,323,221,340,15);

  GraphVl.PaintString(ADR(quit)    ,577,327,12);  (* пишет "QUIT" *)
  GraphVl.PaintString(ADR(previous),446,327,15);  (* пишет "PREVIOUS SCREEN" *)
  GraphVl.PaintString(ADR(help),     37,327,15);  (* пишет "HELP"  *)
  GraphVl.PaintString(ADR(load),    107,327,15);  (* пишет "LOAD"  *)
  GraphVl.PaintString(ADR(save),    170,327,15);  (* пишет "SAVE"  *)
  GraphVl.PaintString(ADR(print),   227,327,15);  (* пишет "PRINT" *)
  GraphVl.PaintString(ADR(transf),  310,327,15);  (* пишет "TRANSFER" *)


moufunc(8,0,10,340);	(* Установка крайней позиции по оси Y *)
moufunc(7,0,20,620);	(* Установка крайней позиции по оси X *)

LOOP  (* большой лУУп *)
      Lib.NoSound;
      moufunc(3,0,0,0);      (* Устанавливаем позицию миши и статус  клавиши *)

(* ********************** поле меню второго экрана ************************* *)
lab_otkaz:
IF (pd >=  323) AND (pd <= 340) THEN
 IF (pc>427)AND(pc<567)                            (* "PREVIOUS SREEN" *)
   THEN IF pb = 1  THEN   Lib.Sound(1000);
		          mouse_X:=480 ; mouse_Y:=330 ;
		          moufunc(2,0,0,0);
		          GOTO lab1 ;
                   END;   (* if *)

 ELSIF (pc>569)AND(pc<=620)                         (* "QUIT" *)
   THEN IF pb = 1  THEN  moufunc(2,0,0,0) ;
                         proverka := TRUE ;
		         Analiz;
		         IF proverka THEN   FOR i:=600 TO 2000 DO
                                             FOR j:=1 TO 60 DO END ;
			                       Lib.Sound(i) ;
		                            END ; (* for *)
		                            GOTO end
		         ELSE GOTO lab2
		         END;   (* if *)
	END; (* if *)	
 ELSIF (pc>=20)AND(pc<90)                          (* "HELP" *)
   THEN IF pb = 1 THEN  moufunc(2,0,0,0);
                        FioVl.Help('d:\br__kr\screen2.hlp',201,50);
                        GOTO lab2
                        END; (* if *)

 ELSIF (pc>90)AND(pc<155)                          (* "LOAD" *)
   THEN IF pb = 1 THEN  proverka := FALSE ;
                        Question(120,50) ;
                        IF proverka THEN GOTO lab2 END ;
                        Polygon(6,px_fn,py_fn,0);
                        MasageWindow(TRUE);
                        GraphVl.PaintString(ADR(osu),baseX+35,baseY   ,15);
                        GraphVl.PaintString(ADR(pro),baseX+10,baseY+28,15);
                        GraphVl.PaintString(ADR(yes),baseX+15, baseY+75,15);
                        GraphVl.PaintString(ADR(no) ,baseX+140,baseY+75,15);
                        moufunc(1,0,0,0);
                        moufunc(8,0,10,340);	(* Уст крайней поз по оси Y *)
                        moufunc(7,0,20,620);	(* Уст крайней поз по оси X *)
(*     просматриваем этикетку или отказываемся от просмотра этикетки          *)
(*             и сразу выходим на рисование графика                           *)
                str := 15 ;
       LOOP
                  moufunc(3,0,0,0);
                  IF pb = 1 THEN
                    IF (pc>=baseX-30)AND(pc<baseX+90)AND(pd>baseY+71)AND(pd<=baseY+86)
                               THEN file := FIO.Open(aa)    ;
                                    FIO.RdStr(file,stretik) ;
                                    moufunc(2,0,0,0);
                                    Polygon(6,px_fn,py_fn,0);
(*  строим окhо в которое выводится этикетка файла специфицированного в "aa" *)
                  MasageWindow(TRUE);
         (*  вписываем в это окно название полей этикетки *)
                  j := 0 ;
              FOR i := 15 TO 25 BY 2 DO
                  Str.ItemS(Fname,s_str,'|',j);
                  GraphVl.PWriteString(23,SHORTCARD(i),Fname,CHAR(89H));
                  INC(j);
              END ; (* for *)
                  Str.ItemS(Fname,s_str,'|',8);
                  GraphVl.PWriteString(28,27,Fname,CHAR(87H));
                  Str.ItemS(Fname,s_str,'|',7);
                  GraphVl.PWriteString(41,27,Fname,CHAR(87H));
(* читаем этикетку из файла "аа" и вносим значения в соответствующие поля *)
                   FOR str := 15 TO 25 BY 2 DO
                      CASE str OF 15 : p := 0 ; l := 4 ;
                                 |17 : p := 4 ; l := 8 ;
                                 |19 : p := 12; l := 6 ;
                                 |21 : p := 18; l := 6 ;
                                 |23 : p := 24; l := 2 ;
                                 |25 : p := 26; l := 6 ;
                       END ; (* case *)
                       FOR i := 1 TO 8 DO
                        buffer[i] := CHAR(0) ;
                       END ; (* for *)
                       Str.Slice(buffer,stretik,p,l);
                       GraphVl.PWriteString(43,str,buffer,CHAR(87H));
                     END ; (* for *)
                     moufunc(1,0,0,0);
                    LOOP
                      moufunc(3,0,0,0);
                      IF pb = 1 THEN
                       IF (pd>baseY+71)AND(pd<=baseY+86) THEN
                         IF (pc>=baseX-30)AND(pc<baseX+90)
                                THEN  moufunc(2,0,0,0);
                                      Polygon(6,px_fn,py_fn,0);
                                      GOTO lab_otkaz
                         ELSIF (pc>baseX+90)AND(pc<=baseX+210)
                                THEN EXIT
                         END ; (* if *)
                       END ; (* if *)
                      END ; (* if *)
                    END ; (* loop *)

                    ELSIF (pc>=baseX+90)AND(pc<baseX+210)AND(pd>=baseY+71)
                           AND(pd<=baseY+86) THEN moufunc(2,0,0,0);
                                                  Polygon(6,px_fn,py_fn,0);
                                                  EXIT
                    END ; (* if *)
                  END ; (* if *)
       END ; (* loop *)
       GraphVl.Grafick(aa);
      END; (* if *)

(* lab_otkaz *)
 ELSIF (pc>155)AND(pc<220)                         (* "SAVE" *)
 (* рисуем  *)
   THEN
IF pb = 1 THEN  moufunc(2,0,0,0);
                        MasageWindow(FALSE);
                        GraphVl.PaintString(ADR(inp), baseX+15,baseY- 5,15);
                        GraphVl.PaintString(ADR(sohr),baseX+30,baseY+ 8,15);
                        GraphVl.PaintString(ADR(dat) ,baseX+60,baseY+21,15);
                        Line(baseX+90,baseY+71,baseX+90,baseY+86,15);
                        GraphVl.PWriteString(25,27,'ESC-Отказ',CHAR(87H));
                        GraphVl.PWriteString(40,27,'ENTER-Ввод',CHAR(87H));
                        prov_open_file :=GraphVl.MakeStr(25,23,24,7);

    IF    prov_open_file=1 THEN  Polygon(6,px_fn,py_fn,0);
                                 GOTO lab_otkaz
    ELSIF prov_open_file=0 THEN  Str.Copy(Fname,string);
                                 MasageWindow(FALSE);
   (* проверяeм существует ли *) FIO.IOcheck := FALSE;
   (* файл с введённым именем *) file := FIO.Open(Fname);

                IF FIO.IOresult() = 0  THEN
                      GraphVl.PWriteString(27,18,'ФАЙЛ С ТАКИМ ИМЕНЕМ',CHAR(87H));
                      GraphVl.PWriteString(31,20,'УЖЕ  СОЗДАН',CHAR(87H));
                      GraphVl.PWriteString(25,27,'ПЕРЕЗАПИСЬ',CHAR(87H));
                      GraphVl.PWriteString(43,27,'ОТКАЗ',CHAR(87H));
                      Line(baseX+90,baseY+71,baseX+90,baseY+86,15);
                       LOOP
                         moufunc(1,0,0,0);
                         moufunc(3,0,0,0);
                        IF pb = 1 THEN
                         IF (pd>=baseY+71)AND(pd<=baseY+86)  THEN
                          IF    (pc>=baseX-30)AND(pc<baseX+90)
                                THEN moufunc(2,0,0,0);
                                     file:=FIO.Create(Fname) ;
                                     MasageWindow(FALSE);
                                     GOTO new_f;
                          ELSIF (pc>baseX+90)AND(pc<=baseX+210)
                                THEN moufunc(2,0,0,0);
                                     Polygon(6,px_fn,py_fn,0);
                                     GOTO lab_otkaz
                          END ; (* if *)
                         END ; (* if *)
                        END ; (* if *)
                       END ; (* loop *)
                ELSE (* открываем окно этикетки для нового создаваемого ф-ла*)
                new_f :
                    j := 0 ;
                     FOR i := 15 TO 27 BY 2 DO
                       Str.ItemS(Name,s_str,'|',j);
                       GraphVl.PWriteString(23,SHORTCARD(i),Name,CHAR(87H));
                       INC(j);
                     END ; (* for *)
                     GraphVl.PWriteString(34,27,Fname,CHAR(8BH));
                     file := FIO.Create(Fname);
                     FIO.Close(file);
                END ; (* if *)
      END ; (* if *)
    (**)
   str         := 15 ;
   poz_kurs    := 43 ;
   z           :=  1 ;
   kolichestvo :=  0 ;
   schet_pos[0]:=  0 ;
   f           :=  0 ;
   schet_pos[f]:=  0 ;
   file := FIO.Open(Fname);
   FIO.WrCharRep(file,' ',80);
   FIO.WrChar(file,CHAR(13));
   FIO.Close(file);
 LOOP
             z := z+kolichestvo-1;

M1 :
     CASE str OF    15 : kolichestvo := 5;
                  | 17 : kolichestvo := 9;
                  | 19 : kolichestvo := 7;
                  | 21 : kolichestvo := 7;
                  | 23 : kolichestvo := 3;
                  | 25 : kolichestvo := 7;
     END ; (* case *)
    schet_pos[f+1] := schet_pos[f]+kolichestvo-1;
    prov_open_file := GraphVl.MakeStr(poz_kurs,str,kolichestvo,09H);

    CASE prov_open_file OF
              0 :  str := str + 2 ;
                   INC(f) ;
                   file:=FIO.Open(Fname);
                   FIO.Seek(file,LONGCARD(z));
                   FIO.WrStr(file,string);
                   FIO.Close(file)
            | 1 :  Polygon(6,px_fn,py_fn,0);
                   FIO.Erase(Fname);
                   GOTO lab_otkaz
            | 2 :  str := str - 2 ;
                   DEC(f) ;
                   IF f<1 THEN f:=0 END ;
                   z := schet_pos[f] ;
                   IF str <= 15 THEN str := 15 END ;
                   GOTO M1 ;
    END ; (*  case  *)
    IF str>=26 THEN EXIT END ; (* if *)
 END ; (* loop *)
END ; (* if *)

 ELSIF (pc>273)AND(pc<427)                          (* "TRANSFER" *)
  THEN IF pb=1 THEN moufunc (2,0,0,0) ;
                    MasageWindow(FALSE);
                    HLine(baseX-30,baseY-1 ,baseX+210,15);
                    HLine(baseX-30,baseY+23,baseX+210,15);
                    HLine(baseX-30,baseY+47,baseX+210,15);
                    GraphVl.PWriteString(26,15,'ПЕРЕДАЧА ВСЕЙ ИНФОРМАЦИИ',CHAR(87H));
                    GraphVl.PWriteString(31,16,'С ЭКРАНА BrKr',CHAR(87H));
                    GraphVl.PWriteString(26,18,'ПЕРЕДАЧА ИНФОРМ О ПАРАМ.',CHAR(87H));
                    GraphVl.PWriteString(32,19,'ИЗМЕРЕНИЙ',CHAR(87H));
                    GraphVl.PWriteString(26,21,'ПЕРЕДАЧА ИНФОРМ О ПАРАМ.',CHAR(87H));
                    GraphVl.PWriteString(32,22,'ИЗОБРАЖЕНИЙ',CHAR(87H));
                    GraphVl.PWriteString(27,24,'ПЕРЕДАЧА РЕЗУЛЬТАТОВ',CHAR(87H));
                    GraphVl.PWriteString(32,25,'ИЗМЕРЕНИЙ',CHAR(87H));
                    GraphVl.PaintString(ADR(quit),baseX+70,baseY+75,15);
                       moufunc(7,0,baseX-30,baseX+210);
                       moufunc(8,0,baseY-26,baseY+ 86);
                       moufunc(4,0,baseX,baseY);
                  LOOP
                       moufunc(1,0,0,0);
                       moufunc(3,0,0,0);
                      IF pb=1 THEN
                          IF (pd>=baseY+73)AND(pd<=baseY+86)
                                THEN  moufunc(7,0,20,620);
                                      moufunc(8,0,10,340);
                                      moufunc(2,0,0,0);
                                      Polygon(6,px_fn,py_fn,0);
                                      EXIT
                          (*ELSIF THEN*)
                          END; (* if *)
                      END ; (* if *)
                  END ; (* loop *)
        END ; (* if *)

 ELSIF (pc>222)AND(pc<273)                          (* "PRINT" *)
   THEN IF pb = 1 THEN  lab4:
                        moufunc(2,0,0,0);
                        proverka := TRUE ;
                        i:= assa.print_ready();
                        IF i = 255 THEN assa.screen
                                   ELSE Print_r
                        END ;
                        IF NOT (proverka) THEN GOTO lab2
                                          ELSE GOTO lab4
                        END ;
                	Lib.Sound(1000)
        END; (* if *)
   END; (*  if анализ координат по X *)
   (*ELSE (*MouseScr*)*)
END; (* if анализ координат по Y *)
moufunc(1,0,0,0);	
END;   (* конец большого loopа *)
end:
      moufunc(2,0,0,0);  (* выключить курсор *)
      Reset;
      Lib.NoSound;
      TextMode;
END sa2034.
