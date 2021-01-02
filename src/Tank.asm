TITLE Tank (Tank.asm)

; ========
; = Tank =
; ========

; The main handler of the tanks


;; PrintTank
;; print tank
PrintTank PROC USES eax ebx ecx esi edi,
    thisOutputHandle: DWORD,
    thisTank: PTR Tank,
	gameMap: PTR BYTE,
    countWord: PTR DWORD

    mov esi, thisTank
    movzx eax, (TANK PTR [esi]).role
    movzx edi, (TANK PTR [esi]).faceTo
    .IF eax == ROLE_PLAYER
        .IF     edi == FACE_UP
            mov edi, OFFSET tankCmdImageUp
        .ELSEIF edi == FACE_RIGHT
            mov edi, OFFSET tankCmdImageRight
        .ELSEIF edi == FACE_DOWN
            mov edi, OFFSET tankCmdImageDown
        .ELSEIF edi == FACE_LEFT
            mov edi, OFFSET tankCmdImageLeft
        .ENDIF
    .ELSE
        .IF     edi == FACE_UP
            mov edi, OFFSET tankCmdImageEnemyUp
        .ELSEIF edi == FACE_RIGHT
            mov edi, OFFSET tankCmdImageEnemyRight
        .ELSEIF edi == FACE_DOWN
            mov edi, OFFSET tankCmdImageEnemyDown
        .ELSEIF edi == FACE_LEFT
            mov edi, OFFSET tankCmdImageEnemyLeft
        .ENDIF
    .ENDIF

    INVOKE PushRenderBufferImageDiscardable,
        RENDER_BUFFER_LAYER_TANKS,
        edi,
        (TANK PTR [esi]).position
    
    mov edi, gameMap
    INVOKE GetRenderBufferIndex, (TANK PTR [esi]).position
    movzx eax, ax
    movzx ebx, (TANK PTR [esi]).role
    .IF     ebx == ROLE_PLAYER
        ; add eax, 128*(PTR Tank [esi]).position.y)+(PTR Tank [esi]).position.x
	    mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_PLAYER
        inc eax
        mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_PLAYER
        inc eax
	    mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_PLAYER

        add eax, GAME_MAP_WIDTH - 2    ; 128-2
        mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_PLAYER
        inc eax
        mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_PLAYER
        inc eax
	    mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_PLAYER

        add eax, GAME_MAP_WIDTH - 2    ; 128-2
        mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_PLAYER
        inc eax
        mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_PLAYER
        inc eax
	    mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_PLAYER

    .ELSEIF ebx == ROLE_ENEMY
        ; add eax, 128*(PTR Tank [esi]).position.y)+(PTR Tank [esi]).position.x
	    mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_ENEMY
        inc eax
        mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_ENEMY
        inc eax
	    mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_ENEMY

        add eax, GAME_MAP_WIDTH - 2    ; 128-2
        mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_ENEMY
        inc eax
        mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_ENEMY
        inc eax
	    mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_ENEMY

        add eax, GAME_MAP_WIDTH - 2    ; 128-2
        mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_ENEMY
        inc eax
        mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_ENEMY
        inc eax
	    mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_ENEMY
    .ENDIF

    ; INVOKE WriteConsoleOutputAttribute,  ; set color
    ;     thisOutputHandle,
    ;     ADDR (Tank PTR [esi]).firstColor,
    ;     3,
    ;     (Tank PTR [esi]).position,
    ;     countWord
    ; INVOKE WriteConsoleOutputCharacter,  ; 設定字母
    ;     thisOutputHandle, 
    ;     ADDR (Tank PTR [esi]).firstLine,
    ;     3,
    ;     (Tank PTR [esi]).position,
    ;     countWord
    
    ; inc (Tank PTR [esi]).position.Y 

    ; INVOKE WriteConsoleOutputAttribute,  ; set color
    ;     thisOutputHandle,
    ;     ADDR (Tank PTR [esi]).secondColor,
    ;     3,
    ;     (Tank PTR [esi]).position,
    ;     countWord
    ; INVOKE WriteConsoleOutputCharacter,  ; 設定字母
    ;     thisOutputHandle, 
    ;     ADDR (Tank PTR [esi]).secondLine,
    ;     3,
    ;     (Tank PTR [esi]).position,
    ;     countWord

    ; inc (Tank PTR [esi]).position.Y

    ; INVOKE WriteConsoleOutputAttribute,  ; set color
    ;     thisOutputHandle,
    ;     ADDR (Tank PTR [esi]).firstColor,
    ;     3,
    ;     (Tank PTR [esi]).position,
    ;     countWord
    ; INVOKE WriteConsoleOutputCharacter,  ; 設定字母
    ;     thisOutputHandle, 
    ;     ADDR (Tank PTR [esi]).thirdLine,
    ;     3,
    ;     (Tank PTR [esi]).position,
    ;     countWord

    ; sub (Tank PTR [esi]).position.Y, 2
    ret
PrintTank ENDP

;; EraseTank
;; clear the tank in order to move
EraseTank PROC USES eax esi edi,
    thisOutputHandle: DWORD,
    thisTank: PTR TANK,
	gameMap: PTR BYTE,
    countWord: PTR DWORD

    mov esi, thisTank

    ; INVOKE PushRenderBufferImageBlank,
    ;     RENDER_BUFFER_LAYER_TANKS,
    ;     (TANK PTR [esi]).position,
    ;     tankSize

    mov edi, GameMap
    INVOKE GetRenderBufferIndex, (TANK PTR [esi]).position
    movzx eax, ax
    ; add eax, 128*(PTR Tank [esi]).position.y)+(PTR Tank [esi]).position.x

	mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_EMPTY
    inc eax
    mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_EMPTY
    inc eax
	mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_EMPTY

    add eax, GAME_MAP_WIDTH - 2    ; 128-2
    mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_EMPTY
    inc eax
    mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_EMPTY
    inc eax
	mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_EMPTY

    add eax, GAME_MAP_WIDTH - 2    ; 128-2
    mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_EMPTY
    inc eax
    mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_EMPTY
    inc eax
	mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_EMPTY

;     mov ecx, 3
; EraseTank_ClearRow:
;     push ecx
;     INVOKE WriteConsoleOutputAttribute,  ; set color
;         thisOutputHandle,
;         ADDR (TANK PTR [esi]).firstColor,
;         3,
;         (TANK PTR [esi]).position,
;         countWord

;     INVOKE WriteConsoleOutputCharacter,  ; 設定字母
;         thisOutputHandle, 
;         ADDR (TANK PTR [esi]).threeWhite,
;         3,
;         (TANK PTR [esi]).position,
;         countWord
;     add (TANK PTR [esi]).position.Y, 1
;     pop ecx
;     loop EraseTank_ClearRow

;     sub (TANK PTR [esi]).position.Y, 3
    ret
EraseTank ENDP

;; ChangeFaceTo
;; change direction 
ChangeFaceTo PROC USES eax esi,
    thisTank: PTR TANK,
    newFaceTo: BYTE

    mov al, newFaceTo
    mov esi, thisTank

    mov (TANK PTR [esi]).faceTo, al

;     cmp al, 1h				
;     je ChangeFaceTo_ChangeToFaceUp
;     cmp al, 2h
;     je ChangeFaceTo_ChangeToFaceRight
;     cmp al, 3h
;     je ChangeFaceTo_ChangeToFaceDown
;     jmp ChangeFaceTo_ChangeToFaceLeft


; ChangeFaceTo_ChangeToFaceUp:
;     mov (TANK PTR [esi]).firstLine[0], ' '
;     mov (TANK PTR [esi]).firstLine[1], 7Ch
;     mov (TANK PTR [esi]).firstLine[2], ' '

;     mov (TANK PTR [esi]).secondLine[0], 23h
;     mov (TANK PTR [esi]).secondLine[2], 23h
    
;     mov (TANK PTR [esi]).thirdLine[0], 23h
;     mov (TANK PTR [esi]).thirdLine[1], 2Bh
;     mov (TANK PTR [esi]).thirdLine[2], 23h
;     mov (TANK PTR [esi]).faceTo, 1h

;     jmp ChangeFaceTo_ChangeEnd
; ChangeFaceTo_ChangeToFaceRight:
;     mov (TANK PTR [esi]).firstLine[0], 23h
;     mov (TANK PTR [esi]).firstLine[1], 23h
;     mov (TANK PTR [esi]).firstLine[2], ' '

;     mov (TANK PTR [esi]).secondLine[0], 2Bh
;     mov (TANK PTR [esi]).secondLine[2], 2Dh
    
;     mov (TANK PTR [esi]).thirdLine[0], 23h
;     mov (TANK PTR [esi]).thirdLine[1], 23h
;     mov (TANK PTR [esi]).thirdLine[2], ' '
;     mov (TANK PTR [esi]).faceTo, 2h

;     jmp ChangeFaceTo_ChangeEnd
; ChangeFaceTo_ChangeToFaceDown:
;     mov (TANK PTR [esi]).firstLine[0], 23h
;     mov (TANK PTR [esi]).firstLine[1], 2Bh
;     mov (TANK PTR [esi]).firstLine[2], 23h

;     mov (TANK PTR [esi]).secondLine[0], 23h
;     mov (TANK PTR [esi]).secondLine[2], 23h
    
;     mov (TANK PTR [esi]).thirdLine[0], ' '
;     mov (TANK PTR [esi]).thirdLine[1], 7Ch
;     mov (TANK PTR [esi]).thirdLine[2], ' '
    
;     mov (TANK PTR [esi]).faceTo, 3h

;     jmp ChangeFaceTo_ChangeEnd
; ChangeFaceTo_ChangeToFaceLeft:
;     mov (TANK PTR [esi]).firstLine[0], ' '
;     mov (TANK PTR [esi]).firstLine[1], 23h
;     mov (TANK PTR [esi]).firstLine[2], 23h

;     mov (TANK PTR [esi]).secondLine[0], 2Dh
;     mov (TANK PTR [esi]).secondLine[2], 2Bh
    
;     mov (TANK PTR [esi]).thirdLine[0], ' '
;     mov (TANK PTR [esi]).thirdLine[1], 23h
;     mov (TANK PTR [esi]).thirdLine[2], 23h

;     mov (TANK PTR [esi]).faceTo, 4h

;     jmp ChangeFaceTo_ChangeEnd
; ChangeFaceTo_ChangeEnd:
    ret
ChangeFaceTo ENDP

;; MoveTank
;; move tank
MoveTank PROC USES eax edi esi, 
    thisOutputHandle: DWORD, 
    thisTank: PTR Tank,
	gameMap: PTR BYTE,
    direction: WORD,
    countWord: PTR DWORD
    LOCAL checkPosition:COORD

    INVOKE EraseTank, thisOutputHandle, thisTank, gameMap, countWord
    xor eax, eax
    mov ax, direction
    mov esi, thisTank
    mov edi, gameMap
    
    cmp ax, 4800h  ; move up
    je MoveTank_MoveUp
    cmp ax, 4D00h  ; move right 
    je MoveTank_MoveRight
    cmp ax, 5000h
    je MoveTank_MoveDown
    cmp ax, 4B00h
    je MoveTank_MoveLeft
    jmp MoveTank_PrintMove

MoveTank_MoveUp:
    mov al, (TANK PTR [esi]).faceTo
    cmp al, FACE_UP
    je MoveTank_SubY
    INVOKE ChangeFaceTo, thisTank, FACE_UP
    jmp MoveTank_PrintMove
MoveTank_SubY:
    mov ax, (TANK PTR [esi]).position.y
    dec ax
    mov checkPosition.y, ax
    mov ax, (TANK PTR [esi]).position.x
    mov checkPosition.x, ax

    INVOKE GetRenderBufferIndex, checkPosition
    cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
    jne MoveTank_Return

    inc checkPosition.x
    INVOKE GetRenderBufferIndex, checkPosition
    cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
    jne MoveTank_Return
    
    inc checkPosition.x
    INVOKE GetRenderBufferIndex, checkPosition
    cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
    jne MoveTank_Return

    sub (TANK PTR [esi]).position.Y, 1
    ; mov ax, (TANK PTR [esi]).position.Y
    ; .IF ax == 0h
    ;     add (TANK PTR [esi]).position.Y, 1
    ; .ENDIF
    jmp MoveTank_PrintMove
MoveTank_MoveRight:
    mov al, (TANK PTR [esi]).faceTo
    cmp al, FACE_RIGHT
    je MoveTank_AddX
    INVOKE ChangeFaceTo, thisTank, FACE_RIGHT
    jmp MoveTank_PrintMove
MoveTank_AddX:
    mov ax, (TANK PTR [esi]).position.x
    add ax, 3
    mov checkPosition.x, ax
    mov ax, (TANK PTR [esi]).position.y
    mov checkPosition.y, ax

    INVOKE GetRenderBufferIndex, checkPosition
    cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
    jne MoveTank_Return
    
    inc checkPosition.y
    INVOKE GetRenderBufferIndex, checkPosition
    cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
    jne MoveTank_Return

    inc checkPosition.y
    INVOKE GetRenderBufferIndex, checkPosition
    cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
    jne MoveTank_Return

    add (TANK PTR [esi]).position.X, 1
    ; mov ax, (TANK PTR [esi]).position.X
    ; .IF ax == 7Dh  ; 125
    ;     sub (TANK PTR [esi]).position.X, 1
    ; .ENDIF
    jmp MoveTank_PrintMove
MoveTank_MoveDown:
    mov al, (TANK PTR [esi]).faceTo
    cmp al, FACE_DOWN
    je MoveTank_AddY
    INVOKE ChangeFaceTo, thisTank, FACE_DOWN
    jmp MoveTank_PrintMove
MoveTank_AddY:
    mov ax, (TANK PTR [esi]).position.y
    add ax, 3
    mov checkPosition.y, ax
    mov ax, (TANK PTR [esi]).position.x
    mov checkPosition.x, ax

    INVOKE GetRenderBufferIndex, checkPosition
    cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
    jne MoveTank_Return
    
    inc checkPosition.x
    INVOKE GetRenderBufferIndex, checkPosition
    cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
    jne MoveTank_Return

    inc checkPosition.x
    INVOKE GetRenderBufferIndex, checkPosition
    cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
    jne MoveTank_Return

    add (TANK PTR [esi]).position.Y, 1
    ; mov ax, (TANK PTR [esi]).position.Y
    ; .IF ax == 1Dh
    ;     sub (TANK PTR [esi]).position.Y, 1
    ; .ENDIF
    jmp MoveTank_PrintMove
MoveTank_MoveLeft:
    mov al, (TANK PTR [esi]).faceTo
    cmp al, FACE_LEFT
    je MoveTank_SubX
    INVOKE ChangeFaceTo, thisTank, FACE_LEFT
    jmp MoveTank_PrintMove
MoveTank_SubX:
    mov ax, (TANK PTR [esi]).position.x
    dec ax
    mov checkPosition.x, ax
    mov ax, (TANK PTR [esi]).position.y
    mov checkPosition.y, ax

    INVOKE GetRenderBufferIndex, checkPosition
    cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
    jne MoveTank_Return
    
    inc checkPosition.y
    INVOKE GetRenderBufferIndex, checkPosition
    cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
    jne MoveTank_Return

    inc checkPosition.y
    INVOKE GetRenderBufferIndex, checkPosition
    cmp BYTE PTR [edi + eax], GAME_MAP_CHAR_EMPTY
    jne MoveTank_Return

    sub (TANK PTR [esi]).position.X, 1
    ; mov ax, (TANK PTR [esi]).position.X
    ; .IF ax == 0h
    ;     add (TANK PTR [esi]).position.X, 1
    ; .ENDIF
    jmp MoveTank_PrintMove
MoveTank_PrintMove:
    ; INVOKE PrintTank, thisOutputHandle, thisTank, gameMap, countWord
MoveTank_Return:
    INVOKE PrintTank, thisOutputHandle, thisTank, gameMap, countWord
    ret
MoveTank ENDP
