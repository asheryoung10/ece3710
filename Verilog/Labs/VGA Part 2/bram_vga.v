/** Supported Memory Block Configurations for Cyclone V Devices
  *
  * 397 M10K blocks available
  *
  * Each block can be configured as:
  *		Depth (bits)	| 	Programmable Width
  *			256			|		x40 or x32
  *			512			|		x20 or x16
  *			 1k			|		x10 or x8
  *			 2k			|		 x5 or x4
  *			 4k			|			 x2
  *			 8k			|			 x1
  *
  * Setting ADDR_WIDTH to 16, could move up to 512 if needed
  */
module bram
#(parameter DATA_WIDTH=16, parameter ADDR_WIDTH=16)
(
	input wire                       clk,
	input wire                      we_a, 
	input wire                      we_b,
	input wire [(DATA_WIDTH-1):0] data_a,
	input wire [(DATA_WIDTH-1):0] data_b,
	input wire [(ADDR_WIDTH-1):0] addr_a,
	input wire [(ADDR_WIDTH-1):0] addr_b,
	output reg [(DATA_WIDTH-1):0]    q_a,
	output reg [(DATA_WIDTH-1):0]    q_b
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];
	
	initial
	begin
		// Assuming data memory starts at 16'h1000
		ram[16'h1000] = 16'd100;	// mario x_pos
		ram[16'h1001] = 16'd350;	// mario y_pos
		ram[16'h1002] = 16'd20;		// mario movement position (21 positions)
	end

	// Port A 
	always @ (posedge clk)
	begin
		if (we_a) 
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
		end
		else 
		begin
			q_a <= ram[addr_a];
		end 
	end 

	// Port B 
	always @ (posedge clk)
	begin
		if (we_b) 
		begin
			ram[addr_b] <= data_b;
			q_b <= data_b;
		end
		else 
		begin
			q_b <= ram[addr_b];
		end 
	end

endmodule
