`timescale 1ns / 1ps
module vga
(
    input  wire       clk50,
    input  wire       reset,
	 
	 
	   input [15:0] p1X,
		input [15:0] p1Y,
		input [15:0] p1AnimationIndex,
		input [15:0] p1HighlightColor,
		
		input [15:0] p2X,
		input [15:0] p2Y,
		input [15:0] p2AnimationIndex,
		input [15:0] p2HighlightColor,
		
	   input [15:0] p3X,
		input [15:0] p3Y,
		input [15:0] p3AnimationIndex,
		input [15:0] p3HighlightColor,
		
		input [15:0] p4X,
		input [15:0] p4Y,
		input [15:0] p4AnimationIndex,
		input [15:0] p4HighlightColor,

        
		input [15:0] p1Scale,
		input [15:0] p2Scale,
		input [15:0] p3Scale,
		input [15:0] p4Scale,

		input [15:0] p1Score,
		input [15:0] p2Score,
		input [15:0] p3Score,
		input [15:0] p4Score,


	
	input [15:0] backgroundOffsetX,
	input [15:0] backgroundOffsetY,
	 
	 input [7:0] rectR,
	 input [7:0] rectG,
	 input [7:0] rectB,
	 
	 output wire [9:0] pixelX,
	 output wire [9:0] pixelY,
	 
    output wire       vga_clk,
    output wire       vga_blank_n,
    output wire       vga_vs,
    output wire       vga_hs,
    output wire [7:0] r,
    output wire [7:0] g,
    output wire [7:0] b,
	 input wire shrinkHalf
);

reg clk25;
always @(posedge clk50 or posedge reset) begin
    if (reset) begin
        clk25 <= 1'b0;
    end else begin
         clk25 <= ~clk25;
    end
end
assign vga_clk = clk25;


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


reg [9:0] hcount;
reg [9:0] vcount;

always @(posedge clk25 or posedge reset) begin
    if (reset) begin
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


assign vga_hs = ~(hcount < H_SYNC);
assign vga_vs = ~(vcount < V_SYNC);

wire display_area = (hcount >= (H_SYNC + H_BACK_PORCH)) &&
                    (hcount <  (H_SYNC + H_BACK_PORCH + H_DISPLAY)) &&
                    (vcount >= (V_SYNC + V_BACK_PORCH)) &&
                    (vcount <  (V_SYNC + V_BACK_PORCH + V_DISPLAY));

assign vga_blank_n = display_area;

assign pixelX = display_area ? (hcount - (H_SYNC + H_BACK_PORCH)) : 10'd0;
assign pixelY = display_area ? (vcount - (V_SYNC + V_BACK_PORCH)) : 10'd0;

wire [7:0] backGroundR, backGroundG, backGroundB;
tileMemory tileMem_inst (
    .clk50(clk25),
    .pixelX(pixelX - ({1'b0, backgroundOffsetX[15:2]})),
    .pixelY(pixelY - ({1'b0, backgroundOffsetY[15:2]})),
    .glyphPixelR(backGroundR),
    .glyphPixelG(backGroundG),
    .glyphPixelB(backGroundB)
);
wire [7:0] scorePixelR, scorePixelG, scorePixelB;
number3Display num3Instance(
    .clk50(clk25),
    .number(p1Score),
    .baseX(0),
    .baseY(0),
    .highlightColor(16'haaaa),
    .pixelX(pixelX),
    .pixelY(pixelY),
    .scale(4),
    .pixelR(scorePixelR),
    .pixelG(scorePixelG),
    .pixelB(scorePixelB)
);

wire [7:0] p1PixelR, p1PixelG, p1PixelB;
wire [7:0] p2PixelR, p2PixelG, p2PixelB;
wire [7:0] p3PixelR, p3PixelG, p3PixelB;
wire [7:0] p4PixelR, p4PixelG, p4PixelB;
playerMemory p1Memory_inst (
    .clk50(clk25),
	 .pixelX(pixelX),
	 .pixelY(pixelY),
    .playerX(p1X),
    .playerY(p1Y),
	 .playerAnimationIndex(p1AnimationIndex),
    .playerPixelR(p1PixelR),
    .playerPixelG(p1PixelG),
    .playerPixelB(p1PixelB),
	 .highlightColor(p1HighlightColor),

         .scale(p1Scale)

);
playerMemory p2Memory_inst (
    .clk50(clk25),
	 .pixelX(pixelX),
	 .pixelY(pixelY),
    .playerX(p2X),
    .playerY(p2Y),
	 .playerAnimationIndex(p2AnimationIndex),
    .playerPixelR(p2PixelR),
    .playerPixelG(p2PixelG),
    .playerPixelB(p2PixelB),
	 .highlightColor(p2HighlightColor),

         .scale(p2Scale)

);
playerMemory p3Memory_inst (
    .clk50(clk25),
	 .pixelX(pixelX),
	 .pixelY(pixelY),
    .playerX(p3X),
    .playerY(p3Y),
	 .playerAnimationIndex(p3AnimationIndex),
    .playerPixelR(p3PixelR),
    .playerPixelG(p3PixelG),
    .playerPixelB(p3PixelB),
	 .highlightColor(p3HighlightColor),
         .scale(p3Scale)

);
playerMemory p4Memory_inst (
    .clk50(clk25),
	 .pixelX(pixelX),
	 .pixelY(pixelY),
    .playerX(p4X),
    .playerY(p4Y),
	 .playerAnimationIndex(p4AnimationIndex),
    .playerPixelR(p4PixelR),
    .playerPixelG(p4PixelG),
    .playerPixelB(p4PixelB),
	 .highlightColor(p4HighlightColor),
     .scale(p4Scale)
);




reg [7:0] r_reg, g_reg, b_reg;
wire score_active = (scorePixelR != 0) || (scorePixelG != 0) || (scorePixelB != 0);

wire playerOne_active = (p1PixelR != 0) || (p1PixelG != 0) || (p1PixelB != 0);
wire playerTwo_active = (p2PixelR != 0) || (p2PixelG != 0) || (p2PixelB != 0);
wire playerThree_active = (p3PixelR != 0) || (p3PixelG != 0) || (p3PixelB != 0);
wire playerFour_active = (p4PixelR != 0) || (p4PixelG != 0) || (p4PixelB != 0);
wire rect_active = (rectR != 0) || (rectG != 0) || (rectB != 0);
wire background_active = (backGroundR != 0) || (backGroundG != 0) || (backGroundB != 0);

always @(posedge clk25) begin
if (score_active) begin
        r_reg = scorePixelR;
        g_reg = scorePixelG;
        b_reg = scorePixelB;
    end else
    if (playerOne_active) begin
        r_reg = p1PixelR;
        g_reg = p1PixelG;
        b_reg = p1PixelB;
    end else if (playerTwo_active) begin
        r_reg = p2PixelR;
        g_reg = p2PixelG;
        b_reg = p2PixelB;
	 end else if (playerThree_active) begin
        r_reg = p3PixelR;
        g_reg = p3PixelG;
        b_reg = p3PixelB;
    end else if (playerFour_active) begin
        r_reg = p4PixelR;
        g_reg = p4PixelG;
        b_reg = p4PixelB;
    end else if (rect_active) begin
        r_reg = rectR;
        g_reg = rectG;
        b_reg = rectB;
    end else if (background_active) begin
        r_reg = backGroundR;
        g_reg = backGroundG;
        b_reg = backGroundB;
    end else begin
        r_reg = 0;
        g_reg = 0;
        b_reg = 0;
    end
end
assign r = r_reg;
assign g = g_reg;
assign b = b_reg;

endmodule