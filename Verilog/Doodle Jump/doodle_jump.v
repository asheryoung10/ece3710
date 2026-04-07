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
	
	//cpu debug
	output [DATA_WIDTH-1:0] instructionRegisterContentsOutput,
   output [DATA_WIDTH-1:0] programCounterContentsOutput,
   output [DATA_WIDTH-1:0] programStateRegisterContentsOutput,
   output [DATA_WIDTH-1:0] aluResultOutput,
   output [4:0] aluFlagsOutput,
	 
	output [2:0] controlUnitState,
	output [2:0] controlUnitNextState
);
assign reset = ~push_buttons[0];
wire [15:0] player_x;
wire [15:0] player_y;


wire [9:0] vgaPixelX;
wire [9:0] vgaPixelY;
wire [7:0] rectR;
wire [7:0] rectG;
wire [7:0] rectB;
vga vga_instance (
	.clk50(systemClock50MHz),
	.rstInv(~reset),
	.vga_clk(vga_clock),
	.vga_blank_n(vga_blank_n),
	.vga_vs(vga_vs),
	.vga_hs(vga_hs),
	.r(vga_red),
	.g(vga_green),
	.b(vga_blue),
	.playerX(player_x),
	.playerY(player_y),
	.playerAnimationIndex(switches[9:6]),
	.pixelX(vgaPixelX),
	.pixelY(vgaPixelY),
	.rectR(rectR),
	.rectB(rectB),
	.rectG(rectG)
);




wire memoryWriteEnable;
wire [MEMORY_ADDR_WIDTH-1:0] memoryReadWriteAddress;
wire [DATA_WIDTH-1:0] registerFileContentsB;
wire [DATA_WIDTH-1:0] memoryContents;
wire [DATA_WIDTH-1:0] register3;
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
	.leftButton(~push_buttons[3]),
	.rightButton(~push_buttons[2]),
	.jumpButton(~push_buttons[1]),
	.vsync(vga_vs),
	.R3(register3)
);


sharedMemory 
#(
    .DATA_WIDTH(DATA_WIDTH)
)
memory_instance
(
    // Inputs
    .clock(systemClock50MHz),
    .writeEnable(memoryWriteEnable),
    .writeData(registerFileContentsB),
    .readWriteAddress(memoryReadWriteAddress),
    // Outputs
    .contents(memoryContents),
	 .reset(reset),
	 .vgaX(vgaPixelX),
	 .vgaY(vgaPixelY),
	 .r(rectR),
	 .g(rectG),
	 .b(rectB),
	 
	 .player_x(player_x),
	 .player_y(player_y)
	 
);

audio_unit audio_unit_instance (
	.CLOCK_50(systemClock50MHz),
	.RESET_N(~reset),
	.configure_N(push_buttons[1]),
	.pitch({{6'b000000}, switches[2:1]}),
	.drum(1'b0),
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