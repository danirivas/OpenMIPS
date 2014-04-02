
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
	make -C ${MODEL_ROOT_BASE}/src/toolchain_support/ all

CFLAGS=-G0 -EL $(CINCLUDE)
LDFLAGS=$(CRT0O) -T ${MODEL_ROOT_BASE}/src/toolchain_support/elf32.x $(CLIB) -lc -lnosys


SRCS_PATH=${MODEL_ROOT_BASE}/src/
BUILDS_PATH=${MODEL_ROOT_BASE}/build/

all:	$(CRT0O) 
	$(CC) -o $(TARGET).exe $(TARGET).c $(CFLAGS) $(LDFLAGS)
	$(OBJCOPY) -O binary -j ".start" -j ".init" -j ".fini" -j ".text" -j ".ctors" -j ".dtors" -j ".data" -j ".bss"  $(TARGET).exe $(TARGET).bin
	${MODEL_ROOT_BASE}/src/toolchain_support/memgen.sh $(TARGET).bin $(TARGET).img 

clean:
	rm -f $(TARGET).exe
	rm -f $(TARGET).bin
	rm -f $(TARGET).img

