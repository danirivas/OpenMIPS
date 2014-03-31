
VC=$(ALTERA_BIN)/vlog
VFLAGS=-sv

all:
	# Create RTL BUILD from scratch
	rm -rf $(RTL_BUILD)
	#mkdir -p $(RTL_BUILD)

	# Set build env
	$(ALTERA_BIN)/vlib $(RTL_BUILD)
	
	# Compile
	$(VC) $(VFLAGS) mips.v


