IMPLEMENTATION MODULE _Int24; (* доработка над обработчиком ошибок INT24H *)

IMPORT SYSTEM,AsmLib,Str,IO;

(* -------------------------- My addition -------------------------- *)

FROM Lib      IMPORT  Dos;
FROM Window   IMPORT  WinDef,WinType,Open,Close,GotoXY,Use,Color,TextColor,
                      SingleFrame;
FROM _Window  IMPORT  Open_Shadow,Close_Shadow;
FROM Probr_lb IMPORT  Soundock;

(*
   The pop stack inline code is required if the program should
   continue after an abort (returning 255 to the calling program).
   If ContinueProg is set to FALSE then the program will terminate
   on 'abort' ;
*)

CONST
  ContinueProg = TRUE ;

TYPE
  Code = ARRAY[0..27] OF SHORTCARD ;
CONST
PopStackCode = Code(
 58H,             (* POP    AX    *)
 58H,             (* POP    AX    *)
 58H,             (* POP    AX    *)
 5BH,             (* POP    BX    *)
 89H,0C4H,        (* MOV    SP,AX *)
 9DH,             (* POPF         *)
 58H,             (* POP    AX    *)
 5BH,             (* POP    BX    *)
 59H,             (* POP    CX    *)
 5AH,             (* POP    DX    *)
 5EH,             (* POP    SI    *)
 5FH,             (* POP    DI    *)
 58H,             (* POP    AX    *)
 1FH,             (* POP    DS    *)
 07H,             (* POP    ES    *)
 89H,0E5H,        (* MOV    BP,SP *)
 80H,4EH,04H,01H, (* OR     Byte Ptr [BP+04],01 ; set carry *)
 89H,0C5H,        (* MOV    BP,AX *)
 0B8H,0FFH,00H,   (* MOV    AX,00FF *)  (* Return error *)
 0CFH) ;          (* IRET         *)

TYPE PopStackProc = PROCEDURE ( VAR CARDINAL ) ;

(*$C 00,N*) PROCEDURE (*$F*) ForceSave(p : CARDINAL) : CARDINAL; FORWARD; (*$C F0,F*)

(* NB! Has to be forward otherwise compiler will spot that
       registers are not being used
*)

(*$C FF,J+*)
PROCEDURE Int24Handler( Dummy : CARDINAL );

TYPE IntReg1 = RECORD
                 DI,SI,ES,DS : CARDINAL;
                 CASE : BOOLEAN OF
                   TRUE  : BX,DX,CX,AX : CARDINAL; |
                   FALSE : BL,BH,DL,DH,CL,CH,AL,AH : SHORTCARD;
                 END;
               END;
VAR
    RegP1 : POINTER TO IntReg1;
    PopStack : PopStackProc ;
    saveipf : BOOLEAN ;
    s : ARRAY[0..45] OF CHAR ;
    k : CHAR ;
(* ------------------------------ My addition ------------------------------ *)
VAR
    wt_error: WinType;
    wd_error: WinDef;
    shad:     CARDINAL;
    r:        SYSTEM.Registers;
BEGIN
     RegP1 := [SYSTEM.Seg( Dummy ):ForceSave(0)+2]; (* must be first in procedure *)
     saveipf := AsmLib.GetInProgramFlag() ;
     AsmLib.SetInProgramFlag( TRUE );
     WITH RegP1^ DO
(* ------------------------------ My addition ------------------------------ *)
      r.AH:= 59H;
      r.BX:= 0H;
      Dos(r);
      CASE CARDINAL(r.AX) OF
                 1: s := 'Неверный номер функции'
                |2: s := 'Файл не найден'
                |3: s := 'Путь не найден'
                |4: s := 'Слишком много открытых файлов'
                |5: s := 'Доступ отвергнут'
                |6: s := 'Неверный описатель'
                |7: s := 'Разрушены блоки управления памятью'
                |8: s := 'Недостаточно памяти'
                |9: s := 'Неверный адрес блока памяти'
               |10: s := 'Неверное окружение'
               |11: s := 'Неверный формат'
               |12: s := 'Неверный код доступа'
               |13: s := 'Неверная дата'
               |14: s := '?????????????'
               |15: s := 'Задан неверный диск'
               |16: s := 'Нельзя удалить тек оглавление'
               |17: s := 'Не то же самое устройство'
               |18: s := 'Больше нет искомых файлов'
               |19: s := 'Попытка записи на защищенный диск'
               |20: s := 'Неизвестный ID субустройства'
               |21: s := 'Дисковод не готов'
               |22: s := 'Неизвестная команда'
               |23: s := 'Ошибка данных диска (ошибка CRC)'
               |24: s := 'Неверная длинна структуры запроса'
               |25: s := 'Ошибка поиска на диске'
               |26: s := 'Неизвестный тип носителя диска'
               |27: s := 'Сектор не найден'
               |28: s := 'Конец бумаги на принтере'
               |29: s := 'Ошибка записи'
               |30: s := 'Ошибка чтения'
               |31: s := 'Общая ошибка'
               |32: s := 'Нарушение разделения файлов'
               |33: s := 'Нарушение блокировки файла'
               |34: s := 'Неверная замена диска'
               |35: s := 'FCB недоступен (слишком много открытых FCB)'
               |80: s := 'Файл уже существует'
      END; (* case *)
         wd_error:= WinDef(15,8,65,14,White,Red,FALSE,FALSE,FALSE,TRUE,SingleFrame,White,Red);
         wt_error:= Open(wd_error);
         shad:= Open_Shadow(wt_error);
         Use(wt_error);
           GotoXY(25 - Str.Length(s) DIV 2,3);  IO.WrStr(s);
           GotoXY(2,5);  IO.WrStr('[A]');
           GotoXY(17,5); IO.WrStr('[R]');
           GotoXY(33,5); IO.WrStr('[I]');
         TextColor(Yellow);
           GotoXY(20,1); IO.WrStr('О Ш И Б К А !');
         TextColor(Black);
           GotoXY(6,5);  IO.WrStr('Отменить');
           GotoXY(21,5); IO.WrStr('Повторить');
           GotoXY(37,5); IO.WrStr('Игнорировать');
         Soundock();

        REPEAT
          k := CAP(IO.RdKey()) ;
        UNTIL (k='R') OR (k='I') OR (k='A');

(* ------------------------------ My addition ------------------------------ *)
        Close(wt_error);
        Close_Shadow(shad);

        IF k='I'    THEN AL := 0 ;  (* ignore *)
        ELSIF k='R' THEN AL := 1 ;  (* retry  *)
        ELSE                        (* abort  *)
           IF ContinueProg THEN
             PopStack := PopStackProc(ADR(PopStackCode)) ;
             PopStack(Dummy);
             (* Remove MSDOS call frame and Return 255 to caller *)
             (* Does not return here *)
           ELSE
             HALT ;
           END ;
        END ;
     END;
     AsmLib.SetInProgramFlag( saveipf ); (* returning to DOS *)
END Int24Handler;
(*$C F0,J-*)

PROCEDURE ForceSave( p : CARDINAL): CARDINAL;
BEGIN
  RETURN SYSTEM.Ofs( p );
END ForceSave;

VAR
  Int24Vec[0:24H*4]   : PROCEDURE ( CARDINAL ) ;

BEGIN
  SYSTEM.DI ;
  (* Install interrupt 24 *)
  Int24Vec := Int24Handler ;
  SYSTEM.EI ;
END _Int24.
