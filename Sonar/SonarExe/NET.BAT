@echo off
 c:\net\net3
 if errorlevel 3 goto lab2
 if errorlevel 2 goto lab1
 if errorlevel 1 goto lab1
 goto lab2
:lab1
 c:\prg\errornet
:lab2
 c:\prg\log


