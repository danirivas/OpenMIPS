
include ../Makefile.inc

TARGET=hello_world

all:	$(CRT0O)
	$(CC) -o $(TARGET).exe $(TARGET).c $(CFLAGS) $(LDFLAGS)
	$(OBJCOPY) -O binary -j ".start" -j ".init" -j ".fini" -j ".text" -j ".ctors" -j ".dtors" -j ".data" -j ".bss"  $(TARGET).exe $(TARGET).bin

clean:
	rm -f $(TARGET).exe
	rm -f $(TARGET).bin
