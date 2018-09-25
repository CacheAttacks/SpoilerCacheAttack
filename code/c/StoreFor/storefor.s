	.file	"storefor.c"
	.text
.Ltext0:
	.type	_ZL6rdtscpv, @function
_ZL6rdtscpv:
.LFB2:
	.file 1 "storefor.c"
	.loc 1 22 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	.loc 1 24 0
#APP
# 24 "storefor.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	movl	%eax, -8(%rbp)
	movl	%edx, -4(%rbp)
	.loc 1 25 0
	movl	-4(%rbp), %eax
	salq	$32, %rax
	movq	%rax, %rdx
	movl	-8(%rbp), %eax
	orq	%rdx, %rax
	.loc 1 26 0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	_ZL6rdtscpv, .-_ZL6rdtscpv
	.globl	_Z9probetimePv
	.type	_Z9probetimePv, @function
_Z9probetimePv:
.LFB3:
	.loc 1 47 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$40, %rsp
	movq	%rdi, -40(%rbp)
	.loc 1 48 0
	cmpq	$0, -40(%rbp)
	jne	.L4
	.loc 1 49 0
	movl	$0, %eax
	jmp	.L5
.L4:
	.loc 1 50 0
	movl	$0, -20(%rbp)
	.loc 1 51 0
	movq	-40(%rbp), %rax
	movq	%rax, -16(%rbp)
	.loc 1 52 0
	call	_ZL6rdtscpv
	movq	%rax, -8(%rbp)
.L7:
	.loc 1 54 0
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	.loc 1 55 0
	movq	-16(%rbp), %rax
	cmpq	-40(%rbp), %rax
	je	.L6
	.loc 1 53 0
	jmp	.L7
.L6:
	.loc 1 56 0
	call	_ZL6rdtscpv
	subq	-8(%rbp), %rax
.L5:
	.loc 1 57 0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	_Z9probetimePv, .-_Z9probetimePv
	.globl	_Z4calci
	.type	_Z4calci, @function
_Z4calci:
.LFB4:
	.loc 1 61 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	.loc 1 62 0
	movl	$0, %eax
	.loc 1 63 0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	_Z4calci, .-_Z4calci
	.section	.rodata
.LC0:
	.string	"\033[31m"
.LC1:
	.string	"%s"
.LC2:
	.string	"\033[0m"
.LC3:
	.string	"%u "
	.text
	.globl	_Z21measurement_funct_oldPhiS_
	.type	_Z21measurement_funct_oldPhiS_, @function
_Z21measurement_funct_oldPhiS_:
.LFB5:
	.loc 1 65 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$88, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -72(%rbp)
	movl	%esi, -76(%rbp)
	movq	%rdx, -88(%rbp)
	.loc 1 65 0
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	.loc 1 66 0
	movl	$8192, %eax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -32(%rbp)
.LBB2:
	.loc 1 67 0
	movl	-76(%rbp), %eax
	movl	%eax, -56(%rbp)
.L16:
	.loc 1 67 0 is_stmt 0 discriminator 1
	cmpl	$4095, -56(%rbp)
	jg	.L11
.LBB3:
	.loc 1 69 0 is_stmt 1
	movq	$0, -40(%rbp)
.LBB4:
	.loc 1 71 0
	movl	$0, -52(%rbp)
.L15:
	.loc 1 71 0 is_stmt 0 discriminator 1
	cmpl	$99, -52(%rbp)
	jg	.L12
.LBB5:
.LBB6:
	.loc 1 75 0 is_stmt 1
	movl	-76(%rbp), %eax
	addl	$1000, %eax
	movl	%eax, -48(%rbp)
.L14:
	.loc 1 75 0 is_stmt 0 discriminator 3
	cmpl	$0, -48(%rbp)
	js	.L13
	.loc 1 76 0 is_stmt 1 discriminator 2
	movl	-48(%rbp), %eax
	movl	%eax, %edx
	movq	-72(%rbp), %rax
	movb	%dl, (%rax)
	.loc 1 75 0 discriminator 2
	subl	$1, -48(%rbp)
	jmp	.L14
.L13:
.LBE6:
.LBB7:
	.loc 1 81 0 discriminator 2
	movq	-72(%rbp), %rax
	movq	%rax, %rbx
#APP
# 81 "storefor.c" 1
	rdtscp;mov %eax, %esi;mov (%rbx), %eax;rdtscp;mfence;sub %esi, %eax;mov %eax, %ecx;
# 0 "" 2
#NO_APP
	movl	%ecx, %eax
	movl	%eax, %ebx
	movl	%ebx, -60(%rbp)
.LBE7:
	.loc 1 82 0 discriminator 2
	movl	-60(%rbp), %eax
	movl	%eax, %eax
	addq	%rax, -40(%rbp)
.LBE5:
	.loc 1 71 0 discriminator 2
	addl	$1, -52(%rbp)
	jmp	.L15
.L12:
.LBE4:
	.loc 1 84 0 discriminator 2
	movl	-56(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	movq	-32(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-40(%rbp), %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	movw	%ax, (%rcx)
.LBE3:
	.loc 1 67 0 discriminator 2
	addl	$1, -56(%rbp)
	jmp	.L16
.L11:
.LBE2:
.LBB8:
	.loc 1 90 0
	movl	-76(%rbp), %eax
	movl	%eax, -44(%rbp)
.L21:
	.loc 1 90 0 is_stmt 0 discriminator 1
	cmpl	$4095, -44(%rbp)
	jg	.L23
	.loc 1 91 0 is_stmt 1
	cmpl	$4094, -44(%rbp)
	jg	.L18
	.loc 1 91 0 is_stmt 0 discriminator 1
	movl	-44(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	cmpw	$150, %ax
	jbe	.L18
	.loc 1 91 0 discriminator 2
	movl	-44(%rbp), %eax
	cltq
	addq	$1, %rax
	leaq	(%rax,%rax), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	cmpw	$130, %ax
	jbe	.L18
	.loc 1 92 0 is_stmt 1
	movl	$.LC0, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
.L18:
	.loc 1 95 0
	movl	-44(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	cmpw	$30, %ax
	jbe	.L19
	.loc 1 96 0
	movl	$.LC0, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	jmp	.L20
.L19:
	.loc 1 101 0
	movl	$.LC2, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
.L20:
	.loc 1 102 0 discriminator 2
	movl	-44(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	movl	%eax, %esi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	printf
	.loc 1 90 0 discriminator 2
	addl	$1, -44(%rbp)
	jmp	.L21
.L23:
.LBE8:
	.loc 1 104 0
	nop
	movq	-24(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L22
	call	__stack_chk_fail
.L22:
	addq	$88, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	_Z21measurement_funct_oldPhiS_, .-_Z21measurement_funct_oldPhiS_
	.section	.rodata
.LC4:
	.string	"target_add:%p\n"
	.text
	.globl	_Z18storefor_write_oldv
	.type	_Z18storefor_write_oldv, @function
_Z18storefor_write_oldv:
.LFB6:
	.loc 1 106 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	.loc 1 110 0
	movl	$16777216, %edi
	call	malloc
	movq	%rax, -8(%rbp)
	.loc 1 111 0
	movq	-8(%rbp), %rax
	movl	$16777216, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset
	.loc 1 115 0
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC4, %edi
	movl	$0, %eax
	call	printf
	.loc 1 116 0
	movq	-8(%rbp), %rdx
	movq	-8(%rbp), %rax
	movl	$64, %esi
	movq	%rax, %rdi
	call	_Z21measurement_funct_oldPhiS_
	.loc 1 120 0
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	_Z18storefor_write_oldv, .-_Z18storefor_write_oldv
	.globl	main
	.type	main, @function
main:
.LFB8:
	.loc 1 127 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	.loc 1 130 0
	call	_Z14storefor_writev
	.loc 1 133 0
	movq	stdin(%rip), %rax
	movq	%rax, %rdi
	call	fgetc
	.loc 1 134 0
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
.Letext0:
	.file 2 "/usr/lib/gcc/x86_64-linux-gnu/5/include/stddef.h"
	.file 3 "/usr/include/x86_64-linux-gnu/bits/types.h"
	.file 4 "/usr/include/libio.h"
	.file 5 "/usr/include/stdint.h"
	.file 6 "/usr/include/stdio.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x524
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.long	.LASF67
	.byte	0x4
	.long	.LASF68
	.long	.LASF69
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x2
	.long	.LASF7
	.byte	0x2
	.byte	0xd8
	.long	0x38
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.long	.LASF0
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.long	.LASF1
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.long	.LASF2
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.long	.LASF3
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF4
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.long	.LASF5
	.uleb128 0x4
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.long	.LASF6
	.uleb128 0x2
	.long	.LASF8
	.byte	0x3
	.byte	0x83
	.long	0x69
	.uleb128 0x2
	.long	.LASF9
	.byte	0x3
	.byte	0x84
	.long	0x69
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.long	.LASF10
	.uleb128 0x5
	.byte	0x8
	.uleb128 0x6
	.byte	0x8
	.long	0x95
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF11
	.uleb128 0x7
	.long	.LASF41
	.byte	0xd8
	.byte	0x4
	.byte	0xf1
	.long	0x219
	.uleb128 0x8
	.long	.LASF12
	.byte	0x4
	.byte	0xf2
	.long	0x62
	.byte	0
	.uleb128 0x8
	.long	.LASF13
	.byte	0x4
	.byte	0xf7
	.long	0x8f
	.byte	0x8
	.uleb128 0x8
	.long	.LASF14
	.byte	0x4
	.byte	0xf8
	.long	0x8f
	.byte	0x10
	.uleb128 0x8
	.long	.LASF15
	.byte	0x4
	.byte	0xf9
	.long	0x8f
	.byte	0x18
	.uleb128 0x8
	.long	.LASF16
	.byte	0x4
	.byte	0xfa
	.long	0x8f
	.byte	0x20
	.uleb128 0x8
	.long	.LASF17
	.byte	0x4
	.byte	0xfb
	.long	0x8f
	.byte	0x28
	.uleb128 0x8
	.long	.LASF18
	.byte	0x4
	.byte	0xfc
	.long	0x8f
	.byte	0x30
	.uleb128 0x8
	.long	.LASF19
	.byte	0x4
	.byte	0xfd
	.long	0x8f
	.byte	0x38
	.uleb128 0x8
	.long	.LASF20
	.byte	0x4
	.byte	0xfe
	.long	0x8f
	.byte	0x40
	.uleb128 0x9
	.long	.LASF21
	.byte	0x4
	.value	0x100
	.long	0x8f
	.byte	0x48
	.uleb128 0x9
	.long	.LASF22
	.byte	0x4
	.value	0x101
	.long	0x8f
	.byte	0x50
	.uleb128 0x9
	.long	.LASF23
	.byte	0x4
	.value	0x102
	.long	0x8f
	.byte	0x58
	.uleb128 0x9
	.long	.LASF24
	.byte	0x4
	.value	0x104
	.long	0x251
	.byte	0x60
	.uleb128 0x9
	.long	.LASF25
	.byte	0x4
	.value	0x106
	.long	0x257
	.byte	0x68
	.uleb128 0x9
	.long	.LASF26
	.byte	0x4
	.value	0x108
	.long	0x62
	.byte	0x70
	.uleb128 0x9
	.long	.LASF27
	.byte	0x4
	.value	0x10c
	.long	0x62
	.byte	0x74
	.uleb128 0x9
	.long	.LASF28
	.byte	0x4
	.value	0x10e
	.long	0x70
	.byte	0x78
	.uleb128 0x9
	.long	.LASF29
	.byte	0x4
	.value	0x112
	.long	0x46
	.byte	0x80
	.uleb128 0x9
	.long	.LASF30
	.byte	0x4
	.value	0x113
	.long	0x54
	.byte	0x82
	.uleb128 0x9
	.long	.LASF31
	.byte	0x4
	.value	0x114
	.long	0x25d
	.byte	0x83
	.uleb128 0x9
	.long	.LASF32
	.byte	0x4
	.value	0x118
	.long	0x26d
	.byte	0x88
	.uleb128 0x9
	.long	.LASF33
	.byte	0x4
	.value	0x121
	.long	0x7b
	.byte	0x90
	.uleb128 0x9
	.long	.LASF34
	.byte	0x4
	.value	0x129
	.long	0x8d
	.byte	0x98
	.uleb128 0x9
	.long	.LASF35
	.byte	0x4
	.value	0x12a
	.long	0x8d
	.byte	0xa0
	.uleb128 0x9
	.long	.LASF36
	.byte	0x4
	.value	0x12b
	.long	0x8d
	.byte	0xa8
	.uleb128 0x9
	.long	.LASF37
	.byte	0x4
	.value	0x12c
	.long	0x8d
	.byte	0xb0
	.uleb128 0x9
	.long	.LASF38
	.byte	0x4
	.value	0x12e
	.long	0x2d
	.byte	0xb8
	.uleb128 0x9
	.long	.LASF39
	.byte	0x4
	.value	0x12f
	.long	0x62
	.byte	0xc0
	.uleb128 0x9
	.long	.LASF40
	.byte	0x4
	.value	0x131
	.long	0x273
	.byte	0xc4
	.byte	0
	.uleb128 0xa
	.long	.LASF70
	.byte	0x4
	.byte	0x96
	.uleb128 0x7
	.long	.LASF42
	.byte	0x18
	.byte	0x4
	.byte	0x9c
	.long	0x251
	.uleb128 0x8
	.long	.LASF43
	.byte	0x4
	.byte	0x9d
	.long	0x251
	.byte	0
	.uleb128 0x8
	.long	.LASF44
	.byte	0x4
	.byte	0x9e
	.long	0x257
	.byte	0x8
	.uleb128 0x8
	.long	.LASF45
	.byte	0x4
	.byte	0xa2
	.long	0x62
	.byte	0x10
	.byte	0
	.uleb128 0x6
	.byte	0x8
	.long	0x220
	.uleb128 0x6
	.byte	0x8
	.long	0x9c
	.uleb128 0xb
	.long	0x95
	.long	0x26d
	.uleb128 0xc
	.long	0x86
	.byte	0
	.byte	0
	.uleb128 0x6
	.byte	0x8
	.long	0x219
	.uleb128 0xb
	.long	0x95
	.long	0x283
	.uleb128 0xc
	.long	0x86
	.byte	0x13
	.byte	0
	.uleb128 0x2
	.long	.LASF46
	.byte	0x5
	.byte	0x30
	.long	0x3f
	.uleb128 0x2
	.long	.LASF47
	.byte	0x5
	.byte	0x31
	.long	0x46
	.uleb128 0x2
	.long	.LASF48
	.byte	0x5
	.byte	0x33
	.long	0x4d
	.uleb128 0x2
	.long	.LASF49
	.byte	0x5
	.byte	0x37
	.long	0x38
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.long	.LASF50
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.long	.LASF51
	.uleb128 0xd
	.long	.LASF71
	.byte	0x1
	.byte	0x16
	.long	0x2a4
	.quad	.LFB2
	.quad	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.long	0x2fb
	.uleb128 0xe
	.string	"low"
	.byte	0x1
	.byte	0x17
	.long	0x299
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0xf
	.long	.LASF52
	.byte	0x1
	.byte	0x17
	.long	0x299
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0x10
	.long	.LASF53
	.byte	0x1
	.byte	0x2f
	.long	.LASF55
	.long	0x2a4
	.quad	.LFB3
	.quad	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.long	0x353
	.uleb128 0x11
	.string	"pp"
	.byte	0x1
	.byte	0x2f
	.long	0x8d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0xe
	.string	"rv"
	.byte	0x1
	.byte	0x32
	.long	0x62
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0xe
	.string	"p"
	.byte	0x1
	.byte	0x33
	.long	0x8d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0xe
	.string	"s"
	.byte	0x1
	.byte	0x34
	.long	0x2a4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x12
	.long	.LASF54
	.byte	0x1
	.byte	0x3d
	.long	.LASF56
	.long	0x62
	.quad	.LFB4
	.quad	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.long	0x385
	.uleb128 0x11
	.string	"i"
	.byte	0x1
	.byte	0x3d
	.long	0x62
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0x13
	.long	.LASF63
	.byte	0x1
	.byte	0x41
	.long	.LASF65
	.quad	.LFB5
	.quad	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.long	0x4c3
	.uleb128 0x14
	.long	.LASF57
	.byte	0x1
	.byte	0x41
	.long	0x4c3
	.uleb128 0x3
	.byte	0x91
	.sleb128 -88
	.uleb128 0x14
	.long	.LASF58
	.byte	0x1
	.byte	0x41
	.long	0x62
	.uleb128 0x3
	.byte	0x91
	.sleb128 -92
	.uleb128 0x14
	.long	.LASF59
	.byte	0x1
	.byte	0x41
	.long	0x4c3
	.uleb128 0x3
	.byte	0x91
	.sleb128 -104
	.uleb128 0xf
	.long	.LASF60
	.byte	0x1
	.byte	0x42
	.long	0x4c9
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x15
	.quad	.LBB2
	.quad	.LBE2-.LBB2
	.long	0x4a4
	.uleb128 0xe
	.string	"p"
	.byte	0x1
	.byte	0x43
	.long	0x62
	.uleb128 0x3
	.byte	0x91
	.sleb128 -72
	.uleb128 0x16
	.quad	.LBB3
	.quad	.LBE3-.LBB3
	.uleb128 0xf
	.long	.LASF61
	.byte	0x1
	.byte	0x45
	.long	0x2a4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x16
	.quad	.LBB4
	.quad	.LBE4-.LBB4
	.uleb128 0xe
	.string	"r"
	.byte	0x1
	.byte	0x47
	.long	0x62
	.uleb128 0x3
	.byte	0x91
	.sleb128 -68
	.uleb128 0x16
	.quad	.LBB5
	.quad	.LBE5-.LBB5
	.uleb128 0xe
	.string	"tt"
	.byte	0x1
	.byte	0x50
	.long	0x299
	.uleb128 0x3
	.byte	0x91
	.sleb128 -76
	.uleb128 0x15
	.quad	.LBB6
	.quad	.LBE6-.LBB6
	.long	0x481
	.uleb128 0xe
	.string	"i"
	.byte	0x1
	.byte	0x4b
	.long	0x62
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.byte	0
	.uleb128 0x16
	.quad	.LBB7
	.quad	.LBE7-.LBB7
	.uleb128 0xf
	.long	.LASF62
	.byte	0x1
	.byte	0x51
	.long	0x299
	.uleb128 0x1
	.byte	0x53
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x16
	.quad	.LBB8
	.quad	.LBE8-.LBB8
	.uleb128 0xe
	.string	"p"
	.byte	0x1
	.byte	0x5a
	.long	0x62
	.uleb128 0x2
	.byte	0x91
	.sleb128 -60
	.byte	0
	.byte	0
	.uleb128 0x6
	.byte	0x8
	.long	0x283
	.uleb128 0x6
	.byte	0x8
	.long	0x28e
	.uleb128 0x13
	.long	.LASF64
	.byte	0x1
	.byte	0x6a
	.long	.LASF66
	.quad	.LFB6
	.quad	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.long	0x4ff
	.uleb128 0xf
	.long	.LASF57
	.byte	0x1
	.byte	0x6d
	.long	0x4c3
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x17
	.long	.LASF72
	.byte	0x1
	.byte	0x7e
	.long	0x62
	.quad	.LFB8
	.quad	.LFE8-.LFB8
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x18
	.long	.LASF73
	.byte	0x6
	.byte	0xa8
	.long	0x257
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
	.uleb128 0x3
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
	.uleb128 0x4
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
	.uleb128 0x5
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
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
	.uleb128 0xe
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
	.uleb128 0xf
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
	.uleb128 0x10
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
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
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
	.uleb128 0x12
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
	.uleb128 0x13
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
	.uleb128 0x14
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
	.uleb128 0x15
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
	.uleb128 0x16
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.byte	0
	.byte	0
	.uleb128 0x17
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
	.uleb128 0x49
	.uleb128 0x13
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
	.uleb128 0x18
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
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
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
.LASF15:
	.string	"_IO_read_base"
.LASF41:
	.string	"_IO_FILE"
.LASF23:
	.string	"_IO_save_end"
.LASF5:
	.string	"short int"
.LASF7:
	.string	"size_t"
.LASF10:
	.string	"sizetype"
.LASF33:
	.string	"_offset"
.LASF60:
	.string	"measurementBuffer"
.LASF17:
	.string	"_IO_write_ptr"
.LASF12:
	.string	"_flags"
.LASF19:
	.string	"_IO_buf_base"
.LASF64:
	.string	"storefor_write_old"
.LASF24:
	.string	"_markers"
.LASF14:
	.string	"_IO_read_end"
.LASF46:
	.string	"uint8_t"
.LASF58:
	.string	"window_size"
.LASF55:
	.string	"_Z9probetimePv"
.LASF57:
	.string	"evictionBuffer"
.LASF54:
	.string	"calc"
.LASF50:
	.string	"long long int"
.LASF32:
	.string	"_lock"
.LASF6:
	.string	"long int"
.LASF52:
	.string	"high"
.LASF29:
	.string	"_cur_column"
.LASF45:
	.string	"_pos"
.LASF44:
	.string	"_sbuf"
.LASF28:
	.string	"_old_offset"
.LASF1:
	.string	"unsigned char"
.LASF56:
	.string	"_Z4calci"
.LASF4:
	.string	"signed char"
.LASF49:
	.string	"uint64_t"
.LASF51:
	.string	"long long unsigned int"
.LASF48:
	.string	"uint32_t"
.LASF3:
	.string	"unsigned int"
.LASF42:
	.string	"_IO_marker"
.LASF31:
	.string	"_shortbuf"
.LASF67:
	.string	"GNU C++ 5.4.0 20160609 -mtune=generic -march=x86-64 -g -O0 -fstack-protector-strong"
.LASF16:
	.string	"_IO_write_base"
.LASF40:
	.string	"_unused2"
.LASF13:
	.string	"_IO_read_ptr"
.LASF20:
	.string	"_IO_buf_end"
.LASF11:
	.string	"char"
.LASF47:
	.string	"uint16_t"
.LASF72:
	.string	"main"
.LASF65:
	.string	"_Z21measurement_funct_oldPhiS_"
.LASF43:
	.string	"_next"
.LASF34:
	.string	"__pad1"
.LASF35:
	.string	"__pad2"
.LASF36:
	.string	"__pad3"
.LASF37:
	.string	"__pad4"
.LASF38:
	.string	"__pad5"
.LASF53:
	.string	"probetime"
.LASF66:
	.string	"_Z18storefor_write_oldv"
.LASF71:
	.string	"rdtscp"
.LASF0:
	.string	"long unsigned int"
.LASF18:
	.string	"_IO_write_end"
.LASF62:
	.string	"_delta"
.LASF9:
	.string	"__off64_t"
.LASF26:
	.string	"_fileno"
.LASF2:
	.string	"short unsigned int"
.LASF25:
	.string	"_chain"
.LASF8:
	.string	"__off_t"
.LASF22:
	.string	"_IO_backup_base"
.LASF73:
	.string	"stdin"
.LASF63:
	.string	"measurement_funct_old"
.LASF59:
	.string	"target_add"
.LASF27:
	.string	"_flags2"
.LASF39:
	.string	"_mode"
.LASF69:
	.string	"/home/619501/MA_2/master-moritz_krebbel-drive_by_cache_attacks/code/c/StoreFor"
.LASF30:
	.string	"_vtable_offset"
.LASF61:
	.string	"total"
.LASF21:
	.string	"_IO_save_base"
.LASF68:
	.string	"storefor.c"
.LASF70:
	.string	"_IO_lock_t"
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.10) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
