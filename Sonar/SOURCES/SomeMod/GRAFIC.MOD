MODULE grafic;
IMPORT IO,FIO,Graph,InOut,swhelp,assa;
CONST pbx=CARDINAL(20);           (* начало графика по X*)
      pex=620;                    (* конец графика по X*)
VAR np   : CARDINAL;              (* число точек на одном графике*)
    one,                          (* совмещенная ось one=1,много one=0*)
    nc   : CARDINAL;              (* количество каналов*)
    i,j,                          (* счетчики циклов  *)
    w,x1,x2,                      (* ширина графикa и др.*)
    step,                         (* шаг между точками*)
    cg,                           (* цвет графика *)
    res,                          (* вспомогательная *)
    shift,                        (* сдвиг по экрану *)
    skip,                         (* прореживание    *)
    lev,                          (* уровень n - графика*)
    levz : CARDINAL;              (* конкретный уровень*)
    ch    : CHAR;                 (* символ с клавиатуры*)
    y1,y2  : INTEGER;             (* выводимое значение*)
    bul,                          (* вспомогательная *)
    escape   : BOOLEAN;           (*выход из программы*)
    max,min  : REAL;
    fmax     : ARRAY[1..6] OF REAL;(* максимумы из значений*)
    f        : ARRAY[1..6] OF FIO.File ;
    buf      : ARRAY[1..6] OF ARRAY[0..8191] OF BYTE;
    pif,                          (*position in a file*)
    mfs      : LONGCARD;          (*minimum of size file*)
(*    a        : ADDRESS;*)
    pix,pip  : REAL;
BEGIN
(* 0 Задание начальных значений*)
 one:=0;                          (*много графиков*)
 escape:=FALSE;
 pif:=20;                         (* начинаем не с начала файла*)
 shift:=20;
 step:=1;
 skip:=1;
 mfs:=0FFFFFFFH;                  (* длина самого короткого файл *)
(* 1 Блок ввода задания*)
 swhelp.vvod(nc,skip,shift,f);
(* 2 Работа с файлами*)
 FOR i:=1 TO CARDINAL(nc) DO
     FIO.AssignBuffer(f[i],buf[i]);
     IF mfs>FIO.Size(f[i]) THEN mfs:=FIO.Size(f[i]);END;
     FIO.Seek(f[i],36);
     res:=FIO.RdBin(f[i],min,4);
     res:=FIO.RdBin(f[i],max,4);
     fmax[i]:=ABS(min);
     IF ABS(max)>fmax[i] THEN fmax[i]:=ABS(max);END;
 END;
 mfs:=mfs-80;
(* 4 Переход в графический режим *)
 Graph.InitEGA;
(* 4.1 Расчет начальных значений *)
 REPEAT
   Graph.EGAGraphMode;
   np:=(pex-pbx) DIV step+1;      (*число точек на одном графике*)
   (*ширина одного графика*)
   w:=(150 DIV CARDINAL(nc))*CARDINAL(1-one)+150*CARDINAL(one);
   lev:=w+2;                      (*уровень первого графика*)
(* 4.2 Рисуем вертикальную ось*)
   Graph.Line(pbx,CARDINAL(2),pbx,300,CARDINAL(10));
   Graph.Line(pbx,CARDINAL(2),pbx-CARDINAL(2),CARDINAL(7),CARDINAL(10));
   Graph.Line(pbx,CARDINAL(2),pbx+CARDINAL(2),CARDINAL(7),CARDINAL(10));
   FOR i:=1 TO nc DO              (*рисуем nc графиков*)
       levz:=lev*CARDINAL(1-one)+CARDINAL(151*one);
(*  4.3 Рисуем одну горизонтальную ось *)
       Graph.HLine(pbx,levz,pex,CARDINAL(10));
       Graph.Line(pex-CARDINAL(5),levz-CARDINAL(2),pex,levz,CARDINAL(10));
       Graph.Line(pex-CARDINAL(5),levz+CARDINAL(2),pex,levz,CARDINAL(10));
(*  4.4 Рисуем один график *)
       cg:=CARDINAL(9)+i*CARDINAL(one);   (*цвет графика*)
       x1:=pbx;
       x2:=pbx+step;
       FIO.Seek(f[i],4*pif);
       res:=FIO.RdBin(f[i],pix,4);
       max:=fmax[i];              (*масштабируем*)
       y1:=INTEGER(pix*REAL(w)/max);
       FOR j:=1 TO np-1 DO
           FIO.Seek(f[i],4*(pif+LONGCARD(j)*LONGCARD(skip)));
           res:=FIO.RdBin(f[i],pip,4);
                                  (*масштабируем*)
           y2:=INTEGER(pip*REAL(w)/max);
           Graph.Line(x1,CARDINAL(INTEGER(levz)-y1),x2,CARDINAL(INTEGER(levz)-y2),cg);
           x1:=x2;
           x2:=x2+step;
           y1:=y2;
       END;
       lev:=lev+w*2+2;            (*уровень i-го графика*)
   END;
(* 4.6 Ввод клавиш *)
   REPEAT
     bul:=TRUE;
     ch:=IO.RdCharDirect();
     CASE ORD(ch) OF
         (*F4*) |62     :one:=1-one;  (*переключатель числа графиков*)
         (*F3*) |61     :IF assa.print_ready()=255 THEN assa.screen;
                            ELSE swhelp.help(2);END;
         (*esc*)|27     :escape:=TRUE;(*выход из программы*)
         (* ->*)|75     :IF pif>(mfs DIV 4)-LONGCARD(shift+(np-1)*skip)
                            THEN bul:=FALSE;         (*стрелка влево*)
                            ELSE pif:=pif+LONGCARD(shift);
                            END;
         (*<- *)|77     :(*стрелка вправо*)
                         IF pif<=LONGCARD(20+shift) THEN bul:=FALSE;
                            ELSE pif:=pif-LONGCARD(shift);END;
         (*^*)  |72     :(*стрелка вверх-растяжка по оси Y*)
                         FOR i:=1 TO nc DO fmax[i]:=fmax[i]*0.8;END;
         (*\/*) |80     :(*стрелка вниз-сжатие по оси Y*)
                         FOR i:=1 TO nc DO fmax[i]:=fmax[i]*1.2;END;
         (*R,r*)|82,114 :IF step<50 THEN step:=step+1;(*растяжка по оси X*)
                            ELSE bul:=FALSE;END;
         (*S,s*)|83,115 :IF step>1 THEN step:=step-1;(*сжатие по оси X*)
                            ELSE bul:=FALSE;END;
         (*U,u*)|85,117 :skip:=skip+1;               (*реже*)
         (*L,l*)|76,108 :IF skip>1 THEN skip:=skip-1;(*гуще*)
                            ELSE bul:=FALSE;END;
         (*F1*) |59     :swhelp.help(1);bul:=TRUE;
         ELSE bul:=FALSE;
     END;
   UNTIL bul;
 UNTIL escape;
 Graph.EGATextMode;
(* 5 Закрытие файлов*)
 FOR i:=1 TO CARDINAL(nc) DO
     FIO.Close(f[i]);
 END;
END grafic.

