# HITLERIN und PANZER

***Battle City x Waifu x Console x MASM***

<!-- TODO: Complete README -->

---

```
                            ./-.       `` `..`       `-:`         
                             :+.  ``..```.``.-...   .++:`         
                         `.```:- `..`` ````` `.`.. `.-``          
                        `-``.-..`.``` ``````````````..--:`        
                        -`.++-```.```````````.```````.`-.         
                        :```` ``.-.--`---/-`````-`.``..``         
                       `:``````````...-:sNo..--./::.-:/`.`        
                       `-```` ``````..:hNmm/:--:.//-.-/.`-        
                       `.````  .-```../shNNmho+o:/+o``.- -`       
                       `````   sy```-:::syNMMMNs::+o `.. `-       
                       ````    -d/`..+NNNMMMMMNssmh. `.`  -       
                         ```    `.``-:hNMMMMMMMNNN:`````  -`      
           `o           `` `    `  `/NNMMNNNNMMMNo`````   ..      
  -//-     .m.         ..``        .`-dmMMNNNMNy-  ` `   ``-      
    `:oo-   yh`      `::```  ```  `--dmdhdmdh+`    ``    ` -      
       `odyhmyd.     /:```:/+/+ooo-:::hMMNs/oy..--.`.`  `````     
        :MNmddhm.  `/-```+oooo+/o+--+o+sNh.---+::/++:.` ` `.`     
         hMNhyhN/ .:.```-oooooo+/:-:///++dy..-d+++///o```````     
         .mMMmdNs-:` ```+ooooooo/`-++//+oomo.--d++/::+: `.```     
          .dMMmh++/. ``.+oo+++oo.-so++oooooy..-/h+ooo/-   ````    
          .+sdhd+ooo:`::/++++o+:-ossss++++++-...++oo+o-`    ``````
          .:odhoooooo//:++/+++-:+oooo+ss+:+++-..-/++/+:.   `  ```-
          `--++oooooo+//////:.:++++oo/ooo+::++-../++hh+`       ```
           ..-:/++++oo:+///..:///++++/++oo//-/+../:+oo:`     ` `..
          ..```:/++++o++/-`.-:::://///+++++::/:-::///:/         ..
         ..``  `-/+++oo/. `:::::::::::////+/-:::://:.+/         `.
        `.``     `:+++-`` .:///:::::-:://///:--:::-.:-`          `
       `.``       ``..` ``--/-+o+/::-:::::/:---:--::-             
       ```        ` ``   `-++/:+o+o/+/://:-::-.:.-::.             
      ```` `      ````   `-/+o/:oo//+++ooo:++:.:::/:.             
      ``` `      ``` `   `---/++/+/oo++/+:/++/-:////-             
     ```  `      ``` `  ..::////::/+////:-::/:.::://+-            
```

---

## About

In a word, the final project of Assembly Language and System Programming class.

The game of the MASM, by the MASM, for the MASM.

***(This is just a work of fiction. Any similarity is purely coincidental)***


## Members

HITLERIN und PANZER Projekt

Member List:
- [Peter130848](https://github.com/Peter130848)
- [Sunny (Cing-Chen)](https://github.com/Cing-Chen)
- [Mibudin (Mibudin)](https://github.com/Mibudin)
- [qswdqswd](https://github.com/qswdqswd)


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
| `.\README.md`  | Read me file           |
| `.\LICENSE`    | License file           |
| `.\config.bat` | Configuration file     |
| `.\make.bat`   | General compiling file |
| `.\run.bat`    | Run game file          |


## Environment

Technically, the default compiling and excuting environment of this project is Windows NT with x86 or x86-64.

In the duration of making this project, the default (and only) using operation system is Windows 10 with x86-64, which is also the only operation systems we have tested.

Therefore, it is suggested that the operation system for this project should be same as that we used, **Windows 10 with x86-64**.

The compiling and linking files used in this project are (maybe) all packed in the folder `.\make\`.


## Compile

In default, run this command in command-line (in the root directory of this project):
```
make
```
which will compile the deafult target source file. Or
```
make <filename>
```
which will compile the target source file spicified by `<filename>`.

### .\config.bat
The configuration file `.\config.bat` is a bat script file with some important settings variables inside. These configure to compile, link, and excute the associated files of this project.

Be careful when changing the values in this file, because most of them are needed to be in specific formats, about certain environments, or the file structure.

The variables set in this file would be used locally by `.\make.bat` and `.\run.bat`.

### .\make.bat
In most of situations, run the `.\make.bat` to generally compile the specified assembly file for this project.

This script `.\make.bat` depends on the configuration file `.\config.bat`.

This script has a optional parameter, the specific file name to be compiled. If it does not has a specific name as a prameter, it will compile the default file configured in its file.

In default, `.\make.bat` will use MASM compile file in `.\make\masm32\`.

### MASM Compile Files
In `.\make\masm32\`, there are some default compiling files (in about latest) for this project:

- `Microsoft Macro Assembler Version 6.14.8444`
- `Microsoft Incremental Linker Version 5.12.8078`

which are copied from the standard MASM files in minimum to run correctly.


## Excute

In dafault, run this command in command-line (in the root directory of this project):
```
run
```
which will run the deafult target exuctable binary file. Or
```
run <filename>
```
which will run the target excutable binary file spicified by `<filename>`.

### .\run.bat
In most of situations, run the `.\run.bat` to generally run the specified excutable binary file for this project.

This script `.\make.bat` depends on the configuration file `.\config.bat`, like `.\make.bat`.

This script has a optional parameter, the specific file name to be run. If it does not has a specific name as a prameter, it will run the default file configured in its file.

In default, `.\run.bat` will open a new CMD cnosole program and its console window to run the file. When the program of the file exits, this script will also exit the new CMD console program and its console window automatically and immediately.


## Play

### Game Rules
The Game Rule of *HITERLIN und PANZER*
- Player's Panzer
    - Have one panzer
    - Control the direction with *[ARROW KEYS]*
    - Fire a bullet with *[SPACE]*
        (fire one per 2 seconds, accumulate three ones at most)
    - Have three lives
- Enemy's Panzers
    - Have three panzers
    - Automatically move and fire through certain rules
    - Have one life for each one
- Victory Condition
    - Destroy all panzers of the enemy
- Failure Condition
    - Run out of all three lives

### Operations
Most of the operating ways are descripted in the game rule above or in the interfaces in this game.


---

Copyright © 2020-2021 HITLERIN und PANZER Projekt

Das letztes Projekt von Assembler-Kurs von HITLERIN und PANZER Projekt
