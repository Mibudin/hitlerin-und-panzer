TITLE HomePage (HomePage.asm)

; ============
; = HomePage =
; ============

; (Obsolete)
; The main handler of the home page


;; Home
Home PROC USES eax edx
Home_Begin:
    ; INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    ; mov consoleHandle, eax
    call Clrscr
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    mov edx, OFFSET StartS
    call WriteString
    call Crlf
    call Crlf
    mov edx, OFFSET RuleS
    call WriteString
    call Crlf
    call Crlf
    mov edx, OFFSET MemberS
    call WriteString
    call Crlf
    call ReadChar
    .IF ax == 3920h  ; SPACE
        ; call Main
        ret
    .ENDIF
    .IF ax == 1372h  ; R
        call Rule
        jmp Home_Begin
    .ENDIF
    .IF ax == 326Dh  ; M
        call Member
        jmp Home_Begin
    .ENDIF
    ; call Home
    jmp Home_Begin
Home ENDP

;; Rule
Rule PROC USES eax edx
Rule_Begin:
    ; INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    ; mov consoleHandle, eax
    call Clrscr
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    mov edx, OFFSET GameRuleS1_1
    call WriteString
    call Crlf
    mov edx, OFFSET GameRuleS1_2
    call WriteString
    call Crlf
    mov edx, OFFSET GameRuleS1_3
    call WriteString
    call Crlf
    mov edx, OFFSET GameRuleS1_4
    call WriteString
    call Crlf
    mov edx, OFFSET GameRuleS1_5
    call WriteString
    call Crlf
    call Crlf
    mov edx, OFFSET GameRuleS2_1
    call WriteString
    call Crlf
    mov edx, OFFSET GameRuleS2_2
    call WriteString
    call Crlf
    mov edx, OFFSET GameRuleS2_3
    call WriteString
    call Crlf
    mov edx, OFFSET GameRuleS2_4
    call WriteString
    call Crlf
    call Crlf
    mov edx, OFFSET GameRuleS3_1
    call WriteString
    call Crlf
    mov edx, OFFSET GameRuleS3_2
    call WriteString
    call Crlf
    call Crlf
    mov edx, OFFSET GameRuleS4_1
    call WriteString
    call Crlf
    mov edx, OFFSET GameRuleS4_2
    call WriteString
    call Crlf
    call Crlf
    mov edx, OFFSET CloseRS
    call WriteString
    call Crlf
    call ReadChar
    .IF ax == 2D78h  ; X
        ; call Home
        ret
    .ENDIF
    ; call Rule
    jmp Rule_Begin
Rule ENDP

;; Member
Member PROC USES eax edx
Member_Begin:
    ; INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    ; mov consoleHandle, eax
    call Clrscr
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    mov edx, OFFSET MemberListS1
    call WriteString
    call Crlf
    call Crlf
    mov edx, OFFSET MemberListS2
    call WriteString
    call Crlf
    call Crlf
    mov edx, OFFSET MemberListS3
    call WriteString
    call Crlf
    call Crlf
    mov edx, OFFSET MemberListS4
    call WriteString
    call Crlf
    call Crlf
    mov edx, OFFSET CloseMS
    call WriteString
    call Crlf
    call ReadChar
    .IF ax == 2D78h  ; X
        ; call Home
        ret
    .ENDIF
    ; call Member
    jmp Member_Begin
Member ENDP
