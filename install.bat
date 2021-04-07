@echo off
call stopcron.bat
start/wait crond.exe -remove
start/wait crond.exe -install
call startcron.bat
