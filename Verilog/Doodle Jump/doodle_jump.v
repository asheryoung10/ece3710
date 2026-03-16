module doodle_jump (
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
	output [7:0] vga_blue
);
assign reset = ~push_buttons[0];
assign hex0 = switches[6:0];
assign hex1 = switches [9:7];

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
	.playerX(switches[5:0]),
	.playerY(0),
	.playerAnimationIndex(switches[9:6]),
);

cpu cpu_instance (
	.clock(systemClock50MHz),
	.reset(reset),
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
	.error(leds[0]),
	.busy(leds[2]),
	.done(leds[1])
	
);

endmodule