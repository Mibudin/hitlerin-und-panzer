@echo off

REM =============================================
REM =                                           =
REM =   The simple make file for this project   =
REM =                                           =
REM =============================================

REM This is a simple make file to compile and link files for this project.
REM One of major purposes is trying to be independent from outside.

REM Parameters:
REM %1: (Optional) The specified name of the target file


REM ==================
REM = Configurations =
REM ==================

SETLOCAL

REM The name of the target file
REM Not including the extension filename
REM May be used as names of generated associated files
IF "%~1" == "" (
    REM The default name of the target file
    SET TARGET_NAME=test
) ^
ELSE (
    REM The specified name of the target file
    SET TARGET_NAME=%1
)

REM The path of the target file
SET TARGET_PATH=.\src\
REM The path of the obe of the target file
REM Not including the extension filename
REM May be used as names of generated associated files
if "%~1" == "" (
    REM The default name of the target file
    SET TARGET_NAME=test
) ^
else (
    REM The specified name of the target file
    SET TARGET_NAME=%1
)

REM The path of the target file
SET TARGET_PATH=.\src\
REM The path of the object files
SET OBJECT_PATH=.\obj\
REM The path of the output files
SET OUTPUT_PATH=.\bin\

REM The path of the MASM binaries
SET MASM=.\make\masm32\

REM The path of the include files
SET INCLUDE=.\inc\
REM The path if the library files
SET LIB=.\lib\


REM ==================
REM = Build Commands =
REM ==================

REM The command to compile (but not link) the target file to the object file
%MASM%ML /Fo %OBJECT_PATH%%TARGET_NAME%.obj /c /coff /Zi %TARGET_PATH%%TARGET_NAME%.asm
if errorlevel 1 goto terminate

REM The command to link the target object file to the excutable file
@REM %MASM%LINK /INCREMENTAL:no /debug /pdb:%OUTPUT_PATH%%TARGET_NAME%.pdb /subsystem:console /entry:start /out:%OUTPUT_PATH%%TARGET_NAME%.exe %OBJECT_PATH%%TARGET_NAME%.obj
%MASM%LINK /INCREMENTAL:no /subsystem:console /entry:start /out:%OUTPUT_PATH%%TARGET_NAME%.exe %OBJECT_PATH%%TARGET_NAME%.obj
if errorlevel 1 goto terminate


REM ======================
REM = Print Informations =
REM ======================

@REM DIR %TARGET_PATH%%TARGET_NAME%*
@REM DIR %OBJECT_PATH%%TARGET_NAME%*
@REM DIR %OUTPUT_PATH%%TARGET_NAME%*


REM ==================
REM = ENDING PROCESS =
REM ==================

:terminate
pause
