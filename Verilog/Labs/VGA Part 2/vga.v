module vga 
#(parameter SYS_DATA_WIDTH=16, SYS_ADDR_WIDTH=16,
				GLYPH_DATA_WIDTH=24, GLYPH_ADDR_WIDTH=8)
(
	input wire                              clk, 
	input wire                              rst,
	input wire  [(SYS_DATA_WIDTH-1):0] sys_data,
	output wire                         vga_clk,
	output wire                     vga_blank_n, 
	output wire                          vga_vs,
	output wire                          vga_hs,
	output wire [7:0]                         r,
	output wire [7:0]                         g, 
	output wire [7:0]                         b,
	output wire [(SYS_ADDR_WIDTH-1):0] sys_addr
);

// size of registers log2(800) ~ 10
//							log2(525) ~ 10
localparam LOG2_DISPLAY_WIDTH  = 10;
localparam LOG2_DISPLAY_HEIGHT = 10;

/***************************************************************************/
/* 		NETS																					*/
/***************************************************************************/

wire [(LOG2_DISPLAY_WIDTH-1):0]  hcount;
wire [(LOG2_DISPLAY_HEIGHT-1):0] vcount;
wire [(GLYPH_ADDR_WIDTH-1):0] glyph_addr;
wire [(GLYPH_DATA_WIDTH-1):0] pixel;
wire [23:0] bg_color;
wire pix_en;
reg  pix_en_out;

/***************************************************************************/
/* 		VGA CONTROL																			*/
/***************************************************************************/

clk_divider clk_div
(
	.clk(clk), 
	.rst(rst),
	.div_clk(vga_clk)
);

vga_controller crtl (
	.vga_clk(vga_clk),
	.rst(rst),
	.vga_hs(vga_hs), 
	.vga_vs(vga_vs),
	.vga_blank_n(vga_blank_n),
	.hcount(hcount),
	.vcount(vcount)
	);

/***************************************************************************/
/* 		BITGEN																				*/
/***************************************************************************/

// generate dff to stall and propogate the pix_en 1 cycle to display proper pixels
always @(posedge clk)
	pix_en_out <= pix_en;
	
defparam bitgen.DATA_WIDTH = GLYPH_DATA_WIDTH;

bitgen bitgen (
	.vga_blank_n(vga_blank_n), 
	.pix_en(pix_en_out),	
	.pixel(pixel), 							
	.bg_color(bg_color), 						
	.rgb({r,g,b})							
);


/***************************************************************************/
/* 		GLYPH ADDRESS GENERATOR															*/
/***************************************************************************/

defparam addr_gen.SYS_DATA_WIDTH = SYS_DATA_WIDTH;
defparam addr_gen.SYS_ADDR_WIDTH = SYS_ADDR_WIDTH;
defparam addr_gen.GLYPH_DATA_WIDTH = GLYPH_DATA_WIDTH;
defparam addr_gen.GLYPH_ADDR_WIDTH = GLYPH_ADDR_WIDTH;
defparam addr_gen.LOG2_DISPLAY_WIDTH = LOG2_DISPLAY_WIDTH;
defparam addr_gen.LOG2_DISPLAY_HEIGHT = LOG2_DISPLAY_HEIGHT;

glyph_addr_gen addr_gen (
	.clk(clk), 
	.rst(rst), 
	.vga_blank_n(vga_blank_n),
	.vga_vs(vga_vs),
	.vga_hs(vga_hs),	
	.hcount(hcount), 												
	.vcount(vcount),											
	.sys_data(sys_data),											
	.glyph_addr(glyph_addr),							
	.sys_addr(sys_addr),											
	.bg_color(bg_color),									
	.pix_en(pix_en)											
);

/***************************************************************************/
/* 		GLYPH ROM																			*/
/***************************************************************************/

defparam glyphs.DATA_WIDTH = GLYPH_DATA_WIDTH;
defparam glyphs.ADDR_WIDTH = GLYPH_ADDR_WIDTH;

glyph_rom glyphs (
	.clk(clk),
	.addr(glyph_addr),
	.q(pixel)
);

endmodule
