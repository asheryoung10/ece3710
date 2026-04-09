module SNES_clkdiv(
input wire clk, rst, en,
output reg SNES_clk
);

reg [8:0]counter = 0;

always @(posedge clk) begin 
	if (rst) begin
		counter <= 0;
		SNES_clk <= 0;
		
	end else if (en) begin
		if (counter == 299) begin
			counter <= 0;
			SNES_clk <= ~SNES_clk;
		end else begin
			counter <= counter + 1;
		end
		
	end else if (~en) begin
		counter <= 0;
		SNES_clk <= 0;
	end
end
endmodule