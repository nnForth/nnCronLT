REQUIRE XSLITERAL ~nn/lib/longstr.f

: s,  ( a u -- a1 ) HERE >R DUP C, HERE SWAP DUP ALLOT CMOVE 0 C, R> ;
: xs, ( a u -- a1 ) HERE >R DUP , HERE SWAP DUP ALLOT CMOVE 0 C, R> ;
: string, get-string [COMPILE] XSLITERAL ;
: eval-string, string, POSTPONE EVAL-SUBST ;


: MessageBox ( flags S" Message" -- result)
    DROP SWAP MB_SYSTEMMODAL OR SWAP ServiceName DROP SWAP 0 MessageBoxA 
;

: N>S ( u -- addr u)  DUP >R ABS S>D <# #S R> SIGN #> ;
: N>H BASE @ >R HEX N>S R> BASE ! ;
: MsgBox ( addr u --)
         MB_OK MB_ICONINFORMATION OR ROT ROT MessageBox DROP ;
: ErrMsgBox ( a u -- )
    MB_OK MB_ICONSTOP ( MB_ICONEXCLAMATION) OR ROT ROT MessageBox DROP ;

\ : SKIP-CHAR ( addr u -- addr1 u1) 1 /STRING ;