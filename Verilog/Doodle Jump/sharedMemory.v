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
	 output wire [15:0] playerOneX,
	 output wire [15:0] playerOneY,
	 output wire [15:0] playerOneAnimationIndex,
	 output wire [15:0] playerOneBackgroundIndex,
	 output wire [15:0] playerOnePitchIndex,
	 output wire [15:0] playerTwoX,
	 output wire [15:0] playerTwoY,
	 output wire [15:0] playerTwoAnimationIndex,
	 output wire [15:0] playerTwoBackgroundIndex,
	 output wire [15:0] playerTwoPitchIndex
);



wire isRectAccess; assign isRectAccess = readWriteAddress[15:6] == 10'b1000000000;
wire isPlayerAccess; assign isPlayerAccess= readWriteAddress[15:3] == 13'b1100000000000;
wire isMemoryAccess; assign isMemoryAccess = !isRectAccess && !isPlayerAccess;
wire enableRectWrite; assign enableRectWrite = writeEnable && isRectAccess;
wire enablePlayerWrite; assign enablePlayerWrite = writeEnable && isPlayerAccess;
wire enableCPUWrite; assign enableCPUWrite = writeEnable && isMemoryAccess;
wire [15:0] contentsCPU;
reg [15:0] contentsPlayer;
reg [15:0] contentsRect;


// CPU Memory
memory 
#(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(12)
)
cpu_memory_instance
(
    .clock(clock),
    .writeEnable(enableCPUWrite),
    .writeData(writeData),
    .readWriteAddress(readWriteAddress),
    .contents(contentsCPU)
);

// Player Memory
reg [15:0] sharedPlayerRegs  [0:15]; // 16 additional saved regs
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
	end else
	if(enablePlayerWrite) begin
			sharedPlayerRegs[readWriteAddress] <= writeData;
			contentsPlayer <= writeData;
	end else begin
		contentsPlayer <= sharedPlayerRegs[readWriteAddress];
	end
end
	 assign  playerOneX = sharedPlayerRegs[0];
	 assign  playerOneY = sharedPlayerRegs[1];
	 assign  playerOneAnimationIndex = sharedPlayerRegs[2];
	 assign  playerOneBackgroundIndex = sharedPlayerRegs[3];
	 assign playerOnePitchIndex = sharedPlayerRegs[4];
	 assign playerTwoX = sharedPlayerRegs[5];
	 assign  playerTwoY = sharedPlayerRegs[6];
	 assign  playerTwoAnimationIndex = sharedPlayerRegs[7];
	 assign  playerTwoBackgroundIndex = sharedPlayerRegs[8];
	 assign  playerTwoPitchIndex = sharedPlayerRegs[9];

// Shared Memory
reg [15:0] rect_data  [0:63]; // 16 rects, each 4 registers.
wire [5:0] rect_index = readWriteAddress[5:0];
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
reg [7:0] width;
reg [7:0] height;
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
 
localparam integer CORNER_RADIUS = 3;
localparam [15:0] DOODLE_GREEN = 16'h3666; // soft green fill
 
always @(*) begin
    // Transparent/black default so the background layer can show through.
    r = 8'h00;
    g = 8'h00;
    b = 8'h00;
 
    for (i = 0; i < 16; i = i + 1) begin
        x     = rect_data[i*4 + 0];
        y     = rect_data[i*4 + 1];
        wh    = rect_data[i*4 + 2];
        color = rect_data[i*4 + 3];
 
        width  = wh[15:8];
        height = wh[7:0];
 
        // Use the stored color if the CPU writes one, otherwise default to a Doodle-style green.
        if (color == 16'h0000) begin
            base_r = {DOODLE_GREEN[15:11], 3'b000};
            base_g = {DOODLE_GREEN[10:5],  2'b00};
            base_b = {DOODLE_GREEN[4:0],   3'b000};
        end else begin
            base_r = {color[15:11], 3'b000};
            base_g = {color[10:5],  2'b00};
            base_b = {color[4:0],   3'b000};
        end
 
        inside_platform =
            (vgaX >= x) &&
            (vgaX < x + width) &&
            (vgaY >= y) &&
            (vgaY < y + height);
 
        cut_corner = 1'b0;
 
        if (inside_platform && (width > (CORNER_RADIUS * 2)) && (height > (CORNER_RADIUS * 2))) begin
            // Cheap FPGA-friendly rounded corners using simple add/compare logic.
            // Top-left corner
            if ((vgaX < x + CORNER_RADIUS) && (vgaY < y + CORNER_RADIUS)) begin
                edge_dx = vgaX - x;
                edge_dy = vgaY - y;
                if ((edge_dx + edge_dy) < (CORNER_RADIUS - 1))
                    cut_corner = 1'b1;
            end
 
            // Top-right corner
            if ((vgaX >= x + width - CORNER_RADIUS) && (vgaY < y + CORNER_RADIUS)) begin
                edge_dx = (x + width - 1) - vgaX;
                edge_dy = vgaY - y;
                if ((edge_dx + edge_dy) < (CORNER_RADIUS - 1))
                    cut_corner = 1'b1;
            end
 
            // Bottom-left corner
            if ((vgaX < x + CORNER_RADIUS) && (vgaY >= y + height - CORNER_RADIUS)) begin
                edge_dx = vgaX - x;
                edge_dy = (y + height - 1) - vgaY;
                if ((edge_dx + edge_dy) < (CORNER_RADIUS - 1))
                    cut_corner = 1'b1;
            end
 
            // Bottom-right corner
            if ((vgaX >= x + width - CORNER_RADIUS) && (vgaY >= y + height - CORNER_RADIUS)) begin
                edge_dx = (x + width - 1) - vgaX;
                edge_dy = (y + height - 1) - vgaY;
                if ((edge_dx + edge_dy) < (CORNER_RADIUS - 1))
                    cut_corner = 1'b1;
            end
        end
 
        inside_rounded_shape = inside_platform && !cut_corner;
 
        if (inside_rounded_shape) begin
            // Darker top band to make the platform read more like Doodle Jump.
            if (vgaY < y + 3) begin
                r = base_r >> 1;
                g = (base_g >> 1) + 8'd40;
                b = base_b >> 1;
            end
            // Slight darker bottom edge for depth.
            else if (vgaY >= y + height - 2) begin
                r = base_r >> 1;
                g = base_g >> 1;
                b = base_b >> 1;
            end
            // Main fill.
            else begin
                r = base_r;
                g = base_g;
                b = base_b;
            end
        end
    end
end

endmodule
