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
    thisTank: PTR Tank,
    countWord: PTR DWORD

EraseTank PROTO,
    thisOutputHandle: DWORD,
    thisTank: PTR Tank,
    countWord: PTR DWORD

ChangeFaceTo PROTO,
    thisTank: PTR Tank,
    newFaceTo: BYTE

MoveTank PROTO, 
    thisOutputHandle: DWORD, 
    thisTank: PTR Tank,
    direction: WORD, 
    countWord: PTR DWORD
