@ECHO OFF

call ver

set SPForthProject=release

rc_pre.exe templ\nncronlt.nsi.txt install\nncronlt.nsi
rd /s /q install\image\data
nnbackup ver -n 0 -i release -o install\image\data -s -x *.zip,*.out,*.ini,*license.rus.txt,*license.txt

copy release\doc\readme.txt install\image\presetup\
copy release\doc\license.txt install\image\presetup\

copy release\doc\readme.rus.txt install\image\presetup\readme.rus
copy release\doc\license.rus.txt install\image\presetup\license.rus

pushd install
E:\win\NSIS\makensis.exe nncronlt.nsi
rem "%PROGRAMFILES%\Ghost Installer\Build\Build.exe" install.gin
rem copy nncronlt.exe %HOME%\nick\versions\nncronlt%ver%.exe
copy nncronlt%ver%.exe %HOME%\nick\versions\nncronlt%ver%.exe
copy nncronlt%ver%.exe %HOME%\nick\versions\nncronlt.exe
copy nncronlt%ver%.exe ..\nncronlt.exe
popd
nncronlt.exe
:nncron_does_not_exist
