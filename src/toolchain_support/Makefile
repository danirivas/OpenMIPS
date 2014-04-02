
MODEL_ROOT_BASE=${MODEL_ROOT}
ifeq ($(MODEL_ROOT_BASE),"")
$(error MODEL_ROOT variable not set)
endif

EPATH=${MODEL_ROOT_BASE}/toolchain/bin

PREFIX=mips-elf-

AS=$(EPATH)/$(PREFIX)as
CC=$(EPATH)/$(PREFIX)gcc

all:
	$(AS) -EL -o crt0.o crt0.S
	$(CC) -EL -o sbrk.o sbrk.c

clean:
	rm -f crt0.o

