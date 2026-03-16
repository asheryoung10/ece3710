`timescale 1ns / 1ps
module vga
(
    input  wire       clk50,      // 50 MHz system clock
    input  wire       rstInv,     // active-low reset
    input  wire [9:0] playerX,    // Player X position in pixels
    input  wire [9:0] playerY,    // Player Y position in pixels
	 input wire [3:0]  playerAnimationIndex,
    output wire       vga_clk,    // 25 MHz pixel clock
    output wire       vga_blank_n,
    output wire       vga_vs,
    output wire       vga_hs,
    output wire [7:0] r,
    output wire [7:0] g,
    output wire [7:0] b
);

//-----------------------------------------------------------
// Clock Divider: 50 MHz -> 25 MHz
//-----------------------------------------------------------
reg clk25;
always @(posedge clk50 or negedge rstInv) begin
    if (~rstInv) begin
        clk25 <= 1'b0;
    end else begin
         clk25 <= ~clk25;
    end
end
assign vga_clk = clk25;

//-----------------------------------------------------------
// VGA Timing Parameters for 640x480 @ 60 Hz
//-----------------------------------------------------------
parameter H_SYNC        = 10'd96;
parameter H_BACK_PORCH  = 10'd48;
parameter H_DISPLAY     = 10'd640;
parameter H_FRONT_PORCH = 10'd16;
parameter H_TOTAL       = 10'd800;

parameter V_SYNC        = 10'd2;
parameter V_BACK_PORCH  = 10'd33;
parameter V_DISPLAY     = 10'd480;
parameter V_FRONT_PORCH = 10'd10;
parameter V_TOTAL       = 10'd525;

//-----------------------------------------------------------
// VGA Counters
//-----------------------------------------------------------
reg [9:0] hcount;
reg [9:0] vcount;

always @(posedge clk25 or negedge rstInv) begin
    if (~rstInv) begin
        hcount <= 10'd0;
        vcount <= 10'd0;
    end else begin
        if (hcount == H_TOTAL-1) begin
            hcount <= 10'd0;
            if (vcount == V_TOTAL-1)
                vcount <= 10'd0;
            else
                vcount <= vcount + 1;
        end else begin
            hcount <= hcount + 1;
        end
    end
end

//-----------------------------------------------------------
// VGA Sync Signals
//-----------------------------------------------------------
assign vga_hs = ~(hcount < H_SYNC);
assign vga_vs = ~(vcount < V_SYNC);

// Active display area
wire display_area = (hcount >= (H_SYNC + H_BACK_PORCH)) &&
                    (hcount <  (H_SYNC + H_BACK_PORCH + H_DISPLAY)) &&
                    (vcount >= (V_SYNC + V_BACK_PORCH)) &&
                    (vcount <  (V_SYNC + V_BACK_PORCH + V_DISPLAY));

assign vga_blank_n = display_area;

//-----------------------------------------------------------
// Pixel Coordinates in visible area
//-----------------------------------------------------------
wire [9:0] pixelX = display_area ? (hcount - (H_SYNC + H_BACK_PORCH)) : 10'd0;
wire [9:0] pixelY = display_area ? (vcount - (V_SYNC + V_BACK_PORCH)) : 10'd0;

// "Next pixel" coordinates for memory prefetch
//wire [9:0] nextX = (pixelX == H_DISPLAY-1) ? 10'd0 : (pixelX + 1);
//wire [9:0] nextY = (pixelX == H_DISPLAY-1) ? ((pixelY == V_DISPLAY-1) ? 10'd0 : pixelY + 1) : pixelY;

//-----------------------------------------------------------
// Tile Pixel Memory (prefetch next pixel)
//-----------------------------------------------------------
wire [7:0] glyphPixelR, glyphPixelG, glyphPixelB;

tileMemory tileMem_inst (
    .clk50(clk25),
    .pixelX(pixelX),
    .pixelY(pixelY),
    .glyphPixelR(glyphPixelR),
    .glyphPixelG(glyphPixelG),
    .glyphPixelB(glyphPixelB)
);

//-----------------------------------------------------------
// Player Pixel Memory (prefetch next pixel)
//-----------------------------------------------------------
wire [7:0] playerPixelR, playerPixelG, playerPixelB;

playerMemory playerMem_inst (
    .clk50(clk25),
	 .pixelX(pixelX),
	 .pixelY(pixelY),
    .playerX(playerX),
    .playerY(playerY),
	 .playerAnimationIndex(playerAnimationIndex),
    .playerPixelR(playerPixelR),
    .playerPixelG(playerPixelG),
    .playerPixelB(playerPixelB)
);

//-----------------------------------------------------------
// RGB Output Pipeline: overlay player on tiles
//-----------------------------------------------------------
reg [7:0] r_reg, g_reg, b_reg;
always @(posedge clk25 or negedge rstInv) begin
    if (~rstInv) begin
        r_reg <= 8'd0;
        g_reg <= 8'd0;
        b_reg <= 8'd0;
    end else begin
        if (display_area) begin
            // Player overlay: if player pixel is non-zero, use it; otherwise, use tile
            r_reg <= playerPixelR ? playerPixelR : glyphPixelR;
            g_reg <= playerPixelG ? playerPixelG : glyphPixelG;
            b_reg <= playerPixelB ? playerPixelB : glyphPixelB;
        end else begin
            r_reg <= 8'd0;
            g_reg <= 8'd0;
            b_reg <= 8'd0;
        end
    end
end

assign r = r_reg;
assign g = g_reg;
assign b = b_reg;

endmodule