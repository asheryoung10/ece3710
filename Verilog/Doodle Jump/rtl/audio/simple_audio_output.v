`timescale 1ns/1ps

module simple_audio_output (
    input wire clk_50mhz,
    input wire rst,
    input wire enable_output,
    input wire drum_toggle,
    input wire [7:0] pitch,
    output wire aud_xck,
    output wire aud_bclk,
    output wire aud_daclrck,
    output reg aud_dacdat
);

reg [1:0] master_divider;
reg [7:0] serial_divider;
reg [15:0] current_sample;
reg [15:0] tone_counter;
reg tone_level;
reg [15:0] tone_limit;
reg [15:0] lfsr;
wire [4:0] bit_index;

assign aud_xck = master_divider[1];
assign aud_bclk = serial_divider[2];
assign aud_daclrck = serial_divider[7];
assign bit_index = serial_divider[6:2];

always @(*) begin
    if ({8'd0, pitch} >= 16'd252)
        tone_limit = 16'd16;
    else
        tone_limit = 16'd1024 - ({8'd0, pitch} << 2);
end

always @(posedge clk_50mhz or posedge rst) begin
    if (rst)
        master_divider <= 2'b00;
    else
        master_divider <= master_divider + 2'd1;
end

always @(posedge aud_xck or posedge rst) begin
    if (rst)
        serial_divider <= 8'd0;
    else
        serial_divider <= serial_divider + 8'd1;
end

always @(posedge aud_daclrck or posedge rst) begin
    if (rst) begin
        current_sample <= 16'h0000;
        tone_counter <= 16'h0000;
        tone_level <= 1'b0;
        lfsr <= 16'hace1;
    end else if (!enable_output) begin
        current_sample <= 16'h0000;
        tone_counter <= tone_limit;
        tone_level <= 1'b0;
    end else if (drum_toggle) begin
        lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
        current_sample <= {lfsr[7:0], lfsr[15:8]};
    end else begin
        if (tone_counter == 16'd0) begin
            tone_counter <= tone_limit;
            tone_level <= ~tone_level;
        end else begin
            tone_counter <= tone_counter - 16'd1;
        end

        if (tone_level)
            current_sample <= 16'h6000;
        else
            current_sample <= 16'ha000;
    end
end

always @(negedge aud_bclk or posedge rst) begin
    if (rst)
        aud_dacdat <= 1'b0;
    else if ((bit_index >= 5'd1) && (bit_index <= 5'd16))
        aud_dacdat <= current_sample[16 - bit_index];
    else
        aud_dacdat <= 1'b0;
end

endmodule
