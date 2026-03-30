`timescale 1ns/1ps
`include "game_map_defs.vh"

module player_renderer (
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,
    input wire [15:0] player_x,
    input wire [15:0] player_y,
    input wire [3:0] style_index,
    output reg [7:0] red,
    output reg [7:0] green,
    output reg [7:0] blue,
    output reg active
);

reg inside_body;
reg inside_eye;

always @(*) begin
    inside_body = (pixel_x >= player_x[9:0]) &&
                  (pixel_x < (player_x[9:0] + `DJ_PLAYER_WIDTH)) &&
                  (pixel_y >= player_y[9:0]) &&
                  (pixel_y < (player_y[9:0] + `DJ_PLAYER_HEIGHT));

    inside_eye = inside_body &&
                 (pixel_y < (player_y[9:0] + 10'd18)) &&
                 ((pixel_x < (player_x[9:0] + 10'd20)) ||
                  (pixel_x > (player_x[9:0] + 10'd43)));

    active = inside_body;

    if (inside_eye) begin
        red = 8'h00;
        green = 8'h00;
        blue = 8'h00;
    end else if (inside_body) begin
        red = 8'd40 + {4'd0, style_index, 1'b0};
        green = 8'hf0;
        blue = 8'd32 + {4'd0, style_index, 1'b0};
    end else begin
        red = 8'd0;
        green = 8'd0;
        blue = 8'd0;
    end
end

endmodule
