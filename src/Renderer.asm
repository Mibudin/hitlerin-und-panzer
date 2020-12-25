TITLE Renderer (Renderer.asm)

; ============
; = Renderer =
; ============

; The major rendering part of the game

;; mGetCutSizeAxis
;; Inner Regs:
;;     AX
mGetCutSizeAxis MACRO positionAxisWord, sizeAxisWord, limitAxisWord
    mov ax, sizeAxisWord
    add ax, positionAxisWord
    .IF ax <= limitAxisWord
        mov ax, sizeAxisWord
    .ELSEIF positionAxisWord < limitAxisWord
        mov ax, SCREEN_BUFFER_WIDTH
        sub ax, positionAxisWord
    .ELSE
        xor ax, ax
    .ENDIF
ENDM


;; GetRenderBufferIndex
;; To find the corresponging index to a coordinate of the render buffer
;; Parameters:
;;     position:COORD: The coordination to be caculated
;; Returns:
;;     AX: The corresponging index of the render buffer
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

;; PushRenderBufferImage
;; TODO: Improvement?
PushRenderBufferImage PROC USES eax ebx ecx edx esi edi,
    cmdImage:PTR CMD_IMAGE,
    position:COORD
    LOCAL renderSize:COORD

    cld
    mov edx, cmdImage

    mGetCutSizeAxis position.x, (CMD_IMAGE PTR [edx]).imageSize.x, SCREEN_BUFFER_WIDTH
    mov renderSize.x, ax
    mGetCutSizeAxis position.y, (CMD_IMAGE PTR [edx]).imageSize.y, SCREEN_BUFFER_HEIGHT
    mov renderSize.y, ax
    .IF renderSize.x <= 0 || renderSize.y <= 0
        jmp PushRenderBufferImage_AllDiscard
    .ENDIF

    INVOKE GetRenderBufferIndex, position
    movzx eax, ax
    xor ebx, ebx
    movzx ecx, renderSize.y
PushRenderBufferImage_ColumnLoop:
    push ecx

    movzx ecx, renderSize.x
    lea esi, (CMD_IMAGE PTR [edx]).characters[ebx]
    lea edi, stdRenderBuffer.characters[eax]
    rep movsb

    shl ebx, 1
    shl eax, 1
    movzx ecx, renderSize.x
    lea esi, (CMD_IMAGE PTR [edx]).attributes[ebx]
    lea edi, stdRenderBuffer.attributes[eax]
    rep movsw
    shr ebx, 1
    shr eax, 1

    add eax, SCREEN_BUFFER_WIDTH
    add bx, (CMD_IMAGE PTR [edx]).imageSize.x

    pop ecx
    loop PushRenderBufferImage_ColumnLoop

PushRenderBufferImage_AllDiscard:
    ret
PushRenderBufferImage ENDP

;; PushRenderBufferImageDiscardable
;; TODO: Improvement? Check correctness?
PushRenderBufferImageDiscardable PROC USES eax ebx ecx edx esi edi,
    cmdImage:PTR CMD_IMAGE,
    position:COORD
    LOCAL renderSize:COORD

    cld
    mov esi, cmdImage

    mGetCutSizeAxis position.x, (CMD_IMAGE PTR [esi]).imageSize.x, SCREEN_BUFFER_WIDTH
    mov renderSize.x, ax
    mGetCutSizeAxis position.y, (CMD_IMAGE PTR [esi]).imageSize.y, SCREEN_BUFFER_HEIGHT
    mov renderSize.y, ax
    .IF renderSize.x <= 0 || renderSize.y <= 0
        jmp PushRenderBufferImageDiscardable_AllDiscard
    .ENDIF

    INVOKE GetRenderBufferIndex, position
    movzx eax, ax
    xor ebx, ebx
    movzx ecx, renderSize.y
PushRenderBufferImageDiscardable_ColumnLoop:
    mov edi, ecx
    movzx ecx, renderSize.x
PushRenderBufferImageDiscardable_ColumnLoop_OneCell:

    mov dl, (CMD_IMAGE PTR [esi]).characters[ebx]
    .IF BYTE PTR [esi] == RENDER_BUFFER_DISCARD
        loop PushRenderBufferImageDiscardable_ColumnLoop_OneCell_Discard
    .ENDIF
    mov BYTE PTR stdRenderBuffer.characters[eax], dl

    shl ebx, 1
    shl eax, 1
    mov dx, (CMD_IMAGE PTR [esi]).attributes[ebx]
    mov WORD PTR stdRenderBuffer.attributes[eax], dx
    shr ebx, 1
    shr eax, 1

PushRenderBufferImageDiscardable_ColumnLoop_OneCell_Discard:
    inc ebx
    inc eax
    loop PushRenderBufferImageDiscardable_ColumnLoop_OneCell

    add eax, SCREEN_BUFFER_WIDTH
    movzx edx, renderSize.x
    sub eax, edx

    mov ecx, edi
    loop PushRenderBufferImageDiscardable_ColumnLoop

PushRenderBufferImageDiscardable_AllDiscard:
    ret
PushRenderBufferImageDiscardable ENDP

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
