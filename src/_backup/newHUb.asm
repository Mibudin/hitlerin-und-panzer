PLAYER  EQU <0>
COMPUTER    EQU <1>

TANK STRUCT 
    ; firstLine   BYTE  ' ', 7Ch, ' '  ;  |
    ; secondLine  BYTE  23h, 2Bh, 23h  ; #+#
    ; thirdLine   BYTE  23h, 2Bh, 23h  ; #+#
    ; firstColor  WORD  6h, 6h, 6h     ; brown
    ; secondColor WORD  6h, 0ch, 6h    ; brown red brown
    ; threeWhite  BYTE  3 DUP(' ')     ; for EraseTank
    position    COORD <1, 1>         ; left up
    faceTo      BYTE  TANK_FACE_UP   ; 1 : face up, 2 : face right, 3 : face down, 4 : face left
    role        BYTE  PLAYER
TANK ENDS