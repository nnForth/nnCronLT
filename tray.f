REQUIRE MessageLoop ~nn/lib/win/messageloop.f
REQUIRE EXIT-95-START exit95.f


\ : TNW S" Shell_TrayWnd" ;
\ WINAPI: FindWindowA USER32.DLL
\ : ExplorerExist ( -- flag ) 0 TNW DROP FindWindowA ;
\ : LOGGEDON? ExplorerExist ;


:NONAME

  WinNT? 
  IF 
    EXIT-95-START 
  ELSE
      BEGIN
        BEGIN ExplorerExist 0= WHILE 1000 PAUSE REPEAT
           EXIT-95-START 
           -1 EXIT-95-HTASK @ WAIT THROW DROP
            EXIT-95-HTASK @ CLOSE-FILE DROP
        BEGIN ExplorerExist WHILE 1000 PAUSE REPEAT
      AGAIN
  THEN
; TASK: make-tray-task

: StartWinService CR 0 make-tray-task START CLOSE-FILE DROP ;

