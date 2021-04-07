

-1 CONSTANT INFINITE

0 VALUE LOG-MUTEX
0 VALUE LOG-FILE

: OPEN/CREATE ( a u -- h )
    2DUP R/W OPEN-FILE-SHARED
    IF  DROP
        R/W CREATE-FILE-SHARED THROW
    ELSE >R 2DROP R>
    THEN
;
: LOG-WR ( a # --)  LOG-FILE WRITE-FILE THROW ;

: LOG-CR LT LTL @ LOG-WR ;

CREATE WDAYS C" SunMonTueWedThuFriSat" ", 

\ : HOLDS ( A # --) OVER + 1- DO I C@ HOLD -1 +LOOP ;

: (LOG-TIME) ( -- addr u)
    GET-CUR-TIME
    <#
        BL HOLD
        Sec@  S>D # #       2DROP [CHAR] : HOLD
        Min@  S>D # #       2DROP [CHAR] : HOLD
        Hour@ S>D # #       2DROP BL       HOLD
        Year@ S>D # # # #   2DROP [CHAR] / HOLD
        Mon@  S>D # #       2DROP [CHAR] / HOLD
        Day@  S>D # #
        WDay@ 3 * WDAYS 1+ + 3 HOLDS
    #>
;
VECT LOG-TIME
' (LOG-TIME) TO LOG-TIME

: GET-LOG-MUTEX
    LOG-MUTEX 0=
    IF
        GetCurrentProcessId S>D
        <# 0 HOLD #S S" NNCronLogMutex" HOLDS #> \ 2DUP TYPE CR
        FALSE CREATE-MUTEX THROW TO LOG-MUTEX
    THEN
    INFINITE LOG-MUTEX WAIT THROW DROP
;

: (LOG) ( a # a-file #-file --)
\        CR .S CR
\        ." log file:" 2DUP TYPE CR
\            2DUP MsgBox
\        ." log text:" 2OVER TYPE CR
\            2OVER MsgBox
         GET-LOG-MUTEX
            OPEN/CREATE TO LOG-FILE
            LOG-FILE FILE-SIZE THROW
            LOG-FILE REPOSITION-FILE THROW
            LOG-TIME LOG-WR S"  " LOG-WR
            LOG-WR LOG-CR
            LOG-FILE CLOSE-FILE THROW
         LOG-MUTEX RELEASE-MUTEX THROW
\        LOG-MUTEX CloseHandle DROP 
\        S" After LOG" MsgBox
;

\ : (LOG2) ( a # a-file #-file --)
\          GET-LOG-MUTEX
\             OPEN/CREATE TO LOG-FILE
\             LOG-FILE FILE-SIZE THROW
\             LOG-FILE REPOSITION-FILE THROW
\             LOG-WR LOG-CR
\             LOG-FILE CLOSE-FILE THROW
\          LOG-MUTEX RELEASE-MUTEX THROW
\ ;

: LOGGING ( A1 #1 A2 #2 xt -- )
    CATCH
    IF 2DROP 2DROP
        GetLastError ." Log error # " . CR
    THEN ;
: LOG  ( A1 #1 A2 #2 -- ) ['] (LOG) LOGGING ;
\ : LOG2  ['] (LOG2) LOGGING ;
