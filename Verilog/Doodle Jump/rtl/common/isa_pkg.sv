`timescale 1ns/1ps

package isa_pkg;

    localparam int DATA_WIDTH = 16;
    localparam int ADDR_WIDTH = 16;
    localparam int REGISTER_COUNT = 16;
    localparam int PSR_WIDTH = 5;

    typedef enum logic [1:0] {
        CU_FETCH    = 2'd0,
        CU_LOAD_IR  = 2'd1,
        CU_EXECUTE  = 2'd2,
        CU_LOAD_MEM = 2'd3
    } cpu_state_t;

    localparam logic [7:0] OP_ADD   = 8'b0000_0101;
    localparam logic [7:0] OP_ADDI  = 8'b0101_????;
    localparam logic [7:0] OP_ADDU  = 8'b0000_0110;
    localparam logic [7:0] OP_ADDUI = 8'b0110_????;
    localparam logic [7:0] OP_ADDC  = 8'b0000_0111;
    localparam logic [7:0] OP_ADDCI = 8'b0111_????;
    localparam logic [7:0] OP_SUB   = 8'b0000_1001;
    localparam logic [7:0] OP_SUBI  = 8'b1001_????;
    localparam logic [7:0] OP_CMP   = 8'b0000_1011;
    localparam logic [7:0] OP_CMPI  = 8'b1011_????;
    localparam logic [7:0] OP_AND   = 8'b0000_0001;
    localparam logic [7:0] OP_OR    = 8'b0000_0010;
    localparam logic [7:0] OP_XOR   = 8'b0000_0011;
    localparam logic [7:0] OP_NOT   = 8'b0000_0100;
    localparam logic [7:0] OP_LSH   = 8'b1000_0100;
    localparam logic [7:0] OP_LSHI  = 8'b1000_000?;
    localparam logic [7:0] OP_RSH   = 8'b1000_100?;
    localparam logic [7:0] OP_RSHI  = 8'b1000_101?;
    localparam logic [7:0] OP_ARSH  = 8'b1000_0110;
    localparam logic [7:0] OP_ARSHI = 8'b1000_001?;
    localparam logic [7:0] OP_NOP   = 8'b0000_0000;
    localparam logic [7:0] OP_LOAD  = 8'b0100_0000;
    localparam logic [7:0] OP_STOR  = 8'b0100_0100;
    localparam logic [7:0] OP_MOV   = 8'b0000_1101;
    localparam logic [7:0] OP_MOVI  = 8'b1101_????;
    localparam logic [7:0] OP_BCOND = 8'b1100_????;
    localparam logic [7:0] OP_JCOND = 8'b0100_1100;

    localparam logic [3:0] COND_EQ = 4'b0000;
    localparam logic [3:0] COND_NE = 4'b0001;
    localparam logic [3:0] COND_CS = 4'b0010;
    localparam logic [3:0] COND_CC = 4'b0011;
    localparam logic [3:0] COND_HI = 4'b0100;
    localparam logic [3:0] COND_LS = 4'b0101;
    localparam logic [3:0] COND_GT = 4'b0110;
    localparam logic [3:0] COND_LE = 4'b0111;
    localparam logic [3:0] COND_FS = 4'b1000;
    localparam logic [3:0] COND_FC = 4'b1001;
    localparam logic [3:0] COND_LO = 4'b1010;
    localparam logic [3:0] COND_HS = 4'b1011;
    localparam logic [3:0] COND_LT = 4'b1100;
    localparam logic [3:0] COND_GE = 4'b1101;
    localparam logic [3:0] COND_UC = 4'b1110;

    localparam int N_INDEX = 0;
    localparam int Z_INDEX = 1;
    localparam int F_INDEX = 2;
    localparam int L_INDEX = 3;
    localparam int C_INDEX = 4;

endpackage
