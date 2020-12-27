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
	GameMap: PTR BYTE,
    countWord: PTR DWORD

    movzx ebx, (TANK PTR [esi]).role
    .IF     ebx == PLAYER
        mov eax, GameMap
        add eax, 128*(PTR Tank [esi]).position.y)+(PTR Tank [esi]).position.x
	    mov (PTR BYTE [eax]), '#'
        inc eax
        mov (PTR BYTE [eax]), '#'
        inc eax
	    mov (PTR BYTE [eax]), '#'

        add eax, 126    ; 128-2
        mov (PTR BYTE [eax]), '#'
        inc eax
        mov (PTR BYTE [eax]), '#'
        inc eax
	    mov (PTR BYTE [eax]), '#'

        add eax, 126    ; 128-2
        mov (PTR BYTE [eax]), '#'
        inc eax
        mov (PTR BYTE [eax]), '#'
        inc eax
	    mov (PTR BYTE [eax]), '#'
    .ELSEIF ebx == ENEMY
        mov eax, GameMap
        add eax, 128*(PTR Tank [esi]).position.y)+(PTR Tank [esi]).position.x
	    mov (PTR BYTE [eax]), '*'
        inc eax
        mov (PTR BYTE [eax]), '*'
        inc eax
	    mov (PTR BYTE [eax]), '*'

        add eax, 126    ; 128-2
        mov (PTR BYTE [eax]), '*'
        inc eax
        mov (PTR BYTE [eax]), '*'
        inc eax
	    mov (PTR BYTE [eax]), '*'

        add eax, 126    ; 128-2
        mov (PTR BYTE [eax]), '*'
        inc eax
        mov (PTR BYTE [eax]), '*'
        inc eax
	    mov (PTR BYTE [eax]), '*'
    ret
PrintTank ENDP

;; EraseTank
;; clear the tank in order to move
EraseTank PROC USES eax, ecx esi,
    thisOutputHandle: DWORD,
    thisTank: PTR TANK,
	GameMap: PTR BYTE,
    countWord: PTR DWORD

    mov esi, thisTank

	mov eax, GameMap
    add eax, 128*(PTR Tank [esi]).position.y)+(PTR Tank [esi]).position.x
	mov (PTR BYTE [eax]), ' '
    inc eax
    mov (PTR BYTE [eax]), ' '
    inc eax
	mov (PTR BYTE [eax]), ' '

    add eax, 126    ; 128-2
    mov (PTR BYTE [eax]), ' '
    inc eax
    mov (PTR BYTE [eax]), ' '
    inc eax
	mov (PTR BYTE [eax]), ' '

    add eax, 126    ; 128-2
    mov (PTR BYTE [eax]), ' '
    inc eax
    mov (PTR BYTE [eax]), ' '
    inc eax
	mov (PTR BYTE [eax]), ' '

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