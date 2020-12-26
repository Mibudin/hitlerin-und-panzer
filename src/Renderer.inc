TITLE Renderer (Renderer.inc)

; ============
; = Renderer =
; ============

; The major rendering part of the game


; mGetCutSizeAxis MACRO
;     regWord,
;     innerPositionAxisWord,
;     innerSizeAxisWord,
;     outerLimitAxisWord

GetCutSize PROTO,
    innerPosition:COORD,
    innerSize:COORD,
    outerlimit:COORD,
    renderSize:PTR COORD

; mGetRenderBufferLayerIndex MACRO
;     regDWord,
;     layerDWord

GetRenderBufferIndex PROTO,
    position:COORD

GetRenderBufferCoord PROTO,
    index:WORD,
    position:PTR COORD

CoverRenderBuffer PROTO,
    layer:DWORD,
    renderBuffer:PTR RENDER_BUFFER

SetRenderBuffer PROTO,
    layer:DWORD,
    characterValue:BYTE,
    attributeValue:WORD

ClearRenderBuffer PROTO,
    layer:DWORD

BlankRenderBuffer PROTO,
    layer:DWORD

PushRenderBufferImage PROTO,
    layer:DWORD,
    cmdImage:PTR CMD_IMAGE,
    position:COORD

PushRenderBufferImageDiscardable PROTO,
    layer:DWORD,
    cmdImage:PTR CMD_IMAGE,
    position:COORD

Render PROTO,
    layer:DWORD

RenderDiscardable PROTO,
    layer:DWORD
