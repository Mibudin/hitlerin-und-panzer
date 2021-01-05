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

;;  InitConsole
InitConsole PROC USES eax ecx edx
    ; TODO: preset cosole font etc.

    ; Set the console mode
    INVOKE SetConsoleMode, stdInputHandle,  CONSOLE_INPUT_MODE
    INVOKE SetConsoleMode, stdOutputHandle, CONSOLE_OUTPUT_MODE

    ; Set the screen and window
    INVOKE FlushConsoleInputBuffer, stdInputHandle
    INVOKE SetConsoleScreenBufferSize, stdOutputHandle, screenBufferSize
    INVOKE SetConsoleWindowInfo, stdOutputHandle, TRUE, ADDR screenBufferInfo.srWindow
    call Clrscr

    ; Set default cursor style
    INVOKE SetConsoleCursorInfo, stdOutputHandle, ADDR stdConsoleCursorInfo

    ; Set the title
    INVOKE SetConsoleTitle, ADDR windowTitle

    ret
InitConsole ENDP

;; InitGameMapRecord
InitGameMapRecord PROC USES ecx esi edi
    cld
    mov ecx, GAME_MAP_WIDTH * GAME_MAP_HEIGHT
    mov esi, OFFSET mapCmdImage_characters
    mov edi, OFFSET gameMapRecord
    rep movsb

    ret
InitGameMapRecord ENDP

;;  InitGame
InitGame PROC
    call Randomize

    call InitHandle
    call InitConsole

    call InitRenderer

    call InitGameMapRecord

    mov gameState, GAME_STATE_START
    mov gameTickCount, 0

    ret
InitGame ENDP
