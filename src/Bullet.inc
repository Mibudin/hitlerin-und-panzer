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
    thisBullet: PTR bullet,
    thisGameMap: PTR BYTE,
    bulletAmount: PTR BYTE,
    bulletList: PTR BULLET,
    ourTank: PTR Tank, 
    enemyTankList: PTR Tank, 
    enemyTankAmount: PTR BYTE

NewBullet PROTO,
    thisTank: PTR TANK,
    bulletAmount: PTR BYTE,
    bulletList: PTR BULLET,
    gameMap: PTR BYTE

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

DeleteTank PROTO,
    thisBullet: PTR BULLET,
    ourTank: PTR TANK,
    enemyTankList: PTR TANK,
    enemyTankAmount: PTR BYTE
