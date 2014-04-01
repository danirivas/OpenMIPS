
`include "constants.vh"


module cpu_top_level();
    reg clk, reset;
    initial clk = 0;
    initial reset = 1;
    always #(0.5ns) clk = ~clk;
    always #(10ns) reset = 0;

    simple_mips cpu(clk, reset);
endmodule

module simple_mips(clk, reset);

input clk, reset;

// Instruction fetch
reg [31:0] current_pc;
reg is_delay_slot;
wire next_is_delay_slot;

wire [31:0] next_pc_seq;
wire [31:0] next_pc;
wire [31:0] target_jump;
assign next_pc_seq = current_pc + 32'h4;
assign next_pc = is_delay_slot ? target_jump : next_pc_seq;

always @ (posedge clk) begin
	if (reset) begin
		current_pc <= 32'h00400000;  // This is the reset LIP
		is_delay_slot <= 0;
	end
	else begin
		current_pc <= next_pc;
		is_delay_slot <= next_is_delay_slot;
	end
end

wire [31:0] encoded_inst;

// Instruction decoding

wire [5:0]  opcode;
wire [4:0]  rs, rt, rd;
wire [4:0]  sa;
wire [5:0]  func;
wire [15:0] imm;

assign opcode = encoded_inst [31:26];
assign sa     = encoded_inst [10: 6];
assign func   = encoded_inst [5 : 0];
assign rs     = encoded_inst [25:21];
assign rt     = encoded_inst [20:16];
assign rd     = encoded_inst [15:11];
assign imm    = encoded_inst [15: 0];

reg [4:0] ra, rb, rc;
always @ (*) begin
	case (opcode)
	`OP_RTYPE: begin
		case (func)
		`FUNC_SLL, `FUNC_SRL, `FUNC_SRA: begin
			ra <= rt;
			rb <= 5'b0;
			rc <= rd;
		end
		`FUNC_SLLV, `FUNC_SRLV, `FUNC_SRAV: begin
			ra <= rt;
			rb <= rs;
			rc <= rd;
        end
		`FUNC_JR: begin
			ra <= rs;
			rb <= 5'b0;
			rc <= 5'b0;
        end
		`FUNC_JALR: begin
			ra <= rs;
			rb <= 5'b0;
			rc <= 5'h1f;
        end
        `FUNC_ADD, `FUNC_ADDU, `FUNC_SUB, `FUNC_SUBU, `FUNC_AND, FUNC_OR, `FUNC_XOR, `FUNC_NOR, `FUNC_SLT, `FUNC_SLTU: begin
			ra <= rs;
			rb <= rt;
			rc <= rd;
		end
        default: begin
			ra <= 5'b0;
			rb <= 5'b0;
			rc <= 5'b0;
		end
		endcase;
    `OP_ADDI, `OP_ADDIU, `OP_SLTI, `OP_SLTIU, `OP_ANDI, `OP_ORI, `OP_XORI, `OP_LW, `OP_LB, `OP_LBU, `OP_LH, `OP_LHU: begin
		ra <= rs;
		rb <= 5'b0;
		rc <= rt;
	end
    `OP_LUI: begin
		ra <= 5'b0;
		rb <= 5'b0;
		rc <= rt;
	end
    `OP_JUMP: begin
		ra <= 5'b0;
		rb <= 5'b0;
		rc <= 5'b0;
	end
    `OP_JAL: begin
		ra <= 5'b0;
		rb <= 5'b0;
		rc <= 5'h1f;
	end
    `OP_SW, `OP_SB: begin
		ra <= rs;
		rb <= rt;
		rc <= 5'b0;
    end
    default: begin
        ra <= 5'b0;
        rb <= 5'b0;
        rc <= 5'b0;
    end
	endcase;
end;

 // Jumps & delay slot
wire is_jump;
wire is_jump_and_link;

assign is_jump =   (opcode == `OP_RTYPE && (func == `FUNC_JR || func == `FUNC_JALR)) ||
					opcode == `OP_JUMP || opcode == `OP_JAL || opcode == `OP_BEQ || opcode == `OP_BNE ||
					opcode == `OP_BRANCH || opcode == `OP_BLEZ || opcode == `OP_BGTZ;
assign next_is_delay_slot = is_jump;
assign is_jump_and_link =   (opcode == `OP_RTYPE && func == `FUNC_JALR) || opcode == `OP_JAL;  // Some cases missing


// Operand read
reg [31:0] reg_bank [31:1];
wire [31:0] opA, opB;
assign opA = (ra != 5'b0) ? reg_bank[ra] : 32'b0;
assign opB = (rb != 5'b0) ? reg_bank[rb] : 32'b0;

// Execution


// Memory load or store


// Writeback
wire [31:0] wb_bus;
always @ (posedge clk) begin
	if (reset) begin
		for (int i = 1; i < 32; i++) begin
			reg_bank[i] = 32'b0;
		end
	end
	else begin
		if (rc != 5'b0)
			reg_bank[rc] = wb_bus;
	end
end


// Output for checker
reg [63:0] cycle_count;
always @ (posedge clk) begin
    if (reset) begin
        cycle_count <= 64'b0;
        $display("Reset going on...");
    end
    else begin
        $display(cycle_count, " ", rc);
        cycle_count <= cycle_count + 1;
    end
end

endmodule


