; asum.asm
section .data
section .bss
section .text

global asum
asum:
    section .text
    
        ; calculate the sum
        mov     rcx, rsi        ; array's length
        mov     rbx, rdi        ; array's address
        mov     r12, 0
        movsd   xmm0, qword [rbx+r12*8]
        dec     rcx             ; one loop less b/c 1st element already in xmm0
        
        sloop:
            inc     r12
            addsd   xmm0, qword [rbx+r12*8]
            loop    sloop
            
        ret                     ; returns sum in xmm0