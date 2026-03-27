module memory
#(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 10,
    parameter INIT_FILE = "cpu/init_mem.text"
)
(
    input clock,
    input writeEnable,
    input [DATA_WIDTH-1:0] writeData,
    input [ADDR_WIDTH-1:0] readWriteAddress,
    output reg [DATA_WIDTH-1:0] contents
);

reg [DATA_WIDTH-1:0] ram[(2**ADDR_WIDTH)-1:0];

initial begin
    $readmemh(INIT_FILE, ram);
end

always @(posedge clock)
begin
    if (writeEnable) begin
        ram[readWriteAddress] <= writeData;
        contents <= writeData;
    end else begin
        contents <= ram[readWriteAddress];
    end
end

endmodule