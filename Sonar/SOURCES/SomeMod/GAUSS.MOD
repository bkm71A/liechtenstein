IMPLEMENTATION MODULE Gauss;
IMPORT MATHLIB,FIO,IO,Str;
FROM Down_hlp  IMPORT wt_downhlp;
FROM Probr_lb  IMPORT Space_free;
FROM SearchFl  IMPORT FullPath;
FROM Window    IMPORT Use,GotoXY,Color,TextColor,TextBackground;
CONST pi2=0.2820948;
      sqrt2=1.414214;
PROCEDURE prover(VAR sname:ARRAY OF CHAR;VAR p:REAL):CARDINAL;
(* Входные : файл даннных REAL,c этикеткой          *)
VAR  i,rsize               : LONGCARD;(*счетчик цикла,pазмеp файла*)
     res,j,commence        : CARDINAL;(*pезультат чтения диска*)
     a,s1,s2,xi_2,teor     : REAL;  (*число и суммы степеней:1,2*)
     k,r                   : CARDINAL;(* число интервалов *)
     count                 : ARRAY[0..113] OF CARDINAL;
     prob                  : ARRAY[0..38] OF REAL;
     min,max,mo,d,sko,del  : REAL;
     gr1,gr2,pi,xi2        : LONGREAL;
     bound                 : ARRAY[0..10] OF LONGCARD;
     f                     : FIO.File;
     buffer                : ARRAY[0..1023] OF BYTE;(*буффеp для файла*)
(* ------------------------- My Addition ------------------------------ *)
     computer:               LONGCARD;
     x_coord:                CARDINAL;
     diskret:                LONGCARD;
     path:                   ARRAY[0..32] OF CHAR;

PROCEDURE normal(d1,d2:LONGREAL):LONGREAL;
(* находит интеграл для нормального распределения  *)
(* d1<d2 - нормированный,масштабированный диапазон *)
VAR s,spr,fact,powd1,powd2 : LONGREAL;
    n                      : CARDINAL;
    sign                   : INTEGER;
  BEGIN
  s:=2.0*(d2-d1);
  sign:=-1;
  fact:=1.0;
  n:=1;
  powd1:=1.0;
  powd2:=1.0;
     REPEAT
     spr:=s;
     powd1:=powd1*d1*d1;
     powd2:=powd2*d2*d2;
     s:=s+LONGREAL(sign)*(powd2*d2-powd1*d1)/(fact*(LONGREAL(n)+0.5));
     n:=n+1;
     sign:=sign*(-1);
     fact:=fact*LONGREAL(n);
     UNTIL ABS(spr-s)<0.0000001;
  s:=s*pi2;
  RETURN LONGREAL(s);
  END normal;

   BEGIN
(* 1 Присвоение начальных значений*)
   FOR j:=0 TO 113 DO
   count[j]:=0;
   END;
   Str.Concat(path,FullPath,'\hi2.tbl');
   IF NOT FIO.Exists(path) THEN RETURN 2;END;
(* задаем границы для выбора числа интервалов *)
   bound[0]:=700;bound[1]:=2100;bound[2]:=4600;bound[3]:=8300;
   bound[4]:=13300;bound[5]:=19800;bound[6]:=28000;bound[7]:=38000;
   bound[8]:=49400;bound[9]:=63000;bound[10]:=66000;
(* задаем значения табличных вероятностей *)
   prob[0]:=0.0001; prob[1]:=0.0005; prob[2]:=0.001; prob[3]:=0.005;
   prob[4]:=0.01;   prob[5]:=0.02;   prob[6]:=0.025; prob[7]:=0.03;
   prob[8]:=0.04;   prob[9]:=0.05;   prob[10]:=0.06; prob[11]:=0.07;
   prob[12]:=0.08;  prob[13]:=0.09;  prob[14]:=0.1;  prob[15]:=0.2;
   prob[16]:=0.25;  prob[17]:=0.3;   prob[18]:=0.4;  prob[19]:=0.5;
   prob[20]:=0.6;   prob[21]:=0.7;   prob[22]:=0.75; prob[23]:=0.8;
   prob[24]:=0.9;   prob[25]:=0.91;  prob[26]:=0.92; prob[27]:=0.93;
   prob[28]:=0.94;  prob[29]:=0.95;  prob[30]:=0.96; prob[31]:=0.97;
   prob[32]:=0.975; prob[33]:=0.98;  prob[34]:=0.99; prob[35]:=0.995;
   prob[36]:=0.999; prob[37]:=0.9995;prob[38]:=0.9999;
   f:=FIO.Open(sname);
   FIO.AssignBuffer(f,buffer);
(* 2  Работа с этикеткой,считать данные *)
   FIO.Seek(f,26);
   res:=FIO.RdBin(f,rsize,4);
   FIO.Seek(f,32);
   res:=FIO.RdBin(f,commence,2);
   FIO.Seek(f,36);
   res:=FIO.RdBin(f,min,4);
   res:=FIO.RdBin(f,max,4);
   res:=FIO.RdBin(f,mo,4);
(* 3 Проверка что длина больше 200 *)
   IF rsize<200 THEN FIO.Close(f);RETURN 1;END;
(* 4 Разбить диапазон на интервалы *)
   j:=1;
      WHILE rsize>bound[j+1] DO
      INC(j);
      END;
   k:=j*10+3;
(* 5 Считаем попадание значений в интервал и дисперсию *)
   FIO.Seek(f,LONGCARD(commence));
   s1:=0.0;s2:=0.0;
   del:=(max-min)/REAL(k);
(* ------------------------- My Addition ------------------------------ *)
(* --------- подготавливаем данные для рисования ползунка ------------- *)
 computer:= 0;
 x_coord:=  1;
  diskret:= rsize DIV 66;
  Use(wt_downhlp);
  GotoXY(0,1);  TextBackground(LightGray); TextColor(Black); IO.WrCharRep('░',66);
  GotoXY(71,1); TextBackground(Red);   TextColor(White); IO.WrStr(' %  ');
(* ------------------------------------------------------------------------ *)

    FOR i:=1 TO rsize DO
      res:=FIO.RdBin(f,a,4);
      s1:=s1+a;
      s2:=s2+a*a;
      j:=CARDINAL((a-min)/del);
      count[j]:=count[j]+1;
(* ------------------------- My Addition ------------------------------- *)
      INC(computer);
      IF (computer>= diskret) THEN
         Use(wt_downhlp);
         TextColor(Red);   GotoXY(x_coord,1); IO.WrChar('█');
         TextColor(White); GotoXY(66,1);
        IF x_coord<= 66
           THEN  IO.WrCard(CARDINAL(REAL(x_coord)/66.*100.),5);
                 INC(x_coord);
        END; (* if *)
        computer:= 0;
        IF i= rsize (* в маленьких файлах, когда точек меньше 66 *)
           THEN TextColor(Red);   GotoXY(0,1);  IO.WrCharRep('█',66);
                TextColor(White); GotoXY(66,1); IO.WrCard(100,5);
        END; (* if *)
      END; (* if *)
(* --------------------------------------------------------------------- *)
    END;(* for Славика *)

   mo:=s1/REAL(rsize);
   d:=(s2-mo*mo*REAL(rsize))/(REAL(rsize-1));
   sko:=REAL(MATHLIB.Sqrt(LONGREAL(d)));
   FIO.Close(f);
(* 6 Находим значение кси - квадрат *)
   xi2:=0.0;
      FOR j:=0 TO k-1 DO
      gr1:=LONGREAL(min+REAL(j)*del);
      gr2:=gr1+LONGREAL(del);
      gr1:=(gr1-LONGREAL(mo))/LONGREAL(sko)/sqrt2;
      gr2:=(gr2-LONGREAL(mo))/LONGREAL(sko)/sqrt2;
      IF ABS(gr1)>5.0 THEN gr1:=ABS(gr1)/gr1*5.3;END;
      IF ABS(gr2)>5.0 THEN gr2:=ABS(gr2)/gr2*5.3;END;
      pi:=ABS(normal(gr1,gr2));
      xi2:=xi2+LONGREAL(count[j])*LONGREAL(count[j])/pi/LONGREAL(rsize);
      END;
   xi2:=xi2-LONGREAL(rsize);
(* 7 Расчет вероятности,интеграла от xi^2  *)
   xi_2:=REAL(xi2);
   r:=k-3;        (* число степеней свободы *)
   f:=FIO.Open(path);
   FIO.AssignBuffer(f,buffer);
   j:=156*(r DIV 10)-4; IF r=110 THEN j:=j-156;END;
   FIO.Seek(f,LONGCARD(j));
   res:=FIO.RdBin(f,teor,4);
   IF xi_2>teor THEN p:=1.0;
                ELSE j:=156*((r DIV 10)-1);
                     FIO.Seek(f,LONGCARD(j));
                     j:=0;
                        REPEAT
                        res:=FIO.RdBin(f,teor,4);
                        INC(j);
                        UNTIL teor>xi_2;
                        p:=prob[j-1];
                END;
   p:=p-1.0;
   FIO.Close(f);
(* -- восстанавливаем цвета в окне подсказки ипользованном ползунком -- *)
  Use(wt_downhlp);
  TextColor(White);
  TextBackground(Brown);
(* -------------------------------------------------------------------- *)

RETURN 0;
END prover;
BEGIN
END Gauss.
