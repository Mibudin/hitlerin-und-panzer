TITLE Test (test.asm)

INCLUDE Irvine32.inc

INCLUDELIB Kernel32.lib
INCLUDELIB irvine32.lib
INCLUDELIB user32.lib

main EQU start@0

.data
myID   DWORD ?
digit0 BYTE  2
digit1 BYTE  5
digit2 BYTE  2
digit3 BYTE  3

.code
Main PROC
    mov eax, 0      ; Initialize eax to 0 (eax = 0x00000000)

    mov ah, digit0  ; ah = Digit0 (ah in eax: 0x0000__00)
    mov al, digit1  ; al = Digit1 (al in eax: 0x000000__)
    shl eax, 16     ; Shift eax left 16 bits (eax: 0x0000???? -> 0x????0000)

    mov ah, digit2  ; ah = Digit2 (ah in eax: 0x0000__00)
    mov al, digit3  ; al = Digit3 (al in eax: 0x000000__)

    mov myID, eax   ; MyID = eax (the result)

    call WriteHex
    call Crlf

    exit            ; Exit this program
Main ENDP
END main
