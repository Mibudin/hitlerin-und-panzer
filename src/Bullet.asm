TITLE Bullet (Bullet.asm)

; ==========
; = Bullet =
; ==========

; The main handler of the bullets


;; PrintBullet
;; print bullet
PrintBullet PROC USES esi,
    thisOutputHandle: DWORD,
    thisBullet: PTR BULLET,
    countWord: PTR DWORD
    
    mov esi, thisBullet

    INVOKE PushRenderBufferImageDiscardable,
        RENDER_BUFFER_LAYER_BULLETS,
        ADDR bulletCmdImage,
        (BULLET PTR [esi]).position

    ; INVOKE WriteConsoleOutputAttribute,  ; set color
    ;     thisOutputHandle,
    ;     ADDR (Bullet PTR [esi]).color,
    ;     1,
    ;     (Bullet PTR [esi]).position,
    ;     countWord
    ; INVOKE WriteConsoleOutputCharacter,  ; 設定字母
    ;     thisOutputHandle, 
    ;     ADDR (Bullet PTR [esi]).symbol,
    ;     1,
    ;     (Bullet PTR [esi]).position,
    ;     countWord

    ret
PrintBullet ENDP

;; EraseBullet
;; before print new bullet, remove the old bullet 
EraseBullet PROC USES esi, 
    thisOutputHandle: DWORD,
    thisBullet: PTR BULLET,
    countWord: PTR DWORD

    mov esi, thisBullet

    INVOKE PushRenderBufferImageBlank,
        RENDER_BUFFER_LAYER_BULLETS,
        (TANK PTR [esi]).position,
        bulletSize

    ; INVOKE WriteConsoleOutputAttribute,  ; set color
    ;     thisOutputHandle,
    ;     ADDR (Bullet PTR [esi]).color,
    ;     1,
    ;     (Bullet PTR [esi]).position,
    ;     countWord
    ; INVOKE WriteConsoleOutputCharacter,  ; 設定字母
    ;     thisOutputHandle, 
    ;     ADDR (Bullet PTR [esi]).white,
    ;     1,
    ;     (Bullet PTR [esi]).position,
    ;     countWord

    ret
EraseBullet ENDP

;; BulletMove
;; move one byte toward bullet's direction
BulletMove PROC USES eax,
    thisOutputHandle: DWORD, 
    thisBullet: PTR BULLET,
    countWord: PTR DWORD

    INVOKE EraseBullet, thisOutputHandle, thisBullet, countWord
    
    mov esi, thisBullet
    mov al, (BULLET PTR [esi]).direction 
    
    cmp al, 1h
    je BulletMove_FlyUp
    cmp al, 2h
    je BulletMove_FlyRight
    cmp al, 3h
    je BulletMove_FlyDown
    cmp al, 4h
    je BulletMove_FlyLeft

BulletMove_FlyUp:
    sub (BULLET PTR [esi]).position.Y, 1
    jmp BulletMove_EndMove
BulletMove_FlyRight:
    add (BULLET PTR [esi]).position.X, 1
    jmp BulletMove_EndMove
BulletMove_FlyDown:
    add (BULLET PTR [esi]).position.Y, 1
    jmp BulletMove_EndMove
BulletMove_FlyLeft:
    sub (BULLET PTR[esi]).position.X, 1
    jmp BulletMove_EndMove
BulletMove_EndMove:
    INVOKE PrintBullet, thisOutputHandle, thisBullet, countWord
    ret
BulletMove ENDP
