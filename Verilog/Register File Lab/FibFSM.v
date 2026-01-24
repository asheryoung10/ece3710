module FibFSM #( 
						parameter BIT_WIDTH = 16,
						parameter SEL_WIDTH = 4,
						parameter OPCODE_WIDTH = 8
					)(
						input wire clk, reset,
						output reg [SEL_WIDTH - 1:0]SrcAddr, DestAddr, WriteAddr //Addr for writing and reading for regfile
						output reg regReset, regWriteEn, ImmMuxSel, //Immediate Mux selector and reset/write enable
						output reg [BITWIDTH - 1:0]ImmData //Immediate Data for ImmMux
						output reg [OPCODE_WIDTH - 1:0]op //opcode for ALU
					);
					
					reg [2:0]nextState = 0;
					reg [3:0]regIndex = 2;
					always @(posedge clk) begin
						case(nextState)
							000: // Init all regs to 0
								regReset = 1;
								regWriteEn = 0;
								ImmMuxSel = 0;
								SrcAddr = {SEL_WIDTH}'d0;
								DestAddr = {SEL_WIDTH}'d0;
								WriteAddr = {SEL_WIDTH}'d0;
								ImmData = {BITWIDTH}'d0;
								op = {OPCODE_WIDTH}'d0;
								nextState = 001;
							001: // Init r1=1
								regReset = 0;
								regWriteEn = 1;
								ImmMuxSel = 1;
								SrcAddr = {SEL_WIDTH}'d0;
								DestAddr = {SEL_WIDTH}'d0;
								WriteAddr = {SEL_WIDTH}'d1;
								ImmData = {BITWIDTH}'d1;
								op = 8'b0000_0101; //ADD
								nextState = 010;
							010: /// Rindex = Rindex-1 + Rindex-2
								regReset = 0;
								regWriteEn = 1;
								ImmMuxSel = 0;
								SrcAddr = regIndex-2;
								DestAddr = regIndex-1;
								WriteAddr = regIndex;
								ImmData = {BITWIDTH}'d1;
								op = 8'b0000_0101; //ADD
								
								regIndex = regIndex + 1;
								if(regIndex == 4'b1111)
									nextState = 011;
								else
									nextState = 010;
							011:
								nextState = nextState;
							default:
								nextState = 000;
						endcase
					end
								
								
								