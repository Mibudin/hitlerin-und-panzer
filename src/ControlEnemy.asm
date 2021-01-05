TITLE ControlEnemy (ControlEnemy.asm)

; ================
; = ControlEnemy =
; ================

; The main handler of controling enemies


;; GetDirection
GetDirection PROC USES eax esi,
    thisTank: PTR TANK,
    playerTank: PTR TANK

    mov eax, 10
    mov esi, thisTank
    ; call Randomize
    call RandomRange
    inc eax
    cmp eax, 5
    jb GetDirection_ChooseOneDirection
    cmp eax, 8
    jb GetDirection_StayDirection
    jmp GetDirection_FaceToPlayer
GetDirection_ChooseOneDirection:
    mov (TANK PTR [esi]).faceTo, al
    jmp GetDirection_Return
GetDirection_StayDirection:
    jmp GetDirection_Return
GetDirection_FaceToPlayer:
    INVOKE Detect, thisTank, playerTank
    jmp GetDirection_Return
GetDirection_Return:
    ret
GetDirection ENDP

;; ComputerTankMove
ComputerTankMove PROC USES eax esi,
    thisOutputHandle: DWORD,
    thisTank: PTR TANK,
    countWord: PTR DWORD

ComputerTankMove_CheckDirection:
    mov esi, thisTank
    xor eax, eax
    mov al, (TANK PTR [esi]).faceTo
    .IF     (al == FACE_UP)
    	mov ax, 4800h
        jmp ComputerTankMove_CallMoveTank
    .ELSEIF (al == FACE_RIGHT)
    	mov ax, 4D00h
        jmp ComputerTankMove_CallMoveTank
    .ELSEIF (al == FACE_DOWN)
    	mov ax, 5000h
        jmp ComputerTankMove_CallMoveTank
    .ELSEIF (al == FACE_LEFT)
    	mov ax, 4B00h
        jmp ComputerTankMove_CallMoveTank
    .ELSE
        jmp ComputerTankMove_Return
    .ENDIF
ComputerTankMove_CallMoveTank:
    INVOKE MoveTank, thisOutputHandle, thisTank, ADDR gameMapRecord, ax, countWord
ComputerTankMove_Return:
    ret
ComputerTankMove ENDP

;; Detect
Detect PROC USES ax bx cx dx esi edi,
    thisTank: PTR TANK,
    playerTank: PTR TANK

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
        .ELSE
            mov (TANK PTR [esi]).faceTo, FACE_RIGHT
            INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
        .ENDIF
    .ELSEIF ax > cx && bx < dx
        sub ax, cx
        sub dx, bx
        .IF ax < dx
            mov (TANK PTR [esi]).faceTo, FACE_DOWN
            INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
        .ELSE
            mov (TANK PTR [esi]).faceTo, FACE_LEFT
            INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
        .ENDIF
    .ELSEIF ax < cx && bx > dx
        sub cx, ax
        sub bx, dx
        .IF cx < bx
            mov (TANK PTR [esi]).faceTo, FACE_UP
            INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
        .ELSE
            mov (TANK PTR [esi]).faceTo, FACE_RIGHT
            INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
        .ENDIF
    .ELSE
        sub ax, cx
        sub bx, dx
        .IF ax < bx
            mov (TANK PTR [esi]).faceTo, FACE_UP
            INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
        .ELSE
            mov (TANK PTR [esi]).faceTo, FACE_LEFT
            INVOKE ChangeFaceTo, thisTank, (TANK PTR [esi]).faceTo
        .ENDIF
    .ENDIF
    ret
Detect ENDP

;; Shoot
;; Returns:
;;     EAX: Whether this tank shooted
;;          1: True; 0: False
Shoot PROC USES ecx edx,
    thisTank: PTR TANK,
    playerTank: PTR TANK

    mov eax, 20
    call RandomRange
    cmp eax, 1
    jb Shoot_Shoot
    mov eax, FALSE
    jmp Shoot_Return
Shoot_Shoot:
    ; INVOKE Detect, thisTank, playerTank
    INVOKE NewBullet,
        thisTank,
        ADDR gameBulletCurrentAmount,
        ADDR gameBulletList,
        ADDR gameMapRecord
    mov eax, TRUE

Shoot_Return:
    ret
Shoot ENDP
