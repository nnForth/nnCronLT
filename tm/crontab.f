REQUIRE AppendNode ~nn/lib/list.f

: cron.tab S" cron.tab" ;

VARIABLE last-line
VARIABLE crontab-list
VARIABLE task-list

: crontab-pre
    SOURCE S>ZALLOC crontab-list AppendNode
    BL SKIP
    GetChar 
    IF [CHAR] # <>
       IF
         crontab-list 
         BEGIN DUP @ ?DUP WHILE NIP REPEAT
         task-list AppendNode
       ELSE 
       THEN
       1 WORD DROP
    ELSE DROP THEN 
;

: load-crontab
    ['] <PRE> BEHAVIOR >R
    ['] crontab-pre TO <PRE>
    cron.tab ['] INCLUDED CATCH R> TO <PRE>
        IF 2DROP THEN
;