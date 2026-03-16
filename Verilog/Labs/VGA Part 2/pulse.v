module pulse
(
	input wire            clk, 
	input wire            rst,
	input wire [31:0] length1,
	input wire [31:0] length2,
	output reg          pulse
);

reg [31:0] counter;

always @(posedge clk, negedge rst) begin
	if (~rst) begin
		counter <= 32'd0;
		pulse <= 1'b0;
	end
	else begin
		if (pulse) begin
			if (counter == length1) begin
				counter <= 32'd0;
				pulse <= 0;
			end
			else begin
				counter <= counter + 1'b1;
				pulse   <= pulse;
			end
		end
		else begin
			if (counter == length2) begin
				counter <= 32'd0;
				pulse   <= 1'b1;
			end
			else begin
				counter <= counter + 1'b1;
				pulse   <= pulse;
			end
		end
	end

end

endmodule
