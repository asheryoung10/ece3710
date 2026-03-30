`timescale 1ns/1ps

module program_rom #
(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 10,
    parameter INIT_FILE = "mem/game_demo.memh"
)
(
    input wire clk,
    input wire [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] rdata
);

reg [DATA_WIDTH-1:0] rom[0:(1 << ADDR_WIDTH) - 1];
integer index;

initial begin
    for (index = 0; index < (1 << ADDR_WIDTH); index = index + 1) begin
        rom[index] = {DATA_WIDTH{1'b0}};
    end

    $readmemh(INIT_FILE, rom);
end

always @(posedge clk) begin
    rdata <= rom[addr];
end

endmodule
