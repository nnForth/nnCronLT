
: TEST-FILE-TIME { a u dtime -- }
    a FIND-FIRST-FILE
    IF DROP
        __FFB ftLastWriteTime 2@ 2DUP
        dtime 2@ DNEGATE D+ OR
        IF
            dtime 2! TRUE
        ELSE
            2DROP FALSE
        THEN
        NEED-LOAD? OR TO NEED-LOAD?
   THEN
   FIND-CLOSE
;


: NEWEST? ( -- ?)
    0 TO NEED-LOAD?
    nncron.tab MODIF-TIME TEST-FILE-TIME
    NEED-LOAD?
;

: LOAD-TAB ( -- )
    POSTPONE [
    CSP @ >R CSP!
    ['] Classic: TO <PRE>
    nncron.tab EXIST?
    IF
        CSP @ >R
        nncron.tab ['] INCLUDED CATCH
         R> CSP !
        IF 2DROP
        ELSE S" CRONTAB LOADING" CSP? THEN
    THEN
    R> CSP !
    POSTPONE [
;

: SHOW-INCLUDE-ERROR
  CURFILE @
    IF
        <# CURSTR @ S>D #S
           [CHAR] : HOLD
           CURFILE @ ASCIIZ> HOLDS
           S" Loading error: " HOLDS
        #> PAD PLACE PAD COUNT CRON-LOG
    THEN
;

: INIT-DICT
    FORTH DEFINITIONS
    SAVE-LATEST CONTEXT @ !
    SAVE-LATEST LAST !

    SAVE-DP ?DUP IF HERE - ALLOT THEN
    HERE TO SAVE-DP
    LH-UNLINK
;


CREATE default-ini S" release\txt\cron.ini" FILE HERE SWAP DUP ALLOT MOVE 0 C,

: ?save-def-ini
    CronINI fexist? 0=
    IF default-ini ASCIIZ> 2SWAP FWRITE ELSE 2DROP THEN ;

: LOAD-INI
    ?save-def-ini
    CRON-NODE /CRON-NODE ERASE
    POSTPONE [
    CRONINI-FILENAME COUNT ['] INCLUDED CATCH
    IF 2DROP
       SHOW-INCLUDE-ERROR
    THEN
    POSTPONE [
    CRON-NODE DEF-CRON-NODE /CRON-NODE CMOVE
;

: FEX FIND IF EXECUTE ELSE DROP THEN ;

: ?load-crontab
    CSP!
    GET-CUR-TIME
    NEWEST?
    IF
        C" BeforeCrontabLoading" FEX
        S" Load %nncron.tab%" CRON-LOG
        CRON-LIST 0!
        SET-LIST 0!
        INIT-DICT
        NUM-TASK 0!
        LOAD-TAB
        C" AfterCrontabLoading" FEX
        SetProcWorkSet
    THEN
    S" MAIN:LOAD-CRONTAB" CSP?
;

: PASS-CRON ( --)
\    ." ENTER" .S CR
    ['] CRON-TEST CATCH IF S" ERROR PASS" CRON-LOG THEN
\    ." EXIT" .S CR
;
VARIABLE DOUB-MUT

: DoubleInstance? ( -- ?)
    SerializeName FALSE CREATE-MUTEX ?DUP IF NIP EXIT THEN
    DOUB-MUT !
    5 DOUB-MUT @ WaitForSingleObject WAIT_TIMEOUT =
;

: DoubleInstancePrevent
    DoubleInstance?
    IF S" Another instance is running. Exit." CRON-LOG
      BYE
    THEN
;

: SET-DIR
    ModuleDirName 1- PAD ZPLACE
        PAD SetCurrentDirectoryA DROP
;

: INIT-CRON
    0 TO NUM-PASS
\    LOG-MUTEX 0!
    0 TO SAVE-DP

    GET-CUR-TIME

    SET-DIR

    GetCurrentThreadId MainThrId !

    ?GUI IF
            CRONOUT-FILENAME COUNT R/W CREATE-FILE-SHARED
            IF DROP
               S" Can't create nncron.out file" CRON-LOG
            ELSE TO H-STDOUT
                H-STDOUT FILE-SIZE THROW
                H-STDOUT REPOSITION-FILE THROW
            THEN
         THEN

    LOAD-INI

    0. MODIF-TIME 2!
    FORTH DEFINITIONS LATEST TO SAVE-LATEST
;


: MY-TITLE
    TITLE
    S" nnCron LITE. v %SVERSION%" EVAL-SUBST TYPE CR
    S" Copyright (C) 2000-%YYYY% nnSoft. e-mail:nemtsev@nncron.ru" EVAL-SUBST TYPE CR
;


: (EXIT-CRON)
    C" BeforeStop" FEX
    S" Service stopped." CRON-LOG
    BYE
;

' (EXIT-CRON) TO EXIT-CRON

\ HANDLE CreateEvent(
\  LPSECURITY_ATTRIBUTES lpEventAttributes,
\                      // pointer to security attributes
\  BOOL bManualReset,  // flag for manual-reset event
\  BOOL bInitialState, // flag for initial state
\  LPCTSTR lpName      // pointer to event-object name
\ );

CREATE TabEventAttr 3 CELLS , 0 , TRUE

: CREATE-TAB-EVENT
    ServiceName PAD ZPLACE S" TabEvent" PAD +ZPLACE
    PAD FALSE TRUE TabEventAttr CreateEventA TO TAB-EVENT
;

: WAIT-TAB { ms \ start-ms stop-ms -- }
    GetTickCount TO start-ms
    start-ms ms + 1- TO stop-ms
    BEGIN
        stop-ms GetTickCount - DUP 0 >
        IF TAB-EVENT ?DUP
            IF SetProcWorkSet WAIT IF DROP FALSE THEN
            ELSE SetProcWorkSet PAUSE FALSE THEN
            IF ?load-crontab
               TAB-EVENT ResetEvent DROP
            THEN
        ELSE DROP THEN
        GetTickCount stop-ms >
    UNTIL
;

: MAIN-CRON \ 1 2 3
    INIT-CRON
    DoubleInstancePrevent
    CREATE-TAB-EVENT
    MY-TITLE
    S" Start nnCron" CRON-LOG

    StartWinService

    ?load-crontab

    GET-CUR-TIME
    Sec@ 10 > IF 60 Sec@ - 1000 * PAUSE THEN
    START-TIME!
    BEGIN
        GET-CUR-TIME
        Min@ TO PrevMin
        CSP! CSP @ >R
        PASS-CRON   R> CSP !
        S" MAIN:PASS-CRON" CSP?
        1000 PAUSE tiWRITE
        GET-CUR-TIME
        Min@ PrevMin =
        IF
            60 Sec@ - 500 * WAIT-TAB
            ?load-crontab

            GET-CUR-TIME
            Min@ PrevMin =
            IF
                60 Sec@ - 1000 * WAIT-TAB
            THEN
        ELSE
            ?load-crontab
        THEN
    FALSE
    UNTIL
    S" Stop nnCron" CRON-LOG
;


' MAIN-CRON TASK: TASK-MAIN-CRON
