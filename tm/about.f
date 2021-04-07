REQUIRE EVAL-SUBST ~nn/lib/subst1.f

VARIABLE <SVC-BUILD>

: SVC-BUILD
    <SVC-BUILD> @
    IF
        S" \cron.exe %<SVC-BUILD> @ ASCIIZ>%" EVAL-SUBST
    ELSE
        S"  "
    THEN ;

: (About)
    S" System command scheduler by Nicholas Nemtsev\%SVC-BUILD%\manager.exe v %SVERSION%\ \mailto:nemtsev@nncron.ru\http://www.nncron.ru"
    EVAL-SUBST
    (Message)
;

: About
    <SVC-BUILD> 0!
    BL SKIP 1 PARSE ?DUP IF S>ZALLOC <SVC-BUILD> ! ELSE DROP THEN
    (About)
    BYE
;
