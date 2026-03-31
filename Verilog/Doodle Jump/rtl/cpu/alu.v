`timescale 1ns/1ps
`include "isa_defs.vh"

module alu #
(
    parameter DATA_WIDTH = `DJ_DATA_WIDTH
)
(
    input wire [DATA_WIDTH-1:0] a,
    input wire [DATA_WIDTH-1:0] b,
    input wire [7:0] opcode,
    input wire carry_in,
    output reg [4:0] flags,
    output reg [DATA_WIDTH-1:0] result
);

// Hold shared arithmetic intermediates and flag calculations.
reg [DATA_WIDTH:0] wide_result;
reg signed [DATA_WIDTH-1:0] signed_a;
reg signed [DATA_WIDTH-1:0] signed_b;
integer shift_amount;
reg c_flag;
reg l_flag;
reg f_flag;
reg z_flag;
reg n_flag;

// Evaluate the selected ALU operation and derive the next flag bundle.
always @(*) begin
    signed_a = a;
    signed_b = b;
    wide_result = {(DATA_WIDTH + 1){1'b0}};
    shift_amount = signed_a;

    result = {DATA_WIDTH{1'b0}};
    c_flag = 1'b0;
    l_flag = 1'b0;
    f_flag = 1'b0;
    z_flag = 1'b0;
    n_flag = 1'b0;

    casez (opcode)
        // Compute signed add variants that update carry, less-than, and overflow.
        `DJ_OP_ADD,
        `DJ_OP_ADDI: begin
            wide_result = {1'b0, b} + {1'b0, a};
            result = wide_result[DATA_WIDTH-1:0];
            c_flag = wide_result[DATA_WIDTH];
            l_flag = ($unsigned(b) < $unsigned(a));
            f_flag = (~(b[DATA_WIDTH-1] ^ a[DATA_WIDTH-1])) &
                     (result[DATA_WIDTH-1] ^ b[DATA_WIDTH-1]);
            z_flag = (result == {DATA_WIDTH{1'b0}});
            n_flag = result[DATA_WIDTH-1];
        end

        // Compute unsigned add variants without overflow reporting.
        `DJ_OP_ADDU,
        `DJ_OP_ADDUI: begin
            wide_result = {1'b0, b} + {1'b0, a};
            result = wide_result[DATA_WIDTH-1:0];
            c_flag = wide_result[DATA_WIDTH];
            l_flag = ($unsigned(b) < $unsigned(a));
            z_flag = (result == {DATA_WIDTH{1'b0}});
            n_flag = result[DATA_WIDTH-1];
        end

        // Compute add-with-carry variants using the saved carry input.
        `DJ_OP_ADDC,
        `DJ_OP_ADDCI: begin
            wide_result = {1'b0, b} + {1'b0, a} + carry_in;
            result = wide_result[DATA_WIDTH-1:0];
            c_flag = wide_result[DATA_WIDTH];
            l_flag = ($unsigned(b) < ($unsigned(a) + carry_in));
            f_flag = (~(b[DATA_WIDTH-1] ^ a[DATA_WIDTH-1])) &
                     (result[DATA_WIDTH-1] ^ b[DATA_WIDTH-1]);
            z_flag = (result == {DATA_WIDTH{1'b0}});
            n_flag = result[DATA_WIDTH-1];
        end

        `DJ_OP_SUB,
        `DJ_OP_SUBI: begin
            wide_result = {1'b0, b} + {1'b0, ~a} + 1'b1;
            result = wide_result[DATA_WIDTH-1:0];
            c_flag = wide_result[DATA_WIDTH];
            l_flag = ($unsigned(b) < $unsigned(a));
            f_flag = (b[DATA_WIDTH-1] ^ a[DATA_WIDTH-1]) &
                     (result[DATA_WIDTH-1] ^ b[DATA_WIDTH-1]);
            z_flag = (result == {DATA_WIDTH{1'b0}});
            n_flag = (signed_b < signed_a);
        end

        // Compare operands and only update the condition flags.
        `DJ_OP_CMP,
        `DJ_OP_CMPI: begin
            result = {DATA_WIDTH{1'b0}};
            c_flag = ($unsigned(b) >= $unsigned(a));
            l_flag = ($unsigned(b) < $unsigned(a));
            z_flag = (signed_b == signed_a);
            n_flag = (signed_b < signed_a);
        end

        // Apply the bitwise logic operations.
        `DJ_OP_AND: begin
            result = b & a;
            z_flag = (result == {DATA_WIDTH{1'b0}});
            n_flag = result[DATA_WIDTH-1];
        end

        `DJ_OP_OR: begin
            result = b | a;
            z_flag = (result == {DATA_WIDTH{1'b0}});
            n_flag = result[DATA_WIDTH-1];
        end

        `DJ_OP_XOR: begin
            result = b ^ a;
            z_flag = (result == {DATA_WIDTH{1'b0}});
            n_flag = result[DATA_WIDTH-1];
        end

        `DJ_OP_NOT: begin
            result = ~a;
            z_flag = (result == {DATA_WIDTH{1'b0}});
            n_flag = result[DATA_WIDTH-1];
        end

        // Shift left using positive amounts and right using negative amounts.
        `DJ_OP_LSH,
        `DJ_OP_LSHI: begin
            if (shift_amount >= 0)
                result = b << shift_amount;
            else
                result = b >> -shift_amount;

            z_flag = (result == {DATA_WIDTH{1'b0}});
            n_flag = result[DATA_WIDTH-1];
        end

        // Shift right logically using positive amounts and left using negative amounts.
        `DJ_OP_RSH,
        `DJ_OP_RSHI: begin
            if (shift_amount >= 0)
                result = b >> shift_amount;
            else
                result = b << -shift_amount;

            z_flag = (result == {DATA_WIDTH{1'b0}});
            n_flag = result[DATA_WIDTH-1];
        end

        // Shift right arithmetically using positive amounts and left using negative amounts.
        `DJ_OP_ARSH,
        `DJ_OP_ARSHI: begin
            if (shift_amount >= 0)
                result = $signed(b) >>> shift_amount;
            else
                result = $signed(b) <<< -shift_amount;

            z_flag = (result == {DATA_WIDTH{1'b0}});
            n_flag = result[DATA_WIDTH-1];
        end

        // Pass through operand B for unsupported or no-op instructions.
        default: begin
            result = b;
            z_flag = (result == {DATA_WIDTH{1'b0}});
            n_flag = result[DATA_WIDTH-1];
        end
    endcase

    flags = {c_flag, l_flag, f_flag, z_flag, n_flag};
end

endmodule
