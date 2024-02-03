; alive.asm
section .data
	msg1	db	"Hello, World!",10,0	; string with new line and 0
	msg1Len	equ	$-msg1-1		; measure length minus the 0
	msg2	db	"Alive and Kicking!",10,0	; string with new line and 0
	msg2Len	equ	$-msg2-1		; measure length minus the 0
	radius	dq	357			; no string, not displayable?
	pi	dq	3.14
section .bss
section .text
	global main
main:
	push	rbp		; function prologue
	mov	rbp, rsp	; function prologue
	mov	rax, 1		; 1 = write
	mov	rdi, 1		; 1 = stdout
	mov	rsi, msg1	; string to display
	mov	rdx, msg1Len	; string length
	syscall			; display string
	mov	rax, 1		; 1 = write
	mov	rdi, 1		; 1 = stdout
	mov	rsi, msg2	; string to display
	mov	rdx, msg2Len	; string length
	syscall			; display string
	mov	rsp, rbp	; function epilogue
	pop 	rbp		; function epilogue
	mov	rax, 60		; 60 = exit
	mov	rdi, 0		; 0 = success
	syscall			; quit
	
