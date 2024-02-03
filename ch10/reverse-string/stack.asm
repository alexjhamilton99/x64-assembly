; stack.asm
extern printf
section .data
    strng     db    "ABCDE",0
    strngLen  equ   $ - strng-1                       ; str length without 0
    fmt1    db      "The original string: %s",10,0
    fmt2    db      "The reversed string: %s",10,0
section .bss
section .text
    global main
main:
    push    rbp
    mov     rbp, rsp
    
    ; print original string
    mov     rdi, fmt1
    mov     rsi, strng
    mov     rax, 0
    call    printf
    
    xor     rax, rax
    mov     rbx, strng
    mov     rcx, strngLen
    mov     r12, 0              ; use r12 as pointer
    
pushloop:
    ; push char per char on the stack
    mov     al, byte [rbx+r12]  ; move char into rax
    push    rax
    inc     r12                 ; increment char pointer
    loop    pushloop            ; continue loop
    
    ; pop the string char per char from the stack
    ; this reverses the original string
    mov     rbx, strng
    mov     rcx, strngLen
    mov     r12, 0              ; use r12 as pointer
    
poploop:
    pop     rax                 ; pop one char from the stack
    mov     byte [rbx+r12], al  ; move popped char into strng
    inc     r12
    loop    poploop
    
    mov     byte [rbx+r12],0    ; terminate string with 0
    
    ; print reversed string
    mov     rdi, fmt2
    mov     rsi, strng
    mov     rax, 0
    call    printf
    
    mov     rsp, rbp
    pop     rbp
    ret
    
    
    
    mov     rsp, rbp
    pop     rbp
    ret