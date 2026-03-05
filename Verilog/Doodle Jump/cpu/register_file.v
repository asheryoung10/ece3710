module register_file
#(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 4
)
(
    input clock,
    input reset,
    input writeEnable,
    input [ADDR_WIDTH-1:0] writeAddress,
    input [DATA_WIDTH-1:0] writeData,

    input [ADDR_WIDTH-1:0] readAddressA,
    input [ADDR_WIDTH-1:0] readAddressB,

    output [DATA_WIDTH-1:0] contentsA,
    output [DATA_WIDTH-1:0] contentsB
);

reg [DATA_WIDTH-1:0] registers [(2**ADDR_WIDTH)-1:0];
integer i;

always @(posedge clock or posedge reset)
begin
    if (reset) begin
        for (i = 0; i < 2**ADDR_WIDTH; i = i + 1)
            registers[i] <= {DATA_WIDTH{1'b0}};
    end else if (writeEnable) begin
        registers[writeAddress] <= writeData;
    end
end

assign contentsA = registers[readAddressA];
assign contentsB = registers[readAddressB];

endmodule