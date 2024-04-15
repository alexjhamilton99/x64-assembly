; sse_string_length.asm
extern printf

section .data
	; template	0123456789abcdef0123456789abcdef0123456789abcd   e
	; template	1234567890123456789012345678901234567890123456   7
	string1		db	"The quick brown fox jumps over the lazy river.",0
	fmt1		db	"This is our string: %s",10,0
	fmt2		db	"Our string is %d characters long.",10,0
section .bss
section .text
	global main
main:
	push	rbp
	mov	rbp, rsp

	mov	rdi, fmt1
	mov	rsi, string1
	xor 	rax, rax
	call	printf

	mov	rdi, string1
	call	pstrlen

	mov	rdi, fmt2
	mov	rsi, rax
	xor	rax, rax
	call	printf

	leave
	ret

; function that computes a string's length
pstrlen:
	push	rbp
	mov	rbp, rsp

	mov	rax, -16	; avoid changing ZF later
	pxor	xmm0, xmm0	; 0 = string's end

	.not_found:
		add		rax, 16				; avoid changing ZF later
		pcmpistri	xmm0, [rdi + rax], 00001000b	; 'equal each'
		jnz		.not_found			; 0 found?
		add		rax, rcx			; rcx contains 0's index
		inc		rax				; correct for start's index 0

	leave
	ret
