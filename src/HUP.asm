TITLE HUP (HUP.asm)

; =======
; = HUP =
; =======

; The major entry and declarations of this project.


; =================
; = Include Outer =
; =================

; Include outer include files
INCLUDE Irvine32.inc

; Include outer libraries
INCLUDELIB Kernel32.Lib
INCLUDELIB User32.Lib
INCLUDELIB Irvine32.lib


; ===========
; = Equates =
; ===========

; The program entry
ProgramEntry EQU _start@0

; The main game loop state
GAME_STATE_TEST     EQU <0>
GAME_STATE_START    EQU <1>
GAME_STATE_GAME_MAP EQU <2>
GAME_STATE_END      EQU <3>

; The size of the screen buffer
SCREEN_BUFFER_WIDTH  EQU <128>  ; 128 (2^7) chars, 64 (2^6) blocks
SCREEN_BUFFER_HEIGHT EQU <32>   ;  32 (2^5) chars, 32 (2^5) blocks

; The size of the window size
WINDOW_WIDTH         EQU <128>  ; 128 (2^7) chars, 64 (2^6) blocks
WINDOW_HEIGHT        EQU <32>   ;  32 (2^5) chars, 32 (2^5) blocks

; The start menu state
START_MENU_STATE_MAIN    EQU <0>
START_MENU_STATE_RULES   EQU <1>
START_MENU_STATE_CREDITS EQU <2>

; The size of the map
GAME_MAP_WIDTH  EQU <SCREEN_BUFFER_WIDTH>
GAME_MAP_HEIGHT EQU <SCREEN_BUFFER_HEIGHT>

; Concole modes
; Default:
;     In:  01F7h (0000 0001 1111 0111 b)
;     Out: 0003h (0000 0000 0000 0011 b)
; In:  ???? ??0? ?0?0 00?0 => 0000 0001 1010 0010
;     0 0x0001 ENABLE_PROCESSED_INPUT 
;     ? 0x0002 ENABLE_LINE_INPUT 
;     0 0x0004 ENABLE_ECHO_INPUT 
;     0 0x0008 ENABLE_WINDOW_INPUT 
;     0 0x0010 ENABLE_MOUSE_INPUT 
;     ? 0x0020 ENABLE_INSERT_MODE 
;     0 0x0040 ENABLE_QUICK_EDIT_MODE 
;     0 0x0200 ENABLE_VIRTUAL_TERMINAL_INPUT 
; Out: ???? ???? ???0 0001 => 0000 0000 0000 0001
;     1 0x0001 ENABLE_PROCESSED_OUTPUT
;     0 0x0002 ENABLE_WRAP_AT_EOL_OUTPUT
;     0 0x0004 ENABLE_VIRTUAL_TERMINAL_PROCESSING
;     0 0x0008 DISABLE_NEWLINE_AUTO_RETURN
;     0 0x0010 ENABLE_LVB_GRID_WORLDWIDE>
CONSOLE_INPUT_MODE  EQU <0000000110100010b>
CONSOLE_OUTPUT_MODE EQU <0000000000000001b>

; CMD color codes
; (Combinable by the operation `OR`)
COLOR_FB EQU <00000001b>  ; FOREGROUND_BLUE      EQU <00000001b>
COLOR_FG EQU <00000010b>  ; FOREGROUND_GREEN     EQU <00000010b>
COLOR_FR EQU <00000100b>  ; FOREGROUND_RED       EQU <00000100b>
COLOR_FI EQU <00001000b>  ; FOREGROUND_INTENSITY EQU <00001000b>
COLOR_BB EQU <00010000b>  ; BACKGROUND_BLUE      EQU <00010000b>
COLOR_BG EQU <00100000b>  ; BACKGROUND_GREEN     EQU <00100000b>
COLOR_BR EQU <01000000b>  ; BACKGROUND_RED       EQU <01000000b>
COLOR_BI EQU <10000000b>  ; BACKGROUND_INTENSITY EQU <10000000b>

; Render settings
RENDER_BUFFER_DISCARD    EQU <0h>                        ; Null character
RENDER_BUFFER_CLEAR_CHAR EQU <RENDER_BUFFER_DISCARD>     ; Use space character to clear render buffer
RENDER_BUFFER_CLEAR_ATTR EQU <00001111b>                 ; Black background and white foreground
RENDER_BUFFER_BLANK_CHAR EQU <20h>                       ; A space
RENDER_BUFFER_BLANK_ATTR EQU <RENDER_BUFFER_CLEAR_ATTR>  ; Black background and white foreground

; Render layers
RENDER_BUFFER_LAYERS         EQU <4>  ; The amount of layers
RENDER_BUFFER_LAYER_GAME_MAP EQU <0>  ; The game map
RENDER_BUFFER_LAYER_TANKS    EQU <1>  ; The panzers (tanks)
RENDER_BUFFER_LAYER_BULLETS  EQU <2>  ; The bullets
RENDER_BUFFER_LAYER_FINALE   EQU <3>  ; The final render buffer layer

; The main game logic
MAIN_GAME_TURN_INTERVAL EQU <100>  ; in milliseconds  ; TODO: Test value

; Texts
CRLF_C EQU <0dh, 0ah>   ; CR and LF characters

; Panzer (Tank)
FACE_UP    EQU <1>
FACE_RIGHT EQU <2>
FACE_DOWN  EQU <3>
FACE_LEFT  EQU <4>

; Tank role
ROLE_PLAYER EQU <1>
ROLE_ENEMY  EQU <2>

; The game map characters
GAME_MAP_CHAR_EMPTY         EQU <' '>
GAME_MAP_CHAR_PLAYER        EQU <'#'>
GAME_MAP_CHAR_ENEMY         EQU <'*'>
GAME_MAP_CHAR_PLAYER_BULLET EQU <'@'>
GAME_MAP_CHAR_ENEMY_BULLET  EQU <'%'>
GAME_MAP_CHAR_WALL_0        EQU <'='>
GAME_MAP_CHAR_WALL_1        EQU <'|'>

; The Game map numbers
GAME_MAP_PLAYER_NUMBER        EQU <1>
GAME_MAP_PLAYER_NUMBER        EQU <2>
GAME_MAP_ENEMY_NUMBER         EQU <3>
GAME_MAP_PLAYER_BULLET_NUMBER EQU <4>
GAME_MAP_ENEMY_BULLET_NUMBER  EQU <5>
GAME_MAP_WALL_0_NUMBER        EQU <6>
GAME_MAP_WALL_1_NUMBER        EQU <7>

; Game objects
PLAYER_START_POSITION       EQU <<21, 21>>
PLAYER_LIVES_INITIAL        EQU <3>
PLAYER_SHOOT_INTERVAL       EQU <2000>
PLAYER_SHOOT_CUMULATION_MAX EQU <3>
ENEMY_TANK_AMOUNT_INITIAL   EQU <3>
BULLET_AMOUNT_MAX           EQU <128>


; ==============
; = Structures =
; ==============

; Render buffer
RENDER_BUFFER STRUCT                                                   ; Size: 3000h (= 3 * 2^12 = 12288) Bytes
    characters BYTE SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(?)  ; Size: 1000h Bytes
    attributes WORD SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(?)  ; Size: 2000h Bytes
RENDER_BUFFER ENDS

CMD_IMAGE STRUCT
    imageSize  COORD <>
    characters BYTE  SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(?)
    attributes WORD  SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(?)
CMD_IMAGE ENDS

TANK STRUCT 
    ; firstLine   BYTE  ' ', 7Ch, ' '  ;  |
    ; secondLine  BYTE  23h, 2Bh, 23h  ; #+#
    ; thirdLine   BYTE  23h, 2Bh, 23h  ; #+#
    ; firstColor  WORD  6h, 6h, 6h     ; brown
    ; secondColor WORD  6h, 0ch, 6h    ; brown red brown
    ; threeWhite  BYTE  3 DUP(' ')     ; for EraseTank
    position    COORD <1, 1>         ; left up
    faceTo      BYTE  FACE_UP        ; 1 : face up, 2 : face right, 3 : face down, 4 : face left
    role        BYTE  ROLE_PLAYER
    hp          BYTE  PLAYER_LIVES_INITIAL
TANK ENDS

BULLET STRUCT
    ; symbol    BYTE  '@'
    ; white     BYTE  ' '
    ; color     WORD  0Eh
    direction BYTE  FACE_UP
    role      BYTE  ROLE_PLAYER
    position  COORD <1, 1>
BULLET ENDS


; =================
; = Include Inner =
; =================

; Include inner include files
INCLUDE Main.inc             ; The main program file of this project. (Must be the first)
INCLUDE Initialization.inc   ; The major initialization part of the game
INCLUDE Renderer.inc         ; The major rendering part of the game
; INCLUDE GameMapHandler.inc   ; The main handler of the game map
INCLUDE Tank.inc             ; The main handler of the tanks
INCLUDE Bullet.inc           ; The main handler of the bullets
INCLUDE ControlEnemy.inc     ; The main handler of controling enemies
; INCLUDE HomePage.inc         ; (Obsolete) The main handler of the home page
; INCLUDE StartMenuHandler.inc ; The main handler of the start menu
; INCLUDE FileLoader.inc       ; The main handler of loading files


; ================
; = Data Segment =
; ================
.data

; The title of the window
windowTitle BYTE "HITLERIN und PANZER - Version 0.2", 0

; The standard handles
stdOutputHandle  DWORD ?
stdInputHandle   DWORD ?

; The screen buffer and window data
screenBufferSize COORD                      <SCREEN_BUFFER_WIDTH, SCREEN_BUFFER_HEIGHT>
screenBufferInfo CONSOLE_SCREEN_BUFFER_INFO <<SCREEN_BUFFER_WIDTH, SCREEN_BUFFER_HEIGHT>, \
                                             <0, 0>,                                      \
                                             RENDER_BUFFER_BLANK_ATTR,                                           \
                                             <0, 0, WINDOW_WIDTH - 1, WINDOW_HEIGHT - 1>, \
                                             <WINDOW_WIDTH, WINDOW_HEIGHT>>
windowSize       COORD                      <WINDOW_WIDTH, WINDOW_HEIGHT>
windowPosition   SMALL_RECT                 <0, 0, WINDOW_WIDTH - 1, WINDOW_HEIGHT - 1>

; The render settings
stdRenderBuffer      RENDER_BUFFER       RENDER_BUFFER_LAYERS DUP(<>)
stdRenderOrigin      COORD               <0, 0>
stdConsoleCursorInfo CONSOLE_CURSOR_INFO <100, FALSE>

; The main game logic
gameState     BYTE  GAME_STATE_TEST
gameTickCount DWORD 0

; The partial game logic
startMenuState BYTE START_MENU_STATE_MAIN

; The game exit code
gameExitCode DWORD 0

; The game map record
gameMapRecord BYTE GAME_MAP_WIDTH * GAME_MAP_HEIGHT DUP(GAME_MAP_CHAR_EMPTY)

; The CMD images
blankCmdImage     CMD_IMAGE <<SCREEN_BUFFER_WIDTH, SCREEN_BUFFER_HEIGHT>,                              \
                             SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(RENDER_BUFFER_BLANK_CHAR), \
                             SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(RENDER_BUFFER_BLANK_ATTR)>

tankCmdImageUp    CMD_IMAGE <<3, 3>,                                        \
                             { 0h, 7Ch,  0h, 23h, 2Bh, 23h, 23h, 2Bh, 23h}, \
                             { 6h,  6h,  6h,  6h, 0Ch,  6h,  6h, 0Ch,  6h}>
tankCmdImageRight CMD_IMAGE <<3, 3>,                                        \
                             {23h, 23h,  0h, 2Bh, 2Bh, 2Dh, 23h, 23h,  0h}, \
                             { 6h,  6h,  6h, 0Ch, 0Ch,  6h,  6h,  6h,  6h}>
tankCmdImageDown  CMD_IMAGE <<3, 3>,                                        \
                             {23h, 2Bh, 23h, 23h, 2Bh, 23h,  0h, 7Ch,  0h}, \
                             { 6h, 0Ch,  6h,  6h, 0Ch,  6h,  6h,  6h,  6h}>
tankCmdImageLeft  CMD_IMAGE <<3, 3>,                                        \
                             { 0h, 23h, 23h, 2Dh, 2Bh, 2Bh,  0h, 23h, 23h}, \
                             { 6h,  6h,  6h,  6h, 0Ch, 0Ch,  6h,  6h,  6h}>

tankCmdImageEnemyUp    CMD_IMAGE <<3, 3>,                                        \
                                  { 0h, 7Ch,  0h, 23h, 2Bh, 23h, 23h, 2Bh, 23h}, \
                                  {0Ch, 0Ch, 0Ch, 0Ch, 0Fh, 0Ch, 0Ch, 0Fh, 0Ch}>
tankCmdImageEnemyRight CMD_IMAGE <<3, 3>,                                        \
                                  {23h, 23h,  0h, 2Bh, 2Bh, 2Dh, 23h, 23h,  0h}, \
                                  {0Ch, 0Ch, 0Ch, 0Fh, 0Fh, 0Ch, 0Ch, 0Ch, 0Ch}>
tankCmdImageEnemyDown  CMD_IMAGE <<3, 3>,                                        \
                                  {23h, 2Bh, 23h, 23h, 2Bh, 23h,  0h, 7Ch,  0h}, \
                                  {0Ch, 0Fh, 0Ch, 0Ch, 0Fh, 0Ch, 0Ch, 0Ch, 0Ch}>
tankCmdImageEnemyLeft  CMD_IMAGE <<3, 3>,                                        \
                                  { 0h, 23h, 23h, 2Dh, 2Bh, 2Bh,  0h, 23h, 23h}, \
                                  {0Ch, 0Ch, 0Ch, 0Ch, 0Fh, 0Fh, 0Ch, 0Ch, 0Ch}>

bulletCmdImage      CMD_IMAGE <<1, 1>, \
                               {'@'},  \
                               {0Eh}>
bulletCmdImageEnemy CMD_IMAGE <<1, 1>, \
                               {'%'},  \
                               {0Dh}>

germanFlagCmdImage_position COORD <8, 12>
germanFlagCmdImage_attributes WORD 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h
                              WORD 0C0h, 0C0h, 0C0h, 0C0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0C0h, 0C0h, 0C0h, 0C0h
                              WORD 0C0h, 0C0h, 0F0h, 0F0h,   0h,   0h, 0F0h, 0F0h, 0F0h, 0F0h,   0h,   0h, 0F0h, 0F0h, 0C0h, 0C0h
                              WORD 0C0h, 0C0h, 0F0h, 0F0h, 0F0h, 0F0h,   0h,   0h,   0h,   0h, 0F0h, 0F0h, 0F0h, 0F0h, 0C0h, 0C0h
                              WORD 0C0h, 0C0h, 0F0h, 0F0h, 0F0h, 0F0h,   0h,   0h,   0h,   0h, 0F0h, 0F0h, 0F0h, 0F0h, 0C0h, 0C0h
                              WORD 0C0h, 0C0h, 0F0h, 0F0h,   0h,   0h, 0F0h, 0F0h, 0F0h, 0F0h,   0h,   0h, 0F0h, 0F0h, 0C0h, 0C0h
                              WORD 0C0h, 0C0h, 0C0h, 0C0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0C0h, 0C0h, 0C0h, 0C0h
                              WORD 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h
germanFlagCmdImage CMD_IMAGE <<16, 8>,                              \
                              16 * 8 DUP(RENDER_BUFFER_BLANK_CHAR), \
                              <>>

polandFlagCmdImage_position COORD <104, 12>
polandFlagCmdImage_attributes WORD 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h
                              WORD 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h
                              WORD 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h
                              WORD 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h
                              WORD 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h
                              WORD 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h
                              WORD 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h
                              WORD 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h
polandFlagCmdImage CMD_IMAGE <<16, 8>,                              \
                              16 * 8 DUP(RENDER_BUFFER_BLANK_CHAR), \
                              <>>

; TODO: Load from file?
startMenuCmdImage_characters BYTE "                                                                                          ./-.       `` `..`       `-:`         "
                             BYTE "                                                                                           :+.  ``..```.``.-...   .++:`         "
                             BYTE "      H H  III  TTT  L    EEE  RRR  III  N N                                           `.```:- `..`` ````` `.`.. `.-``          "
                             BYTE "      H H   I    T   L    E    R R   I   NNN                                          `-``.-..`.``` ``````````````..--:`        "
                             BYTE "      HHH   I    T   L    EEE  RR    I   N N                                          -`.++-```.```````````.```````.`-.         "
                             BYTE "      H H   I    T   L    E    R R   I   N N                                          :```` ``.-.--`---/-`````-`.``..``         "
                             BYTE "      H H  III   T   LLL  EEE  R R  III  N N                                         `:``````````...-:sNo..--./::.-:/`.`        "
                             BYTE "                                                                                     `-```` ``````..:hNmm/:--:.//-.-/.`-        "
                             BYTE "                            d                                                        `.````  .-```../shNNmho+o:/+o``.- -`       "
                             BYTE "                            d                                                        `````   sy```-:::syNMMMNs::+o `.. `-       "
                             BYTE "                u u  nnn  ddd                                                        ````    -d/`..+NNNMMMMMNssmh. `.`  -       "
                             BYTE "                u u  n n  d d                                                          ```    `.``-:hNMMMMMMMNNN:`````  -`      "
                             BYTE "                uuu  n n  ddd                                            `o           `` `    `  `/NNMMNNNNMMMNo`````   ..      "
                             BYTE "                                                                -//-     .m.         ..``        .`-dmMMNNNMNy-  ` `   ``-      "
                             BYTE "                          PPP   A   N N  ZZZ  EEE  RRR            `:oo-   yh`      `::```  ```  `--dmdhdmdh+`    ``    ` -      "
                             BYTE "                          P P  A A  NNN    Z  E    R R               `odyhmyd.     /:```:/+/+ooo-:::hMMNs/oy..--.`.`  `````     "
                             BYTE "                          PPP  AAA  N N   Z   EEE  RR                 :MNmddhm.  `/-```+oooo+/o+--+o+sNh.---+::/++:.` ` `.`     "
                             BYTE "                          P    A A  N N  Z    E    R R                 hMNhyhN/ .:.```-oooooo+/:-:///++dy..-d+++///o```````     "
                             BYTE "                          P    A A  N N  ZZZ  EEE  R R                 .mMMmdNs-:` ```+ooooooo/`-++//+oomo.--d++/::+: `.```     "
                             BYTE "                                                                        .dMMmh++/. ``.+oo+++oo.-so++oooooy..-/h+ooo/-   ````    "
                             BYTE "                                                                        .+sdhd+ooo:`::/++++o+:-ossss++++++-...++oo+o-`    ``````"
                             BYTE "                                                                        .:odhoooooo//:++/+++-:+oooo+ss+:+++-..-/++/+:.   `  ```-"
                             BYTE "      * [SPACE] Start The Battle                                        `--++oooooo+//////:.:++++oo/ooo+::++-../++hh+`       ```"
                             BYTE "                                                                         ..-:/++++oo:+///..:///++++/++oo//-/+../:+oo:`     ` `.."
                             BYTE "      * [R] See The Game Rule                                           ..```:/++++o++/-`.-:::://///+++++::/:-::///:/         .."
                             BYTE "                                                                       ..``  `-/+++oo/. `:::::::::::////+/-:::://:.+/         `."
                             BYTE "      * [M] See The Credits                                           `.``     `:+++-`` .:///:::::-:://///:--:::-.:-`          `"
                             BYTE "                                                                     `.``       ``..` ``--/-+o+/::-:::::/:---:--::-             "
                             BYTE "                                                                     ```        ` ``   `-++/:+o+o/+/://:-::-.:.-::.             "
                             BYTE "                                                                    ```` `      ````   `-/+o/:oo//+++ooo:++:.:::/:.             "
                             BYTE "      HETLERIN und PANZER - Version 0.2                             ``` `      ``` `   `---/++/+/oo++/+:/++/-:////-             "
                             BYTE "                                                                   ```  `      ``` `  ..::////::/+////:-::/:.::://+-            "
startMenuCmdImage CMD_IMAGE <<SCREEN_BUFFER_WIDTH, SCREEN_BUFFER_HEIGHT>,                              \
                             <>,                                                                       \
                             SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(RENDER_BUFFER_BLANK_ATTR)>

menuRuleCmdImage_characters BYTE "                                                                                          ./-.       `` `..`       `-:`         "
                            BYTE "                                                                                           :+.  ``..```.``.-...   .++:`         "
                            BYTE "      The Game Rule of `HITERLIN und PANZER`                                           `.```:- `..`` ````` `.`.. `.-``          "
                            BYTE "                                                                                      `-``.-..`.``` ``````````````..--:`        "
                            BYTE "      - Player's Panzer                                                               -`.++-```.```````````.```````.`-.         "
                            BYTE "                                                                                      :```` ``.-.--`---/-`````-`.``..``         "
                            BYTE "          - Have one panzer                                                          `:``````````...-:sNo..--./::.-:/`.`        "
                            BYTE "          - Control the direction with [ARROW KEYS]                                  `-```` ``````..:hNmm/:--:.//-.-/.`-        "
                            BYTE "          - Fire a bullet with [SPACE]                                               `.````  .-```../shNNmho+o:/+o``.- -`       "
                            BYTE "            ( fire one per 2 seconds, accumulate three ones at most )                `````   sy```-:::syNMMMNs::+o `.. `-       "
                            BYTE "          - Have three lives                                                         ````    -d/`..+NNNMMMMMNssmh. `.`  -       "
                            BYTE "                                                                                       ```    `.``-:hNMMMMMMMNNN:`````  -`      "
                            BYTE "      - Enemy's Panzers                                                  `o           `` `    `  `/NNMMNNNNMMMNo`````   ..      "
                            BYTE "                                                                -//-     .m.         ..``        .`-dmMMNNNMNy-  ` `   ``-      "
                            BYTE "          - Have three panzers                                    `:oo-   yh`      `::```  ```  `--dmdhdmdh+`    ``    ` -      "
                            BYTE "          - Automatically move and fire through certain rules        `odyhmyd.     /:```:/+/+ooo-:::hMMNs/oy..--.`.`  `````     "
                            BYTE "          - Have one life for each one                                :MNmddhm.  `/-```+oooo+/o+--+o+sNh.---+::/++:.` ` `.`     "
                            BYTE "                                                                       hMNhyhN/ .:.```-oooooo+/:-:///++dy..-d+++///o```````     "
                            BYTE "      - Victory Condition                                              .mMMmdNs-:` ```+ooooooo/`-++//+oomo.--d++/::+: `.```     "
                            BYTE "                                                                        .dMMmh++/. ``.+oo+++oo.-so++oooooy..-/h+ooo/-   ````    "
                            BYTE "          - Destroy all panzers of the enemy                            .+sdhd+ooo:`::/++++o+:-ossss++++++-...++oo+o-`    ``````"
                            BYTE "                                                                        .:odhoooooo//:++/+++-:+oooo+ss+:+++-..-/++/+:.   `  ```-"
                            BYTE "      - Failure Condition                                               `--++oooooo+//////:.:++++oo/ooo+::++-../++hh+`       ```"
                            BYTE "                                                                         ..-:/++++oo:+///..:///++++/++oo//-/+../:+oo:`     ` `.."
                            BYTE "          - Run out of all three lives                                  ..```:/++++o++/-`.-:::://///+++++::/:-::///:/         .."
                            BYTE "                                                                       ..``  `-/+++oo/. `:::::::::::////+/-:::://:.+/         `."
                            BYTE "                                                                      `.``     `:+++-`` .:///:::::-:://///:--:::-.:-`          `"
                            BYTE "      * [X] Retuen to The Start Menu                                 `.``       ``..` ``--/-+o+/::-:::::/:---:--::-             "
                            BYTE "                                                                     ```        ` ``   `-++/:+o+o/+/://:-::-.:.-::.             "
                            BYTE "                                                                    ```` `      ````   `-/+o/:oo//+++ooo:++:.:::/:.             "
                            BYTE "      HETLERIN und PANZER - Version 0.2                             ``` `      ``` `   `---/++/+/oo++/+:/++/-:////-             "
                            BYTE "                                                                   ```  `      ``` `  ..::////::/+////:-::/:.::://+-            "
menuRuleCmdImage CMD_IMAGE <<SCREEN_BUFFER_WIDTH, SCREEN_BUFFER_HEIGHT>,                              \
                            <>,                                                                       \
                            SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(RENDER_BUFFER_BLANK_ATTR)>

menuCreditsCmdImage_characters BYTE "                                                                                          ./-.       `` `..`       `-:`         "
                               BYTE "                                                                                           :+.  ``..```.``.-...   .++:`         "
                               BYTE "                                                                                       `.```:- `..`` ````` `.`.. `.-``          "
                               BYTE "                                                                                      `-``.-..`.``` ``````````````..--:`        "
                               BYTE "      The Credits of `HITERLIN und PANZER`                                            -`.++-```.```````````.```````.`-.         "
                               BYTE "                                                                                      :```` ``.-.--`---/-`````-`.``..``         "
                               BYTE "                                                                                     `:``````````...-:sNo..--./::.-:/`.`        "
                               BYTE "      - Peter                                                                        `-```` ``````..:hNmm/:--:.//-.-/.`-        "
                               BYTE "                                                                                     `.````  .-```../shNNmho+o:/+o``.- -`       "
                               BYTE "          - Behaviors of Tanks and Bullets                                           `````   sy```-:::syNMMMNs::+o `.. `-       "
                               BYTE "                                                                                     ````    -d/`..+NNNMMMMMNssmh. `.`  -       "
                               BYTE "      - Hong, Yu-Xiang                                                                 ```    `.``-:hNMMMMMMMNNN:`````  -`      "
                               BYTE "                                                                         `o           `` `    `  `/NNMMNNNNMMMNo`````   ..      "
                               BYTE "          - AI of Tanks, DEMO Slides Designing and Making       -//-     .m.         ..``        .`-dmMMNNNMNy-  ` `   ``-      "
                               BYTE "                                                                  `:oo-   yh`      `::```  ```  `--dmdhdmdh+`    ``    ` -      "
                               BYTE "      - Liu, Zih-Yong                                                `odyhmyd.     /:```:/+/+ooo-:::hMMNs/oy..--.`.`  `````     "
                               BYTE "                                                                      :MNmddhm.  `/-```+oooo+/o+--+o+sNh.---+::/++:.` ` `.`     "
                               BYTE "          - Game Interfaces Designing and Project Integrating          hMNhyhN/ .:.```-oooooo+/:-:///++dy..-d+++///o```````     "
                               BYTE "                                                                       .mMMmdNs-:` ```+ooooooo/`-++//+oomo.--d++/::+: `.```     "
                               BYTE "      - Qin, Cheng-Ye                                                   .dMMmh++/. ``.+oo+++oo.-so++oooooy..-/h+ooo/-   ````    "
                               BYTE "                                                                        .+sdhd+ooo:`::/++++o+:-ossss++++++-...++oo+o-`    ``````"
                               BYTE "          - Idea Giving and Start Menu Designing                        .:odhoooooo//:++/+++-:+oooo+ss+:+++-..-/++/+:.   `  ```-"
                               BYTE "                                                                        `--++oooooo+//////:.:++++oo/ooo+::++-../++hh+`       ```"
                               BYTE "                                                                         ..-:/++++oo:+///..:///++++/++oo//-/+../:+oo:`     ` `.."
                               BYTE "                                                                        ..```:/++++o++/-`.-:::://///+++++::/:-::///:/         .."
                               BYTE "      * [X] Retuen to The Start Menu                                   ..``  `-/+++oo/. `:::::::::::////+/-:::://:.+/         `."
                               BYTE "                                                                      `.``     `:+++-`` .:///:::::-:://///:--:::-.:-`          `"
                               BYTE "                                                                     `.``       ``..` ``--/-+o+/::-:::::/:---:--::-             "
                               BYTE "                                                                     ```        ` ``   `-++/:+o+o/+/://:-::-.:.-::.             "
                               BYTE "                                                                    ```` `      ````   `-/+o/:oo//+++ooo:++:.:::/:.             "
                               BYTE "      HETLERIN und PANZER - Version 0.2                             ``` `      ``` `   `---/++/+/oo++/+:/++/-:////-             "
                               BYTE "                                                                   ```  `      ``` `  ..::////::/+////:-::/:.::://+-            "
menuCreditsCmdImage CMD_IMAGE <<SCREEN_BUFFER_WIDTH, SCREEN_BUFFER_HEIGHT>,                              \
                               <>,                                                                       \
                               SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(RENDER_BUFFER_BLANK_ATTR)>

winResultCmdImage_characters BYTE "                                                                                                                                "
                             BYTE "                                                                                                                                "
                             BYTE "                                                                                                                                "
                             BYTE "                                                                                                                                "
                             BYTE "                                                                                                                                "
                             BYTE "                                                                                                                                "
                             BYTE "                                                                                                                                "
                             BYTE "                                                                                                                                "
                             BYTE "                                                                                   ```````````````                              "
                             BYTE "                                                                                  `..-:/++++//:-.````                           "
                             BYTE "         _____.___.               __      __.__         ._. ._. ._.           ```.://++oooossssso+:....                         "
                             BYTE "         \__  |   | ____  __ __  /  \    /  \__| ____   | | | | | |         ````-////+++++oosssssooo:``.`                       "
                             BYTE "          /   |   |/  _ \|  |  \ \   \/\/   /  |/    \  | | | | | |       `.```.://///--..-/+osso+///:.`..                      "
                             BYTE "          \____   (  <_> )  |  /  \        /|  |   |  \  \|  \|  \|       .````-////:::////::/oo+/://::``.                      "
                             BYTE "          / ______|\____/|____/    \__/\  / |__|___|  /  __  __  __       .```.://::/:.-o+/::/+o/:-:+//.`.`                     "
                             BYTE "          \/                            \/          \/   \/  \/  \/       . `.-::://///////+++++o+:/+//:`-`                     "
                             BYTE "                                                                          -..--:::/+++oooo++//:://:/++++:-                      "
                             BYTE "                                                                         ..----:::////+++/+:.``````-/++++/:-`                   "
                             BYTE "                                                                         -:--:-:-:/:://::/+/-......:::://::/+/:.`               "
                             BYTE "                       * [ESC] Close the Game                            -:.-:::::////+//:--.-::--..::-::/++/:/++//-`           "
                             BYTE "                                                                         .//:--:::/+++++++////++++:-/////:-:/::-/osso+:`    `  `"
                             BYTE "                                                                          `..`.---:/+++++++++++++++/++//+/+/:--:+ossssso+.``````"
                             BYTE "                                                                          ````..----/+++//+++++ooo+++///-`.-/+/+oooosss+-.``````"
                             BYTE "                  HETLERIN und PANZER - Version 0.2                      .`````.://--::/+/::////////::/:.``.:///+++oo+-`````````"
                             BYTE "                                                                          ``````.-/oo/::://:---..`..---.`.-://:-://:.```````````"
                             BYTE "                                                                            ``````../yhhso/-----....`.-.:--..````..    `````````"
                             BYTE "                                                                         ....`````..`./ymd.      `-+``.`````   ```      ````````"
                             BYTE "                                                                             .......`...:+os+`    .:```                   ``````"
                             BYTE "                                                                             .............-::`    -``  ``                 ``````"
                             BYTE "                                                                                 ........```..`   ``````````               `````"
                             BYTE "                                                                                   ...`````````` ```` ```````                  `"
                             BYTE "                                                                                       `````.``````````  `````           `      "
winResultCmdImage CMD_IMAGE <<SCREEN_BUFFER_WIDTH, SCREEN_BUFFER_HEIGHT>,                              \
                             <>,                                                                       \
                             SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(RENDER_BUFFER_BLANK_ATTR)>

loseResultCmdImage_characters BYTE "                                   ............                                                                                 "
                              BYTE "                                ``..............``                                                                              "
                              BYTE "                             ``.....:///++++//:-..````                                                                          "
                              BYTE "                          ``....-:/++++ooooooo++/:-.`..`                                                                        "
                              BYTE "                         ......:/+++++ooooosoooo++//-...`                                                                       "
                              BYTE "                        .....--/+++++ooooooooooooo++/:.`.                                                                       "
                              BYTE "                       .....--://+++++ooooooooooooo+/:-`.`                                                                      "
                              BYTE "                      `.```..-:/++++++++/::::::/+////::-.                                                                       "
                              BYTE "                      `.````.-//++++/////:-...-++/...---.                                                                       "
                              BYTE "                       `.``.-://++++///:::--:/++oo/--.-:-                                                                       "
                              BYTE "                       `::/::///++++++++++o++++++oo+::-:-     _____.___.                .____                         ._.       "
                              BYTE "                       ./+//////+++++ooooo+///:////:/o+/:     \__  |   | ____  __ __    |    |    ____  ______ ____   | |       "
                              BYTE "                       -//:+/////++++++++/:/+:-.....-://:      /   |   |/  _ \|  |  \   |    |   /  _ \/  ___// __ \  | |       "
                              BYTE "                       //:/+////++++++++/:++/---..----:/:      \____   (  <_> )  |  /   |    |__(  <_> )___ \\  ___/   \|       "
                              BYTE "                       :++++//////++++++/++/:----..-:-://      / ______|\____/|____/    |_______ \____/____  >\___  >  __       "
                              BYTE "                        .-::--:///++++++//-...---..-/://:      \/                               \/         \/     \/   \/       "
                              BYTE "                 ````.......-:::////++++//+/+oo++/-///+/:                                                                       "
                              BYTE "            ``..````..`.``:////::::////++++++++/////////.                                                                       "
                              BYTE "       ```.....`..-.-.`.``.oo///:--::////++ooo+++++/++:-                                                                        "
                              BYTE "  ``.........--...-.--`.``.-yyo/:--.--:::///++++/++++/.                        * [ESC] Close the Game                           "
                              BYTE "```....-------------.-...``./yyyo/::--------::::::::--`                                                                         "
                              BYTE "``.....---------.---.--`.``..+yyyyo/::--...----:-......-..`                                                                     "
                              BYTE "``..------------..--.--...`..`+ssyyyo+:--..--:+/`.........--.`                                                                  "
                              BYTE "```..-----------.`--.--.`....``+sssyyys-.``.+oo.`..-.........--`          HETLERIN und PANZER - Version 0.2                     "
                              BYTE "```..------------`.-----.`....``/oosyo`     .oo``..--.....`/::s-.                                                               "
                              BYTE "`````.-----.-----`.-----.``...```+soo-`    `.+o```.---..``-+:/:...-:////`                                                       "
                              BYTE " ```....---..----`.-----.``...```.os/..    --+s```.----..`-//oooooooo++/.                                                       "
                              BYTE "  `````.....`...-`.-----..``..````.+--/`   -:+s``..---/++oo+++////::-..                                                         "
                              BYTE "  ``...``.`.``....`-----..``````````/o:`   -/+o``.../ooooo/::::-``                                                              "
                              BYTE "   ```...```` `...`..--.``  ````````:s`    -+/-....:++ooooo+//:-..                                                              "
                              BYTE "   ``.```..`  `.```...`   ```````````/     ./-``..:+++++//////+++++/                                                            "
                              BYTE "   ``....```` ``````     `````````````      -.`.-+++++osso+/::////:/`                                                           "
loseResultCmdImage CMD_IMAGE <<SCREEN_BUFFER_WIDTH, SCREEN_BUFFER_HEIGHT>,                              \
                              <>,                                                                       \
                              SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(RENDER_BUFFER_BLANK_ATTR)>

mapCmdImage_characters BYTE "================================================================================================================================"
                       BYTE "|                     |                                                                                                        |"
                       BYTE "|                     |                                                                                                        |"
                       BYTE "|                     |                                                                                                        |"
                       BYTE "|                                                                                                                              |"
                       BYTE "|                                 ===============     ==================                       =============================   |"
                       BYTE "|                                 |                                    |                       |                               |"
                       BYTE "|                                 |                                    |                       |                               |"
                       BYTE "|                                                                                              |                               |"
                       BYTE "|                                                                                              |                               |"
                       BYTE "|                                                                                              |                               |"
                       BYTE "|                                                                      |                       |                               |"
                       BYTE "|                                                                      |                       |                               |"
                       BYTE "|                                     ==================================                       |                               |"
                       BYTE "|                                |                                                             |                               |"
                       BYTE "|                                |                                                             |                               |"
                       BYTE "|                                |                                                             |                               |"
                       BYTE "|                                |                       ==============================                                        |"
                       BYTE "|                                |                       |                                                                     |"
                       BYTE "|                                |                       |                                                                     |"
                       BYTE "|                                |                                                                                             |"
                       BYTE "|                                |                                                                                             |"
                       BYTE "|                                |                                                                                             |"
                       BYTE "|                                |                                                                                             |"
                       BYTE "|                                |                       |                                    |                                |"
                       BYTE "|                                |                       |                                    |                                |"
                       BYTE "|    =============================                       ==================     ===============                                |"
                       BYTE "|                                                                                                                              |"
                       BYTE "|                                                                                                         |                    |"
                       BYTE "|                                                                                                         |                    |"
                       BYTE "|                                                                                                         |                    |"
                       BYTE "================================================================================================================================"
mapCmdImage CMD_IMAGE <<GAME_MAP_WIDTH, GAME_MAP_HEIGHT>,                              \
                       <>,                                                             \
                       GAME_MAP_WIDTH * GAME_MAP_HEIGHT DUP(RENDER_BUFFER_BLANK_ATTR)>

; Game map field
enemySpawnField SMALL_RECT <6, 96, 25, 126>  ; TODO: Random spawn enemy?

; Object sizes
tankSize   COORD <3, 3>
bulletSize COORD <1, 1>

; Current game objects
gamePlayerTank             TANK   <PLAYER_START_POSITION, FACE_UP, ROLE_PLAYER, PLAYER_LIVES_INITIAL>
gamePlayerTankLastShoot    DWORD  0
gamePlayerTankShootAmount  BYTE   PLAYER_SHOOT_CUMULATION_MAX
gameEnemyTankList          TANK   <<117,  9>, FACE_UP, ROLE_ENEMY, 1>  ; ENEMY_TANK_AMOUNT_INITIAL = 3  ; TODO: Initialize enemy tanks
                           TANK   << 97, 24>, FACE_UP, ROLE_ENEMY, 1>
                           TANK   <<122, 27>, FACE_UP, ROLE_ENEMY, 1>
gameEnemyTankCurrentAmount BYTE   ENEMY_TANK_AMOUNT_INITIAL
gameBulletList             BULLET BULLET_AMOUNT_MAX DUP(<>)
gameBulletCurrentAmount    BYTE   0
; gamePlayerTankLives        BYTE   PLAYER_LIVES_INITIAL  ; TODO: Player lives

; The winner of the game
gameWinner BYTE ?

; The common trash bus
trashBus DWORD ?

; Home page texts
; StartS  BYTE "					        Press SPACE to start", 0
; RuleS   BYTE "					    Press R to see the game rule", 0
; MemberS BYTE "					     Press M to see member list", 0

; CloseRS BYTE "	   	Press X to close the game rule", 0
; CloseMS BYTE "					     Press X to close member list", 0

; GameRuleS1_1 BYTE "	   	- Player's Panzer", 0
; GameRuleS1_2 BYTE "		  	- Have one panzer", 0
; GameRuleS1_3 BYTE "		  	- Control the direction with ARROW KEYS", 0
; GameRuleS1_4 BYTE "		   	- Fire a bullet with SPACE ( fire one per 2 seconds, accumulate three ones at most )", 0
; GameRuleS1_5 BYTE "		   	- Have three lives", 0

; GameRuleS2_1 BYTE "	   	- Enemy's Panzers",0 
; GameRuleS2_2 BYTE "		   	- Have three panzers", 0
; GameRuleS2_3 BYTE "		   	- Automatically move and fire through certain rules", 0
; GameRuleS2_4 BYTE "		   	- Have one life", 0

; GameRuleS3_1 BYTE "	   	- Victory Condition", 0
; GameRuleS3_2 BYTE "		   	- Destroy all panzers of the enemy", 0

; GameRuleS4_1 BYTE "	  	- Failure Condition", 0
; GameRuleS4_2 BYTE "		   	- Run out of all three lives", 0

; MemberListS1 BYTE "					     HONG, YU-XIANG", 0				; 洪裕翔
; MemberListS2 BYTE "					     LIU, ZI-YONG", 0				; 劉子雍
; MemberListS3 BYTE "					     PETER", 0						; 林緯翔
; MemberListS4 BYTE "					     QIN, CHENG-YE", 0				; 秦承業

; TODO: Test
; testString BYTE CRLF_C
;            BYTE "~~~ HITLERIN und PANZER ~~~", CRLF_C
;            BYTE CRLF_C
;            BYTE "Battle City x Waifu x Console x MASM", CRLF_C
;            BYTE CRLF_C, 0

; testImageChars BYTE "123456789"
; testImageAttrs WORD 9 DUP(49)

; testImage CMD_IMAGE <<5, 6>, "123456789012345678901234567890", 30 DUP(49)>
; testPosition COORD <4, 7>

; testTank TANK <>
; testTankEnemy1 TANK <<100, 20>, ?, ROLE_ENEMY>
; testTankEnemy2 TANK <<80, 1>, ?, ROLE_ENEMY>


; ================
; = Code Segment =
; ================
.code

; The start of the program entry
ProgramEntry:

; Include sources
INCLUDE Main.asm             ; The main program file of this project. (Must be the first)
INCLUDE Initialization.asm   ; The major initialization part of the game
INCLUDE Renderer.asm         ; The major rendering part of the game
; INCLUDE GameMapHandler.asm   ; The main handler of the game map
INCLUDE Tank.asm             ; The main handler of the tanks
INCLUDE Bullet.asm           ; The main handler of the bullets
INCLUDE ControlEnemy.asm     ; The main handler of controling enemies
; INCLUDE HomePage.asm         ; (Obsolete) The main handler of the home page
; INCLUDE StartMenuHandler.asm ; The main handler of the start menu
; INCLUDE FileLoader.asm       ; The main handler of loading files

; The end of the program entry
END ProgramEntry
