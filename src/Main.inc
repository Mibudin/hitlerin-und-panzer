TITLE Main (Main.inc)

; ========
; = Main =
; ========

; The main program file of this project


; ==========
; = MACROS =
; ==========

;; mMainGameTurn_GameStateTest
mMainGameTurn_GameStateTest MACRO
    ; mClearRenderBuffer RENDER_BUFFER_LAYER_TANKS

    ; call ReadKey
    ; INVOKE MoveTank, stdOutputHandle, ADDR testTank, ADDR gameMapRecord, ax, ADDR trashBus

    ; INVOKE RenderDiscardable, RENDER_BUFFER_LAYER_TANKS

    mov eax, TRUE
ENDM

;; mMainGameTurn_GameStateStart
mMainGameTurn_GameStateStart MACRO
    call Home    

    mov gameState, GAME_STATE_GAME_MAP
    ; mov gameState, GAME_STATE_TEST
    call Clrscr

    mov eax, TRUE
ENDM

;; mMainGameTurn_GameStateGameMap
mMainGameTurn_GameStateGameMap MACRO
    mClearRenderBuffer RENDER_BUFFER_LAYER_TANKS

    call ReadKey
    INVOKE MoveTank, stdOutputHandle, ADDR testTank, ADDR gameMapRecord, ax, ADDR trashBus

    INVOKE RenderDiscardable, RENDER_BUFFER_LAYER_TANKS

    ; mov gameState, GAME_STATE_END

    mov eax, TRUE
ENDM

;; mMainGameTurn_GameStateEnd
mMainGameTurn_GameStateEnd MACRO
    mov eax, TRUE
ENDM


; ==========
; = PROTOS =
; ==========

Main PROTO

MainGameInit PROTO

MainGameLoop PROTO

MainGameTurn PROTO

MainGameExit PROTO
