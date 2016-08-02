IMPLEMENTATION MODULE FioVl; (* Private M.V.N. *)

IMPORT FIO,Graph,Lib, SYSTEM,IO;
IMPORT Letter,LetterR,GraphVl,mouse;
TYPE Coor_4 = ARRAY [1..4] OF CARDINAL	;
VAR
    file :  FIO.File;
   a,j,i :  CARDINAL ;
       d :  CHAR ;
      Fp :  ARRAY [1..100]       OF LONGCARD ;
   color :  ARRAY [1..14],[1..7] OF CARDINAL;

PROCEDURE FileSave(Name : ARRAY OF CHAR);
VAR i,j : CARDINAL ;
CONST color ::= GraphVl.Color;
BEGIN
file:=FIO.Create(Name);
IF NOT(FIO.OK)	THEN HALT END ;
	     FOR i := 1 TO 14 DO     (* считает кнопки по Х *)
	      FOR j :=1 TO  7 DO     (* cчитает кнопки по Y *)
	       FIO.WrCard(file,color[i,j],3)
	     END;
	    END;
FIO.Close(file);
END FileSave;

PROCEDURE FileLoad(Name : ARRAY OF CHAR);
VAR i,j : CARDINAL ;
CONST color ::= GraphVl.Color;
BEGIN
file:=FIO.Open(Name);
IF NOT(FIO.OK)	THEN HALT END ;
	       FOR i := 1 TO 14  DO  (* считаем кнопки по Х *)
	        FOR j:= 1 TO  7  DO  (* считаем кнопки по Y *)
	              color[i,j] :=  FIO.RdCard(file);
	        END;
	      END;
FIO.Close(file);
END FileLoad;

PROCEDURE Help(Name: ARRAY OF CHAR ; baseX,baseY : CARDINAL);
VAR
           buf  : ARRAY [1..10],[1..41] OF CHAR ;
	     m  : INTEGER ;
    px,py,py_hm : ARRAY [1..4] OF CARDINAL;

CONST  all = 'that is all' ;
      must = 'you must press (page up) or (quit)' ;
        up = 'page up';
      down = 'page down';
      quit = 'quit';
LABEL lab1,lab2,lab3,end;

BEGIN
file := FIO.Open(Name);
m := 1 ;
Fp[m] := 0;

px[1] := baseX+ 15;  py[1] := baseY+ 10;
px[2] := baseX+415;  py[2] := baseY+ 10;
px[3] := baseX+415;  py[3] := baseY+181;
px[4] := baseX+ 15;  py[4] := baseY+181;
Graph.Polygon(4,px,py,8);                              (* полигон тени *)


px[1] := baseX;      py[1] := baseY ;
px[2] := baseX+400;  py[2] := baseY;
px[3] := baseX+400;  py[3] := baseY+151;
px[4] := baseX;      py[4] := baseY+151;
Graph.Polygon(4,px,py,7);                              (* полигон окна Help *)

py_hm[1] := baseY+152;
py_hm[2] := baseY+152;
py_hm[3] := baseY+172;
py_hm[4] := baseY+172;
Graph.Polygon(4,px,py_hm,5);                           (* полигон меню *)

Graph.Line(baseX-1,  baseY,baseX-1,  baseY+173,15);    (* линии очерчивают окна *)
Graph.Line(baseX+401,baseY,baseX+401,baseY+173,15);    (* окна Help и меню Help *)
Graph.Line(baseX+300,baseY+152,baseX+300,baseY+173,15);
Graph.Line(baseX+150,baseY+152,baseX+150,baseY+173,15);

Graph.HLine(baseX-1,baseY,    baseX+401,15);
Graph.HLine(baseX-1,baseY+152,baseX+401,15);
Graph.HLine(baseX-1,baseY+173,baseX+401,15);

GraphVl.PaintString(ADR(up),baseX+45,baseY+159,15);     (* надписи в поле меню *)
GraphVl.PaintString(ADR(down),baseX+190,baseY+159,15);
GraphVl.PaintString(ADR(quit),baseX+330,baseY+159,15);

mouse.moufunc(7,0,baseX+2,  baseX+399);  (* Установка крайней позиции по оси X *)
mouse.moufunc(8,0,baseY+152,baseY+172);  (* Установка крайней позиции по оси Y *)
mouse.moufunc(4,0,baseX+220,baseY+163);  (* Установ. позиции мыши в коор Х и Y *)
lab1 :
   FIO.Seek(file,Fp[m]);
   FOR i:=1 TO 10 DO
      FOR j:=1 TO 40 DO buf[i,j]:=CHAR(0)  END ;
      FIO.RdStr(file,buf[i]);
   END ;

  a := baseY;
  FOR i := 1 TO 10 DO
      IF NOT(FIO.OK) THEN  GOTO lab2  END;
      a := a + 14;
      GraphVl.PaintString(ADR(buf[i]),baseX+15,a,0);
  END;	(* for *)

GOTO lab3;

lab2 : GraphVl.PaintString(ADR(all),baseX+160,a+100,4);
       GraphVl.PaintString(ADR(must),baseX+50,a+130,4);

lab3:
LOOP
mouse.moufunc(1,0,0,0);
mouse.moufunc(3,0,0,0);

    IF	    (mouse.pc>(baseX+150))AND(mouse.pc<(baseX+299))
	     THEN  CASE mouse.pb OF
		    1:
		     mouse.moufunc(2,0,0,0);
		     Graph.Polygon(4,px,py,7);
		     m := m + 1;
		     Fp[m] := FIO.GetPos(file);
		     GOTO lab1
		   END; (* case *)

      ELSIF (mouse.pc>(baseX+1))AND(mouse.pc<(baseX+149))
	     THEN  CASE mouse.pb OF
		    1:
		     mouse.moufunc(2,0,0,0);
		     Graph.Polygon(4,px,py,7);
		     m := m - 1;
		     IF m <= 0 THEN m := 1
			       END;
		     GOTO lab1
		   END; (* case *)
      ELSIF (mouse.pc>(baseX+300))AND(mouse.pc<(baseX+400))
	     THEN CASE mouse.pb OF
		   1:
		     mouse.moufunc(2,0,0,0);
		     EXIT
		  END; (* case *)
END; (* if *)

END; (* loop *)
end :
FIO.Close(file);
END Help;

END FioVl.
