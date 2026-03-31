`timescale 1ns/1ps
`include "game_map_defs.vh"

module audio_regs (
    input wire clk,
    input wire rst,
    input wire chip_select,
    input wire write_enable,
    input wire [15:0] address,
    input wire [15:0] write_data,
    input wire configure_ack,
    input wire busy,
    input wire done,
    input wire error,
    output reg [15:0] read_data,
    output reg configure_request,
    output reg enable_output,
    output reg drum_toggle,
    output reg [3:0] selected_command,
    output reg [7:0] pitch
);

// Mirror the most recent audio register write for debug readback.
reg [15:0] debug_shadow;

// Reset the audio control state and capture MMIO writes from the CPU.
always @(posedge clk or posedge rst) begin
    if (rst) begin
        configure_request <= 1'b0;
        enable_output <= 1'b0;
        drum_toggle <= 1'b0;
        selected_command <= 4'd0;
        pitch <= 8'd32;
        debug_shadow <= 16'h0000;
    end else begin
        if (configure_ack)
            configure_request <= 1'b0;

        if (chip_select && write_enable) begin
            case (address)
                `DJ_AUDIO_CONTROL_ADDR: begin
                    enable_output <= write_data[0];
                    drum_toggle <= write_data[1];
                    selected_command <= write_data[7:4];
                    debug_shadow <= write_data;
                    if (write_data[2])
                        configure_request <= 1'b1;
                end

                `DJ_AUDIO_PITCH_ADDR: begin
                    pitch <= write_data[7:0];
                    debug_shadow <= write_data;
                end

                `DJ_AUDIO_DEBUG_ADDR: begin
                    debug_shadow <= write_data;
                end
            endcase
        end
    end
end

// Return the selected audio control, pitch, status, or debug register value.
always @(*) begin
    case (address)
        `DJ_AUDIO_CONTROL_ADDR: read_data = {8'd0, selected_command, configure_request, drum_toggle, enable_output};
        `DJ_AUDIO_PITCH_ADDR: read_data = {8'd0, pitch};
        `DJ_AUDIO_STATUS_ADDR: read_data = {12'd0, configure_request, error, done, busy};
        `DJ_AUDIO_DEBUG_ADDR: read_data = debug_shadow;
        default: read_data = 16'h0000;
    endcase
end

endmodule
