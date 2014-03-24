
# Setup

.section .text
.extern main
 
.global _start
_start:
	# Clear BSS section
	la $t0, __bss_start
	la $t1, _end
	_bss_clear_loop:
	sw $zero, 0($t0)
	bne $t0,$t1,_bss_clear_loop
	addiu $t0, $t0, 4

	# Setup stackpointer
	lui $sp, 0x1000

	# Call program
	jal main

	# Exit! Loop forever
	_inf_loop:
	j _inf_loop

