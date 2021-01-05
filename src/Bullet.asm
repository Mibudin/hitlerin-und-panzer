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
    
    ; Print bullet
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

    ; Record in map
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
EraseBullet PROC USES eax esi edi,
    thisBullet: PTR BULLET,
    thisGameMap: PTR BYTE

    mov esi, thisBullet

    ; Erase bullet
    ; INVOKE PushRenderBufferImageBlank,
    ;     RENDER_BUFFER_LAYER_BULLETS,
    ;     (BULLET PTR [esi]).position,
    ;     bulletSize

    ; Record in map
    mov edi, thisGameMap
    INVOKE GetRenderBufferIndex, (BULLET PTR [esi]).position
    movzx eax, ax
       
    mov (BYTE PTR [edi + eax]), GAME_MAP_CHAR_EMPTY
    ret
EraseBullet ENDP

;; BulletMove
;; move one byte toward bullet's direction
;; TODO: Bullets conflicts!!!
BulletMove PROC USES eax ebx esi edi,
    thisBullet: PTR BULLET,
    thisGameMap: PTR BYTE,
    bulletAmount: PTR BYTE,
    bulletList: PTR BULLET,
    ourTank: PTR TANK,
    enemyTankList: PTR TANK,
    enemyTankAmount: PTR BYTE

    ; Erase bullets
    INVOKE EraseBullet, thisBullet, thisGameMap
    
    mov edi, thisGameMap
    mov esi, thisBullet
    mov al, (BULLET PTR [esi]).direction
    movzx ebx, (BULLET PTR [esi]).role
    ; Different check
    cmp al, FACE_UP
    je BulletMove_FlyUp
    cmp al, FACE_RIGHT
    je BulletMove_FlyRight
    cmp al, FACE_DOWN
    je BulletMove_FlyDown
    cmp al, FACE_LEFT
    je BulletMove_FlyLeft
BulletMove_FlyUp:
    mov ax, (BULLET PTR [esi]).position.Y
    dec ax
    mov (BULLET PTR [esi]).position.Y, ax

    INVOKE GetRenderBufferIndex, (BULLET PTR [esi]).position
    movzx eax, ax

    ; If role's bullet hit wall, enemy's bullet, enemy's tank
    .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_0
        INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
        jmp MoveBullet_return  
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_1
        INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
        jmp MoveBullet_return
    ; .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY_BULLET
    ;     sub (BULLET PTR [esi]).position.y, 1
    ;     INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
    ;     jmp MoveBullet_return 
    ; .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER_BULLET
    ;     sub (BULLET PTR [esi]).position.y, 1
    ;     INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
    ;     jmp MoveBullet_return 
    .ENDIF
    
    .IF ebx == ROLE_PLAYER
        .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY
            INVOKE DeleteTank, thisBullet, ourTank, enemyTankList, enemyTankAmount
            INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
            jmp MoveBullet_return 
        .ENDIF    
    .ELSEIF ebx == ROLE_ENEMY
        .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER
            INVOKE DeleteTank, thisBullet, ourTank, enemyTankList, enemyTankAmount
            INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
            jmp MoveBullet_return 
        .ENDIF
    .ENDIF

    jmp Print_bullet
BulletMove_FlyRight:
    mov ax, (BULLET PTR [esi]).position.x
    inc ax
    mov (BULLET PTR [esi]).position.x, ax

    INVOKE GetRenderBufferIndex, (BULLET PTR [esi]).position
    movzx eax, ax

    ; If role's bullet hit wall, enemy's bullet, enemy's tank
    .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_0
        INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
        jmp MoveBullet_return  
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_1
        INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
        jmp MoveBullet_return
    ; .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY_BULLET
    ;     add (BULLET PTR [esi]).position.x, 1
    ;     INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
    ;     jmp MoveBullet_return 
    ; .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER_BULLET
    ;     add (BULLET PTR [esi]).position.x, 1
    ;     INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
    ;     jmp MoveBullet_return 
    .ENDIF
    
    .IF ebx == ROLE_PLAYER
        .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY
            INVOKE DeleteTank, thisBullet, ourTank, enemyTankList, enemyTankAmount
            INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
            jmp MoveBullet_return 
        .ENDIF    
    .ELSEIF ebx == ROLE_ENEMY
        .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER
            INVOKE DeleteTank, thisBullet, ourTank, enemyTankList, enemyTankAmount
            INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
            jmp MoveBullet_return 
        .ENDIF
    .ENDIF

    jmp Print_bullet
BulletMove_FlyDown:
    mov ax, (BULLET PTR [esi]).position.Y
    inc ax
    mov (BULLET PTR [esi]).position.Y, ax

    INVOKE GetRenderBufferIndex, (BULLET PTR [esi]).position
    movzx eax, ax

    ; If role's bullet hit wall, enemy's bullet, enemy's tank
    .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_0
        INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
        jmp MoveBullet_return  
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_1
        INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
        jmp MoveBullet_return
    ; .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY_BULLET
    ;     add (BULLET PTR [esi]).position.x, 1
    ;     INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
    ;     jmp MoveBullet_return 
    ; .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER_BULLET
    ;     add (BULLET PTR [esi]).position.x, 1
    ;     INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
    ;     jmp MoveBullet_return 
    .ENDIF
    
    .IF ebx == ROLE_PLAYER
        .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY
            INVOKE DeleteTank, thisBullet, ourTank, enemyTankList, enemyTankAmount
            INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
            jmp MoveBullet_return 
        .ENDIF    
    .ELSEIF ebx == ROLE_ENEMY
        .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER
            INVOKE DeleteTank, thisBullet, ourTank, enemyTankList, enemyTankAmount
            INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
            jmp MoveBullet_return 
        .ENDIF
    .ENDIF

    jmp Print_bullet
BulletMove_FlyLeft:
    mov ax, (BULLET PTR [esi]).position.x
    sub ax, 1
    mov (BULLET PTR [esi]).position.x, ax

    INVOKE GetRenderBufferIndex, (BULLET PTR [esi]).position
    movzx eax, ax

    ; If role's bullet hit wall, enemy's bullet, enemy's tank
    .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_0
        INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
        jmp MoveBullet_return  
    .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_WALL_1
        INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
        jmp MoveBullet_return
    ; .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY_BULLET
    ;     add (BULLET PTR [esi]).position.x, 1
    ;     INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
    ;     jmp MoveBullet_return 
    ; .ELSEIF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER_BULLET
    ;     add (BULLET PTR [esi]).position.x, 1
    ;     INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
    ;     jmp MoveBullet_return 
    .ENDIF
    
    .IF ebx == ROLE_PLAYER
        .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_ENEMY
            INVOKE DeleteTank, thisBullet, ourTank, enemyTankList, enemyTankAmount
            INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
            jmp MoveBullet_return 
        .ENDIF    
    .ELSEIF ebx == ROLE_ENEMY
        .IF (BYTE PTR [edi + eax]) == GAME_MAP_CHAR_PLAYER
            INVOKE DeleteTank, thisBullet, ourTank, enemyTankList, enemyTankAmount
            INVOKE DeleteBullet, thisBullet, bulletAmount, bulletList
            jmp MoveBullet_return 
        .ENDIF
    .ENDIF

    jmp Print_bullet
Print_bullet:
    INVOKE PrintBullet, thisBullet, thisGameMap
MoveBullet_return:
    ret
BulletMove ENDP

;; NewBullet
NewBullet PROC USES eax esi edi,
    thisTank: PTR TANK,
    bulletAmount: PTR BYTE,
    bulletList: PTR BULLET,
    gameMap: PTR BYTE

    ; Get the position that the new bullet should appear
    mov esi, bulletList
    mov edi, bulletAmount
    mov al, [edi]
    .IF al == 0h
        jmp NewBullet_SetNewBullet
    .ENDIF
    movzx ecx, al
NewBullet_MoveToNewBullet:
    add esi, BULLET
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

        ; mov (bullet PTR [esi]).position.X, (tank PTR [edi]).position.X
        ; add (bullet PTR [esi]).position.X, 1h

        ; mov (bullet PTR [esi]).position.Y, (tank PTR [edi]).position.Y
        ; sub (bullet PTR [esi]).position.Y, 1h

        mov (bullet PTR [esi]).direction, FACE_UP
        jmp NewBullet_NewBulletEnd

    .ELSEIF al == FACE_RIGHT
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

    .ELSEIF al == FACE_DOWN
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

    .ELSEIF al == FACE_LEFT
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
    mov edi, bulletAmount
    add (BYTE PTR [edi]), 1
    INVOKE BulletMove, esi, gameMap, bulletAmount, bulletList, ADDR gamePlayerTank, ADDR gameEnemyTankList, ADDR gameEnemyTankCurrentAmount
NewBullet_return:
    ret
NewBullet ENDP 

;; WhatPositionIs
;; Returns:
;;     EAX: Which game map object at this position
WhatPositionIs PROC USES edi,
    thisPosition: COORD,
    thisGameMap: PTR BYTE

    INVOKE GetRenderBufferIndex, thisPosition
    movzx eax, ax
    mov edi, thisGameMap

    ; This position might be wall, enemy's bullet, enemy's tank
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
    ; push ecx
    dec ecx
    jz DeleteBullet_DecreaseTheBulletAmount
    push edi
DeleteBullet_RunToEnd:
    add edi, BULLET
    loop DeleteBullet_RunToEnd
DeleteBullet_MoveEndToDelete:
    mov eax, edi
    pop edi
    ; pop ecx
    mov bx, (BULLET PTR [eax]).position.x
    mov (BULLET PTR [edi]).position.x, bx
    mov bx, (BULLET PTR [eax]).position.y
    mov (BULLET PTR [edi]).position.y, bx
    mov bl, (BULLET PTR [eax]).direction
    mov bh, (BULLET PTR [eax]).role
    mov (BULLET PTR [edi]).direction, bl
    mov (BULLET PTR [edi]).role, bh
DeleteBullet_DecreaseTheBulletAmount:
    dec (BYTE PTR [edx])
    jmp DeleteBullet_Return
DeleteBullet_RunCheckLoop:
    add edi, BULLET
    loop DeleteBullet_CheckBullet
DeleteBullet_Return:
    ret
DeleteBullet ENDP

;; DeleteTank
;; delete tank
DeleteTank PROC USES eax ecx esi edi,
    thisBullet: PTR BULLET,
    ourTank: PTR TANK,
    enemyTankList: PTR TANK,
    enemyTankAmount: PTR BYTE

    mov esi, thisBullet
    mov edi, ourTank

    ; check if our tank be hit
    mov ax, (TANK PTR [edi]).position.x
    cmp ax, (BULLET PTR [esi]).position.x
    ja DeleteTank_checkEnemies

    add ax, 2
    cmp ax, (BULLET PTR [esi]).position.X
    jb DeleteTank_checkEnemies

    mov ax, (TANK PTR [edi]).position.Y
    cmp ax, (BULLET PTR [esi]).position.Y
    ja DeleteTank_checkEnemies

    add ax, 2
    cmp ax, (BULLET PTR [esi]).position.Y
    jb DeleteTank_checkEnemies

    sub (TANK PTR [edi]).hp, 1
    INVOKE UpdateFlagOnMap, ROLE_PLAYER
    jmp DeleteTank_return
DeleteTank_checkEnemies:
    mov edi, enemyTankAmount
    movzx ecx, (BYTE PTR [edi])
    
    mov edi, enemyTankList
    cmp ecx, 0
    je DeleteTank_return
DeleteTank_checkEnemy:
    mov ax, (TANK PTR [edi]).position.X
    cmp ax, (BULLET PTR [esi]).position.x
    ja DeleteTank_nextTank

    add ax, 2
    cmp ax, (BULLET PTR [esi]).position.X
    jb DeleteTank_nextTank

    mov ax, (TANK PTR [edi]).position.Y
    cmp ax, (BULLET PTR [esi]).position.Y
    ja DeleteTank_nextTank

    add ax, 2
    cmp ax, (BULLET PTR [esi]).position.Y
    jb DeleteTank_nextTank
       
    jmp DeleteTank_deleteEnemyTank
DeleteTank_nextTank:
    add edi, TANK          ; struct tank is 7 byte
    loop DeleteTank_checkEnemy
DeleteTank_deleteEnemyTank:
    INVOKE EraseTank, stdOutputHandle, edi, ADDR gameMapRecord, ADDR trashBus
    mov esi, enemyTankAmount
    movzx ecx, (BYTE PTR [esi])
    dec ecx
    cmp ecx, 0
    je DeleteTank_DecreaseTheTankAmount
    mov esi, enemyTankList
DeleteTank_moveToLastTank:
    add esi, TANK
    loop DeleteTank_moveToLastTank
DeleteTank_deleteEnemyTank2:
    mov ax, (TANK PTR [esi]).position.X
    mov (TANK PTR [edi]).position.x, ax

    mov ax, (TANK PTR [esi]).position.Y
    mov (TANK PTR [edi]).position.y, ax

    mov al, (TANK PTR [esi]).faceTo
    mov (TANK PTR [edi]).faceTo, al

    mov al, (TANK PTR [esi]).role
    mov (TANK PTR [edi]).role, al

    mov al, (TANK PTR [esi]).hp
    mov (TANK PTR [edi]).hp, al

DeleteTank_DecreaseTheTankAmount:
    mov edi, enemyTankAmount
    sub (BYTE PTR [edi]), 1
    INVOKE UpdateFlagOnMap, ROLE_ENEMY
DeleteTank_return:
    ret
DeleteTank ENDP
