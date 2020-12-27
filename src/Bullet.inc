TITLE Bullet (Bullet.inc)

; ==========
; = Bullet =
; ==========

; The main handler of the bullets


; ==========
; = PROTOS =
; ==========

PrintBullet PROTO,
    thisOutputHandle: DWORD,
    thisBullet: PTR BULLET,
    thisGameMap: PTR BYTE,
    countWord: PTR DWORD

EraseBullet PROTO, 
    thisOutputHandle: DWORD,
    thisBullet: PTR BULLET,
    thisGameMap: PTR BYTE,
    countWord: PTR DWORD

BulletMove PROTO,
    thisOutputHandle: DWORD, 
    thisBullet: PTR BULLET,
    thisGameMap: PTR BYTE,
    countWord: PTR DWORD

NewBullet PROTO,
    thisTank: PTR TANK,
    bulletAmount: PTR BYTE,
    bulletList: PTR BULLET

BulletHit PROTO,
    thisBullet: PTR BULLET,
    thisBulletAmount: PTR BYTE, 
    thisGameMap: PTR BYTE
