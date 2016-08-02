(* ----------- программа сложения и вычитания реализации -------------- *)
IMPLEMENTATION MODULE Addition;

IMPORT IO,FIO,Str;
FROM  _Window IMPORT Open_Shadow,Close_Shadow;
(*
FROM  Lib     IMPORT Sound,NoSound,Delay;
*)
FROM  Window  IMPORT WinType,WinDef,Open,Close,Color,PutOnTop,Hide,Change,
                     Clear,TextColor,TextBackground,Use,GotoXY,SingleFrame;
FROM Probr_lb IMPORT WaitingOn,WaitingOff;
FROM ServisVl IMPORT DiskFree;
FROM DigitCon IMPORT wt_out;
FROM Down_hlp IMPORT DownHelpAny,wt_downhlp;

(*
PROCEDURE Soundend();
 VAR i: CARDINAL;
BEGIN
 FOR i:= 1 TO 300 BY 10 DO
  Sound(i* 10);
  Delay(25+ 300 DIV i);
 END;
 NoSound;
END Soundend;
*)

PROCEDURE Addit(znak: BOOLEAN; file_name1,file_name2: ARRAY OF CHAR): INTEGER;

VAR
  buffer1:        ARRAY [0..4*512+FIO.BufferOverhead] OF BYTE;
  buffer2:        ARRAY [0..4*512+FIO.BufferOverhead] OF BYTE;
  bufferrez:      ARRAY [0..4*512+FIO.BufferOverhead] OF BYTE;
  file1:          FIO.File;
  file2:          FIO.File;
  filerez:        FIO.File;
  tmpr:           ARRAY [0..120] OF BYTE; (* ---- под етикетку ------ *)
  out_name:       ARRAY [0..12]  OF CHAR;
  slice1,slice2:  ARRAY [0..4]   OF CHAR;
  obj1,obj2:      ARRAY [0..3]   OF CHAR;
  answ:           CHAR;
  prom:           CARDINAL;
  x_coord:        CARDINAL;
  control_sh1:    CARDINAL;
  control,obr:    CARDINAL;
  size_etick:     CARDINAL;
  size:           LONGCARD;
  diskret:        LONGCARD;
  computer:       LONGCARD;
  digit1,digit2:  REAL;
  digitrez:       REAL;
  min,max,MO:     REAL;

CONST
(* ---------------- основное тело программы ----------------- *)
BEGIN
 FIO.IOcheck:= FALSE;
 MO:= 0.;
 max:= MIN(REAL);
 min:= MAX(REAL);
 x_coord:= 1;
(* ----- проверка по именам файлов номера режима - должны совпадать ----- *)
  Str.Slice(slice1,file_name1,1,2);
  Str.Slice(slice2,file_name2,1,2);
  control:= Str.Compare(slice1,slice2);
 IF control<> 0 THEN RETURN -9 END;
(* -------------------- начало работы с файлами ------------------------- *)
  file1:= FIO.Open(file_name1); FIO.AssignBuffer(file1,buffer1);
  file2:= FIO.Open(file_name2); FIO.AssignBuffer(file2,buffer2);
(* -------- проверка наличия свободного места на текущем диске ---------- *)
  size:= FIO.Size(file1);
  computer:= FIO.Size(file2);
 IF computer< size THEN size:= computer END;
  diskret:= DiskFree();
 IF diskret<= size THEN  RETURN INTEGER(diskret) END;
(* ------------ проверка прореживания - должно совпадать ---------------- *)
  FIO.Seek(file1,30);
  FIO.Seek(file2,30);
 IF FIO.RdCard(file1) <> FIO.RdCard(file2)
   THEN FIO.Close(file1);
        FIO.Close(file2);
        RETURN -8
 END; (* if *)
(* ------------ проверка двух байтов обработки - должны совпадать ------- *)
  FIO.Seek(file1,48);
  FIO.Seek(file2,48);
 IF FIO.RdCard(file1) <> FIO.RdCard(file2)
   THEN FIO.Close(file1);
        FIO.Close(file2);
        RETURN -7
 END; (* if *)
(* ------------ проверка частоты дискретизации - должно совпадать ------- *)
  FIO.Seek(file1,22);
  FIO.Seek(file2,22);
 IF FIO.RdReal(file1) <> FIO.RdReal(file2)
   THEN FIO.Close(file1);
        FIO.Close(file2);
        RETURN -10
 END; (* if *)
(* ------------ проверка обьекта - должно совпадать --------------------- *)
  FIO.Seek(file1,10); control:= FIO.RdBin(file1,obj1,4);
  FIO.Seek(file2,10); control:= FIO.RdBin(file2,obj2,4);
 IF Str.Compare(obj1,obj2)<> 0
   THEN FIO.Close(file1);
        FIO.Close(file2);
        RETURN -11
 END; (* if *)
(* -------------- создаем имя выходного файла --------------------------- *)
  Str.Copy(out_name,slice1);
  Str.Slice(slice1,file_name1,5,3);
  Str.Slice(slice2,file_name2,5,3);
  Str.Append(out_name,slice1);
  Str.Append(out_name,slice2);
 IF znak
    THEN  Str.Append(out_name,'.SLP')
    ELSE  Str.Append(out_name,'.SLM')
 END; (* if *)
(* ------------- создаем выходной файл с этикеткой ---------------------- *)
  filerez:= FIO.Create(out_name);
 IF filerez= MAX(CARDINAL)
  THEN FIO.Close(file1);
       FIO.Close(file2);
       RETURN -12
 END;
  FIO.AssignBuffer(filerez,bufferrez);
  FIO.Seek(file1,32);
  control:= FIO.RdBin(file1,size_etick,2); (* --- смещение начала данных ---- *)
  FIO.Seek(file1,0) ;
  control:= FIO.RdBin(file1,  tmpr,size_etick);
            FIO.WrBin(filerez,tmpr,size_etick);
(* --------------- подготавливаем данные для рисования ползунка ------------- *)
  size:= (size - LONGCARD(size_etick)) DIV 4; (* размер файла в штуках точек  *)
 IF size= 0 THEN RETURN -13 END;
  diskret:= size DIV 66; (* - кол -во точек приходящихся на один квадратик  - *)
  control_sh1:= WaitingOn();
  Use(wt_downhlp);
  GotoXY(0,1);  TextBackground(LightGray); TextColor(Black); IO.WrCharRep('░',66);
  GotoXY(71,1); TextBackground(Red);   TextColor(White); IO.WrStr(' %  ');
(* --------------------- начинаем считать --------------------------------- *)
  FIO.Seek(file1,LONGCARD(size_etick));
  FIO.Seek(file2,LONGCARD(size_etick)); (* - практически нужно только это - *)
  FIO.Seek(filerez,LONGCARD(size_etick));
  computer:= 0;
FOR prom:= 1 TO CARDINAL(size) DO
  control:= FIO.RdBin(file1,digit1,4);
  control:= FIO.RdBin(file2,digit2,4);
 IF znak
    THEN  digitrez:= digit1+ digit2
    ELSE  digitrez:= digit1- digit2
 END; (* if *)
  MO:= MO+ digitrez;
  IF max< digitrez THEN max:= digitrez END;
  IF min> digitrez THEN min:= digitrez END;
  FIO.WrBin(filerez,digitrez,4);
  INC(computer);
 IF (computer>= diskret) THEN
    Use(wt_downhlp);
    TextColor(Red);   GotoXY(x_coord,1); IO.WrChar('█');
    TextColor(White); GotoXY(66,1);
    IF x_coord<= 66
       THEN  IO.WrCard(CARDINAL(REAL(x_coord)/66.*100.),5);
             INC(x_coord);
    END; (* if *)
    computer:= 0;
        IF prom= CARDINAL(size) (* в маленьких файлах, когда точек меньше 66 *)
           THEN TextColor(Red);   GotoXY(0,1);  IO.WrCharRep('█',66);
                TextColor(White); GotoXY(66,1); IO.WrCard(100,5);
        END; (* if *)
 END; (* if *)
END; (* for *)
(* -- восстанавливаем цвета в окне подсказки ипользованном ползунком -- *)
  Use(wt_downhlp);
  TextColor(White);
  TextBackground(Brown);
(* ----------------- запись изменений в этикетку -------------------- *)
  FIO.Seek(filerez,36);
  FIO.WrBin(filerez,min,4);
  FIO.WrBin(filerez,max,4);
   MO:= MO / REAL(size);
  FIO.WrBin(filerez,MO,4);
  FIO.Close(file1);
  FIO.Close(file2);
  FIO.Close(filerez);
(* ------------------ возврат по нормальному завершению ------------- *)
  (* Soundend(); *)
  WaitingOff(control_sh1);
  DownHelpAny();
  Change(wt_out,15,9,65,11);
  control_sh1:= Open_Shadow(wt_out);
  PutOnTop(wt_out);  Clear();
  GotoXY(3,1);
  TextColor(White);        IO.WrStrAdj('Имя выходного файла',-32);
  TextColor(LightMagenta); IO.WrStr(out_name);
  answ:= IO.RdCharDirect();
  Close_Shadow(control_sh1);
  Hide(wt_out);
  RETURN 0;
END Addit;

END Addition.