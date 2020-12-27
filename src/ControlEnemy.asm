TITLE ControlEnemy (ControlEnemy.asm)

; ================
; = ControlEnemy =
; ================

; The main handler of controling enemies


;; GetDirection
GetDirection PROC USES eax esi, thisTank: PTR Tank
    mov eax, 4
    mov esi, thisTank
    call Randomize
    call RandomRange
    inc eax
    mov (TANK PTR [esi]).faceTo, al
    ret
GetDirection ENDP

;; MoveRandom
MoveRandom PROC USES eax ecx esi edi, thisOutputHandle: DWORD, thisTank: PTR TANK, GameMap: PTR BYTE, countWord: PTR DWORD
    LOCAL checkPosition:COORD

    mov esi, thisTank
    mov edi, GameMap
MoveRandom_Set:
    xor eax, eax
    mov al, (TANK PTR [esi]).faceTo
    .IF     (al == FACE_UP)
        mov ax, ((TANK PTR [esi]).position.y - 1)           ; 0 is boundary, so Y need to - 1
    .ELSEIF (al == FACE_RIGHT)
        mov ax, GAME_MAP_WIDTH - 2                          ; 127 is boundary, so 127 need to - 1
        sub ax, (TANK PTR [esi]).position.x
    .ELSEIF (al == FACE_DOWN)
        mov ax, GAME_MAP_HEIGHT - 2                         ; 31 is boundary, so 31 need to - 1
        sub ax, (TANK PTR [esi]).position.y
    .ELSEIF (al == FACE_LEFT)
        mov ax, ((TANK PTR [esi]).position.x - 1)           ; 0 is boundary, so X need to - 1
    .ENDIF

    ; .IF ((TANK PTR [esi]).faceTo == FACE_UP)
    ;     mov eax, ((TANK PTR [esi]).Y - 1)           ; 0 is boundary, so Y need to - 1
    ; .ELSEIF ((TANK PTR [esi]).faceTo == FACE_RIGHT)
    ;     mov eax, (126 - (TANK PTR [esi]).X)         ; 127 is boundary, so 127 need to - 1
    ; .ELSEIF ((TANK PTR [esi]).faceTo == FACE_DOWN)
    ;     mov eax, (30 - (TANK PTR [esi]).Y)          ; 31 is boundary, so 31 need to - 1
    ; .ELSEIF ((TANK PTR [esi]).faceTo == FACE_LEFT)
    ;     mov eax, ((TANK PTR [esi]).X - 1)           ; 0 is boundary, so X need to - 1
    ; .ENDIF
MoveRandom_Random:
    call Randomize
    call RandomRange
    inc eax
    mov ecx, eax
MoveRandom_Check:
    ;; Use GetRenderBufferIndex temporarily (perhaps)
    xor eax, eax
    mov al, (TANK PTR [esi]).faceTo
    .IF     (al == FACE_UP)
        mov ax, (TANK PTR [esi]).position.y
        dec ax
        mov checkPosition.y, ax
        mov ax, (TANK PTR [esi]).position.x
        mov checkPosition.x, ax

        INVOKE GetRenderBufferIndex, checkPosition
        cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
        jne MoveRandom_Return
    
        inc checkPosition.x
        INVOKE GetRenderBufferIndex, checkPosition
        cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
        jne MoveRandom_Return

        inc checkPosition.x
        cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
        jne MoveRandom_Return

        jmp MoveRandom_Move

    .ELSEIF (al == FACE_RIGHT)
        mov ax, (TANK PTR [esi]).position.x
        add ax, 3
        mov checkPosition.x, ax
        mov ax, (TANK PTR [esi]).position.y
        mov checkPosition.y, ax

        INVOKE GetRenderBufferIndex, checkPosition
        cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
        jne MoveRandom_Return
    
        inc checkPosition.y
        INVOKE GetRenderBufferIndex, checkPosition
        cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
        jne MoveRandom_Return

        inc checkPosition.y
        cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
        jne MoveRandom_Return

        jmp MoveRandom_Move

    .ELSEIF (al == FACE_DOWN)
        mov ax, (TANK PTR [esi]).position.y
        add ax, 3
        mov checkPosition.y, ax
        mov ax, (TANK PTR [esi]).position.x
        mov checkPosition.x, ax

        INVOKE GetRenderBufferIndex, checkPosition
        cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
        jne MoveRandom_Return
    
        inc checkPosition.x
        INVOKE GetRenderBufferIndex, checkPosition
        cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
        jne MoveRandom_Return

        inc checkPosition.x
        cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
        jne MoveRandom_Return

        jmp MoveRandom_Move

    .ELSEIF (al == FACE_LEFT)
        mov ax, (TANK PTR [esi]).position.x
        dec ax
        mov checkPosition.x, ax
        mov ax, (TANK PTR [esi]).position.y
        mov checkPosition.y, ax

        INVOKE GetRenderBufferIndex, checkPosition
        cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
        jne MoveRandom_Return
    
        inc checkPosition.y
        INVOKE GetRenderBufferIndex, checkPosition
        cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
        jne MoveRandom_Return

        inc checkPosition.y
        cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
        jne MoveRandom_Return

        jmp MoveRandom_Move

    .ELSE
        jmp MoveRandom_Return

    .ENDIF

    ; .IF (((TANK PTR [esi]).faceTo = 1) and ((BYTE PTR [edi+(128*((TANK PTR [esi]).position.Y-1)+(TANK PTR [esi]).position.X)]) = ' ') and ((BYTE PTR [edi+(128*((TANK PTR [esi]).position.Y-1)+(TANK PTR [esi]).position.X+1)]) = ' ') and ((BYTE PTR [edi+(128*((TANK PTR [esi]).position.Y-1)+(TANK PTR [esi]).position.X+2)]) = ' '))
    ;     jmp MoveRandom_Move
    ; .ELSEIF (((TANK PTR [esi]).faceTo = 2) and ((BYTE PTR [edi+(128*((TANK PTR [esi]).position.Y)+(TANK PTR [esi]).position.X+3)]) = ' ') and ((BYTE PTR [edi+(128*((TANK PTR [esi]).position.Y+1)+(TANK PTR [esi]).position.X+3)]) = ' ') and ((BYTE PTR [edi+(128*((TANK PTR [esi]).position.Y+2)+(TANK PTR [esi]).position.X+3)]) = ' '))
    ;     jmp MoveRandom_Move
    ; .ELSEIF (((TANK PTR [esi]).faceTo = 3) and ((BYTE PTR [edi+(128*((TANK PTR [esi]).position.Y+3)+(TANK PTR [esi]).position.X)]) = ' ') and ((BYTE PTR [edi+(128*((TANK PTR [esi]).position.Y+3)+(TANK PTR [esi]).position.X+1)]) = ' ') and ((BYTE PTR [edi+(128*((TANK PTR [esi]).position.Y+3)+(TANK PTR [esi]).position.X+2)]) = ' '))
    ;     jmp MoveRandom_Move
    ; .ELSEIF (((TANK PTR [esi]).faceTo = 4) and ((BYTE PTR [edi+(128*((TANK PTR [esi]).position.Y)+(TANK PTR [esi]).position.X-1)]) = ' ') and ((BYTE PTR [edi+(128*((TANK PTR [esi]).position.Y+1)+(TANK PTR [esi]).position.X-1)]) = ' ') and ((BYTE PTR [edi+(128*((TANK PTR [esi]).position.Y+2)+(TANK PTR [esi]).position.X-1)]) = ' '))
    ;     jmp MoveRandom_Move
    ; .ELSE
    ;     jmp MoveRandom_Return
MoveRandom_Move:
    INVOKE MoveTank, thisOutputHandle, thisTank, (TANK PTR [esi]).faceTo, countWord
MoveRandom_Loop:
    loop MoveRandom_Move
MoveRandom_Return:
    ret
MoveRandom ENDP

;; DetectShoot
;; TODO: 射一發子彈
DetectShoot PROC USES ax bx cx dx esi edi, thisTank: PTR TANK, playerTank: PTR TANK
    mov esi, thisTank
    mov edi, playerTank

    mov ax, (TANK PTR [esi]).position.x
    mov bx, (TANK PTR [esi]).position.y
    mov cx, (TANK PTR [edi]).position.x
    mov dx, (TANK PTR [edi]).position.y

    .IF     ax < cx && bx < dx
        sub cx, ax
        sub dx, bx
        .IF cx < dx
            mov (TANK PTR [esi]).faceTo, FACE_DOWN
            INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
            ; 射一發子彈
        .ELSE
            mov (TANK PTR [esi]).faceTo, FACE_RIGHT
            INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
            ; 射一發子彈
        .ENDIF
    .ELSEIF ax > cx && bx < dx
        sub ax, cx
        sub dx, bx
        .IF ax < dx
            mov (TANK PTR [esi]).faceTo, FACE_DOWN
            INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
            ; 射一發子彈
        .ELSE
            mov (TANK PTR [esi]).faceTo, FACE_LEFT
            INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
            ; 射一發子彈
        .ENDIF
    .ELSEIF ax < cx && bx > dx
        sub cx, ax
        sub bx, dx
        .IF cx < bx
            mov (TANK PTR [esi]).faceTo, FACE_UP
            INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
            ; 射一發子彈
        .ELSE
            mov (TANK PTR [esi]).faceTo, FACE_RIGHT
            INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
            ; 射一發子彈
        .ENDIF
    .ELSE
        sub ax, cx
        sub bx, dx
        .IF ax < bx
            mov (TANK PTR [esi]).faceTo, FACE_UP
            INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
            ; 射一發子彈
        .ELSE
            mov (TANK PTR [esi]).faceTo, FACE_LEFT
            INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
            ; 射一發子彈
        .ENDIF
    .ENDIF

    ; .IF (((TANK PTR [esi]).position.X < (TANK PTR [edi]).position.X) AND ((TANK PTR [esi]).position.Y < (TANK PTR [edi]).position.Y))
    ;     .IF (((TANK PTR [edi]).position.X - (TANK PTR [esi]).position.X) < ((TANK PTR [edi]).position.Y - (TANK PTR [esi]).position.Y))
    ;         mov (TANK PTR [esi]).faceTo, 3
    ;         INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
    ;         ; 射一發子彈
    ;     .ELSE
    ;         mov (TANK PTR [esi]).faceTo, 2
    ;         INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
    ;         ; 射一發子彈
    ;     .ENDIF
    ; .ELSEIF (((TANK PTR [esi]).position.X > (TANK PTR [edi]).position.X) AND ((TANK PTR [esi]).position.Y < (TANK PTR [edi]).position.Y))
    ;     .IF (((TANK PTR [esi]).position.X - (TANK PTR [edi]).position.X) < ((TANK PTR [edi]).position.Y - (TANK PTR [esi]).position.Y))
    ;         mov (TANK PTR [esi]).faceTo, 3
    ;         INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
    ;         ; 射一發子彈
    ;     .ELSE
    ;         mov (TANK PTR [esi]).faceTo, 4
    ;         INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
    ;         ; 射一發子彈
    ;     .ENDIF
    ; .ELSEIF (((TANK PTR [esi]).position.X < (TANK PTR [edi]).position.X) AND ((TANK PTR [esi]).position.Y > (TANK PTR [edi]).position.Y))
    ;     .IF (((TANK PTR [edi]).position.X - (TANK PTR [esi]).position.X) < ((TANK PTR [esi]).position.Y - (TANK PTR [edi]).position.Y))
    ;         mov (TANK PTR [esi]).faceTo, 1
    ;         INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
    ;         ; 射一發子彈
    ;     .ELSE
    ;         mov (TANK PTR [esi]).faceTo, 2
    ;         INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
    ;         ; 射一發子彈
    ;     .ENDIF
    ; .ELSE
    ;     .IF (((TANK PTR [esi]).position.X - (TANK PTR [edi]).position.X) < ((TANK PTR [esi]).position.Y - (TANK PTR [edi]).position.Y))
    ;         mov (TANK PTR [esi]).faceTo, 1
    ;         INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
    ;         ; 射一發子彈
    ;     .ELSE
    ;         mov (TANK PTR [esi]).faceTo, 4
    ;         INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
    ;         ; 射一發子彈
    ;     .ENDIF
    ; .ENDIF
    ret
DetectShoot ENDP
