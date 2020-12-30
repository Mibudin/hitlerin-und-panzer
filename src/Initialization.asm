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

;; InitGameMapRecord
InitGameMapRecord PROC USES ecx esi edi
    cld
    mov ecx, GAME_MAP_WIDTH * GAME_MAP_HEIGHT
    mov esi, OFFSET mapCmdImage_characters
    mov edi, OFFSET gameMapRecord
    rep movsb

    ret
InitGameMapRecord ENDP

;; InitTanks
InitTanks PROC USES eax ecx
;     mov ecx, ENEMY_TANK_AMOUNT

; InitTanks_SetEnemyTanks:
;     mov eax, enemyField.top
;     call RandomRange

;     mov eax, enemyField.left
;     call RandomRange

;     mov eax, enemyField.bottom
;     sub eax, enemyField.top
;     call RandomRange

;     mov eax, enemyField.right
;     sub eax, enemyField.left
;     call RandomRange

;     loop InitTanks_SetEnemyTanks

    ret
InitTanks ENDP

;;  InitGame
InitGame PROC
    call Randomize

    call InitHandle
    call InitScreen

    call InitGameMapRecord
    call InitTanks

    mov gameState, GAME_STATE_START
    mov gameTickCount, 0

    ret
InitGame ENDP
