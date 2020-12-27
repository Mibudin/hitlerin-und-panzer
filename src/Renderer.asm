TITLE Renderer (Renderer.asm)

; ============
; = Renderer =
; ============

; The major rendering part of the game


;; InitRenderer
InitRenderer PROC USES ecx
    call Clrscr

    mov ecx, RENDER_BUFFER_LAYERS
InitRenderer_ClearRenderBufferLayersAll:
    dec ecx
    INVOKE ClearRenderBuffer, ecx
    cmp ecx, 0
    jbe InitRenderer_ClearRenderBufferLayersAll

    INVOKE SetConsoleCursorInfo, stdOutputHandle, ADDR stdConsoleCursorInfo

    ret
InitRenderer ENDP

;; mGetCutSizeAxis
mGetCutSizeAxis MACRO regWord, innerPositionAxisWord, innerSizeAxisWord, outerLimitAxisWord
    mov regWord, innerSizeAxisWord
    add regWord, innerPositionAxisWord
    .IF regWord <= outerLimitAxisWord
        mov regWord, innerSizeAxisWord
    .ELSE
        mov regWord, innerPositionAxisWord
        .IF regWord < outerLimitAxisWord
            mov regWord, outerLimitAxisWord
            sub regWord, innerPositionAxisWord
        .ELSE
            xor regWord, regWord
        .ENDIF
    .ENDIF
ENDM

;; GetCutSize
GetCutSize PROC USES ax edi,
    innerPosition:COORD,
    innerSize:COORD,
    outerlimit:COORD,
    renderSize:PTR COORD

    mov edi, renderSize

    mGetCutSizeAxis ax, innerPosition.x, innerSize.x, outerlimit.x
    mov (COORD PTR[edi]).x, ax
    mGetCutSizeAxis ax, innerPosition.y, innerSize.y, outerlimit.y
    mov (COORD PTR[edi]).y, ax

    ret
GetCutSize ENDP

;; mGetRenderBufferLayerIndex
mGetRenderBufferLayerIndex MACRO regDWord, layerDWord
    ; reg = layer * 3 * 2 ^ 12

    mov regDWord, layerDWord

    ; * 3
    shl regDWord, 1
    inc regDWord

    ; * 1000h
    shl regDWord, 12
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
CoverRenderBuffer PROC USES eax ecx esi edi,
    layer:DWORD,
    renderBuffer:PTR RENDER_BUFFER

    cld
    mGetRenderBufferLayerIndex eax, layer

    mov ecx, SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT
    lea esi, stdRenderBuffer[eax].characters
    lea edi, (RENDER_BUFFER PTR [renderBuffer]).characters
    rep movsb

    mov ecx, SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT
    lea esi, stdRenderBuffer[eax].attributes
    lea edi, (RENDER_BUFFER PTR [renderBuffer]).attributes
    rep movsw

    ret
CoverRenderBuffer ENDP

;; SetRenderBuffer
SetRenderBuffer PROC USES ax ebx ecx edi,
    layer:DWORD,
    characterValue:BYTE,
    attributeValue:WORD

    cld
    mGetRenderBufferLayerIndex ebx, layer

    mov al, characterValue
    mov ecx, SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT
    lea edi, stdRenderBuffer[ebx].characters
    rep stosb

    mov ax, attributeValue
    mov ecx, SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT
    lea edi, stdRenderBuffer[ebx].attributes
    rep stosw

    ret
SetRenderBuffer ENDP

;; ClearRenderBuffer
ClearRenderBuffer PROC,
    layer:DWORD

    INVOKE SetRenderBuffer, layer, RENDER_BUFFER_CLEAR_CHAR, RENDER_BUFFER_CLEAR_ATTR

    ret
ClearRenderBuffer ENDP

;; BlankRenderBuffer
BlankRenderBuffer PROC,
    layer:DWORD

    INVOKE SetRenderBuffer, layer, RENDER_BUFFER_BLANK_CHAR, RENDER_BUFFER_BLANK_ATTR

    ret
BlankRenderBuffer ENDP

;; PushRenderBufferImage
;; TODO: Improvement?
PushRenderBufferImage PROC USES eax ebx ecx edx esi edi,
    layer:DWORD,
    cmdImage:PTR CMD_IMAGE,
    position:COORD
    LOCAL renderSize:COORD

    cld
    mov edx, cmdImage

    INVOKE GetCutSize,
        position,
        (CMD_IMAGE PTR [edx]).imageSize,
        screenBufferSize,
        ADDR renderSize
    .IF renderSize.x <= 0 || renderSize.y <= 0
        jmp PushRenderBufferImage_AllDiscard
    .ENDIF

    INVOKE GetRenderBufferIndex, position
    movzx eax, ax
    xor ebx, ebx
    movzx ecx, renderSize.y
PushRenderBufferImage_ColumnLoop:
    push ecx

    mGetRenderBufferLayerIndex ecx, layer
    lea esi, (CMD_IMAGE PTR [edx]).characters[ebx]
    lea edi, stdRenderBuffer[ecx].characters[eax]
    movzx ecx, renderSize.x
    rep movsb

    shl ebx, 1
    shl eax, 1
    mGetRenderBufferLayerIndex ecx, layer
    lea esi, (CMD_IMAGE PTR [edx]).attributes[ebx]
    lea edi, stdRenderBuffer[ecx].attributes[eax]
    movzx ecx, renderSize.x
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
    layer:DWORD,
    cmdImage:PTR CMD_IMAGE,
    position:COORD
    LOCAL renderSize:COORD

    mov esi, cmdImage
    mGetRenderBufferLayerIndex edi, layer

    INVOKE GetCutSize,
        position,
        (CMD_IMAGE PTR [esi]).imageSize,
        screenBufferSize,
        ADDR renderSize
    .IF renderSize.x <= 0 || renderSize.y <= 0
        jmp PushRenderBufferImageDiscardable_AllDiscard
    .ENDIF

    INVOKE GetRenderBufferIndex, position
    movzx eax, ax
    xor ebx, ebx
    movzx ecx, renderSize.y
PushRenderBufferImageDiscardable_ColumnLoop:
    push ecx
    movzx ecx, renderSize.x

PushRenderBufferImageDiscardable_ColumnLoop_OneCell:
    mov dl, (CMD_IMAGE PTR [esi]).characters[ebx]
    .IF BYTE PTR [esi] == RENDER_BUFFER_DISCARD
        loop PushRenderBufferImageDiscardable_ColumnLoop_OneCell_Discard
    .ENDIF
    mov BYTE PTR stdRenderBuffer[edi].characters[eax], dl

    shl ebx, 1
    shl eax, 1
    mov dx, (CMD_IMAGE PTR [esi]).attributes[ebx]
    mov WORD PTR stdRenderBuffer[edi].attributes[eax], dx
    shr ebx, 1
    shr eax, 1

PushRenderBufferImageDiscardable_ColumnLoop_OneCell_Discard:
    inc ebx
    inc eax
    loop PushRenderBufferImageDiscardable_ColumnLoop_OneCell

    add eax, SCREEN_BUFFER_WIDTH
    movzx edx, renderSize.x
    sub eax, edx

    pop ecx
    loop PushRenderBufferImageDiscardable_ColumnLoop

PushRenderBufferImageDiscardable_AllDiscard:
    ret
PushRenderBufferImageDiscardable ENDP

;; Render
Render PROC USES eax ecx edx,
    layer:DWORD
    LOCAL outputCount:DWORD

    mGetRenderBufferLayerIndex edx, layer
    INVOKE WriteConsoleOutputCharacter,
        stdOutputHandle,
        ADDR stdRenderBuffer[edx].characters,
        SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT,
        stdRenderOrigin,
        ADDR outputCount

    mGetRenderBufferLayerIndex edx, layer
    INVOKE WriteConsoleOutputAttribute,
        stdOutputHandle,
        ADDR stdRenderBuffer[edx].attributes,
        SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT,
        stdRenderOrigin,
        ADDR outputCount

    ret
Render ENDP

;; RenderDiscardable
;; TODO: Improve?
RenderDiscardable PROC USES eax ebx ecx edx esi edi,
    layer:DWORD
    LOCAL outputCount:DWORD,
          renderStart:COORD

    cld
    mGetRenderBufferLayerIndex eax, layer
    mov ecx, SCREEN_BUFFER_WIDTH * SCREEN_BUFFER_HEIGHT
    lea esi, stdRenderBuffer[eax].characters
    lea edx, stdRenderBuffer[eax].attributes
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
