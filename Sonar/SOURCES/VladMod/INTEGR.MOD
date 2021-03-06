IMPLEMENTATION MODULE Integr;
(* ��⥣�஢���� ����� *)
IMPORT FIO,Str,SwLib;
VAR aa[0B800H:0]     : CARDINAL;
PROCEDURE integral(c:CHAR;ord:CARDINAL;VAR sname,dname:ARRAY OF CHAR):LONGINT;
(*��।��� � - ����㠫�� ���,ord-���冷� ��⥣�஢����,sname-��� 䠩��*)
(* �����頥�: 0 - �ᯥ譮� �����襭�� ,�᫮>0-���� ���� �� ⥪�饬 ���⪮�
��᪥,��� ����㠫쭮� ��᪥,�� 墠⠥� <�᫮> ���� *)
VAR xi,xi1,y0,re64             : REAL;
    del,y1,mo,min,max,mt       : REAL;
    sfile,dfile,fs,fd          : FIO.File;(*����� s-��室��,d-䠩� १����*)
    sbuf,dbuf,buf              : ARRAY[1..1024] OF BYTE;
    tname                      : ARRAY[0..11] OF CHAR;(*����� 䠩���*)
    long,i                     : LONGCARD;(*�᫮ ����⮢*)
    sizef                      : LONGCARD;(* ࠧ��� 䠩�� *)
    res,commence,obr,j,p       : CARDINAL;
    t                          : LONGINT;
    b,vdisk                    : SHORTCARD;
 PROCEDURE int1();
(* ��⥣�஢���� 1 �⥯��� *)
 BEGIN
          y0:=0.0;
          mt:=0.0;
          max:=0.0;
          min:=0.0;
          FIO.WrBin(fd,y0,4);
          res:=FIO.RdBin(fs,xi,4);
            FOR i:=1 TO long-1 DO
            res:=FIO.RdBin(fs,xi1,4);
            y1:=y0+(xi+xi1-2.0*mo)*del;
            IF y1>max THEN max:=y1;END;
            IF y1<min THEN min:=y1;END;
            mt:=mt+y1;
            FIO.WrBin(fd,y1,4);
            y0:=y1;
            xi:=xi1;
            p:=CARDINAL(REAL(i)*re64/REAL(long-1));
            IF (i=long-1) AND (aa>33) THEN aa:=64;END;
            IF p>aa THEN aa:=aa+1;END;
            END;
          mt:=mt/REAL(long);
 END int1;
BEGIN
(* 0 ���뢠�� �室��� 䠩�*)
 sfile:=FIO.Open(sname);
 sizef:=FIO.Size(sfile);
(* 1  �஢���� ���� �� ���� �� ��᪥ *)
 t:=SwLib.DiskAvail(0); (* �᫮ ᢮������ ���� *)
 t:=LONGINT(sizef)-t;
 IF t>=0 THEN FIO.Close(sfile);RETURN t;END;
 vdisk:=SHORTCARD(CARDINAL(CAP(c))-40H);
 t:=SwLib.DiskAvail(vdisk); (* �᫮ ᢮������ ���� �� vdisk*)
 t:=LONGINT(sizef-30)-t;
 IF t>=0 THEN FIO.Close(sfile);RETURN t;END;
(* 2 ��ନ�㥬 ��� ��室���� 䠩�� *)
 Str.Item(dname,sname,Str.CHARSET{'.'},0);
 res:=Str.Length(dname);
 dname[res]:='.';
 IF ((sname[res+1]='I') OR (sname[res+1]='N')) AND
    ((sname[res+2]='i') OR (sname[res+2]='n'))
    THEN dname[res+3]:=CHAR(CARDINAL(sname[res+3])+ord);
    ELSE dname[res+3]:=CHAR(ord+30H);
    END;
 dname[res+1]:='I';
 dname[res+2]:='N';
 dname[res+4]:=CHAR(0);
(* 3 ������� ��室��� 䠩� *)
 dfile:=FIO.Create(dname);
 FIO.AssignBuffer(sfile,sbuf);
 FIO.AssignBuffer(dfile,dbuf);
(* 4 ��⠥� ����� �� �⨪�⪨ *)
 FIO.Seek(sfile,22);
 res:=FIO.RdBin(sfile,del,4); (* ���� ����⨧�樨 *)
 del:=0.5/del;
 res:=FIO.RdBin(sfile,long,4);    (* ����� ॠ����樨  *)
 FIO.Seek(sfile,32);
 res:=FIO.RdBin(sfile,commence,2);(* ��砫� ������     *)
 FIO.Seek(sfile,44);
 res:=FIO.RdBin(sfile,mo,4);      (* ��⮦������       *)
 res:=FIO.RdBin(sfile,obr,2);     (* ���� ��ࠡ�⪨    *)
(* 5 �����㥬 �⨪��� *)
 FIO.Seek(sfile,0);
 FOR j:=1 TO commence DO          (* commence ���� �����㥬 *)
      res:=FIO.RdBin(sfile,b,1);
      FIO.WrBin(dfile,b,1);
 END;
(* 6 �맮� ��楤��*)
 CASE ord OF
      |1  : re64:=64.0;
            fs:=sfile;
            fd:=dfile;
            int1();
      |2  : re64:=32.0;
            aa:=32;
            tname:='a:musor';
            tname[0]:=c;
            fs:=sfile;
            fd:=FIO.Create(tname);
            FIO.AssignBuffer(fd,buf);
            int1();
            fs:=fd;
            fd:=dfile;
            FIO.Seek(fs,LONGCARD(0));
            mo:=mt;
            int1();               (* �� ࠧ ���� �ந�������*)
            FIO.Erase(tname);
 END;
 FIO.Close(sfile);
(* 7 ������ � �⨪��� *)
 FIO.Seek(dfile,36);
 FIO.WrBin(dfile,min,4);
 FIO.WrBin(dfile,max,4);
 FIO.WrBin(dfile,mt,4);
 obr:=CARDINAL(BITSET(obr)+BITSET(0010H));
 FIO.WrBin(dfile,obr,2);
 FIO.Close(dfile);
RETURN 0;
END integral;

END Integr.