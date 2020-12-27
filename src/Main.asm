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
MainGameTurn PROC USES ebx edx
    ; Initialization
    ; call Clrscr
    ; call ClearRenderBuffer

    ; The game states
    .IF     gameState == GAME_STATE_TEST
        mClearRenderBuffer RENDER_BUFFER_LAYER_TANKS

        call ReadKey
        INVOKE MoveTank, stdOutputHandle, ADDR testTank, ax, ADDR trashBus

        INVOKE RenderDiscardable, RENDER_BUFFER_LAYER_TANKS

        mov eax, TRUE

        jmp MainGameTurn_PostProcess

    .ELSEIF gameState == GAME_STATE_START
        jmp MainGameTurn_PostProcess

    .ELSEIF gameState == GAME_STATE_GAME_MAP
        jmp MainGameTurn_PostProcess

    .ELSEIF gameState == GAME_STATE_END
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
