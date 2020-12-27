TITLE bullet (bullet.asm)

INCLUDE Irvine32.inc

bullet STRUCT
    symbol BYTE '@'
    white BYTE ' '
    color word 0Eh
    direction BYTE 1
    position COORD <1, 1>
bullet ENDS

.code
; print bullet
printBullet PROC USES esi,
    thisOutputHandle: DWORD,
    thisBullet: PTR bullet,
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
		ADDR (Bullet PTR [esi]).symbol,
		1,
		(Bullet PTR [esi]).position,
		countWord

    ret
printBullet ENDP

; before print new bullet, remove the old bullet 
eraseBullet PROC USES esi, 
    thisOutputHandle: DWORD,
    thisBullet: PTR Bullet,
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

    ret
eraseBullet ENDP


; move one byte toward bullet's direction
bulletMove PROC USES eax,
    thisOutputHandle: DWORD, 
    thisBullet: PTR bullet,
    countWord: PTR DWORD

    INVOKE eraseBullet, thisOutputHandle, thisBullet, countWord
    
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
    INVOKE printBullet, thisOutputHandle, thisBullet, countWord
    ret
bulletMove ENDP