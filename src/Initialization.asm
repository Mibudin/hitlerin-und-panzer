TITLE Initialization (Initialization.asm)

; ==================
; = Initialization =
; ==================

; The major initialization part of the game


;;  InitHandle
InitHandle PROC USES eax
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov stdOutputHandle, eax
    INVOKE GetStdHandle, STD_INPUT_HANDLE
    mov stdinputHandle, eax

    ret
InitHandle ENDP

;;  InitScreen
InitScreen PROC
    ; TODO: preset cosole font etc.
    INVOKE SetConsoleScreenBufferSize, stdOutputHandle, screenBufferSize
    INVOKE SetConsoleWindowInfo, stdOutputHandle, TRUE, ADDR screenBufferInfo.srWindow
    call Clrscr

    INVOKE SetConsoleTitle, ADDR windowTitle

    ret
InitScreen ENDP

;;  InitGame
InitGame PROC
    call InitHandle
    call InitScreen

    ret
InitGame ENDP
