TITLE Control_Enemy (Control_Enemy.asm)

INCLUDE Irvine32.inc
INCLUDE Tank.inc

GetDirection PROC USES eax esi, thisTank: PTR Tank
	mov eax, 4
	mov esi, thisTank
	call Randomize
	call RandomRange
	inc eax
	mov (Tank PTR [esi]).faceTo, al
	ret
GetDirection ENDP

MoveRandom PROC USES eax ecx esi edi, thisOutputHandle: DWORD, thisTank: PTR Tank, GameMap: PTR BYTE, countWord: PTR DWORD
	mov esi, thisTank
	mov edi, GameMap
MoveRandom_set:
	.IF ((Tank PTR [esi]).faceTo = 1)
		mov eax, ((Tank PTR [esi]).Y - 1)           ; 0 is boundary, so Y need to - 1
	.ELSEIF ((Tank PTR [esi]).faceTo = 2)
		mov eax, (126 - (Tank PTR [esi]).X)         ; 127 is boundary, so 127 need to - 1
	.ELSEIF ((Tank PTR [esi]).faceTo = 3)
		mov eax, (30 - (Tank PTR [esi]).Y)          ; 31 is boundary, so 31 need to - 1
	.ELSEIF ((Tank PTR [esi]).faceTo = 4)
		mov eax, ((Tank PTR [esi]).X - 1)           ; 0 is boundary, so X need to - 1
    .ENDIF
MoveRandom_random:
	call Randomize
	call RandomRange
	inc eax
	mov ecx, eax
MoveRandom_check:
	.IF (((Tank PTR [esi]).faceTo = 1) and ((BYTE PTR [edi+(128*((Tank PTR [esi]).position.Y-1)+(Tank PTR [esi]).position.X)]) = ' ') and ((BYTE PTR [edi+(128*((Tank PTR [esi]).position.Y-1)+(Tank PTR [esi]).position.X+1)]) = ' ') and ((BYTE PTR [edi+(128*((Tank PTR [esi]).position.Y-1)+(Tank PTR [esi]).position.X+2)]) = ' '))
		jmp MoveRandom_move
	.ELSEIF (((Tank PTR [esi]).faceTo = 2) and ((BYTE PTR [edi+(128*((Tank PTR [esi]).position.Y)+(Tank PTR [esi]).position.X+3)]) = ' ') and ((BYTE PTR [edi+(128*((Tank PTR [esi]).position.Y+1)+(Tank PTR [esi]).position.X+3)]) = ' ') and ((BYTE PTR [edi+(128*((Tank PTR [esi]).position.Y+2)+(Tank PTR [esi]).position.X+3)]) = ' '))
		jmp MoveRandom_move
	.ELSEIF (((Tank PTR [esi]).faceTo = 3) and ((BYTE PTR [edi+(128*((Tank PTR [esi]).position.Y+3)+(Tank PTR [esi]).position.X)]) = ' ') and ((BYTE PTR [edi+(128*((Tank PTR [esi]).position.Y+3)+(Tank PTR [esi]).position.X+1)]) = ' ') and ((BYTE PTR [edi+(128*((Tank PTR [esi]).position.Y+3)+(Tank PTR [esi]).position.X+2)]) = ' '))
		jmp MoveRandom_move
	.ELSEIF (((Tank PTR [esi]).faceTo = 4) and ((BYTE PTR [edi+(128*((Tank PTR [esi]).position.Y)+(Tank PTR [esi]).position.X-1)]) = ' ') and ((BYTE PTR [edi+(128*((Tank PTR [esi]).position.Y+1)+(Tank PTR [esi]).position.X-1)]) = ' ') and ((BYTE PTR [edi+(128*((Tank PTR [esi]).position.Y+2)+(Tank PTR [esi]).position.X-1)]) = ' '))
		jmp MoveRandom_move
	.ELSE
		jmp MoveRandom_return	
MoveRandom_move:				
	INVOKE moveTank, thisOutputHandle, thisTank, (Tank PTR [esi]).faceTo, countWord
MoveRandom_loop:	
	loop MoveRandom_move
MoveRandom_return:	
	ret
Move ENDP

DetectShoot PROC USES esi edi, thisTank: PTR Tank, playerTank: PTR Tank
	mov esi, thisTank
	mov edi, playerTank
	.IF (((Tank PTR [esi]).position.X < (Tank PTR [edi]).position.X) AND ((Tank PTR [esi]).position.Y < (Tank PTR [edi]).position.Y))
		.IF (((Tank PTR [edi]).position.X - (Tank PTR [esi]).position.X) < ((Tank PTR [edi]).position.Y - (Tank PTR [esi]).position.Y))
		    mov (Tank PTR [esi]).faceTo, 3
			INVOKE ChangeFaceTo, thisTank, (Tank PTR [esi]).faceTo
			; 射一發子彈
		.ELSE
			mov (Tank PTR [esi]).faceTo, 2
			INVOKE ChangeFaceTo, thisTank, (Tank PTR [esi]).faceTo
			; 射一發子彈
        .ENDIF    
	.ELSEIF (((Tank PTR [esi]).position.X > (Tank PTR [edi]).position.X) AND ((Tank PTR [esi]).position.Y < (Tank PTR [edi]).position.Y))
		.IF (((Tank PTR [esi]).position.X - (Tank PTR [edi]).position.X) < ((Tank PTR [edi]).position.Y - (Tank PTR [esi]).position.Y))
			mov (Tank PTR [esi]).faceTo, 3
			INVOKE ChangeFaceTo, thisTank, (Tank PTR [esi]).faceTo
			; 射一發子彈
		.ELSE
			mov (Tank PTR [esi]).faceTo, 4
			INVOKE ChangeFaceTo, thisTank, (Tank PTR [esi]).faceTo
			; 射一發子彈
        .ENDIF    
	.ELSEIF (((Tank PTR [esi]).position.X < (Tank PTR [edi]).position.X) AND ((Tank PTR [esi]).position.Y > (Tank PTR [edi]).position.Y))
		.IF (((Tank PTR [edi]).position.X - (Tank PTR [esi]).position.X) < ((Tank PTR [esi]).position.Y - (Tank PTR [edi]).position.Y))
			mov (Tank PTR [esi]).faceTo, 1
			INVOKE ChangeFaceTo, thisTank, (Tank PTR [esi]).faceTo
			; 射一發子彈
		.ELSE
			mov (Tank PTR [esi]).faceTo, 2
			INVOKE ChangeFaceTo, thisTank, (Tank PTR [esi]).faceTo
			; 射一發子彈
        .ENDIF    
	.ELSE
		.IF (((Tank PTR [esi]).position.X - (Tank PTR [edi]).position.X) < ((Tank PTR [esi]).position.Y - (Tank PTR [edi]).position.Y))
			mov (Tank PTR [esi]).faceTo, 1
			INVOKE ChangeFaceTo, thisTank, (Tank PTR [esi]).faceTo
			; 射一發子彈
		.ELSE
			mov (Tank PTR [esi]).faceTo, 4
			INVOKE ChangeFaceTo, thisTank, (Tank PTR [esi]).faceTo
			; 射一發子彈
        .ENDIF
    .ENDIF    
    ret
DetectShoot ENDP