; move.asm
section .data
	bNum	db	123
	wNum	dw	12345
	dNum	dd	1234567890
	qNum1	dq	1234567890123456789
	qNum2	dq	123456
	qNum3	dq	3.14
section .bss
section .text
	global main
main:
	push rbp
	mov rbp, rsp		
	mov rax, -1		; fill rax with 1's
	mov al, byte [bNum]	; doesn't clear rax's upper bits
	xor rax, rax		; clear rax
	mov al, byte [bNum]	; now rax has the correct value
	
	mov rax, -1		; fill rax with 1's
	mov ax, word [wNum]	; doesn't clear rax's upper bits
	xor rax, rax		; clear rax
	mov ax, word [wNum]	; now rax contains the correct value
	
	mov rax, -1		; fill rax with 1's
	mov eax, dWord [dNum]	; clears rax's upper bits
	
	mov rax, -1		; fill rax with 1's
	mov rax, qWord [qNum1]	; clears rax's upper bits
	
	mov qWord [qNum2], rax	; one operand always a register
	mov rax, 123456		; source operands can be an immediate value
	
	movq xmm0, [qNum3]	; special instruction for floating-point
	mov rsp, rbp
	pop rbp

ret	
