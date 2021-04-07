: ThreadId GetCurrentThreadId ;

\ : QUOTE S" '" [ CHAR " HERE 2- C! ] COUNT ;
\ : PERCENT S" %" ;

0 [IF]
VARIABLE LAST-TICK
VARIABLE TMP-CNT

: (TempFile) ( Tick -- addr u)
  S>D
  <# #S 2DROP [CHAR] . HOLD
     GetCurrentThreadId S>D #S 2DROP [CHAR] . HOLD
     TMP-CNT 1+! TMP-CNT @ S>D #S
  #> ;

: TempFile ( -- addr u)
    GetTickCount DUP LAST-TICK ! (TempFile) ;

: PrevTempFile ( -- addr u )
    -1 TMP-CNT +! LAST-TICK @ (TempFile) ;


[THEN]

: INCLUDE get-string 2DUP + 0 SWAP C! INCLUDED ;

