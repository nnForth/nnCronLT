@echo off
if "%OS%"=="Windows_NT" goto WinNT

start/wait cron.exe -stop
start/wait cron.exe 2000 PAUSE BYE
goto exit

:WinNT
net stop cron

:exit