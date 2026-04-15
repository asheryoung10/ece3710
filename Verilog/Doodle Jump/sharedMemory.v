module sharedMemory
#(
	parameter DATA_WIDTH = 16
)
(
		input clock,
		input writeEnable,
		input [15:0] writeData,
		input [15:0] readWriteAddress,
		output reg [15:0] contents,
		input reset,
	 

		input [9:0] vgaX,
		input [9:0] vgaY,
		output reg [7:0] r,
		output reg [7:0] g,
		output reg [7:0] b,

	   output [15:0] p1X,
		output [15:0] p1Y,
		output [15:0] p1AnimationIndex,
		output [15:0] p1HighlightColor,
		
		output [15:0] p2X,
		output [15:0] p2Y,
		output [15:0] p2AnimationIndex,
		output [15:0] p2HighlightColor,
		
	   output [15:0] p3X,
		output [15:0] p3Y,
		output [15:0] p3AnimationIndex,
		output [15:0] p3HighlightColor,
		
		output [15:0] p4X,
		output [15:0] p4Y,
		output [15:0] p4AnimationIndex,
		output [15:0] p4HighlightColor,
		
		output [15:0] backgroundOffsetX,
		output [15:0] backgroundOffsetY,
		output [15:0] audioPitchIndex,
		output [15:0] p1Scale,
		output [15:0] p2Scale,
		output [15:0] p3Scale,
		output [15:0] p4Scale,

		
		output [15:0] p1Score,
		output [15:0] p2Score,
		output [15:0] p3Score,
		output [15:0] p4Score

);




wire isRectAccess; assign isRectAccess = readWriteAddress[15:7] == 9'b100000000;
wire isPlayerAccess; assign isPlayerAccess= readWriteAddress[15:5] == 11'b11000000000;
wire isMemoryAccess; assign isMemoryAccess = !isRectAccess && !isPlayerAccess;
wire enableRectWrite; assign enableRectWrite = writeEnable && isRectAccess;
wire enablePlayerWrite; assign enablePlayerWrite = writeEnable && isPlayerAccess;
wire enableCPUWrite; assign enableCPUWrite = writeEnable && isMemoryAccess;
wire [15:0] contentsCPU;
reg [15:0] contentsPlayer;
reg [15:0] contentsRect;


// CPU Memory
localparam addr_width = 12;
memory 
#(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(addr_width)
)
cpu_memory_instance
(
    .clock(clock),
    .writeEnable(enableCPUWrite),
    .writeData(writeData),
    .readWriteAddress(readWriteAddress[addr_width-1:0]),
    .contents(contentsCPU)
);

// Player Memory
reg [15:0] sharedPlayerRegs  [0:26]; // 26 additional saved regs
always@(posedge clock) begin
	if(reset) begin
		sharedPlayerRegs[0] <= 0;
		sharedPlayerRegs[1] <= 0;
		sharedPlayerRegs[2] <= 0;
		sharedPlayerRegs[3] <= 0;
		sharedPlayerRegs[4] <= 0;
		sharedPlayerRegs[5] <= 0;
		sharedPlayerRegs[6] <= 0;
		sharedPlayerRegs[7] <= 0;
		sharedPlayerRegs[8] <= 0;
		sharedPlayerRegs[9] <= 0;
		sharedPlayerRegs[10] <= 0;
		sharedPlayerRegs[11] <= 0;
		sharedPlayerRegs[12] <= 0;
		sharedPlayerRegs[13] <= 0;
		sharedPlayerRegs[14] <= 0;
		sharedPlayerRegs[15] <= 0;
		sharedPlayerRegs[16] <= 0;
		sharedPlayerRegs[17] <= 0;
		sharedPlayerRegs[18] <= 0;
		sharedPlayerRegs[19] <= 0;
		sharedPlayerRegs[20] <= 0;
		sharedPlayerRegs[21] <= 0;
		sharedPlayerRegs[22] <= 0;
		sharedPlayerRegs[23] <= 0;
		sharedPlayerRegs[24] <= 0;
		sharedPlayerRegs[25] <= 0;
		sharedPlayerRegs[26] <= 0;
	end else
	if(enablePlayerWrite) begin
			sharedPlayerRegs[readWriteAddress[4:0]] <= writeData;
			contentsPlayer <= writeData;
	end else begin
		contentsPlayer <= sharedPlayerRegs[readWriteAddress[4:0]];
	end
end

assign p1X = sharedPlayerRegs[0];
assign p1Y = sharedPlayerRegs[1];
assign p1AnimationIndex = sharedPlayerRegs[2];
assign p1HighlightColor = sharedPlayerRegs[3];

assign p2X = sharedPlayerRegs[4];
assign p2Y = sharedPlayerRegs[5];
assign p2AnimationIndex = sharedPlayerRegs[6];
assign p2HighlightColor = sharedPlayerRegs[7];

assign p3X = sharedPlayerRegs[8];
assign p3Y = sharedPlayerRegs[9];
assign p3AnimationIndex = sharedPlayerRegs[10];
assign p3HighlightColor = sharedPlayerRegs[11];

assign p4X = sharedPlayerRegs[12];
assign p4Y = sharedPlayerRegs[13];
assign p4AnimationIndex = sharedPlayerRegs[14];
assign p4HighlightColor = sharedPlayerRegs[15];

assign backgroundOffsetX = sharedPlayerRegs[16];
assign backgroundOffsetY = sharedPlayerRegs[17];
assign audioPitchIndex = sharedPlayerRegs[18];
assign p1Scale = sharedPlayerRegs[19];
assign p2Scale = sharedPlayerRegs[20];
assign p3Scale = sharedPlayerRegs[21];
assign p4Scale = sharedPlayerRegs[22];
assign p1Score = sharedPlayerRegs[23];
assign p2Score = sharedPlayerRegs[24];	
assign p3Score = sharedPlayerRegs[25];
assign p4Score = sharedPlayerRegs[26];




// Shared Memory
reg [15:0] rect_data  [0:255]; // 16 rects, each 4 registers.
wire [6:0] rect_index = readWriteAddress[6:0];
always @(posedge clock) begin
	if(isRectAccess) begin
			if(enableRectWrite) begin
				rect_data[rect_index] <= writeData;
				contentsRect <= writeData;
			end else begin
				contentsRect <= rect_data[rect_index];
			end
	end
end


always @(*) begin
	if(isRectAccess)
		contents <= contentsRect;
	else if(isPlayerAccess)
		contents <= contentsPlayer;
	else
		contents <= contentsCPU;
end
// Draw Rectangles
reg [15:0] width;
reg [15:0] height;
reg [15:0] x;
reg [15:0] y;
reg [15:0] wh;
reg [15:0] color;
reg [7:0] base_r;
reg [7:0] base_g;
reg [7:0] base_b;
reg inside_platform;
reg inside_rounded_shape;
reg cut_corner;
integer i;
integer edge_dx;
integer edge_dy;
wire signed [15:0] svgaX = {6'b0, vgaX};  // zero-extend to 16 bits
wire signed [15:0] svgaY = {6'b0, vgaY};
 
localparam integer CORNER_RADIUS = 3;
 
always @(*) begin
    r = 8'h00;
    g = 8'h00;
    b = 8'h00;

    for (i = 0; i < 64; i = i + 1) begin
        x     = rect_data[i*4 + 0];
        y     = rect_data[i*4 + 1];
        wh    = rect_data[i*4 + 2];
        color = rect_data[i*4 + 3];

        width  = wh[15:8];
        height = wh[7:0];

        base_r = {color[15:11], 3'b000};
        base_g = {color[10:5],  2'b00};
        base_b = {color[4:0],   3'b000};

        inside_platform =
            (svgaX >= $signed(x)) &&
            (svgaX <  $signed(x) + $signed({8'b0, width})) &&
            (svgaY >= $signed(y)) &&
            (svgaY <  $signed(y) + $signed({8'b0, height}));

        cut_corner = 1'b0;

        if (inside_platform && (width > (CORNER_RADIUS * 2)) && (height > (CORNER_RADIUS * 2))) begin
            if ((svgaX < $signed(x) + CORNER_RADIUS) && (svgaY < $signed(y) + CORNER_RADIUS)) begin
                edge_dx = svgaX - $signed(x);
                edge_dy = svgaY - $signed(y);
                if ((edge_dx + edge_dy) < (CORNER_RADIUS - 1))
                    cut_corner = 1'b1;
            end

            if ((svgaX >= $signed(x) + $signed({8'b0, width}) - CORNER_RADIUS) && (svgaY < $signed(y) + CORNER_RADIUS)) begin
                edge_dx = ($signed(x) + $signed({8'b0, width}) - 1) - svgaX;
                edge_dy = svgaY - $signed(y);
                if ((edge_dx + edge_dy) < (CORNER_RADIUS - 1))
                    cut_corner = 1'b1;
            end

            if ((svgaX < $signed(x) + CORNER_RADIUS) && (svgaY >= $signed(y) + $signed({8'b0, height}) - CORNER_RADIUS)) begin
                edge_dx = svgaX - $signed(x);
                edge_dy = ($signed(y) + $signed({8'b0, height}) - 1) - svgaY;
                if ((edge_dx + edge_dy) < (CORNER_RADIUS - 1))
                    cut_corner = 1'b1;
            end

            if ((svgaX >= $signed(x) + $signed({8'b0, width}) - CORNER_RADIUS) && (svgaY >= $signed(y) + $signed({8'b0, height}) - CORNER_RADIUS)) begin
                edge_dx = ($signed(x) + $signed({8'b0, width}) - 1) - svgaX;
                edge_dy = ($signed(y) + $signed({8'b0, height}) - 1) - svgaY;
                if ((edge_dx + edge_dy) < (CORNER_RADIUS - 1))
                    cut_corner = 1'b1;
            end
        end

        inside_rounded_shape = inside_platform && !cut_corner;

        if (inside_rounded_shape) begin
            if (svgaY < $signed(y) + 3) begin
                r = base_r >> 1;
                g = (base_g >> 1) + 8'd40;
                b = base_b >> 1;
            end else if (svgaY >= $signed(y) + $signed({8'b0, height}) - 2) begin
                r = base_r >> 1;
                g = base_g >> 1;
                b = base_b >> 1;
            end else begin
                r = base_r;
                g = base_g;
                b = base_b;
            end
        end
    end
end

endmodule
