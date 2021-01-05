@echo off

REM =============================================
REM =                                           =
REM =   The simple make file for this project   =
REM =                                           =
REM =============================================

REM This is a simple make file to compile and link files for this project.
REM One of major purposes is trying to be independent from outside.

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


REM ==================
REM = Build Commands =
REM ==================

REM The command to compile (but not link) the target file to the object file
%MASM%ML /Fo %OBJECT_PATH%%TARGET_NAME%.obj /c /coff /Zi %TARGET_PATH%%TARGET_NAME%.asm
if errorlevel 1 goto terminate

REM The command to link the target object file to the excutable file
if %GEN_PDB% == 1 (
    %MASM%LINK /INCREMENTAL:no /debug /pdb:%OUTPUT_PATH%%TARGET_NAME%.pdb /subsystem:console /entry:%PROGRAM_ENTRY% /out:%OUTPUT_PATH%%TARGET_NAME%.exe %OBJECT_PATH%%TARGET_NAME%.obj
) ^
else (
    %MASM%LINK /INCREMENTAL:no /subsystem:console /entry:%PROGRAM_ENTRY% /out:%OUTPUT_PATH%%TARGET_NAME%.exe %OBJECT_PATH%%TARGET_NAME%.obj
)
if errorlevel 1 goto terminate


REM ======================
REM = Print Informations =
REM ======================

REM The commands to print the associated generated files
if %LOG_INFO_FILES% == 1 (
    DIR %TARGET_PATH%%TARGET_NAME%*
    DIR %OBJECT_PATH%%TARGET_NAME%*
    DIR %OUTPUT_PATH%%TARGET_NAME%*
)


REM ==================
REM = Ending Process =
REM ==================

:terminate
if %END_PAUSE% == 1 (
    pause
)

ENDLOCAL
