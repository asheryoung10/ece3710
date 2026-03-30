`timescale 1ns/1ps
`include "game_map_defs.vh"

module tb_cpu_smoke;

reg clk;
reg rst;
wire memory_write_enable;
wire [15:0] memory_address;
wire [15:0] memory_write_data;
wire [15:0] memory_read_data;
wire [15:0] instruction_register_contents;
wire [15:0] program_counter_contents;
wire [15:0] program_state_contents;
wire [15:0] alu_result_output;
wire [4:0] alu_flags_output;
wire [2:0] control_state_output;
wire [2:0] control_next_state_output;

wire [15:0] player_x;
wire [15:0] player_y;
wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_x_bus;
wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_y_bus;
wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_wh_bus;
wire [15:0] score_status;
wire audio_configure_request;
wire audio_enable_output;
wire audio_drum_toggle;
wire [3:0] audio_selected_command;
wire [7:0] audio_pitch;

cpu_core cpu_core_instance (
    .clk(clk),
    .rst(rst),
    .memory_write_enable(memory_write_enable),
    .memory_address(memory_address),
    .memory_write_data(memory_write_data),
    .memory_read_data(memory_read_data),
    .instruction_register_contents(instruction_register_contents),
    .program_counter_contents(program_counter_contents),
    .program_state_contents(program_state_contents),
    .alu_result_output(alu_result_output),
    .alu_flags_output(alu_flags_output),
    .control_state_output(control_state_output),
    .control_next_state_output(control_next_state_output)
);

mem_router #(
    .ROM_INIT_FILE("mem/cpu_smoke.memh")
) mem_router_instance (
    .clk(clk),
    .rst(rst),
    .address(memory_address),
    .write_data(memory_write_data),
    .write_enable(memory_write_enable),
    .push_buttons(4'h0),
    .switches(10'h000),
    .audio_busy(1'b0),
    .audio_done(1'b0),
    .audio_error(1'b0),
    .audio_configure_ack(1'b0),
    .read_data(memory_read_data),
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

always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    rst = 1'b1;

    repeat (2) @(negedge clk);
    rst = 1'b0;

    repeat (60) @(negedge clk);

    if (player_x !== 16'd36) begin
        $display("tb_cpu_smoke failed: expected player_x 36, got %0d", player_x);
        $finish;
    end

    if (score_status !== 16'd8) begin
        $display("tb_cpu_smoke failed: expected score_status 8, got %0d", score_status);
        $finish;
    end

    if (program_counter_contents === 16'd0) begin
        $display("tb_cpu_smoke failed: program counter did not advance");
        $finish;
    end

    $display("tb_cpu_smoke passed");
    $finish;
end

endmodule
