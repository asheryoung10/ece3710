`timescale 1ns/1ps
`include "game_map_defs.vh"

module tb_mmio_decode;

reg clk;
reg rst;
reg [15:0] address;
reg [15:0] write_data;
reg write_enable;
reg [3:0] push_buttons;
reg [9:0] switches;
reg audio_busy;
reg audio_done;
reg audio_error;
reg audio_configure_ack;
wire [15:0] read_data;
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

mem_router #(
    .ROM_INIT_FILE("mem/cpu_smoke.memh")
) dut (
    .clk(clk),
    .rst(rst),
    .address(address),
    .write_data(write_data),
    .write_enable(write_enable),
    .push_buttons(push_buttons),
    .switches(switches),
    .audio_busy(audio_busy),
    .audio_done(audio_done),
    .audio_error(audio_error),
    .audio_configure_ack(audio_configure_ack),
    .read_data(read_data),
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

task write_word;
    input [15:0] addr;
    input [15:0] value;
    begin
        @(negedge clk);
        address = addr;
        write_data = value;
        write_enable = 1'b1;
        @(negedge clk);
        write_enable = 1'b0;
    end
endtask

initial begin
    clk = 1'b0;
    rst = 1'b1;
    address = 16'h0000;
    write_data = 16'h0000;
    write_enable = 1'b0;
    push_buttons = 4'ha;
    switches = 10'h155;
    audio_busy = 1'b0;
    audio_done = 1'b0;
    audio_error = 1'b0;
    audio_configure_ack = 1'b0;

    repeat (2) @(negedge clk);
    rst = 1'b0;

    write_word(`DJ_PLAYER_X_ADDR, 16'd111);
    address = `DJ_PLAYER_X_ADDR;
    #1;
    if (read_data !== 16'd111) begin
        $display("tb_mmio_decode failed: PLAYER_X readback mismatch");
        $finish;
    end

    write_word(`DJ_PLATFORM_BASE_ADDR + (16'd2 * `DJ_PLATFORM_WORDS) + 16'd1, 16'd222);
    address = `DJ_PLATFORM_BASE_ADDR + (16'd2 * `DJ_PLATFORM_WORDS) + 16'd1;
    #1;
    if (read_data !== 16'd222) begin
        $display("tb_mmio_decode failed: platform register readback mismatch");
        $finish;
    end

    write_word(`DJ_AUDIO_PITCH_ADDR, 16'd77);
    address = `DJ_AUDIO_PITCH_ADDR;
    #1;
    if (audio_pitch !== 8'd77) begin
        $display("tb_mmio_decode failed: audio pitch register mismatch");
        $finish;
    end

    write_word(`DJ_AUDIO_CONTROL_ADDR, 16'h0035);
    address = `DJ_AUDIO_CONTROL_ADDR;
    #1;
    if (audio_enable_output !== 1'b1) begin
        $display("tb_mmio_decode failed: audio enable bit did not latch");
        $finish;
    end

    if (audio_configure_request !== 1'b1) begin
        $display("tb_mmio_decode failed: audio configure request not raised");
        $finish;
    end

    audio_configure_ack = 1'b1;
    @(negedge clk);
    audio_configure_ack = 1'b0;
    #1;
    if (audio_configure_request !== 1'b0) begin
        $display("tb_mmio_decode failed: audio configure request did not clear after ack");
        $finish;
    end

    address = `DJ_BUTTONS_ADDR;
    #1;
    if (read_data[3:0] !== push_buttons) begin
        $display("tb_mmio_decode failed: buttons MMIO mismatch");
        $finish;
    end

    address = `DJ_SWITCHES_ADDR;
    #1;
    if (read_data[9:0] !== switches) begin
        $display("tb_mmio_decode failed: switches MMIO mismatch");
        $finish;
    end

    $display("tb_mmio_decode passed");
    $finish;
end

endmodule
