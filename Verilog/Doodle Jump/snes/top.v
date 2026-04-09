module snes #(
    parameter DATA_WIDTH = 16,
    parameter MEMORY_ADDR_WIDTH = 16
)
(
	input systemClock50MHz,
	
	output [9:0] leds,
	input [3:0] push_buttons,
	input GPIO1_28_data,
	output GPIO1_27_latch,
	output GPIO1_26_cpu,
	output [15:0]buttons
);
// Gray = Vsrc +5V
// Brown = GND
// Blue = GPIO1_26_cpuClk
// Yellow = GPIO1_27_LatchClk
// Red = GPIO1_28_Serial Data

//-----Button States --> Actual Button-----
// 0-->B | 1-->Y | 2-->SELECT | 3-->START
// 4-->UP | 5-->DOWN | 6-->LEFT | 7-->RIGHT
// 8-->A | 9-->X | 10-->Left Bumper (L) | 11-->Right Bumper (R)

wire [15:0]button_states;
wire cpuClk_en;
wire latchClk;
wire cpuClk;
 
SNES_clkdiv clkInstance
	(
		.clk(systemClock50MHz),
		.rst(~push_buttons[0]),
		.en(cpuClk_en),
		.SNES_clk(cpuClk)
	);
	
SNES_latchGen latchInstance
	(
		.clk(systemClock50MHz),
		.rst(~push_buttons[0]),
		.snes_clk(latchClk)
	);

wire [15:0] snes_buttons;
wire        snes_sample;
	
SNES_Controller controllerInstance
	(
		.fpga_clk(systemClock50MHz),
		.latch_clk(latchClk),
		.data(GPIO1_28_data),
		.cpu_clk(cpuClk),
		.cpuClk_en(cpuClk_en),
		.rst(~push_buttons[0]),
		.buttons_pressed(button_states)
	);
	
assign leds[0] = button_states[0]; // B
assign leds[1] = button_states[1]; // Y
assign leds[2] = button_states[2]; // Select
assign leds[3] = button_states[3]; // Start
assign leds[4] = button_states[4]; // Up
assign leds[5] = button_states[5]; // Down
assign leds[6] = button_states[6]; // Left
assign leds[7] = button_states[7]; // Right
assign leds[8] = button_states[8]; // A
assign leds[9] = button_states[9]; // X
assign buttons = button_states;

assign GPIO1_27_latch = latchClk;
assign GPIO1_26_cpu = cpuClk;
endmodule
