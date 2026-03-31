`timescale 1ns/1ps

module sync_ram #
(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 10
)
(
    input wire clk,
    input wire we,
    input wire [ADDR_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] wdata,
    output reg [DATA_WIDTH-1:0] rdata
);

// Allocate the writable RAM storage and loop index.
reg [DATA_WIDTH-1:0] ram[0:(1 << ADDR_WIDTH) - 1];
integer index;

// Initialize the RAM contents to zero for simulation.
initial begin
    for (index = 0; index < (1 << ADDR_WIDTH); index = index + 1) begin
        ram[index] = {DATA_WIDTH{1'b0}};
    end
end

// Perform synchronous writes and return the addressed word.
always @(posedge clk) begin
    if (we) begin
        ram[addr] <= wdata;
        rdata <= wdata;
    end else begin
        rdata <= ram[addr];
    end
end

endmodule
