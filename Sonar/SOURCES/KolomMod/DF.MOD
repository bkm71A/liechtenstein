MODULE df ;
             IMPORT Lib,FIO,Str,IO ;
FROM Window  IMPORT Open,WinType,WinDef,Color,DoubleFrame,GotoXY,Close,
                   TextColor,TextBackground,PutOnTop,SetTitle,CenterUpperTitle ;
FROM _Window IMPORT Shadow ;
             IMPORT SYSTEM ;
VAR   Aaa,Bbb,Ccc    : WinType ; (* ���� ��� �뤠� �।�०����� *)
      AA,BB,CC       : WinDef ;
      ot             : CHAR ;
      p              : BOOLEAN ;
      D              : FIO.DirEntry ;   (* ��� �⥭�� ���� 䠩��� *)
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
   SetTitle(Bbb,' ᯨ᮪ 㤠������ 䠩��� ',CenterUpperTitle) ;
   PutOnTop(Bbb) ;
   Shadow(Bbb) ;
   chablon:='*.*' ;
      Str.Concat(put,'d:\data\',chablon) ;
      (* �⥭�� ���� 䠩��� � �� 㤠����� *)
      IF FIO.ReadFirstEntry(put,FIO.FileAttr{FIO.archive,
                        FIO.readonly},D) THEN
            Str.Concat(put1,'d:\data\',D.Name) ;
            IO.WrStr('       ') ;IO.WrStr(D.Name) ; IO.WrLn ;
            FIO.Erase(put1) ; (* ���� ��� 䠩� *)
      END ; (* IF *)
      LOOP
         IF FIO.ReadNextEntry(D) THEN
               Str.Concat(put1,'d:\data\',D.Name) ;
            IO.WrStr('       ') ;IO.WrStr(D.Name) ; IO.WrLn ;
               FIO.Erase(put1) ; (* ���� ��� 䠩� *)
            ELSE
               EXIT ;
         END ; (* IF *)
      END ; (* loop *)
   IO.WrStr(' ') ; IO.WrLn ;
   IO.WrStr('     �� 䠩�� 㤠����   ') ;
   TextColor(Black) ;
   TextBackground(LightMagenta) ;
   IO.WrStr(' ��� �த������� ������ ') ;
   IO.WrStr('      ���� �������      ') ;
   ot:=IO.RdCharDirect() ;
   Close(Bbb) ;
END del_file ;

BEGIN
(* ���������� 䮭� ��࠭� *)
   CC:=WinDef(0,0,79,24,LightBlue,Black,FALSE,TRUE,TRUE,FALSE,DoubleFrame,White,Red) ;
   AA:=WinDef(18,6,62,15,White,Red,FALSE,FALSE,FALSE,TRUE,DoubleFrame,White,Red) ;
   Ccc:=Open(CC) ;
   FOR i:=0 TO 24 DO
      FOR j:=0 TO 79 DO
         IO.WrChar('�') ;
      END ; (* FOR *)
   END ; (* FOR *)
   PutOnTop(Ccc) ;
   Aaa:=Open(AA) ;
   Shadow(Aaa) ;
   GotoXY(3,2) ;
   IO.WrStr('����� ���� 㤠���� �� 䠩�� ������ !') ;
   TextColor(Yellow) ;
   GotoXY(5,4) ;
   IO.WrStr('���⢥न� 㤠����� ��� ��୨���') ;
   GotoXY(7,5) ;
   IO.WrStr('� ��⥬� ��� ��࠭���� 䠩���') ;
   TextColor(Blue) ; TextBackground(Cyan) ;
   GotoXY(3,8) ;
   IO.WrStr('     ��������     ') ;
   TextColor(Yellow) ; TextBackground(Red) ;
   GotoXY(24,8) ;
   IO.WrStr('    ���࠭����    ') ;
   p:=TRUE ;
   LOOP
   ot:=IO.RdCharDirect() ;
      CASE ot OF (CHAR(75)),
                 (CHAR(77)) : (* ��६�饭�� ����� *)
                              IF p THEN
                                    p:=FALSE ;
                                    TextColor(Yellow) ; TextBackground(Red) ;
                                    GotoXY(3,8) ;
                                    IO.WrStr('     ��������     ') ;
                                    TextColor(Blue) ; TextBackground(Cyan) ;
                                    GotoXY(24,8) ;
                                    IO.WrStr('    ���࠭����    ') ;
                                 ELSE
                                    p:=TRUE ;
                                    TextColor(Blue) ; TextBackground(Cyan) ;
                                    GotoXY(3,8) ;
                                    IO.WrStr('     ��������     ') ;
                                    TextColor(Yellow) ; TextBackground(Red) ;
                                    GotoXY(24,8) ;
                                    IO.WrStr('    ���࠭����    ') ;
                              END ; (* IF *)
               | (CHAR(0DH)): (* �롮� ०��� *)
                              IF p THEN (* 㤠����� 䠩��� *)
                                    kod:=101 ;
                                    del_file ;
                                 ELSE
                                     kod:=102 ;
                              END ; (* IF *)
                              EXIT ;
               | (CHAR(27)) : (* ��室 ��� 㤠����� *)
                              kod:=103 ;
                              EXIT ;
      END ; (* CASE *)
   END ; (* LOOP *)
   Close(Ccc) ;
   Close(Aaa) ;
   Lib.SetReturnCode(kod) ;
END df.