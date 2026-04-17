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
    output [DATA_WIDTH-1:0] contentsB,
	 
	input wire p1Left,
	input wire p1Right,
	input wire p1Up,
	input wire p1Down,
	
	input wire p2Left,
	input wire p2Right,
	input wire p2Up,
	input wire p2Down,
	
	input wire p3Left,
	input wire p3Right,
	input wire p3Up,
	input wire p3Down,
	
	input wire p4Left,
	input wire p4Right,
	input wire p4Up,
	input wire p4Down,


	input wire start,
	input wire select,
	input wire vsync,
	 
	 output wire [15:0] R3
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

wire [15:0] reg15Input;
wire [15:0] reg11Input;
assign reg15Input = {p4Down, p4Up, p4Right, p4Left, p3Down, p3Up, p3Right, p3Left, p2Down, p2Up, p2Right, p2Left, p1Down, p1Up, p1Right, p1Left};
assign reg11Input = {13'b0, start, select, vsync};


assign contentsA = (4'd11 == readAddressA) ? reg11Input : (4'd15 == readAddressA ? reg15Input : registers[readAddressA]);
assign contentsB = (4'd11 == readAddressB) ? reg11Input : (4'd15 == readAddressB ? reg15Input : registers[readAddressB]);
assign R3 = registers[4'd3];



endmodule