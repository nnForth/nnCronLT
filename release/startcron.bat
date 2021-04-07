@echo off
if "%OS%"=="Windows_NT" goto WinNT

:Win95
cron.exe
goto exit

:WinNT
net start cron

:exit