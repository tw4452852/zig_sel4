.section .text
.global _start
_start:
	ldr x19, =__stack_top
	add sp, x19, #0
	bl main
	/* should not return */
1:
	b 1b

.section .bss
__stack_base:
	.align 16
	.space 0x1000
__stack_top: