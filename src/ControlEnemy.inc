TITLE ControlEnemy (ControlEnemy.inc)

; ================
; = ControlEnemy =
; ================

; The main handler of controling enemies


GetDirection PROTO,
    thisTank: PTR Tank,

MoveRandom PROTO,
    thisOutputHandle: DWORD,
    thisTank: PTR Tank,
    GameMap: PTR BYTE,
    countWord: PTR DWORD

DetectShoot PROTO,
    thisTank: PTR Tank,
    playerTank: PTR Tank
