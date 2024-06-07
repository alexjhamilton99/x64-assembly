; sse_string4.asm
; find a character
extern print16b
extern printf

section .data
	string1		db	"qdacdekkfijlmdozabecdfgdklkmddaffffffffdedeee",10,0
	string2		db	"e",0
	string3		db	"a",0
	fmt		db	"Find all the charaters '%s' and '%s' in:",10,0
	fmt_oc		db	"I found %ld characters '%s' and '%s'",10,0
	NL		db	10,0

section .bss
section .text
	global main
main:
	push	rbp
	mov	rbp, rsp

	; print the search characters
	mov	rdi, fmt
	mov	rsi, string2
	mov	rdx, string3
	xor	rax, rax
	call	printf
	; print the target string
	mov	rdi, string1
	xor	rax, rax
	call	printf
	; search the string and print mask
	mov	rdi, string1
	mov	rsi, string2
	mov	rdx, string3
	call	pcharsrch
	; print number of string2 occurrences
	mov	rdi, fmt_oc
	mov	rsi, rax
	mov	rdx, string2
	mov	rcx, string3
	call	printf

	leave
	ret

; searching and mask printing function
pcharsrch:	; packed character search
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16		; provide stack space for pushing xmm1
	xor	r12, r12	; occurrence running total
	xor	rcx, rcx	; for signaling the end
	xor	rbx, rbx	; for address calculation
	mov	rax, -16	; for byte counting, avoid setting flag

	; build xmm1, load search character
	pxor	xmm1, xmm1		; clear xmm1
	pinsrb	xmm1, byte[rsi], 0	; first char is at index 0
	pinsrb	xmm1, byte[rdx], 1	; second char is at index 0

	.loop:
		add		rax, 16			; avoid setting ZF
		mov		rsi, 16			; if no terminating 0, print 16 bytes
		movdqu		xmm2, [rdi + rbx]	; load 16 bytes of string in xmm2
		pcmpistrm	xmm1, xmm2, 40h		; 'equal each' and 'byte mask in xmm0'
		setz		cl			; if terminating 0 detected

		; if there's a terminating 0, determine its position
		cmp		cl, 0
		je		.gotoprint		; no terminating 0 found

		; terminating null found
		; less than 16 bytes left
		; rdi contains string's address
		; rbx contains number bytes in the blocks handled so far
		add		rdi, rbx		; remaining string part's address
		push		rcx			; caller saved (cl in use)
		call		pstrlen			; rax returns the length
		pop		rcx			; caller saved
		dec		rax			; length without 0
		mov		rsi, rax		; remaining mask bytes' length

		; print the mask
	.gotoprint:
		call		print_mask
		; keep matches running total
		popcnt		r13d, r13d		; count number of 1 bits
		add		r12d, r13d		; keep number of occurrences in r12d
		or		cl, cl			; terminating 0 detected?
		jnz		.exit
		add		rbx, 16			; prepare for next 16 bytes
		jmp		.loop

	.exit:
		mov		rdi, NL			; add a new line
		call		printf
		mov		rax, r12		; number of occurrences

	leave
	ret

; find terminating 0 function
pstrlen:
	push		rbp
	mov		rbp, rsp

	sub		rsp, 16		; for saving xmm0
	movdqu		[rbp-16], xmm0	; push xmm0
	mov		rax, -16	; avoid later flag setting
	pxor		xmm0, xmm0	; search for 0, i.e. string's end

	.loop:
		add		rax, 16				; avoid setting ZF
		pcmpistri	xmm0, [rdi + rax], 0x08		; equal each
		jnz		.loop
		add		rax, rcx			; rax = bytes already handled
								; terminating loop handles when rcx = bytes
		movdqu		xmm0, [rbp - 16]		; pop xmm0

	leave
	ret

; mask printing function
; xmm0 contains the mask
; rsi contains the number of bits to print (16 or less)
print_mask:
	push		rbp
	mov		rbp, rsp

	sub		rsp, 16			; for saving xmm0

	call		reverse_xmm0		; little endian
	pmovmskb	r13d, xmm0		; mov byte mask to r13d
	movdqu		[rbp - 16], xmm1	; push xmm1 b/c of printf
	push		rdi			; rdi contains string1
	mov		edi, r13d		; contains mask to print
	push		rdx			; contains mask
	push		rcx			; contains string flag's end
	call		print16b
	pop		rcx
	pop		rdx
	pop		rdi
	movdqu		xmm1, [rbp - 16]	; pop xmm1

	leave
	ret

; reversing and shuffling xmm0 function
reverse_xmm0:
section .data
	; reversing mask
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
	ret						; returns shuffled xmm0
