@echo off
setlocal EnableExtensions EnableDelayedExpansion
set "SourcePath=X:\ReSampler\"
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
for /R "%SourcePath%" %%I in (*.flac) do (
    set "RelativePath=%%~dpI"
    set "RelativePath=!RelativePath:~%PathLength%,-1!"
    md "%TargetPath%!RelativePath!" 2>nul
Saracon.exe "%%I" -t "%TargetPath%!RelativePath!" -c p2p -r 48000 -d off -f flac -n 24bit -b normal -g -1.0 "%%I"
rem	Saracon.exe "%%I" -t "%TargetPath%!RelativePath!" -c p2p -r 88200 -d off -f flac -n 24bit -b normal -g -1.0 "%%I"
rem	Saracon.exe "%%I" -t "%TargetPath%!RelativePath!" -c p2p -r 96000 -d off -f flac -n 24bit -b normal -g -1.0 "%%I"
rem	Saracon.exe "%%I" -t "%TargetPath%!RelativePath!" -c p2p -r 176400 -d off -f flac -n 24bit -b normal -g -1.0 "%%I"
rem	Saracon.exe "%%I" -t "%TargetPath%!RelativePath!" -c p2p -r 192000 -d off -f flac -n 24bit -b normal -g -1.0 "%%I"
rem	Saracon.exe "%%I" -t "%TargetPath%!RelativePath!" -c p2p -r 352800 -d off -f flac -n 24bit -b normal -g -1.0 "%%I"
rem	Saracon.exe "%%I" -t "%TargetPath%!RelativePath!" -c p2p -r 384000 -d off -f flac -n 24bit -b normal -g -1.0 "%%I"
rem Saracon.exe "%%I" -t "%TargetPath%!RelativePath!" -c p2p -r 44100 -d powr2 -f flac -n 16bit -b normal -g -1.0 "%%I"
rem Saracon.exe "%%I" -t "%TargetPath%!RelativePath!" -c p2p -r 44100 -d powr1 -f flac -n 16bit -b normal -g -1.0 "%%I"
rem Saracon.exe "%%I" -t "%TargetPath%!RelativePath!" -c p2p -r 44100 -d powr3 -f flac -n 16bit -b normal -g -1.0 "%%I"
rem Saracon.exe "%%I" -t "%TargetPath%!RelativePath!" -c p2p -r 44100 -d tpdf -f flac -n 16bit -b normal -g -1.0 "%%I"
rem	Saracon.exe "%%I" -t "%TargetPath%!RelativePath!" -c p2d -r 2822400 -d off -f dff -b normal -g -1.0 "%%I"
    
)
endlocal
