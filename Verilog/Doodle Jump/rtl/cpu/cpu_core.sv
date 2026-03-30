`timescale 1ns/1ps
`include "isa_defs.vh"

module cpu_core #
(
    parameter DATA_WIDTH = `DJ_DATA_WIDTH,
    parameter ADDR_WIDTH = `DJ_ADDR_WIDTH
)
(
    input wire clk,
    input wire rst,
    output wire memory_write_enable,
    output wire [ADDR_WIDTH-1:0] memory_address,
    output wire [DATA_WIDTH-1:0] memory_write_data,
    input wire [DATA_WIDTH-1:0] memory_read_data,
    output reg [DATA_WIDTH-1:0] instruction_register_contents,
    output reg [DATA_WIDTH-1:0] program_counter_contents,
    output reg [DATA_WIDTH-1:0] program_state_contents,
    output wire [DATA_WIDTH-1:0] alu_result_output,
    output wire [4:0] alu_flags_output,
    output wire [2:0] control_state_output,
    output wire [2:0] control_next_state_output
);

reg [1:0] state;
wire [1:0] next_state;

wire register_file_write_enable;
wire [1:0] register_file_write_select;
wire instruction_register_write_enable;
wire program_counter_write_enable;
wire program_state_write_enable;
wire alu_select_immediate;
wire use_register_address;

wire [3:0] register_address_a;
wire [3:0] register_address_b;
wire [15:0] immediate;
wire [7:0] opcode;
wire [15:0] next_program_counter;
wire [15:0] register_data_a;
wire [15:0] register_data_b;
reg [15:0] register_file_write_data;
wire [15:0] alu_input_a;
wire [4:0] alu_flags;
wire [15:0] alu_result;

register_file register_file_instance (
    .clk(clk),
    .rst(rst),
    .write_enable(register_file_write_enable),
    .write_address(register_address_b),
    .write_data(register_file_write_data),
    .read_address_a(register_address_a),
    .read_address_b(register_address_b),
    .read_data_a(register_data_a),
    .read_data_b(register_data_b)
);

instruction_decoder instruction_decoder_instance (
    .instruction(instruction_register_contents),
    .program_counter(program_counter_contents),
    .program_state(program_state_contents),
    .register_data_a(register_data_a),
    .register_address_a(register_address_a),
    .register_address_b(register_address_b),
    .immediate(immediate),
    .opcode(opcode),
    .next_program_counter(next_program_counter)
);

alu alu_instance (
    .a(alu_input_a),
    .b(register_data_b),
    .opcode(opcode),
    .carry_in(program_state_contents[`DJ_C_INDEX]),
    .flags(alu_flags),
    .result(alu_result)
);

control_unit control_unit_instance (
    .state(state),
    .opcode(opcode),
    .next_state(next_state),
    .memory_write_enable(memory_write_enable),
    .use_register_address(use_register_address),
    .register_file_write_enable(register_file_write_enable),
    .register_file_write_select(register_file_write_select),
    .instruction_register_write_enable(instruction_register_write_enable),
    .program_counter_write_enable(program_counter_write_enable),
    .program_state_write_enable(program_state_write_enable),
    .alu_select_immediate(alu_select_immediate)
);

assign alu_input_a = alu_select_immediate ? immediate : register_data_a;
assign memory_address = use_register_address ? register_data_a : program_counter_contents;
assign memory_write_data = register_data_b;
assign alu_result_output = alu_result;
assign alu_flags_output = alu_flags;
assign control_state_output = {1'b0, state};
assign control_next_state_output = {1'b0, next_state};

always @(*) begin
    case (register_file_write_select)
        2'b00: register_file_write_data = alu_result;
        2'b01: register_file_write_data = register_data_a;
        2'b10: register_file_write_data = immediate;
        2'b11: register_file_write_data = memory_read_data;
        default: register_file_write_data = {DATA_WIDTH{1'b0}};
    endcase
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= `DJ_CU_FETCH;
        instruction_register_contents <= {DATA_WIDTH{1'b0}};
        program_counter_contents <= {DATA_WIDTH{1'b0}};
        program_state_contents <= {DATA_WIDTH{1'b0}};
    end else begin
        state <= next_state;

        if (instruction_register_write_enable)
            instruction_register_contents <= memory_read_data;

        if (program_counter_write_enable)
            program_counter_contents <= next_program_counter;

        if (program_state_write_enable)
            program_state_contents <= {{(DATA_WIDTH - `DJ_PSR_WIDTH){1'b0}}, alu_flags};
    end
end

endmodule
