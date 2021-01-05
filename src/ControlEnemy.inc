TITLE ControlEnemy (ControlEnemy.inc)

; ================
; = ControlEnemy =
; ================

; The main handler of controling enemies


; ==========
; = PROTOS =
; ==========

GetDirection PROTO,
    thisTank: PTR TANK,
    playerTank: PTR TANK

ComputerTankMove PROTO,
    thisOutputHandle: DWORD,
    thisTank: PTR TANK,
    countWord: PTR DWORD

Detect PROTO,
    thisTank: PTR TANK,
    playerTank: PTR TANK

Shoot PROTO,
    thisTank: PTR TANK,
    playerTank: PTR TANK
