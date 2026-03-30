`timescale 1ns/1ps

module video_compositor (
    input wire display_active,
    input wire [7:0] background_red,
    input wire [7:0] background_green,
    input wire [7:0] background_blue,
    input wire [7:0] platform_red,
    input wire [7:0] platform_green,
    input wire [7:0] platform_blue,
    input wire platform_active,
    input wire [7:0] player_red,
    input wire [7:0] player_green,
    input wire [7:0] player_blue,
    input wire player_active,
    output reg [7:0] red,
    output reg [7:0] green,
    output reg [7:0] blue
);

always @(*) begin
    if (!display_active) begin
        red = 8'd0;
        green = 8'd0;
        blue = 8'd0;
    end else if (player_active) begin
        red = player_red;
        green = player_green;
        blue = player_blue;
    end else if (platform_active) begin
        red = platform_red;
        green = platform_green;
        blue = platform_blue;
    end else begin
        red = background_red;
        green = background_green;
        blue = background_blue;
    end
end

endmodule
