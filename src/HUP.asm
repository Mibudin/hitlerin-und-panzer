TITLE HUP (HUP.asm)

; =======
; = HUP =
; =======

; The major entry and declarations of this project.


; ===========
; = Include =
; ===========

; Include outer include files
INCLUDE Irvine32.inc

; Include outer libraries
INCLUDELIB Kernel32.lib
INCLUDELIB irvine32.lib
INCLUDELIB user32.lib

; Include inner include files
INCLUDE Main.inc
INCLUDE Initialization.inc
INCLUDE Renderer.inc


; ===========
; = Equates =
; ===========

; The program entry
ProgramEntry EQU _start@0

; The size of the screen buffer
SCREEN_BUFFER_WIDTH  EQU <128>  ; 128 (2^7) chars, 64 (2^6) blocks
SCREEN_BUFFER_HEIGHT EQU <32>   ;  32 (2^5) chars, 32 (2^5) blocks

; The size of the window size
WINDOW_WIDTH         EQU <128>  ; 128 (2^7) chars, 64 (2^6) blocks
WINDOW_HEIGHT        EQU <32>   ;  32 (2^5) chars, 32 (2^5) blocks

; Render
RENDER_BUFFER_CLEAR_CHAR EQU <49>   ; TODO: Test value
RENDER_BUFFER_CLEAR_ATTR EQU <49>   ; TODO: Test value
RENDER_BUFFER_DISCARD    EQU <0>    ; TODO: Test value

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

; Texts
CRLF_C   EQU <0dh, 0ah>   ; CR and LF characters


; ==============
; = Structures =
; ==============

; Render buffer
RENDER_BUFFER STRUCT
    characters BYTE SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(?)
    attributes WORD SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(?)
RENDER_BUFFER ENDS

CMD_IMAGE STRUCT
    imageSize  COORD <>
    characters BYTE  <>
    attributes WORD  <>
CMD_IMAGE ENDS


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
stdRenderBuffer  RENDER_BUFFER <>
stdRenderOrigin  COORD         <0, 0>

; Test
testString BYTE CRLF_C
           BYTE "~~~ HITLERIN und PANZER ~~~", CRLF_C
           BYTE CRLF_C
           BYTE "Battle City x Waifu x Console x MASM", CRLF_C
           BYTE CRLF_C, 0


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
