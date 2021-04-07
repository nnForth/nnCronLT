@echo off

set doc_dest=%HOME%\src\cronlt\release\doc
if %COMPUTERNAME%==ADMIN goto get_help
start/wait %HOME%\src\cron\nncrond.exe ONLINE? HALT
if %ERRORLEVEL%==0 goto no_get_help

:get_help
call gethelp1 nncronlt.zip help.chm %doc_dest%
call gethelp1 nncronlt_ru.zip help_ru.chm %doc_dest%

pushd %doc_dest%
call wget -e continue=off -N http://www.nncron.ru/translation/nncronlt/readme.txt
call wget -e continue=off -N http://www.nncron.ru/translation/nncronlt/readme.br.txt
call wget -e continue=off -N http://www.nncron.ru/translation/nncronlt/readme.chs.txt
call wget -e continue=off -N http://www.nncron.ru/translation/nncronlt/readme.cz.txt
call wget -e continue=off -N http://www.nncron.ru/translation/nncronlt/readme.de.txt
call wget -e continue=off -N http://www.nncron.ru/translation/nncronlt/readme.es.txt
call wget -e continue=off -N http://www.nncron.ru/translation/nncronlt/readme.fi.txt
call wget -e continue=off -N http://www.nncron.ru/translation/nncronlt/readme.fr.txt
call wget -e continue=off -N http://www.nncron.ru/translation/nncronlt/readme.nl.txt
call wget -e continue=off -N http://www.nncron.ru/translation/nncronlt/readme.pt.txt
call wget -e continue=off -N http://www.nncron.ru/translation/nncronlt/readme.rus.txt
call wget -e continue=off -N http://www.nncron.ru/translation/nncronlt/readme.ua.txt
call wget -e continue=off -N http://www.nncron.ru/translation/nncronlt/readme.pl.txt

call wget -e continue=off -N http://www.nncron.ru/translation/nncronlt/license.txt
call wget -e continue=off -N http://www.nncron.ru/translation/nncronlt/license.rus
del license.rus.txt
ren license.rus license.rus.txt


popd

:no_get_help