module sharedMemory
#(
    parameter DATA_WIDTH = 16,
    parameter NUM_RECTS  = 4
)
(
    input clock,
    input writeEnable,
    input [15:0] writeData,
    input [15:0] readWriteAddress,
    output [15:0] contents,
	 

    input [9:0] vgaX,
    input [9:0] vgaY,
    output reg [7:0] r,
    output reg [7:0] g,
    output reg [7:0] b,
	 output reg [15:0] player_x,
	 output reg [15:0] player_y
);

// --------------------------------------------------
// Derived constants
// --------------------------------------------------
localparam REGS_PER_RECT = 3;
localparam TOTAL_REGS    = NUM_RECTS * REGS_PER_RECT;

// --------------------------------------------------
// BRAM (normal memory)
// --------------------------------------------------
wire isRectAccess;
assign isRectAccess = readWriteAddress[15] && (readWriteAddress[4:0] < TOTAL_REGS);

wire enableCPUWrite;
assign enableCPUWrite = writeEnable && !isRectAccess;
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
    .contents(contents)
);

// --------------------------------------------------
// Rectangle RegistersNUM_RECTS
// --------------------------------------------------
reg [15:0] rect_x  [0:NUM_RECTS-1];
reg [15:0] rect_y  [0:NUM_RECTS-1];
reg [15:0] rect_wh [0:NUM_RECTS-1];



always@(posedge clock) begin
	if(writeEnable) begin
		if(readWriteAddress[14]) begin
			// TODO CHANGE THIS CUZ IT WRITE TO TOO MUCH
			if(readWriteAddress[0]) begin
				player_x <= writeData; 
			end else begin
				player_y <= writeData;
			end
		end
	end
end



// Decode index
wire [$clog2(TOTAL_REGS)-1:0] regIndex;
assign regIndex = readWriteAddress[$clog2(TOTAL_REGS)-1:0];

wire [$clog2(NUM_RECTS)-1:0] rectIndex;
assign rectIndex = regIndex / REGS_PER_RECT;

wire [1:0] fieldIndex;
assign fieldIndex = regIndex % REGS_PER_RECT;

// Write logic (loop-based, scalable)
integer i;
always @(posedge clock) begin
    if (writeEnable && isRectAccess) begin
        for (i = 0; i < NUM_RECTS; i = i + 1) begin
            if (rectIndex == i) begin
                case (fieldIndex)
                    0: rect_x[i]  <= writeData;
                    1: rect_y[i]  <= writeData;
                    2: rect_wh[i] <= writeData;
                endcase
            end
        end
    end
end

// --------------------------------------------------
// VGA Rectangle Rendering
// --------------------------------------------------
reg inside;
reg [7:0] width;
reg [7:0] height;

always @(*) begin
    inside = 0;

    for (i = 0; i < NUM_RECTS; i = i + 1) begin
        width  = rect_wh[i][15:8];
        height = rect_wh[i][7:0];

        if (
            (vgaX >= rect_x[i]) &&
            (vgaX < rect_x[i] + width) &&
            (vgaY >= rect_y[i]) &&
            (vgaY < rect_y[i] + height)
        ) begin
            inside = 1;
        end
    end

    if (inside) begin
        r = 8'hFF;
        g = 8'hFF;
        b = 8'hFF;
    end else begin
        r = 8'h00;
        g = 8'h00;
        b = 8'h00;
    end
end



localparam SCREEN_W = 640;
localparam SCREEN_H = 480;

initial begin
    for (i = 0; i < NUM_RECTS; i = i + 1) begin
        // Spread X across screen
        rect_x[i] = (i * (SCREEN_W / NUM_RECTS));

        // Stagger Y so they aren’t all in a line
        rect_y[i] = (i * 40) % SCREEN_H;

        // Fixed size (safe so they stay on screen)
        rect_wh[i] = {8'd50, 8'd30}; // width=50, height=30
    end
end


endmodule
