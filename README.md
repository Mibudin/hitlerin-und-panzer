# HITLERIN und PANZER

Das letztes Projekt von Assembler-Kurs

Von HITLERIN und PANZER Projekt

---

## About
***Battle City x Waifu x Console x MASM***

In a word, the final project of Assembly Language and System Programming class.

The game of the MASM, by the MASM, for the MASM.


## File Structure

### Main Folders
| Folder    | Description     |
| :-------- | :-------------- |
| `.\bin\`  | Binary files    |
| `.\inc\`  | Include files   |
| `.\lib\`  | Library files   |
| `.\make\` | Compiling files |
| `.\obj\`  | Object files    |
| `.\res\`  | Resource files  |
| `.\src\`  | Source files    |

### Main Files
| File           | Description            |
| :------------- | :--------------------- |
| `.\LICENSE`    | License file           |
| `.\config.bat` | Configuration file     |
| `.\make.bat`   | General compiling file |
| `.\README.md`  | Read me file           |


## Compile

### .\make.bat
In most of situations, run the `.\make.bat` to generally compile the specified assembly file for this project.

The BAT file `.\make.bat` has a optional parameter, the specific file name to be compiled. If it does not has a specific name as a prameter, it will compile the default file configured in its file.

In default, `.\make.bat` will use MASM compile file in `.\make\masm32\`.

### MASM Compile Files
In `.\make\masm32\`, there are some default compiling files (in about latest) for this project:

- `Microsoft Macro Assembler Version 6.14.8444`
- `Microsoft Incremental Linker Version 5.12.8078`

which are copied from the standard MASM files in minimum to run correctly.

---

Copyright © 2020 HITLERIN und PANZER Projekt
