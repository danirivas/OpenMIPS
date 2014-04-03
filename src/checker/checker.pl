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
my $rpt_outfile     = "$out_path/report-$base.log";

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

my @lips_checker;
open (FILE1, $checker_outfile);
while (<FILE1>){
    chomp;
    if ($_ =~ /^insn:[\s]+[^\s]+[\s]+0x([0-9a-f]+)/) {
        push (@lips_checker, $1);
    }
}
close(FILE1);

my @lips_sim;
open (FILE1, $sim_outfile);
while (<FILE1>){
    chomp;
    if ($_ =~ /PC:[\s]*([0-9a-fxz]+)/) {
        push (@lips_sim, $1);
    }
}
close(FILE1);

open (FILE2, ">>$rpt_outfile"); 
my $msize = @lips_sim;
if (0+$lips_sim > 0+$lips_checker) { $msize = @lips_checker; }

for ($i = 0; $i < $msize; $i++) {
    print FILE2 $lips_sim[$i] . " " . $lips_checker[$i] ."\n";
}
close(FILE2);


