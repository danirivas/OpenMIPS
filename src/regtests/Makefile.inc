
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
LD=$(EPATH)/$(PREFIX)ld
CPP=$(EPATH)/$(PREFIX)g++
OBJCOPY=$(EPATH)/$(PREFIX)objcopy
OBJDUMP=$(EPATH)/$(PREFIX)objdump

# CRT0 stuff
CRT0O=${MODEL_ROOT_BASE}/src/toolchain_support/crt0.o
$(CRT0O):
	make -C ${MODEL_ROOT_BASE}/src/toolchain_support/ all

CFLAGS=-G0 -EL $(CINCLUDE)
LDFLAGS=$(CRT0O) -T ${MODEL_ROOT_BASE}/src/toolchain_support/elf32.x $(CLIB) -lc -lnosys


SRCS_PATH=${MODEL_ROOT_BASE}/src/
BUILDS_PATH=${MODEL_ROOT_BASE}/build/

all:	$(CRT0O) 
	$(CC) -o $(TARGET).exe -Wl,-Map=$(TARGET).map $(TARGET).c $(CFLAGS) $(LDFLAGS)
	$(OBJCOPY) -O binary -j ".start" -j ".init" -j ".text" -j ".fini" -j ".eh_frame" -j ".ctors" -j ".dtors" -j ".jcr" -j ".data" -j ".sdata" -j ".bss"  $(TARGET).exe $(TARGET).bin
	${MODEL_ROOT_BASE}/src/toolchain_support/memgen.sh $(TARGET).bin $(TARGET).img 

regression:
	$(MODEL_ROOT_BASE)/src/checker/checker.pl $(TARGET).exe $(TARGET).bin $(MODEL_ROOT_BASE)/build/rtl/$(TOP_LEVEL_CPU)/ $(TOP_LEVEL_CPU)_toplevel $(MODEL_ROOT_BASE)/regression/$(TOP_LEVEL_CPU)

clean:
	rm -f $(TARGET).exe
	rm -f $(TARGET).bin
	rm -f $(TARGET).img

