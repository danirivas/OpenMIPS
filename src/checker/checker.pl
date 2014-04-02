#!/usr/bin/perl
# Register and LIP checker for RTL simulations
#

# Usage:
#  checker.pl elf_executable sim_executable simulation_path unit_to_simulate output_path
#

my $argc = @ARGV;
if ($argc < 6) {
    print "Usage: checker.pl elf_executable sim_executable simulation_path unit_to_simulate output_path\n";
    exit(1);
}

my $elf_executable   = $ARGV[1];
my $sim_executable   = $ARGV[2];
my $simulation_path  = $ARGV[3];
my $unit_to_simulate = $ARGV[4];
my $out_path         = $ARGV[5];


my $MODEL_ROOT = $ENV{'MODEL_ROOT'};
my $GDB_RUN_BINARY = $MODEL_ROOT . "/toolchain/bin/mips-elf-run";
my $SIM_RUN_BINARY = $ALTERA_BIN . "/vsim";

my $base=`basename $elf_executable`;

my $checker_outfile = "$out_path/checker-$base.log";
my $sim_outfile     = "$out_path/simulator-$base.log";

my $run_cmdline = $GDB_RUN_BINARY . "--memory-region 0x400000,268435456 --trace-reg=on --trace-insn=on --trace-file $checker_outfile" . $elf_executable;
my $sim_cmdline = "( cd $simulation_path; $SIM_RUN_BINARY -c -do 'run 100ns;quit' $unit_to_simulate > $sim_outfile )";

system("bash $run_cmdline");
system("bash $sim_cmdline");


