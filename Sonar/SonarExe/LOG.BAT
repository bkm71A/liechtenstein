@echo on
rem c:
rem cd c:\prg
 login
 if errorlevel 255 goto lab2
 if errorlevel 254 goto lab2
 if errorlevel 253 goto lab2
 if errorlevel 252 goto lab2
 goto end
:lab2 
 error
:end
c:
cd c:\prg
 menu ais
