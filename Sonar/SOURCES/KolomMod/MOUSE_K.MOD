IMPLEMENTATION MODULE mouse_k;
IMPORT Lib,IO ;
VAR Shift[0:0417H] : SHORTCARD ;

PROCEDURE MousFunc(a,b,c,d:CARDINAL);
VAR pr : BOOLEAN ;
    ot : CHAR ;
BEGIN
    r.AX:=a;
    r.BX:=b;
    r.CX:=c;
    r.DX:=d;
    IF (r.AX=3)AND(IO.KeyPressed()) THEN
             Lib.Intr(r,33H) ;
             CASE SHORTCARD(IO.RdCharDirect()) OF
                 0 : r.AX:= 4 ; pr :=TRUE ;
                     IF SHORTCARD(BITSET(CARDINAL(Shift))*(BITSET(03H)))#0 THEN
                                pr :=FALSE
                     END ;
                     CASE SHORTCARD(IO.RdCharDirect()) OF
                  (* вниз *) 80 : IF pr THEN r.DX:= r.DX+14
                                        ELSE r.DX:= r.DX+1  END
                  (* вверх*)|72 : IF pr THEN r.DX:= r.DX-14
                                        ELSE r.DX:= r.DX-1  END
                  (*вправо*)|77 : IF pr THEN r.CX:= r.CX+14
                                        ELSE r.CX:= r.CX+1  END
                  (*влево *)|75 : IF pr THEN r.CX:= r.CX-14
                                        ELSE r.CX:= r.CX-1  END
                     END ; (* case *)
(* Esc *)     | 27 : r.BX := 4 ; RETURN
(* Enter *)   | 13 : r.BX := 1 ; RETURN
(* пробел*)   | 20H: r.BX := 2 ; RETURN
             END ;  (* case *)
    END ;
    Lib.Intr(r,33H);
END MousFunc;

PROCEDURE Trigger ;
BEGIN LOOP  MousGet ;  (* триггер *)
            IF r.BX=0 THEN EXIT END ;
      END ;
END Trigger ;

PROCEDURE Wait ;
VAR ot : CHAR ;
BEGIN
     LOOP  (* ожидаем любого нажатия *)
         IF IO.KeyPressed() THEN
              ot := IO.RdCharDirect() ;
              IF ot=CHR(0) THEN ot := IO.RdCharDirect() END ;
              EXIT
         END ;
         MousGet ;
         IF r.BX#0 THEN EXIT END ;
     END ;
END Wait ;

PROCEDURE MousOn ;
BEGIN MousFunc(1,0,0,0)
END MousOn ;

PROCEDURE MousOff;
BEGIN MousFunc(2,0,0,0)
END MousOff ;

PROCEDURE MousX(a,b:CARDINAL);
BEGIN MousFunc(7,0,a,b)
END MousX ;

PROCEDURE MousY(a,b:CARDINAL);
BEGIN MousFunc(8,0,a,b)
END MousY ;

PROCEDURE MousGet;
BEGIN MousFunc(3,0,0,0)
END MousGet ;

END mouse_k.