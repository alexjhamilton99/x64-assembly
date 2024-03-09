; aligned.asm
extern printf
section .data
    fmt     db      "2 times pi equals %.14f",10,0
    pi      dq      3.14159265358979
section .bss
section .text
;---------------------------------------------------------------------------
func3:
    push    rbp
    movsd   xmm0, [pi]
    addsd   xmm0, [pi]
    mov     rdi, fmt
    mov     rax, 1
    call    printf          ; print float
    pop     rbp
    ret
;---------------------------------------------------------------------------
func2:
    push    rbp
    call    func3           ; call 3rd fn
    pop     rbp
    ret
;---------------------------------------------------------------------------
func1:
    push    rbp
    call    func2           ; call 2nd fn
    pop     rbp
    ret
;---------------------------------------------------------------------------
    global main
main:
    push    rbp
    call    func1           ; call 1st fn
    pop rbp
    ret