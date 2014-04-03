#!/usr/bin/perl
# Register and LIP checker for RTL simulations
#

# Usage:
#  checker.pl elf_executable sim_executable simulation_path unit_to_simulate output_path
#

my $argc = @ARGV;
if ($argc < 5) {
    print "Usage: checker.pl elf_executable sim_executable simulation_path unit_to_simulate output_path\n";
    exit(1);
}

print "Args $ARGV[0] $ARGV[1] $ARGV[2] $ARGV[3] $ARGV[4]\n";

my $elf_executable   = `readlink -nf $ARGV[0]`;
my $sim_executable   = `readlink -nf $ARGV[1]`;
my $simulation_path  = `readlink -nf $ARGV[2]`;
my $unit_to_simulate = $ARGV[3];
my $out_path         = `readlink -nf $ARGV[4]`;

system("bash -c \"mkdir -p $out_path\"");

my $MODEL_ROOT = $ENV{'MODEL_ROOT'};
my $GDB_RUN_BINARY = $MODEL_ROOT . "/toolchain/bin/mips-elf-run";
my $SIM_RUN_BINARY = $ENV{'ALTERA_BIN'} . "/vsim";

my $base=`basename $elf_executable | tr -d '\n'`;

my $checker_outfile = "$out_path/checker-$base.log";
my $sim_outfile     = "$out_path/simulator-$base.log";

my $run_cmdline = $GDB_RUN_BINARY . " --memory-region 0x100000,0x100000 --trace-reg=on --trace-insn=on --trace-file $checker_outfile $elf_executable ";
my $sim_cmdline = "( cd $simulation_path; $SIM_RUN_BINARY -c -do 'run 100ns;quit' $unit_to_simulate > $sim_outfile )";

print "$run_cmdline\n";
system("bash -c \"$run_cmdline\"");
print "$sim_cmdline\n";
system("bash -c \"$sim_cmdline\"");

# Now proceed to parse the output logs and compare. Generate a report :)
#

# Example of LIP + reg output
# insn:     mips.igen:2361 0x400000 lui r29, 0x1000          - LUI
# reg:      mips.igen:2361 0x400000 lui r29, 0x1000          -                                  :: 0x0000001d 0x10000000

open (FILE1, $checker_outfile);
while (<FILE1>){
    chomp;
    if ($_ =~ /^insn:[\s]+[^\s]+[\s]+([0-9x]+)/) {
        #print $_;
    }
}
close(FILE1);




