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
	 

    input [9:0] vgaX,
    input [9:0] vgaY,
    output reg [7:0] r,
    output reg [7:0] g,
    output reg [7:0] b,
	 output reg [15:0] player_x,
	 output reg [15:0] player_y,
	 output wire [15:0] audio_pitch
);



wire isRectAccess; assign isRectAccess = readWriteAddress[15:6] == 10'b1000000000;
wire isPlayerAccess; assign isPlayerAccess= readWriteAddress[15:1] == 15'b110000000000000;
wire isMemoryAccess; assign isMemoryAccess = !isRectAccess && !isPlayerAccess;
wire enableRectWrite; assign enableRectWrite = writeEnable && isRectAccess;
wire enablePlayerWrite; assign enablePlayerWrite = writeEnable && isPlayerAccess;
wire enableCPUWrite; assign enableCPUWrite = writeEnable && isMemoryAccess;
wire [15:0] contentsCPU;
reg [15:0] contentsPlayer;
reg [15:0] contentsRect;
assign audio_pitch = 0;


// CPU Memory
memory 
#(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(10)
)
cpu_memory_instance
(
    .clock(clock),
    .writeEnable(enableCPUWrite),
    .writeData(writeData),
    .readWriteAddress(readWriteAddress[9:0]),
    .contents(contentsCPU)
);

// Player Memory
always@(posedge clock) begin
	if(enablePlayerWrite) begin
			if(readWriteAddress[0]) begin
				player_y <= writeData;
				contentsPlayer <= writeData;
			end else begin
				player_x <= writeData;
				contentsPlayer <= writeData;
			end
	end else begin
		if(readWriteAddress[0]) begin
			contentsPlayer <= player_y;
		end else begin
			contentsPlayer <= player_x;
			 
		end
	end
end

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
integer i;
always @(*) begin

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

        if (
            (vgaX >= x) &&
            (vgaX < x + width) &&
            (vgaY >= y) &&
            (vgaY < y + height)
        ) begin
            r = {color[15:11], 3'b000};
            g = {color[10:5],  2'b00};
            b = {color[4:0],   3'b000};
        end
    end
end

// Give rectangels initial positions.
localparam SCREEN_W = 640;
localparam SCREEN_H = 480;
initial begin
    for (i = 0; i < 16; i = i + 1) begin
        rect_data[i*4 + 0] = (i * (SCREEN_W / 16));
        rect_data[i*4 + 1] = (i * 40) % SCREEN_H;
        rect_data[i*4 + 2] = {8'd50, 8'd30};

        // simple varying colors
        case (i)
            0: rect_data[i*4 + 3] = 16'hF800; // red
            1: rect_data[i*4 + 3] = 16'h07E0; // green
            2: rect_data[i*4 + 3] = 16'h001F; // blue
            3: rect_data[i*4 + 3] = 16'hFFE0; // yellow
            default: rect_data[i*4 + 3] = 16'hFFFF; // white
        endcase
    end
end
endmodule
