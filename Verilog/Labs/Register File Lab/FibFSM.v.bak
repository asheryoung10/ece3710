module FibFSM #( 
						parameter BIT_WIDTH = 16,
						parameter SEL_WIDTH = 4,
						parameter OPCODE_WIDTH = 8
					)(
						input wire clk, reset,
						output reg [SEL_WIDTH - 1:0]SrcMux, SrcReg, DestMux, DestReg,  //Selectors and Addr for Src and Dest Mux/Reg
						output reg regReset, regWriteEn, ImmMuxSel, //Immediate Mux selector and reset/write enable
						output reg [BITWIDTH - 1:0]regData, Imm //Reg write data and Immediate for ImmMux
						output reg [OPCODE_WIDTH - 1:0]op //opcode for ALU
					);
					
					reg [2:0]state = 0;
					always @(posedge clk, negedge reset) begin
						if (reset)
							state = 3'b000;
						else if (state == 25) //State number we want to hold at (last state of fib sequence) 
							state = state;
						else
							state = state + 3'b001;
					end
					
					always @(*) begin
						case(state)
							000: 
								regReset = 1;
								regWriteEn = 0;
								SrcMux = 0;
								DestMux = 0;
								ImmMuxSel = 0;
								DestReg = 0;
								SrcReg = 0;
								regData = 16'd0;
								Imm = 16'd0
								op = 8'd0;
							001:
								regReset = 0;
								regWriteEn = 1;
								SrcMux = 4'b000;
								DestMux = 4'b0000;
								ImmMuxSel= 1'b1;
								DestReg = 4'b0000;
								SrcReg = 4'b0000;
								regData = ?;
								Imm = 16'd1;
								op = 8'b0101_xxxx;
								
								
								