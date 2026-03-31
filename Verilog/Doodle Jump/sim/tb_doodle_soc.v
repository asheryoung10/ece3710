`timescale 1ns/1ps

module tb_doodle_soc;

reg systemClock50MHz;
reg [9:0] switches;
wire [9:0] leds;
reg [3:0] push_buttons;
wire [6:0] hex0;
wire [6:0] hex1;
wire [6:0] hex2;
wire [6:0] hex3;
wire [6:0] hex4;
wire [6:0] hex5;
tri i2c_clock;
tri i2c_data;
tri audio_masterClock;
tri audio_leftRightClock;
tri audio_bitClock;
tri audio_data;
wire vga_clock;
wire vga_blank_n;
wire vga_hs;
wire vga_vs;
wire vga_sync_n;
wire [7:0] vga_red;
wire [7:0] vga_green;
wire [7:0] vga_blue;
wire [15:0] instructionRegisterContentsOutput;
wire [15:0] programCounterContentsOutput;
wire [15:0] programStateRegisterContentsOutput;
wire [15:0] aluResultOutput;
wire [4:0] aluFlagsOutput;
wire [2:0] controlUnitState;
wire [2:0] controlUnitNextState;

// Instantiate the full board wrapper to exercise the integrated SoC.
doodle_jump dut (
    .systemClock50MHz(systemClock50MHz),
    .switches(switches),
    .leds(leds),
    .push_buttons(push_buttons),
    .hex0(hex0),
    .hex1(hex1),
    .hex2(hex2),
    .hex3(hex3),
    .hex4(hex4),
    .hex5(hex5),
    .i2c_clock(i2c_clock),
    .i2c_data(i2c_data),
    .audio_masterClock(audio_masterClock),
    .audio_leftRightClock(audio_leftRightClock),
    .audio_bitClock(audio_bitClock),
    .audio_data(audio_data),
    .vga_clock(vga_clock),
    .vga_blank_n(vga_blank_n),
    .vga_hs(vga_hs),
    .vga_vs(vga_vs),
    .vga_sync_n(vga_sync_n),
    .vga_red(vga_red),
    .vga_green(vga_green),
    .vga_blue(vga_blue),
    .instructionRegisterContentsOutput(instructionRegisterContentsOutput),
    .programCounterContentsOutput(programCounterContentsOutput),
    .programStateRegisterContentsOutput(programStateRegisterContentsOutput),
    .aluResultOutput(aluResultOutput),
    .aluFlagsOutput(aluFlagsOutput),
    .controlUnitState(controlUnitState),
    .controlUnitNextState(controlUnitNextState)
);

// Generate the 50 MHz simulation clock used by the top-level design.
always #10 systemClock50MHz = ~systemClock50MHz;

// Reset the SoC, let it run, and verify a few integrated outputs.
initial begin
    systemClock50MHz = 1'b0;
    switches = 10'h180;
    push_buttons = 4'b1111;

    repeat (2) @(negedge systemClock50MHz);
    push_buttons[0] = 1'b0;
    repeat (2) @(negedge systemClock50MHz);
    push_buttons[0] = 1'b1;

    repeat (140) @(negedge systemClock50MHz);

    if (dut.doodle_jump_top_instance.mem_router_instance.player_x <= 16'd200) begin
        $display("tb_doodle_soc failed: expected player_x to move from its initialized ROM value");
        $finish;
    end

    if (dut.doodle_jump_top_instance.mem_router_instance.audio_pitch !== 8'd32) begin
        $display("tb_doodle_soc failed: audio pitch register was not initialized");
        $finish;
    end

    if (vga_blank_n === 1'bx) begin
        $display("tb_doodle_soc failed: VGA blank should be driven");
        $finish;
    end

    $display("tb_doodle_soc passed");
    $finish;
end

endmodule
