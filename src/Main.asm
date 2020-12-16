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
; TODO:


; ===========
; = Equates =
; ===========

; The WinDbg debugger entry
main EQU start@0

; The size of the screen buffer
SCREEN_BUFFER_WIDTH  EQU <128>  ; 128 chars, 64 blocks
SCREEN_BUFFER_HEIGHT EQU <36>   ;  36 chars, 36 blocks

; The size of the window size
WINDOW_WIDTH         EQU <128>  ; 128 chars, 64 blocks
WINDOW_HEIGHT        EQU <36>   ;  36 chars, 36 blocks

; Texts
CRLF_C EQU <0dh, 0ah>


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
stdOutputHandle DWORD ?
stdInputHandle  DWORD ?

; The screen buffer and window data
screenBufferSize COORD                      <SCREEN_BUFFER_WIDTH, SCREEN_BUFFER_HEIGHT>
screenBufferInfo CONSOLE_SCREEN_BUFFER_INFO <<SCREEN_BUFFER_WIDTH, SCREEN_BUFFER_HEIGHT>, <0, 0>, 0, <0, 0, WINDOW_WIDTH - 1, WINDOW_HEIGHT - 1>, <WINDOW_WIDTH, WINDOW_HEIGHT>>
windowSize       COORD                      <WINDOW_WIDTH, WINDOW_HEIGHT>
windowPosition   SMALL_RECT                 <0, 0, WINDOW_WIDTH - 1, WINDOW_HEIGHT - 1>

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

; = The main procedure
Main PROC
    call InitGame

    mov edx, OFFSET testString
    call WriteString

    call WaitMsg

    exit
Main ENDP

; Includes
INCLUDE Initialization.asm  ; The major initialization part of the game

END main
