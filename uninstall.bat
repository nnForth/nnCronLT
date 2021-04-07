@echo off
call stopcron.bat

start/wait crond.exe -remove

