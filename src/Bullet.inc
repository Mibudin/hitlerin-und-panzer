TITLE Bullet (Bullet.inc)

; ==========
; = Bullet =
; ==========

; The main handler of the bullets


; ==========
; = PROTOS =
; ==========

printBullet PROTO,
    thisOutputHandle: DWORD,
    thisBullet: PTR bullet,
    countWord: PTR DWORD
