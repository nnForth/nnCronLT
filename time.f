REQUIRE { ~nn/lib/locals.f

S" LIB\EXT\FACIL.F" INCLUDED

CREATE LTIME /SYSTEMTIME ALLOT

: GET-CUR-TIME LTIME GetLocalTime DROP ;
: Min@ LTIME wMinute W@ ;
: Hour@ LTIME wHour W@ ;
: Sec@ LTIME wSecond W@ ;
: Day@ LTIME wDay W@ ;
: Mon@ LTIME wMonth W@ ;
: Year@ LTIME wYear W@ ;
: WDay@ LTIME wDayOfWeek W@ ?DUP 0= IF 7 THEN ;

: TimeMin@ ( -- CurrentTime_in_minutes)  Hour@ 60 * Min@ + ;
: TimeSec@ ( -- Time_in_seconds) TimeMin@ 60 * Sec@ + ;

CREATE MON-LENGTH 31 C, 28 C, 31 C, 30 C, 31 C, 30 C,
                  31 C, 31 C, 30 C, 31 C, 30 C, 31 C, 
: MonLength ( year month -- days-of-month )
    DUP 2 =
    IF
        DROP
        4 MOD 0= IF 29 ELSE 28 THEN
    ELSE
        NIP 1- MON-LENGTH + C@ 
    THEN
;

: DAYS ( y m d -- days)
\  оличество дней от начала летоисчислени€ по григорианскому календарю
    SWAP DUP 2 > IF 1+ ELSE 13 + ROT 1- ROT ROT THEN
    306 * 10 / + SWAP 36525 * 100 / +
;

: Days@ Year@ Mon@ Day@ DAYS ;

CREATE WDAYS C" SunMonTueWedThuFriSat" ", 
CREATE MONNAMES C" JunFebMarAprMayJunJulAugSepOctNovDec" ",

: YMD>DATE ( y m d -- u)  SWAP 5 LSHIFT + SWAP 9 LSHIFT + ;
: DATE>YMD ( u -- y m d)
    DUP 9 RSHIFT SWAP
    DUP 5 RSHIFT 15 AND SWAP
    31 AND ;
