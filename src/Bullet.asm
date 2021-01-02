TITLE Bullet (Bullet.asm)

; ==========
; = Bullet =
; ==========

; The main handler of the bullets


;; PrintBullet
;; print bullet
PrintBullet PROC USES eax ebx esi edi,
    thisBullet: PTR BULLET,
    thisGameMap: PTR BYTE
    
    ; print bullet
    mov esi, thisBullet
    movzx edi, (BULLET PTR [esi]).role
    .IF edi == ROLE_PLAYER
        mov edi, OFFSET bulletCmdImage
    .ELSE
        mov edi, OFFSET bulletCmdImageEnemy
    .ENDIF
    INVOKE PushRenderBufferImageDiscardable, 
        RENDER_BUFFER_LAYER_BULLETS, 
        edi,
        (BULLET PTR [esi]).position

    ; record in map
    mov edi, thisGameMap
    INVOKE GetRenderBufferIndex, (BULLET PTR [esi]).position
    movzx eax, ax
    movzx ebx, (BULLET PTR [esi]).role

    .IF ebx == ROLE_PLAYER
        mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_PLAYER_BULLET
    .ELSEIF ebx == ROLE_ENEMY
        mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_ENEMY_BULLET
    .ENDIF
    ret
PrintBullet ENDP

;; EraseBullet
;; before print new bullet, remove the old bullet 
; EraseBullet PROC USES ecx esi edi, 
;     thisOutputHandle: DWORD,
;    thisBullet: PTR BULLET,
;    thisGameMap: PTR BYTE,
;    countWord: PTR DWORD
;
;    mov esi, thisBullet
;
;    INVOKE PushRenderBufferImageBlank,
;        RENDER_BUFFER_LAYER_BULLETS,
;        (TANK PTR [esi]).position,
;        bulletSize
;
;    ; record in map
;    movzx ecx, (BULLET PTR [esi]).position.Y
;    mov edi, thisGameMap
;EraseBullet_ChangeRow:
;    add edi, GAME_MAP_WIDTH
;    loop EraseBullet_ChangeRow
;
;    movzx ecx, (BULLET PTR [esi]).position.X
;    add edi, ecx
;       
;    mov (BYTE PTR [edi]), GAME_MAP_CHAR_EMPTY
;
;    ret
;EraseBullet ENDP


EraseBullet PROC USES eax ecx esi edi,
    thisBullet: PTR BULLET,
    thisGameMap: PTR BYTE

    mov esi, thisBullet

    ; erase bullet
    INVOKE PushRenderBufferImageBlank,
        RENDER_BUFFER_LAYER_BULLETS,
        (BULLET PTR [esi]).position,
        bulletSize

    ; record in map
    mov edi, thisGameMap
    INVOKE GetRenderBufferIndex, (BULLET PTR [esi]).position
    movzx eax, ax
       
    mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_EMPTY
    ret
EraseBullet ENDP

;; BulletMove
;; move one byte toward bullet's direction
BulletMove PROC USES eax esi,
    thisBullet: PTR BULLET,
    thisGameMap: PTR BYTE,
    bulletAmount: BYTE,
    bulletList: PTR BULLET

    LOCAL checkPosition:COORD

    ; erase tank
    INVOKE EraseBullet, thisBullet, thisGameMap
    
    mov esi, thisBullet
    mov al, (Bullet PTR [esi]).direction 
    movzx ebx, (Bullet PTR [esi]).role
    ; different check
    cmp al, FACE_UP
    je BulletMove_FlyUp
    cmp al, FACE_RIGHT
    je BulletMove_FlyRight
    cmp al, FACE_DOWN
    je BulletMove_FlyDown
    cmp al, FACE_LEFT
    je BulletMove_FlyLeft
BulletMove_FlyUp:
    ; before move, check
    mov ax, (BULLET PTR [esi]).position.Y
    dec ax
    mov checkPosition.y, ax
    mov ax, (TANK PTR [esi]).position.x
    mov checkPosition.x, ax

    INVOKE GetRenderBufferIndex, checkPosition
    movzx eax, ax

    ; if role's bullet hit wall, enemy's bullet, enemy's tank
    .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_0
        ; remove this bullet from bullet list
        jmp MoveBullet_return  
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_1
        ; remove this bullet form bullet list
        jmp MoveBullet_return
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY_BULLET
        sub (BULLET PTR [esi]).position.y, 1
        ; remove this bullet form bullet list
        jmp MoveBullet_return 
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER_BULLET
        sub (BULLET PTR [esi]).position.y, 1
        ; remove this bullet form bullet list
        jmp MoveBullet_return 
    .ENDIF
    
    .IF ebx == ROLE_PLAYER
        .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY
            ; remove this bullet from bullet list
            ; remove enemy tank
            jmp MoveBullet_return 
        .ENDIF    
    .ELSEIF ebx == ROLE_ENEMY
        .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER
            ; remove this bullet from bullet list
            ; remove enemy tank
            jmp MoveBullet_return 
        .ENDIF
    .ENDIF

    sub (Bullet PTR [esi]).position.y, 1
    jmp Print_bullet
BulletMove_FlyRight:
    ; before move, check
    mov ax, (BULLET PTR [esi]).position.Y
    mov checkPosition.y, ax
    mov ax, (TANK PTR [esi]).position.x
    inc ax
    mov checkPosition.x, ax

    INVOKE GetRenderBufferIndex, checkPosition
    movzx eax, ax

    ; if role's bullet hit wall, enemy's bullet, enemy's tank
    .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_0
        ; remove this bullet from bullet list
        jmp MoveBullet_return  
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_1
        ; remove this bullet form bullet list
        jmp MoveBullet_return
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY_BULLET
        add (BULLET PTR [esi]).position.x, 1
        ; remove this bullet form bullet list
        jmp MoveBullet_return 
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER_BULLET
        add (BULLET PTR [esi]).position.x, 1
        ; remove this bullet form bullet list
        jmp MoveBullet_return 
    .ENDIF
    
    .IF ebx == ROLE_PLAYER
        .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY
            ; remove this bullet from bullet list
            ; remove enemy tank
            jmp MoveBullet_return 
        .ENDIF    
    .ELSEIF ebx == ROLE_ENEMY
        .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER
            ; remove this bullet from bullet list
            ; remove enemy tank
            jmp MoveBullet_return 
        .ENDIF
    .ENDIF

    sub (Bullet PTR [esi]).position.y, 1
    jmp Print_bullet
BulletMove_FlyDown:
    ; before move, check
    mov ax, (BULLET PTR [esi]).position.Y
    mov checkPosition.y, ax
    inc ax
    mov ax, (TANK PTR [esi]).position.x
    mov checkPosition.x, ax

    INVOKE GetRenderBufferIndex, checkPosition
    movzx eax, ax

    ; if role's bullet hit wall, enemy's bullet, enemy's tank
    .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_0
        ; remove this bullet from bullet list
        jmp MoveBullet_return  
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_1
        ; remove this bullet form bullet list
        jmp MoveBullet_return
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY_BULLET
        add (BULLET PTR [esi]).position.x, 1
        ; remove this bullet form bullet list
        jmp MoveBullet_return 
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER_BULLET
        add (BULLET PTR [esi]).position.x, 1
        ; remove this bullet form bullet list
        jmp MoveBullet_return 
    .ENDIF
    
    .IF ebx == ROLE_PLAYER
        .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY
            ; remove this bullet from bullet list
            ; remove enemy tank
            jmp MoveBullet_return 
        .ENDIF    
    .ELSEIF ebx == ROLE_ENEMY
        .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER
            ; remove this bullet from bullet list
            ; remove enemy tank
            jmp MoveBullet_return 
        .ENDIF
    .ENDIF

    add (Bullet PTR [esi]).position.y, 1
    jmp Print_bullet
BulletMove_FlyLeft:
    ; before move, check
    mov ax, (BULLET PTR [esi]).position.Y
    mov checkPosition.y, ax
    mov ax, (TANK PTR [esi]).position.x
    sub ax, 1
    mov checkPosition.x, ax

    INVOKE GetRenderBufferIndex, checkPosition
    movzx eax, ax

    ; if role's bullet hit wall, enemy's bullet, enemy's tank
    .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_0
        ; remove this bullet from bullet list
        jmp MoveBullet_return  
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_1
        ; remove this bullet form bullet list
        jmp MoveBullet_return
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY_BULLET
        add (BULLET PTR [esi]).position.x, 1
        ; remove this bullet form bullet list
        jmp MoveBullet_return 
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER_BULLET
        add (BULLET PTR [esi]).position.x, 1
        ; remove this bullet form bullet list
        jmp MoveBullet_return 
    .ENDIF
    
    .IF ebx == ROLE_PLAYER
        .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY
            ; remove this bullet from bullet list
            ; remove enemy tank
            jmp MoveBullet_return 
        .ENDIF    
    .ELSEIF ebx == ROLE_ENEMY
        .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER
            ; remove this bullet from bullet list
            ; remove enemy tank
            jmp MoveBullet_return 
        .ENDIF
    .ENDIF

    ; move
    sub (Bullet PTR [esi]).position.x, 1
    jmp Print_bullet
Print_bullet:
    INVOKE printBullet, thisBullet, thisGameMap
MoveBullet_return:
    ret
BulletMove ENDP

; BulletMove PROC USES eax esi,
;     thisOutputHandle: DWORD, 
;     thisBullet: PTR BULLET,
;     thisGameMap: PTR BYTE,
;     countWord: PTR DWORD

;     INVOKE EraseBullet, thisOutputHandle, thisBullet, thisGameMap, countWord
    
;     mov esi, thisBullet
;     mov al, (BULLET PTR [esi]).direction 
    
;     cmp al, FACE_UP
;     je BulletMove_FlyUp
;     cmp al, FACE_RIGHT
;     je BulletMove_FlyRight
;     cmp al, FACE_DOWN
;     je BulletMove_FlyDown
;     cmp al, FACE_LEFT
;     je BulletMove_FlyLeft

; BulletMove_FlyUp:
;     sub (BULLET PTR [esi]).position.Y, 1
;     jmp BulletMove_EndMove
; BulletMove_FlyRight:
;     add (BULLET PTR [esi]).position.X, 1
;     jmp BulletMove_EndMove
; BulletMove_FlyDown:
;     add (BULLET PTR [esi]).position.Y, 1
;     jmp BulletMove_EndMove
; BulletMove_FlyLeft:
;     sub (BULLET PTR[esi]).position.X, 1
;     jmp BulletMove_EndMove
; BulletMove_EndMove:
;     INVOKE PrintBullet, thisOutputHandle, thisBullet, thisGameMap, countWord
;     ret
; BulletMove ENDP

;; NewBullet
NewBullet PROC USES eax ecx esi edi,
    thisTank: PTR TANK,
    bulletAmount: PTR BYTE,
    bulletList: PTR BULLET,
    gameMap: PTR BYTE

    ; get the position that the new bullet should appear
    mov esi, bulletList
    mov edi, bulletAmount
    mov al, [edi]
    .IF al == 0h
        jmp NewBullet_SetNewBullet
    .ENDIF
    movzx ecx, al
NewBullet_MoveToNewBullet:
    add esi, BULLET_SIZE_BYTE
    loop NewBullet_MoveToNewBullet

NewBullet_SetNewBullet:
    mov edi, thisTank
    mov al, (TANK PTR [edi]).role
    mov (BULLET PTR [esi]).role, al

    mov al, (tank PTR [edi]).faceTo

    .IF al == FACE_UP
        mov ax, (TANK PTR [edi]).position.x
        add ax, 1h
        mov (bullet PTR [esi]).position.x, ax

        mov ax, (TANK PTR [edi]).position.y
        ; sub ax, 1h
        mov (bullet PTR [esi]).position.y, ax

        ; 
        ; mov (bullet PTR [esi]).position.X, (tank PTR [edi]).position.X
        ; add (bullet PTR [esi]).position.X, 1h

        ; mov (bullet PTR [esi]).position.Y, (tank PTR [edi]).position.Y
        ; sub (bullet PTR [esi]).position.Y, 1h

        mov (bullet PTR [esi]).direction, FACE_UP
        jmp NewBullet_NewBulletEnd
    .ENDIF

    .IF al == FACE_RIGHT
        mov ax, (TANK PTR [edi]).position.x
        add ax, 2h
        mov (bullet PTR [esi]).position.x, ax

        mov ax, (TANK PTR [edi]).position.y
        add ax, 1h
        mov (bullet PTR [esi]).position.y, ax

        ; mov (bullet PTR [esi]).position.X, (TANK PTR [edi]).position.X
        ; add (bullet PTR [esi]).position.X, 3h

        ; mov (bullet PTR [edi]).position.Y, (TANK PTR [edi]).position.Y
        ; add (bullet PTR [edi]).position.Y, 1h

        mov (bullet PTR [esi]).direction, FACE_RIGHT
        jmp NewBullet_NewBulletEnd
    .ENDIF

    .IF al == FACE_DOWN
        mov ax, (TANK PTR [edi]).position.x
        add ax, 1h
        mov (bullet PTR [esi]).position.x, ax

        mov ax, (TANK PTR [edi]).position.y
        add ax, 2h
        mov (bullet PTR [esi]).position.y, ax

        ; mov (bullet PTR [esi]).position.X, (TANK PTR [edi]).position.X
        ; add (bullet PTR [esi]).position.X, 1h

        ; mov (bullet PTR [edi]).position.Y, (TANK PTR [edi]).position.Y
        ; add (bullet PTR [edi]).position.Y, 3h

        mov (bullet PTR [esi]).direction, FACE_DOWN
        jmp NewBullet_NewBulletEnd
    .ENDIF

    .IF al == FACE_LEFT
        mov ax, (TANK PTR [edi]).position.x
        ; sub ax, 1h
        mov (bullet PTR [esi]).position.x, ax

        mov ax, (TANK PTR [edi]).position.y
        add ax, 1h
        mov (bullet PTR [esi]).position.y, ax

        ; mov (bullet PTR [esi]).position.X, (TANK PTR [edi]).position.X
        ; sub (bullet PTR [esi]).position.X, 1

        ; mov (bullet PTR [edi]).position.Y, (TANK PTR [edi]).position.Y
        ; add (bullet PTR [edi]).position.Y, 1

        mov (bullet PTR [esi]).direction, FACE_LEFT
        jmp NewBullet_NewBulletEnd
    .ENDIF

NewBullet_NewBulletEnd:
    mov esi, bulletAmount 
    add (BYTE PTR [esi]), 1
    INVOKE BulletMove, (bullet PTR [esi]), gameMap, bulletAmount, bulletList
NewBullet_return:
    ret
NewBullet ENDP 

;; BulletHit
;; this proc is been moved to bullet_move
;; check if bullet has hit wall or tank
; BulletHit PROC USES eax ebx ecx esi edi,
;     thisBullet: PTR BULLET,
;     thisBulletAmount: PTR BYTE, 
;     thisGameMap: PTR BYTE

;     mov esi, thisBullet
;     mov edi, thisGameMap
    
;     movzx ecx, (BULLET PTR [esi]).position.Y
; BulletHit_ChangeRow:
;     add edi, GAME_MAP_WIDTH
;     loop BulletHit_ChangeRow

;     movzx ecx, (bullet PTR [esi]).position.X
;     add edi, ecx
    
;     mov ebx, [edi]
;     .IF ebx == GAME_MAP_CHAR_EMPTY
;         jmp BulletHit_BulletHitEnd
;     .ENDIF

;     push esi
;     mov esi, thisBulletAmount               ; hit something (tank or wall)
;     sub (BYTE PTR [esi]), 1                 ; bullet amount - 1
;     pop esi

;     mov al, (bullet PTR [esi]).role
;     .IF ebx == GAME_MAP_CHAR_PLAYER                        ; hit our tank
;         .IF al == ROLE_PLAYER
;             jmp BulletHit_BulletHitEnd
;         .ENDIF
;         ; ourTankDestroy
;         ; 
;     .ENDIF

;     .IF ebx == GAME_MAP_CHAR_ENEMY                        ; hit enemy's tank
;         .IF al == ROLE_ENEMY
;             jmp BulletHit_BulletHitEnd                ; enemy hit enemy
;         .ENDIF
;         ; enemyTankDestroy
;     .ENDIF
;                                             ; if hit wall, do nothing      
; BulletHit_BulletHitEnd:
;     ret
; BulletHit ENDP

;; WhatPositionIs
;; Returns:
;;     EAX: Which game map object at this position
WhatPositionIs PROC USES edi,
    thisPosition: COORD,
    thisGameMap: PTR BYTE

    INVOKE GetRenderBufferIndex, thisPosition
    movzx eax, ax
    mov edi, thisGameMap

    ; this Position might be wall, enemy's bullet, enemy's tank
    .IF     (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_EMPTY
        mov al, GAME_MAP_PLAYER_NUMBER                 ; 1
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER
        mov al, GAME_MAP_PLAYER_NUMBER                 ; 2
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY
        mov al, GAME_MAP_ENEMY_NUMBER                  ; 3
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER_BULLET
        mov al, GAME_MAP_PLAYER_BULLET_NUMBER          ; 4
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY_BULLET
        mov al, GAME_MAP_ENEMY_BULLET_NUMBER           ; 5
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_0
        mov al, GAME_MAP_WALL_0_NUMBER                 ; 6
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_1
        mov al, GAME_MAP_WALL_1_NUMBER                 ; 7
    .ENDIF
WhatPositionIs_Return:
    ret
WhatPositionIs ENDP

;; DeleteBullet
DeleteBullet PROC USES eax ebx ecx edx esi edi, 
    thisBullet: PTR BULLET,
    bulletAmount: PTR BYTE, 
    bulletList: PTR BULLET

    mov edx, bulletAmount
    mov esi, thisBullet
    mov edi, bulletList
    movzx ecx, (BYTE PTR [edx])
DeleteBullet_CheckBullet:
    mov ax, (BULLET PTR [esi]).position.x
    mov bx, (BULLET PTR [edi]).position.x
    cmp ax, bx
    jne DeleteBullet_RunCheckLoop
    mov ax, (BULLET PTR [esi]).position.y
    mov bx, (BULLET PTR [edi]).position.y
    cmp ax, bx
    jne DeleteBullet_RunCheckLoop
    push ecx
    push edi
    dec ecx
DeleteBullet_RunToEnd:
    inc edi
    loop DeleteBullet_RunToEnd
DeleteBullet_MoveEndToDelete:
    mov eax, edi
    pop edi
    pop ecx
    mov bx, (BULLET PTR [eax]).position.x
    mov (BULLET PTR [edi]).position.x, bx
    mov bx, (BULLET PTR [eax]).position.y
    mov (BULLET PTR [edi]).position.y, bx
    mov bl, (BULLET PTR [eax]).direction
    mov bh, (BULLET PTR [eax]).role
    mov (BULLET PTR [edi]).direction, bl
    mov (BULLET PTR [edi]).role, bh
    dec (BYTE PTR [edx])
DeleteBullet_RunCheckLoop:
    inc edi
    loop DeleteBullet_CheckBullet
    ret
DeleteBullet ENDP

; delete tank
DeleteTank PROC USES esi,
    thisBullet: PTR BULLET,
    ourTank: PTR TANK,
    enemyTankList: PTR TANK,
    enmyTankAmount: PTR BYTE

    mov esi, thisBullet
    mov edi, ourTank

    ; check if our tank be hit
    mov ax, (tank PTR [edi]).position.x 
    cmp ax, (bullet PTR [esi]).position.x
    ja DeleteTank_checkEnemies

    add ax, 2
    cmp ax, (bullet PTR [esi]).position.X
    jb DeleteTank_checkEnemies

    mov ax, (tank PTR [edi]).position.Y
    cmp ax, (bullet PTR [esi]).position.Y
    ja DeleteTank_checkEnemies

    add ax, 2
    cmp ax, (bullet PTR [esi]).position.Y
    jb DeleteTank_checkEnemies

    sub (tank PTR [edi]).hp, 1
    jmp DeleteTank_return 
DeleteTank_checkEnemies:
    mov edi, enemyTankAmount
    movzx ecx, (BYTE PTR [edi])
    
    mov edi, enemyTankList
    cmp ecx, 0
    je DeleteTank_return
DeleteTank_checkEnemy:
    mov ax, (tank PTR [edi]).position.X
    cmp ax, (bullet PTR [esi]).position.x
    ja DeleteTank_nextTank

    add ax, 2
    cmp ax, (bullet PTR [esi]).position.X
    jb DeleteTank_nextTank

    mov al, (tank PTR [edi]).position.Y
    cmp al, (bullet PTR [esi]).position.Y
    ja DeleteTank_nextTank

    add al, 2
    cmp al, (bullet PTR [esi]).position.Y
    jb DeleteTank_nextTank
       
    jmp DeleteTank_deleteEnemyTank
DeleteTank_nextTank:
    add edi, 7          ; struct tank is 7 byte
    loop DeleteTank_checkEnemy
DeleteTank_deleteEnemyTank:
    mov esi, enemyTankAmount
    movzx ecx, (BYTR PTR [esi])
    cmp ecx, 0
    je deleteEnemyTank2
DeleteTank_moveToLastTank:
    add esi, 7
    loop DeleteTank_movToLastTank
DeleteTank_deleteEnemyTank2:
    mov ax, (Tank PTR [esi]).position.X
    mov (Tank PTR [edi]).position.x, ax

    mov ax, (Tank PTR [esi]).position.Y
    mov (Tank PTR [edi]).position.y, ax

    mov al, (Tank PTR [esi]).faceTo
    mov (Tank PTR [edi]).faceTo, al

    mov al, (Tank PTR [esi]).role
    mov (Tank PTR [edi]).role, al

    mov al, (Tank PTR [esi]).hp
    mov (Tank PTR [edi]).hp, al

    mov edi, enemyTankAmount
    sub (BYTE PTR [edi]), 1 
DeleteTank_return:
    ret
DeleteTank ENDP
