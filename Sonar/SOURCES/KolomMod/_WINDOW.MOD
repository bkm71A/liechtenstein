(*$D D_DATA *)
IMPLEMENTATION MODULE _Window ;

             IMPORT Str,IO,SYSTEM,Asm ;

FROM Window  IMPORT WinDef,WinType,Color,
                    Open,Close,PutOnTop,Change,Info,GotoXY,TextColor,
                    TextBackground ;

VAR i,j : CARDINAL ;
                          (* делаем привязку тени к описаному окну *)
PROCEDURE Open_Sh(ww : WinType) : CARDINAL ;
VAR VhodDef : WinDef ;
LABEL con ;
BEGIN Info(ww,VhodDef) ;
      FOR i :=0 TO max DO
         IF Stack_Win[i,0]=NIL THEN GOTO con END ;
      END ; (* for *)
 (****  Переполнение ****)
con : Stack_Win[i,0] := ww ;
      Opis[i,1].X1:=VhodDef.X2+1 ;
      Opis[i,1].Y1:=VhodDef.Y1+1 ;
      Opis[i,1].X2:=VhodDef.X2+2 ;
      Opis[i,1].Y2:=VhodDef.Y2   ;
        Stack_Win[i,1] := Open(Opis[i,1]) ;
        Asm.Str_Ten(Opis[i,1].X1,Opis[i,1].Y1,Opis[i,1].X2,Opis[i,1].Y2) ;
      Opis[i,2].X1:=VhodDef.X1+2 ;
      Opis[i,2].Y1:=VhodDef.Y2+1 ;
      Opis[i,2].X2:=VhodDef.X2+2 ;
      Opis[i,2].Y2:=VhodDef.Y2+1 ;
        Stack_Win[i,2] := Open(Opis[i,2]) ;
        Asm.Str_Ten(Opis[i,2].X1,Opis[i,2].Y1,Opis[i,2].X2,Opis[i,2].Y2) ;
   RETURN i ;
END Open_Sh ;
(*
PROCEDURE Change_Sh( T : CARDINAL );
VAR VhodDef : WinDef ;
    a,b,c,d : CARDINAL ;
BEGIN Info(Stack_Win[T,0],VhodDef) ;
      a:=VhodDef.X2+1 ;   b:=VhodDef.Y1+1 ;
      c:=VhodDef.X2+2 ;   d:=VhodDef.Y2   ;
        Change(Stack_Win[T,1],a,b,c,d) ;
        Asm.Str_Ten(a,b,c,d) ;
      a:=VhodDef.X1+2 ;   b:=VhodDef.Y2+1 ;
      c:=VhodDef.X2+2 ;   d:=VhodDef.Y2+1 ;
        Change(Stack_Win[T,2],a,b,c,d) ;
        Asm.Str_Ten(a,b,c,d) ;
END Change_Sh ;
*)
PROCEDURE Close_Sh( T : CARDINAL ) ;
BEGIN Stack_Win[T,0] := NIL ;
      PutOnTop(Stack_Win[T,1]) ;
          Close(Stack_Win[T,1]) ;
      PutOnTop(Stack_Win[T,2]) ;
          Close(Stack_Win[T,2]) ;
END Close_Sh ;

PROCEDURE Shadow(ww : WinType) ;
VAR VhodDef : WinDef ;
BEGIN Info(ww,VhodDef) ;
      Asm.Str_Ten(VhodDef.X2+1,VhodDef.Y1+1,VhodDef.X2+2,VhodDef.Y2)   ;
      Asm.Str_Ten(VhodDef.X1+2,VhodDef.Y2+1,VhodDef.X2+2,VhodDef.Y2+1)
END Shadow ;



BEGIN
   FOR i:=0 TO max DO
        Stack_Win[i,0]        := NIL ;
      FOR j:=1 TO 2 DO
        Stack_Win[i,j]        := NIL ;
        Opis[i,j].Foreground  := Black ;
        Opis[i,j].Background  := Black ;
        Opis[i,j].CursorOn    := FALSE ;
        Opis[i,j].WrapOn      := FALSE ;
        Opis[i,j].Hidden      := TRUE ; (* скрыто - TRUE *)
        Opis[i,j].FrameOn     := FALSE ;
      END ;
   END ;

END _Window.