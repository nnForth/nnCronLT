@echo off
call rc.cmd manager.rc
fres manager.res
kill -f manager.exe
call ..\ver
set SPForthProject=debug
call spf manager.f
call copy2.cmd