TITLE Main (Main.asm)

; ========
; = Main =
; ========

; The main program file and the major entry of this project.


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
INCLUDE Renderer.inc


; ===========
; = Equates =
; ===========

; The WinDbg debugger entry
main EQU start@0

; The size of the screen buffer
SCREEN_BUFFER_WIDTH  EQU <128>  ; 128 chars, 64 blocks
SCREEN_BUFFER_HEIGHT EQU <32>   ;  32 chars, 32 blocks

; The size of the window size
WINDOW_WIDTH         EQU <128>  ; 128 chars, 64 blocks
WINDOW_HEIGHT        EQU <32>   ;  32 chars, 32 blocks

; Texts
CRLF_C   EQU <0dh, 0ah>   ; CR and LF

; CMD color codes (Combinable)
COLOR_FB EQU <00000001b>  ; FOREGROUND_BLUE      EQU <00000001b>
COLOR_FG EQU <00000010b>  ; FOREGROUND_GREEN     EQU <00000010b>
COLOR_FR EQU <00000100b>  ; FOREGROUND_RED       EQU <00000100b>
COLOR_FI EQU <00001000b>  ; FOREGROUND_INTENSITY EQU <00001000b>
COLOR_BB EQU <00010000b>  ; BACKGROUND_BLUE      EQU <00010000b>
COLOR_BG EQU <00100000b>  ; BACKGROUND_GREEN     EQU <00100000b>
COLOR_BR EQU <01000000b>  ; BACKGROUND_RED       EQU <01000000b>
COLOR_BI EQU <10000000b>  ; BACKGROUND_INTENSITY EQU <10000000b>

; Render
RENDER_BUFFER_LAYERS EQU <3>



; ==============
; = Structures =
; ==============
; TODO:


; ================
; = Data Segment =
; ================
.data

; The title of the window
windowTitle BYTE "HITLERIN und PANZER", 0

; The standard handles
stdOutputHandle        DWORD ?
stdInputHandle         DWORD ?

; The screen buffer and window data
screenBufferSize       COORD                      <SCREEN_BUFFER_WIDTH, SCREEN_BUFFER_HEIGHT>
screenBufferInfo       CONSOLE_SCREEN_BUFFER_INFO <<SCREEN_BUFFER_WIDTH, SCREEN_BUFFER_HEIGHT>, <0, 0>, 0, <0, 0, WINDOW_WIDTH - 1, WINDOW_HEIGHT - 1>, <WINDOW_WIDTH, WINDOW_HEIGHT>>
windowSize             COORD                      <WINDOW_WIDTH, WINDOW_HEIGHT>
windowPosition         SMALL_RECT                 <0, 0, WINDOW_WIDTH - 1, WINDOW_HEIGHT - 1>

; The render buffer
renderBufferCharacters BYTE RENDER_BUFFER_LAYERS DUP(SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(0))
renderBufferAttributes WORD RENDER_BUFFER_LAYERS DUP(SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT DUP(0))

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

; The earliest beginning of the game
GameBegin:

;;  The main procedure
Main PROC
    LOCAL pos:COORD

    call InitGame

    mov edx, OFFSET testString
    call WriteString

    mov pos.x, 117
    mov pos.y, 17
    INVOKE RenderBufferIndex, 2, pos
    call WriteInt
    call CRlf

    call WaitMsg

    exit
Main ENDP

; Includes
INCLUDE Initialization.asm  ; The major initialization part of the game
INCLUDE Renderer.asm        ; The major rendering part of the game

END main
