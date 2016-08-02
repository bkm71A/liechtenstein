IMPLEMENTATION MODULE mouse;  (* Private M.V.N. 1991 *)

IMPORT SYSTEM,Lib;

PROCEDURE moufunc(a,b,c,d:CARDINAL);
VAR reg : SYSTEM.Registers ;
BEGIN
    reg.AX:=a;
    reg.BX:=b;
    reg.CX:=c;
    reg.DX:=d;
     Lib.Intr(reg,33H);
    pa:=reg.AX;
    pb:=reg.BX;
    pc:=reg.CX;
    pd:=reg.DX;
END moufunc;

END mouse.