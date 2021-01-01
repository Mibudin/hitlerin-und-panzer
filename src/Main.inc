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
;; TODO: HITLERIN
mMainGameTurn_GameStateStart MACRO
    call Home    

    mov gameState, GAME_STATE_GAME_MAP
    ; mov gameState, GAME_STATE_TEST
    call Clrscr

    mov eax, TRUE
ENDM

;; mMainGameTurn_GameStateGameMap
;; TODO: Move to ending
mMainGameTurn_GameStateGameMap MACRO
    ; Clear render buffer layers
    mClearRenderBuffer RENDER_BUFFER_LAYER_TANKS
    mClearRenderBuffer RENDER_BUFFER_LAYER_BULLETS
    mClearRenderBuffer RENDER_BUFFER_LAYER_FINALE

    ; Player tank
    call ReadKey
    INVOKE MoveTank, stdOutputHandle, ADDR gamePlayerTank, ADDR gameMapRecord, ax, ADDR trashBus

    ; Enemy tank
    mov ecx, ENEMY_TANK_AMOUNT_INITIAL
    xor edx, edx
mMainGameTurn_GameStateGameMap_EnemyTanks:
    INVOKE GetDirection, ADDR gameEnemyTankList[edx], ADDR gamePlayerTank
    INVOKE ComputerTankMove, stdOutputHandle, ADDR gameEnemyTankList[edx], ADDR trashBus
    add edx, TANK
    loop mMainGameTurn_GameStateGameMap_EnemyTanks

    ; Render
    INVOKE IntegrateRenderBufferFinaleAllDiscardable
    INVOKE RenderDiscardable, RENDER_BUFFER_LAYER_FINALE

    ; mov gameState, GAME_STATE_END

    mov eax, TRUE
ENDM

;; mMainGameTurn_GameStateEnd
;; TODO: Ending
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
