
# Setup

.section .start,"ax",@progbits
.extern main
 
.global _start
_start:
    .set noreorder
	# Setup stackpointer
	la $sp, 0x200000
    # Setup GP
    la $gp, _gp

    # Call initialization
    # This clears bss, calls C++ constructors...
    jal _init
    nop

	# Call program
	jal main
    nop

    # Call destructors and other stuff
    jal _fini
    nop

	# Exit! Loop forever
    break
    nop
    nop
	_inf_loop:
	j _inf_loop
    nop
    nop
    nop

