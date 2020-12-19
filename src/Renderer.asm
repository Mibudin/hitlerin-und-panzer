TITLE Renderer (Renderer.asm)

; ============
; = Renderer =
; ============

; The major rendering part of the game


;;  GetRenderBufferIndex
;;  To find the corresponging index to a coordinate of the render buffer
;;  Parameters:
;;      position:COORD: The coordination to be caculated
;;  Returns:
;;       AX: The corresponging index of the render buffer
GetRenderBufferIndex PROC,
    position:COORD

    ; position.y * SCREEN_BUFFER_WIDTH + position.x

    ; In default
    ; SCREEN_BUFFER_WIDTH  = 128 = 2^7
    ; SCREEN_BUFFER_HEIGHT =  32 = 2^5

    movzx eax, position.y
    shl ax, 7
    add ax, position.x

    ret
GetRenderBufferIndex ENDP

;; GetRenderBufferCoord
GetRenderBufferCoord PROC USES ax cx,
    index:WORD,
    position:PTR COORD

    mov ax, index
    mov cl, SCREEN_BUFFER_WIDTH
    div cl

    movzx cx, ah
    movzx ax, al

    mov (COORD PTR [position]).x, cx
    mov (COORD PTR [position]).y, ax

    ret
GetRenderBufferCoord ENDP

;; CoverRenderBuffer
CoverRenderBuffer PROC USES ecx esi edi,
    renderBuffer:PTR RENDER_BUFFER

    cld

    mov ecx, SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT
    lea esi, stdRenderBuffer.characters
    lea edi, (RENDER_BUFFER PTR [renderBuffer]).characters
    rep movsb

    mov ecx, SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT
    lea esi, stdRenderBuffer.attributes
    lea edi, (RENDER_BUFFER PTR [renderBuffer]).attributes
    rep movsw

    ret
CoverRenderBuffer ENDP

;; ClearRenderBuffer
ClearRenderBuffer PROC USES ax ecx edi
    cld
    mov ax, 49

    mov ecx, SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT
    mov edi, OFFSET stdRenderBuffer.characters
    rep stosb

    mov ecx, SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT
    mov edi, OFFSET stdRenderBuffer.attributes
    rep stosw

    ret
ClearRenderBuffer ENDP

;; Render
Render PROC USES eax
    LOCAL outputCount:DWORD

    INVOKE WriteConsoleOutputCharacter,
        stdOutputHandle,
        ADDR stdRenderBuffer.characters,
        SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT,
        stdRenderOrigin,
        ADDR outputCount

    INVOKE WriteConsoleOutputAttribute,
        stdOutputHandle,
        ADDR stdRenderBuffer.attributes,
        SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT,
        stdRenderOrigin,
        ADDR outputCount

    ret
Render ENDP

;; RenderDiscardable
RenderDiscardable PROC USES eax ebx ecx edx esi edi
    LOCAL outputCount:DWORD
    LOCAL renderStart:COORD

    cld
    mov ecx, SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT
    mov esi, OFFSET stdRenderBuffer.characters
    mov edx, OFFSET stdRenderBuffer.attributes
    xor ebx, ebx
    xor edi, edi

RenderDiscardable_ScanAll:
    mov al, RENDER_DISCARD

    add esi, edi
    add edx, edi
    add ebx, edi
    mov edi, esi

    repne scasb
    jnz RenderDiscardable_End
    sub edi, 2
RenderDiscardable_End:
    sub edi, esi

    ; TODO:
    INVOKE GetRenderBufferCoord, bx, ADDR renderStart

    INVOKE WriteConsoleOutputCharacter,
        stdOutputHandle,
        esi,
        edi,
        renderStart,
        ADDR outputCount
    
   INVOKE WriteConsoleOutputAttribute,
        stdOutputHandle,
        edx,
        edi,
        renderStart,
        ADDR outputCount

    inc ecx
    add edi, 2
    loop RenderDiscardable_ScanAll

    ret
RenderDiscardable ENDP
