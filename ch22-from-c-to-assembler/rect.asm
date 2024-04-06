; rect.asm
section .data
section .bss
section .text

global rarea
rarea:
    section .text
        push    rbp
        mov     rbp, rsp
        
        mov     rax, rdi
        imul    rsi         ; multiplies the value in rsi with the value in rax
        
        leave
        ret
    
global rperim
rperim:
    section .text
        push    rbp
        mov     rbp, rsp
        
        mov     rax, rdi
        add     rax, rsi
        imul    rax, 2
        
        leave
        ret