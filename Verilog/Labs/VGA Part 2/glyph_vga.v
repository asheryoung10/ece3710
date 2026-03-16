module glyph_vga
(
	input  wire         clk,
	input  wire         rst,
	output wire     vga_clk, 
	output wire vga_blank_n,
	output wire      vga_vs,
	output wire      vga_hs,
	output wire [7:0]     r,
	output wire [7:0]     g,
	output wire [7:0]     b
);

localparam SYS_DATA_WIDTH=16, SYS_ADDR_WIDTH=16;
localparam GLYPH_DATA_WIDTH=24, GLYPH_ADDR_WIDTH=14;

wire [(SYS_DATA_WIDTH-1):0] data_a, data_b;
wire [(SYS_ADDR_WIDTH-1):0] addr_a, addr_b, q_a, q_b;
wire we_a, we_b;

defparam vga.SYS_DATA_WIDTH = SYS_DATA_WIDTH;
defparam vga.SYS_ADDR_WIDTH = SYS_ADDR_WIDTH;
defparam vga.GLYPH_DATA_WIDTH = GLYPH_DATA_WIDTH;
defparam vga.GLYPH_ADDR_WIDTH = GLYPH_ADDR_WIDTH;



vga vga (
	.clk(clk),
	.rst(rst),									
	.sys_data(q_b),			
	.vga_clk(vga_clk),	
	.vga_blank_n(vga_blank_n), 
	.vga_vs(vga_vs), 
	.vga_hs(vga_hs),	
	.r(r), 
	.g(g), 
	.b(b),											
	.sys_addr(addr_b)											
);


defparam ram.DATA_WIDTH = SYS_DATA_WIDTH;
defparam ram.ADDR_WIDTH = SYS_ADDR_WIDTH;

bram ram (
	.clk(clk),
	.we_a(we_a), 
	.we_b(we_b),
	.data_a(data_a),
	.data_b(data_b),
	.addr_a(addr_a),
	.addr_b(addr_b),
	.q_a(q_a),
	.q_b(q_b)
);


defparam move.DATA_WIDTH = SYS_DATA_WIDTH;
defparam move.ADDR_WIDTH = SYS_ADDR_WIDTH;

movement move (
	.clk(clk), 
	.rst(rst),		
	.data_in(q_a),					
	.addr(addr_a),				
	.data_out(data_a),				
	.we(we_a)					
);

endmodule
