@echo off

REM ===============================================
REM =                                             =
REM =   The configuration file for this project   =
REM =                                             =
REM ===============================================

REM This is the major confuguration file for this project.
REM These variables in this file will be used in `.\make.bat`.

REM Parameters:
REM - (None)


REM ==================
REM = Configurations =
REM ==================

REM Note:
REM - Do not delete the declaration of these variables below
REM - A path should end with `\`
REM - A boolean should be either `1`(mean TRUE) or `0`(mean FALSE)

REM The default name of the target file
REM Not including the extension filename
REM May be used as names of generated associated files
SET TARGET_NAME=test

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

REM Whether to generate the PDB debug file
SET GEN_PDB=0

REM Whether to print the associated generated files
SET GEN_INFO_FILES=0
