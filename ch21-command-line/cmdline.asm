; cmdline.asm
extern printf
section .data
    msg     db      "The command and arguments: ",10,0
    fmt     db      "%s",10,0
section .bss
section .text
    global main
main:
    push    rbp
    mov     rbp, rsp
    
    mov     r12, rdi        ; number of args
    mov     r13, rsi        ; arg array address
    
    mov     rdi, msg
    call    printf
    mov     r14, 0
    
ploop:  ; loops through the array and prints the elements (cmd line args)
    mov     rdi, fmt
    mov     rsi, qword [r13+r14*8]
    call    printf
    
    inc     r14
    cmp     r14, r12        ; is number of args reached
    jl      ploop
    
    leave
    ret
