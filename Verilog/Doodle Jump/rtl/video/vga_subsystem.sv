`timescale 1ns/1ps
`include "game_map_defs.vh"

module vga_subsystem (
    input wire clk_50mhz,
    input wire rst,
    input wire [15:0] player_x,
    input wire [15:0] player_y,
    input wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_x_bus,
    input wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_y_bus,
    input wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_wh_bus,
    input wire [3:0] player_style_index,
    output wire vga_clock,
    output wire vga_blank_n,
    output wire vga_hs,
    output wire vga_vs,
    output wire [7:0] vga_red,
    output wire [7:0] vga_green,
    output wire [7:0] vga_blue
);

wire display_active;
wire [9:0] pixel_x;
wire [9:0] pixel_y;

wire [7:0] background_red;
wire [7:0] background_green;
wire [7:0] background_blue;

wire [7:0] platform_red;
wire [7:0] platform_green;
wire [7:0] platform_blue;
wire platform_active;

wire [7:0] player_red;
wire [7:0] player_green;
wire [7:0] player_blue;
wire player_active;

video_timing video_timing_instance (
    .clk_50mhz(clk_50mhz),
    .rst(rst),
    .pixel_clk(vga_clock),
    .hsync(vga_hs),
    .vsync(vga_vs),
    .blank_n(vga_blank_n),
    .display_active(display_active),
    .pixel_x(pixel_x),
    .pixel_y(pixel_y)
);

background_renderer background_renderer_instance (
    .pixel_x(pixel_x),
    .pixel_y(pixel_y),
    .red(background_red),
    .green(background_green),
    .blue(background_blue)
);

platform_renderer platform_renderer_instance (
    .pixel_x(pixel_x),
    .pixel_y(pixel_y),
    .platform_x_bus(platform_x_bus),
    .platform_y_bus(platform_y_bus),
    .platform_wh_bus(platform_wh_bus),
    .red(platform_red),
    .green(platform_green),
    .blue(platform_blue),
    .active(platform_active)
);

player_renderer player_renderer_instance (
    .pixel_x(pixel_x),
    .pixel_y(pixel_y),
    .player_x(player_x),
    .player_y(player_y),
    .style_index(player_style_index),
    .red(player_red),
    .green(player_green),
    .blue(player_blue),
    .active(player_active)
);

video_compositor video_compositor_instance (
    .display_active(display_active),
    .background_red(background_red),
    .background_green(background_green),
    .background_blue(background_blue),
    .platform_red(platform_red),
    .platform_green(platform_green),
    .platform_blue(platform_blue),
    .platform_active(platform_active),
    .player_red(player_red),
    .player_green(player_green),
    .player_blue(player_blue),
    .player_active(player_active),
    .red(vga_red),
    .green(vga_green),
    .blue(vga_blue)
);

endmodule
