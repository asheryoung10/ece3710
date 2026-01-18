module reg #( 
					parameter BIT_WIDTH = 16
				)(
					input wire [BIT_WIDTH - 1:0]writeData,
					input wire reset, writeEn, clk,
					input wire [3:0]addrDest, addrSrc,
					output reg [BIT_WIDTH - 1:0]Rdest, Rsrc
				 );
				 reg i = 0;
				 reg[BIT_WIDTH - 1:0] regs[BIT_WIDTH - 1:0];
				 
				 always @(posedge clk) begin
					if (reset) begin
						for (i = 0, i < 16, i = i + 1)
							regs[i] <= 16'd0; // Set every reg to 0
					end
					else if (writeEn) // Update reg with inputted data
						regs[addrDest] <= writeData;
					else begin
						regs <= regs; // Don't update any regs
					end
					
					// Set output to the value at input address.
					Rdest = regs[addrDest];
					// Set output to the value of input address.
					Rsrc = regs[addrSrc];
				 end
endmodule
				 