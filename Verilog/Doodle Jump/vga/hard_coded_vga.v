`timescale 1ns / 1ps
module vga
(
    input  wire       clk50,      // 50 MHz system clock
    input  wire       rstInv,     // active-low reset
    input  wire [9:0] playerX,    // Player X position in pixels
    input  wire [9:0] playerY,    // Player Y position in pixels
	 input  wire [9:0] playerTwoX,    // Player X position in pixels
    input  wire [9:0] playerTwoY,    // Player Y position in pixels
	 input wire [3:0]  playerAnimationIndex,
	  input wire [3:0]  playerTwoAnimationIndex,
	 input wire [15:0] playerOneBackgroundIndex,
    output wire       vga_clk,    // 25 MHz pixel clock
    output wire       vga_blank_n,
    output wire       vga_vs,
    output wire       vga_hs,
    output wire [7:0] r,
    output wire [7:0] g,
    output wire [7:0] b,
	 output wire [9:0] pixelX,
	 output wire [9:0] pixelY,
	 input [7:0] rectR,
	 input [7:0] rectG,
	 input [7:0] rectB
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
assign pixelX = display_area ? (hcount - (H_SYNC + H_BACK_PORCH)) : 10'd0;
assign pixelY = display_area ? (vcount - (V_SYNC + V_BACK_PORCH)) : 10'd0;

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
    .pixelY(pixelY - ({1'b0, playerOneBackgroundIndex[15:2]})),
    .glyphPixelR(glyphPixelR),
    .glyphPixelG(glyphPixelG),
    .glyphPixelB(glyphPixelB)
);

//-----------------------------------------------------------
// Player Pixel Memory (prefetch next pixel)
//-----------------------------------------------------------
wire [7:0] playerOnePixelR, playerOnePixelG, playerOnePixelB;

playerMemory playerMem_inst (
    .clk50(clk25),
	 .pixelX(pixelX),
	 .pixelY(pixelY),
    .playerX(playerX),
    .playerY(playerY),
	 .playerAnimationIndex(playerAnimationIndex),
    .playerPixelR(playerOnePixelR),
    .playerPixelG(playerOnePixelG),
    .playerPixelB(playerOnePixelB)
);
wire [7:0] playerTwoPixelR, playerTwoPixelG, playerTwoPixelB;

playerMemory playerMemTwo_inst (
    .clk50(clk25),
	 .pixelX(pixelX),
	 .pixelY(pixelY),
    .playerX(playerTwoX),
    .playerY(playerTwoY),
	 .playerAnimationIndex(playerTwoAnimationIndex),
    .playerPixelR(playerTwoPixelR),
    .playerPixelG(playerTwoPixelG),
    .playerPixelB(playerTwoPixelB)
);

// Check if players' pixels are active
reg [7:0] r_reg, g_reg, b_reg;
wire playerOne_active = (playerOnePixelR != 0) || (playerOnePixelG != 0) || (playerOnePixelB != 0);
wire playerTwo_active = (playerTwoPixelR != 0) || (playerTwoPixelG != 0) || (playerTwoPixelB != 0);
wire rect_active = (rectR != 0) || (rectG != 0) || (rectB != 0);
wire tile_active = (glyphPixelR != 0) || (glyphPixelG != 0) || (glyphPixelB != 0);

// Output RGB values based on active pixels
always @(posedge clk25) begin
    if (playerOne_active) begin
        // Player One is active, override RGB with playerOne's colors
        r_reg = playerOnePixelR;
        g_reg = playerOnePixelG;
        b_reg = playerOnePixelB;
    end else if (playerTwo_active) begin
        // Player Two is active, override RGB with playerTwo's colors
        r_reg = playerTwoPixelR;
        g_reg = playerTwoPixelG;
        b_reg = playerTwoPixelB;
    end else if (rect_active) begin
        // Rectangle is active, override RGB with rectangle's colors
        r_reg = rectR;
        g_reg = rectG;
        b_reg = rectB;
    end else if (tile_active) begin
        // Tile is active, override RGB with tile's colors
        r_reg = glyphPixelR;
        g_reg = glyphPixelG;
        b_reg = glyphPixelB;
    end else begin
        // No active pixels, set RGB to black (or whatever default color)
        r_reg = 0;
        g_reg = 0;
        b_reg = 0;
    end
end
assign r = r_reg;
assign g = g_reg;
assign b = b_reg;

endmodule