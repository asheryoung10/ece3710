`timescale 1ns/1ps

module audio_subsystem (
    input wire clk_50mhz,
    input wire rst,
    input wire configure_request,
    input wire [3:0] selected_command,
    input wire [7:0] pitch,
    input wire drum_toggle,
    input wire enable_output,
    output reg configure_ack,
    output reg busy,
    output reg done,
    output reg error,
    inout wire i2c_clock,
    inout wire i2c_data,
    output wire audio_master_clock,
    output wire audio_left_right_clock,
    output wire audio_bit_clock,
    output wire audio_data
);

reg configure_active;
wire busy_internal;
wire done_internal;
wire error_internal;

always @(posedge clk_50mhz or posedge rst) begin
    if (rst) begin
        configure_active <= 1'b0;
        configure_ack <= 1'b0;
    end else begin
        configure_ack <= 1'b0;

        if (configure_request && !configure_active && !busy_internal) begin
            configure_active <= 1'b1;
            configure_ack <= 1'b1;
        end else if (busy_internal) begin
            configure_active <= 1'b0;
        end
    end
end

audio_configurator_select audio_configurator_select_instance (
    .systemClock(clk_50mhz),
    .reset(rst),
    .configure(configure_active),
    .selectedCommand(selected_command),
    .busy(busy_internal),
    .done(done_internal),
    .encounteredError(error_internal),
    .i2c_clock(i2c_clock),
    .i2c_data(i2c_data)
);

simple_audio_output simple_audio_output_instance (
    .clk_50mhz(clk_50mhz),
    .rst(rst),
    .enable_output(enable_output),
    .drum_toggle(drum_toggle),
    .pitch(pitch),
    .aud_xck(audio_master_clock),
    .aud_bclk(audio_bit_clock),
    .aud_daclrck(audio_left_right_clock),
    .aud_dacdat(audio_data)
);

always @(*) begin
    busy = busy_internal;
    done = done_internal;
    error = error_internal;
end

endmodule
