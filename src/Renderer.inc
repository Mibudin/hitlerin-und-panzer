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

ClearRenderBuffer PROTO

Render PROTO

RenderDiscardable PROTO
