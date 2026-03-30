`timescale 1ns/1ps
`include "game_map_defs.vh"

module doodle_jump_top (
    input wire systemClock50MHz,
    input wire [9:0] switches,
    output reg [9:0] leds,
    input wire [3:0] push_buttons,
    output wire [6:0] hex0,
    output wire [6:0] hex1,
    output wire [6:0] hex2,
    output wire [6:0] hex3,
    output wire [6:0] hex4,
    output wire [6:0] hex5,
    inout wire i2c_clock,
    inout wire i2c_data,
    inout wire audio_masterClock,
    inout wire audio_leftRightClock,
    inout wire audio_bitClock,
    inout wire audio_data,
    output wire vga_clock,
    output wire vga_blank_n,
    output wire vga_hs,
    output wire vga_vs,
    output reg vga_sync_n,
    output wire [7:0] vga_red,
    output wire [7:0] vga_green,
    output wire [7:0] vga_blue,
    output wire [15:0] instructionRegisterContentsOutput,
    output wire [15:0] programCounterContentsOutput,
    output wire [15:0] programStateRegisterContentsOutput,
    output wire [15:0] aluResultOutput,
    output wire [4:0] aluFlagsOutput,
    output wire [2:0] controlUnitState,
    output wire [2:0] controlUnitNextState
);

wire rst;
wire [3:0] synced_buttons;
wire [9:0] synced_switches;

wire cpu_memory_write_enable;
wire [15:0] cpu_memory_address;
wire [15:0] cpu_memory_write_data;
wire [15:0] cpu_memory_read_data;

wire [15:0] player_x;
wire [15:0] player_y;
wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_x_bus;
wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_y_bus;
wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_wh_bus;
wire [15:0] score_status;

wire audio_configure_request;
wire audio_configure_ack;
wire audio_enable_output;
wire audio_drum_toggle;
wire [3:0] audio_selected_command;
wire [7:0] audio_pitch;
wire audio_busy;
wire audio_done;
wire audio_error;

assign rst = ~push_buttons[0];

input_synchronizer #(
    .WIDTH(4)
) button_synchronizer (
    .clk(systemClock50MHz),
    .rst(rst),
    .async_in(push_buttons),
    .sync_out(synced_buttons)
);

input_synchronizer #(
    .WIDTH(10)
) switch_synchronizer (
    .clk(systemClock50MHz),
    .rst(rst),
    .async_in(switches),
    .sync_out(synced_switches)
);

cpu_core cpu_core_instance (
    .clk(systemClock50MHz),
    .rst(rst),
    .memory_write_enable(cpu_memory_write_enable),
    .memory_address(cpu_memory_address),
    .memory_write_data(cpu_memory_write_data),
    .memory_read_data(cpu_memory_read_data),
    .instruction_register_contents(instructionRegisterContentsOutput),
    .program_counter_contents(programCounterContentsOutput),
    .program_state_contents(programStateRegisterContentsOutput),
    .alu_result_output(aluResultOutput),
    .alu_flags_output(aluFlagsOutput),
    .control_state_output(controlUnitState),
    .control_next_state_output(controlUnitNextState)
);

mem_router mem_router_instance (
    .clk(systemClock50MHz),
    .rst(rst),
    .address(cpu_memory_address),
    .write_data(cpu_memory_write_data),
    .write_enable(cpu_memory_write_enable),
    .push_buttons(synced_buttons),
    .switches(synced_switches),
    .audio_busy(audio_busy),
    .audio_done(audio_done),
    .audio_error(audio_error),
    .audio_configure_ack(audio_configure_ack),
    .read_data(cpu_memory_read_data),
    .player_x(player_x),
    .player_y(player_y),
    .platform_x_bus(platform_x_bus),
    .platform_y_bus(platform_y_bus),
    .platform_wh_bus(platform_wh_bus),
    .score_status(score_status),
    .audio_configure_request(audio_configure_request),
    .audio_enable_output(audio_enable_output),
    .audio_drum_toggle(audio_drum_toggle),
    .audio_selected_command(audio_selected_command),
    .audio_pitch(audio_pitch)
);

vga_subsystem vga_subsystem_instance (
    .clk_50mhz(systemClock50MHz),
    .rst(rst),
    .player_x(player_x),
    .player_y(player_y),
    .platform_x_bus(platform_x_bus),
    .platform_y_bus(platform_y_bus),
    .platform_wh_bus(platform_wh_bus),
    .player_style_index(synced_switches[9:6]),
    .vga_clock(vga_clock),
    .vga_blank_n(vga_blank_n),
    .vga_hs(vga_hs),
    .vga_vs(vga_vs),
    .vga_red(vga_red),
    .vga_green(vga_green),
    .vga_blue(vga_blue)
);

audio_subsystem audio_subsystem_instance (
    .clk_50mhz(systemClock50MHz),
    .rst(rst),
    .configure_request(audio_configure_request),
    .selected_command(audio_selected_command),
    .pitch(audio_pitch),
    .drum_toggle(audio_drum_toggle),
    .enable_output(audio_enable_output),
    .configure_ack(audio_configure_ack),
    .busy(audio_busy),
    .done(audio_done),
    .error(audio_error),
    .i2c_clock(i2c_clock),
    .i2c_data(i2c_data),
    .audio_master_clock(audio_masterClock),
    .audio_left_right_clock(audio_leftRightClock),
    .audio_bit_clock(audio_bitClock),
    .audio_data(audio_data)
);

hex_decoder hex0_decoder (
    .value(score_status[3:0]),
    .segments(hex0)
);

hex_decoder hex1_decoder (
    .value(score_status[7:4]),
    .segments(hex1)
);

hex_decoder hex2_decoder (
    .value(score_status[11:8]),
    .segments(hex2)
);

hex_decoder hex3_decoder (
    .value(score_status[15:12]),
    .segments(hex3)
);

hex_decoder hex4_decoder (
    .value(player_x[3:0]),
    .segments(hex4)
);

hex_decoder hex5_decoder (
    .value(player_y[3:0]),
    .segments(hex5)
);

always @(*) begin
    leds = {audio_selected_command, audio_error, audio_done, audio_busy, controlUnitState};
    vga_sync_n = 1'b0;
end

endmodule
