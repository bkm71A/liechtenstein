IMPLEMENTATION MODULE MakeMenu; (* Copyright 1991, M.V.N. *)

IMPORT IO,Str;
FROM _Window  IMPORT Open_Shadow,Close_Shadow;
FROM  Window  IMPORT WinType,WinDef,Open,Close,SetTitle,Color,SetTitle,GotoXY,
                     CenterUpperTitle,Change,Clear,SingleFrame,TextColor,TextBackground,
                     SetFrame,SetTitle,PutOnTop,Hide,Use,FrameStr,TitleMode;

PROCEDURE Vert_menu(X1,Y1:            INTEGER;
                    ForeText:         Color;
                    QuantFields:      INTEGER;
                    Frame:            BOOLEAN;
                    FrameType:        FrameStr;
                    ForeFr,BackFr:    Color;
                    Hidden:           BOOLEAN;
                    Shadow:           BOOLEAN;
                    Title:            BOOLEAN;
                    TitlePos:         TitleMode;
                    TitleName:        ARRAY OF CHAR;
                    FieldsConteins:   ARRAY OF CHAR;
                    MaxLength:        INTEGER) : INTEGER;
VAR
  answ:              CHAR;
  control:           CARDINAL;
  i:                 INTEGER;
  length:            INTEGER;
  substring:         ARRAY [0..79] OF CHAR;
BEGIN

Change(wt_menu,X1,Y1,X1+3+MaxLength,Y1+QuantFields+1);
IF Frame  THEN SetFrame(wt_menu,FrameType,ForeFr,BackFr) END;
IF Title  THEN SetTitle(wt_menu,TitleName,TitlePos) END;
IF Shadow THEN control:= Open_Shadow(wt_menu) END;

PutOnTop(wt_menu);  Clear();
TextColor(ForeText);
FOR i:= 0 TO QuantFields-1  DO
    Str.ItemS(substring,FieldsConteins,'+',i);
    GotoXY(2,i+1);   IO.WrStr(substring);
END; (* for *)

(* -- открываем окно инверсии и выводим в него нулевое имя поля меню ----- *)
 Change(wt_invr,X1+1,Y1+1,X1+2+MaxLength,Y1+1);
 PutOnTop(wt_invr);  Clear();
 Str.ItemS(substring,FieldsConteins,'+',0);
 GotoXY(2,1); IO.WrStr(substring);

(* ---- анализируем в каком поле был нажат ввод и возвращаем номер поля ----- *)
i:= 0;
LOOP
 answ:=IO.RdCharDirect();
  CASE answ OF
       CHAR(27): IF Shadow THEN  Close_Shadow(control) END;
                 Hide(wt_menu);
                 Hide(wt_invr);
                 RETURN MAX(CARDINAL);
      |CHAR(13): IF Shadow THEN Close_Shadow(control) END;
                 IF Hidden THEN
                              Hide(wt_menu);
                              Hide(wt_invr);

                 END; (* if *)
                 RETURN i;
      |CHAR(0) : answ:=IO.RdCharDirect();
                 CASE answ OF  CHAR(72): DEC(i);
                              |CHAR(80): INC(i);
                 END; (* case *)
                 IF     i>QuantFields-1 THEN i:=0
                  ELSIF i<0 THEN i:=QuantFields-1
                 END; (* if *)
              Str.ItemS(substring,FieldsConteins,'+',i);
              Change(wt_invr,X1+1,Y1+i+1,X1+2+MaxLength,Y1+i+1);
              Clear();
              GotoXY(2,1);   IO.WrStr(substring);
  END; (* case *)
END; (* loop *)
END Vert_menu;


PROCEDURE SetOnHorMenu();
BEGIN
END SetOnHorMenu;


PROCEDURE HorMenu(  X1,Y1,X2,Y2:      INTEGER;
                    ForeText:         Color;
                    QuantFields:      INTEGER;
                    Frame:            BOOLEAN;
                    FrameType:        FrameStr;
                    ForeFr,BackFr:    Color;
                    Shadow:           BOOLEAN;
                    FieldsConteins:   ARRAY OF CHAR) : INTEGER;
VAR i: INTEGER;
BEGIN


RETURN i;
END HorMenu;
BEGIN
   wt_invr:= Open(wd_invr);
   wt_menu:= Open(wd_menu);
END MakeMenu.