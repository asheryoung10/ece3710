module program_counter(
	input clk,
	input reset,
	output [15:0] pc
);

initial begin
	pc = 1'd0;
end

always @(posedge clk or posedge reset) begin
	if (reset) begin
		pc <= 1'd0;
		end
	
	pc <= pc + 1'b1;
	end


endmodule