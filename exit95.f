\ REQUIRE  WinClass ~nn/lib/win/winclass.f
\ REQUIRE  TrayIcon ~nn/lib/win/trayicon.f
REQUIRE { ~nn/lib/locals.f
REQUIRE MessageLoop ~nn/lib/win/messageloop.f

VARIABLE CtrlWnd
VARIABLE EXIT-95-HTASK
VARIABLE good_time

2001 CONSTANT MY_EXIT
2002 CONSTANT TAB_RELOAD

\ VARIABLE xCNT
:NONAME  { lparam wparam uMsg hwnd \ buf -- }
\    xCNT 1+! xCNT @ DUP . CR 100 > 
\    IF 0 S" xxxx" DROP S" xxxx" DROP 0 MessageBoxA DROP 
\        xCNT 0!
\    THEN
    uMsg WM_QUERYENDSESSION = IF
        WinNT? 0= IF  0 PostQuitMessage DROP  THEN 
        TRUE EXIT 
    THEN

    uMsg MY_EXIT =
    IF
        0 PostQuitMessage DROP
        good_time ON
        TRUE
    ELSE
    uMsg TAB_RELOAD =
    IF
        TAB-EVENT ?DUP IF SetEvent DROP THEN 0
    ELSE
        lparam wparam uMsg hwnd DefWindowProcA
    THEN THEN
;
WNDPROC: ctrl-proc

:NONAME
  good_time OFF
  0 0 0 0 0 0 0 0 0 CtrlWinName DROP S" STATIC" DROP 0 CreateWindowExA CtrlWnd !
  CtrlWnd @ 0= IF ( S" Can't create window" MsgBox) EXIT THEN
\  nnCronWindowTitle 0 WM_SETTEXT CtrlWnd @ SendMessageA DROP
  ['] ctrl-proc GWL_WNDPROC CtrlWnd @ SetWindowLongA DROP
  MessageLoop
  good_time @ IF EXIT-CRON THEN
;

TASK: EXIT-95-TASK

: EXIT-95-START
    EXIT-95-HTASK 0!
    0 EXIT-95-TASK START EXIT-95-HTASK ! ;

