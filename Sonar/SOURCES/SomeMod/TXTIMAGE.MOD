IMPLEMENTATION MODULE TxtImage;
IMPORT Lib;

PROCEDURE SaveScreen();
VAR
  adr,adr_video:   ADDRESS;
BEGIN
  adr_video:= [0B800H:0];
  adr:= ADR(spool);
  Lib.WordMove(adr_video,adr,HIGH(spool));
END SaveScreen;


PROCEDURE RestoreScreen();
VAR
   adr,adr_video:   ADDRESS;
BEGIN
  adr_video:= [0B800H:0];
  adr:= ADR(spool);
  Lib.WordMove(adr,adr_video,HIGH(spool));
END RestoreScreen;

END TxtImage.
