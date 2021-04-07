\ REQUIRE EVAL-SUBST ~nn/lib/subst.f

USER-CREATE CUR-FILE-NAME 2 CELLS USER-ALLOT
VECT FILE-ERR
: (FILE-ERR) ( a u -- )
    ." FILE ERROR (" CUR-FILE-NAME 2@ TYPE ." ): " TYPE CR
;

' (FILE-ERR) TO FILE-ERR

: DROP-RIGHT-DIR ( a u -- a u1 true | -- false)
    OVER +
    BEGIN  1- 2DUP <  WHILE 
      DUP C@ [CHAR] \ =
      IF
        OVER -
        TRUE EXIT
      THEN
    REPEAT
    2DROP FALSE
;

: ERROR_PATH_NOT_FOUND? ( ior -- ?)
    ERROR_PATH_NOT_FOUND = ;

: MAKE-DIR ( a u -- ior)
    S>ZALLOC >R
    0
    R@ CreateDirectoryA ERR \ DUP .
    DUP IF DUP ERROR_ALREADY_EXISTS = IF DROP 0 THEN THEN
    R> FREE THROW
;

: MAKE-DIRS { a u -- ior }
    a u MAKE-DIR ?DUP 0= IF 0 EXIT THEN
    DUP ERROR_PATH_NOT_FOUND? 
    IF DROP
       a u DROP-RIGHT-DIR
       IF
          RECURSE DUP 0=
          IF DROP  a u MAKE-DIR THEN
       ELSE
         ERROR_BAD_PATHNAME
       THEN
    THEN
;

: MAKE-FILE ( a u mode -- handle ior)
    >R
    2DUP R@ CREATE-FILE-SHARED DUP
    ERROR_PATH_NOT_FOUND =
    IF 2DROP
       2DUP DROP-RIGHT-DIR 
       IF
           MAKE-DIRS ?DUP 0=
           IF R@ CREATE-FILE-SHARED
           ELSE ( a u ior -- ) NIP NIP 0 SWAP THEN
       ELSE 2DROP 0 ERROR_BAD_PATHNAME THEN
    ELSE
        2SWAP 2DROP
    THEN
    RDROP
;

: OPEN/CREATE-FILE ( a u mode -- handle ior)
    >R
    2DUP R@ OPEN-FILE-SHARED
    IF DROP
       R@ MAKE-FILE
    ELSE 
        >R 2DROP R> 0
    THEN
    RDROP
;

