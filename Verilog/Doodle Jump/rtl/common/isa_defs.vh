`ifndef DOODLE_JUMP_ISA_DEFS_VH
`define DOODLE_JUMP_ISA_DEFS_VH

// Define the core-wide data-path and register file widths.
`define DJ_DATA_WIDTH 16
`define DJ_ADDR_WIDTH 16
`define DJ_REGISTER_COUNT 16
`define DJ_PSR_WIDTH 5

// Define the control-unit state encodings.
`define DJ_CU_FETCH 2'd0
`define DJ_CU_LOAD_IR 2'd1
`define DJ_CU_EXECUTE 2'd2
`define DJ_CU_LOAD_MEM 2'd3

// Define the supported ALU, move, load/store, and control opcodes.
`define DJ_OP_ADD   8'b0000_0101
`define DJ_OP_ADDI  8'b0101_zzzz
`define DJ_OP_ADDU  8'b0000_0110
`define DJ_OP_ADDUI 8'b0110_zzzz
`define DJ_OP_ADDC  8'b0000_0111
`define DJ_OP_ADDCI 8'b0111_zzzz
`define DJ_OP_SUB   8'b0000_1001
`define DJ_OP_SUBI  8'b1001_zzzz
`define DJ_OP_CMP   8'b0000_1011
`define DJ_OP_CMPI  8'b1011_zzzz
`define DJ_OP_AND   8'b0000_0001
`define DJ_OP_OR    8'b0000_0010
`define DJ_OP_XOR   8'b0000_0011
`define DJ_OP_NOT   8'b0000_0100
`define DJ_OP_LSH   8'b1000_0100
`define DJ_OP_LSHI  8'b1000_000z
`define DJ_OP_RSH   8'b1000_100z
`define DJ_OP_RSHI  8'b1000_101z
`define DJ_OP_ARSH  8'b1000_0110
`define DJ_OP_ARSHI 8'b1000_001z
`define DJ_OP_NOP   8'b0000_0000
`define DJ_OP_LOAD  8'b0100_0000
`define DJ_OP_STOR  8'b0100_0100
`define DJ_OP_MOV   8'b0000_1101
`define DJ_OP_MOVI  8'b1101_zzzz
`define DJ_OP_BCOND 8'b1100_zzzz
`define DJ_OP_JCOND 8'b0100_1100

// Define the branch and jump condition selector encodings.
`define DJ_COND_EQ 4'b0000
`define DJ_COND_NE 4'b0001
`define DJ_COND_CS 4'b0010
`define DJ_COND_CC 4'b0011
`define DJ_COND_HI 4'b0100
`define DJ_COND_LS 4'b0101
`define DJ_COND_GT 4'b0110
`define DJ_COND_LE 4'b0111
`define DJ_COND_FS 4'b1000
`define DJ_COND_FC 4'b1001
`define DJ_COND_LO 4'b1010
`define DJ_COND_HS 4'b1011
`define DJ_COND_LT 4'b1100
`define DJ_COND_GE 4'b1101
`define DJ_COND_UC 4'b1110

// Define the program-state register flag bit positions.
`define DJ_N_INDEX 0
`define DJ_Z_INDEX 1
`define DJ_F_INDEX 2
`define DJ_L_INDEX 3
`define DJ_C_INDEX 4

`endif
