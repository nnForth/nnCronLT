if not exist manager.exe goto exit

copy res\*.txt ..\res\
copy manager.exe ..
rem copy manager.exe ..\release

:exit