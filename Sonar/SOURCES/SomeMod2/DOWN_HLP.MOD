IMPLEMENTATION MODULE Down_hlp;  (*   раздел подстрочных подсказок   *)

IMPORT IO;
FROM Window   IMPORT Open,Close,Use,TextColor,Clear,GotoXY,TextBackground;
FROM _Window  IMPORT Open_Shadow,Close_Shadow;
FROM SearchFl IMPORT FileInformArray;
FROM Probr_lb IMPORT contdisk_contr;


PROCEDURE SetOnDownhlp(): CARDINAL;
VAR
 shad_control: CARDINAL;
BEGIN
 wt_downhlp:= Open(wd_downhlp);
 shad_control:= Open_Shadow(wt_downhlp);
 RETURN shad_control
END SetOnDownhlp;

PROCEDURE SetOffDownhlp(shad_control: CARDINAL);
BEGIN
 Close(wt_downhlp);
 Close_Shadow(shad_control);
END SetOffDownhlp;

PROCEDURE DownHelp0();
BEGIN
    Use(wt_downhlp); Clear();
  TextColor(White);
    GotoXY(12,1);  IO.WrStr('[]');
    GotoXY(43,1); IO.WrStr('[Enter]');
  TextColor(Black);
    GotoXY(17,1); IO.WrStr('Перемещение курсора');
    GotoXY(51,1); IO.WrStr('Выбор режима');
END DownHelp0;

PROCEDURE DownHelp01();
BEGIN
    Use(wt_downhlp); Clear();
  TextColor(White);
    GotoXY(12,1);  IO.WrStr('[]');
    GotoXY(43,1);  IO.WrStr('[Enter]');
  TextColor(Black);
    GotoXY(17,1);  IO.WrStr('Перемещение курсора');
    GotoXY(51,1);  IO.WrStr('Выбор шаблона');
END DownHelp01;


PROCEDURE DownHelp011();
BEGIN
   Use(wt_downhlp);  Clear();
 TextColor(White);
   GotoXY(2,1);  IO.WrStr('[]');
   GotoXY(26,1); IO.WrStr('[Enter]');
   GotoXY(42,1); IO.WrStr('[Space]');
   GotoXY(61,1); IO.WrStr('[Esc]');
 TextColor(Black);
   GotoXY(9,1);  IO.WrStr('Просм.каталога');
   GotoXY(34,1); IO.WrStr('Выбор');
   GotoXY(50,1); IO.WrStr('Этикетка');
   GotoXY(67,1); IO.WrStr('Выход');
END DownHelp011;

PROCEDURE DownHelp012();
BEGIN
    Use(wt_downhlp); Clear();
  TextColor(White);
    GotoXY(12,1);  IO.WrStr('[]');
    GotoXY(43,1);  IO.WrStr('[Enter]');
  TextColor(Black);
    GotoXY(17,1);  IO.WrStr('Перемещение курсора');
    GotoXY(51,1);  IO.WrStr('Выбор диска');
END DownHelp012;


PROCEDURE DownHelp02();
BEGIN
  Use(wt_downhlp);  Clear();
 TextColor(White);
  GotoXY(2,1);  IO.WrStr('[I,i]');
  GotoXY(29,1); IO.WrStr('[D,d]');
  GotoXY(61,1); IO.WrStr('[Esc]');
 TextColor(Black);
  GotoXY(8,1);  IO.WrStr('Интегральный закон');
  GotoXY(35,1); IO.WrStr('Дифференциальный закон');
  GotoXY(67,1); IO.WrStr('Выход');
END DownHelp02;

PROCEDURE DownHelp03();
BEGIN
  Use(wt_downhlp);  Clear();
 TextColor(White);
  GotoXY(2,1);  IO.WrStr('[H,h]');
  GotoXY(27,1); IO.WrStr('[S,s]');
  GotoXY(63,1); IO.WrStr('[Esc]');
 TextColor(Black);
  GotoXY(8,1);  IO.WrStr('Проверка по Hi2');
  GotoXY(33,1); IO.WrStr('Проверка по Шарлье-Эджворту');
  GotoXY(69,1); IO.WrStr('Выход');
END DownHelp03;

PROCEDURE DownHelp031();
BEGIN
  Use(wt_downhlp);  Clear();
 TextColor(White);
  GotoXY(7,1);  IO.WrStr('[]');
  GotoXY(40,1); IO.WrStr('[Enter]');
 TextColor(Black);
  GotoXY(12,1);  IO.WrStr('Перемещение курсора');
  GotoXY(48,1); IO.WrStr('Выбор уровня значимости');
END DownHelp031;

PROCEDURE DownHelp04();
BEGIN
      Use(wt_downhlp);
      Clear();
      TextColor(White);
       GotoXY(7,1);  IO.WrStr('[]');
       GotoXY(40,1); IO.WrStr('[Enter]');
       TextColor(Black);
       GotoXY(14,1); IO.WrStr('Перемещение курсора 4');
       GotoXY(50,1); IO.WrStr('Выбор режима 4 ');
END DownHelp04;

PROCEDURE DownHelp120();
BEGIN
  Use(wt_downhlp);   Clear();
 TextColor(White);
   GotoXY(3,1);  IO.WrStr('[]');
   GotoXY(33,1); IO.WrStr('[Enter]');
   GotoXY(62,1); IO.WrStr('[Esc]');
 TextColor(Black);
   GotoXY(8,1);  IO.WrStr('Перемещение курсора');
   GotoXY(41,1); IO.WrStr('Выбор метода');
   GotoXY(68,1); IO.WrStr('Отказ');
END DownHelp120;

PROCEDURE DownHelp121();
BEGIN
 Use(wt_downhlp);   Clear();
 TextColor(White);
   GotoXY(25,1);  IO.WrStr('Введите указанные параметры');
END DownHelp121;

PROCEDURE DownHelp122();
BEGIN
     Use(wt_downhlp);
     Clear();
     TextColor(White);
       GotoXY(4,1);  IO.WrStr('[Enter]');
       GotoXY(31,1); IO.WrStr('[Spacebar]');
       GotoXY(60,1); IO.WrStr('[Esc]');

     TextColor(Black);
       GotoXY(12,1); IO.WrStr('Запуск фильтрации');
       GotoXY(42,1); IO.WrStr('Изменение границ');

       GotoXY(66,1); IO.WrStr('Отказ');
END DownHelp122;

PROCEDURE DownHelp124();
BEGIN
  Use(wt_downhlp);  Clear();
 TextColor(White);
  GotoXY(5,1);  IO.WrStr('[]');
  GotoXY(33,1); IO.WrStr('[Enter]');
 TextColor(Black);
  GotoXY(10,1); IO.WrStr('Перемещение курсора');
  GotoXY(41,1); IO.WrStr('Выбор доверительной вероятности');
END DownHelp124;

PROCEDURE DownHelp125();
BEGIN
     Use(wt_downhlp);
     Clear();
     TextColor(White);
       GotoXY(8,1);  IO.WrStr('[Enter]');
       GotoXY(39,1); IO.WrStr('[Spacebar]');
     TextColor(Black);
       GotoXY(16,1); IO.WrStr('Запуск сглаживания');
       GotoXY(50,1); IO.WrStr('Изменение параметров');
END DownHelp125;

PROCEDURE DownHelpAny();
BEGIN
 Use(wt_downhlp);   Clear();
 TextColor(White);
   GotoXY(18,1);  IO.WrStr('Для продолжения нажмите любую клавишу');
END DownHelpAny;

PROCEDURE DownHelp220_30();
BEGIN
  Use(wt_downhlp); Clear();
  TextColor(White);
    GotoXY(10,1);   IO.WrStr('[Enter]');
    GotoXY(55,1);   IO.WrStr('[Esc]');
  TextColor(Black);
    GotoXY(18,1);   IO.WrStr('Подтвержд. имени');
    GotoXY(61,1);   IO.WrStr('Измен. имени');
END DownHelp220_30;

PROCEDURE DownHelp221_31();
BEGIN
   Use(wt_downhlp);   Clear();
 TextColor(White);
   GotoXY(12,1);  IO.WrStr('[]');
   GotoXY(43,1); IO.WrStr('[Enter]');
 TextColor(Black);
   GotoXY(17,1); IO.WrStr('Перемещение курсора');
   GotoXY(51,1); IO.WrStr('Выбор порядка');
END DownHelp221_31;


END Down_hlp.