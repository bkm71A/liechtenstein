echo off
:menu
  Echo [1;37;44m
  cls
  FOR %%F IN (1,2,3,4,5,6,7,8) DO Echo [?7l°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
  FOR %%F IN (1,2,3,4,5,6,7,8) DO Echo [?7l°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
  FOR %%F IN (1,2,3,4,5,6,7,8) DO Echo [?7l°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
  Echo [1;37;44m[25;01f°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°[0;36;46m
  Echo [1;34;46m[01;01fÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿[37;44m[01;70f
  Echo [1;34;46m[02;01f³ €¢â®¬ â¨§¨à®¢ ­­ ï ¨­ä®à¬ æ¨®­­ ï á¨áâ¥¬  ®¡à ¡®âª¨ íªá¯¥à¨¬¥­â «ì­ëå ¤ ­­ëå ³[37;44m[02;70f
  Echo [1;34;46m[03;01fÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ[37;44m[03;70f
  Echo [1;33;44m[09;26fÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
  Echo [1;33;44m[10;26fº                           º
  Echo [1;33;44m[11;26fº                           º
  Echo [1;37;44m[11;27f A - €¢â®­®¬­ ï à ¡®â  Œ
  Echo [1;33;44m[12;26fº                           º
  Echo [1;33;44m[13;26fº                           º
  Echo [1;37;44m[13;27f N -  ¡®â  ¢ á¥â¨
  Echo [1;33;44m[14;26fº                           º
  Echo [1;33;44m[15;26fº                           º
  Echo [1;37;44m[15;27f D - ‚ëå®¤ ¢ DOS
  Echo [1;33;44m[16;26fº                           º
  Echo [1;33;44m[17;26fº                           º
  Echo [1;37;44m[17;27f Q - Š®­¥æ à ¡®âë
  Echo [1;33;44m[18;26fº                           º
  Echo [1;33;44m[19;26fÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
  Echo [1;36;46m[24;01f
  Klawizs A N D Q
  If ErrorLevel 4 Goto End
  If ErrorLevel 3 Goto D
  If ErrorLevel 2 Goto Net
  If ErrorLevel 1 Goto RME
:RME
   Echo [37;40m
   cls
   c:\prg\arme.bat
   goto menu
:D
echo off
   Echo [0;37;40m
   cls
   c:
   cd \.
   goto DOS
:End
@echo off
   Echo [0;37;40m
   cls
   c:\prg\logout
   cls
   p
:Net
  Echo [0;37;40m
   Cls
   c:\prg\ip
:DOS
  @echo on
