TITLE Main (Main.asm)

; ========
; = Main =
; ========

; The main program file of this project.


;; Main
;; TODO:
Main PROC
    LOCAL pos:COORD

    call InitGame

    mov edx, OFFSET testString
    call WriteString

    call WaitMsg
    call Crlf

    call ClearRenderBuffer

    mov stdRenderBuffer.characters[SCREEN_BUFFER_WIDTH + 4], RENDER_BUFFER_DISCARD

    ; INVOKE Render
    INVOKE RenderDiscardable

    call WaitMsg

    exit
Main ENDP

;; MainGameLoop
MainGameLoop PROC
    ; TODO:

    ret
MainGameLoop ENDP
