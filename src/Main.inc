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

    call WaitMsg

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
    ; mov al, mapCmdImage_characters[128]
    ; call WriteChar
    ; call WaitMsg

    mClearRenderBuffer RENDER_BUFFER_LAYER_TANKS
    mClearRenderBuffer RENDER_BUFFER_LAYER_BULLETS
    mClearRenderBuffer RENDER_BUFFER_LAYER_FINALE

    ; Player tank
    call ReadKey
    INVOKE MoveTank, stdOutputHandle, ADDR testTank, ADDR gameMapRecord, ax, ADDR trashBus

    ; Enemy tank
    INVOKE GetDirection, ADDR testTankEnemy1
    INVOKE MoveRandom, stdOutputHandle, ADDR testTankEnemy1, ADDR gameMapRecord, ADDR trashBus
    INVOKE GetDirection, ADDR testTankEnemy2
    INVOKE MoveRandom, stdOutputHandle, ADDR testTankEnemy2, ADDR gameMapRecord, ADDR trashBus

    ; INVOKE RenderDiscardable, RENDER_BUFFER_LAYER_GAME_MAP
    ; INVOKE RenderDiscardable, RENDER_BUFFER_LAYER_TANKS
    ; INVOKE RenderDiscardable, RENDER_BUFFER_LAYER_BULLETS

    INVOKE IntegrateRenderBufferFinaleAllDiscardable
    INVOKE RenderDiscardable, RENDER_BUFFER_LAYER_FINALE

    ; call WaitMsg

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
