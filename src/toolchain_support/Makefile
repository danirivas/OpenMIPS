
MODEL_ROOT_BASE=${MODEL_ROOT}
ifeq ($(MODEL_ROOT_BASE),"")
$(error MODEL_ROOT variable not set)
endif

EPATH=${MODEL_ROOT_BASE}/toolchain/bin

PREFIX=mips-elf-

AS=$(EPATH)/$(PREFIX)as

all:
	$(AS) -o crt0.o crt0.S

clean:
	rm -f crt0.o

