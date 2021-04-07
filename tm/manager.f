REQUIRE DEBUG? ~nn/lib/qdebug.f
REQUIRE BUILD! ~nn/lib/build.f
REQUIRE JMP ~nn/lib/jmp.f
REQUIRE ININAME ~nn/lib/init.f
REQUIRE RESOURCES: ~nn/~yz/resources.f
REQUIRE EXE-PATH ~nn/lib/executable.f
REQUIRE ONLYNAME ~nn/lib/filename.f
REQUIRE FILE-ICONS ~nn/lib/win/shell/fileinfo.f
\ REQUIRE QWNDPROC: ~nn/lib/qWNDPROC.f


CREATE ProgName C" nnCron LITE" ",

S" res.f" INCLUDED
S" ../../cron/tm/message.f" INCLUDED
S" build.f" INCLUDED
S" about.f" INCLUDED
S" crontab.f" INCLUDED
S" main.f" INCLUDED

' MAIN TO <MAIN>
TRUE TO ?GUI
0 MAINX !
' BYE ' QUIT JMP

S" cron.ini" ININAME
S" manager.out" OUTNAME

DEBUG? [IF] BUILD! [ELSE] BUILD++ [THEN]

RESOURCES: manager.fres

S" manager.exe" SAVE
\ .( GetDialogBaseUnits=) GetDialogBaseUnits 0x1000 /MOD . . CR
\ EditTask nncron.tab purge-cron-log

BYE
