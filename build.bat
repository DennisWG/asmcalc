@echo off
echo Build script started executing at %time% ...

REM Process command line arguments. Default is to build in release configuration.
set BuildType=%1
if "%BuildType%"=="" (set BuildType=release)

set ProjectName=%2
if "%ProjectName%"=="" (set ProjectName=hello_world)

set BuildExt=%3
if "%BuildExt%"=="" (set BuildExt=exe)

set AdditionalLinkerFlags=%4

echo Building %ProjectName% in %BuildType% configuration...

if not defined DevEnvDir (
    call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
)

set BuildDir=%~dp0build

if "%BuildType%"=="clean" (
    setlocal EnableDelayedExpansion
    echo Cleaning build from directory: %BuildDir%. Files will be deleted^^!
    echo Continue ^(Y/N^)^?
    set /p ConfirmCleanBuild=
    if "!ConfirmCleanBuild!"=="Y" (
        echo Removing files in %BuildDir%...
        del /s /q %BuildDir%\*.*
    )
    goto end
)

echo Building in directory: %BuildDir% ...

if not exist %BuildDir% mkdir %BuildDir%
pushd %BuildDir%

if not exist %BuildDir% mkdir %BuildDir%
pushd %BuildDir%

set EntryPoint="%~dp0src\%ProjectName%.asm"

set IntermediateObj=%BuildDir%\%ProjectName%.obj
set OutBin=%BuildDir%\%ProjectName%.%BuildExt%

set CommonCompilerFlags=-f win64 -I%~dp0 -l "%BuildDir%\%ProjectName%.lst"
set DebugCompilerFlags=-gcv8

if "%BuildExt%"=="exe" (
    set BinLinkerFlagsMSVC=/subsystem:console /entry:main
) else (
    set BinLinkerFlagsMSVC=/dll
)

set CommonLinkerFlagsMSVC=%BinLinkerFlagsMSVC% /defaultlib:ucrt.lib /defaultlib:msvcrt.lib /defaultlib:legacy_stdio_definitions.lib /defaultlib:Kernel32.lib /defaultlib:Shell32.lib /nologo /incremental:no
set DebugLinkerFlagsMSVC=/opt:noref /debug /pdb:"%BuildDir%\%ProjectName%.pdb"
set ReleaseLinkerFlagsMSVC=/opt:ref

if "%BuildType%"=="debug" (
    set CompileCommand=nasm %CommonCompilerFlags% %DebugCompilerFlags% -o "%IntermediateObj%" %EntryPoint%
    set LinkCommand=link "%IntermediateObj%" %CommonLinkerFlagsMSVC% %DebugLinkerFlagsMSVC% %AdditionalLinkerFlags% /out:"%OutBin%"
) else (
    set CompileCommand=nasm %CommonCompilerFlags% -o "%IntermediateObj%" %EntryPoint%
    set LinkCommand=link "%IntermediateObj%" %CommonLinkerFlagsMSVC%  %ReleaseLinkerFlagsMSVC% %AdditionalLinkerFlags% /out:"%OutBin%"
)

echo.
echo Compiling (command follows below)...
echo %CompileCommand%

%CompileCommand%

if %errorlevel% neq 0 goto error

echo.
echo Linking (command follows below)...
echo %LinkCommand%

%LinkCommand%

if %errorlevel% neq 0 goto error
if %errorlevel% == 0 goto success

:error
echo.
echo ***************************************
echo *      !!! An error occurred!!!       *
echo ***************************************
popd
goto end


:success
echo.
echo ***************************************
echo *    Build completed successfully!    *
echo ***************************************
goto end


:end
echo.
echo Build script finished execution at %time%.
popd
popd
exit /b %errorlevel%