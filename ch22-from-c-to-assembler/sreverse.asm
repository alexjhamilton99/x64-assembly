; sreverse.asm
section .data
section .bss
section .text

global sreverse
sreverse:
    push    rbp
    mov     rbp, rsp
    
pushing:
    mov     rcx, rsi
    mov     rbx, rdi
    mov     r12, 0
    
    pushloop:
        mov     rax, qword [rbx+r12]
        push    rax
        inc     r12
        loop    pushloop
        
popping:
    mov     rcx, rsi
    mov     rbx, rdi
    mov     r12, 0
        
    poploop:
        pop     rax
        mov     byte [rbx+r12], al
        inc     r12
        loop    poploop
        
    mov     rax, rdi
    
    leave
    ret    