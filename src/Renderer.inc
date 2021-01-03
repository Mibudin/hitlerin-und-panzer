TITLE Renderer (Renderer.inc)

; ============
; = Renderer =
; ============

; The major rendering part of the game


; ==========
; = MACROS =
; ==========

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

;; mGetRenderBufferLayerIndex
mGetRenderBufferLayerIndex MACRO regDWord, layerDWord
    ; reg = layer * 3 * 2 ^ 12

    mov regDWord, layerDWord

    ; * 3
    shl regDWord, 1
    add regDWord, layerDWord

    ; * 1000h
    shl regDWord, 12
ENDM

;; mClearRenderBuffer
mClearRenderBuffer MACRO layerDWord
    INVOKE SetRenderBuffer, layerDWord, RENDER_BUFFER_CLEAR_CHAR, RENDER_BUFFER_CLEAR_ATTR
ENDM

;; mBlankRenderBuffer
mBlankRenderBuffer MACRO layerDWord
    INVOKE SetRenderBuffer, layerDWord, RENDER_BUFFER_BLANK_CHAR, RENDER_BUFFER_BLANK_ATTR
ENDM


; ==========
; = PROTOS =
; ==========

InitRenderer PROTO

GetCutSize PROTO,
    innerPosition:COORD,
    innerSize:COORD,
    outerlimit:COORD,
    renderSize:PTR COORD

GetRenderBufferIndex PROTO,
    position:COORD

GetRenderBufferCoord PROTO,
    index:WORD,
    position:PTR COORD

CoverRenderBufferLayer PROTO,
    sourceLayer:DWORD,
    targetLayer:DWORD

CoverRenderBufferLayerDiscardable PROTO,
    sourceLayer:DWORD,
    targetLayer:DWORD

SetRenderBuffer PROTO,
    layer:DWORD,
    characterValue:BYTE,
    attributeValue:WORD

PushCmdImageCharacters PROTO,
    cmdImage:PTR CMD_IMAGE,
    cmdImageCharacters:PTR BYTE,
    characterLength:DWORD

PushCmdImageAttributes PROTO,
    cmdImage:PTR CMD_IMAGE,
    cmdImageAttributes:PTR WORD,
    attributeLength:DWORD

UpdateFlag PROTO,
    role:BYTE

UpdateFlagOnMap PROTO,
    role:BYTE

PushRenderBufferImage PROTO,
    layer:DWORD,
    cmdImage:PTR CMD_IMAGE,
    position:COORD

PushRenderBufferImageBlank PROTO,
    layer:DWORD,
    position:COORD,
    blankSize:COORD

PushRenderBufferImageDiscardable PROTO,
    layer:DWORD,
    cmdImage:PTR CMD_IMAGE,
    position:COORD

IntegrateRenderBufferFinaleAll PROTO

IntegrateRenderBufferFinaleAllDiscardable PROTO

Render PROTO,
    layer:DWORD

RenderDiscardable PROTO,
    layer:DWORD
