IMPLEMENTATION MODULE Spectr;
(* ����� � ������ﬨ RAM*)
IMPORT MATHLIB,FIO,Storage,SwLib;
CONST ln2=0.69314717;
      pi=3.1415926;
      k64=65536;
      k32=32768;
      k4=4096;
      k8=8192;
      k16=16384;
      nome1='musor1';
      nome2='musor2';
PROCEDURE s_pect(bet:SHORTCARD;VAR eps,c1,c2:REAL;
                 VAR sname,dname:ARRAY OF CHAR):LONGINT;
VAR adr                       : ADDRESS;
    c                         : SHORTCARD;
    mo,m2,m4,min,max,dw       : REAL;
    a,b,xr,xi                 : REAL;        (*�㦥��� ���祭��   *)
    y                         : LONGREAL;
    freq                      : REAL;        (*���� ����⨧�樨*)
    mlog,commence,obr,bo      : CARDINAL;    (*log 2 ����� ���ᨢ�  *)
    result,ns,of,i            : CARDINAL;
    sr,si                     : ARRAY[0..1] OF CARDINAL;(*ᥣ����� ������ *)
    rsize,long,n,o,o1,o2      : LONGCARD;(*����� ॠ����樨,����� ���,���稪�*)
    mem                       : CARDINAL;(*����㯭�� ������ � ������*)
    fs,fd,tf1,tf2             : FIO.File;(*䠩��:�室���,��室���,�஬������*)
    bufs,bufd,buf1,buf2       : ARRAY[1..2048] OF BYTE;
    p1,p2                     : POINTER TO REAL;
    dr                        : LONGINT;
    ZA                        : ARRAY[0..13] OF REAL;
PROCEDURE reszapis(fil1,fil2:FIO.File;dlina:LONGCARD);
(*������� ������ � 䠩�� � ����뢠�� �� *)
VAR op : LONGCARD;
BEGIN
FIO.AssignBuffer(fil1,buf1);
FIO.AssignBuffer(fil2,buf2);
    FOR op:=0 TO dlina-1 DO
    ns:=CARDINAL(o*4 DIV k64);
    of:=CARDINAL(o*4 MOD k64);
    p1:=[sr[ns]:of];
    p2:=[si[ns]:of];
    FIO.WrBin(fil1,p1^,4);
    FIO.WrBin(fil2,p2^,4);
    END;
FIO.Close(fil1);
FIO.Close(fil2);
END reszapis;
BEGIN
(* 0  ��ନ�㥬 ��� ��室���� 䠩�� *)
  SwLib.nome('S','P','L',result,sname,dname);
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
  long:=rsize;
(* 3 ������ �⮡ ����� ॠ����樨 �뫠 �⥯���� ������ *)
  SwLib.pow2(long,n,mlog);
(* 4  �஢�ઠ ���� �� ���� �� ���⪮� ��᪥,���뢠��� DOS 36H *)
  dr:=SwLib.DiskAvail(0); (* �᫮ ᢮������ ���� *)
  IF rsize>k32 THEN o:=8*k32;ELSE o:=LONGCARD(commence)+n*2;END;
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
(* �᫨ rsize>32K,� ࠧ���� �� ��� ��� *)
  IF rsize>k32 THEN n:=k32;END;
  mem:=Storage.HeapAvail(Storage.MainHeap);
  IF mem<CARDINAL(n DIV 2) THEN FIO.Close(fs);FIO.Close(fd);FIO.Erase(dname);
                                RETURN LONGINT(mem)-LONGINT(n DIV 2);
                                END;
  Storage.HeapAllocate(Storage.MainHeap,adr,mem);
  sr[0]:=CARDINAL(LONGCARD(adr)>>16);
  si[0]:=sr[0]+1000H;
  IF n<k16 THEN si[0]:=sr[0]+CARDINAL(n DIV 4);END;
  sr[1]:=sr[0]+2000H;
  si[1]:=si[0]+2000H;
(* 7 �८�ࠧ������ ���� *)
IF rsize>k32 THEN  (* 7.A ����塞 �� ���� *)
  o2:=(rsize-1) DIV 2;
   FOR i:=1 TO 2 DO
    FOR o:=0 TO o2 DO
    result:=FIO.RdBin(fs,b,4);
    ns:=CARDINAL(o DIV k16);
    of:=4*CARDINAL(o MOD k16);
    p1:=[sr[ns]:of];
    p1^:=b;
    result:=FIO.RdBin(fs,b,4);
    END;
   (* ������� ��ﬨ �� 32K *)
   IF o2+1<k32 THEN  FOR o:=o2+1 TO k32-1 DO
                     ns:=CARDINAL(o DIV k16);
                     of:=4*CARDINAL(o MOD k16);
                     p1:=[sr[ns]:of];
                     p1^:=0.0;
                     END;
                    END;
  (*������ ���� ࠢ�� ��� *)
    FOR o:=0 TO k32-1 DO
    ns:=CARDINAL(o DIV k16);
    of:=4*CARDINAL(o MOD k16);
    p2:=[si[ns]:of];
    p2^:=0.0;
    END;
   SwLib.fft(k32,15,sr,si);
   IF i=1 THEN (* ��� *)
          tf1:=FIO.Create(nome1);
          tf2:=FIO.Create(nome2);
          (* ��࠭��� ��� *)
          reszapis(tf1,tf2,k32);
          (*Seek ��⠭����� �� ���� ������� ॠ����樨 ,�.�. ��ன*)
          o1:=LONGCARD(commence)+4;
          FIO.Seek(fs,o1);
          o2:=(rsize DIV 2)-1;
          END;
   END;
(* 7.A.2 ᪫���� *)
  tf1:=FIO.Open(nome1);
  tf2:=FIO.Open(nome2);
  y:=pi/LONGREAL(k32);
    FOR o:=0 TO k32-1 DO
    result:=FIO.RdBin(tf1,a,4);
    result:=FIO.RdBin(tf2,b,4);
    ns:=CARDINAL(o DIV k16);
    of:=4*CARDINAL(o MOD k16);
    p1:=[sr[ns]:of];
    p2:=[si[ns]:of];
    xr:=a+p1^*REAL(MATHLIB.Cos(y*LONGREAL(o)))+p2^*REAL(MATHLIB.Sin(y*LONGREAL(o)));
    xi:=b-p1^*REAL(MATHLIB.Sin(y*LONGREAL(o)))+p2^*REAL(MATHLIB.Cos(y*LONGREAL(o)));
    p1^:=xr;
    p2^:=xi;
    END;
  FIO.Close(tf1);FIO.Erase(nome1);
  FIO.Close(tf2);FIO.Erase(nome2);
  n:=k64;
ELSE
 (* 7.B.1  ��९��뢠�� 䠩� � ������ RAM *)
    FOR o:=0 TO long-1 DO
    result:=FIO.RdBin(fs,b,4);
    ns:=CARDINAL(o DIV k16);
    of:=4*CARDINAL(o MOD k16);
    p1:=[sr[ns]:of];
    p1^:=b;
    END;
  IF n>long THEN     (* ������� 䠩� *)
     b:=0.0;
       FOR o:=long TO n-1 DO
       ns:=CARDINAL(o DIV k16);
       of:=4*CARDINAL(o MOD k16);
       p1:=[sr[ns]:of];
       p1^:=b;
       END;
     END;
    FOR o:=0 TO n-1 DO
    ns:=CARDINAL(o DIV k16);
    of:=4*CARDINAL(o MOD k16);
    p1:=[si[ns]:of];
    p1^:=0.0;
    END;
(* 7.B.2  �맮� ��楤��� *)
  SwLib.fft(n,mlog,sr,si);
END;
(* 8  ���᫥��� ᯥ��� � ������ १���⮢ *)
mo:=0.0;m2:=0.0;m4:=0.0;min:=MAX(REAL);max:=MIN(REAL);
    FOR o:=0 TO (n DIV 2)-1 DO
    ns:=CARDINAL(o*4 DIV k64);
    of:=CARDINAL(o*4 MOD k64);
    p1:=[sr[ns]:of];
    p2:=[si[ns]:of];
    p1^:=2.0*(p1^*p1^+p2^*p2^)/REAL(n-1)/freq;
    a:=REAL(o)*REAL(o);
    mo:=mo+p1^;
    m2:=m2+p1^*a;
    m4:=m4+p1^*a*a;
    IF p1^>max THEN max:=p1^;END;
    IF p1^<min THEN min:=p1^;END;
    FIO.WrBin(fd,p1^,4);
    END;
eps:=REAL(MATHLIB.Sqrt(LONGREAL(1.0-m2*m2/mo/m4)));
mo:=mo/REAL(n DIV 2);
(* 9 ���᫥��� �����⥫��� ���ࢠ��� *)
ZA[0]:=1.282;ZA[1]:=1.340;ZA[2]:=1.404;ZA[3]:=1.475;ZA[4]:=1.554;ZA[5]:=1.643;
ZA[6]:=1.750;ZA[7]:=1.880;ZA[8]:=1.960;ZA[9]:=2.053;ZA[10]:=2.170;ZA[11]:=2.325;
ZA[12]:=2.576;ZA[13]:=3.290;
IF bet>12 THEN bet:=13;END;
bo:=CARDINAL(bet);
c1:=(1.0-2.0/9.0/3.0+ZA[bo]*REAL(MATHLIB.Sqrt(LONGREAL(2.0/9.0/3.0))))*
    (1.0-2.0/9.0/3.0+ZA[bo]*REAL(MATHLIB.Sqrt(LONGREAL(2.0/9.0/3.0))))*
    (1.0-2.0/9.0/3.0+ZA[bo]*REAL(MATHLIB.Sqrt(LONGREAL(2.0/9.0/3.0))));
c1:=1.0/c1;
c2:=(1.0-2.0/9.0/3.0-ZA[bo]*REAL(MATHLIB.Sqrt(LONGREAL(2.0/9.0/3.0))))*
    (1.0-2.0/9.0/3.0-ZA[bo]*REAL(MATHLIB.Sqrt(LONGREAL(2.0/9.0/3.0))))*
    (1.0-2.0/9.0/3.0-ZA[bo]*REAL(MATHLIB.Sqrt(LONGREAL(2.0/9.0/3.0))));
 c2:=1.0/c2;
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
 obr:=CARDINAL(BITSET(obr)+BITSET(0080H));
 FIO.WrBin(fd,obr,2);
 FIO.Seek(fd,60);
 FIO.WrBin(fd,dw,4);
 FIO.Seek(fd,68);
 FIO.WrBin(fd,c1,4);
 FIO.WrBin(fd,c2,4);
 FIO.Seek(fd,80)   ; FIO.WrStr(fd,'Hz'); FIO.WrChar(fd,CHR(13));
                                         FIO.WrChar(fd,CHR(13));
(* 11 �����⨥ 䠩�o� *)
  FIO.Close(fs);
  FIO.Close(fd);
  RETURN 0;
END s_pect;

END Spectr.