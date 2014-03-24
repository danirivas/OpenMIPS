
OpenMIPS
========

MIPS SoC processor

Environment
-----------

To use the environment the MODEL_ROOT environment variable has to be set pointing
to the root folder of the repository (you can "source setroot.sh").

To properly build regression tests you need a GCC/binutils toolchain. You can do this
by doing "make toolchain" (and "make toolchain_clean" to cleanup unneeded object files).

Regression tests can be compiled by doing a "make regression_binaries".

