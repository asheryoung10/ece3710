module SNES_latchGen(
	input wire clk,
	input wire rst,
	output reg snes_clk
);

reg[19:0] counter;
	//this block triggers  a 16 micro second long pluse every 16.67ms (mimicking SNES cpu clk)
always @(posedge clk) begin
		if (rst) begin
			snes_clk <= 1'b0; 
			counter <= 20'd0;
		end
		else begin
			if (counter == 833499) //number of cycles for 16.67ms
				counter <= 0;
			else
				counter <= counter + 1;
				
			if (counter < 600)
				snes_clk <= 1;
			else 
				snes_clk <= 0;
		end
	end
endmodule