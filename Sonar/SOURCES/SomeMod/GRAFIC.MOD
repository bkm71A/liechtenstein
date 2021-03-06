MODULE grafic;
IMPORT IO,FIO,Graph,InOut,swhelp,assa;
CONST pbx=CARDINAL(20);           (* ��砫� ��䨪� �� X*)
      pex=620;                    (* ����� ��䨪� �� X*)
VAR np   : CARDINAL;              (* �᫮ �祪 �� ����� ��䨪�*)
    one,                          (* ᮢ��饭��� ��� one=1,����� one=0*)
    nc   : CARDINAL;              (* ������⢮ �������*)
    i,j,                          (* ���稪� 横���  *)
    w,x1,x2,                      (* �ਭ� ��䨪a � ��.*)
    step,                         (* 蠣 ����� �窠��*)
    cg,                           (* 梥� ��䨪� *)
    res,                          (* �ᯮ����⥫쭠� *)
    shift,                        (* ᤢ�� �� ��࠭� *)
    skip,                         (* ��०������    *)
    lev,                          (* �஢��� n - ��䨪�*)
    levz : CARDINAL;              (* ������� �஢���*)
    ch    : CHAR;                 (* ᨬ��� � ����������*)
    y1,y2  : INTEGER;             (* �뢮����� ���祭��*)
    bul,                          (* �ᯮ����⥫쭠� *)
    escape   : BOOLEAN;           (*��室 �� �ணࠬ��*)
    max,min  : REAL;
    fmax     : ARRAY[1..6] OF REAL;(* ���ᨬ�� �� ���祭��*)
    f        : ARRAY[1..6] OF FIO.File ;
    buf      : ARRAY[1..6] OF ARRAY[0..8191] OF BYTE;
    pif,                          (*position in a file*)
    mfs      : LONGCARD;          (*minimum of size file*)
(*    a        : ADDRESS;*)
    pix,pip  : REAL;
BEGIN
(* 0 ������� ��砫��� ���祭��*)
 one:=0;                          (*����� ��䨪��*)
 escape:=FALSE;
 pif:=20;                         (* ��稭��� �� � ��砫� 䠩��*)
 shift:=20;
 step:=1;
 skip:=1;
 mfs:=0FFFFFFFH;                  (* ����� ᠬ��� ���⪮�� 䠩� *)
(* 1 ���� ����� �������*)
 swhelp.vvod(nc,skip,shift,f);
(* 2 ����� � 䠩����*)
 FOR i:=1 TO CARDINAL(nc) DO
     FIO.AssignBuffer(f[i],buf[i]);
     IF mfs>FIO.Size(f[i]) THEN mfs:=FIO.Size(f[i]);END;
     FIO.Seek(f[i],36);
     res:=FIO.RdBin(f[i],min,4);
     res:=FIO.RdBin(f[i],max,4);
     fmax[i]:=ABS(min);
     IF ABS(max)>fmax[i] THEN fmax[i]:=ABS(max);END;
 END;
 mfs:=mfs-80;
(* 4 ���室 � ����᪨� ०�� *)
 Graph.InitEGA;
(* 4.1 ����� ��砫��� ���祭�� *)
 REPEAT
   Graph.EGAGraphMode;
   np:=(pex-pbx) DIV step+1;      (*�᫮ �祪 �� ����� ��䨪�*)
   (*�ਭ� ������ ��䨪�*)
   w:=(150 DIV CARDINAL(nc))*CARDINAL(1-one)+150*CARDINAL(one);
   lev:=w+2;                      (*�஢��� ��ࢮ�� ��䨪�*)
(* 4.2 ���㥬 ���⨪����� ���*)
   Graph.Line(pbx,CARDINAL(2),pbx,300,CARDINAL(10));
   Graph.Line(pbx,CARDINAL(2),pbx-CARDINAL(2),CARDINAL(7),CARDINAL(10));
   Graph.Line(pbx,CARDINAL(2),pbx+CARDINAL(2),CARDINAL(7),CARDINAL(10));
   FOR i:=1 TO nc DO              (*��㥬 nc ��䨪��*)
       levz:=lev*CARDINAL(1-one)+CARDINAL(151*one);
(*  4.3 ���㥬 ���� ��ਧ��⠫��� ��� *)
       Graph.HLine(pbx,levz,pex,CARDINAL(10));
       Graph.Line(pex-CARDINAL(5),levz-CARDINAL(2),pex,levz,CARDINAL(10));
       Graph.Line(pex-CARDINAL(5),levz+CARDINAL(2),pex,levz,CARDINAL(10));
(*  4.4 ���㥬 ���� ��䨪 *)
       cg:=CARDINAL(9)+i*CARDINAL(one);   (*梥� ��䨪�*)
       x1:=pbx;
       x2:=pbx+step;
       FIO.Seek(f[i],4*pif);
       res:=FIO.RdBin(f[i],pix,4);
       max:=fmax[i];              (*����⠡��㥬*)
       y1:=INTEGER(pix*REAL(w)/max);
       FOR j:=1 TO np-1 DO
           FIO.Seek(f[i],4*(pif+LONGCARD(j)*LONGCARD(skip)));
           res:=FIO.RdBin(f[i],pip,4);
                                  (*����⠡��㥬*)
           y2:=INTEGER(pip*REAL(w)/max);
           Graph.Line(x1,CARDINAL(INTEGER(levz)-y1),x2,CARDINAL(INTEGER(levz)-y2),cg);
           x1:=x2;
           x2:=x2+step;
           y1:=y2;
       END;
       lev:=lev+w*2+2;            (*�஢��� i-�� ��䨪�*)
   END;
(* 4.6 ���� ������ *)
   REPEAT
     bul:=TRUE;
     ch:=IO.RdCharDirect();
     CASE ORD(ch) OF
         (*F4*) |62     :one:=1-one;  (*��४���⥫� �᫠ ��䨪��*)
         (*F3*) |61     :IF assa.print_ready()=255 THEN assa.screen;
                            ELSE swhelp.help(2);END;
         (*esc*)|27     :escape:=TRUE;(*��室 �� �ணࠬ��*)
         (* ->*)|75     :IF pif>(mfs DIV 4)-LONGCARD(shift+(np-1)*skip)
                            THEN bul:=FALSE;         (*��५�� �����*)
                            ELSE pif:=pif+LONGCARD(shift);
                            END;
         (*<- *)|77     :(*��५�� ��ࠢ�*)
                         IF pif<=LONGCARD(20+shift) THEN bul:=FALSE;
                            ELSE pif:=pif-LONGCARD(shift);END;
         (*^*)  |72     :(*��५�� �����-���寧� �� �� Y*)
                         FOR i:=1 TO nc DO fmax[i]:=fmax[i]*0.8;END;
         (*\/*) |80     :(*��५�� ����-ᦠ⨥ �� �� Y*)
                         FOR i:=1 TO nc DO fmax[i]:=fmax[i]*1.2;END;
         (*R,r*)|82,114 :IF step<50 THEN step:=step+1;(*���寧� �� �� X*)
                            ELSE bul:=FALSE;END;
         (*S,s*)|83,115 :IF step>1 THEN step:=step-1;(*ᦠ⨥ �� �� X*)
                            ELSE bul:=FALSE;END;
         (*U,u*)|85,117 :skip:=skip+1;               (*०�*)
         (*L,l*)|76,108 :IF skip>1 THEN skip:=skip-1;(*���*)
                            ELSE bul:=FALSE;END;
         (*F1*) |59     :swhelp.help(1);bul:=TRUE;
         ELSE bul:=FALSE;
     END;
   UNTIL bul;
 UNTIL escape;
 Graph.EGATextMode;
(* 5 �����⨥ 䠩���*)
 FOR i:=1 TO CARDINAL(nc) DO
     FIO.Close(f[i]);
 END;
END grafic.

