; function2.asm
extern printf
section .data
    radius      dq      10.0
section .bss
section .text
;-----------------------------------------------------------------------
area:
    section .data
        .pi     dq      3.141592654     ; local variable for area fn
    section .text
        push    rbp
        mov     rbp, rsp
            movsd   xmm0, [radius]
            mulsd   xmm0, [radius]
            mulsd   xmm0, [.pi]
        leave
        ret
;-----------------------------------------------------------------------
circum:
    section .data
        .pi     dq      3.14            ; local variable for circum fn
    section .text
        push    rbp
        mov     rbp, rsp
            movsd   xmm0, [radius]
            addsd   xmm0, [radius]
            mulsd   xmm0, [.pi]
        leave
        ret
;-----------------------------------------------------------------------
circle:
    section .data
        .fmt_area   db      "The area is %.2f",10,0
        .fmt_circum db      "The circumference is %.2f",10,0
    section .text
        push    rbp
        mov     rbp, rsp
            call    area
            lea     rdi, .fmt_area
            mov     rax, 1      ; area is in xmm0
            call    printf
            call    circum
            lea     rdi, .fmt_circum
            mov     rax, 1      ; circumference is in xmm0
            call    printf
        leave
        ret
;----------------------------------------------------------------------
    global main
main:
    push    rbp
    mov     rbp, rsp
        call    circle
    leave
    ret