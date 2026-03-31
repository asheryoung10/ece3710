`timescale 1ns/1ps
`include "isa_defs.vh"

module control_unit (
    input wire [1:0] state,
    input wire [7:0] opcode,
    output reg [1:0] next_state,
    output reg memory_write_enable,
    output reg use_register_address,
    output reg register_file_write_enable,
    output reg [1:0] register_file_write_select,
    output reg instruction_register_write_enable,
    output reg program_counter_write_enable,
    output reg program_state_write_enable,
    output reg alu_select_immediate
);

// Generate the per-state control signals for fetch, execute, and memory cycles.
always @(*) begin
    next_state = `DJ_CU_FETCH;
    memory_write_enable = 1'b0;
    use_register_address = 1'b0;
    register_file_write_enable = 1'b0;
    register_file_write_select = 2'b00;
    instruction_register_write_enable = 1'b0;
    program_counter_write_enable = 1'b0;
    program_state_write_enable = 1'b0;
    alu_select_immediate = 1'b0;

    case (state)
        // Advance from the fetch state into instruction capture.
        `DJ_CU_FETCH: begin
            next_state = `DJ_CU_LOAD_IR;
        end

        // Latch the fetched instruction before entering execute.
        `DJ_CU_LOAD_IR: begin
            instruction_register_write_enable = 1'b1;
            next_state = `DJ_CU_EXECUTE;
        end

        // Decode the opcode and drive the main execute-cycle controls.
        `DJ_CU_EXECUTE: begin
            program_counter_write_enable = 1'b1;
            next_state = `DJ_CU_FETCH;

            casez (opcode)
                // Write ALU results back and update flags for arithmetic and logic ops.
                `DJ_OP_ADD,
                `DJ_OP_ADDI,
                `DJ_OP_ADDU,
                `DJ_OP_ADDUI,
                `DJ_OP_ADDC,
                `DJ_OP_ADDCI,
                `DJ_OP_SUB,
                `DJ_OP_SUBI,
                `DJ_OP_AND,
                `DJ_OP_OR,
                `DJ_OP_XOR,
                `DJ_OP_NOT,
                `DJ_OP_LSH,
                `DJ_OP_LSHI,
                `DJ_OP_RSH,
                `DJ_OP_RSHI,
                `DJ_OP_ARSH,
                `DJ_OP_ARSHI: begin
                    register_file_write_enable = 1'b1;
                    program_state_write_enable = 1'b1;
                end

                // Update flags only for compare instructions.
                `DJ_OP_CMP,
                `DJ_OP_CMPI: begin
                    program_state_write_enable = 1'b1;
                end

                // Start a memory read by switching the address source and stalling.
                `DJ_OP_LOAD: begin
                    use_register_address = 1'b1;
                    next_state = `DJ_CU_LOAD_MEM;
                end

                // Issue a memory write using the register-based address.
                `DJ_OP_STOR: begin
                    use_register_address = 1'b1;
                    memory_write_enable = 1'b1;
                end

                // Forward an existing register value into the destination register.
                `DJ_OP_MOV: begin
                    register_file_write_enable = 1'b1;
                    register_file_write_select = 2'b01;
                end

                // Forward the decoded immediate into the destination register.
                `DJ_OP_MOVI: begin
                    register_file_write_enable = 1'b1;
                    register_file_write_select = 2'b10;
                end

                default: begin
                end
            endcase

            casez (opcode)
                // Select the sign-extended immediate as the ALU A input when required.
                `DJ_OP_ADDI,
                `DJ_OP_ADDUI,
                `DJ_OP_ADDCI,
                `DJ_OP_SUBI,
                `DJ_OP_CMPI,
                `DJ_OP_LSHI,
                `DJ_OP_RSHI,
                `DJ_OP_ARSHI: begin
                    alu_select_immediate = 1'b1;
                end

                default: begin
                end
            endcase
        end

        // Complete a pending memory load by writing the bus data back.
        `DJ_CU_LOAD_MEM: begin
            register_file_write_enable = 1'b1;
            register_file_write_select = 2'b11;
            next_state = `DJ_CU_FETCH;
        end

        default: begin
            next_state = `DJ_CU_FETCH;
        end
    endcase
end

endmodule
