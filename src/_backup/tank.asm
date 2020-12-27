TITLE control tank                (car.ASM)

INCLUDE Irvine32.inc

main          EQU start@

Tank STRUCT 
	firstLine BYTE ' ', 7Ch, ' '		;  |
	secondLine BYTE 23h, 2Bh, 23h 		; #+#
	thirdLine BYTE 23h, 2Bh, 23h		; #+#
	firstColor WORD 6h, 6h, 6h 			; brown	
	secondColor WORD 6h, 0ch, 6h		; brown red brown
	threeWhite BYTE 3 DUP (' ')			; for EraseTank
	position COORD <1,1>				; left up
	faceTo BYTE 1               		; 1 : face up, 2 : face right, 3 : face down, 4 : face left 
Tank ENDS

; print tank
PrintTank PROC USES eax ecx esi,
	thisOutputHandle: DWORD,
	thisTank: PTR Tank,
	countWord: PTR DWORD

	mov esi, thisTank

	INVOKE WriteConsoleOutputAttribute,			; set color
		thisOutputHandle,
		ADDR (Tank PTR [esi]).firstColor,
		3,
		(Tank PTR [esi]).position,
		countWord
	INVOKE WriteConsoleOutputCharacter,			; 設定字母
		thisOutputHandle, 
		ADDR (Tank PTR [esi]).firstLine,
		3,
		(Tank PTR [esi]).position,
		countWord
	
	inc (Tank PTR [esi]).position.Y 

	INVOKE WriteConsoleOutputAttribute,			; set color
		thisOutputHandle,
		ADDR (Tank PTR [esi]).secondColor,
		3,
		(Tank PTR [esi]).position,
		countWord
	INVOKE WriteConsoleOutputCharacter,			; 設定字母
		thisOutputHandle, 
		ADDR (Tank PTR [esi]).secondLine,
		3,
		(Tank PTR [esi]).position,
		countWord

	inc (Tank PTR [esi]).position.Y

	INVOKE WriteConsoleOutputAttribute,			; set color
		thisOutputHandle,
		ADDR (Tank PTR [esi]).firstColor,
		3,
		(Tank PTR [esi]).position,
		countWord
	INVOKE WriteConsoleOutputCharacter,			; 設定字母
		thisOutputHandle, 
		ADDR (Tank PTR [esi]).thirdLine,
		3,
		(Tank PTR [esi]).position,
		countWord

	sub (Tank PTR [esi]).position.Y, 2
	ret
PrintTank ENDP
	
	
; clear the tank in order to move
EraseTank PROC USES ecx esi,
	thisOutputHandle: DWORD,
	thisTank: PTR Tank,
	countWord: PTR DWORD

	mov esi, thisTank
	mov ecx, 3
clearRow:
	push ecx
	INVOKE WriteConsoleOutputAttribute,			; set color
		thisOutputHandle,
		ADDR (Tank PTR [esi]).firstColor,
		3,
		(Tank PTR [esi]).position,
		countWord

	INVOKE WriteConsoleOutputCharacter,			; 設定字母
		thisOutputHandle, 
		ADDR (Tank PTR [esi]).threeWhite,
		3,
		(Tank PTR [esi]).position,
		countWord
	add (Tank PTR [esi]).position.Y, 1
	pop ecx
	loop clearRow

	sub (Tank PTR [esi]).position.Y, 3
	ret
EraseTank ENDP

; change direction 
ChangeFaceTo PROC USES eax ecx esi,
	thisTank: PTR Tank,
	newFaceTo: BYTE

	mov al, newFaceTo
	mov esi, thisTank

	cmp al, 1h				
	je changeToFaceUP
	cmp al, 2h
	je changeToFaceRight
	cmp al, 3h
	je changeToFaceDown
	jmp changeToFaceLeft


changeToFaceUP:
	mov (Tank PTR [esi]).firstLine[0], ' '
	mov (Tank PTR [esi]).firstLine[1], 7Ch
	mov (Tank PTR [esi]).firstLine[2], ' '

	mov (Tank PTR [esi]).secondLine[0], 23h
	mov (Tank PTR [esi]).secondLine[2], 23h
	
	mov (Tank PTR [esi]).thirdLine[0], 23h
	mov (Tank PTR [esi]).thirdLine[1], 2Bh
	mov (Tank PTR [esi]).thirdLine[2], 23h
	mov (Tank PTR [esi]).faceTo, 1h

	jmp ChangeEnd
changeToFaceRight:
	mov (Tank PTR [esi]).firstLine[0], 23h
	mov (Tank PTR [esi]).firstLine[1], 23h
	mov (Tank PTR [esi]).firstLine[2], ' '

	mov (Tank PTR [esi]).secondLine[0], 2Bh
	mov (Tank PTR [esi]).secondLine[2], 2Dh
	
	mov (Tank PTR [esi]).thirdLine[0], 23h
	mov (Tank PTR [esi]).thirdLine[1], 23h
	mov (Tank PTR [esi]).thirdLine[2], ' '
	mov (Tank PTR [esi]).faceTo, 2h

	jmp ChangeEnd
changeToFaceDown:
	mov (Tank PTR [esi]).firstLine[0], 23h
	mov (Tank PTR [esi]).firstLine[1], 2Bh
	mov (Tank PTR [esi]).firstLine[2], 23h

	mov (Tank PTR [esi]).secondLine[0], 23h
	mov (Tank PTR [esi]).secondLine[2], 23h
	
	mov (Tank PTR [esi]).thirdLine[0], ' '
	mov (Tank PTR [esi]).thirdLine[1], 7Ch
	mov (Tank PTR [esi]).thirdLine[2], ' '
	
	mov (Tank PTR [esi]).faceTo, 3h

	jmp ChangeEnd
changeToFaceLeft:
	mov (Tank PTR [esi]).firstLine[0], ' '
	mov (Tank PTR [esi]).firstLine[1], 23h
	mov (Tank PTR [esi]).firstLine[2], 23h

	mov (Tank PTR [esi]).secondLine[0], 2Dh
	mov (Tank PTR [esi]).secondLine[2], 2Bh
	
	mov (Tank PTR [esi]).thirdLine[0], ' '
	mov (Tank PTR [esi]).thirdLine[1], 23h
	mov (Tank PTR [esi]).thirdLine[2], 23h

	mov (Tank PTR [esi]).faceTo, 4h

	jmp ChangeEnd
changeEnd:
	ret
ChangeFaceTo ENDP


; move tank
MoveTank PROC USES eax esi, 
	thisOutputHandle: DWORD, 
	thisTank: PTR Tank,
	direction: WORD, 
	countWord: PTR DWORD

	INVOKE EraseTank, thisOutputHandle, thisTank, countWord
	mov ax, direction
	mov esi, thisTank
	
	cmp ax, 4800h		; move up
	je MoveTank_MoveUp
	cmp ax, 4D00h       ; move right 
	je moveRight
	cmp ax, 5000h
	je moveDown
	cmp ax, 4B00h
	je moveLeft
	jmp printMove

MoveTank_MoveUp:
	mov al, (Tank PTR [esi]).faceTo
	cmp al, 1h
	je subY
	INVOKE ChangeFaceTo, thisTank, 1h
	jmp  printMove
subY:
	sub (Tank PTR [esi]).position.Y, 1
	mov ax, (Tank PTR [esi]).position.Y
	.IF ax == 0h 										
		add (Tank PTR [esi]).position.Y, 1 										
	.ENDIF
	jmp  printMove
moveRight:
	mov al, (Tank PTR [esi]).faceTo
	cmp al, 2h
	je addX
	INVOKE ChangeFaceTo, thisTank, 2h
	jmp  printMove
addX:
	add (Tank PTR [esi]).position.X, 1
	mov ax, (Tank PTR [esi]).position.X
	.IF ax == 7Dh 			; 125									
		sub (Tank PTR [esi]).position.X, 1 										
	.ENDIF
	jmp  printMove
moveDown:
	mov al, (Tank PTR [esi]).faceTo
	cmp al, 3h
	je addY
	INVOKE ChangeFaceTo, thisTank, 3h
	jmp  printMove
addY:
	add (Tank PTR [esi]).position.Y, 1
	mov ax, (Tank PTR [esi]).position.Y
	.IF ax == 1Dh 										
		sub (Tank PTR [esi]).position.Y, 1 										
	.ENDIF
	jmp  printMove
moveLeft:
	mov al, (Tank PTR [esi]).faceTo
	cmp al, 4h
	je subX
	INVOKE ChangeFaceTo, thisTank, 4h
	jmp  printMove
subX:
	sub (Tank PTR [esi]).position.X, 1
	mov ax, (Tank PTR [esi]).position.X
	.IF ax == 0h 										
		add (Tank PTR [esi]).position.X, 1 										
	.ENDIF
	jmp  printMove
printMove:
	INVOKE PrintTank, thisOutputHandle, thisTank, countWord
	ret
MoveTank ENDP
