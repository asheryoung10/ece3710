module doodle_jump #(
    parameter DATA_WIDTH = 16,
    parameter MEMORY_ADDR_WIDTH = 16
)
(
	input systemClock50MHz,
	
	input [9:0] switches,
	output [9:0] leds,
	input [3:0] push_buttons,
	
	output [6:0] hex0,
	output [6:0] hex1,
	output [6:0] hex2,
	output [6:0] hex3,
	output [6:0] hex4,
	output [6:0] hex5,
	
	
	inout i2c_clock,
	inout i2c_data,
	inout audio_masterClock,
	inout audio_leftRightClock,
	inout audio_bitClock,
	inout audio_data,
	
	output vga_clock,
	output vga_blank_n,
	output vga_hs,
	output vga_vs,
	output vga_sync_n,
	output [7:0] vga_red,
	output [7:0] vga_green,
	output [7:0] vga_blue,
	

	input GPIO1_28_data, 
	input GPIO0_28_data,
	output GPIO1_27_latch, 
	output GPIO1_26_cpu, 
	output GPIO0_27_latch,
	output GPIO0_26_cpu
);

// Reset Button
wire reset; 
assign reset = ~push_buttons[0];

// Player wires
wire [15:0] p1X;
wire [15:0] p1Y;
wire [15:0] p2X;
wire [15:0] p2Y;
wire [15:0] p3X;
wire [15:0] p3Y;
wire [15:0] p4X;
wire [15:0] p4Y;
wire [15:0] p1AnimationIndex;
wire [15:0] p2AnimationIndex;
wire [15:0] p3AnimationIndex;
wire [15:0] p4AnimationIndex;

wire [15:0] p1HighlightColor;
wire [15:0] p2HighlightColor;
wire [15:0] p3HighlightColor;
wire [15:0] p4HighlightColor;

wire [15:0] backgroundOffsetX;
wire [15:0] backgroundOffsetY;
wire [15:0] audioPitchIndex;

// VGA wires
wire [9:0] vgaPixelX;
wire [9:0] vgaPixelY;
wire [7:0] rectR;
wire [7:0] rectG;
wire [7:0] rectB;

// Shared memory wires
wire memoryWriteEnable;
wire [MEMORY_ADDR_WIDTH-1:0] memoryReadWriteAddress;
wire [DATA_WIDTH-1:0] registerFileContentsB;
wire [DATA_WIDTH-1:0] memoryContents;
wire [DATA_WIDTH-1:0] register3;
wire [DATA_WIDTH-1:0] register4;

// Controller (Left Header)
wire [15:0] snesButtons0;
// Controller (Right Header)
wire [15:0] snesButtons1;

snes snes1_instance (
	.systemClock50MHz(systemClock50MHz),
	.leds(),
	.push_buttons(push_buttons),
	.GPIOX_28_data(GPIO1_28_data),
	.GPIOX_27_latch(GPIO1_27_latch),
	.GPIOX_26_cpu(GPIO1_26_cpu),
	.buttons(snesButtons1)
);

snes snes0_instance (
	.systemClock50MHz(systemClock50MHz),
	.leds(),
	.push_buttons(push_buttons),
	.GPIOX_28_data(GPIO0_28_data),
	.GPIOX_27_latch(GPIO0_27_latch),
	.GPIOX_26_cpu(GPIO0_26_cpu),
	.buttons(snesButtons0)
);

vga vga_instance (
	.clk50(systemClock50MHz),
	.reset(reset),
	
		.p1X(p1X),
		.p1Y(p1Y),
		.p1AnimationIndex(p1AnimationIndex),
		.p1HighlightColor(p1HighlightColor),
		
		.p2X(p2X),
		.p2Y(p2Y),
		.p2AnimationIndex(p2AnimationIndex),
		.p2HighlightColor(p2HighlightColor),
		
	   .p3X(p3X),
		.p3Y(p3Y),
		.p3AnimationIndex(p3AnimationIndex),
		.p3HighlightColor(p3HighlightColor),
		
		.p4X(p4X),
		.p4Y(p4Y),
		.p4AnimationIndex(p4AnimationIndex),
		.p4HighlightColor(p4HighlightColor),
		
		.backgroundOffsetY(backgroundOffsetY),
		.backgroundOffsetX(backgroundOffsetX),
	
	.pixelX(vgaPixelX),
	.pixelY(vgaPixelY),
	
	.rectR(rectR),
	.rectG(rectG),
	.rectB(rectB),
	 
   .vga_clk(vga_clock),
   .vga_blank_n(vga_blank_n),
   .vga_vs(vga_vs),
   .vga_hs(vga_hs),
   .r(vga_red),
   .g(vga_green),
   .b(vga_blue),
	.shrinkHalf(switches[9])
);

cpu cpu_instance (
	.clock(systemClock50MHz),
	.reset(reset),
	
	.memoryWriteEnable(memoryWriteEnable),
	.registerFileContentsB(registerFileContentsB),
	.memoryReadWriteAddress(memoryReadWriteAddress),
	.memoryContents(memoryContents),
	
	.instructionRegisterContentsOutput(),
   .programCounterContentsOutput(),
   .programStateRegisterContentsOutput(),
   .aluResultOutput(),
   .aluFlagsOutput(),
   .controlUnitState(),
   .controlUnitNextState(),
	
	.p1Left(~snesButtons0[6]),
	.p1Right(~snesButtons0[7]),
	.p1Up(~snesButtons0[4]),
	.p1Down(~snesButtons0[5]),
	
	.p2Left(~snesButtons0[1]),
	.p2Right(~snesButtons0[8]),
	.p2Up(~snesButtons0[9]),
	.p2Down(~snesButtons0[0]),
	
	.p3Left(~snesButtons1[6]),
	.p3Right(~snesButtons1[7]),
	.p3Up(~snesButtons1[4]),
	.p3Down(~snesButtons1[5]),
	
	.p4Left(~snesButtons1[1]),
	.p4Right(~snesButtons1[8]),
	.p4Up(~snesButtons1[9]),
	.p4Down(~snesButtons1[0]),
	
	.vsync(vga_vs),
	.R3(register3),
	.R4(register4)
);

sharedMemory memory_instance
(
    .clock(systemClock50MHz),
	 .reset(reset),
	 
    .writeEnable(memoryWriteEnable),
    .writeData(registerFileContentsB),
    .readWriteAddress(memoryReadWriteAddress),
    .contents(memoryContents),
	 
	 .vgaX(vgaPixelX),
	 .vgaY(vgaPixelY),
	 .r(rectR),
	 .g(rectG),
	 .b(rectB),
	 
		.p1X(p1X),
		.p1Y(p1Y),
		.p1AnimationIndex(p1AnimationIndex),
		.p1HighlightColor(p1HighlightColor),
		
		.p2X(p2X),
		.p2Y(p2Y),
		.p2AnimationIndex(p2AnimationIndex),
		.p2HighlightColor(p2HighlightColor),
		
	   .p3X(p3X),
		.p3Y(p3Y),
		.p3AnimationIndex(p3AnimationIndex),
		.p3HighlightColor(p3HighlightColor),
		
		.p4X(p4X),
		.p4Y(p4Y),
		.p4AnimationIndex(p4AnimationIndex),
		.p4HighlightColor(p4HighlightColor),
		
		.backgroundOffsetX(backgroundOffsetX),
		.backgroundOffsetY(backgroundOffsetY),
		.audioPitchIndex()
);

audio_unit audio_unit_instance (
	.CLOCK_50(systemClock50MHz),
	.RESET_N(~reset),
	.configure_N(push_buttons[1]),
	.pitch(switches),
	.drum(push_buttons[3]),
	.enableOutput(switches[0]),
	.selectedCommand(switches[9:6]),
	
	.FPGA_I2C_SCLK(i2c_clock),
	.FPGA_I2C_SDAT(i2c_data),
	
	.AUD_XCK(audio_masterClock),
	.AUD_BCLK(audio_bitClock),
	.AUD_DACLRCK(audio_leftRightClock),
	.AUD_DACDAT(audio_data),
	.error(),
	.busy(),
	.done()
	
);

sixteen_bit_seven_seg segDriver (
        .value(register3), 
        .hex0(hex0),     
        .hex1(hex1),
        .hex2(hex2),
        .hex3(hex3)
 );

sixteen_bit_seven_seg segDriver_2 (
        .value(register4), 
        .hex0(hex4),     
        .hex1(hex5),
        .hex2(),
        .hex3()
 );
endmodule