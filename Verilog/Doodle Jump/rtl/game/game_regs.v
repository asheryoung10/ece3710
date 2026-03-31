`timescale 1ns/1ps
`include "game_map_defs.vh"

module game_regs (
    input wire clk,
    input wire rst,
    input wire chip_select,
    input wire write_enable,
    input wire [15:0] address,
    input wire [15:0] write_data,
    output reg [15:0] read_data,
    output reg [15:0] player_x,
    output reg [15:0] player_y,
    output wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_x_bus,
    output wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_y_bus,
    output wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_wh_bus,
    output reg [15:0] score_status
);

// Store the player, platform, and score state exposed over MMIO.
reg [15:0] platform_x_mem[0:`DJ_NUM_PLATFORMS-1];
reg [15:0] platform_y_mem[0:`DJ_NUM_PLATFORMS-1];
reg [15:0] platform_wh_mem[0:`DJ_NUM_PLATFORMS-1];
integer index;
genvar flatten_index;

// Flatten the per-platform memories onto the packed renderer buses.
generate
    for (flatten_index = 0; flatten_index < `DJ_NUM_PLATFORMS; flatten_index = flatten_index + 1) begin : flatten_platform_buses
        assign platform_x_bus[(flatten_index*16)+15:(flatten_index*16)] = platform_x_mem[flatten_index];
        assign platform_y_bus[(flatten_index*16)+15:(flatten_index*16)] = platform_y_mem[flatten_index];
        assign platform_wh_bus[(flatten_index*16)+15:(flatten_index*16)] = platform_wh_mem[flatten_index];
    end
endgenerate

// Reset the game state defaults and capture CPU writes into the MMIO registers.
always @(posedge clk or posedge rst) begin
    if (rst) begin
        player_x <= `DJ_PLAYER_DEFAULT_X;
        player_y <= `DJ_PLAYER_DEFAULT_Y;
        score_status <= `DJ_DEFAULT_SCORE;

        for (index = 0; index < `DJ_NUM_PLATFORMS; index = index + 1) begin
            platform_x_mem[index] <= 16'd48 + (index * 16'd144);
            platform_y_mem[index] <= 16'd400 - (index * 16'd88);
            platform_wh_mem[index] <= ((`DJ_PLATFORM_DEFAULT_W & 16'h00ff) << 8) |
                                      (`DJ_PLATFORM_DEFAULT_H & 16'h00ff);
        end
    end else if (chip_select && write_enable) begin
        case (address)
            `DJ_PLAYER_X_ADDR: player_x <= write_data;
            `DJ_PLAYER_Y_ADDR: player_y <= write_data;
            `DJ_SCORE_STATUS_ADDR: score_status <= write_data;
            default: begin
                for (index = 0; index < `DJ_NUM_PLATFORMS; index = index + 1) begin
                    if (address == (`DJ_PLATFORM_BASE_ADDR + (index * `DJ_PLATFORM_WORDS) + 16'd0))
                        platform_x_mem[index] <= write_data;

                    if (address == (`DJ_PLATFORM_BASE_ADDR + (index * `DJ_PLATFORM_WORDS) + 16'd1))
                        platform_y_mem[index] <= write_data;

                    if (address == (`DJ_PLATFORM_BASE_ADDR + (index * `DJ_PLATFORM_WORDS) + 16'd2))
                        platform_wh_mem[index] <= write_data;
                end
            end
        endcase
    end
end

// Return the addressed player, score, or platform register value.
always @(address or player_x or player_y or score_status or
         platform_x_mem[0] or platform_x_mem[1] or platform_x_mem[2] or platform_x_mem[3] or
         platform_y_mem[0] or platform_y_mem[1] or platform_y_mem[2] or platform_y_mem[3] or
         platform_wh_mem[0] or platform_wh_mem[1] or platform_wh_mem[2] or platform_wh_mem[3]) begin
    read_data = 16'h0000;

    case (address)
        `DJ_PLAYER_X_ADDR: read_data = player_x;
        `DJ_PLAYER_Y_ADDR: read_data = player_y;
        `DJ_SCORE_STATUS_ADDR: read_data = score_status;
        default: begin
            for (index = 0; index < `DJ_NUM_PLATFORMS; index = index + 1) begin
                if (address == (`DJ_PLATFORM_BASE_ADDR + (index * `DJ_PLATFORM_WORDS) + 16'd0))
                    read_data = platform_x_mem[index];

                if (address == (`DJ_PLATFORM_BASE_ADDR + (index * `DJ_PLATFORM_WORDS) + 16'd1))
                    read_data = platform_y_mem[index];

                if (address == (`DJ_PLATFORM_BASE_ADDR + (index * `DJ_PLATFORM_WORDS) + 16'd2))
                    read_data = platform_wh_mem[index];
            end
        end
    endcase
end

endmodule
