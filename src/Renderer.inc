TITLE Renderer (Renderer.inc)

; ============
; = Renderer =
; ============

; The major rendering part of the game

GetRenderBufferIndex PROTO,
    position:COORD

CoverRenderBuffer PROTO,
    renderBuffer:PTR RENDER_BUFFER

Render PROTO
