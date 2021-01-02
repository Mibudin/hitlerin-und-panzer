TITLE Main (Main.inc)

; ========
; = Main =
; ========

; The main program file of this project


; ==========
; = MACROS =
; ==========

;; mMainGameTurn_GameStateTest_Pre
mMainGameTurn_GameStateTest_Pre MACRO
ENDM

;; mMainGameTurn_GameStateTest
mMainGameTurn_GameStateTest MACRO
    ; mClearRenderBuffer RENDER_BUFFER_LAYER_TANKS

    ; call ReadKey
    ; INVOKE MoveTank, stdOutputHandle, ADDR testTank, ADDR gameMapRecord, ax, ADDR trashBus

    ; INVOKE RenderDiscardable, RENDER_BUFFER_LAYER_TANKS

    ; INVOKE RenderDiscardable, RENDER_BUFFER_LAYER_GAME_MAP

    ; call WaitMsg

    mov eax, TRUE
ENDM

;; mMainGameTurn_GameStateStart_Pre
mMainGameTurn_GameStateStart_Pre MACRO
    INVOKE PushRenderBufferImageDiscardable,
        RENDER_BUFFER_LAYER_GAME_MAP,
        ADDR startMenuCmdImage,
        stdRenderOrigin
    INVOKE Render, RENDER_BUFFER_LAYER_GAME_MAP
ENDM

;; mMainGameTurn_GameStateStart
;; TODO: More beautiful?
mMainGameTurn_GameStateStart MACRO
    call ReadKey
    movzx edx, startMenuState
    .IF edx == START_MENU_STATE_MAIN
        .IF     ax == 3920h                 ; SPACE
            mov gameState, GAME_STATE_GAME_MAP
            mMainGameTurn_GameStateGameMap_Pre

        .ELSEIF ax == 1372h || ax == 1352h  ; r || R
            INVOKE PushRenderBufferImage,
                RENDER_BUFFER_LAYER_GAME_MAP,
                ADDR menuRuleCmdImage,
                stdRenderOrigin
            INVOKE Render, RENDER_BUFFER_LAYER_GAME_MAP
            mov startMenuState, START_MENU_STATE_RULES

        .ELSEIF ax == 326Dh || ax == 324Dh  ; m || M
            INVOKE PushRenderBufferImage,
                RENDER_BUFFER_LAYER_GAME_MAP,
                ADDR menuCreditsCmdImage,
                stdRenderOrigin
            INVOKE Render, RENDER_BUFFER_LAYER_GAME_MAP
            mov startMenuState, START_MENU_STATE_CREDITS

        .ENDIF

    .ELSEIF edx == START_MENU_STATE_RULES
        .IF     ax == 2D78h || ax == 2D58h  ; x || X
            INVOKE PushRenderBufferImage,
                RENDER_BUFFER_LAYER_GAME_MAP,
                ADDR startMenuCmdImage,
                stdRenderOrigin
            INVOKE Render, RENDER_BUFFER_LAYER_GAME_MAP
            mov startMenuState, START_MENU_STATE_MAIN

        .ENDIF

    .ELSEIF edx == START_MENU_STATE_CREDITS
        .IF     ax == 2D78h || ax == 2D58h  ; x || X
            INVOKE PushRenderBufferImage,
                RENDER_BUFFER_LAYER_GAME_MAP,
                ADDR startMenuCmdImage,
                stdRenderOrigin
            INVOKE Render, RENDER_BUFFER_LAYER_GAME_MAP
            mov startMenuState, START_MENU_STATE_MAIN

        .ENDIF

    .ENDIF

    mov eax, TRUE
ENDM

;; mMainGameTurn_GameStateGameMap_Pre
mMainGameTurn_GameStateGameMap_Pre MACRO
    INVOKE PushRenderBufferImageDiscardable,
        RENDER_BUFFER_LAYER_GAME_MAP,
        ADDR mapCmdImage,
        stdRenderOrigin
ENDM

;; mMainGameTurn_GameStateGameMap
;; TODO: Move to ending
;; TODO: Tanks, bullets, lives
mMainGameTurn_GameStateGameMap MACRO
    ; Clear render buffer layers
    mClearRenderBuffer RENDER_BUFFER_LAYER_TANKS
    mClearRenderBuffer RENDER_BUFFER_LAYER_BULLETS
    mClearRenderBuffer RENDER_BUFFER_LAYER_FINALE

    ; Bullets
    movzx ecx, gameBulletCurrentAmount
    cmp ecx, 0
    je mMainGameTurn_GameStateGameMap_BulletsEnd
    xor edx, edx
mMainGameTurn_GameStateGameMap_Bullets:
    INVOKE BulletMove,
        ADDR gameBulletList[edx],
        ADDR gameMapRecord,
        ADDR gameBulletCurrentAmount,
        ADDR gameBulletList,
        ADDR gamePlayerTank, 
        ADDR gameEnemyTankList, 
        ADDR gameEnemyTankCurrentAmount
    add edx, BULLET
    loop mMainGameTurn_GameStateGameMap_Bullets

mMainGameTurn_GameStateGameMap_BulletsEnd:

    ; Player tank
    ; FIXME: Interval time?
    call ReadKey
    jz mMainGameTurn_GameStateGameMap_EndPlayerKeyDetect
    .IF ax == 3920h  ; SPACE
        INVOKE NewBullet,
            ADDR gamePlayerTank,
            ADDR gameBulletCurrentAmount,
            ADDR gameBulletList,
            ADDR gameMapRecord
    .ENDIF

mMainGameTurn_GameStateGameMap_EndPlayerKeyDetect:
    INVOKE MoveTank,
        stdOutputHandle,
        ADDR gamePlayerTank,
        ADDR gameMapRecord,
        ax,
        ADDR trashBus

    ; Enemy tank
    ; FIXME: Enemys' bullets?
    movzx ecx, gameEnemyTankCurrentAmount
    cmp ecx, 0
    je mMainGameTurn_GameStateGameMap_EnemyTanksEnd
    xor edx, edx
mMainGameTurn_GameStateGameMap_EnemyTanks:
    INVOKE GetDirection, ADDR gameEnemyTankList[edx], ADDR gamePlayerTank
    INVOKE ComputerTankMove, stdOutputHandle, ADDR gameEnemyTankList[edx], ADDR trashBus
    add edx, TANK
    loop mMainGameTurn_GameStateGameMap_EnemyTanks
mMainGameTurn_GameStateGameMap_EnemyTanksEnd:

    ; Render
    INVOKE IntegrateRenderBufferFinaleAllDiscardable
    INVOKE RenderDiscardable, RENDER_BUFFER_LAYER_FINALE

    ; Check ending conditions
    movzx edx, gamePlayerTank.hp
    .IF edx <= 0
        mov gameWinner, ROLE_ENEMY
        mov gameState, GAME_STATE_END
        mMainGameTurn_GameStateEnd_Pre
        jmp mMainGameTurn_GameStateGameMap_EndTurn
    .ENDIF
    movzx edx, gameEnemyTankCurrentAmount
    .IF edx == 0
        mov gameWinner, ROLE_PLAYER
        mov gameState, GAME_STATE_END
        mMainGameTurn_GameStateEnd_Pre
        jmp mMainGameTurn_GameStateGameMap_EndTurn
    .ENDIF

mMainGameTurn_GameStateGameMap_EndTurn:
    mov eax, TRUE
ENDM

;; mMainGameTurn_GameStateEnd_Pre
mMainGameTurn_GameStateEnd_Pre MACRO
    movzx edx, gameWinner
    .IF edx == ROLE_PLAYER
        ; TODO: Player wins
    .ELSE
        ; TODO: Enemy wins
    .ENDIF
ENDM

;; mMainGameTurn_GameStateEnd
;; FIXME: Ending
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
