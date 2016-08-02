MODULE df ;
             IMPORT Lib,FIO,Str,IO ;
FROM Window  IMPORT Open,WinType,WinDef,Color,DoubleFrame,GotoXY,Close,
                   TextColor,TextBackground,PutOnTop,SetTitle,CenterUpperTitle ;
FROM _Window IMPORT Shadow ;
             IMPORT SYSTEM ;
VAR   Aaa,Bbb,Ccc    : WinType ; (* окно для выдачи предупреждения *)
      AA,BB,CC       : WinDef ;
      ot             : CHAR ;
      p              : BOOLEAN ;
      D              : FIO.DirEntry ;   (* для чтения имен файлов *)
      i,j            : CARDINAL ;
      kod            : SHORTCARD ;
      r              : SYSTEM.Registers ;
PROCEDURE del_file ;


VAR   chablon        : ARRAY [0..3] OF CHAR ;
      put            : ARRAY[0..63] OF CHAR ;
      put1           : ARRAY[0..70] OF CHAR ;

BEGIN
   BB:=WinDef(23,4,49,20,Black,Magenta,FALSE,TRUE,TRUE,FALSE,DoubleFrame,Yellow,Magenta) ;
   Bbb:=Open(BB) ;
   SetTitle(Bbb,' список удаленных файлов ',CenterUpperTitle) ;
   PutOnTop(Bbb) ;
   Shadow(Bbb) ;
   chablon:='*.*' ;
      Str.Concat(put,'d:\data\',chablon) ;
      (* чтение имен файлов и их удаление *)
      IF FIO.ReadFirstEntry(put,FIO.FileAttr{FIO.archive,
                        FIO.readonly},D) THEN
            Str.Concat(put1,'d:\data\',D.Name) ;
            IO.WrStr('       ') ;IO.WrStr(D.Name) ; IO.WrLn ;
            FIO.Erase(put1) ; (* убрать этот файл *)
      END ; (* IF *)
      LOOP
         IF FIO.ReadNextEntry(D) THEN
               Str.Concat(put1,'d:\data\',D.Name) ;
            IO.WrStr('       ') ;IO.WrStr(D.Name) ; IO.WrLn ;
               FIO.Erase(put1) ; (* убрать этот файл *)
            ELSE
               EXIT ;
         END ; (* IF *)
      END ; (* loop *)
   IO.WrStr(' ') ; IO.WrLn ;
   IO.WrStr('     Все файлы удалены   ') ;
   TextColor(Black) ;
   TextBackground(LightMagenta) ;
   IO.WrStr(' Для продолжения нажмите ') ;
   IO.WrStr('      любую клавишу      ') ;
   ot:=IO.RdCharDirect() ;
   Close(Bbb) ;
END del_file ;

BEGIN
(* заполнение фона экрана *)
   CC:=WinDef(0,0,79,24,LightBlue,Black,FALSE,TRUE,TRUE,FALSE,DoubleFrame,White,Red) ;
   AA:=WinDef(18,6,62,15,White,Red,FALSE,FALSE,FALSE,TRUE,DoubleFrame,White,Red) ;
   Ccc:=Open(CC) ;
   FOR i:=0 TO 24 DO
      FOR j:=0 TO 79 DO
         IO.WrChar('░') ;
      END ; (* FOR *)
   END ; (* FOR *)
   PutOnTop(Ccc) ;
   Aaa:=Open(AA) ;
   Shadow(Aaa) ;
   GotoXY(3,2) ;
   IO.WrStr('Сейчас будут удалены все файлы данных !') ;
   TextColor(Yellow) ;
   GotoXY(5,4) ;
   IO.WrStr('Подтвердите удаление или вернитесь') ;
   GotoXY(7,5) ;
   IO.WrStr('в систему для сохранения файлов') ;
   TextColor(Blue) ; TextBackground(Cyan) ;
   GotoXY(3,8) ;
   IO.WrStr('     Удаление     ') ;
   TextColor(Yellow) ; TextBackground(Red) ;
   GotoXY(24,8) ;
   IO.WrStr('    Сохранение    ') ;
   p:=TRUE ;
   LOOP
   ot:=IO.RdCharDirect() ;
      CASE ot OF (CHAR(75)),
                 (CHAR(77)) : (* перемещение курсора *)
                              IF p THEN
                                    p:=FALSE ;
                                    TextColor(Yellow) ; TextBackground(Red) ;
                                    GotoXY(3,8) ;
                                    IO.WrStr('     Удаление     ') ;
                                    TextColor(Blue) ; TextBackground(Cyan) ;
                                    GotoXY(24,8) ;
                                    IO.WrStr('    Сохранение    ') ;
                                 ELSE
                                    p:=TRUE ;
                                    TextColor(Blue) ; TextBackground(Cyan) ;
                                    GotoXY(3,8) ;
                                    IO.WrStr('     Удаление     ') ;
                                    TextColor(Yellow) ; TextBackground(Red) ;
                                    GotoXY(24,8) ;
                                    IO.WrStr('    Сохранение    ') ;
                              END ; (* IF *)
               | (CHAR(0DH)): (* выбор режима *)
                              IF p THEN (* удаление файлов *)
                                    kod:=101 ;
                                    del_file ;
                                 ELSE
                                     kod:=102 ;
                              END ; (* IF *)
                              EXIT ;
               | (CHAR(27)) : (* выход без удаления *)
                              kod:=103 ;
                              EXIT ;
      END ; (* CASE *)
   END ; (* LOOP *)
   Close(Ccc) ;
   Close(Aaa) ;
   Lib.SetReturnCode(kod) ;
END df.