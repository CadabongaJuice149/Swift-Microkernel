/* Multiboot header for Mach-Swift Microkernel */

.section .multiboot
.align 4
.long 0x1BADB002        /* MULTIBOOT_HEADER_MAGIC */
.long 0x00000003        /* MULTIBOOT_HEADER_FLAGS */
.long 0xE4524FFB        /* MULTIBOOT_CHECKSUM = -(0x1BADB002 + 0x00000003) */

.section .text
.global _start
_start:
    /* Set up a basic stack */
    mov $stack_top, %esp
    
    /* Call the Swift kernel entry point */
    call kernel_main
    
    /* Halt if the kernel returns */
loop:
    hlt
    jmp loop

.section .bss
.align 16
stack_bottom:
.skip 16384 /* 16 KiB stack */
stack_top:
