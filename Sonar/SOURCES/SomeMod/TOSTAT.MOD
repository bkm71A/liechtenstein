MODULE ToStat;
IMPORT FIO,IO,SwLib;
VAR freq,min,max,mo,a : REAL;
    long,dr           : LONGCARD;
    i,res,commence    : CARDINAL;
    f1,f2,f3          : FIO.File;
    buf1,buf2,buf3    : ARRAY[1..2048] OF BYTE;
    s1,s2,s3          : ARRAY[0..30] OF CHAR;
BEGIN
IO.WrStr('�室��� 䠩� ');
IO.RdItem(s1);
f1:=FIO.Open(s1);
FIO.AssignBuffer(f1,buf1);
(*IO.WrStr('��室��� 䠩� ');
IO.RdItem(s2);*)
f2:=FIO.Create('Y');
FIO.AssignBuffer(f2,buf2);
(*IO.WrStr('��室��� 䠩� �� X     ');
IO.RdItem(s3);*)
f3:=FIO.Create('X');
FIO.AssignBuffer(f3,buf3);
IO.WrStr('��४���஢�� 䠩�� ��� ������ � ����� ');
FIO.Seek(f1,26);
res:=FIO.RdBin(f1,long,4);
FIO.Seek(f1,32);
res:=FIO.RdBin(f1,commence,2);
(* 4  �஢�ઠ ���� �� ���� �� ���⪮� ��᪥,���뢠��� DOS 36H *)
  dr:=SwLib.DiskAvail(0); (* �᫮ ᢮������ ���� *)
  IF long*13>dr THEN
                IO.WrStr('��� ���� �����筮 �� ��᪥ ');
                ELSE
FIO.Seek(f1,LONGCARD(commence));
  FOR i:=1 TO CARDINAL(long) DO
  res:=FIO.RdBin(f1,a,4);
  FIO.WrReal(f2,a,8,10);
  FIO.WrReal(f3,REAL(i),4,6);
  FIO.WrLn(f3);
  FIO.WrChar(f2,' ');
  FIO.WrLn(f2);
  END;
                END;
FIO.Close(f1);
FIO.Close(f2);
FIO.Close(f3);
END ToStat.