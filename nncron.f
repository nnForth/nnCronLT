\ cron

: WINAPI: ['] WINAPI: CATCH IF SOURCE TYPE CR ELSE ( SOURCE TYPE CR) THEN ;

CREATE CRONOUT-FILENAME C" cron.out" ", 0 C,
: nncron.tab S" cron.tab" ;

WARNING @ WARNING 0!
: BYE
    H-STDOUT CLOSE-FILE DROP
    CRONOUT-FILENAME COUNT DELETE-FILE DROP
    BYE
; WARNING !

REQUIRE { ~nn/lib/locals.f

S" ~nn\lib\lh.f" INCLUDED
S" LIB\EXT\JMP.F" LH-INCLUDED
S" ~nn/lib/qdebug.f" INCLUDED

DEBUG?
[IF]
: (INCLUDED) ( a u )
    HERE >R ." #include <" 2DUP TYPE ." > "
    CURFILE @ >R
    2DUP HEAP-COPY CURFILE !
    2DUP 2>R INCLUDE-PROBE 2R> ROT
    IF +ModuleDirName INCLUDE-PROBE ELSE 2DROP 0 THEN
    CURFILE @ FREE DROP
    R> CURFILE !
    HERE R> - . CR
    THROW ;

' (INCLUDED) ' INCLUDED JMP
[THEN]

S" LIB\EXT\CORE-EXT1.F" INCLUDED
S" ~nn/lib/EOF.F" INCLUDED
\ S" LIB\ext\tools.f" INCLUDED
S" LIB\EXT\CASE.F" INCLUDED

: NNCRON-HOME-DIR ModuleDirName ;
: WINAPI: >IN @ >R
    BL WORD FIND NIP
    0= IF R> >IN ! WINAPI:
       ELSE RDROP BL WORD DROP THEN
;
\ : INCLUDED 2DUP TYPE ." ..." INCLUDED ." ok" CR ;

DEBUG?
[IF]
    : .S CR ." Depth is " DEPTH . CR .S ;

    CREATE SVC-NAME C" cronD" ", 0 C,
    : CtrlWinName S" NNCronLTCtrlWindowD" ;
    : SerializeName S" NNCronLTDSerialize" ;
[ELSE]
    CREATE SVC-NAME C" cron" ", 0 C,
    : CtrlWinName S" NNCronLTCtrlWindow" ;
    : SerializeName S" NNCronLTSerialize" ;
[THEN]

: ServiceName SVC-NAME COUNT ;

ServiceName TYPE CR

: BeforeCrontabLoading ;
: AfterCrontabLoading ;
: BeforeStop ;

\ S" LIB\EXT\STRING.F" INCLUDED

0 VALUE PrevMin
0 VALUE SAVE-LATEST
0 VALUE SAVE-DP
0 VALUE TAB-EVENT

0 VALUE CRONLOG-FILENAME  HERE C" cron.log" ", 0 C, TO CRONLOG-FILENAME
0 VALUE CRONLOG-TIME-FORMAT HERE C" %WW% %DD%-%MM%-%YYYY% %hh%:%mm% %ThreadId%" ", 0 C,
            TO CRONLOG-TIME-FORMAT

CREATE CRONINI-FILENAME C" cron.ini" ", 0 C,

: CronINI CRONINI-FILENAME COUNT ;

S" ~nn/lib/onoff.f" INCLUDED

VECT EXIT-CRON  ' BYE TO EXIT-CRON

CREATE MODIF-TIME 2 CELLS ALLOT

0 VALUE CRONTAB-FILE

0 VALUE NEED-LOAD?

VARIABLE MainThrId

0x00200000 CONSTANT MB_SERVICE_NOTIFICATION

 S" ~nn\lib\usedll.f" LH-INCLUDED
 UseDLL USER32.DLL
 UseDLL KERNEL32.DLL
 UseDLL GDI32.DLL
 UseDLL ADVAPI32.DLL

\ S" ~nn/lib/win/wfunc.f" INCLUDED

S" ~nn/lib/wincon.f"  LH-INCLUDED

S" ~nn/lib/find.f" INCLUDED
S" ~nn/lib/list.f" INCLUDED
\ S" ~nn/lib/winver.f" INCLUDED
\ S" agents/pop3rules/wcmatch.f" INCLUDED
\ USER-VALUE EXACT-MATCH?
\ : WC-MATCH1 EXACT-MATCH? IF WC-COMPARE ELSE WC-MATCH THEN ;
S" win32.f" INCLUDED
\ S" ~nn/lib/beep.f" INCLUDED
S" LIB\EXT\MUTEX.F" INCLUDED
\ S" winsta.f" INCLUDED
\ S" time.f" INCLUDED
S" ~nn/lib/getstr.f" INCLUDED
REQUIRE EVAL-SUBST ~nn/lib/subst1.f
\ S" ~nn/lib/win.f" INCLUDED
\ S" ~nn/lib/mouse.f" INCLUDED
S" ~nn/lib/process.f" INCLUDED
S" add.f" INCLUDED
\ S" ~nn/lib/folders.f" INCLUDED
\ S" ~nn/lib/delfolder.f" INCLUDED

S" ~nn/lib/file.f" INCLUDED
\ S" file.f"  INCLUDED
S" ~nn/lib/log.f" INCLUDED


(
: .ADDRS
    BASE @ >R HEX
    ." Thread ID: " ThreadId TYPE CR
    ." Image begin " IMAGE-BEGIN U. CR
    ." Here "   HERE U. CR
    ." PAD "    PAD U. CR
    ." SP: "    SP@ U. CR
    R> BASE !
;
)
: CRON-LOG  ( a u --)
    EVAL-SUBST
    CRONLOG-FILENAME COUNT EVAL-SUBST
    LOG ;
: LOG-TASK BASE @ >R HEX
    S" H:%HERE N>H% T:%TIB N>H% SP:%SP@ N>H" CRON-LOG
    R> BASE !
    ;
(
USER-CREATE THID-NAME 2 CELLS USER-ALLOT
USER THID
\ : THID. \ S" NAME" --
    THID-NAME 2!
    DEBUG?
    IF
        GetCurrentThreadId THID !
        S" %THID-NAME 2@%: ThId: %THID @ N>S%" CRON-LOG
    THEN
;
)

S" ~nn/lib/set.f" INCLUDED
S" csp.f" INCLUDED
S" ~nn/lib/shellstart.f" INCLUDED
\ S" ~nn/lib/ras.f" INCLUDED
\ S" tl.f" INCLUDED
\ S" sec.f" INCLUDED
\ S" ~nn/lib/bak.f" INCLUDED
\ REQUIRE FOR-FILES ~nn/lib/for-files.f
\ REQUIRE FMOVE ~nn/lib/file.f
\ S" ~nn/lib/keyemul.f" INCLUDED
\ S" ~nn/lib/isearch.f" INCLUDED
S" crontab.f" INCLUDED
\ S" watch.f" INCLUDED
\ S" watchwin.f" INCLUDED
\ S" watchCD.f" INCLUDED
\ S" clipboard.f" INCLUDED
S" ~nn/lib/nnsvc.f" INCLUDED
S" ~nn/lib/nnsvc95.f" INCLUDED
\ S" ~nn/lib/regkey.f"  INCLUDED
\ S" reg.f" INCLUDED
\ S" ~nn/lib/priv.f" INCLUDED
S" ~nn/lib/build.f" INCLUDED

S" ../cron/homedir.f" INCLUDED

S" macros.f" INCLUDED
\ S" hint.f" INCLUDED
\ S" watchproc.f" INCLUDED
S" ~nn/lib/time-vars.f" INCLUDED

S" options.f" INCLUDED
S" tray.f" INCLUDED
\ S" reminder.f" INCLUDED
\ S" ~nn/lib/web/server.f" INCLUDED
\ S" ~nn/lib/script.f" INCLUDED
\ ' START-APPW TO StartScriptApp
S" ~nn/lib/workset.f" INCLUDED
S" main.f" INCLUDED
S" install.f" INCLUDED

: -debug    TRUE TO DEBUG? ;

: -stop
    INIT-CRON
    CtrlWinName DROP 0 FindWindowA ?DUP
    IF >R
        0 0 MY_EXIT R> SendMessageA DROP
    THEN
    BYE
;

: NNSERVICE
  DECIMAL
  ServiceName doStartService
  0= IF EXIT-CRON THEN
  WinNT? IF BYE THEN
;

' NNSERVICE TASK: NNSERVICE-TASK


: StartNNServiceTask  ( 0 NNSERVICE-TASK START DROP) NNSERVICE ;

0 VALUE NOT-SERVICE?

WINAPI: RegisterServiceProcess KERNEL32.DLL
\ DWORD RegisterServiceProcess(
\  DWORD dwProcessId,
\  DWORD dwType
\ );



: -ns TRUE TO NOT-SERVICE? ;
: (Send2Cron) ( par1 par2 msg -- ?)
    CtrlWinName DROP 0 FindWindowA ?DUP
    IF SendMessageA ELSE 2DROP DROP 0 THEN ;
: Send2Cron (Send2Cron) DROP ;


: MAIN { \ atom -- }
    ['] THROW TO ERROR
    WinNT? 0= NOT-SERVICE? OR
    IF
        NOT-SERVICE? 0=
        IF 1 GetCurrentProcessId RegisterServiceProcess DROP THEN
        MAIN-CRON
    ELSE
\        S" SeShutdownPrivilege" PrivOn DROP
        StartNNServiceTask
        -1 PAUSE
    THEN
;


: CRONLOG-TIME ( -- addr u) CRONLOG-TIME-FORMAT COUNT EVAL-SUBST ;
' CRONLOG-TIME TO LOG-TIME

: C", ( -- addr)
    get-string TUCK HERE >R R@ PLACE
    1+ ALLOT 0 C, R> ;

: -v
    S" nnCron LITE v %SVERSION%" EVAL-SUBST MsgBox ;


: -reload-tab
    0 0 TAB_RELOAD Send2Cron
    BYE
;
: -reload  -reload-tab ;

\ : Crontab: get-string ADD-TAB ;
: Cronlog:  C", TO CRONLOG-FILENAME ;
: LogTimeFormat: C", TO CRONLOG-TIME-FORMAT ;

\ : DelNNCron S" %FOLDER-PROGRAMS%\NNCron" EVAL-SUBST DeleteFolder DROP ;

: -? 0 S" readme.txt" START-APP BYE ;
: /? -? ;
: /h -? ;
: /H -? ;
: /help -? ;

' MAIN-CRON TO ServiceProc

' MAIN TO <MAIN>
\ DEBUG? 0= [IF] TRUE TO ?GUI [THEN]
TRUE TO ?GUI
0 MAINX !
' BYE ' QUIT JMP

S" icons.f" INCLUDED

\ REQUIRE MT-ALLOT ~nn/lib/allot.f

CR .( End of building.) CR
DEBUG? [IF] BUILD! [ELSE] BUILD++ [THEN]
512 1024 * TO IMAGE-SIZE
\ HEX 4C8821 100 - 200 DUMP

REQUIRE RESOURCES: ~nn/~yz/resources.f

RESOURCES: rc/cron.fres

\ S" lib/ext/dis486.f" INCLUDED
DEBUG? 0=
[IF]
    S" cron.exe" SAVE
[ELSE]
    S" crond.exe" SAVE
[THEN]

BYE

