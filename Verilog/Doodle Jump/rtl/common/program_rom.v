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

// Allocate the program ROM storage and loop index.
reg [DATA_WIDTH-1:0] rom[0:(1 << ADDR_WIDTH) - 1];
integer index;

// Clear the ROM image and then load the selected memory file.
initial begin
    for (index = 0; index < (1 << ADDR_WIDTH); index = index + 1) begin
        rom[index] = {DATA_WIDTH{1'b0}};
    end

    $readmemh(INIT_FILE, rom);
end

// Return the addressed ROM word on the next clock edge.
always @(posedge clk) begin
    rdata <= rom[addr];
end

endmodule
