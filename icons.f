S" rc\nncron32x32-16.ico" EVAL-SUBST R/O OPEN-FILE THROW 
DUP I32 22   ROT READ-FILE THROW DROP
DUP I32 744  ROT READ-FILE THROW DROP CLOSE-FILE DROP

S" rc\nncron16x16-16.ico" EVAL-SUBST R/O OPEN-FILE THROW 
DUP I16 22  ROT READ-FILE THROW DROP
DUP I16 296 ROT READ-FILE THROW DROP CLOSE-FILE DROP
