@ECHO OFF

rem Check for the help switches
IF /I "%~1"=="help"   GOTO SHOWHELP
IF /I "%~1"=="/help"  GOTO SHOWHELP
IF /I "%~1"=="-help"  GOTO SHOWHELP
IF /I "%~1"=="--help" GOTO SHOWHELP
IF /I "%~1"=="/?"     GOTO SHOWHELP

IF DEFINED MINGW32 GOTO VarOk
ECHO ERROR: Please define MINGW32 (and/or MSYS) environment variable(s)
EXIT /B

:VarOk
SET PATH=%MSYS%\bin;%MINGW32%\bin;%PATH%
SET "make_args=-j4"
IF /I "%~2" == "Debug" SET "make_args=DEBUG=yes %make_args%"

IF "%~1" == "" (
  SET "BUILDTYPE=build"
) ELSE (
  IF /I "%~1" == "Build" (
    SET "BUILDTYPE=build"
    CALL :SubMake %make_args%
    EXIT /B
  )

  IF /I "%~1" == "Clean" (
    SET "BUILDTYPE=clean"
    CALL :SubMake clean -j1
    EXIT /B
  )

  IF /I "%~1" == "Rebuild" (
    SET "BUILDTYPE=rebuild"
    CALL :SubMake clean -j1
    CALL :SubMake %make_args%
    EXIT /B
  )

  ECHO.
  ECHO Unsupported commandline switch!
  ECHO Run "%~nx0 help" for details about the commandline switches.
  EXIT /B
)


:SubMake
TITLE "make.exe %*"
ECHO make.exe %*
make.exe %*
EXIT /B


:SHOWHELP
TITLE "%~nx0 %1"
ECHO. & ECHO.
ECHO Usage:   %~nx0 [Clean^|Build^|Rebuild] [Debug]
ECHO.
ECHO Notes:   The arguments are not case sensitive.
ECHO. & ECHO.
ECHO Executing "%~nx0" will use the defaults: "%~nx0 build"
ECHO.
ENDLOCAL
EXIT /B
