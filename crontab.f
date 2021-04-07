REQUIRE { ~nn/lib/locals.f
REQUIRE N-TEST ~nn/lib/time-test.f
REQUIRE LoadUserProfile ~nn/lib/asuser/asuser.f
\ REQUIRE GetTrayToken ~nn\lib\win\sec\traytoken.f
REQUIRE GetCurrentUserToken ~nn\lib\win\sec\wts.f
\ REQUIRE RES ~nn/lib/res.f

CREATE START-TIME /SYSTEMTIME ALLOT
: START-TIME! GET-CUR-TIME LTIME START-TIME /SYSTEMTIME CMOVE ;

0 VALUE NUM-PASS
0 VALUE START-DIR

VARIABLE YearField
YearField OFF
CHAR ~ VALUE NoLogPrefix
CHAR @ VALUE RunMissedPrefix

VARIABLE DefMissed         44640 DefMissed !

: DefaultRunMissedTime: get-string SH:M|D>MIN DefMissed ! ;
DefaultRunMissedTime: 360:00

0
1 CELLS -- CRON-NEXT
1 CELLS -- CRON-NAME
1 CELLS -- CRON-TIME-LIST    \ time list
1 CELLS -- CRON-FLAGS
\ 1 CELLS -- CRON-COMMAND
\ 1 CELLS -- CRON-INTERNAL
\ 1 CELLS -- CRON-AFTER
\ 1 CELLS -- CRON-RULE
1 CELLS -- CRON-ACTION
\ 1 CELLS -- CRON-WATCH
\ 1 CELLS -- CRON-USER
\ 1 CELLS -- CRON-PASSWORD
\ 1 CELLS -- CRON-DOMAIN
\ 1 CELLS -- CRON-SU-FLAGS
\ 1 CELLS -- CRON-SU-TOKEN
\ 1 CELLS -- CRON-HWINSTA
\ 1 CELLS -- CRON-FILENAME
1 CELLS -- CRON-CRC32
1 CELLS -- CRON-MISSED     \ if set value is minutes
1 CELLS -- CRON-IS-MISSED  \ true if task is missed

1 CELLS -- CRON-APP-Flags
/STARTUPINFO -- CRON-si

CONSTANT /CRON-NODE

0
1 CELLS -- CRON-NEXT-TIME
1 CELLS -- CRON-MIN
1 CELLS -- CRON-HOUR
1 CELLS -- CRON-DAY
1 CELLS -- CRON-WDAY
1 CELLS -- CRON-MON
1 CELLS -- CRON-YEAR
60      -- CRON-T-MIN
24      -- CRON-T-HOUR
31      -- CRON-T-DAY
7       -- CRON-T-WDAY
12      -- CRON-T-MON
YEAR-RANGE 1+ -- CRON-T-YEAR

CONSTANT /CRON-TIME

2   CONSTANT CRON-FLAG-ACTIVE
4   CONSTANT CRON-FLAG-ERROR

VARIABLE CRON-LIST

CREATE CRON-NODE /CRON-NODE ALLOT
CREATE CRON-TIME /CRON-TIME ALLOT

CREATE DEF-CRON-NODE /CRON-NODE ALLOT
        DEF-CRON-NODE /CRON-NODE ERASE
USER-VALUE CUR-NODE
USER-VALUE CUR-TIME
USER-VALUE NO-LOG

: CRON-FLAG-ERROR?  CUR-NODE CRON-FLAGS @ CRON-FLAG-ERROR AND ;
: CF-RUN-MISSED? CUR-NODE CRON-MISSED @ 0<> ;  \ CF-RUN-MISSED  CUR-FLAG? ;
: by-time? MainThrId @ GetCurrentThreadId = ;

: ">' ( a u -- a u)
    2DUP
    OVER + SWAP
    DO I C@ [CHAR] " = IF [CHAR] ' I C! THEN LOOP ;

: CRON-TASK-NAME
    CRON-NODE CRON-ACTION @
    ?DUP IF CFL + XCOUNT EVAL-SUBST ">' ELSE S"  " THEN     \ "

;

: CUR-TASK-NAME
    CUR-NODE ?DUP IF CRON-ACTION @ ?DUP
                     IF CFL + XCOUNT EVAL-SUBST ">' ELSE HERE 0 THEN    \ "
                  ELSE HERE 0 THEN
;

DEBUG?
[IF]
    : TDBG-NAME CUR-TASK-NAME TYPE SPACE ;
    : TDBG( [CHAR] ) POSTPONE .TIME POSTPONE TDBG-NAME WORD COUNT >R PAD R@ CMOVE PAD R> EVALUATE ; IMMEDIATE
[ELSE]
    : TDBG( [CHAR] ) WORD DROP ; IMMEDIATE
[THEN]



S" ../cron/taskinfo.f" INCLUDED

: ?CRON-LOG NO-LOG 0= IF CRON-LOG ELSE 2DROP THEN ;

: LOG-NODE ( A # NODE --)
    >R
    PAD PLACE
    R> CRON-NAME @  ?DUP
    IF COUNT PAD +PLACE THEN
    PAD COUNT ?CRON-LOG
;

: CRON-FLAG1 ( mask --)
    CRON-NODE CRON-FLAGS @ OR
    CRON-NODE CRON-FLAGS ! ;
: CRON-FLAG0 ( mask --)
    -1 XOR CRON-NODE CRON-FLAGS @ AND
    CRON-NODE CRON-FLAGS ! ;

: SET-CRON-FLAG (  NODE MASK --) >R CRON-FLAGS DUP @ R> OR SWAP ! ;
: CLR-CRON-FLAG (  NODE MASK --) -1 XOR >R CRON-FLAGS DUP @ R> AND SWAP ! ;


: GW, ( -- a/0) BL WORD DUP C@ IF DUP ", 0 C, ELSE DROP 0 THEN ;
: end-def STATE @ IF RET, ( POSTPONE ;) [COMPILE] [ SMUDGE THEN ; \ ]
\ : end-def STATE @ IF POSTPONE ; THEN ;



USER >IN1

: TIME-ERROR
    >IN @ >IN1 !
    S" WARNING: %CUR-TAB-FILENAME COUNT% line:%CURSTR @ N>S% pos:%>IN1 @ N>S%. Invalid time specification. Possible range is [%BEG-RANGE N>S%-%END-RANGE N>S%]."
    CRON-LOG ;

0 [IF]
             : TEST-TIME-FIELD ( a u -- )
             \    CR ." ENTER" CR
             \    .S
                 BEGIN ?DUP WHILE
                     OVER C@ [CHAR] * =
                     IF SKIP-CHAR
                     ELSE
                         TIME>NUMB DUP BEG-RANGE < SWAP END-RANGE > OR
                         IF 2DROP TIME-ERROR EXIT THEN
                     THEN
                     DUP
                     IF OVER C@ DUP [CHAR] , = OVER [CHAR] - = OR SWAP [CHAR] / = OR
                        IF
                          SKIP-CHAR
                          ?DUP 0= IF DROP TIME-ERROR EXIT THEN
                        ELSE
                          2DROP TIME-ERROR EXIT
                        THEN
                     THEN
                 REPEAT
                 DROP
             \    CR ." EXIT" CR
             \    .S
             ;
[THEN]

VARIABLE t-is-year

: TEST-TIME-FIELD ( a u -- )
\    CR ." ENTER" CR
\    .S
    BEGIN ?DUP WHILE
        OVER C@ DUP [CHAR] * = SWAP [CHAR] ? = OR
        IF SKIP-CHAR
        ELSE
            TIME>NUMB DUP BEG-RANGE < SWAP END-RANGE > OR t-is-year @ 0= AND
            IF 2DROP TIME-ERROR EXIT THEN
        THEN
        DUP
        IF OVER C@ DUP [CHAR] , = OVER [CHAR] - = OR SWAP [CHAR] / = OR
           IF
             SKIP-CHAR
             ?DUP 0= IF DROP TIME-ERROR EXIT THEN
           ELSE
             2DROP TIME-ERROR EXIT
           THEN
        THEN
    REPEAT
    DROP
\    CR ." EXIT" CR
\    .S
;



: GTW, { \ beg -- addr }
    HERE TO beg  0 W,
    BEGIN
      GW, DUP
      IF
        COUNT beg +PLACE -3 ALLOT 0 C,
\        beg SHOW
        beg COUNT + 1- C@ DUP [CHAR] , = SWAP [CHAR] - = OR
      THEN
      0=
    UNTIL
    beg C@ 0=
    IF 0
    ELSE beg C@ 1 = beg 1+ C@ [CHAR] * = AND
        IF 0
        ELSE beg COUNT TEST-TIME-FIELD
             beg
        THEN
    THEN
;

S" ../cron/ttable.f" INCLUDED

: M: end-def t-is-ny 0-59 GTW, DUP CRON-TIME CRON-MIN !
    CRON-TIME CRON-T-MIN START-TIME wMinute W@ set-cron-time-table
\    0 CRON-TIME CRON-MIN @ COUNT DROP DUP 0 MessageBoxA DROP
;  IMMEDIATE
: H: end-def t-is-ny 0-23 GTW, DUP CRON-TIME CRON-HOUR !
    CRON-TIME CRON-T-HOUR START-TIME wHour W@ set-cron-time-table
; IMMEDIATE
: W: end-def t-is-ny 1-7 GTW, DUP CRON-TIME CRON-WDAY !
    CRON-TIME CRON-T-WDAY START-TIME wDayOfWeek W@ ?DUP 0= IF 7 THEN set-cron-time-table
; IMMEDIATE
: D: end-def t-is-ny 1-31 GTW, DUP CRON-TIME CRON-DAY !
    CRON-TIME CRON-T-DAY START-TIME wDay W@ set-cron-time-table
; IMMEDIATE
: MON: end-def t-is-ny 1-12 GTW, DUP CRON-TIME CRON-MON !
    CRON-TIME CRON-T-MON START-TIME wMonth W@ set-cron-time-table
; IMMEDIATE
: Y: end-def t-is-y 2000-3000 GTW, DUP CRON-TIME CRON-YEAR !
    CRON-TIME CRON-T-YEAR START-TIME wYear W@ set-cron-time-table
; IMMEDIATE


\ * : M: end-def 0-59 GTW, CRON-TIME CRON-MIN !  ;  IMMEDIATE
\ * : H: end-def 0-23 GTW, CRON-TIME CRON-HOUR ! ; IMMEDIATE
\ * : W: end-def 1-7 GTW, CRON-TIME CRON-WDAY ! ; IMMEDIATE
\ * : D: end-def 1-31 GTW, CRON-TIME CRON-DAY ! ; IMMEDIATE
\ * : MON: end-def 1-12 GTW, CRON-TIME CRON-MON ! ; IMMEDIATE
\ * : Y: end-def 2000-3000 GTW, CRON-TIME CRON-YEAR ! ; IMMEDIATE

\ : C: end-def 1 WORD DUP ", 0 C, CRON-NODE CRON-COMMAND ! ;  IMMEDIATE
\ : I: end-def :NONAME CRON-NODE CRON-INTERNAL ! ;  IMMEDIATE
\ : A: end-def :NONAME CRON-NODE CRON-AFTER ! ;  IMMEDIATE
: A: end-def :NONAME CRON-NODE CRON-ACTION ! ;  IMMEDIATE

\ : Internal: [COMPILE] I: ; IMMEDIATE
\ : After: [COMPILE] A: ; IMMEDIATE
\ : Command:  [COMPILE] C: ; IMMEDIATE

\ : LogInternal end-def CRON-FLAG-LOGINTERNAL CRON-FLAG1 ;  IMMEDIATE
: Action:  [COMPILE] A: ; IMMEDIATE

: SET-SI-FLAGS ( flag node --)
    >R R@ CRON-si dwFlags @ OR
       R> CRON-si dwFlags ! ;

: (SET-SW) ( flag node )
    >R  R@ CRON-si wShowWindow W!
    STARTF_USESHOWWINDOW R> SET-SI-FLAGS ;

: SET-SW ( flag -- )
    STATE @ IF POSTPONE LITERAL POSTPONE CUR-NODE POSTPONE (SET-SW)
    ELSE CRON-NODE (SET-SW) THEN ;

: ShowNormal       SW_SHOWNORMAL      SET-SW ; IMMEDIATE
: SWHide           SW_HIDE            SET-SW ; IMMEDIATE
: ShowMaximized    SW_SHOWMAXIMIZED   SET-SW ; IMMEDIATE
\ : ShowMinimized    SW_SHOWMINIMIZED   SET-SW ; IMMEDIATE
: ShowMinimized    SW_SHOWMINNOACTIVE SET-SW ; IMMEDIATE
: ShowNoActivate   SW_SHOWNOACTIVATE  SET-SW ; IMMEDIATE

: (SET-APP-Flags) ( flag node -- ) CRON-APP-Flags ! ;

: SET-APP-Flags ( flag -- )
    STATE @ IF POSTPONE LITERAL POSTPONE CUR-NODE POSTPONE (SET-APP-Flags)
    ELSE CRON-NODE (SET-APP-Flags) THEN ;

: xNT WinNT? 0= IF RDROP THEN ;

: HighPriority   xNT   HIGH_PRIORITY_CLASS SET-APP-Flags ; IMMEDIATE
: IdlePriority   xNT   IDLE_PRIORITY_CLASS SET-APP-Flags ; IMMEDIATE
: NormalPriority xNT   NORMAL_PRIORITY_CLASS SET-APP-Flags ; IMMEDIATE
: RealtimePriority xNT REALTIME_PRIORITY_CLASS SET-APP-Flags ; IMMEDIATE
\ : AboveNormalPriority xNT   0x8000 SET-APP-Flags ; IMMEDIATE
\ : BelowNormalPriority xNT   0x4000 SET-APP-Flags ; IMMEDIATE



: CRON-NODE0!
    CRON-NODE /CRON-NODE ERASE
    DEF-CRON-NODE CRON-NODE /CRON-NODE CMOVE
    CRON-TIME /CRON-TIME ERASE
    CRON-FLAG-ACTIVE  CRON-FLAG1

    CRON-TIME CRON-T-MIN [ 60 24 + 31 + 7 + 12 + YEAR-RANGE 1+ + ] LITERAL 1 FILL

;


: ?TEST> N-TEST 0= IF RDROP FALSE THEN  ;

: (TEST-NODE-TIME) ( -- ? )
    ['] def-name2num TO NAME2NUM
    0-59 CUR-TIME CRON-MIN @ Min@  START-TIME wMinute W@ ?TEST>
    0-23 CUR-TIME CRON-HOUR @ Hour@  START-TIME wHour W@ ?TEST>
    CUR-TIME CRON-WDAY @ 0=
    IF 1-31 CUR-TIME CRON-DAY @ Day@ START-TIME wDay W@ ?TEST> ELSE
    CUR-TIME CRON-DAY @ 0=
    IF 1-7  CUR-TIME CRON-WDAY @ WDay@  WEEKDAYS 0 ?TEST>
    ELSE
        1-31 CUR-TIME CRON-DAY @ Day@ START-TIME wDay W@ N-TEST
        1-7  CUR-TIME CRON-WDAY @ WDay@  WEEKDAYS 0 N-TEST AND
        0= IF FALSE EXIT THEN
    THEN THEN
    1-12 CUR-TIME CRON-MON @ Mon@  MONTHES START-TIME wMonth W@  ?TEST>
    2000-3000 YearField @ IF CUR-TIME CRON-YEAR @ Year@ 0 ?TEST> THEN
    TRUE
;

: TEST-NODE-TIME ( -- ?)
    CUR-NODE CRON-TIME-LIST
    BEGIN @ ?DUP WHILE
      TO CUR-TIME
      (TEST-NODE-TIME)
      IF TRUE EXIT THEN
      CUR-TIME
    REPEAT
    FALSE
;

0 VALUE CUR-POS
USER-VALUE ERR-CODE

S" ../cron/assumed.f" INCLUDED

0 [IF]
            : MISSED? ( -- ?)
            \ true if task is missed
                DBG( ." MISSED?" CR )
                ASSUMED-PREV-TIME
                IF ( d)
                    DBG( ." 1 --- " 2DUP D. CR )
                    TASK-EXECUTION-TIME
                    IF ( d1 d2 )
                        DBG( ." 2 --- " 2DUP D. CR )
                        2SWAP D<
                    ELSE
                        TASK-CREATION-TIME
                        IF
                            DBG( ." 3 --- " 2DUP D. CR )
                            2SWAP D<
                        ELSE
                            DBG( ." 4 --- " 2DUP D. CR )
                            2DROP FALSE
                        THEN
                    THEN
                ELSE
                    FALSE
                THEN
            ;
[THEN]

: MISSED? { \ n1 n2 -- ?}
\ true if task is missed
    DBG( ." MISSED?" CR )
    ASSUMED-PREV-TIME
    IF ( d)
        TO n2 TO n1
        DBG( ." 1 --- " n1 n2 D. CR )
        TASK-EXECUTION-TIME
        IF ( d1 d2 )
            DBG( ." 2 --- " 2DUP D. CR )
            n1 n2 D<
        ELSE
            TASK-CREATION-TIME
            IF
                DBG( ." 3 --- " 2DUP D. CR )
                n1 n2 D<
            THEN
        THEN
    ELSE
        FALSE
    THEN
    DUP
    IF
        \ проверяем, а не прошло ли время для missed?
        FT-CUR n1 n2 FT- FT>MIN
        DBG( ." 4 --- " DUP . CR )
        DUP 0 >
        IF
            CUR-NODE CRON-MISSED @ >
            IF DROP FALSE THEN
        ELSE DROP THEN
        DBG( ." 5 --- " DUP . CR )
    THEN
;


: RUN-MISSED? ( -- ?)
    CF-RUN-MISSED? by-time?  AND
    IF
        MISSED?
        DUP CUR-NODE CRON-IS-MISSED !
    ELSE
        FALSE
    THEN
;


: START-TIME? NUM-PASS 0= ;

: TEST-NODE ( Node --?)
    TO CUR-NODE
    TEST-NODE-TIME ?DUP 0=
    IF RUN-MISSED? THEN
    DBG( test-prev&next )
;

: START-TASK
    START
    [ DEBUG? ] [IF] DUP S>D <# #S S" Thread handle is " HOLDS #> CRON-LOG [THEN]
    ?DUP IF CLOSE-FILE DROP THEN ;
\ : START-TASK START ?DUP IF CloseHandle THEN ;



: INIT-ACTION
    SP@ S0 !
    APP-Dir 0!
;


VARIABLE AsLoggedUser
USER SU-TOKEN

: LOGON-NODE  ( -- )
    SU-TOKEN 0!
    AsLoggedUser @ 0<> WinNT? AND
    IF
        AsLoggedOk OFF
        ( GetTrayToken)
        GetCurrentUserToken
        0=
        IF
            ?DUP
            IF
                AsLoggedOk ON
                SU-TOKEN !
                SU-TOKEN @ ImpersonateLoggedOnUser DROP
                WinXP? 0= IF TRUE SU-TOKEN @ LoadUserProfile THEN
            THEN
        ELSE
            DROP
        THEN
    THEN
;

: LOGOFF-NODE
    SU-TOKEN @ ?DUP
    IF
        RevertToSelf DROP
        WinXP? 0= IF DUP UnloadUserProfile THEN
        CLOSE-FILE DROP
    THEN
;

: WRITE-EXEC-TIME
    tiBegin&Find
    IF
        FT-CUR FT>DD.MM.YYYY/hh:mm:ss   TI-EXECUTION-TIME   tiTable fput
        STRUE                           TI-FLAG-SUCCESS     tiTable fput
        \                               tiWRITE
    THEN
    tiEnd
;

: EXEC-ACTION ( NODE -- )
    DECIMAL
    TO CUR-NODE
    INIT-ACTION
    CSP!
    CUR-NODE CRON-ACTION @ ?DUP
    IF
        LOGON-NODE
        WRITE-EXEC-TIME
        CATCH DUP TO ERR-CODE
        IF
          DROP
          CUR-NODE CRON-FLAG-ERROR SET-CRON-FLAG
          S" Internal err # %ERR-CODE N>S%:" CUR-NODE LOG-NODE
        THEN
        LOGOFF-NODE
    THEN
    S" TASK STACK ERROR" CSP?
    CSP-DIFF IF  S" Stack error in task:" CUR-NODE LOG-NODE THEN
;

' EXEC-ACTION TASK: EXEC-ACTION-TASK

USER-VALUE COMMAND-RESULT
USER-CREATE COMMAND-STRING 2 CELLS USER-ALLOT
USER EXEC-PATH

(
USER-VALUE SH_EXE_INF

: FILL-FOR-SHELL-EXEC
    /SHELLEXECUTEINFO ALLOCATE THROW TO SH_EXE_INF
    SH_EXE_INF /SHELLEXECUTEINFO ERASE
    COMMAND-STRING 2@ DROP SH_EXE_INF sei_lpFile !
    APP-Dir @ SH_EXE_INF sei_lpDirectory !
    CUR-NODE CRON-si wShowWindow W@ SH_EXE_INF sei_nShow !
;
)
: start-app SU-TOKEN @ ?DUP IF StartAppAsUser ELSE StartApp THEN ;

: app-quote  COMMAND-STRING 2@ S"  " SEARCH NIP NIP IF QUOTE ELSE S" " THEN ;  \ "

WINAPI: FindExecutableA SHELL32.DLL

: [missed] CUR-NODE CRON-IS-MISSED @ IF S"  [missed]" ELSE S" " THEN ;

: (START-APP) ( addr u -- )
    [ DEBUG? ] [IF] ." START-APP: " 2DUP TYPE CR [THEN]
    OVER C@ NoLogPrefix = IF TRUE TO NO-LOG 1 /STRING THEN
    OVER C@ [CHAR] ! =
    IF  1 /STRING EVAL-SUBST
        2DUP ?CRON-LOG
        ['] EVALUATE CATCH IF 2DROP THEN
        EXIT
    THEN
\    2DUP ?CRON-LOG
    EVAL-SUBST DUP CELL+ ALLOCATE THROW >R R@ SWAP 1+ CMOVE
    R> ASCIIZ> COMMAND-STRING 2!
\    FILL-FOR-SHELL-EXEC
    ALL>ENV
    S" Start%[missed]%: %COMMAND-STRING 2@%" ?CRON-LOG
    CUR-NODE CRON-APP-Flags @ APP-Flags !
    CUR-NODE CRON-si
    COMMAND-STRING 2@ \ ." Run: " 2DUP TYPE CR
    start-app
    0=
    IF
      GetLastError
      [ DEBUG? ] [IF] ." StartApp ERROR # " DUP . CR [THEN]
\      SH_EXE_INF R@ IF ShellStartAppWait ELSE ShellStartApp THEN
      1024 ALLOCATE THROW DUP EXEC-PATH !
      0 COMMAND-STRING 2@ DROP FindExecutableA DUP 32 >
      IF DROP \ Found
        CUR-NODE CRON-si
        S" %EXEC-PATH @ ASCIIZ>% %app-quote%%COMMAND-STRING 2@%%app-quote%" EVAL-SUBST
        start-app IF DROP 0 THEN
      ELSE
        [ DEBUG? ] [IF] ." FindExecutable ERROR # " DUP . CR [THEN]
        DROP
        CUR-NODE CRON-si
        S" %ComSpec% /c %COMMAND-STRING 2@%" EVAL-SUBST
        start-app IF DROP 0 THEN
      THEN
      EXEC-PATH @ FREE THROW
    ELSE 0 THEN
    TO COMMAND-RESULT
    S" Start result: %COMMAND-RESULT N>S%" ?CRON-LOG
    COMMAND-STRING 2@ DROP FREE DROP
\    SH_EXE_INF FREE DROP
    RDROP
;


: START-APP (START-APP) ;

: to-eol BL SKIP 1 PARSE ( ." Command line: " 2DUP TYPE CR) ;
: to-eol, to-eol POSTPONE XSLITERAL ;
: START-APP:  to-eol, POSTPONE START-APP ; IMMEDIATE

(
: S?
    2>R ?DUP
    IF 2R> TYPE SPACE COUNT TYPE CR
    ELSE 2R> 2DROP THEN
;

: VIEW-CRON-NODE \ NODE --
    TO CUR-NODE
    CUR-NODE CRON-NAME      @ S" Name:"     S?
    CUR-NODE CRON-MIN       @ S" Min:"      S?
    CUR-NODE CRON-HOUR      @ S" Hour:"     S?
    CUR-NODE CRON-DAY       @ S" Day:"      S?
    CUR-NODE CRON-WDAY      @ S" WDay:"     S?
    CUR-NODE CRON-MON       @ S" Mon:"      S?
    CUR-NODE CRON-YEAR      @ S" Year:"     S?
\    CUR-NODE CRON-COMMAND   @ S" Command:"  S?
\    CUR-NODE CRON-INTERNAL
\    CUR-NODE CRON-RULE
;

: .NODES
    CRON-LIST @ TO CUR-POS
    BEGIN CUR-POS WHILE
      CUR-POS VIEW-CRON-NODE
      CUR-POS CRON-NEXT @ TO CUR-POS
    REPEAT
;
)

: N? BL WORD SWAP N-TEST 0= IF ." Not " THEN ." OK" CR ;

: CRON-TEST-NODE ( NODE -- )
    TO CUR-NODE
    CUR-NODE TEST-NODE
    IF
        CUR-NODE CRON-ACTION @
        IF
            CUR-NODE EXEC-ACTION-TASK START-TASK
        THEN
    THEN
;

: CRON-TEST
    CRON-LIST @ TO CUR-POS
    BEGIN CUR-POS WHILE
      CUR-POS CRON-TEST-NODE
      CUR-POS CRON-NEXT @ TO CUR-POS
    REPEAT
    NUM-PASS 1+ TO NUM-PASS
;


: BLANK-LINE?
    >IN @ >R
    BL WORD DUP C@
    IF 1+ C@ [CHAR] # =
    ELSE DROP TRUE THEN
    R> >IN !
;

: SKIP-LINE 1 WORD DROP ;

VARIABLE NUM-TASK
: CRON-VALUE! ( char Addr --)
        SWAP WORD DUP C@
        IF DUP 1+ C@ [CHAR] * - OVER C@ 1 > OR
           IF HERE ROT ! ", 0 C,        \ "
           ELSE
             DROP 0!
           THEN
        ELSE
           DROP 0!
        THEN ;

: ClassicTime
     PeekChar RunMissedPrefix =
     IF RunMissedPrefix SKIP
         DefMissed @ CRON-NODE CRON-MISSED !
     THEN
     POSTPONE M:
     POSTPONE H:
     POSTPONE D:
     POSTPONE MON:
     POSTPONE W:
     YearField @ IF POSTPONE Y: THEN

\     BL CRON-TIME CRON-MIN   CRON-VALUE!
\     BL CRON-TIME CRON-HOUR  CRON-VALUE!
\     BL CRON-TIME CRON-DAY   CRON-VALUE!
\     BL CRON-TIME CRON-MON   CRON-VALUE!
\     BL CRON-TIME CRON-WDAY  CRON-VALUE!
\     BL CRON-TIME CRON-YEAR  CRON-VALUE!
;

: AddTime ( -- )
    HERE >R
    /CRON-TIME ALLOT
    CRON-TIME R@ /CRON-TIME CMOVE
    CRON-NODE CRON-TIME-LIST @  R@ CRON-NEXT-TIME !
    R> CRON-NODE CRON-TIME-LIST !
    CRON-TIME /CRON-TIME ERASE
;
: TIME0?
    CRON-TIME CRON-MIN   @ 0=
    CRON-TIME CRON-HOUR  @ 0= AND
    CRON-TIME CRON-DAY   @ 0= AND
    CRON-TIME CRON-WDAY  @ 0= AND
    CRON-TIME CRON-MON   @ 0= AND
    YearField IF CRON-TIME CRON-YEAR  @ 0= AND THEN
;

VARIABLE LAST-TASK

: :TASK
    end-def
    CRON-NODE0!
    CREATE
    HERE 0 , LAST-TASK !
    LATEST CRON-NODE CRON-NAME !
    [COMPILE] [ ; IMMEDIATE \ ]


: TASK;
   end-def
   CRON-NODE CRON-ACTION @
   IF
\     ." End task: " CRON-NODE CRON-NAME @ COUNT TYPE CR
     AddTime
\     CUR-TAB-FILENAME CRON-NODE CRON-FILENAME !
     HERE >R /CRON-NODE ALLOT
     R@ LAST-TASK @ !
     CRON-NODE R@ /CRON-NODE CMOVE
     CRON-LIST @ R@ CRON-LIST !
     R@ CRON-NEXT !
     R@ renewTI
     RDROP
   THEN
;

: CLASSIC-TASK
    NUM-TASK 1+!
    NUM-TASK @ S>D <# #S S" :TASK TASK-#-" HOLDS #> EVALUATE
    ClassicTime
    POSTPONE Action:
    POSTPONE START-APP:
    TASK;
;

: TAB>BL OVER + SWAP ?DO I C@ 9 = IF BL I C! THEN LOOP ;

: Classic:
    BLANK-LINE? 0=
    IF
        BL SKIP
        SOURCE DROP >IN @ + 4 S" SET " COMPARE 0=
        IF
            1 PARSE EVALUATE
        ELSE
            CLASSIC-TASK
        THEN
    THEN
    SKIP-LINE
;

