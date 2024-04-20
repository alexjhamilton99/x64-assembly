; cpu_avx.asm
extern printf
section .data
	fmt_noavx	db	"This cpu doesn't support AVX.",10,0
	fmt_avx		db	"This cpu supports AVX.",10,0
	fmt_noavx2	db	"This cpu doesn't support AVX2.",10,0
	fmt_avx2	db	"This cpu supports AVX2.",10,0
	fmt_noavx512	db	"This cpu doesn't support AVX-512.",10,0
	fmt_avx512	db	"This cpu supports AVX-512.",10,0
section .bss
section .text
	global main
main:
	push	rbp
	mov	rbp, rsp
	
	call	cpu_sse		; returns 1 in rax if AVX supported, otherwise 0

	leave
	ret

cpu_sse:
	push	rbp
	mov	rbp, rsp

	; test for AVX
	mov	eax, 1		; request CPU feature flags
	cpuid
	mov	eax, 28		; test bit 28 in eax
	bt	ecx, eax	; bt = bit test
	jnc	no_avx
	xor	rax, rax
	mov	rdi, fmt_avx
	call	printf
	; test for AVX 2
	mov	eax, 7		; request CPU feature flags
	mov	ecx, 0
	cpuid
	mov	eax, 5		; test bit 5 in ebx
	bt	ebx, eax
	jnc	the_exit
	xor	rax, rax
	mov	rdi, fmt_avx2
	call	printf
	; test for AVX-512 foundation
	mov	eax, 7		; request CPU feature flags
	mov	ecx, 0
	cpuid
	mov	eax, 16		; test bit 16 in ebx
	bt	ebx, eax
	jnc	no_avx512
	xor	rax, rax
	mov	rdi, fmt_avx512
	call	printf
	jmp	the_exit

	no_avx:
		mov	rdi, fmt_noavx
		xor	rax, rax
		call	printf			; displays message if AVX not available
		xor	rax, rax		; returns 0, no AVX
		jmp	the_exit

	no_avx2:
		mov	rdi, fmt_noavx2
		xor	rax, rax
		call	printf			; displays message if AVX not available
		xor	rax, rax		; returns 0, no AVX
		jmp	the_exit

	no_avx512:
		mov	rdi, fmt_noavx512
		xor	rax, rax
		call	printf			; displays message if AVX not available
		xor	rax, rax		; returns 0, no AVX
		jmp	the_exit

	the_exit:
		leave
		ret
