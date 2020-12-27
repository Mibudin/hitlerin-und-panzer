TITLE Main (Main.asm)

; ========
; = Main =
; ========

; The main program file of this project


;; Main
;; TODO:
Main PROC
    call MainGameInit

    call MainGameLoop

    call MainGameExit

    INVOKE ExitProcess, 0
    exit
Main ENDP

;; MainGameInit
MainGameInit PROC
    call InitGame
    call InitRenderer

    mov gameState, GAME_STATE_START

    ret
MainGameInit ENDP

;; MainGameLoop
MainGameLoop PROC USES eax ebx ecx
    xor ebx, ebx

MainGameLoop_Loop:
    call GetTickCount
    mov gameTickCount, eax
    mov ecx, eax
    sub ecx, ebx
    cmp ecx, MAIN_GAME_TURN_INTERVAL
    jb MainGameLoop_Loop
    mov ebx, eax

    call MainGameTurn
    ; mov eax, TRUE
    cmp eax, TRUE
    je MainGameLoop_Loop

    ret
MainGameLoop ENDP

;; MainGameTurn
;; ; TODO:
;; Returns:
;;     EAX: Whether to continue the main game loop
;;          1: True; 0: False
MainGameTurn PROC
    ; Initialization
    ; call Clrscr
    ; call ClearRenderBuffer

    ; The game states
    .IF     gameState == GAME_STATE_TEST
        mMainGameTurn_GameStateTest

        jmp MainGameTurn_PostProcess

    .ELSEIF gameState == GAME_STATE_START
        mMainGameTurn_GameStateStart

        jmp MainGameTurn_PostProcess

    .ELSEIF gameState == GAME_STATE_GAME_MAP
        mMainGameTurn_GameStateGameMap

        jmp MainGameTurn_PostProcess

    .ELSEIF gameState == GAME_STATE_END
        mMainGameTurn_GameStateEnd

        jmp MainGameTurn_PostProcess

    .ENDIF

MainGameTurn_PostProcess:
    ; call Render

MainGameTurn_End:
    ret
MainGameTurn ENDP

;; MainGameExit
MainGameExit PROC
    ; TODO:

    ret
MainGameExit ENDP
