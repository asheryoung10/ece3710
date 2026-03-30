`timescale 1ns/1ps
`include "game_map_defs.vh"

module platform_renderer (
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,
    input wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_x_bus,
    input wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_y_bus,
    input wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_wh_bus,
    output reg [7:0] red,
    output reg [7:0] green,
    output reg [7:0] blue,
    output reg active
);

integer index;
reg [15:0] platform_x_word;
reg [15:0] platform_y_word;
reg [15:0] platform_wh_word;
reg [7:0] width;
reg [7:0] height;

always @(*) begin
    active = 1'b0;
    red = 8'd0;
    green = 8'd0;
    blue = 8'd0;

    for (index = 0; index < `DJ_NUM_PLATFORMS; index = index + 1) begin
        platform_x_word = platform_x_bus[(index*16) +: 16];
        platform_y_word = platform_y_bus[(index*16) +: 16];
        platform_wh_word = platform_wh_bus[(index*16) +: 16];
        width = platform_wh_word[15:8];
        height = platform_wh_word[7:0];

        if ((pixel_x >= platform_x_word[9:0]) &&
            (pixel_x < (platform_x_word[9:0] + width)) &&
            (pixel_y >= platform_y_word[9:0]) &&
            (pixel_y < (platform_y_word[9:0] + height))) begin
            active = 1'b1;
            red = 8'hff;
            green = 8'hff;
            blue = 8'hff;
        end
    end
end

endmodule
