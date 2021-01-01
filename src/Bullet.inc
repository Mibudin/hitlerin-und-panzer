TITLE Bullet (Bullet.inc)

; ==========
; = Bullet =
; ==========

; The main handler of the bullets


; ==========
; = PROTOS =
; ==========

PrintBullet PROTO,
    thisBullet: PTR BULLET,
    thisGameMap: PTR BYTE

EraseBullet PROTO,
    thisBullet: PTR BULLET,
    thisGameMap: PTR BYTE

BulletMove PROTO,
    thisBullet: PTR BULLET,
    thisGameMap: PTR BYTE,
    bulletAmount: BYTE,
    bulletList: PTR BULLET

NewBullet PROTO,
    thisTank: PTR TANK,
    bulletAmount: PTR BYTE,
    bulletList: PTR BULLET

; BulletHit PROTO,
;     thisBullet: PTR BULLET,
;     thisBulletAmount: PTR BYTE, 
;     thisGameMap: PTR BYTE

WhatPositionIs PROTO,
    thisPosition: COORD,
    thisGameMap: PTR BYTE

DeleteBullet PROTO, 
    thisBullet: PTR BULLET,
    bulletAmount: PTR BYTE, 
    bulletList: PTR BULLET
