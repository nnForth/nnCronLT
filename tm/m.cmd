@echo off
call ..\ver
set SPForthProject=release

call spf manager.f

call copy1.cmd