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

rem Set up ReSampler parameters.
set "ReSamplerParams=-r 44100 -b 16 --steepLPF --dither --showStages --tempDir F:\aui_cache"

rem Process each supported file in the source path and
rem resample it to the target path, preserving the directory
rem structure of the source path in the target path.
for /R "%SourcePath%" %%I in (*.flac) do (
    set "RelativePath=%%~dpI"
    set "RelativePath=!RelativePath:~%PathLength%,-1!"
    md "%TargetPath%!RelativePath!" 2>nul

    rem Run ReSampler on the input file and write the output to the target path.
    echo Resampling "%%~nxI"...
    C:\ReSampler\ReSampler -i "%%I" -o "%TargetPath%!RelativePath!/%%~nxI" %ReSamplerParams%
    if %errorlevel% neq 0 (
        echo ERROR: Failed to resample "%%~nxI".
    )
)

echo Resampling complete.
endlocal
