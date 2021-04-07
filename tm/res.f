REQUIRE StrRes ~nn/lib/strres.f
REQUIRE PLACE lib/ext/string.f

StrRes OBJECT: res

: RES! ( a u -- )
    res Load
;
: DefRES S" res/english.txt" ;

: RES ( # -- a u )
    res filename @ 0= IF DefRES res Load THEN 
    res Get
;    


0 VALUE RES-INIT
: resPAD PAD 256 + ;
: set-lang
    S" res\" resPAD  PLACE
    NextWord resPAD +PLACE
    S" .txt" resPAD +PLACE
    resPAD COUNT +ModuleDirName
    RES!
    TRUE TO RES-INIT
;

: Language: set-lang ;