!to "main.prg", cbm
* = $801
; This will auto run the program by calling sys2068
!byte $0c,$08,$0a,$00 ; load from drive 8
!byte $9e ; sys 
!text "2068" ; execute command sys2068

*=$0814 ; Assigns program to 2068
; References: 
; - https://sta.c64.org/cbm64petkey.html
; - https://sta.c64.org/cbm64krnfunc.html
; - https://technocoma.blogspot.com/p/understanding-6502-assembly-on_63.html
; TODO: Backspace
; TODO: Read string when press enter.

BYTEC = $033f
CHROUT = $ffd2  ; KERNAL fn to print to out
SCNKEY = $ff9f  ; KERNAL fn to scan keyboard for keypress
GETIN = $ffe4   ; KERNAL fn to get input from buffer and store it in A
; our code starts here
main
    jsr clear_screen
    jsr init_text
    rts

clear_screen 
    lda #$93        ; Load clear character
    jsr CHROUT      ; CHROUT - Write register A

init_text   
    ldx #$00        ; Clear X
    stx $cc         ; Activate Blinking Cursor

show_text   
    lda line1,x     ; Load line1 label to A, at position X
    jsr CHROUT      ; Print x to CHROUT
    inx             ; Increment x
    cpx #$28        ; Check if X == 40 (28 in hex)
    bne show_text   ; if false, branch to start of show_text

get_input
    stx BYTEC       ; Store keystrokes to x
    jsr SCNKEY      ; Scan keyboard
    jsr GETIN       ; Save input char to A
    cmp #$04        ; Pressed Ctrl+D
    beq epilogue    ; Jumps to epilogue label if above is true
    cmp #$41        ; Compare value with value referring to char A
    bcc get_input   ; If referring to char before A, continue loop
    cmp #$5B        ; Compare valuew with value referring to char Z
    bcc show_input  ; If referring to char before after Z, display.
    jmp get_input

show_input
    jsr CHROUT
    jmp get_input

epilogue
    rts

line1       
    !pet "what is your name?                        " ; need to be 40
