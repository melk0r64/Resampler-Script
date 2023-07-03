@echo off
setlocal EnableExtensions EnableDelayedExpansion
set "SourcePath=F:\FLAC_ALBUM\"
set "TargetPath=E:\ReSampler_44100\"

rem If the batch file was started with a string as
rem parameter, interpret this string as source path.
if not "%~1" == "" set "SourcePath=%~1"

rem If the batch file was started with one more string
rem as parameter, interpret this string as target path.
if not "%~2" == "" set "TargetPath=%~2"

rem Remove backslash at end of source and target path
rem in case of being specified with a backslash at end.
if "%SourcePath:~-1%" == "\" set "SourcePath=%SourcePath:~0,-1%"
if "%TargetPath:~-1%" == "\" set "TargetPath=%TargetPath:~0,-1%"

rem Determine length of source path by finding out at which
rem position in source path there is no more character.
set "PathLength=1"
:GetPathLength
if not "!SourcePath:~%PathLength%,1!" == "" (
    set /A PathLength+=1
    goto GetPathLength
)

rem Process each file not having hidden or system attribute set and
rem decrypt it to the target path relative to source path. The relative
rem path is determined by removing from full path of current file the
rem first PathLength characters and the last character which is the
rem directory separator (backslash).

set "MAX_PROCESSES=4"
set "PROCESS_COUNTER=0"

for /R "%SourcePath%" %%I in (*.flac) do (
    set "RelativePath=%%~dpI"
    set "RelativePath=!RelativePath:~%PathLength%,-1!"
    md "%TargetPath%!RelativePath!" 2>nul

    set "COMMAND=C:\ReSampler\ReSampler -i "%%I" -o "%TargetPath%!RelativePath!/%%~nxI" -r 48000 -b 24 --minphase --relaxedLPF --showStages --tempDir c:\Temp"

    rem Launch the resampler tool in a separate process
    START /B CMD /C "%COMMAND%"

    set /A PROCESS_COUNTER+=1
    if !PROCESS_COUNTER! geq !MAX_PROCESSES! (
        rem Wait for any of the launched processes to finish before launching more
        CALL :COUNT_FOR_PROCESS
    )
)

:WAIT_FOR_PROCESS
rem Wait for one process to finish
PING -n 2 127.0.0.1 >NUL
for /f "tokens=3" %%a in ('TASKLIST /FI "WINDOWTITLE eq C:\ReSampler\ReSampler.exe" /NH') do (
    if "%%a" == "C:\ReSampler\ReSampler.exe" (
        rem There is still at least one instance of the resampler tool running
        goto :WAIT_FOR_PROCESS
    )
)
set "PROCESS_COUNTER=0"
exit /B
goto :EOF

REM use trick from https://devblogs.microsoft.com/oldnewthing/20110825-00/?p=9803
:COUNT_FOR_PROCESS
echo Wait untill at least one processes finish
rem Wait untill at least one processes finish
C:\Windows\System32\timeout.exe /T !TIMEOUT! /nobreak 
set IMAGENAME=ReSampler.exe
set /A RUNNING_PPOCESS_COUNT=0
for /f "tokens=1" %%_ in ('tasklist.exe /FI "IMAGENAME eq !IMAGENAME!" /NH ^| C:\Windows\System32\find.exe "!IMAGENAME!" ^|C:\Windows\System32\find.exe/c /v "" ') do (
    set /A RUNNING_PPOCESS_COUNT=%%_
    echo !RUNNING_PPOCESS_COUNT! !IMAGENAME! is running
    if !RUNNING_PPOCESS_COUNT! equ !MAX_PROCESSES! (
       goto :COUNT_FOR_PROCESS
    )
)
set /A "PROCESS_COUNTER=!RUNNING_PPOCESS_COUNT!"
echo set PROCESS_COUNTER to !PROCESS_COUNTER!
exit /B
