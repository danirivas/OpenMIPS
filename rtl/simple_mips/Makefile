
VC=$(ALTERA_BIN)/vlog -work $(RTL_BUILD)/work
VFLAGS=-sv

all:
	# Create RTL BUILD from scratch
	rm -rf $(RTL_BUILD)
	mkdir -p $(RTL_BUILD)

	# Set build env
	(cd $(RTL_BUILD); $(ALTERA_BIN)/vlib work)
	
	# Compile
	$(VC) $(VFLAGS) toplevel.v

regression:
	# Simulate 
	
