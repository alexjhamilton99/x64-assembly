; console.asm
section .data
    msg1        db      "Hello, World!",10,0    
    msg1len     equ     $-msg1
    msg2        db      "Your turn: ",0
    msg2len     equ     $-msg2
    msg3        db      "You answered: ",0
    msg3len     equ     $-msg3
    inputlen    equ     10                      ; input buffer's length
section .bss
    input       resb    inputlen+1              ; provide space for ending 0
section .text
    global main
main:
    push    rbp
    mov     rbp, rsp
    
    mov     rsi, msg1
    mov     rdx, msg1len
    call    prints
    mov     rsi, msg2
    mov     rdx, msg2len
    call    prints
    
    mov     rsi, input      ; input buffer address
    mov     rdx, inputlen
    call    reads           ; wait for input
    mov     rsi, msg3
    mov     rdx, msg3len
    call    prints
    mov     rsi, input
    mov     rdx, inputlen
    call    prints          ; print the input buffer
    
    leave
    ret
    
prints:
    push    rbp
    mov     rbp, rsp
    
    ; rsi contains the string's address
    ; rdx contains the string's length          
    mov     rax, 1          ; 1 = write
    mov     rdi, 1          ; 1 = stdout
    syscall
    
    leave
    ret

reads:
    push    rbp
    mov     rbp, rsp
    
    ; rsi contains the inputbuffer's address
    ; rdi contains the inputbuffer's length
    mov     rax, 0          ; 0 = read
    mov     rdi, 1          ; 1 = stdin
    syscall
    
    leave
    ret