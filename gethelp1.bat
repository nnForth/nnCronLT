@echo off

set ZIPFILE=%1
set HELPFILE=%2
set DSTDIR=%3
echo HOME=%HOME%

pushd %HOME%\src\help
call wget -e continue=off -N http://www.nncron.ru/download/%ZIPFILE%

if exist %ZIPFILE% goto unzip_help

echo ERROR: file %ZIPFILE% not exists
goto exit

:unzip_help
cd
echo unzipping %HELPFILE%
del %HELPFILE%
unzip -o %ZIPFILE%
copy %HELPFILE% %DSTDIR%
:exit
popd