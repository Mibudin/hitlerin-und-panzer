TITLE ControlEnemy (ControlEnemy.inc)

; ================
; = ControlEnemy =
; ================

; The main handler of controling enemies


; ==========
; = PROTOS =
; ==========

GetDirection PROTO,
    thisTank: PTR Tank,
    playerTank: PTR Tank

ComputerTankMove PROTO,
    thisOutputHandle: DWORD,
    thisTank: PTR Tank,
    countWord: PTR DWORD


; MoveRandom PROTO,
;     thisOutputHandle: DWORD,
;     thisTank: PTR Tank,
;     GameMap: PTR BYTE,
;     countWord: PTR DWORD

Detect PROTO,
    thisTank: PTR Tank,
    playerTank: PTR Tank

Shoot PROTO,
    thisTank: PTR Tank,
    playerTank: PTR Tank
