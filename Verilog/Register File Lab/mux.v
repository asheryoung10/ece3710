module mux #(
					paramter BIT_WIDTH = 16,
					parameter SELECT_WIDTH = 4
				)(
					input wire [BIT_WIDTH - 1:0]r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 
					input wire [SELECT_WIDTH - 1:0]sel,
					output reg [BIT_WIDTH - 1:0]rout
				);
				
				always @(*) begin
					case(sel)
						0000: rout = r1;
						0001: rout = r2;
						0010: rout = r3;
						0011: rout = r4;
						0100: rout = r5;
						0101: rout = r6;
						0110: rout = r7;
						0111: rout = r8;
						1000: rout = r9;
						1001: rout = r10;
						1010: rout = r11;
						1011: rout = r12;
						1100: rout = r13;
						1101: rout = r14;
						1110: rout = r15;
						1111: rout = r16;
					endcase
				end
endmodule
				