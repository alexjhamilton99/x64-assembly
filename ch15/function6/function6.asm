; function6.asm
extern printf
section .data
    first   db      "A"
    second  db      "B"
    third   db      "C"
    fourth  db      "D"
    fifth   db      "E"
    sixth   db      "F"
    seventh db      "G"
    eighth  db      "H"
    ninth   db      "I"
    tenth   db      "J"
    fmt     db      "The string is: %s",10,0
section .bss
    flist   resb    11      ; string length + terminating 0
section .text
    global main
main:
    push    rbp
    mov     rbp, rsp
    
    mov     rdi, flist      ; final string
    mov     rsi, first
    mov     rdx, second
    mov     rcx, third
    mov     r8, fourth
    mov     r9, fifth
    push    tenth           ; push additional args in reverse
    push    ninth
    push    eighth
    push    seventh
    push    sixth
    call    lfunc
    
    mov     rdi, fmt
    mov     rsi, flist
    mov     rax, 0
    call    printf
    
    leave
    ret

lfunc:
    push    rbp
    mov     rbp, rsp
    
    xor     rax, rax    ; clear rax (especially the higher bits)
    
    mov     al, byte[rsi]   ; move content of 1st arg into al (byte keyword is for readability)
    mov     [rdi], al       ; store al to memory
    mov     al, byte[rdx]
    mov     [rdi+1], al
    mov     al, byte[rcx]
    mov     [rdi+2], al
    mov     al, byte[r8]
    mov     [rdi+3], al
    mov     al, byte[r9]
    mov     [rdi+4], al
    
    push    rbx             ; callee saved
    xor     rbx, rbx
    mov     rax, qword[rbp+16]  ; initial value + rip + rbp
    mov     bl, byte[rax]       ; extract character
    mov     [rdi+5], bl         ; store character to memory
    mov     rax, qword[rbp+24]
    mov     bl, byte[rax]
    mov     [rdi+6], bl
    mov     rax, qword[rbp+32]
    mov     bl, byte[rax]
    mov     [rdi+7], bl
    mov     rax, qword[rbp+40]
    mov     bl, byte[rax]
    mov     [rdi+8], bl
    mov     rax, qword[rbp+48]
    mov     bl, byte[rax]
    mov     [rdi+9], bl
    mov     bl, 0
    mov     [rdi+10], bl
    pop     rbx             ; callee saved
    
    mov     rsp, rbp
    pop     rbp
    ret
    