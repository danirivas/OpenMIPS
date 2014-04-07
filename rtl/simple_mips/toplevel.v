
`include "mips.v"

module simple_mips_toplevel();
    reg clk, reset;
    initial clk = 0;
    initial reset = 1;
    always #(0.5ns) clk = ~clk;
    always #(10ns) reset = 0;

    simple_mips cpu(clk, reset);
endmodule

