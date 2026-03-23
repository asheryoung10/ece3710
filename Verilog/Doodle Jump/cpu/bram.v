module bram
#(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 10,
    parameter INIT_FILE = "init_mem.text"
)
(
    input clock,
    input writeEnable,
    input [ADDR_WIDTH-1:0] address,
    input [DATA_WIDTH-1:0] writeData,
    output reg [DATA_WIDTH-1:0] readData
);

(* ramstyle = "M10K" *) reg [DATA_WIDTH-1:0] ram[0:(1<<ADDR_WIDTH)-1];
integer i;

initial begin
    for (i = 0; i < (1 << ADDR_WIDTH); i = i + 1)
        ram[i] = {DATA_WIDTH{1'b0}};

    $readmemh(INIT_FILE, ram);
end

always @(posedge clock) begin
    if (writeEnable) begin
        ram[address] <= writeData;
        readData <= writeData;
    end else begin
        readData <= ram[address];
    end
end

endmodule
