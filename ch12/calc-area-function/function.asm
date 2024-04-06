; function.asm
extern printf
section .data
    radius  dq  10.0
    pi      dq  3.14
    fmt     db  "The area of the circle is %.2f",10,0
section .bss
section .text
    global main
;----------------------------------------------------------------------
main:
    push    rbp
    lea     rbp, [rsp]
    call    area            ; call area function 
    lea     rdi, fmt
    movsd   xmm1, [radius]
    mov     rax, 1
    call    printf
    leave
    ret
;----------------------------------------------------------------------
area:
    push    rbp
    lea     rbp, [rsp]
    movsd   xmm0, [radius]
    mulsd   xmm0, [radius]
    mulsd   xmm0, [pi]
    leave
    ret