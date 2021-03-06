IMPLEMENTATION MODULE Ensemble;
(* ����� � ������ﬨ RAM*)
IMPORT FIO,Storage,SwLib;
CONST k64=65536;
      k16=16384;
PROCEDURE katok(kol:SHORTCARD;shift:CARDINAL;
                VAR sname,dname:ARRAY OF CHAR):LONGINT;
VAR adr                       : ADDRESS;
    c                         : SHORTCARD;
    mo,min,max,dw             : REAL;
    a,b                       : REAL;        (*�㦥��� ���祭��   *)
    freq                      : REAL;        (*���� ����⨧�樨*)
    mlog,commence,obr         : CARDINAL;    (*log 2 ����� ���ᨢ�  *)
    result,ns,of,i            : CARDINAL;
    sr,si                     : ARRAY[0..1] OF CARDINAL;(*ᥣ����� ������ *)
    rsize,long,n,o,o1,o2      : LONGCARD;(*����� ॠ����樨,����� ���,���稪�*)
    mem                       : CARDINAL;(*����㯭�� ������ � ������*)
    fs,fd                     : FIO.File;(*䠩��:�室���,��室��� *)
    bufs,bufd                 : ARRAY[1..2048] OF BYTE;
    p1,p2                     : POINTER TO REAL;
    dr                        : LONGINT;
BEGIN
(* 0  ��ନ�㥬 ��� ��室���� 䠩�� *)
  SwLib.nome('S','G','0',result,sname,dname);
  i:=0;
    WHILE FIO.Exists(dname) DO
    i:=i+1;
    dname[result+3]:=CHAR(i+30H);
    END;
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
  SwLib.pow2(long,n,mlog);
  mlog:=mlog-1;
  n:=n>>1;
  IF n>k16 THEN n:=k16;END;
(* 4  �஢�ઠ ���� �� ���� �� ���⪮� ��᪥,���뢠��� DOS 36H *)
  dr:=SwLib.DiskAvail(0); (* �᫮ ᢮������ ���� *)
  o:=LONGCARD(commence)+n*2;
  dr:=LONGINT(o)-dr;
  IF dr>0 THEN FIO.Close(fs);RETURN dr;END;
(* 5 �����㥬 �⨪��� *)
  fd:=FIO.Create(dname);
  FIO.AssignBuffer(fd,bufd);
  FIO.Seek(fs,0);
    FOR i:=0 TO commence-1 DO
    result:=FIO.RdBin(fs,c,1);
    FIO.WrBin(fd,c,1);
    END;
(* 6  ���।������ �����   *)
(* ������� ��� ��� *)
  mem:=Storage.HeapAvail(Storage.MainHeap);
  IF mem<CARDINAL(REAL(n)*0.626) THEN FIO.Close(fs);FIO.Close(fd);FIO.Erase(dname);
                                 RETURN LONGINT(mem)-LONGINT(REAL(n)*0.626);
                                 END;
  Storage.HeapAllocate(Storage.MainHeap,adr,mem);
  sr[0]:=CARDINAL(LONGCARD(adr)>>16);
  si[0]:=sr[0]+1000H;
  IF n<k16 THEN si[0]:=sr[0]+CARDINAL(n DIV 4);END;
  sr[1]:=sr[0]+CARDINAL(n DIV 2)+1;
(* ����塞 �㬬� *)
    FOR o:=0 TO (n DIV 2)-1 DO
    of:=CARDINAL(o*4 MOD k64);
    p1:=[sr[1]:of];
    p1^:=0.0;
    END;
(* ���樨 �㬬��㥬 *)
FOR c:=1 TO kol DO
(* 7 �८�ࠧ������ ���� *)
 (* 7.1  ��९��뢠�� ��१�� � ������ RAM *)
  o:=LONGCARD(commence)+4*LONGCARD(c-1)*LONGCARD(shift);
  FIO.Seek(fs,o);
    FOR o:=0 TO n-1 DO
    result:=FIO.RdBin(fs,b,4);
    ns:=0;
    of:=4*CARDINAL(o MOD k16);
    p1:=[sr[ns]:of];
    p2:=[si[ns]:of];
    p2^:=0.0;
    p1^:=b;
    END;
(* 7.2  �맮� ��楤��� *)
  SwLib.fft(n,mlog,sr,si);
(* 8  ���᫥��� ᯥ��� � ������ १���⮢ � ������ *)
    FOR o:=0 TO (n DIV 2)-1 DO
    of:=CARDINAL(o*4 MOD k64);
    p1:=[sr[0]:of];
    p2:=[si[0]:of];
    p1^:=2.0*(p1^*p1^+p2^*p2^)/REAL(n-1)/freq;
    p2:=[sr[1]:of];
    p2^:=p2^+p1^;
    END;
END;
(* 9  ��।����� � ������ १���⮢ � 䠩� *)
mo:=0.0;min:=MAX(REAL);max:=MIN(REAL);
b:=REAL(kol);
    FOR o:=0 TO (n DIV 2)-1 DO
    of:=CARDINAL(o*4 MOD k64);
    p1:=[sr[1]:of];
    a:=p1^/b;
    FIO.WrBin(fd,a,4);
    mo:=mo+a;
    IF a>max THEN max:=a;END;
    IF a<min THEN min:=a;END;
    END;
mo:=mo/REAL(n DIV 2);
(* 10  �����⨥ �����⥩ �����*)
  Storage.HeapDeallocate(Storage.MainHeap,adr,mem);
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
 FIO.Seek(fd,80) ; FIO.WrStr(fd,'Hz'); FIO.WrChar(fd,CHR(13));
                                       FIO.WrChar(fd,CHR(13));
(* 11 �����⨥ 䠩�o� *)
  FIO.Close(fs);
  FIO.Close(fd);
  RETURN 0;
END katok;

END Ensemble.