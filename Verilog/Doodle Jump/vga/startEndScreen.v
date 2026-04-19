module startEndScreen (
	 input  wire        clk50,
    input  wire [15:0] number,
    input  wire [15:0] baseX,
    input  wire [15:0] baseY,
    input  wire [15:0] highlightColor,
    input  wire [9:0]  pixelX,
    input  wire [9:0]  pixelY,
    input  wire [15:0] scale,
 
    output reg  [7:0] pixelR,
    output reg  [7:0] pixelG,
    output reg  [7:0] pixelB
);

endmodule