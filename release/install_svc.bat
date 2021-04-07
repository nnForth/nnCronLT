@echo off
call stopcron.bat
start/wait cron.exe -q -remove
start/wait cron.exe -q -install
call startcron.bat
