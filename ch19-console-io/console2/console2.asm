; console2.asm
section .data
    msg1        db      "Hello, World!",10,0
    msg2        db      "Your turn (only a-z): ",0
    msg3        db      "You answered: ",0
    inputlen    equ     10
    NL          db      0xa
section .bss
    input       resb    inputlen+1      ; space for ending 0
section .text
    global main
main:
    push    rbp
    mov     rbp, rsp
    
    mov     rdi, msg1
    call    prints
    
    mov     rdi, msg2
    call    prints
    
    mov     rdi, input
    mov     rsi, inputlen
    call    reads
    
    mov     rdi, msg3
    call    prints
    
    mov     rdi, input
    call    prints
    mov     rdi, NL
    call    prints
    
    leave
    ret

prints:
    push    rbp
    mov     rbp, rsp
    
    push    r12         ; save callee
    
    ; count characters
    xor     rdx, rdx    ; length in rdx
    mov     r12, rdi
    
.lengthloop:
    cmp     byte [r12], 0
    je      .lengthfound
    
    inc     rdx
    inc     r12
    jmp     .lengthloop
    
.lengthfound:           ; print strin
    cmp     rdx, 0
    je      .done
    
    mov     rsi, rdi    ; rdi contains string's address
    mov     rax, 1      ; 1 = write
    mov     rdi, 1      ; 1 = stdout
    syscall
    
.done:
    pop     r12
    
    leave
    ret
    
reads:
section .data
section .bss
    .inputchar  resb    1
section .text
    push    rbp
    mov     rbp, rsp
    
    push    r12         ; callee saved
    push    r13         ; callee saved
    push    r14         ; callee saved
    
    mov     r12, rdi    ; input buffer's address
    mov     r13, rsi    ; max len in r13
    xor     r14, r14    ; character counter
    
.readc:
    mov     rax, 0              ; read
    mov     rdi, 1              ; stdin
    lea     rsi, [.inputchar]   ; input's address
    mov     rdx, 1              ; # of characters to read
    syscall
    
    mov     al, [.inputchar]
    cmp     al, byte [NL]       ; is it a new line char?
    je      .done
    
    cmp     al, 97              ; 97 is a's ASCII code
    jl      .readc              ; if lower, ignore it
    
    cmp     al, 122             ; 122 is z's ASCII code
    jg      .readc              ; if higher, ignore it
    
    inc     r14                 ; increment counter
    cmp     r14, r13
    ja      .readc              ; reached buffer's max
    
    mov     byte [r12], al      ; safe char in buffer
    inc     r12                 ; point to next char in buffer
    jmp     .readc
    
.done:  
    inc     r12
    mov     byte [r12], 0       ; add ending 0 to input buffer
    
    pop     r14                 ; callee saved
    pop     r13                 ; callee saved
    pop     r12                 ; callee saved
    
    leave
    ret