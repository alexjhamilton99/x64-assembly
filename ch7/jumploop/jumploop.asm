; jumploop.asm
extern printf
section .data
    number      dq      1000000000
    fmt         db      "The sum from 0 to %ld is %ld",10,0
section .bss
section .text
    global main
main:
    push    rbp
    mov     rbp,rsp
    mov     rbx,0       ; counter is in rbx
    mov     rax,0       ; sum is in rax
jloop:
    add     rax,rbx
    inc     rbx
    cmp     rbx,[number]    ; is number reached?
    jle     jloop           ; number not yet reached then restart loop
    ; number reached then continue below
    mov     rdi,fmt         ; prepare for displaying
    mov     rsi,[number]
    mov     rdx,rax
    mov     rax,0
    call    printf
    mov     rsp,rbp
    pop     rbp
    ret