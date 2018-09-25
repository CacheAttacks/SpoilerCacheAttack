	.file	"storefor_find_es.c"
	.text
.Ltext0:
	.globl	_Z12measure_readPv
	.type	_Z12measure_readPv, @function
_Z12measure_readPv:
.LFB2:
	.file 1 "storefor_find_es.c"
	.loc 1 13 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	.cfi_offset 3, -24
	movq	%rdi, -16(%rbp)
	.loc 1 36 0
	movq	-16(%rbp), %rax
	movq	%rax, %rbx
#APP
# 36 "storefor_find_es.c" 1
	rdtscp;mov %eax, %esi;mov (%rbx), %eax;lfence;rdtscp;sub %esi, %eax;mov %eax, %ecx;
# 0 "" 2
#NO_APP
	movl	%ecx, %eax
	movl	%eax, %ebx
	.loc 1 38 0
	movl	%ebx, %eax
	.loc 1 40 0
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	_Z12measure_readPv, .-_Z12measure_readPv
	.globl	_Z3blaPj
	.type	_Z3blaPj, @function
_Z3blaPj:
.LFB5:
	.loc 1 54 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	.loc 1 55 0
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	leal	1(%rax), %edx
	movq	-8(%rbp), %rax
	movl	%edx, (%rax)
	.loc 1 56 0
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	leal	1(%rax), %edx
	movq	-8(%rbp), %rax
	movl	%edx, (%rax)
	.loc 1 57 0
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	leal	1(%rax), %edx
	movq	-8(%rbp), %rax
	movl	%edx, (%rax)
	.loc 1 58 0
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	leal	1(%rax), %edx
	movq	-8(%rbp), %rax
	movl	%edx, (%rax)
	.loc 1 59 0
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	_Z3blaPj, .-_Z3blaPj
	.globl	_Z16measure_read_altPv
	.type	_Z16measure_read_altPv, @function
_Z16measure_read_altPv:
.LFB6:
	.loc 1 62 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	.loc 1 64 0
#APP
# 64 "storefor_find_es.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	movl	%eax, -12(%rbp)
	.loc 1 66 0
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -8(%rbp)
	.loc 1 69 0
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	addl	$1, -8(%rbp)
	.loc 1 75 0
#APP
# 75 "storefor_find_es.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	movl	%eax, -4(%rbp)
	.loc 1 77 0
	movl	-4(%rbp), %eax
	subl	-12(%rbp), %eax
	.loc 1 103 0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	_Z16measure_read_altPv, .-_Z16measure_read_altPv
	.globl	_Z5dummyv
	.type	_Z5dummyv, @function
_Z5dummyv:
.LFB7:
	.loc 1 105 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	.loc 1 105 0
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	_Z5dummyv, .-_Z5dummyv
	.section	.rodata
.LC0:
	.string	"%u"
.LC1:
	.string	"\033[31m"
.LC2:
	.string	"%s"
.LC3:
	.string	"(%u) "
.LC4:
	.string	"\033[0m"
	.text
	.globl	_Z17measurement_functPhiS_
	.type	_Z17measurement_functPhiS_, @function
_Z17measurement_functPhiS_:
.LFB8:
	.loc 1 107 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movl	%esi, -60(%rbp)
	movq	%rdx, -72(%rbp)
	.loc 1 108 0
	movl	$8192, %eax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -8(%rbp)
.LBB2:
	.loc 1 111 0
	movl	-60(%rbp), %eax
	movl	%eax, -40(%rbp)
.L18:
	.loc 1 111 0 is_stmt 0 discriminator 1
	cmpl	$4095, -40(%rbp)
	jg	.L8
.LBB3:
	.loc 1 113 0 is_stmt 1
	movq	$0, -16(%rbp)
.LBB4:
	.loc 1 115 0
	movl	$0, -36(%rbp)
.L12:
	.loc 1 115 0 is_stmt 0 discriminator 1
	cmpl	$99, -36(%rbp)
	jg	.L9
.LBB5:
	.loc 1 118 0 is_stmt 1
	call	_Z5dummyv
.LBB6:
	.loc 1 119 0
	movl	$100, -32(%rbp)
.L11:
	.loc 1 119 0 is_stmt 0 discriminator 3
	cmpl	$0, -32(%rbp)
	js	.L10
	.loc 1 120 0 is_stmt 1 discriminator 2
	movl	-32(%rbp), %eax
	movl	%eax, %edx
	movq	-56(%rbp), %rax
	movb	%dl, (%rax)
	.loc 1 119 0 discriminator 2
	subl	$1, -32(%rbp)
	jmp	.L11
.L10:
.LBE6:
	.loc 1 122 0 discriminator 2
	movl	-40(%rbp), %eax
	sall	$12, %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	.loc 1 128 0 discriminator 2
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	_Z12measure_readPv
	movl	%eax, %eax
	addq	%rax, -16(%rbp)
.LBE5:
	.loc 1 115 0 discriminator 2
	addl	$1, -36(%rbp)
	jmp	.L12
.L9:
.LBE4:
	.loc 1 131 0
	movl	-40(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	movq	-8(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-16(%rbp), %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	movw	%ax, (%rcx)
	.loc 1 133 0
	movl	-40(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	movl	%eax, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	.loc 1 135 0
	movq	$0, -16(%rbp)
.LBB7:
	.loc 1 137 0
	movl	$0, -28(%rbp)
.L16:
	.loc 1 137 0 is_stmt 0 discriminator 1
	cmpl	$99, -28(%rbp)
	jg	.L13
.LBB8:
.LBB9:
	.loc 1 140 0 is_stmt 1
	movl	-60(%rbp), %eax
	movl	%eax, -24(%rbp)
.L15:
	.loc 1 140 0 is_stmt 0 discriminator 3
	cmpl	$0, -24(%rbp)
	js	.L14
	.loc 1 141 0 is_stmt 1 discriminator 2
	movl	-40(%rbp), %eax
	subl	-24(%rbp), %eax
	sall	$12, %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	.loc 1 140 0 discriminator 2
	subl	$1, -24(%rbp)
	jmp	.L15
.L14:
.LBE9:
	.loc 1 148 0 discriminator 2
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	_Z12measure_readPv
	movl	%eax, %eax
	addq	%rax, -16(%rbp)
.LBE8:
	.loc 1 137 0 discriminator 2
	addl	$1, -28(%rbp)
	jmp	.L16
.L13:
.LBE7:
	.loc 1 150 0
	movl	-40(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	movq	-8(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-16(%rbp), %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	movw	%ax, (%rcx)
	.loc 1 152 0
	movl	-40(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	cmpw	$300, %ax
	jbe	.L17
	.loc 1 153 0
	movl	$.LC1, %esi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
.L17:
	.loc 1 155 0 discriminator 2
	movl	-40(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	movl	%eax, %esi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	printf
	.loc 1 156 0 discriminator 2
	movl	$.LC4, %esi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
.LBE3:
	.loc 1 111 0 discriminator 2
	addl	$1, -40(%rbp)
	jmp	.L18
.L8:
.LBE2:
.LBB10:
	.loc 1 162 0
	movl	-60(%rbp), %eax
	movl	%eax, -20(%rbp)
.L20:
	.loc 1 162 0 is_stmt 0 discriminator 3
	cmpl	$4095, -20(%rbp)
	jg	.L21
	.loc 1 162 0 discriminator 2
	addl	$1, -20(%rbp)
	jmp	.L20
.L21:
.LBE10:
	.loc 1 173 0 is_stmt 1
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	_Z17measurement_functPhiS_, .-_Z17measurement_functPhiS_
	.globl	_Z21measurement_funct_altPhiS_
	.type	_Z21measurement_funct_altPhiS_, @function
_Z21measurement_funct_altPhiS_:
.LFB9:
	.loc 1 175 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movl	%esi, -60(%rbp)
	movq	%rdx, -72(%rbp)
	.loc 1 176 0
	movl	$8192, %eax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -8(%rbp)
.LBB11:
	.loc 1 179 0
	movl	-60(%rbp), %eax
	movl	%eax, -40(%rbp)
.L33:
	.loc 1 179 0 is_stmt 0 discriminator 1
	cmpl	$4095, -40(%rbp)
	jg	.L23
.LBB12:
	.loc 1 181 0 is_stmt 1
	movq	$0, -16(%rbp)
.LBB13:
	.loc 1 183 0
	movl	$0, -36(%rbp)
.L27:
	.loc 1 183 0 is_stmt 0 discriminator 1
	cmpl	$99, -36(%rbp)
	jg	.L24
.LBB14:
.LBB15:
	.loc 1 186 0 is_stmt 1
	movl	-60(%rbp), %eax
	movl	%eax, -32(%rbp)
.L26:
	.loc 1 186 0 is_stmt 0 discriminator 3
	cmpl	$0, -32(%rbp)
	js	.L25
	.loc 1 187 0 is_stmt 1 discriminator 2
	movq	-56(%rbp), %rax
	movb	$0, (%rax)
	.loc 1 186 0 discriminator 2
	subl	$1, -32(%rbp)
	jmp	.L26
.L25:
.LBE15:
	.loc 1 194 0 discriminator 2
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	_Z16measure_read_altPv
	movl	%eax, %eax
	addq	%rax, -16(%rbp)
.LBE14:
	.loc 1 183 0 discriminator 2
	addl	$1, -36(%rbp)
	jmp	.L27
.L24:
.LBE13:
	.loc 1 196 0
	movl	-40(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	movq	-8(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-16(%rbp), %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	movw	%ax, (%rcx)
	.loc 1 198 0
	movl	-40(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	movl	%eax, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	.loc 1 200 0
	movq	$0, -16(%rbp)
.LBB16:
	.loc 1 202 0
	movl	$0, -28(%rbp)
.L31:
	.loc 1 202 0 is_stmt 0 discriminator 1
	cmpl	$99, -28(%rbp)
	jg	.L28
.LBB17:
.LBB18:
	.loc 1 205 0 is_stmt 1
	movl	-60(%rbp), %eax
	movl	%eax, -24(%rbp)
.L30:
	.loc 1 205 0 is_stmt 0 discriminator 3
	cmpl	$0, -24(%rbp)
	js	.L29
	.loc 1 206 0 is_stmt 1 discriminator 2
	movl	-40(%rbp), %eax
	subl	-24(%rbp), %eax
	sall	$12, %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	.loc 1 205 0 discriminator 2
	subl	$1, -24(%rbp)
	jmp	.L30
.L29:
.LBE18:
	.loc 1 213 0 discriminator 2
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	_Z12measure_readPv
	movl	%eax, %eax
	addq	%rax, -16(%rbp)
.LBE17:
	.loc 1 202 0 discriminator 2
	addl	$1, -28(%rbp)
	jmp	.L31
.L28:
.LBE16:
	.loc 1 215 0
	movl	-40(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	movq	-8(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-16(%rbp), %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	movw	%ax, (%rcx)
	.loc 1 217 0
	movl	-40(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	cmpw	$300, %ax
	jbe	.L32
	.loc 1 218 0
	movl	$.LC1, %esi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
.L32:
	.loc 1 220 0 discriminator 2
	movl	-40(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	movl	%eax, %esi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	printf
	.loc 1 221 0 discriminator 2
	movl	$.LC4, %esi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
.LBE12:
	.loc 1 179 0 discriminator 2
	addl	$1, -40(%rbp)
	jmp	.L33
.L23:
.LBE11:
.LBB19:
	.loc 1 227 0
	movl	-60(%rbp), %eax
	movl	%eax, -20(%rbp)
.L35:
	.loc 1 227 0 is_stmt 0 discriminator 3
	cmpl	$4095, -20(%rbp)
	jg	.L36
	.loc 1 227 0 discriminator 2
	addl	$1, -20(%rbp)
	jmp	.L35
.L36:
.LBE19:
	.loc 1 238 0 is_stmt 1
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	_Z21measurement_funct_altPhiS_, .-_Z21measurement_funct_altPhiS_
	.section	.rodata
.LC5:
	.string	"target_add:%p\n"
	.text
	.globl	_Z14storefor_writev
	.type	_Z14storefor_writev, @function
_Z14storefor_writev:
.LFB10:
	.loc 1 241 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	.loc 1 245 0
	movl	$16777216, %edi
	call	malloc
	movq	%rax, -8(%rbp)
	.loc 1 246 0
	movq	-8(%rbp), %rax
	movl	$16777216, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset
	.loc 1 250 0
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC5, %edi
	movl	$0, %eax
	call	printf
	.loc 1 251 0
	movq	-8(%rbp), %rdx
	movq	-8(%rbp), %rax
	movl	$64, %esi
	movq	%rax, %rdi
	call	_Z17measurement_functPhiS_
	.loc 1 255 0
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	_Z14storefor_writev, .-_Z14storefor_writev
.Letext0:
	.file 2 "/usr/include/stdint.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x44c
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.long	.LASF32
	.byte	0x4
	.long	.LASF33
	.long	.LASF34
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF0
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.long	.LASF1
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.long	.LASF2
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF3
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF4
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.long	.LASF5
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF6
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF7
	.uleb128 0x4
	.byte	0x8
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF8
	.uleb128 0x5
	.long	.LASF9
	.byte	0x2
	.byte	0x30
	.long	0x34
	.uleb128 0x5
	.long	.LASF10
	.byte	0x2
	.byte	0x31
	.long	0x3b
	.uleb128 0x5
	.long	.LASF11
	.byte	0x2
	.byte	0x33
	.long	0x42
	.uleb128 0x5
	.long	.LASF12
	.byte	0x2
	.byte	0x37
	.long	0x2d
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF13
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF14
	.uleb128 0x6
	.long	.LASF15
	.byte	0x1
	.byte	0xd
	.long	.LASF18
	.long	0x8b
	.quad	.LFB2
	.quad	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.long	0xf0
	.uleb128 0x7
	.long	.LASF16
	.byte	0x1
	.byte	0xd
	.long	0x6c
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x8
	.long	.LASF20
	.byte	0x1
	.byte	0x11
	.long	0x8b
	.uleb128 0x1
	.byte	0x53
	.byte	0
	.uleb128 0x9
	.string	"bla"
	.byte	0x1
	.byte	0x36
	.long	.LASF35
	.long	0x57
	.quad	.LFB5
	.quad	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.long	0x124
	.uleb128 0xa
	.string	"val"
	.byte	0x1
	.byte	0x36
	.long	0x124
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0xb
	.byte	0x8
	.long	0x8b
	.uleb128 0x6
	.long	.LASF17
	.byte	0x1
	.byte	0x3e
	.long	.LASF19
	.long	0x8b
	.quad	.LFB6
	.quad	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.long	0x188
	.uleb128 0x7
	.long	.LASF16
	.byte	0x1
	.byte	0x3e
	.long	0x6c
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x8
	.long	.LASF21
	.byte	0x1
	.byte	0x3f
	.long	0x8b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x8
	.long	.LASF22
	.byte	0x1
	.byte	0x3f
	.long	0x8b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xc
	.string	"val"
	.byte	0x1
	.byte	0x3f
	.long	0x8b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0xd
	.long	.LASF36
	.byte	0x1
	.byte	0x69
	.long	.LASF37
	.quad	.LFB7
	.quad	.LFE7-.LFB7
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0xe
	.long	.LASF28
	.byte	0x1
	.byte	0x6b
	.long	.LASF30
	.quad	.LFB8
	.quad	.LFE8-.LFB8
	.uleb128 0x1
	.byte	0x9c
	.long	0x2de
	.uleb128 0x7
	.long	.LASF23
	.byte	0x1
	.byte	0x6b
	.long	0x2de
	.uleb128 0x3
	.byte	0x91
	.sleb128 -72
	.uleb128 0x7
	.long	.LASF24
	.byte	0x1
	.byte	0x6b
	.long	0x57
	.uleb128 0x3
	.byte	0x91
	.sleb128 -76
	.uleb128 0x7
	.long	.LASF25
	.byte	0x1
	.byte	0x6b
	.long	0x2de
	.uleb128 0x3
	.byte	0x91
	.sleb128 -88
	.uleb128 0x8
	.long	.LASF26
	.byte	0x1
	.byte	0x6c
	.long	0x2e4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0xf
	.quad	.LBB2
	.quad	.LBE2-.LBB2
	.long	0x2bf
	.uleb128 0xc
	.string	"p"
	.byte	0x1
	.byte	0x6f
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x10
	.quad	.LBB3
	.quad	.LBE3-.LBB3
	.uleb128 0x8
	.long	.LASF27
	.byte	0x1
	.byte	0x71
	.long	0x96
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0xf
	.quad	.LBB4
	.quad	.LBE4-.LBB4
	.long	0x281
	.uleb128 0xc
	.string	"r"
	.byte	0x1
	.byte	0x73
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -52
	.uleb128 0x10
	.quad	.LBB6
	.quad	.LBE6-.LBB6
	.uleb128 0xc
	.string	"i"
	.byte	0x1
	.byte	0x77
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.byte	0
	.byte	0
	.uleb128 0x10
	.quad	.LBB7
	.quad	.LBE7-.LBB7
	.uleb128 0xc
	.string	"r"
	.byte	0x1
	.byte	0x89
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -44
	.uleb128 0x10
	.quad	.LBB9
	.quad	.LBE9-.LBB9
	.uleb128 0xc
	.string	"i"
	.byte	0x1
	.byte	0x8c
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x10
	.quad	.LBB10
	.quad	.LBE10-.LBB10
	.uleb128 0xc
	.string	"p"
	.byte	0x1
	.byte	0xa2
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.byte	0
	.byte	0
	.uleb128 0xb
	.byte	0x8
	.long	0x75
	.uleb128 0xb
	.byte	0x8
	.long	0x80
	.uleb128 0xe
	.long	.LASF29
	.byte	0x1
	.byte	0xaf
	.long	.LASF31
	.quad	.LFB9
	.quad	.LFE9-.LFB9
	.uleb128 0x1
	.byte	0x9c
	.long	0x423
	.uleb128 0x7
	.long	.LASF23
	.byte	0x1
	.byte	0xaf
	.long	0x2de
	.uleb128 0x3
	.byte	0x91
	.sleb128 -72
	.uleb128 0x7
	.long	.LASF24
	.byte	0x1
	.byte	0xaf
	.long	0x57
	.uleb128 0x3
	.byte	0x91
	.sleb128 -76
	.uleb128 0x7
	.long	.LASF25
	.byte	0x1
	.byte	0xaf
	.long	0x2de
	.uleb128 0x3
	.byte	0x91
	.sleb128 -88
	.uleb128 0x8
	.long	.LASF26
	.byte	0x1
	.byte	0xb0
	.long	0x2e4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0xf
	.quad	.LBB11
	.quad	.LBE11-.LBB11
	.long	0x404
	.uleb128 0xc
	.string	"p"
	.byte	0x1
	.byte	0xb3
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x10
	.quad	.LBB12
	.quad	.LBE12-.LBB12
	.uleb128 0x8
	.long	.LASF27
	.byte	0x1
	.byte	0xb5
	.long	0x96
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0xf
	.quad	.LBB13
	.quad	.LBE13-.LBB13
	.long	0x3c6
	.uleb128 0xc
	.string	"r"
	.byte	0x1
	.byte	0xb7
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -52
	.uleb128 0x10
	.quad	.LBB15
	.quad	.LBE15-.LBB15
	.uleb128 0xc
	.string	"i"
	.byte	0x1
	.byte	0xba
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.byte	0
	.byte	0
	.uleb128 0x10
	.quad	.LBB16
	.quad	.LBE16-.LBB16
	.uleb128 0xc
	.string	"r"
	.byte	0x1
	.byte	0xca
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -44
	.uleb128 0x10
	.quad	.LBB18
	.quad	.LBE18-.LBB18
	.uleb128 0xc
	.string	"i"
	.byte	0x1
	.byte	0xcd
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x10
	.quad	.LBB19
	.quad	.LBE19-.LBB19
	.uleb128 0xc
	.string	"p"
	.byte	0x1
	.byte	0xe3
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.byte	0
	.byte	0
	.uleb128 0x11
	.long	.LASF38
	.byte	0x1
	.byte	0xf1
	.long	.LASF39
	.quad	.LFB10
	.quad	.LFE10-.LFB10
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x8
	.long	.LASF23
	.byte	0x1
	.byte	0xf4
	.long	0x2de
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x6e
	.uleb128 0xe
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x6e
	.uleb128 0xe
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x6e
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x6e
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x6e
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.long	0x2c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x8
	.byte	0
	.value	0
	.value	0
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.quad	0
	.quad	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF23:
	.string	"evictionBuffer"
.LASF25:
	.string	"target_add"
.LASF39:
	.string	"_Z14storefor_writev"
.LASF37:
	.string	"_Z5dummyv"
.LASF9:
	.string	"uint8_t"
.LASF12:
	.string	"uint64_t"
.LASF29:
	.string	"measurement_funct_alt"
.LASF35:
	.string	"_Z3blaPj"
.LASF24:
	.string	"window_size"
.LASF1:
	.string	"unsigned char"
.LASF0:
	.string	"long unsigned int"
.LASF36:
	.string	"dummy"
.LASF20:
	.string	"_delta"
.LASF34:
	.string	"/home/619501/MA_2/master-moritz_krebbel-drive_by_cache_attacks/code/c/StoreFor"
.LASF32:
	.string	"GNU C++ 5.4.0 20160609 -mtune=generic -march=x86-64 -g -O0 -fstack-protector-strong"
.LASF15:
	.string	"measure_read"
.LASF17:
	.string	"measure_read_alt"
.LASF3:
	.string	"unsigned int"
.LASF14:
	.string	"long long unsigned int"
.LASF38:
	.string	"storefor_write"
.LASF22:
	.string	"after"
.LASF27:
	.string	"total"
.LASF19:
	.string	"_Z16measure_read_altPv"
.LASF7:
	.string	"sizetype"
.LASF13:
	.string	"long long int"
.LASF28:
	.string	"measurement_funct"
.LASF8:
	.string	"char"
.LASF31:
	.string	"_Z21measurement_funct_altPhiS_"
.LASF18:
	.string	"_Z12measure_readPv"
.LASF21:
	.string	"before"
.LASF5:
	.string	"short int"
.LASF10:
	.string	"uint16_t"
.LASF11:
	.string	"uint32_t"
.LASF6:
	.string	"long int"
.LASF4:
	.string	"signed char"
.LASF2:
	.string	"short unsigned int"
.LASF33:
	.string	"storefor_find_es.c"
.LASF16:
	.string	"memory"
.LASF30:
	.string	"_Z17measurement_functPhiS_"
.LASF26:
	.string	"measurementBuffer"
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.10) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
