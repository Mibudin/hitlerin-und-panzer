TITLE Tank (Tank.inc)

; ========
; = Tank =
; ========

; The main handler of the tanks


; ==========
; = PROTOS =
; ==========

PrintTank PROTO,
    thisOutputHandle: DWORD,
    thisTank: PTR TANK,
	gameMap: PTR BYTE,
    countWord: PTR DWORD

EraseTank PROTO,
    thisOutputHandle: DWORD,
    thisTank: PTR TANK,
	gameMap: PTR BYTE,
    countWord: PTR DWORD

ChangeFaceTo PROTO,
    thisTank: PTR TANK,
    newFaceTo: BYTE

MoveTank PROTO, 
    thisOutputHandle: DWORD, 
    thisTank: PTR TANK,
    gameMap: PTR BYTE,
    direction: WORD, 
    countWord: PTR DWORD
