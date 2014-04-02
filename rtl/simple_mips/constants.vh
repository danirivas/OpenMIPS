
`define OP_RTYPE   6'b000000
`define OP_BRANCH  6'b000001
`define OP_JUMP    6'b000010
`define OP_JAL     6'b000011
`define OP_CP0     6'b010000

`define OP_BEQ     6'b000100
`define OP_BNE     6'b000101
`define OP_BLEZ    6'b000110
`define OP_BGTZ    6'b000111
	
`define OP_ADDI    6'b001000
`define OP_ADDIU   6'b001001
`define OP_SLTI    6'b001010
`define OP_SLTIU   6'b001011

`define OP_ANDI    6'b001100
`define OP_ORI     6'b001101
`define OP_XORI    6'b001110
`define OP_LUI     6'b001111
	
`define OP_LB      6'b100000
`define OP_LH      6'b100001
`define OP_LW      6'b100011
`define OP_LBU     6'b100100
`define OP_LHU     6'b100101
`define OP_LWL     6'b100010
`define OP_LWR     6'b100110

`define OP_SB      6'b101000
`define OP_SH      6'b101001
`define OP_SW      6'b101011

`define OP_LWC     6'b110001
`define OP_SWC     6'b111001
	
`define FUNC_SLL     6'b000000
`define FUNC_SRL     6'b000010
`define FUNC_SRA     6'b000011
`define FUNC_SLLV    6'b000100
`define FUNC_SRLV    6'b000110
`define FUNC_SRAV    6'b000111
	
`define FUNC_JR      6'b001000
`define FUNC_JALR    6'b001001
`define FUNC_SYS     6'b001100
`define FUNC_BREAK   6'b001101
	
`define FUNC_MFHI    6'b010000
`define FUNC_MTHI    6'b010001
`define FUNC_MFLO    6'b010010
`define FUNC_MTLO    6'b010011

`define FUNC_MUL     6'b011000
`define FUNC_MULU    6'b011001
`define FUNC_DIV     6'b011010
`define FUNC_DIVU    6'b011011
	
`define FUNC_ADD     6'b100000
`define FUNC_ADDU    6'b100001
`define FUNC_SUB     6'b100010
`define FUNC_SUBU    6'b100011

`define FUNC_AND     6'b100100
`define FUNC_OR      6'b100101
`define FUNC_XOR     6'b100110
`define FUNC_NOR     6'b100111
	
`define FUNC_SLT     6'b101010
`define FUNC_SLTU    6'b101011

`define UOP_ADD     5'b00000
`define UOP_ADDU    5'b00001
`define UOP_SUB     5'b00010
`define UOP_SUBU    5'b00011
`define UOP_MUL     5'b00100
`define UOP_MULU    5'b00101
`define UOP_DIV     5'b00110
`define UOP_DIVU    5'b00111
`define UOP_OR      5'b01000 
`define UOP_AND     5'b01001
`define UOP_XOR     5'b01010 
`define UOP_NOR     5'b01011
`define UOP_SLL     5'b01100
`define UOP_SRL     5'b01101
`define UOP_SLA     5'b01110
`define UOP_SRA     5'b01111
`define UOP_NOP     5'b11111

