
storefor:     Dateiformat elf64-x86-64


Disassembly of section .init:

00000000004004b8 <_init>:
  4004b8:	48 83 ec 08          	sub    $0x8,%rsp
  4004bc:	48 8b 05 35 0b 20 00 	mov    0x200b35(%rip),%rax        # 600ff8 <_DYNAMIC+0x1d0>
  4004c3:	48 85 c0             	test   %rax,%rax
  4004c6:	74 05                	je     4004cd <_init+0x15>
  4004c8:	e8 73 00 00 00       	callq  400540 <malloc@plt+0x10>
  4004cd:	48 83 c4 08          	add    $0x8,%rsp
  4004d1:	c3                   	retq   

Disassembly of section .plt:

00000000004004e0 <printf@plt-0x10>:
  4004e0:	ff 35 22 0b 20 00    	pushq  0x200b22(%rip)        # 601008 <_GLOBAL_OFFSET_TABLE_+0x8>
  4004e6:	ff 25 24 0b 20 00    	jmpq   *0x200b24(%rip)        # 601010 <_GLOBAL_OFFSET_TABLE_+0x10>
  4004ec:	0f 1f 40 00          	nopl   0x0(%rax)

00000000004004f0 <printf@plt>:
  4004f0:	ff 25 22 0b 20 00    	jmpq   *0x200b22(%rip)        # 601018 <_GLOBAL_OFFSET_TABLE_+0x18>
  4004f6:	68 00 00 00 00       	pushq  $0x0
  4004fb:	e9 e0 ff ff ff       	jmpq   4004e0 <_init+0x28>

0000000000400500 <memset@plt>:
  400500:	ff 25 1a 0b 20 00    	jmpq   *0x200b1a(%rip)        # 601020 <_GLOBAL_OFFSET_TABLE_+0x20>
  400506:	68 01 00 00 00       	pushq  $0x1
  40050b:	e9 d0 ff ff ff       	jmpq   4004e0 <_init+0x28>

0000000000400510 <fgetc@plt>:
  400510:	ff 25 12 0b 20 00    	jmpq   *0x200b12(%rip)        # 601028 <_GLOBAL_OFFSET_TABLE_+0x28>
  400516:	68 02 00 00 00       	pushq  $0x2
  40051b:	e9 c0 ff ff ff       	jmpq   4004e0 <_init+0x28>

0000000000400520 <__libc_start_main@plt>:
  400520:	ff 25 0a 0b 20 00    	jmpq   *0x200b0a(%rip)        # 601030 <_GLOBAL_OFFSET_TABLE_+0x30>
  400526:	68 03 00 00 00       	pushq  $0x3
  40052b:	e9 b0 ff ff ff       	jmpq   4004e0 <_init+0x28>

0000000000400530 <malloc@plt>:
  400530:	ff 25 02 0b 20 00    	jmpq   *0x200b02(%rip)        # 601038 <_GLOBAL_OFFSET_TABLE_+0x38>
  400536:	68 04 00 00 00       	pushq  $0x4
  40053b:	e9 a0 ff ff ff       	jmpq   4004e0 <_init+0x28>

Disassembly of section .plt.got:

0000000000400540 <.plt.got>:
  400540:	ff 25 b2 0a 20 00    	jmpq   *0x200ab2(%rip)        # 600ff8 <_DYNAMIC+0x1d0>
  400546:	66 90                	xchg   %ax,%ax

Disassembly of section .text:

0000000000400550 <_start>:
  400550:	31 ed                	xor    %ebp,%ebp
  400552:	49 89 d1             	mov    %rdx,%r9
  400555:	5e                   	pop    %rsi
  400556:	48 89 e2             	mov    %rsp,%rdx
  400559:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
  40055d:	50                   	push   %rax
  40055e:	54                   	push   %rsp
  40055f:	49 c7 c0 20 0b 40 00 	mov    $0x400b20,%r8
  400566:	48 c7 c1 b0 0a 40 00 	mov    $0x400ab0,%rcx
  40056d:	48 c7 c7 b8 06 40 00 	mov    $0x4006b8,%rdi
  400574:	e8 a7 ff ff ff       	callq  400520 <__libc_start_main@plt>
  400579:	f4                   	hlt    
  40057a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000400580 <deregister_tm_clones>:
  400580:	b8 57 10 60 00       	mov    $0x601057,%eax
  400585:	55                   	push   %rbp
  400586:	48 2d 50 10 60 00    	sub    $0x601050,%rax
  40058c:	48 83 f8 0e          	cmp    $0xe,%rax
  400590:	48 89 e5             	mov    %rsp,%rbp
  400593:	76 1b                	jbe    4005b0 <deregister_tm_clones+0x30>
  400595:	b8 00 00 00 00       	mov    $0x0,%eax
  40059a:	48 85 c0             	test   %rax,%rax
  40059d:	74 11                	je     4005b0 <deregister_tm_clones+0x30>
  40059f:	5d                   	pop    %rbp
  4005a0:	bf 50 10 60 00       	mov    $0x601050,%edi
  4005a5:	ff e0                	jmpq   *%rax
  4005a7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  4005ae:	00 00 
  4005b0:	5d                   	pop    %rbp
  4005b1:	c3                   	retq   
  4005b2:	0f 1f 40 00          	nopl   0x0(%rax)
  4005b6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  4005bd:	00 00 00 

00000000004005c0 <register_tm_clones>:
  4005c0:	be 50 10 60 00       	mov    $0x601050,%esi
  4005c5:	55                   	push   %rbp
  4005c6:	48 81 ee 50 10 60 00 	sub    $0x601050,%rsi
  4005cd:	48 c1 fe 03          	sar    $0x3,%rsi
  4005d1:	48 89 e5             	mov    %rsp,%rbp
  4005d4:	48 89 f0             	mov    %rsi,%rax
  4005d7:	48 c1 e8 3f          	shr    $0x3f,%rax
  4005db:	48 01 c6             	add    %rax,%rsi
  4005de:	48 d1 fe             	sar    %rsi
  4005e1:	74 15                	je     4005f8 <register_tm_clones+0x38>
  4005e3:	b8 00 00 00 00       	mov    $0x0,%eax
  4005e8:	48 85 c0             	test   %rax,%rax
  4005eb:	74 0b                	je     4005f8 <register_tm_clones+0x38>
  4005ed:	5d                   	pop    %rbp
  4005ee:	bf 50 10 60 00       	mov    $0x601050,%edi
  4005f3:	ff e0                	jmpq   *%rax
  4005f5:	0f 1f 00             	nopl   (%rax)
  4005f8:	5d                   	pop    %rbp
  4005f9:	c3                   	retq   
  4005fa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000400600 <__do_global_dtors_aux>:
  400600:	80 3d 51 0a 20 00 00 	cmpb   $0x0,0x200a51(%rip)        # 601058 <completed.7594>
  400607:	75 11                	jne    40061a <__do_global_dtors_aux+0x1a>
  400609:	55                   	push   %rbp
  40060a:	48 89 e5             	mov    %rsp,%rbp
  40060d:	e8 6e ff ff ff       	callq  400580 <deregister_tm_clones>
  400612:	5d                   	pop    %rbp
  400613:	c6 05 3e 0a 20 00 01 	movb   $0x1,0x200a3e(%rip)        # 601058 <completed.7594>
  40061a:	f3 c3                	repz retq 
  40061c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000400620 <frame_dummy>:
  400620:	bf 20 0e 60 00       	mov    $0x600e20,%edi
  400625:	48 83 3f 00          	cmpq   $0x0,(%rdi)
  400629:	75 05                	jne    400630 <frame_dummy+0x10>
  40062b:	eb 93                	jmp    4005c0 <register_tm_clones>
  40062d:	0f 1f 00             	nopl   (%rax)
  400630:	b8 00 00 00 00       	mov    $0x0,%eax
  400635:	48 85 c0             	test   %rax,%rax
  400638:	74 f1                	je     40062b <frame_dummy+0xb>
  40063a:	55                   	push   %rbp
  40063b:	48 89 e5             	mov    %rsp,%rbp
  40063e:	ff d0                	callq  *%rax
  400640:	5d                   	pop    %rbp
  400641:	e9 7a ff ff ff       	jmpq   4005c0 <register_tm_clones>

0000000000400646 <_ZL6rdtscpv>:
  400646:	55                   	push   %rbp
  400647:	48 89 e5             	mov    %rsp,%rbp
  40064a:	0f 31                	rdtsc  
  40064c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  40064f:	89 55 fc             	mov    %edx,-0x4(%rbp)
  400652:	8b 45 fc             	mov    -0x4(%rbp),%eax
  400655:	48 c1 e0 20          	shl    $0x20,%rax
  400659:	48 89 c2             	mov    %rax,%rdx
  40065c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  40065f:	48 09 d0             	or     %rdx,%rax
  400662:	5d                   	pop    %rbp
  400663:	c3                   	retq   

0000000000400664 <_Z9probetimePv>:
  400664:	55                   	push   %rbp
  400665:	48 89 e5             	mov    %rsp,%rbp
  400668:	48 83 ec 28          	sub    $0x28,%rsp
  40066c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  400670:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  400675:	75 07                	jne    40067e <_Z9probetimePv+0x1a>
  400677:	b8 00 00 00 00       	mov    $0x0,%eax
  40067c:	eb 38                	jmp    4006b6 <_Z9probetimePv+0x52>
  40067e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  400685:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  400689:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  40068d:	e8 b4 ff ff ff       	callq  400646 <_ZL6rdtscpv>
  400692:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  400696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  40069a:	48 8b 00             	mov    (%rax),%rax
  40069d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  4006a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  4006a5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  4006a9:	74 02                	je     4006ad <_Z9probetimePv+0x49>
  4006ab:	eb e9                	jmp    400696 <_Z9probetimePv+0x32>
  4006ad:	e8 94 ff ff ff       	callq  400646 <_ZL6rdtscpv>
  4006b2:	48 2b 45 f8          	sub    -0x8(%rbp),%rax
  4006b6:	c9                   	leaveq 
  4006b7:	c3                   	retq   

00000000004006b8 <main>:
  4006b8:	55                   	push   %rbp
  4006b9:	48 89 e5             	mov    %rsp,%rbp
  4006bc:	e8 91 03 00 00       	callq  400a52 <_Z14storefor_writev>
  4006c1:	48 8b 05 88 09 20 00 	mov    0x200988(%rip),%rax        # 601050 <__TMC_END__>
  4006c8:	48 89 c7             	mov    %rax,%rdi
  4006cb:	e8 40 fe ff ff       	callq  400510 <fgetc@plt>
  4006d0:	b8 00 00 00 00       	mov    $0x0,%eax
  4006d5:	5d                   	pop    %rbp
  4006d6:	c3                   	retq   

00000000004006d7 <_Z12measure_readPv>:
  4006d7:	55                   	push   %rbp
  4006d8:	48 89 e5             	mov    %rsp,%rbp
  4006db:	53                   	push   %rbx
  4006dc:	48 89 7d f0          	mov    %rdi,-0x10(%rbp)
  4006e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  4006e4:	48 89 c3             	mov    %rax,%rbx
  4006e7:	0f 31                	rdtsc  
  4006e9:	89 c6                	mov    %eax,%esi
  4006eb:	8b 03                	mov    (%rbx),%eax
  4006ed:	0f ae e8             	lfence 
  4006f0:	0f 31                	rdtsc  
  4006f2:	29 f0                	sub    %esi,%eax
  4006f4:	89 c1                	mov    %eax,%ecx
  4006f6:	89 c8                	mov    %ecx,%eax
  4006f8:	89 c3                	mov    %eax,%ebx
  4006fa:	89 d8                	mov    %ebx,%eax
  4006fc:	5b                   	pop    %rbx
  4006fd:	5d                   	pop    %rbp
  4006fe:	c3                   	retq   

00000000004006ff <_Z3blaPj>:
  4006ff:	55                   	push   %rbp
  400700:	48 89 e5             	mov    %rsp,%rbp
  400703:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  400707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  40070b:	8b 00                	mov    (%rax),%eax
  40070d:	8d 50 01             	lea    0x1(%rax),%edx
  400710:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  400714:	89 10                	mov    %edx,(%rax)
  400716:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  40071a:	8b 00                	mov    (%rax),%eax
  40071c:	8d 50 01             	lea    0x1(%rax),%edx
  40071f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  400723:	89 10                	mov    %edx,(%rax)
  400725:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  400729:	8b 00                	mov    (%rax),%eax
  40072b:	8d 50 01             	lea    0x1(%rax),%edx
  40072e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  400732:	89 10                	mov    %edx,(%rax)
  400734:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  400738:	8b 00                	mov    (%rax),%eax
  40073a:	8d 50 01             	lea    0x1(%rax),%edx
  40073d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  400741:	89 10                	mov    %edx,(%rax)
  400743:	90                   	nop
  400744:	5d                   	pop    %rbp
  400745:	c3                   	retq   

0000000000400746 <_Z16measure_read_altPv>:
  400746:	55                   	push   %rbp
  400747:	48 89 e5             	mov    %rsp,%rbp
  40074a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  40074e:	0f 31                	rdtsc  
  400750:	89 45 f4             	mov    %eax,-0xc(%rbp)
  400753:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  400757:	8b 00                	mov    (%rax),%eax
  400759:	89 45 f8             	mov    %eax,-0x8(%rbp)
  40075c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400760:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400764:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400768:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  40076c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400770:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400774:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400778:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  40077c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400780:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400784:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400788:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  40078c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400790:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400794:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400798:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  40079c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007a0:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007a4:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007a8:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007ac:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007b0:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007b4:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007b8:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007bc:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007c0:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007c4:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007c8:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007cc:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007d0:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007d4:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007d8:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007dc:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007e0:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007e4:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007e8:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007ec:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007f0:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007f4:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007f8:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  4007fc:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400800:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400804:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400808:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  40080c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400810:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400814:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400818:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  40081c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400820:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400824:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400828:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  40082c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400830:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400834:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400838:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  40083c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400840:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400844:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400848:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  40084c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  400850:	0f 31                	rdtsc  
  400852:	89 45 fc             	mov    %eax,-0x4(%rbp)
  400855:	8b 45 fc             	mov    -0x4(%rbp),%eax
  400858:	2b 45 f4             	sub    -0xc(%rbp),%eax
  40085b:	5d                   	pop    %rbp
  40085c:	c3                   	retq   

000000000040085d <_Z17measurement_functPhiS_>:
  40085d:	55                   	push   %rbp
  40085e:	48 89 e5             	mov    %rsp,%rbp
  400861:	48 83 ec 50          	sub    $0x50,%rsp
  400865:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  400869:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  40086c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  400870:	b8 00 20 00 00       	mov    $0x2000,%eax
  400875:	48 89 c7             	mov    %rax,%rdi
  400878:	e8 b3 fc ff ff       	callq  400530 <malloc@plt>
  40087d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  400881:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  400884:	89 45 d8             	mov    %eax,-0x28(%rbp)
  400887:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%rbp)
  40088e:	0f 8f a6 01 00 00    	jg     400a3a <_Z17measurement_functPhiS_+0x1dd>
  400894:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  40089b:	00 
  40089c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  4008a3:	83 7d dc 63          	cmpl   $0x63,-0x24(%rbp)
  4008a7:	7f 42                	jg     4008eb <_Z17measurement_functPhiS_+0x8e>
  4008a9:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  4008ac:	89 45 e0             	mov    %eax,-0x20(%rbp)
  4008af:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  4008b3:	78 1e                	js     4008d3 <_Z17measurement_functPhiS_+0x76>
  4008b5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  4008b8:	2b 45 e0             	sub    -0x20(%rbp),%eax
  4008bb:	c1 e0 0c             	shl    $0xc,%eax
  4008be:	48 63 d0             	movslq %eax,%rdx
  4008c1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  4008c5:	48 01 d0             	add    %rdx,%rax
  4008c8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  4008cb:	88 10                	mov    %dl,(%rax)
  4008cd:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  4008d1:	eb dc                	jmp    4008af <_Z17measurement_functPhiS_+0x52>
  4008d3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  4008d7:	48 89 c7             	mov    %rax,%rdi
  4008da:	e8 67 fe ff ff       	callq  400746 <_Z16measure_read_altPv>
  4008df:	89 c0                	mov    %eax,%eax
  4008e1:	48 01 45 f0          	add    %rax,-0x10(%rbp)
  4008e5:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  4008e9:	eb b8                	jmp    4008a3 <_Z17measurement_functPhiS_+0x46>
  4008eb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  4008ee:	48 98                	cltq   
  4008f0:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
  4008f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  4008f8:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  4008fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  400900:	48 c1 e8 02          	shr    $0x2,%rax
  400904:	48 ba c3 f5 28 5c 8f 	movabs $0x28f5c28f5c28f5c3,%rdx
  40090b:	c2 f5 28 
  40090e:	48 f7 e2             	mul    %rdx
  400911:	48 89 d0             	mov    %rdx,%rax
  400914:	48 c1 e8 02          	shr    $0x2,%rax
  400918:	66 89 01             	mov    %ax,(%rcx)
  40091b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  40091e:	48 98                	cltq   
  400920:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
  400924:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  400928:	48 01 d0             	add    %rdx,%rax
  40092b:	0f b7 00             	movzwl (%rax),%eax
  40092e:	0f b7 c0             	movzwl %ax,%eax
  400931:	89 c6                	mov    %eax,%esi
  400933:	bf 34 0b 40 00       	mov    $0x400b34,%edi
  400938:	b8 00 00 00 00       	mov    $0x0,%eax
  40093d:	e8 ae fb ff ff       	callq  4004f0 <printf@plt>
  400942:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  400949:	00 
  40094a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  400951:	83 7d e4 63          	cmpl   $0x63,-0x1c(%rbp)
  400955:	7f 42                	jg     400999 <_Z17measurement_functPhiS_+0x13c>
  400957:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  40095a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  40095d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  400961:	78 1e                	js     400981 <_Z17measurement_functPhiS_+0x124>
  400963:	8b 45 d8             	mov    -0x28(%rbp),%eax
  400966:	2b 45 e8             	sub    -0x18(%rbp),%eax
  400969:	c1 e0 0c             	shl    $0xc,%eax
  40096c:	48 63 d0             	movslq %eax,%rdx
  40096f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  400973:	48 01 d0             	add    %rdx,%rax
  400976:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  400979:	88 10                	mov    %dl,(%rax)
  40097b:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  40097f:	eb dc                	jmp    40095d <_Z17measurement_functPhiS_+0x100>
  400981:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  400985:	48 89 c7             	mov    %rax,%rdi
  400988:	e8 4a fd ff ff       	callq  4006d7 <_Z12measure_readPv>
  40098d:	89 c0                	mov    %eax,%eax
  40098f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
  400993:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  400997:	eb b8                	jmp    400951 <_Z17measurement_functPhiS_+0xf4>
  400999:	8b 45 d8             	mov    -0x28(%rbp),%eax
  40099c:	48 98                	cltq   
  40099e:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
  4009a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  4009a6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  4009aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  4009ae:	48 c1 e8 02          	shr    $0x2,%rax
  4009b2:	48 ba c3 f5 28 5c 8f 	movabs $0x28f5c28f5c28f5c3,%rdx
  4009b9:	c2 f5 28 
  4009bc:	48 f7 e2             	mul    %rdx
  4009bf:	48 89 d0             	mov    %rdx,%rax
  4009c2:	48 c1 e8 02          	shr    $0x2,%rax
  4009c6:	66 89 01             	mov    %ax,(%rcx)
  4009c9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  4009cc:	48 98                	cltq   
  4009ce:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
  4009d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  4009d6:	48 01 d0             	add    %rdx,%rax
  4009d9:	0f b7 00             	movzwl (%rax),%eax
  4009dc:	66 3d 2c 01          	cmp    $0x12c,%ax
  4009e0:	76 14                	jbe    4009f6 <_Z17measurement_functPhiS_+0x199>
  4009e2:	be 37 0b 40 00       	mov    $0x400b37,%esi
  4009e7:	bf 3d 0b 40 00       	mov    $0x400b3d,%edi
  4009ec:	b8 00 00 00 00       	mov    $0x0,%eax
  4009f1:	e8 fa fa ff ff       	callq  4004f0 <printf@plt>
  4009f6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  4009f9:	48 98                	cltq   
  4009fb:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
  4009ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  400a03:	48 01 d0             	add    %rdx,%rax
  400a06:	0f b7 00             	movzwl (%rax),%eax
  400a09:	0f b7 c0             	movzwl %ax,%eax
  400a0c:	89 c6                	mov    %eax,%esi
  400a0e:	bf 40 0b 40 00       	mov    $0x400b40,%edi
  400a13:	b8 00 00 00 00       	mov    $0x0,%eax
  400a18:	e8 d3 fa ff ff       	callq  4004f0 <printf@plt>
  400a1d:	be 46 0b 40 00       	mov    $0x400b46,%esi
  400a22:	bf 3d 0b 40 00       	mov    $0x400b3d,%edi
  400a27:	b8 00 00 00 00       	mov    $0x0,%eax
  400a2c:	e8 bf fa ff ff       	callq  4004f0 <printf@plt>
  400a31:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  400a35:	e9 4d fe ff ff       	jmpq   400887 <_Z17measurement_functPhiS_+0x2a>
  400a3a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  400a3d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  400a40:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
  400a47:	7f 06                	jg     400a4f <_Z17measurement_functPhiS_+0x1f2>
  400a49:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  400a4d:	eb f1                	jmp    400a40 <_Z17measurement_functPhiS_+0x1e3>
  400a4f:	90                   	nop
  400a50:	c9                   	leaveq 
  400a51:	c3                   	retq   

0000000000400a52 <_Z14storefor_writev>:
  400a52:	55                   	push   %rbp
  400a53:	48 89 e5             	mov    %rsp,%rbp
  400a56:	48 83 ec 10          	sub    $0x10,%rsp
  400a5a:	bf 00 00 00 01       	mov    $0x1000000,%edi
  400a5f:	e8 cc fa ff ff       	callq  400530 <malloc@plt>
  400a64:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  400a68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  400a6c:	ba 00 00 00 01       	mov    $0x1000000,%edx
  400a71:	be 00 00 00 00       	mov    $0x0,%esi
  400a76:	48 89 c7             	mov    %rax,%rdi
  400a79:	e8 82 fa ff ff       	callq  400500 <memset@plt>
  400a7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  400a82:	48 89 c6             	mov    %rax,%rsi
  400a85:	bf 4b 0b 40 00       	mov    $0x400b4b,%edi
  400a8a:	b8 00 00 00 00       	mov    $0x0,%eax
  400a8f:	e8 5c fa ff ff       	callq  4004f0 <printf@plt>
  400a94:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  400a98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  400a9c:	be 40 00 00 00       	mov    $0x40,%esi
  400aa1:	48 89 c7             	mov    %rax,%rdi
  400aa4:	e8 b4 fd ff ff       	callq  40085d <_Z17measurement_functPhiS_>
  400aa9:	90                   	nop
  400aaa:	c9                   	leaveq 
  400aab:	c3                   	retq   
  400aac:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000400ab0 <__libc_csu_init>:
  400ab0:	41 57                	push   %r15
  400ab2:	41 56                	push   %r14
  400ab4:	41 89 ff             	mov    %edi,%r15d
  400ab7:	41 55                	push   %r13
  400ab9:	41 54                	push   %r12
  400abb:	4c 8d 25 4e 03 20 00 	lea    0x20034e(%rip),%r12        # 600e10 <__frame_dummy_init_array_entry>
  400ac2:	55                   	push   %rbp
  400ac3:	48 8d 2d 4e 03 20 00 	lea    0x20034e(%rip),%rbp        # 600e18 <__init_array_end>
  400aca:	53                   	push   %rbx
  400acb:	49 89 f6             	mov    %rsi,%r14
  400ace:	49 89 d5             	mov    %rdx,%r13
  400ad1:	4c 29 e5             	sub    %r12,%rbp
  400ad4:	48 83 ec 08          	sub    $0x8,%rsp
  400ad8:	48 c1 fd 03          	sar    $0x3,%rbp
  400adc:	e8 d7 f9 ff ff       	callq  4004b8 <_init>
  400ae1:	48 85 ed             	test   %rbp,%rbp
  400ae4:	74 20                	je     400b06 <__libc_csu_init+0x56>
  400ae6:	31 db                	xor    %ebx,%ebx
  400ae8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  400aef:	00 
  400af0:	4c 89 ea             	mov    %r13,%rdx
  400af3:	4c 89 f6             	mov    %r14,%rsi
  400af6:	44 89 ff             	mov    %r15d,%edi
  400af9:	41 ff 14 dc          	callq  *(%r12,%rbx,8)
  400afd:	48 83 c3 01          	add    $0x1,%rbx
  400b01:	48 39 eb             	cmp    %rbp,%rbx
  400b04:	75 ea                	jne    400af0 <__libc_csu_init+0x40>
  400b06:	48 83 c4 08          	add    $0x8,%rsp
  400b0a:	5b                   	pop    %rbx
  400b0b:	5d                   	pop    %rbp
  400b0c:	41 5c                	pop    %r12
  400b0e:	41 5d                	pop    %r13
  400b10:	41 5e                	pop    %r14
  400b12:	41 5f                	pop    %r15
  400b14:	c3                   	retq   
  400b15:	90                   	nop
  400b16:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  400b1d:	00 00 00 

0000000000400b20 <__libc_csu_fini>:
  400b20:	f3 c3                	repz retq 

Disassembly of section .fini:

0000000000400b24 <_fini>:
  400b24:	48 83 ec 08          	sub    $0x8,%rsp
  400b28:	48 83 c4 08          	add    $0x8,%rsp
  400b2c:	c3                   	retq   
