@ECHO OFF

if exist release\help.chm move release\help.chm release\doc\help.chm
if exist release\help_ru.chm move release\help_ru.chm release\doc\help_ru.chm
if exist release\history.txt move release\history.txt release\doc\history.txt
if exist release\license.rus.txt move release\license.rus.txt release\doc\license.rus.txt
if exist release\license.txt move release\license.txt release\doc\license.txt
if exist release\readme.rus.txt move release\readme.rus.txt release\doc\readme.rus.txt
if exist release\readme.txt move release\readme.txt release\doc\readme.txt
if exist release\install.bat ren release\install.bat release\install_svc.bat
if exist release\uninstall.bat ren release\uninstall.bat release\uninstall_svc.bat

call ver

set SPForthProject=release

rc_pre.exe templ\cron.rc rc\cron.rc
rc_pre.exe templ\nncronlt.nsi.txt install\nncronlt.nsi
call brc.cmd -r rc\cron.rc -forc\cron.res
..\spf\fres.exe rc\cron.res

cron -stop

DEL cron.exe

call spf NNCRON.F
if not exist cron.exe goto nncron_does_not_exist
copy cron.exe release

call gethelp

rd /s /q install\image\data
nnbackup ver -n 0 -i release -o install\image\data -s -x *.zip,*.out,*.ini,*license.rus.txt,*license.txt

copy release\doc\readme.txt install\image\presetup\
copy release\doc\license.txt install\image\presetup\

copy release\doc\readme.rus.txt install\image\presetup\readme.rus
copy release\doc\license.rus.txt install\image\presetup\license.rus

pushd install
"%WIN%\NSIS\makensis.exe" nncronlt.nsi
rem "%PROGRAMFILES%\Ghost Installer\Build\Build.exe" install.gin
rem copy nncronlt.exe %HOME%\nick\versions\nncronlt%ver%.exe
copy nncronlt%ver%.exe %HOME%\nick\versions\nncronlt%ver%.exe
copy nncronlt%ver%.exe %HOME%\nick\versions\nncronlt.exe
copy nncronlt%ver%.exe ..\nncronlt.exe
copy nncronlt.nsi %HOME%\nick\versions\nncronlt.nsi
popd

call %HOME%\src\cron\put.cmd nncronlt
call %BIN%\backup\dmp.cmd cronlt 5
:nncron_does_not_exist
