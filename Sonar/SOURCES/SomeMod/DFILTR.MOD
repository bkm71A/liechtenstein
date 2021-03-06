IMPLEMENTATION MODULE DFiltr;
IMPORT BIGFFT,FIO,SwLib,Str;
CONST mus='MUSORF';
      tmp='MUSORT';
VAR bufs,bufd                 : ARRAY[1..4095] OF BYTE;
PROCEDURE filtration(bor1,bor2:REAL;
                     VAR sname,dname:ARRAY OF CHAR):LONGINT;

VAR c                     : SHORTCARD;
    a,b,max,min,mo        : REAL;        (*�㦥��� ���祭��   *)
    freq                  : REAL;        (*���� ����⨧�樨*)
    commence,mlog         : CARDINAL;    (*log 2 ����� ���ᨢ�  *)
    res,i,obr             : CARDINAL;
    rsize,n,o,o1,o2       : LONGCARD;    (*����� 䠩��,����� ���*)
    fs,fd,ft              : FIO.File;    (*䠩��:�室���,��室���*)
    dr                    : LONGINT;
BEGIN
(* 1  ������ 䠩� *)
  fs:=FIO.Open(sname);
  FIO.AssignBuffer(fs,bufs);
(* 2  ����� � �⨪�⪮�,����� ����� *)
  FIO.Seek(fs,22);
  res:=FIO.RdBin(fs,freq,4);
  res:=FIO.RdBin(fs,rsize,4);
  FIO.Seek(fs,32);
  res:=FIO.RdBin(fs,commence,2);
  FIO.Seek(fs,48);
  res:=FIO.RdBin(fs,obr,2);
  FIO.Close(fs);
(* 3 ������ �⮡ ����� ॠ����樨 �뫠 �⥯���� ������ *)
  SwLib.pow2(rsize,n,mlog);
(* 4  �஢�ઠ ���� �� ���� �� ���⪮� ��᪥  *)
  dr:=SwLib.DiskAvail(0); (* �᫮ ᢮������ ���� *)
  o:=n*16;
 IF LONGCARD(commence)>n*4 THEN o:=o+LONGCARD(commence);END;
  dr:=LONGINT(o)-dr;
  IF dr>0 THEN RETURN dr;END;
(* 5 �८�ࠧ������ ���� *)
  BIGFFT.Diskfft(rsize,commence,TRUE,sname);
  Str.Copy(dname,mus);
(* 6 ��२�������� � ������ FFT *)
(**)FIO.Rename('MUSOR0',dname);
  fd:=FIO.Open(dname);
  FIO.AssignBuffer(fd,bufd);
  ft:=FIO.Create(tmp);
  FIO.AssignBuffer(ft,bufs);
(* 7 �஢�ઠ �࠭�� �� ���४⭮��� � ��ॢ�� � ����� *)
    IF bor1<0.0 THEN bor1:=0.0;END;
    IF bor2<0.0 THEN bor2:=0.0;END;
    IF bor1>bor2 THEN bor2:=bor1;END;
    IF bor1>=freq/2.0 THEN o1:=(n DIV 2)-1;
                      ELSE o1:=LONGCARD(bor1*REAL(n-1)/freq);
                      END;
    IF bor2>=freq/2.0 THEN o2:=(n DIV 2)-1;
                      ELSE o2:=LONGCARD(bor2*REAL(n-1)/freq+0.5);
                      END;
(* 8 ��������� �� ��।����� �㭪�� *)
      FOR o:=0 TO n-1 DO
      res:=FIO.RdBin(fd,a,4);
      res:=FIO.RdBin(fd,b,4);
      IF (o1>o) OR ((o2<o)AND(n-1-o2>o)) OR (o>n-1-o1)
                      THEN  a:=0.0;
                            b:=0.0;
                      ELSE  b:=-b;
                      END;
      FIO.WrBin(ft,a,4);
      FIO.WrBin(ft,b,4);
      END;
  FIO.Close(fd);
  FIO.Close(ft);
  FIO.Erase(dname);
  Str.Copy(dname,tmp);
(* 9 ���⭮� FFT *)
  BIGFFT.Diskfft(n,CARDINAL(0),FALSE,dname);
(* 10  ��ନ�㥬 ��� ��室���� 䠩�� *)
  SwLib.nome('F','L','0',res,sname,dname);
  i:=0;
    WHILE FIO.Exists(dname) DO
    i:=i+1;
    dname[res+3]:=CHAR(i+30H);
    END;
(* 11 �����㥬 �⨪��� *)
  fs:=FIO.Open(sname);
  FIO.AssignBuffer(fs,bufs);
  fd:=FIO.Create(dname);
  FIO.AssignBuffer(fd,bufd);
    FOR i:=0 TO commence-1 DO
    res:=FIO.RdBin(fs,c,1);
    FIO.WrBin(fd,c,1);
    END;
  FIO.Close(fs);
(* 13 ������ १���⮢ *)
  fs:=FIO.Open('MUSOR0');
  FIO.AssignBuffer(fs,bufs);
  mo:=0.0;  min:=MAX(REAL);  max:=MIN(REAL);
      FOR o:=0 TO rsize-1 DO
      res:=FIO.RdBin(fs,a,4);
      res:=FIO.RdBin(fs,b,4);
      a:=a/REAL(n);
      FIO.WrBin(fd,a,4);
      mo:=mo+a;
      IF a>max THEN max:=a;END;
      IF a<min THEN min:=a;END;
      END;
(* 16 ������ � �⨪��� *)
  mo:=mo/REAL(rsize);
  FIO.Seek(fd,36);
  FIO.WrBin(fd,min,4);
  FIO.WrBin(fd,max,4);
  FIO.WrBin(fd,mo,4);
  obr:=CARDINAL(BITSET(obr)+BITSET(0020H));
  FIO.WrBin(fd,obr,2);
  FIO.WrBin(fd,bor1,4);
  FIO.WrBin(fd,bor2,4);
(* 17 �����⨥ 䠩�o� *)
  FIO.Close(fs);
  FIO.Erase('MUSOR0');
  FIO.Close(fd);
  RETURN 0;
END filtration;
BEGIN
END DFiltr.