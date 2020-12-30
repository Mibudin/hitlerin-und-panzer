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
InitScreen PROC USES eax
    ; TODO: preset cosole font etc.
    INVOKE SetConsoleScreenBufferSize, stdOutputHandle, screenBufferSize
    INVOKE SetConsoleWindowInfo, stdOutputHandle, TRUE, ADDR screenBufferInfo.srWindow
    call Clrscr

    INVOKE SetConsoleTitle, ADDR windowTitle

    ret
InitScreen ENDP

;; InitGameMap
InitGameMap PROC USES ecx esi edi
    cld
    mov ecx, GAME_MAP_WIDTH * GAME_MAP_HEIGHT
    mov esi, OFFSET mapCmdImage_characters
    mov edi, OFFSET gameMapRecord
    rep movsb

    ret
InitGameMap ENDP

;;  InitGame
InitGame PROC
    call InitHandle
    call InitScreen
    call InitGameMap

    call Randomize

    mov gameState, GAME_STATE_START
    mov gameTickCount, 0

    ret
InitGame ENDP
