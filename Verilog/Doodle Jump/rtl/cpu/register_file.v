`timescale 1ns/1ps
`include "isa_defs.vh"

module register_file #
(
    parameter DATA_WIDTH = `DJ_DATA_WIDTH,
    parameter ADDR_WIDTH = 4
)
(
    input wire clk,
    input wire rst,
    input wire write_enable,
    input wire [ADDR_WIDTH-1:0] write_address,
    input wire [DATA_WIDTH-1:0] write_data,
    input wire [ADDR_WIDTH-1:0] read_address_a,
    input wire [ADDR_WIDTH-1:0] read_address_b,
    output wire [DATA_WIDTH-1:0] read_data_a,
    output wire [DATA_WIDTH-1:0] read_data_b
);

reg [DATA_WIDTH-1:0] registers[0:(1 << ADDR_WIDTH) - 1];
integer index;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (index = 0; index < (1 << ADDR_WIDTH); index = index + 1) begin
            registers[index] <= {DATA_WIDTH{1'b0}};
        end
    end else if (write_enable) begin
        registers[write_address] <= write_data;
    end
end

assign read_data_a = registers[read_address_a];
assign read_data_b = registers[read_address_b];

endmodule
