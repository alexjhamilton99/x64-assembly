; sse_string3_exp.asm
; compare explicit-lengthed strings
extern printf

section .data
	string1		db	"the quick brown fox jumps over the lazy river"
	string1Len	equ	$ - string1
	string2		db	"the quick brown fox jumps over the lazy river"
	string2Len	equ	$ - string2
	dummy		db	"confuse the world"
	string3		db	"the quick brown fox jumps over the lazy dog"
	string3Len	equ	$ - string3
	fmt1		db	"Strings 1 and 2 are equal.",10,0
	fmt11		db	"Strings 1 and 2 differ at position %i.",10,0
	fmt2		db	"Strings 2 and 3 are equal.",10,0
	fmt22		db	"Strings 2 and 3 differ at position %i.",10,0

section .bss
	buffer		resb	64

section .text
	global main
main:
    mov rbp, rsp; for correct debugging
	push	rbp
	mov	rbp, rsp

	; compare string 1 and 2
	mov	rdi, string1
	mov	rsi, string2
	mov	rdx, string1Len
	mov	rcx, string2Len
	call	pstrcmp
	push	rax			; push result on stack

	; print string1, string2 and result
	; first build the string with a newline and terminating 0
	; string1
	mov	rsi, string1
	mov	rdi, buffer
	mov	rcx, string1Len
	rep	movsb
	mov	byte[rdi], 10		; add newline to buffer
	inc	rdi
	mov	byte[rdi],0		; add terminating 0 to buffer
	; print string1
	mov	rdi, buffer
	xor	rax, rax
	call	printf
	; string2
	mov	rsi, string2
	mov	rdi, buffer
	mov	rcx, string2Len
	rep	movsb
	mov	byte[rdi], 10		; add newline to buffer
	inc	rdi
	mov	byte[rdi],0		; add terminating 0
	; print string2
	mov	rdi, buffer
	xor	rax, rax
	call	printf
	; print the comparison's result
	pop	rax
	mov	rdi, fmt1
	cmp	rax, 0
	je	eql1
	mov	rdi, fmt11

	eql1:
		mov	rsi, rax
		xor	rax, rax
		call	printf

	; compare string2 and string3
	mov	rdi, string2
	mov	rsi, string3
	mov	rdx, string2Len
	mov	rcx, string3Len
	call	pstrcmp
	push	rax
	
	; print string3 and the result
	; first build the string with a newline char and a terminating 0
	; string3
	mov	rsi, string3
	mov	rdi, buffer
	mov	rcx, string3Len
	rep	movsb
	mov	byte[rdi], 10		; add newline to buffer
	inc	rdi
	mov	byte[rdi],0		; add terminating 0 to buffer
	; print
	mov	rdi, buffer
	xor	rax, rax
	call	printf
	; print the comparison's result
	pop	rax
	mov	rdi, fmt2
	cmp	rax, 0
	je	eql2
	mov	rdi, fmt22

	eql2:
		mov	rsi, rax
		xor	rax, rax
		call	printf

	leave
	ret

;------------------------------------------------------------------------------------------------------
pstrcmp:
	push	rbp
	mov	rbp, rsp

	xor	rbx, rbx
	mov	rax, rdx	; rax now contains first string's length
	mov	rdx, rcx	; rdx now contains second string's length
	xor	rcx, rcx	; rcx as index

	.loop:
		movdqu		xmm1, [rdi + rbx]
		pcmpestri	xmm1, [rsi + rbx], 0x18		; equal each, negative polarity
		jc		.differ
		jz		.equal
		add		rbx, 16
		sub		rax, 16
		sub		rdx, 16
		jmp		.loop

	.differ:
		mov		rax, rbx
		add		rax, rcx			; rcx contains the differing position
		inc		rax				; b/c counter starts at 05
		jmp		.exit
	
	.equal:
		xor		rax, rax

	.exit:
		leave
		ret
