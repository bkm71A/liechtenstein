echo off
:menu
  Echo [1;37;44m
  cls
  FOR %%F IN (1,2,3,4,5,6,7,8) DO Echo [?7l░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
  FOR %%F IN (1,2,3,4,5,6,7,8) DO Echo [?7l░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
  FOR %%F IN (1,2,3,4,5,6,7,8) DO Echo [?7l░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
  Echo [1;37;44m[25;01f░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░[0;36;46m
  Echo [1;34;46m[01;01f┌────────────────────────────────────────────────────────────────────────────────────┐[37;44m[01;70f
  Echo [1;34;46m[02;01f│ Автоматизированная информационная система обработки экспериментальных данных │[37;44m[02;70f
  Echo [1;34;46m[03;01f└────────────────────────────────────────────────────────────────────────────────────┘[37;44m[03;70f
  Echo [1;33;44m[10;17f╔══════════════════════════════════════════════╗
  Echo [1;33;44m[11;17f║            АВТОНОМНАЯ РАБОТА РМЭ             ║
  Echo [1;33;44m[12;17f╠══════════════════════════════════════════════╣
  Echo [1;33;44m[13;17f║                                              ║
  Echo [1;37;44m[13;18f 1 - Работа со спектроанализатором типа 2034
  Echo [1;33;44m[14;17f║                                              ║
  Echo [1;37;44m[14;18f 2 - Система ввода данных с АЦП
  Echo [1;33;44m[15;17f║                                              ║
  Echo [1;37;44m[15;18f 3 - Система ввода и предварительной обработки
  Echo [1;33;44m[16;17f║                                              ║
  Echo [1;37;44m[16;18f 4 - Система полной обработки (К А Р М Э)
  Echo [1;33;44m[17;17f║                                              ║
  Echo [1;37;44m[17;18f D - Выход в DOS
  Echo [1;33;44m[18;17f║                                              ║
  Echo [1;37;44m[18;18f Q - Конец работы
  Echo [1;33;44m[19;17f╚══════════════════════════════════════════════╝
  Echo [1;36;46m[24;01f
  Klawizs 1 2 3 4 D Q
  If ErrorLevel 6 Goto Lab6
  If ErrorLevel 5 Goto Lab5
  If ErrorLevel 4 Goto Lab4
  If ErrorLevel 3 Goto Lab3
  If ErrorLevel 2 Goto Lab2
  If ErrorLevel 1 Goto Lab1
:Lab1
  Echo [0;30;40m
  c:\release
  c:\mouse\agmouse.com
  d:
  cd sa2034
  d:\sa2034\sa2034.exe
  cd..
  c:
  c:\release /a
  Echo [0;37;40m
  goto menu
:Lab2
  Echo [0;30;40m
  c:\prg\nii_viln
  Echo [0;37;40m
  goto menu
:Lab3
  Echo [0;30;40m
  c:\release
  c:\mouse\agmouse
  c:\prg\mainproc
  c:\release /A
  Echo [0;37;40m
  goto menu
:Lab4
  c:
  cd c:\full
  mr karme
  cd ..
 cd prg
  goto menu
:Lab5
 @echo off
  Echo [30;40m
  cls
 c:\prg\df
 if errorlevel 103 goto label2
 if errorlevel 102 goto label2
echo off
   Echo [37;40m
   cls
   c:
   cd \.
 goto DOS
:label2
 c:\prg\mainproc
 goto menu
:Lab6
 @echo off
 Echo [37;40m
 cls
 c:\prg\df
 if errorlevel 103 goto label2
 if errorlevel 102 goto label2
 c:\p
:label2
 c:\prg\mainproc
 goto menu
:DOS
 @echo on
