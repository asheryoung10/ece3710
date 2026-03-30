`timescale 1ns/1ps

module video_timing (
    input wire clk_50mhz,
    input wire rst,
    output wire pixel_clk,
    output reg hsync,
    output reg vsync,
    output reg blank_n,
    output reg display_active,
    output reg [9:0] pixel_x,
    output reg [9:0] pixel_y
);

localparam H_SYNC = 10'd96;
localparam H_BACK_PORCH = 10'd48;
localparam H_DISPLAY = 10'd640;
localparam H_FRONT_PORCH = 10'd16;
localparam H_TOTAL = 10'd800;

localparam V_SYNC = 10'd2;
localparam V_BACK_PORCH = 10'd33;
localparam V_DISPLAY = 10'd480;
localparam V_FRONT_PORCH = 10'd10;
localparam V_TOTAL = 10'd525;

reg clk_div2;
reg [9:0] hcount;
reg [9:0] vcount;

assign pixel_clk = clk_div2;

always @(posedge clk_50mhz or posedge rst) begin
    if (rst)
        clk_div2 <= 1'b0;
    else
        clk_div2 <= ~clk_div2;
end

always @(posedge pixel_clk or posedge rst) begin
    if (rst) begin
        hcount <= 10'd0;
        vcount <= 10'd0;
    end else if (hcount == (H_TOTAL - 1)) begin
        hcount <= 10'd0;
        if (vcount == (V_TOTAL - 1))
            vcount <= 10'd0;
        else
            vcount <= vcount + 10'd1;
    end else begin
        hcount <= hcount + 10'd1;
    end
end

always @(*) begin
    hsync = ~(hcount < H_SYNC);
    vsync = ~(vcount < V_SYNC);
    display_active = (hcount >= (H_SYNC + H_BACK_PORCH)) &&
                     (hcount < (H_SYNC + H_BACK_PORCH + H_DISPLAY)) &&
                     (vcount >= (V_SYNC + V_BACK_PORCH)) &&
                     (vcount < (V_SYNC + V_BACK_PORCH + V_DISPLAY));
    blank_n = display_active;

    if (display_active) begin
        pixel_x = hcount - (H_SYNC + H_BACK_PORCH);
        pixel_y = vcount - (V_SYNC + V_BACK_PORCH);
    end else begin
        pixel_x = 10'd0;
        pixel_y = 10'd0;
    end
end

endmodule
