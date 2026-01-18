module ImmMux #(
					paramter BIT_WIDTH = 16;
				)(
					input wire [BIT_WIDTH - 1:0]RSrc, Imm
					input wire sel,
					output reg [BIT_WIDTH - 1:0]ImmOut
				);
				
				always @(*) begin
					case(sel)
						0: ImmOut = RSrc;
						1: ImmOut = Imm;
					endcase
				end
endmodule