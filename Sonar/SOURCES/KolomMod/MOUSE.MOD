IMPLEMENTATION MODULE mouse;
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
               0 : r.AX:= 4 ;
                   IF SHORTCARD(BITSET(CARDINAL(Shift))*(BITSET(03H)))#0 THEN
                        pr :=FALSE
                   ELSE pr := TRUE
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
(* Esc *)   | 27 : r.BX := 4 ; answ_mouse:=4 ; RETURN
(* Enter *) | 13 : r.BX := 1 ; answ_mouse:=1 ; RETURN
(* пробел*) | 20H: r.BX := 2 ; answ_mouse:=2 ; RETURN
           END ;  (* case *)
    END ;
    IF r.AX=5 THEN LOOP     (* очищаем опережающий ввод *)
                   IF IO.KeyPressed() THEN ot:=IO.RdCharDirect()
                                      ELSE EXIT END
                   END ; (* loop *)
    END ; (* if *)
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
              IF    ot=CHR(27) THEN answ_mouse:=4
              ELSIF ot=CHR(13) THEN answ_mouse:=1
              ELSIF ot=CHR(32) THEN answ_mouse:=2
              ELSIF ot=CHR(0)  THEN
                    ot := IO.RdCharDirect() ;
                    answ_mouse:=0 ; (* нажата клавиша от клавиатуры ДРУГАЯ *)
              END ;
              EXIT
         END ;
         MousGet ;
         IF r.BX#0 THEN answ_mouse:= r.BX; EXIT END ;
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

PROCEDURE MousYes ;
BEGIN  r.AH := 0FAH ;              (* проверка наличия МЫШИ *)
       r.BX := 0    ;
          Lib.Intr(r,10H) ;
       IF r.BX=0 THEN IO.WrStr('Отсутствует драйвер "МЫШЬ"') ;
                      HALT END ;
END MousYes ;

END mouse.