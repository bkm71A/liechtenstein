IMPLEMENTATION MODULE LetterR;    (* private M.V.N. 1991 *)
(* paint Russian letters *)

  FROM Graph IMPORT Plot,Line,HLine;
  VAR basaX, basaY              : CARDINAL;

PROCEDURE letA(basaX,basaY,color : CARDINAL);    (* paint letter "A" *)
BEGIN
   HLine(basaX+1,basaY,basaX+6,color);
    Line(basaX,basaY+1,basaX,basaY+8,color);
    Line(basaX+6,basaY,basaX+6,basaY+8,color);
   HLine(basaX,basaY+5,basaX+6,color);
END letA ;

PROCEDURE letB(basaX,basaY,color : CARDINAL ) ;  (* paint letter "Å" *)
BEGIN
  Line(basaX,basaY,basaX,basaY+8,color);
  HLine(basaX,basaY,basaX+6,color);
  HLine(basaX,basaY+4,basaX+5,color);
  HLine(basaX,basaY+8,basaX+5,color);
  Plot(basaX+6,basaY+1,color);
  Plot(basaX+6,basaY+5,color);
  Plot(basaX+6,basaY+6,color);
  Plot(basaX+6,basaY+7,color);
END letB ;

PROCEDURE letV(basaX,basaY,color : CARDINAL ) ;  (* paint letter "Ç" *)
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
END letV ;

PROCEDURE letG(basaX,basaY,color : CARDINAL ) ;  (* paint letter "É" *)
BEGIN
  Line(basaX,basaY,basaX,basaY+8,color);
  HLine(basaX,basaY,basaX+6,color);
  Plot(basaX+6,basaY+1,color);
END letG ;

PROCEDURE letD(basaX,basaY,color : CARDINAL);
BEGIN
 HLine(basaX+2,basaY,basaX+5,color);
    Line(basaX+1,basaY+1,basaX+1,basaY+6,color);
    Line(basaX+5,basaY,basaX+5,basaY+6,color);
   HLine(basaX,basaY+7,basaX+6,color);
   Plot(basaX,basaY+8,color);
   Plot(basaX+6,basaY+8,color);
END letD ;

PROCEDURE letE(basaX,basaY,color : CARDINAL ) ;  (* paint letter "Ö" *)
BEGIN
  Line(basaX,basaY,basaX,basaY+8,color);
  HLine(basaX,basaY,basaX+6,color);
  HLine(basaX,basaY+8,basaX+6,color);
  HLine(basaX,basaY+4,basaX+5,color);
END letE ;

PROCEDURE letGe(basaX,basaY,color : CARDINAL);    (* paint letter "Ü" *)
BEGIN
    Line(basaX,basaY+1,basaX+6,basaY+7,color);
    Line(basaX+6,basaY+1,basaX,basaY+7,color);
    Line(basaX+3,basaY,basaX+3,basaY+8,color);
    Plot(basaX,basaY,color);
    Plot(basaX,basaY+8,color);
    Plot(basaX+6,basaY,color);
    Plot(basaX+6,basaY+8,color);
END letGe;

PROCEDURE letZ(basaX,basaY,color : CARDINAL ) ;  (* paint letter "á" *)
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
END letZ ;

PROCEDURE letI(basaX,basaY,color : CARDINAL);    (* paint letter "à" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+8,color);
    Line(basaX+6,basaY,basaX+6,basaY+8,color);
    Line(basaX+6,basaY+1,basaX,basaY+7,color);
END letI ;

PROCEDURE letK(basaX,basaY,color : CARDINAL);    (* paint letter "ä" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+8,color);
    Line(basaX,basaY+5,basaX+6,basaY,color);
    Line(basaX+2,basaY+4,basaX+6,basaY+8,color);
END letK ;

PROCEDURE letL(basaX,basaY,color : CARDINAL);    (* paint letter "ã" *)
BEGIN
   HLine(basaX+2,basaY,basaX+6,color);
    Line(basaX+1,basaY+1,basaX+1,basaY+7,color);
    Line(basaX+6,basaY,basaX+6,basaY+8,color);
    Plot(basaX,basaY+8,color);
END letL ;

PROCEDURE letM(basaX,basaY,color : CARDINAL);    (* paint letter "å" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+8,color);
    Line(basaX+6,basaY,basaX+6,basaY+8,color);
    Line(basaX,basaY,basaX+3,basaY+3,color);
    Line(basaX+3,basaY+3,basaX+6,basaY,color);
END letM ;

PROCEDURE letN(basaX,basaY,color : CARDINAL);    (* paint letter "H" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+8,color);
    Line(basaX+6,basaY,basaX+6,basaY+8,color);
   HLine(basaX,basaY+4,basaX+6,color);
END letN ;

PROCEDURE letO(basaX,basaY,color : CARDINAL ) ;  (* paint letter "O" *)
BEGIN
   HLine(basaX+1,basaY,basaX+5,color);
   Line(basaX,basaY+1,basaX,basaY+7,color);
   Line(basaX+6,basaY+1,basaX+6,basaY+7,color);
   HLine(basaX+1,basaY+8,basaX+5,color);
END letO ;

PROCEDURE letP(basaX,basaY,color : CARDINAL);    (* paint letter "è" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+8,color);
    Line(basaX+6,basaY,basaX+6,basaY+8,color);
   HLine(basaX,basaY,basaX+6,color);
END letP ;

PROCEDURE letR(basaX,basaY,color : CARDINAL ) ;  (* paint letter "P" *)
BEGIN
   Line(basaX,basaY,basaX,basaY+8,color);
   Line(basaX+6,basaY+1,basaX+6,basaY+3,color);
  HLine(basaX,basaY,basaX+5,color);
  HLine(basaX,basaY+4,basaX+5,color);
END letR ;

PROCEDURE letS(basaX,basaY,color : CARDINAL);    (* paint letter "C" *)
BEGIN
   HLine(basaX+1,basaY,basaX+5,color);
    Line(basaX,basaY+1,basaX,basaY+7,color);
   HLine(basaX+1,basaY+8,basaX+5,color);
   Plot(basaX+6,basaY+1,color);
   Plot(basaX+6,basaY+7,color);
END letS ;

PROCEDURE letT(basaX,basaY,color : CARDINAL ) ;  (* paint letter "T" *)
BEGIN
   HLine(basaX,basaY,basaX+6,color);
    Line(basaX+3,basaY,basaX+3,basaY+8,color);
    Plot(basaX,basaY+1,color);
    Plot(basaX+6,basaY+1,color);
END letT ;

PROCEDURE letU(basaX,basaY,color : CARDINAL);    (* paint letter "ì" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+3,color);
    Line(basaX+6,basaY,basaX+6,basaY+7,color);
   HLine(basaX+1,basaY+4,basaX+6,color);
   HLine(basaX+1,basaY+8,basaX+5,color);
   Plot(basaX,basaY+7,color);
END letU ;

PROCEDURE letF(basaX,basaY,color : CARDINAL);     (* paint letter "î" *)
BEGIN
   Line(basaX,basaY+2,basaX,basaY+4,color);
   Line(basaX+3,basaY,basaX+3,basaY+8,color);
   Line(basaX+6,basaY+2,basaX+6,basaY+4,color);
  HLine(basaX+1,basaY+1,basaX+5,color);
  HLine(basaX+1,basaY+5,basaX+5,color);
END letF;

PROCEDURE letH(basaX,basaY,color : CARDINAL);    (* paint letter "X" *)
BEGIN
    Line(basaX,basaY+1,basaX+6,basaY+7,color);
    Line(basaX+6,basaY+1,basaX,basaY+7,color);
    Plot(basaX,basaY,color);
    Plot(basaX,basaY+8,color);
    Plot(basaX+6,basaY,color);
    Plot(basaX+6,basaY+8,color);
END letH ;

PROCEDURE letC(basaX,basaY,color : CARDINAL);    (* paint letter "ñ" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+7,color);
    Line(basaX+5,basaY,basaX+5,basaY+7,color);
   HLine(basaX,basaY+8,basaX+6,color);
    Plot(basaX+6,basaY+9,color);
END letC ;

PROCEDURE letCh(basaX,basaY,color : CARDINAL);    (* paint letter "ó" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+3,color);
    Line(basaX+6,basaY,basaX+6,basaY+8,color);
   HLine(basaX+1,basaY+4,basaX+6,color);
END letCh ;

PROCEDURE letSh(basaX,basaY,color : CARDINAL);    (* paint letter "ò" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+8,color);
    Line(basaX+6,basaY,basaX+6,basaY+8,color);
    Line(basaX+3,basaY,basaX+3,basaY+8,color);
   HLine(basaX,basaY+8,basaX+6,color);
END letSh ;

PROCEDURE letSCh(basaX,basaY,color : CARDINAL);    (* paint letter "ô" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+8,color);
    Line(basaX+6,basaY,basaX+6,basaY+8,color);
    Line(basaX+3,basaY,basaX+3,basaY+8,color);
   HLine(basaX,basaY+8,basaX+6,color);
   Plot(basaX+7,basaY+9,color);
END letSCh ;

PROCEDURE letEe(basaX,basaY,color : CARDINAL ) ;  (* paint letter "ù" *)
BEGIN
   HLine(basaX+1,basaY,basaX+5,color);
   HLine(basaX+2,basaY+4,basaX+6,color);
    Plot(basaX,basaY+1,color);
    Plot(basaX,basaY+7,color);
    Line(basaX+6,basaY+1,basaX+6,basaY+7,color);
   HLine(basaX+1,basaY+8,basaX+5,color);
END letEe ;

PROCEDURE letYu(basaX,basaY,color : CARDINAL )  ;  (* Paint letter "û" *)
BEGIN
    Line(basaX,basaY,basaX,basaY+8,color);
    Line(basaX+3,basaY+1,basaX+3,basaY+7,color);
    Line(basaX+6,basaY+1,basaX+6,basaY+7,color);
    HLine(basaX+1,basaY+4,basaX+3,color);
    HLine(basaX+4,basaY,basaX+5,color);
    HLine(basaX+4,basaY+8,basaX+5,color);
END letYu;

PROCEDURE letYa(basaX,basaY,color : CARDINAL ) ;  (* paint letter "ü" *)
BEGIN
   Line(basaX+6,basaY,basaX+6,basaY+8,color);
   Line(basaX,basaY+1,basaX,basaY+3,color);
   Line(basaX,basaY+8,basaX+3,basaY+5,color);
  HLine(basaX+1,basaY,basaX+6,color);
  HLine(basaX+1,basaY+4,basaX+6,color);
END letYa ;

PROCEDURE letMZ(basaX,basaY,color : CARDINAL ) ;  (* paint letter "ú" *)
BEGIN
  Line(basaX,basaY,basaX,basaY+8,color);
  HLine(basaX,basaY+4,basaX+5,color);
  HLine(basaX,basaY+8,basaX+5,color);
  Plot(basaX+6,basaY+5,color);
  Plot(basaX+6,basaY+6,color);
  Plot(basaX+6,basaY+7,color);
END letMZ ;

PROCEDURE letTZ(basaX,basaY,color : CARDINAL ) ;  (* paint letter "ö" *)
BEGIN
  Line(basaX+1,basaY,basaX+1,basaY+8,color);
  HLine(basaX+1,basaY+4,basaX+5,color);
  HLine(basaX+1,basaY+8,basaX+5,color);
  Line(basaX+6,basaY+5,basaX+6,basaY+7,color);
  HLine(basaX-1,basaY,basaX+1,color)
END letTZ ;

PROCEDURE letII(basaX,basaY,color : CARDINAL ) ;  (* paint letter "õ" *)
BEGIN
  Line(basaX,basaY,basaX,basaY+8,color);
  HLine(basaX,basaY+4,basaX+3,color);
  HLine(basaX,basaY+8,basaX+3,color);
  Plot(basaX+4,basaY+5,color);
  Plot(basaX+4,basaY+6,color);
  Plot(basaX+4,basaY+7,color);
  Line(basaX+6,basaY,basaX+6,basaY+8,color)
END letII;



END LetterR.
