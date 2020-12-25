TITLE Renderer (Renderer.inc)

; ============
; = Renderer =
; ============

; The major rendering part of the game


GetRenderBufferIndex PROTO,
    position:COORD

GetRenderBufferCoord PROTO,
    index:WORD,
    position:PTR COORD

CoverRenderBuffer PROTO,
    renderBuffer:PTR RENDER_BUFFER

SetRenderBuffer PROTO,
    characterValue:BYTE,
    attributeValue:WORD

ClearRenderBuffer PROTO

PushRenderBufferImage PROTO,
    cmdImage:PTR CMD_IMAGE,
    position:COORD

PushRenderBufferImageDiscardable PROTO,
    cmdImage:PTR CMD_IMAGE,
    position:COORD

Render PROTO

RenderDiscardable PROTO
