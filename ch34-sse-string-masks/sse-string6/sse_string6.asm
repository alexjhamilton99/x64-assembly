; sse_string6.asm
; find a substring
extern print16b
extern printf

section .data
	string1	db	"a quick pink dinosaur jumps over the lazy river and the lazy dinosaur doesn't mind",10,0
	string2	db	"dinosaur",0
	NL	db	10,0
	fmt	db	"Find the substring '%s' in:",10,0
	fmt_oc	db	"I found %ld %ss",10,0

section .bss
section .text
	global main
main:
	push	rbp
	mov	rbp, rsp

	; first print the strings
	mov	rdi, fmt
	mov	rsi, string2
	xor	rax, rax
	call	printf
	mov	rdi, string1
	xor	rax, rax
	call	printf
	; search the string
	mov	rdi, string1
	mov	rsi, string2
	call	psubstringsrch
	; print substring's number of occurrences
	mov	rdi, fmt_oc
	mov	rsi, rax
	mov	rdx, string2
	call	printf

	leave
	ret

; searching substring and printing mask fn
psubstringsrch:		; packed substring search
	push		rbp
	mov		rbp, rsp

	sub		rsp, 16		; room for saving xmm1

	xor		r12, r12	; occurrences running total
	xor		rcx, rcx	; for signaling the end
	xor		rbx, rbx	; for address calculation
	mov		rax, -16	; avoid setting ZF

	; build xmm1, load substring
	pxor		xmm1, xmm1
	movdqu		xmm1, [rsi]

	.loop:
		add		rax, 16			; avoid setting ZF
		mov		rsi, 16			; if no 0, print 16 bytes
		movdqu		xmm2, [rdi + rbx]
		pcmpistrm	xmm1, xmm2, 01001100b	; equal ordered | byte mask in xmm0
		setz		cl			; terminating 0 detected
		; if terminating 0 found, determine position
		cmp		cl, 0
		je		.gotoprint		; no terminating 0 found
		; terminating null found
		; less than 16 bytes left
		; rdi contains string's address
		; rbx contains number of bytes in blocks handled so far
		add		rdi, rbx		; take only the string's tail
		push		rcx			; caller saved (cl in use)
		call		pstrlen			; rax returns the 0's position
		push		rcx			; caller saved (cl in use)
		dec		rax			; length without 0
		mov		rsi, rax		; remaining bytes' length

	; print mask
	.gotoprint:
		call		print_mask
		; keep matches' running total
		popcnt		r13d, r13d		; count number of 1 bits
		add		r12d, r13d		; keep occurrences' number in r12
		or		cl, cl			; terminating 0 detected?
		jnz		.exit
		add		rbx, 16			; prepare for next block
		jmp		.loop

	.exit:
		mov		rdi, NL
		call		printf
		mov		rax, r12		; return number of occurrences

	leave
	ret

;------------------------------------------------------------------------------------------
pstrlen:
	push		rbp
	mov		rbp, rsp

	sub		rsp, 16			; for pushing xmm0

	movdqu		[rbp - 16], xmm0	; push xmm0
	mov		rax, -16		; avoid setting ZF later
	pxor		xmm0, xmm0		; search for 0 (string's end)

	.loop:
		add		rax, 16			; avoid setting ZF when rax = 0 after pcmpistri
		pcmpistri	xmm0, [rdi + rax], 0x08	; equal each
		jnz		.loop			; 0 found?
		add		rax, rcx		; rax = bytes already handled
							; rcx = bytes handled in terminating loop
		movdqu		xmm0, [rbp - 16]	; pop xmm0

	leave
	ret

; print mask fn
; xmm0 contains mask
; rsi contains the number of bits to print (16 or less)
print_mask:
	push		rbp
	mov		rbp, rsp

	sub		rsp, 16			; for saving xmm0

	call		reverse_xmm0		; little Endian
	pmovmskb	r13d, xmm0		; mov byte mask to edx
	movdqu		[rbp - 16], xmm1	; push xmm1 because of printf
	push		rdi			; rdi contains string1
	mov		edi, r13d		; contains mask to print
	push		rdx			; contains mask
	push		rcx			; contains end of string flag
	call		print16b
	pop		rcx
	pop		rdx
	pop		rdi
	movdqu		xmm1, [rbp - 16]	; pop xmm1

	leave
	ret

; reversing and shuffling xmm0 fn
reverse_xmm0:
section .data
	; mask for reversing
	.bytereverse	db	15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0
section .text
	push		rbp
	mov		rbp, rsp

	sub		rsp, 16

	movdqu		[rbp - 16], xmm2
	movdqu		xmm2, [.bytereverse]		; load mask in xmm2
	pshufb		xmm0, xmm2
	movdqu		xmm2, [rbp - 16]		; pop xmm2

	leave
	ret						; returns the shuffled xmm0
