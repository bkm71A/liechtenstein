IMPLEMENTATION MODULE Letter; (* private M.V.N. 1991 *)
FROM Graph IMPORT Plot,Line,HLine;

PROCEDURE letA(basaX,basaY,color : CARDINAL);    (* paint letter "A" *)
BEGIN
   HLine(basaX+1,basaY,basaX+6,color);
    Line(basaX,basaY+1,basaX,basaY+8,color);
    Line(basaX+6,basaY,basaX+6,basaY+8,color);
   HLine(basaX,basaY+5,basaX+6,color);
END letA ;

PROCEDURE letB(basaX,basaY,color : CARDINAL ) ;  (* paint letter "B" *)
BEGIN
  Line(basaX,basaY,basaX,basaY+8,color);
  HLine(basaX,basaY,basaX+5,color);
  HLine(basaX,basaY+4,basaX+5,color);
  HLine(basaX,basaY+8,basaX+5,color);
  Plot(basaX+6,basaY+1,color);
  Plot(basaX+6,basaY+2,color);
  Plot(basaX+6,basaY+3,color);
  Plot(basaX+6,basaY+5,color);
  Plot(basaX+6,basaY+6,color);
  Plot(basaX+6,basaY+7,color);
END letB ;

PROCEDURE letC(basaX,basaY,color : CARDINAL);    (* paint letter "C" *)
BEGIN
   HLine(basaX+1,basaY,basaX+5,color);
    Line(basaX,basaY+1,basaX,basaY+7,color);
   HLine(basaX+1,basaY+8,basaX+5,color);
   Plot(basaX+6,basaY+1,color);
   Plot(basaX+6,basaY+7,color);
END letC ;

PROCEDURE letD(basaX,basaY,color : CARDINAL ) ;  (* paint letter "D" *)
BEGIN
   HLine(basaX,basaY,basaX+4,color);
    Line(basaX,basaY,basaX,basaY+8,color);
    Plot(basaX+5,basaY+1,color);
    Plot(basaX+5,basaY+7,color);
    Line(basaX+6,basaY+2,basaX+6,basaY+6,color);
   HLine(basaX,basaY+8,basaX+4,color);
END letD ;

PROCEDURE letE(basaX,basaY,color : CARDINAL ) ;  (* paint letter "E" *)
BEGIN
  Line(basaX,basaY,basaX,basaY+8,color);
  HLine(basaX,basaY,basaX+6,color);
  HLine(basaX,basaY+8,basaX+6,color);
  HLine(basaX,basaY+4,basaX+5,color);
END letE ;

PROCEDURE letF(basaX,basaY,color : CARDINAL ) ;  (* paint letter "F" *)
BEGIN
  Line(basaX,basaY,basaX,basaY+8,color);
  HLine(basaX,basaY,basaX+6,color);
  HLine(basaX,basaY+4,basaX+5,color);
END letF ;

PROCEDURE letG(basaX,basaY,color : CARDINAL);    (* paint letter "G" *)
BEGIN
   HLine(basaX+1,basaY,basaX+5,color);
    Line(basaX,basaY+1,basaX,basaY+7,color);
    Line(basaX+6,basaY+5,basaX+6,basaY+7,color);
   HLine(basaX+1,basaY+8,basaX+5,color);
   HLine(basaX+3,basaY+5,basaX+5,color);
   Plot(basaX+6,basaY+1,color);
END letG ;

PROCEDURE letH(basaX,basaY,color : CARDINAL);    (* paint letter "H" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+8,color);
    Line(basaX+6,basaY,basaX+6,basaY+8,color);
   HLine(basaX,basaY+4,basaX+6,color);
END letH ;

PROCEDURE letI(basaX,basaY,color : CARDINAL ) ;  (* paint letter "I" *)
BEGIN
   HLine(basaX+2,basaY,basaX+4,color);
    Line(basaX+3,basaY,basaX+3,basaY+8,color);
   HLine(basaX+2,basaY+8,basaX+4,color);
END letI ;

PROCEDURE letJ(basaX,basaY,color : CARDINAL ) ;  (* paint letter "J" *)
BEGIN
    Plot(basaX,basaY+7,color);
    Line(basaX+6,basaY,basaX+6,basaY+7,color);
   HLine(basaX+1,basaY+8,basaX+5,color);
END letJ ;

PROCEDURE letK(basaX,basaY,color : CARDINAL);    (* paint letter "K" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+8,color);
    Line(basaX,basaY+5,basaX+6,basaY,color);
    Line(basaX+2,basaY+4,basaX+6,basaY+8,color);
END letK ;

PROCEDURE letL(basaX,basaY,color : CARDINAL ) ;  (* paint letter "L" *)
BEGIN
    Plot(basaX+6,basaY+7,color);
    Line(basaX,basaY,basaX,basaY+8,color);
   HLine(basaX+1,basaY+8,basaX+6,color);
END letL ;


PROCEDURE letM(basaX,basaY,color : CARDINAL);    (* paint letter "M" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+8,color);
    Line(basaX+6,basaY,basaX+6,basaY+8,color);
    Line(basaX,basaY,basaX+3,basaY+3,color);
    Line(basaX+3,basaY+3,basaX+6,basaY,color);
END letM ;

PROCEDURE letN(basaX,basaY,color : CARDINAL);    (* paint letter "N" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+8,color);
    Line(basaX+6,basaY,basaX+6,basaY+8,color);
    Line(basaX,basaY,basaX+6,basaY+8,color);
END letN ;

PROCEDURE letO(basaX,basaY,color : CARDINAL ) ;  (* paint letter "O" *)
BEGIN
   HLine(basaX+1,basaY,basaX+5,color);
   Line(basaX,basaY+1,basaX,basaY+7,color);
   Line(basaX+6,basaY+1,basaX+6,basaY+7,color);
   HLine(basaX+1,basaY+8,basaX+5,color);
END letO ;

PROCEDURE letP(basaX,basaY,color : CARDINAL ) ;  (* paint letter "P" *)
BEGIN
   Line(basaX,basaY,basaX,basaY+8,color);
   Line(basaX+6,basaY+1,basaX+6,basaY+3,color);
  HLine(basaX,basaY,basaX+5,color);
  HLine(basaX,basaY+4,basaX+5,color);
END letP ;

PROCEDURE letQ(basaX,basaY,color : CARDINAL ) ;  (* paint letter "Q" *)
BEGIN
   HLine(basaX+1,basaY,basaX+5,color);
    Line(basaX,basaY+1,basaX,basaY+7,color);
    Line(basaX+6,basaY+1,basaX+6,basaY+7,color);
   HLine(basaX+1,basaY+8,basaX+5,color);
    Plot(basaX+3,basaY+6,color);
    Plot(basaX+4,basaY+7,color);
    Plot(basaX+5,basaY+8,color);
    Plot(basaX+6,basaY+9,color);
    Plot(basaX+6,basaY+10,color);
END letQ ;

PROCEDURE letR(basaX,basaY,color : CARDINAL ) ;  (* paint letter "R" *)
BEGIN
   Line(basaX,basaY,basaX,basaY+8,color);
   Line(basaX+6,basaY+1,basaX+6,basaY+3,color);
   Line(basaX+2,basaY+4,basaX+6,basaY+8,color);
  HLine(basaX,basaY,basaX+5,color);
  HLine(basaX,basaY+4,basaX+5,color);
END letR ;

PROCEDURE letS(basaX,basaY,color : CARDINAL ) ;  (* paint letter "S" *)
BEGIN
   Plot(basaX+6,basaY+1,color);
   Plot(basaX,basaY+7,color);
   Line(basaX,basaY+1,basaX,basaY+3,color);
   Line(basaX+6,basaY+5,basaX+6,basaY+7,color);
  HLine(basaX+1,basaY,basaX+5,color);
  HLine(basaX+1,basaY+4,basaX+5,color);
  HLine(basaX+1,basaY+8,basaX+5,color);
END letS ;

PROCEDURE letT(basaX,basaY,color : CARDINAL ) ;  (* paint letter "T" *)
BEGIN
   HLine(basaX,basaY,basaX+6,color);
    Line(basaX+3,basaY,basaX+3,basaY+8,color);
    Plot(basaX,basaY+1,color);
    Plot(basaX+6,basaY+1,color);
END letT ;

PROCEDURE letU(basaX,basaY,color : CARDINAL);    (* paint letter "U" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+7,color);
    Line(basaX+6,basaY,basaX+6,basaY+7,color);
   HLine(basaX+1,basaY+8,basaX+5,color);
END letU ;

PROCEDURE letV(basaX,basaY,color : CARDINAL);    (* paint letter "V" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+5,color);
    Line(basaX+6,basaY,basaX+6,basaY+5,color);
    Line(basaX,basaY+5,basaX+3,basaY+8,color);
    Line(basaX+3,basaY+8,basaX+6,basaY+5,color);
END letV ;

PROCEDURE letW(basaX,basaY,color : CARDINAL);    (* paint letter "W" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+7,color);
    Line(basaX+6,basaY,basaX+6,basaY+7,color);
    Line(basaX+1,basaY+8,basaX+3,basaY+6,color);
    Line(basaX+3,basaY+6,basaX+5,basaY+8,color);
END letW ;


PROCEDURE letX(basaX,basaY,color : CARDINAL);    (* paint letter "X" *)
BEGIN
    Line(basaX,basaY+1,basaX+6,basaY+7,color);
    Line(basaX+6,basaY+1,basaX,basaY+7,color);
    Plot(basaX,basaY,color);
    Plot(basaX,basaY+8,color);
    Plot(basaX+6,basaY,color);
    Plot(basaX+6,basaY+8,color);
END letX ;

PROCEDURE letY(basaX,basaY,color : CARDINAL);    (* paint letter "Y" *)
BEGIN
    Line(basaX,basaY,basaX+3,basaY+3,color);
    Line(basaX+3,basaY+3,basaX+6,basaY,color);
    Line(basaX+3,basaY+3,basaX+3,basaY+8,color);
END letY ;

PROCEDURE letZ(basaX,basaY,color : CARDINAL ) ;  (* paint letter "Z" *)
BEGIN
   Plot(basaX,basaY+1,color);
   Plot(basaX+6,basaY+7,color);
   Line(basaX+6,basaY+1,basaX,basaY+7,color);
  HLine(basaX,basaY,basaX+6,color);
  HLine(basaX,basaY+8,basaX+6,color);
END letZ ;

PROCEDURE letEQUIVALENT(basaX,basaY,color : CARDINAL);    (* paint letter "=" *)
BEGIN
   HLine(basaX+2,basaY+3,basaX+4,color);
   HLine(basaX+2,basaY+6,basaX+4,color);
END letEQUIVALENT ;

PROCEDURE letPLUS(basaX,basaY,color : CARDINAL);    (* paint letter "+" *)
BEGIN
   HLine(basaX+1,basaY+4,basaX+5,color);
    Line(basaX+3,basaY+6,basaX+3,basaY+2,color);
END letPLUS ;

PROCEDURE letMINUS(basaX,basaY,color : CARDINAL);    (* paint letter "-" *)
BEGIN
   HLine(basaX+1,basaY+4,basaX+5,color)
END letMINUS ;

PROCEDURE letPROC(basaX,basaY,color : CARDINAL);    (* paint letter "%" *)
BEGIN
    Line(basaX+6,basaY,basaX,basaY+8,color);
   Plot(basaX,basaY,color);
   Plot(basaX+6,basaY+8,color)
END letPROC ;

PROCEDURE letPOINT(basaX,basaY,color: CARDINAL);     (* paint letter "." *)
BEGIN
    Plot(basaX+1,basaY+8,color)
END letPOINT;

PROCEDURE letZPT(basaX,basaY,color: CARDINAL);     (* paint letter "," *)
BEGIN
    Plot(basaX,basaY+8,color);
    Plot(basaX-1,basaY+9,color)
END letZPT;

PROCEDURE let2POINT(basaX,basaY,color: CARDINAL);     (* paint letter ":" *)
BEGIN
    Plot(basaX+1,basaY+7,color);
    Plot(basaX+1,basaY+1,color)
END let2POINT;

PROCEDURE letSkLeft(basaX,basaY,color: CARDINAL);     (* paint letter "(" *)
BEGIN
     Line(basaX+2,basaY+2,basaX+2,basaY+6,color);
     Line(basaX+2,basaY+2,basaX+4,basaY  ,color);
     Line(basaX+2,basaY+6,basaX+4,basaY+8,color);
END letSkLeft;

PROCEDURE letSkRight(basaX,basaY,color: CARDINAL);     (* paint letter ")" *)
BEGIN
     Line(basaX+4,basaY+2,basaX+4,basaY+6,color);
     Line(basaX+2,basaY,  basaX+4,basaY+2,color);
     Line(basaX+4,basaY+6,basaX+2,basaY+8,color);
END letSkRight;

PROCEDURE letKvSkL(basaX,basaY,color : CARDINAL);
BEGIN
     Line(basaX+1,basaY,  basaX+1,basaY+8,color);
     Line(basaX+1,basaY,  basaX+4,basaY,  color);
     Line(basaX+1,basaY+8,basaX+4,basaY+8,color);
END letKvSkL;	
	
PROCEDURE letKvSkR(basaX,basaY,color : CARDINAL) ;
BEGIN
     Line(basaX+5,basaY,  basaX+5,basaY+8,color);
     Line(basaX+5,basaY,  basaX+2,basaY  ,color);
     Line(basaX+5,basaY+8,basaX+2,basaY+8,color);
END letKvSkR;	
	
PROCEDURE letKosL(basaX,basaY,color : CARDINAL) ;
BEGIN
     Line(basaX,basaY,basaX+6,basaY+8,color);
END letKosL;	

PROCEDURE letImpers(basaX,basaY,color : CARDINAL);
BEGIN
     Line(basaX,  basaY+1,basaX,  basaY+2,color);
     Line(basaX+3,basaY+1,basaX+3,basaY+2,color);
     Line(basaX+1,basaY  ,basaX+2,basaY  ,color);
     Line(basaX,  basaY+5,basaX,  basaY+7,color);
     Line(basaX+1,basaY+7,basaX+4,basaY+7,color);
     Line(basaX+1,basaY+4,basaX+2,basaY+3,color);
     Line(basaX+1,basaY+3,basaX+6,basaY+8,color);
     Plot(basaX+6,basaY+6,color);
END letImpers;

PROCEDURE letUndLin(basaX,basaY,color : CARDINAL);
BEGIN
     Line(basaX,basaY+8,basaX+6,basaY+8,color);
END letUndLin;

PROCEDURE letZvzd(basaX,basaY,color : CARDINAL);
BEGIN
     Line(basaX,  basaY+1,basaX+6,basaY+7,color);
     Line(basaX,  basaY+7,basaX+6,basaY+1,color);
     Line(basaX,  basaY+4,basaX+6,basaY+4,color);
END letZvzd;

	
PROCEDURE letVOICE(basaX,basaY,color: CARDINAL);     (* paint letter "!" *)
BEGIN
     Line(basaX+3,basaY,basaX+3,basaY+6,color);
     Line(basaX+4,basaY,basaX+3,basaY+6,color);
     Line(basaX+2,basaY,basaX+3,basaY+6,color);
     Plot(basaX+3,basaY+8,color)
END letVOICE;

PROCEDURE letQUEST(basaX,basaY,color : CARDINAL ) ;  (* paint letter "?" *)
BEGIN
  HLine(basaX+1,basaY,basaX+5,color);
  HLine(basaX+2,basaY+4,basaX+5,color);
   Line(basaX+2,basaY+5,basaX+2,basaY+6,color);
   Plot(basaX+2,basaY+8,color);
   Plot(basaX,basaY+1,color);
   Plot(basaX+6,basaY+1,color);
   Plot(basaX+6,basaY+2,color);
   Plot(basaX+6,basaY+3,color)
END letQUEST ;

PROCEDURE letERROR(basaX,basaY,color : CARDINAL ) ;  (* paint letter "ERROR" *)
BEGIN
   Plot(basaX,basaY+1,color);
   Plot(basaX+6,basaY+7,color);
   Line(basaX,basaY,basaX,basaY+8,color);
   Line(basaX+6,basaY,basaX+6,basaY+8,color);
   Line(basaX+6,basaY+1,basaX,basaY+7,color);
   Line(basaX,basaY+1,basaX+6,basaY+7,color);
  HLine(basaX,basaY,basaX+6,color);
  HLine(basaX,basaY+8,basaX+6,color);
END letERROR ;

PROCEDURE let0(basaX,basaY,color : CARDINAL ) ;  (* paint letter "0" *)
BEGIN
   HLine(basaX+1,basaY,basaX+5,color);
   Line(basaX,basaY+1,basaX,basaY+7,color);
   Line(basaX+6,basaY+1,basaX+6,basaY+7,color);
   Line(basaX,basaY+6,basaX+6,basaY+2,color);
   HLine(basaX+1,basaY+8,basaX+5,color);
END let0 ;

PROCEDURE let1(basaX,basaY,color : CARDINAL ) ;  (* paint letter "1" *)
BEGIN
   Line(basaX+3,basaY,basaX+3,basaY+8,color);
   Line(basaX+3,basaY,basaX,basaY+3,color);
END let1 ;

PROCEDURE let2(basaX,basaY,color : CARDINAL ) ;  (* paint letter "2" *)
BEGIN
   Plot(basaX,basaY+1,color);
   Plot(basaX+6,basaY+7,color);
   Plot(basaX+6,basaY+2,color);
   Plot(basaX+6,basaY+1,color);
   Line(basaX+6,basaY+3,basaX,basaY+8,color);
  HLine(basaX+1,basaY,basaX+5,color);
  HLine(basaX,basaY+8,basaX+6,color);
END let2 ;

PROCEDURE let3(basaX,basaY,color : CARDINAL ) ;  (* paint letter "3" *)
BEGIN
  HLine(basaX+1,basaY,basaX+5,color);
  HLine(basaX+2,basaY+4,basaX+5,color);
  HLine(basaX+1,basaY+8,basaX+5,color);
  Plot(basaX,basaY+7,color);
  Plot(basaX,basaY+1,color);
  Plot(basaX+6,basaY+1,color);
  Plot(basaX+6,basaY+2,color);
  Plot(basaX+6,basaY+3,color);
  Plot(basaX+6,basaY+5,color);
  Plot(basaX+6,basaY+6,color);
  Plot(basaX+6,basaY+7,color);
END let3 ;

PROCEDURE let4(basaX,basaY,color : CARDINAL);    (* paint letter "4" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+4,color);
    Line(basaX+6,basaY,basaX+6,basaY+8,color);
   HLine(basaX,basaY+4,basaX+6,color);
END let4 ;

PROCEDURE let5(basaX,basaY,color : CARDINAL ) ;  (* paint letter "5" *)
BEGIN
  HLine(basaX,basaY,basaX+6,color);
  HLine(basaX,basaY+4,basaX+5,color);
  HLine(basaX+1,basaY+8,basaX+5,color);
   Line(basaX,basaY,basaX,basaY+4,color);
   Line(basaX+6,basaY+5,basaX+6,basaY+7,color);
   Plot(basaX,basaY+7,color);
END let5 ;

PROCEDURE let6(basaX,basaY,color : CARDINAL);    (* paint letter "6" *)
BEGIN
   HLine(basaX+1,basaY,basaX+5,color);
    Line(basaX,basaY+1,basaX,basaY+7,color);
    Line(basaX+6,basaY+5,basaX+6,basaY+7,color);
   HLine(basaX+1,basaY+8,basaX+5,color);
   HLine(basaX+1,basaY+4,basaX+5,color);
   Plot(basaX+6,basaY+1,color);
END let6 ;

PROCEDURE let7(basaX,basaY,color : CARDINAL ) ;  (* paint letter "7" *)
BEGIN
   Plot(basaX,basaY+1,color);
   Plot(basaX+6,basaY+1,color);
   Plot(basaX+6,basaY+2,color);
   Line(basaX+6,basaY+3,basaX,basaY+8,color);
  HLine(basaX,basaY,basaX+6,color);
END let7 ;

PROCEDURE let8(basaX,basaY,color : CARDINAL ) ;  (* paint letter "8" *)
BEGIN
   Line(basaX,basaY+1,basaX,basaY+3,color);
   Line(basaX,basaY+5,basaX,basaY+7,color);
   Line(basaX+6,basaY+5,basaX+6,basaY+7,color);
   Line(basaX+6,basaY+1,basaX+6,basaY+3,color);
  HLine(basaX+1,basaY,basaX+5,color);
  HLine(basaX+1,basaY+4,basaX+5,color);
  HLine(basaX+1,basaY+8,basaX+5,color);
END let8 ;

PROCEDURE let9(basaX,basaY,color : CARDINAL ) ;  (* paint letter "9" *)
BEGIN
   Plot(basaX,basaY+7,color);
   Line(basaX,basaY+1,basaX,basaY+3,color);
   Line(basaX+6,basaY+1,basaX+6,basaY+7,color);
  HLine(basaX+1,basaY,basaX+5,color);
  HLine(basaX+1,basaY+4,basaX+5,color);
  HLine(basaX+1,basaY+8,basaX+5,color);
END let9 ;

END Letter.
