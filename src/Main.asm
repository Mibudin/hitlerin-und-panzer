TITLE Main (Main.asm)

; ========
; = Main =
; ========

; The main program file of this project.


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

    call Clrscr
    INVOKE ClearRenderBuffer, 0

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
MainGameTurn PROC USES ebx
    ; Initialization
    ; call Clrscr
    ; call ClearRenderBuffer

    ; The game states
    .IF     gameState == GAME_STATE_TEST
        INVOKE ClearRenderBuffer, 3

        ; mov ebx, gameTickCount
        ; INVOKE SetRenderBuffer, bl, bx
        INVOKE PushRenderBufferImageDiscardable, 3, ADDR testImage, testPosition
        add testPosition.x, 7

        INVOKE RenderDiscardable, 3

        mov eax, TRUE

        jmp MainGameTurn_PostProcess

    .ELSEIF gameState == GAME_STATE_INIT
        jmp MainGameTurn_PostProcess

    .ELSEIF gameState == GAME_STATE_INTRO_SCREEN
        jmp MainGameTurn_PostProcess

    .ELSEIF gameState == GAME_STATE_START_MENU
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
