IMPLEMENTATION MODULE DAuto;
IMPORT FIO,BIGFFT,SwLib,Str;
CONST mus='MUSORF';
      tmp='MUSORT';
      isx='MUSOR0';
VAR bufs,bufd                 : ARRAY[1..2048] OF BYTE;
PROCEDURE correl(VAR sname,dname:ARRAY OF CHAR):LONGINT;
VAR c                         : SHORTCARD;
    mo,min,max                : REAL;
    a,b,xr,xi                 : REAL;        (*�㦥��� ���祭��   *)
    freq                      : REAL;        (*���� ����⨧�樨*)
    y                         : LONGREAL;
    mlog,commence,obr         : CARDINAL;    (*log 2 ����� ���ᨢ�  *)
    result,ns,of,i,ji         : CARDINAL;
    rsize,n,o,o1,o2           : LONGCARD;(*����� ॠ����樨,����� ���*)
    mem                       : CARDINAL;(*����㯭�� ������ � ������*)
    fs,fd,ft                  : FIO.File;(*䠩��:�室���,��室���*)
    dr                        : LONGINT;

BEGIN
(* 1  ������ 䠩� *)
  fs:=FIO.Open(sname);
  FIO.AssignBuffer(fs,bufs);
(* 2  ����� � �⨪�⪮�,����� ����� *)
  FIO.Seek(fs,22);
  result:=FIO.RdBin(fs,freq,4);
  result:=FIO.RdBin(fs,rsize,4);
  FIO.Seek(fs,32);
  result:=FIO.RdBin(fs,commence,2);
  FIO.Seek(fs,48);
  result:=FIO.RdBin(fs,obr,2);
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
(* 6  ���᫥��� ᯥ��ࠫ쭮� ���⭮�� *)
  Str.Copy(dname,mus);
  (*  ��२�������� � ������ FFT *)
  FIO.Rename(isx,dname);
  fd:=FIO.Open(dname);
  FIO.AssignBuffer(fd,bufd);
  ft:=FIO.Create(tmp);
  FIO.AssignBuffer(ft,bufs);
      FOR o:=0 TO n-1 DO
      result:=FIO.RdBin(fd,a,4);
      result:=FIO.RdBin(fd,b,4);
      a:=(a*a+b*b)/REAL(n)/freq;
      b:=0.0;
      FIO.WrBin(ft,a,4);
      FIO.WrBin(ft,b,4);
      END;
  FIO.Close(fd);
  FIO.Close(ft);
  FIO.Erase(dname);
  Str.Copy(dname,tmp);
(* 7 ���⭮� FFT *)
  BIGFFT.Diskfft(n,CARDINAL(0),FALSE,dname);
(* 8  ��ନ�㥬 ��� ��室���� 䠩�� *)
  SwLib.nome('K','O','R',result,sname,dname);
(* 9 �����㥬 �⨪��� *)
  fd:=FIO.Create(dname);
  FIO.AssignBuffer(fd,bufd);
  fs:=FIO.Open(sname);
  FIO.AssignBuffer(fs,bufs);
    FOR i:=0 TO commence-1 DO
    result:=FIO.RdBin(fs,c,1);
    FIO.WrBin(fd,c,1);
    END;
  FIO.Close(fs);
(* 10  ���᫥��� �㭪樨 � ������ १���⮢ *)
    fs:=FIO.Open(isx);
    FIO.AssignBuffer(fs,bufs);
    mo:=0.0;min:=MAX(REAL);max:=MIN(REAL);
      FOR o:=0 TO (n DIV 2)-1 DO
      result:=FIO.RdBin(fs,xr,4);
      result:=FIO.RdBin(fs,xi,4);
      xr:=xr/REAL(n)*freq;
      mo:=mo+xr;
      IF xr>max THEN max:=xr;END;
      IF xr<min THEN min:=xr;END;
      FIO.WrBin(fd,xr,4);
      END;
 mo:=mo/REAL(n DIV 2);
 FIO.Erase(isx);
(* 10  ������ ������ � �⨪��� *)
 FIO.Seek(fd,26);
 FIO.WrBin(fd,n DIV 2,4);
 FIO.Seek(fd,36);
 FIO.WrBin(fd,min,4);
 FIO.WrBin(fd,max,4);
 FIO.WrBin(fd,mo,4);
 obr:=CARDINAL(BITSET(obr)+BITSET(0004H));
 FIO.WrBin(fd,obr,2);
(* 11 �����⨥ 䠩�o� *)
  FIO.Close(fd);
  RETURN 0;
END correl;

END DAuto.