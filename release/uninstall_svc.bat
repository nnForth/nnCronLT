@echo off
call stopcron.bat

start/wait cron.exe -q -remove

