; hello4.asm
extern	printf						; declare an external function
section .data
	msg	db	"Hello, World!",0
	fmtstr	db	"This is our string: %s",10,0	; printf format
section	.bss
section .text
	global main
main:
	push	rbp
	mov	rbp, rsp
	mov	rdi, fmtstr				; first printf arg
	mov	rsi, msg				; second printf arg
	mov	rax, 0					; no xmm registers involved
	call	printf					; call external function
	mov	rsp, rbp
	pop	rbp
	mov 	rax, 60
	mov	rdi, 0
	syscall
