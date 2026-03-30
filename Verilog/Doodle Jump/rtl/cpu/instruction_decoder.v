`timescale 1ns/1ps
`include "isa_defs.vh"

module instruction_decoder (
    input wire [15:0] instruction,
    input wire [15:0] program_counter,
    input wire [15:0] program_state,
    input wire [15:0] register_data_a,
    output reg [3:0] register_address_a,
    output reg [3:0] register_address_b,
    output reg [15:0] immediate,
    output reg [7:0] opcode,
    output reg [15:0] next_program_counter
);

reg condition_met;

always @(*) begin
    register_address_a = instruction[3:0];
    register_address_b = instruction[11:8];
    immediate = {{8{instruction[7]}}, instruction[7:0]};
    opcode = {instruction[15:12], instruction[7:4]};

    case (instruction[11:8])
        `DJ_COND_EQ: condition_met = program_state[`DJ_Z_INDEX];
        `DJ_COND_NE: condition_met = ~program_state[`DJ_Z_INDEX];
        `DJ_COND_GE: condition_met = program_state[`DJ_N_INDEX] | program_state[`DJ_Z_INDEX];
        `DJ_COND_CS: condition_met = program_state[`DJ_C_INDEX];
        `DJ_COND_CC: condition_met = ~program_state[`DJ_C_INDEX];
        `DJ_COND_HI: condition_met = program_state[`DJ_L_INDEX];
        `DJ_COND_LS: condition_met = ~program_state[`DJ_L_INDEX];
        `DJ_COND_LO: condition_met = ~program_state[`DJ_L_INDEX] & ~program_state[`DJ_Z_INDEX];
        `DJ_COND_HS: condition_met = program_state[`DJ_L_INDEX] | program_state[`DJ_Z_INDEX];
        `DJ_COND_GT: condition_met = program_state[`DJ_N_INDEX];
        `DJ_COND_LE: condition_met = ~program_state[`DJ_N_INDEX];
        `DJ_COND_FS: condition_met = program_state[`DJ_F_INDEX];
        `DJ_COND_FC: condition_met = ~program_state[`DJ_F_INDEX];
        `DJ_COND_LT: condition_met = ~program_state[`DJ_N_INDEX] & ~program_state[`DJ_Z_INDEX];
        `DJ_COND_UC: condition_met = 1'b1;
        default: condition_met = 1'b0;
    endcase

    casez (opcode)
        `DJ_OP_BCOND: begin
            if (condition_met)
                next_program_counter = program_counter + immediate;
            else
                next_program_counter = program_counter + 16'd1;
        end

        `DJ_OP_JCOND: begin
            if (condition_met)
                next_program_counter = register_data_a;
            else
                next_program_counter = program_counter + 16'd1;
        end

        default: begin
            next_program_counter = program_counter + 16'd1;
        end
    endcase
end

endmodule
