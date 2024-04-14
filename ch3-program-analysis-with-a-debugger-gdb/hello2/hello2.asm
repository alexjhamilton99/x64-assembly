; hello2.asm
section .data
	msg	db	"hello, world",0
	NL	db	0xa			; ascii code for new line character
section .bss
section .text
	global main
main:
	mov	rax, 1		; 1 = write
	mov	rdi, 1		; 1 = to stdout
	mov	rsi, msg	; string to display
	mov	rdx, 12		; string's length, without 0
	syscall			; display string
	mov 	rax, 1		; 1 = write
	mov	rdi, 1		; 1 = to stdout
	mov	rsi, NL		; display new line
	mov	rdx, 1		; string's length
	syscall			; display string
	mov	rax, 60		; 60 = exit
	mov	rdi, 0		; 0 = success exit
	syscall			; quit
