@echo off

REM ============================================
REM =                                          =
REM =   The simple run file for this project   =
REM =                                          =
REM ============================================

REM This is a simple run file to run the target excutable file for this project.
REM This script will start a new CMD window to run the target excutable file.

REM Parameters:
REM - %1: (Optional) The specified name of the target file


REM ==================
REM = Configurations =
REM ==================

SETLOCAL

REM The command to call the configuration file
call .\config.bat

REM The specific name of the target file (if exist)
if "%~1" neq "" (
    SET TARGET_NAME=%1
)


REM ================
REM = Run Commands =
REM ================

REM TODO: Other initialization?
REM The command to run the target excutable file
start cmd @cmd /k "@%OUTPUT_PATH%%TARGET_NAME%&@exit"


REM ==================
REM = Ending Process =
REM ==================

:terminate
if %END_PAUSE% == 1 (
    pause
)

ENDLOCAL
