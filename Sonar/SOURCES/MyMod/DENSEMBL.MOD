IMPLEMENTATION MODULE DEnsembl;
IMPORT FIO,FFT,SwLib;
CONST k4=4096;
VAR   re,im,ono          : ARRAY[0..k4-1] OF REAL;
VAR   bufs,bufd          : ARRAY[1..2048] OF BYTE;
PROCEDURE katok(kol:SHORTCARD;shift:CARDINAL;
                VAR sname,dname:ARRAY OF CHAR):LONGINT;
VAR c                  : SHORTCARD;
    mo,min,max,dw      : REAL;
    a,b                : REAL;        (*�㦥��� ���祭��   *)
    freq               : REAL;        (*���� ����⨧�樨*)
    mlog,commence,obr  : CARDINAL;    (*log 2 ����� ���ᨢ�  *)
    result,i,j,n       : CARDINAL;
    rsize,long,nl,o    : LONGCARD;(*����� ॠ����樨,����� ���*)
    fs,fd              : FIO.File;(*䠩��:�室���,��室��� *)
    dr                 : LONGINT;
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
(* 3 ������ �⮡ ����� ॠ����樨 �뫠 �⥯���� ������ *)
  long:=rsize-LONGCARD(shift)*LONGCARD(kol-1);
  SwLib.pow2(long,nl,mlog);
  IF nl#long THEN  mlog:=mlog-1;
                   nl:=nl>>1;
            END;
  IF nl>k4 THEN nl:=k4; mlog:=12;END;
(* 4  �஢�ઠ ���� �� ���� �� ���⪮� ��᪥,���뢠��� DOS 36H *)
  dr:=SwLib.DiskAvail(0); (* �᫮ ᢮������ ���� *)
  o:=LONGCARD(commence)+nl*2;
  dr:=LONGINT(o)-dr;
  IF dr>0 THEN FIO.Close(fs);RETURN dr;END;
(* 5  ��ନ�㥬 ��� ��室���� 䠩�� *)
  SwLib.nome('S','G','0',result,sname,dname);
  i:=0;
    WHILE FIO.Exists(dname) DO
    i:=i+1;
    dname[result+3]:=CHAR(i+30H);
    END;
(* 6 �����㥬 �⨪��� *)
  fd:=FIO.Create(dname);
  FIO.AssignBuffer(fd,bufd);
  FIO.Seek(fs,0);
    FOR i:=0 TO commence-1 DO
    result:=FIO.RdBin(fs,c,1);
    FIO.WrBin(fd,c,1);
    END;
(* 7 ���㫥��� ���ᨢ� १���⮢ *)
  n:=CARDINAL(nl);
    FOR i:=0 TO n-1 DO
    ono[i]:=0.0;
    END;
(* 8 ���᫥��� ᯥ��� � �㬬�஢���� १���⮢ *)
    FOR i:= 1 TO CARDINAL(kol) DO
    FIO.Seek(fs,LONGCARD(commence+shift*(i-1)));
    (* ��९���� ��१�� � ���ᨢ *)
      FOR j:=0 TO n-1 DO
      result:=FIO.RdBin(fs,a,4);
      re[j]:=a;
      im[j]:=0.0;
      END;
    (* �८�ࠧ������ ���� *)
    FFT.nfft(n,mlog,re,im);
    (* �㬬�஢���� *)
      FOR j:=0 TO n-1 DO
      ono[j]:=ono[j]+2.0*(re[j]*re[j]+im[j]*im[j])/REAL(n-1)/freq;
      END;
    END;
(* 9  ��।����� � ������ १���⮢ � 䠩� *)
  mo:=0.0;min:=MAX(REAL);max:=MIN(REAL);
  b:=REAL(kol);
    FOR i:=0 TO (n DIV 2)-1 DO
    a:=ono[i]/b;
    FIO.WrBin(fd,a,4);
    mo:=mo+a;
    IF a>max THEN max:=a;END;
    IF a<min THEN min:=a;END;
    END;
  mo:=mo/REAL(n DIV 2);
(* 10  ������ ������ � �⨪��� *)
  FIO.Seek(fd,26);
  FIO.WrBin(fd,n DIV 2,4);
  dw:=freq/REAL(n-1);
  FIO.Seek(fd,36);
  FIO.WrBin(fd,min,4);
  FIO.WrBin(fd,max,4);
  FIO.WrBin(fd,mo,4);
  obr:=CARDINAL(BITSET(obr)+BITSET(0400H));
  FIO.WrBin(fd,obr,2);
  FIO.Seek(fd,60);
  FIO.WrBin(fd,dw,4);
(* 11 �����⨥ 䠩�o� *)
  FIO.Close(fs);
  FIO.Close(fd);
  RETURN 0;
END katok;
BEGIN
END DEnsembl.