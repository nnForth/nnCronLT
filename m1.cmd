@ECHO OFF

call ver

set SPForthProject=debug

rc_pre.exe templ\cron.rc rc\cron.rc
call brc.cmd -r rc\cron.rc -forc\cron.res
fres rc\cron.res

rem net stop NNCronLTD
rem crond.exe -stop
sleep 2
DEL crond.exe

call spf nncron.f
rem >make.log

if exist crond.exe goto start
echo crond.exe not exist 
goto exit

:start
rem nncrond.exe -install
rem sleep 2
rem  start crond.exe -ns
rem call startcron.bat
rem net start NNCronLTD
net stop cron
sleep 3
copy crond.exe %WIN%\cron\cron.exe
net start cron

rem call spf nish.f
rem if exist nish.exe copy nish.exe release

rem stopscm -h mailsrv -s nncron
rem copy nncrond.exe \\mailsrv\e$\win\eserv2\nncron.exe
rem startscm -h mailsrv -s nncron

:exit