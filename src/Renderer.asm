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
;;      AX: The corresponging index of the render buffer
GetRenderBufferIndex PROC,
    position:COORD

    ; position.y * SCREEN_BUFFER_WIDTH + position.x

    ; In default
    ; SCREEN_BUFFER_WIDTH  = 128 = 2^7
    ; SCREEN_BUFFER_HEIGHT =  32 = 2^5

    mov ax, position.y
    shl ax, 7
    add ax, position.x

    ret
GetRenderBufferIndex ENDP

;; GetRenderBufferCoord
GetRenderBufferCoord PROC USES ax cx esi,
    index:WORD,
    position:PTR COORD

    ; x = index - y * SCREEN_BUFFER_WIDTH
    ; y = index / SCREEN_BUFFER_WIDTH

    ; In default
    ; SCREEN_BUFFER_WIDTH  = 128 = 2^7
    ; SCREEN_BUFFER_HEIGHT =  32 = 2^5

    mov ax, index
    and ax, 007Fh
    mov cx, index
    shr cx, 7

    mov esi, position
    mov (COORD PTR [esi]).x, ax
    mov (COORD PTR [esi]).y, cx

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

;; SetRenderBuffer
SetRenderBuffer PROC USES ax ecx edi,
    characterValue:BYTE,
    attributeValue:WORD

    cld

    mov al, characterValue
    mov ecx, SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT
    mov edi, OFFSET stdRenderBuffer.characters
    rep stosb

    mov ax, attributeValue
    mov ecx, SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT
    mov edi, OFFSET stdRenderBuffer.attributes
    rep stosw

    ret
SetRenderBuffer ENDP

;; ClearRenderBuffer
ClearRenderBuffer PROC
    INVOKE SetRenderBuffer, RENDER_BUFFER_CLEAR_CHAR, RENDER_BUFFER_CLEAR_ATTR

    ret
ClearRenderBuffer ENDP

;; Render
Render PROC USES eax ecx edx
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
;; TODO: Improve?
RenderDiscardable PROC USES eax ebx ecx edx esi edi
    LOCAL outputCount:DWORD,
          renderStart:COORD

    cld
    mov ecx, SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT
    mov esi, OFFSET stdRenderBuffer.characters
    mov edx, OFFSET stdRenderBuffer.attributes
    xor edi, edi
    xor ebx, ebx

RenderDiscardable_ScanAll:
    add esi, edi
    add ebx, edi
    shl edi, 1
    add edx, edi
    mov edi, esi

    mov al, RENDER_BUFFER_DISCARD
    repne scasb
    jnz RenderDiscardable_End
    dec edi
RenderDiscardable_End:
    sub edi, esi
    jz RenderDiscardable_Continued

    INVOKE GetRenderBufferCoord, bx, ADDR renderStart

    push ecx
    push edx
    INVOKE WriteConsoleOutputCharacter,
        stdOutputHandle,
        esi,
        edi,
        renderStart,
        ADDR outputCount
    pop edx

    push edx
    INVOKE WriteConsoleOutputAttribute,
        stdOutputHandle,
        edx,
        edi,
        renderStart,
        ADDR outputCount
    pop edx
    pop ecx

RenderDiscardable_Continued:
    inc edi
    inc ecx
    loop RenderDiscardable_ScanAll

    ret
RenderDiscardable ENDP

;; RenderImage
RenderImage PROC
    ; TODO:

    ret
RenderImage ENDP
