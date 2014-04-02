
## Read environment variables ##
MODEL_ROOT_BASE=${MODEL_ROOT}
ifeq ($(strip $(MODEL_ROOT_BASE)),)
$(error MODEL_ROOT variable not set)
endif
ifeq ($(strip ${ALTERA_BIN}),)
$(error ALTERA_BIN variable not set)
endif

.PHONY:	toolchain_clean toolchain status regression_binaries


## General MODEL actions ##

status:
	@echo "Model status:"
	@$(MODEL_ROOT_BASE)/scripts/binutils-toolchain.sh check && (echo " - Binutils OK") || (echo " - Binutils missing")
	@$(MODEL_ROOT_BASE)/scripts/gcc-toolchain.sh check      && (echo " - GCC OK")      || (echo " - GCC missing")
	@$(MODEL_ROOT_BASE)/scripts/gdb-toolchain.sh check      && (echo " - GDB OK")      || (echo " - GDB missing")

## Compile toolchain ##

toolchain_clean:
	rm -rf toolchain
	mkdir toolchain
	./scripts/binutils-toolchain.sh clean
	./scripts/gcc-toolchain.sh clean
	./scripts/newlib-toolchain.sh clean
	./scripts/gdb-toolchain.sh clean

toolchain:
	./scripts/binutils-toolchain.sh build
	./scripts/gcc-toolchain.sh build-pre
	./scripts/newlib-toolchain.sh build
	./scripts/gcc-toolchain.sh build
	./scripts/gdb-toolchain.sh build

## Regression tests ##

regression_binaries:
	make -C $(MODEL_ROOT_BASE)/src/regtests all

regression_binaries_clean:
	make -C $(MODEL_ROOT_BASE)/src/regtests clean
	make -C $(MODEL_ROOT_BASE)/src/toolchain_support clean

regression:	regression_binaries
	(export TOP_LEVEL_CPU=simple_mips ; make -C $(MODEL_ROOT_BASE)/src/regtests regression)

## RTL model compile ##

simple_mips:
	make -C $(MODEL_ROOT_BASE)/rtl/simple_mips/ RTL_BUILD=$(MODEL_ROOT_BASE)/build/rtl/simple_mips



