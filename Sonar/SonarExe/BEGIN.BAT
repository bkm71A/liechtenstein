echo off
:menu
  Echo [1;37;44m
  cls
  FOR %%F IN (1,2,3,4,5,6,7,8) DO Echo [?7l같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같
  FOR %%F IN (1,2,3,4,5,6,7,8) DO Echo [?7l같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같
  FOR %%F IN (1,2,3,4,5,6,7,8) DO Echo [?7l같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같
  Echo [1;37;44m[25;01f같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같[0;36;46m
  Echo [1;34;46m[01;01f旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커[37;44m[01;70f
  Echo [1;34;46m[02;01f� �™�쵟殊㎤昔쥯�췅� Þ兒席졿Ŧ�췅� 歲飡�쵟 �□젩�洙� 咨召�黍Д��젷彛音 쩆��音 �[37;44m[02;70f
  Echo [1;34;46m[03;01f읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸[37;44m[03;70f
  Echo [1;33;44m[09;26f�袴袴袴袴袴袴袴袴袴袴袴袴袴敲
  Echo [1;33;44m[10;26f�                           �
  Echo [1;33;44m[11;26f�                           �
  Echo [1;37;44m[11;27f A - �™���Л좑 �젩��� 릪�
  Echo [1;33;44m[12;26f�                           �
  Echo [1;33;44m[13;26f�                           �
  Echo [1;37;44m[13;27f N - 맆‘�� � 醒殊
  Echo [1;33;44m[14;26f�                           �
  Echo [1;33;44m[15;26f�                           �
  Echo [1;37;44m[15;27f D - 귣若� � DOS
  Echo [1;33;44m[16;26f�                           �
  Echo [1;33;44m[17;26f�                           �
  Echo [1;37;44m[17;27f Q - 뒶�ζ �젩�瞬
  Echo [1;33;44m[18;26f�                           �
  Echo [1;33;44m[19;26f훤袴袴袴袴袴袴袴袴袴袴袴袴袴�
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
