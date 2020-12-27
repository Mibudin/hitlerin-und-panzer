TITLE Tank (Tank.asm)

; ========
; = Tank =
; ========

; The main handler of the tanks


;; PrintTank
;; print tank
PrintTank PROC USES eax ecx esi edi,
    thisOutputHandle: DWORD,
    thisTank: PTR Tank,
    countWord: PTR DWORD

    mov esi, thisTank

    movzx edi, (TANK PTR [esi]).faceTo
    .IF     edi == FACE_UP
        mov edi, OFFSET tankCmdImageUp
    .ELSEIF edi == FACE_RIGHT
        mov edi, OFFSET tankCmdImageRight
    .ELSEIF edi == FACE_DOWN
        mov edi, OFFSET tankCmdImageDown
    .ELSEIF edi == FACE_LEFT
        mov edi, OFFSET tankCmdImageLeft
    .ENDIF

    INVOKE PushRenderBufferImageDiscardable,
        RENDER_BUFFER_LAYER_TANKS,
        edi,
        (TANK PTR [esi]).position

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
EraseTank PROC USES ecx esi,
    thisOutputHandle: DWORD,
    thisTank: PTR TANK,
    countWord: PTR DWORD

    mov esi, thisTank

    INVOKE PushRenderBufferImageBlank,
        RENDER_BUFFER_LAYER_TANKS,
        (TANK PTR [esi]).position,
        tankSize

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
ChangeFaceTo PROC USES eax ecx esi,
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
MoveTank PROC USES eax esi, 
    thisOutputHandle: DWORD, 
    thisTank: PTR Tank,
    direction: WORD, 
    countWord: PTR DWORD

    INVOKE EraseTank, thisOutputHandle, thisTank, countWord
    mov ax, direction
    mov esi, thisTank
    
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
    cmp al, 1h
    je MoveTank_SubY
    INVOKE ChangeFaceTo, thisTank, 1h
    jmp MoveTank_PrintMove
MoveTank_SubY:
    sub (TANK PTR [esi]).position.Y, 1
    mov ax, (TANK PTR [esi]).position.Y
    .IF ax == 0h 										
        add (TANK PTR [esi]).position.Y, 1 										
    .ENDIF
    jmp MoveTank_PrintMove
MoveTank_MoveRight:
    mov al, (TANK PTR [esi]).faceTo
    cmp al, 2h
    je MoveTank_AddX
    INVOKE ChangeFaceTo, thisTank, 2h
    jmp MoveTank_PrintMove
MoveTank_AddX:
    add (TANK PTR [esi]).position.X, 1
    mov ax, (TANK PTR [esi]).position.X
    .IF ax == 7Dh 			; 125									
        sub (TANK PTR [esi]).position.X, 1 										
    .ENDIF
    jmp MoveTank_PrintMove
MoveTank_MoveDown:
    mov al, (TANK PTR [esi]).faceTo
    cmp al, 3h
    je MoveTank_AddY
    INVOKE ChangeFaceTo, thisTank, 3h
    jmp MoveTank_PrintMove
MoveTank_AddY:
    add (TANK PTR [esi]).position.Y, 1
    mov ax, (TANK PTR [esi]).position.Y
    .IF ax == 1Dh 										
        sub (TANK PTR [esi]).position.Y, 1 										
    .ENDIF
    jmp MoveTank_PrintMove
MoveTank_MoveLeft:
    mov al, (TANK PTR [esi]).faceTo
    cmp al, 4h
    je MoveTank_SubX
    INVOKE ChangeFaceTo, thisTank, 4h
    jmp MoveTank_PrintMove
MoveTank_SubX:
    sub (TANK PTR [esi]).position.X, 1
    mov ax, (TANK PTR [esi]).position.X
    .IF ax == 0h 										
        add (TANK PTR [esi]).position.X, 1 										
    .ENDIF
    jmp MoveTank_PrintMove
MoveTank_PrintMove:
    INVOKE PrintTank, thisOutputHandle, thisTank, countWord
    ret
MoveTank ENDP
