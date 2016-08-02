IMPLEMENTATION MODULE Printer;
FROM Assa IMPORT Screen,Print_ready;


PROCEDURE PrinterMesage;
VAR
  wt_print:  WinType;
  wd_print:  WinDef;
BEGIN
 IF print_ready= 0 THEN  screen;
                   ELSE  wd_print:= WinDef(15,8,65,14,LightGreen,Blue,
                                           FALSE,FALSE,FALSE,TRUE,
                                           SingleFrame,LightMagenta,Blue);
                         wt_print:= Open(wd_print);
                         GotoXY(5,1);   IO.WrStr('Принтер не готов');


END Mesage;


END Printer.
