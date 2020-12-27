TITLE bullet (bullet.asm)

INCLUDE Irvine32.inc



.data 


bullet STRUCT
    symbol BYTE '@'
    white BYTE ' '
    color word 0Eh
    direction BYTE 1
    owner BYTE 1            ; 1 represent we shoot 2 represent enemy shoot
    position COORD <1, 1>
bullet ENDS

.code
; print bullet
PrintBullet PROC USES eax ecx esi edi,
    thisOutputHandle: DWORD,
    thisBullet: PTR bullet,
    thisGameMap: PTR BYTE,
    countWord: PTR DWORD
    
    
    mov esi, thisBullet
    ; print in console
    INVOKE WriteConsoleOutputAttribute,			; set color
		thisOutputHandle,
		ADDR (Bullet PTR [esi]).color,
		1,
		(Bullet PTR [esi]).position,
		countWord
	INVOKE WriteConsoleOutputCharacter,			; 設定字母
		thisOutputHandle, 
		ADDR (Bullet PTR [esi]).symbol,
		1,
		(Bullet PTR [esi]).position,
		countWord

    ; record in map
    movzx ecx, (bullet PTR [esi]).position.Y
    mov edi, thisGameMap
changeRow:
    add edi, 128
    loop changeRow

    add edi, (bullet PTR [esi]).position.X
       
    mov al, (bullet PTR [esi]).owner
    .IF al == 1h
        mov (BYTE PTR [edi]), 40h
        jmp printEnd
    .ENDIF 

    .IF al == 2h
        mov (BYTE PTR [edi]), 25h
        jmp printEnd
    .ENDIF
printEnd:
    ret
PrintBullet ENDP

; before print new bullet, remove the old bullet 
EraseBullet PROC USES eax ecx esi edi, 
    thisOutputHandle: DWORD,
    thisBullet: PTR Bullet,
    thisGameMap: PTR BYTE,
    countWord: PTR DWORD 


    mov esi, thisBullet

    INVOKE WriteConsoleOutputAttribute,			; set color
		thisOutputHandle,
		ADDR (Bullet PTR [esi]).color,
		1,
		(Bullet PTR [esi]).position,
		countWord
	INVOKE WriteConsoleOutputCharacter,			; 設定字母
		thisOutputHandle, 
		ADDR (Bullet PTR [esi]).white,
		1,
		(Bullet PTR [esi]).position,
		countWord
    
    movzx ecx, (bullet PTR [esi]).position.Y
    mov edi, thisGameMap
changeRow:
    add edi, 128
    loop changeRow

    add edi, (bullet PTR [esi]).position.X
       
    mov (BYTE PTR [edi]), ' '
    ret
EraseBullet ENDP


; move one byte toward bullet's direction
BulletMove PROC USES eax esi,
    thisOutputHandle: DWORD, 
    thisBullet: PTR bullet,
    thisGameMap: PTR BYTE,
    countWord: PTR DWORD
    

    INVOKE eraseBullet, thisOutputHandle, thisBullet, thisGameMap, countWord
    
    mov esi, thisBullet
    mov al, (Bullet PTR [esi]).direction 
    
    cmp al, 1h
    je flyUp
    cmp al, 2h
    je flyRight
    cmp al, 3h
    je flyDown
    cmp al, 4h
    je flyLeft

flyUp:
    sub (Bullet PTR [esi]).position.Y, 1
    jmp endMove
flyRight:
    add (Bullet PTR [esi]).position.X, 1
    jmp endMove
flyDown:
    add (Bullet PTR [esi]).position.Y, 1
    jmp endMove
flyLeft:
    sub (Bullet PTR[esi]).position.X, 1
    jmp endMove
endMove:
    INVOKE printBullet, thisOutputHandle, thisBullet, thisGameMap, countWord
    ret
BulletMove ENDP

NewBullet PROC USES eax ecx esi edi,
    thisTank: PTR tank,
    bulletAmount: PTR BYTE,
    bulletList: PTR bullet

    ; get the position that the new bullet should appear
    mov esi, bulletList
    mov edi, bulletAmount
	mov al, [edi]
	.IF al == 0h
		jmp setNewBullet
	.ENDIF
    movzx ecx, al
moveToNewBullet:
	add esi, 10
	loop moveToNewBullet

setNewBullet:
    mov edi, thisTank
    mov al, (tank PTR [edi]).faceTo

    .IF al == 1h
        mov (bullet PTR [esi]).position.X, (tank PTR [edi]).position.X
        add (bullet PTR [esi]).position.X, 1h

        mov (bullet PTR [esi]).position.Y, (tank PTR [edi]).position.Y
        sub (bullet PTR [esi]).position.Y, 1h 

        mov (bullet PTR [esi]).direction, 1h
        jmp newBulletEnd
    .ENDIF

    .IF al == 2h
        mov (bullet PTR [esi]).position.X, (tank PTR [edi]).position.X
        add (bullet PTR [esi]).position.X, 3h

        mov (bullet PTR [edi]).position.Y, (tank PTR [edi]).position.Y
        add (bullet PTR [edi]).position.Y, 1h 

        mov (bullet PTR [edi]).direction, 2h
        jmp newBulletEnd
    .ENDIF

    .IF al == 3h
        mov (bullet PTR [esi]).position.X, (tank PTR [edi]).position.X
        add (bullet PTR [esi]).position.X, 1h

        mov (bullet PTR [edi]).position.Y, (tank PTR [edi]).position.Y
        add (bullet PTR [edi]).position.Y, 3h  

        mov (bullet PTR [edi]).direction, 3h
        jmp newBulletEnd
    .ENDIF

    .IF al == 4h
        mov (bullet PTR [esi]).position.X, (tank PTR [edi]).position.X
        sub (bullet PTR [esi]).position.X, 1

        mov (bullet PTR [edi]).position.Y, (tank PTR [edi]).position.Y
        add (bullet PTR [edi]).position.Y, 1  

        mov (bullet PTR [edi]).direction, 4h
        jmp newBulletEnd
    .ENDIF
newBulletEnd:
    mov esi,  bulletAmount 
    add (BYTE PTR [esi]), 1
    ret
NewBullet ENDP 

; check if bullet has hit wall or tank 
BulletHit Proc USES eax ebx ecx esi edi,
    thisBullet: PTR bullet,
    thisBulletAmount: PTR BYTE, 
    thisGameMap: PTR BYTE

    mov esi, thisBullet
    mov edi, thisGameMap
    
    movzx ecx, (bullet PTR [esi]).position.Y
changeRow:
    add edi, 128
    loop changeRow

    add edi, (bullet PTR [esi]).position.X
    
    mov ebx, [edi]
    .IF ebx == ' '
        jmp BulletHitEnd
    .ENDIF

    push esi
    mov esi, thisBulletAmount               ; hit something (tank or wall)
    sub (BYTE PTR [esi]), 1                 ; bullet amount - 1
    pop esi

    mov al, (bullet PTR [esi]).owner
    .IF ebx == 23h                        ; hit our tank
        .IF al == 1h
            jmp BulletHitEnd
        .ENDIF
        ; ourTankDestroy
        ; 
    .ENDIF

    .IF ebx == 2Ah                        ; hit enemy's tank
        .IF al == 2h
            jmp BulletHitEnd                ; enemy hit enemy
        .ENDIF
        ; enemyTankDestroy
    .ENDIF
                                            ; if hit wall, do nothing      
BulletHitEnd:
    ret
BulletHit ENDP
