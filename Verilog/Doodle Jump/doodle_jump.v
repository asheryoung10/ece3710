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
	output GPIO1_27_latch,
	output GPIO1_26_cpu
);

// Reset Button
wire reset; 
assign reset = ~push_buttons[0];

// Player wires
wire [15:0] p1X;
wire [15:0] p1Y;
wire [15:0] p2X;
wire [15:0] p2Y;
wire [15:0] p1AnimationIndex;
wire [15:0] p2AnimationIndex;
wire [15:0] p1BackgroundIndex;
wire [15:0] p2BackgroundIndex;
wire [15:0] p1Score;
wire [15:0] p2Score;
wire [15:0] p1PitchIndex;
wire [15:0] p2PitchIndex;

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

// Controller
wire [15:0] snesButtons;

snes snes_instance (
	.systemClock50MHz(systemClock50MHz),
	.leds(),
	.push_buttons(push_buttons),
	.GPIO1_28_data(GPIO1_28_data),
	.GPIO1_27_latch(GPIO1_27_latch),
	.GPIO1_26_cpu(GPIO1_26_cpu),
	.buttons(snesButtons)
);

vga vga_instance (
	.clk50(systemClock50MHz),
	.reset(reset),
	
	.p1X(p1X),
	.p1Y(p1Y),
	.p2X(p2X),
	.p2Y(p2Y),
	.p1AnimationIndex(p1AnimationIndex),
	.p2AnimationIndex(p2AnimationIndex),
	.p1BackgroundIndex(p1BackgroundIndex),
	.p2BackgroundIndex(p2BackgroundIndex),
	
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
   .b(vga_blue)
);

cpu cpu_instance (
	.clock(systemClock50MHz),
	.reset(reset),
	
	.memoryWriteEnable(memoryWriteEnable),
	.registerFileContentsB(registerFileContentsB),
	.memoryReadWriteAddress(memoryReadWriteAddress),
	.memoryContents(memoryContents),
	
	.instructionRegisterContentsOutput(instructionRegisterContentsOutput),
   .programCounterContentsOutput(programCounterContentsOutput),
   .programStateRegisterContentsOutput(programStateRegisterContentsOutput),
   .aluResultOutput(aluResultOutput),
   .aluFlagsOutput(aluFlagsOutput),
   .controlUnitState(controlUnitState),
   .controlUnitNextState(controlUnitNextState),
	.leftButton(~push_buttons[3] || ~snesButtons[1] || ~snesButtons[10]),
	.rightButton(~push_buttons[2] || ~snesButtons[8] || ~snesButtons[11]),
	.jumpButton(~push_buttons[1] || ~snesButtons[0]),
	.leftButtonTwo(~snesButtons[6]),
	.rightButtonTwo(~snesButtons[7]),
	.jumpButtonTwo(~snesButtons[5]),
	.vsync(vga_vs),
	.R3(register3)
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
	 
	 .playerOneX(p1X),
	 .playerOneY(p1Y),
	 .playerOneAnimationIndex(p1AnimationIndex),
	 .playerOneBackgroundIndex(p2BackgroundIndex),
	 .playerOnePitchIndex(p1PitchIndex),
	 .playerOneScore(p1Score),
	 .playerTwoX(p2X),
	 .playerTwoY(p2Y),
	 .playerTwoAnimationIndex(p2AnimationIndex),
	 .playerTwoBackgroundIndex(p2BackgroundIndex),
	 .playerTwoPitchIndex(p2PitchIndex),
	 .playerTwoScore(p2Score)
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
endmodule