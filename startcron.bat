@echo off
if "%OS%"=="Windows_NT" goto WinNT

:Win95
crond.exe
goto exit

:WinNT
rem net start crond
crond.exe -ns
:exit