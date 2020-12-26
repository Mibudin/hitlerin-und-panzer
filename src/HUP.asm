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
INCLUDELIB Kernel32.lib
INCLUDELIB irvine32.lib
INCLUDELIB user32.lib


; ===========
; = Equates =
; ===========

; The program entry
ProgramEntry EQU _start@0

; The main game loop state
GAME_STATE_TEST         EQU <0>
GAME_STATE_INIT         EQU <1>
GAME_STATE_INTRO_SCREEN EQU <2>
GAME_STATE_START_MENU   EQU <3>

; The size of the screen buffer
SCREEN_BUFFER_WIDTH  EQU <128>  ; 128 (2^7) chars, 64 (2^6) blocks
SCREEN_BUFFER_HEIGHT EQU <32>   ;  32 (2^5) chars, 32 (2^5) blocks

; The size of the window size
WINDOW_WIDTH         EQU <128>  ; 128 (2^7) chars, 64 (2^6) blocks
WINDOW_HEIGHT        EQU <32>   ;  32 (2^5) chars, 32 (2^5) blocks

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

; Render
RENDER_BUFFER_LAYERS     EQU <4>                         ; The amount of layers ; TODO: Test value
RENDER_BUFFER_DISCARD    EQU <0>                         ; Null character
RENDER_BUFFER_CLEAR_CHAR EQU <RENDER_BUFFER_DISCARD>     ; Use space character to clear render buffer
RENDER_BUFFER_CLEAR_ATTR EQU <00001111b>                 ; Black background and white foreground
RENDER_BUFFER_BLANK_CHAR EQU <20h>                       ; A space
RENDER_BUFFER_BLANK_ATTR EQU <RENDER_BUFFER_CLEAR_ATTR>  ; Black background and white foreground

; Texts
CRLF_C   EQU <0dh, 0ah>   ; CR and LF characters

; The main game logic
MAIN_GAME_TURN_INTERVAL EQU <500>  ; in milliseconds  ; TODO: Test value


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
    characters BYTE SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(?)
    attributes WORD SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(?)
CMD_IMAGE ENDS


; =================
; = Include Inner =
; =================

; Include inner include files
INCLUDE Main.inc
INCLUDE Initialization.inc
INCLUDE Renderer.inc


; ================
; = Data Segment =
; ================
.data

; The title of the window
windowTitle BYTE "HITLERIN und PANZER - Version 0.1", 0

; The standard handles
stdOutputHandle  DWORD ?
stdInputHandle   DWORD ?

; The screen buffer and window data
screenBufferSize COORD                      <SCREEN_BUFFER_WIDTH, SCREEN_BUFFER_HEIGHT>
screenBufferInfo CONSOLE_SCREEN_BUFFER_INFO <<SCREEN_BUFFER_WIDTH, SCREEN_BUFFER_HEIGHT>, <0, 0>, 0, <0, 0, WINDOW_WIDTH - 1, WINDOW_HEIGHT - 1>, <WINDOW_WIDTH, WINDOW_HEIGHT>>
windowSize       COORD                      <WINDOW_WIDTH, WINDOW_HEIGHT>
windowPosition   SMALL_RECT                 <0, 0, WINDOW_WIDTH - 1, WINDOW_HEIGHT - 1>

; The render buffer
stdRenderBuffer RENDER_BUFFER RENDER_BUFFER_LAYERS DUP(<>)
stdRenderOrigin COORD         <0, 0>

; The main game logic
gameState     BYTE  GAME_STATE_TEST
gameTickCount DWORD ?

; Test
testString BYTE CRLF_C
           BYTE "~~~ HITLERIN und PANZER ~~~", CRLF_C
           BYTE CRLF_C
           BYTE "Battle City x Waifu x Console x MASM", CRLF_C
           BYTE CRLF_C, 0

testImageChars BYTE "123456789"
testImageAttrs WORD 9 DUP(49)

testImage CMD_IMAGE <<5, 6>, "123456789012345678901234567890", 30 DUP(49)>
testPosition COORD <4, 7>


; ================
; = Code Segment =
; ================
.code

; The start of the program entry
ProgramEntry:

; Include sources
INCLUDE Main.asm           ; The main program file of this project. (Must be the first)
INCLUDE Initialization.asm ; The major initialization part of the game
INCLUDE Renderer.asm       ; The major rendering part of the game

; The end of the program entry
END ProgramEntry
