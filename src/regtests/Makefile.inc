
# MODEL_ROOT path
MODEL_ROOT_BASE=${MODEL_ROOT}
ifeq ($(strip $(MODEL_ROOT_BASE)),)
$(error MODEL_ROOT variable not set)
endif

# PATH for toolchain
EPATH=${MODEL_ROOT_BASE}/toolchain/bin

# Prefix for toolchain tools
PREFIX=mips-elf-

# Complete path for the tools
CC=$(EPATH)/$(PREFIX)gcc
CPP=$(EPATH)/$(PREFIX)g++
OBJCOPY=$(EPATH)/$(PREFIX)objcopy

# CRT0 stuff
CRT0O=${MODEL_ROOT_BASE}/src/toolchain_support/crt0.o
$(CRT0O):
	make -C ${MODEL_ROOT_BASE}/src/toolchain_support/

CFLAGS=-G0
LDFLAGS=$(CRT0O)

