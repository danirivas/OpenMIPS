
Regression tests environment
----------------------------

Regression tests run at bare-metal environment, therefore
they have teir own setup code to properly setup CPU as needed.

The memory map is as follows:

.text  0x400000
.data  (continues, aligned)
.bss   (continue, aligned)

.stack 0x10000000 (grows downwards)

Tests can use up to 256MB aprox. for test+data+stack

