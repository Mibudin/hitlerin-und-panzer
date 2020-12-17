TITLE Renderer (Renderer.asm)

; ============
; = Renderer =
; ============

; The major rendering part of the game

;;  RenderBufferIndex
;;  To find the corresponging index to a coordinate of the render buffer
;;  Parameters:
;;      layer:WORD: The index of the layer
;;      position:COORD: The coordination to be caculated
;;  Returns:
;;       EAX: The corresponging index of the render buffer
RenderBufferIndex PROC USES cx,
    layer:WORD, position:COORD

    ; layer * (SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT)
    ; + position.y * SCREEN_BUFFER_WIDTH
    ; + position.x

    ; In default
    ; SCREEN_BUFFER_WIDTH  = 128 = 2^7
    ; SCREEN_BUFFER_HEIGHT =  32 = 2^5

    movzx eax, layer
    shl ax, 12

    mov cx, position.y
    shl cx, 7
    add ax, cx

    add ax, position.x

    ret
RenderBufferIndex ENDP
