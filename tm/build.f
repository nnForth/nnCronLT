\ REQUIRE ~nn/lib/build.f
0 VALUE #BUILD-CRON

: GET-CRON-BUILD
    S" ..\build.txt" R/O OPEN-FILE THROW >R
    PAD 10 R@ READ-LINE THROW DROP
    PAD SWAP S>NUM TO #BUILD-CRON
    R> CLOSE-FILE DROP
;

GET-CRON-BUILD