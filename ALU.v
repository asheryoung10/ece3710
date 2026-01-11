// ALU module that handles opcodes
module ALU #(parameter BIT_WIDTH    = 16,
             parameter OPCODE_WIDTH =  8,
             parameter FLAG_WIDTH   =  5
            )
            (
                input wire [BIT_WIDTH-1:0]  Rsrc_Imm,
                input wire [BIT_WIDTH-1:0]     Rdest,
                input wire [OPCODE_WIDTH-1:0] Opcode,
                output reg [FLAG_WIDTH-1:0]    Flags,
                output reg [BIT_WIDTH-1:0]    Result 
            );

			// Instruction opcodes
            localparam ADD    	= 8'b0000_0101;
            localparam ADDI   	= 8'b0101_xxxx;
			localparam ADDU   	= 8'b0000_0110;
			localparam ADDUI  	= 8'b0110_xxxx;
			localparam ADDC   	= 8'b0000_0111;
			localparam ADDCI  	= 8'b0111_xxxx;
			localparam SUB    	= 8'b0000_1001;
			localparam SUBI   	= 8'b1001_xxxx;
			localparam CMP 		= 8'b0000_1011;
			localparam CMPI		= 8'b1011_xxxx;
			localparam AND 		= 8'b0000_0001;
			localparam OR 		= 8'b0000_0010;
			localparam XOR		= 8'b0000_0011;
			localparam NOT		= 8'b0000_0100;
			localparam LSH		= 8'b1000_0100;
			localparam LSHI		= 8'b1000_000x;
			localparam RSH		= 8'b1000_100x;	
		 	localparam RSHI		= 8'b1000_101x;
			localparam ARSH 	= 8'b1000_0110;
			localparam ARSHI 	= 8'b1000_001x;
			localparam NOP		= 8'b0000_0000;
				
			// Individual bit registers to hold flags
			reg cFlag;
			reg lFlag;
			reg fFlag;
			reg nFlag;
			reg zFlag;
				
			// Wire for just holding shift amount for shift instructions.
			reg [BIT_WIDTH-1:0] shift_amt;

			// Behavioral block for all logic.
            always@(*) begin
                casex(Opcode)

						// Signed addition operation.
						ADD, ADDI: begin
							Result = $signed(Rdest) + $signed(Rsrc_Imm);
							
							zFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = (Rdest[15] == Rsrc_Imm[15]) && (Result[15] != Rdest[15]);
							lFlag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, lFlag, fFlag, zFlag, nFlag};
						end

						// Unsigned addition operation.
						ADDU, ADDUI: begin
							Result = Rdest + Rsrc_Imm;
							
							zFlag = Result == 0;
							{cFlag, Result} = Rdest + Rsrc_Imm;
							fFlag = 1'bx;
							lFlag = Rdest < Rscr_Imm;
							nFlag = 1'bx;
							
							Flags = {cFlag, lFlag, fFlag, zFlag, nFlag};
						end

						// Signed addition operation including carry.
						ADDC, ADDCI: begin
							Result = cFlag + $signed(Rdest) + $signed(Rsrc_Imm);
							
							zFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = (Rdest[15] == Rsrc_Imm[15]) && (Result[15] != Rdest[15]);
							lFlag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, lFlag, fFlag, zFlag, nFlag};
						end

						// Signed subtraction operation.
						SUB, SUBI: begin
							reg signed [BIT_WIDTH-1:0] negRsrc;
							negRsrc = -$signed(Rsrc_Imm);
							Result = $signed(Rdest) + negRsrc;

							zFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = (Rdest[15] == Rsrc_Imm[15]) && (Result[15] != Rdest[15]);
							lFlag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, lFlag, fFlag, zFlag, nFlag};
						end

						// Compare operation.
						CMP, CMPI: begin
							Result = 16b'xxxx_xxxx_xxxx_xxxx;
							zFlag = $signed(Rdest) == $signed(Rsrc_Imm);
							cFlag = 1'bx;
							fFlag = 1'bx;
							lFlag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, lFlag, fFlag, zFlag, nFlag};
						end

						// And operation.
						AND: begin
							Result = Rdest & Rsrc_Imm;
							zFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = 1'bx;
							lFlag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, lFlag, fFlag, zFlag, nFlag};
						end

						// Or operation.
						OR: begin
							Result = Rdest | Rsrc_Imm;
							ZFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = 1'bx;
							lFlag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, lFlag, fFlag, zFlag, nFlag};
						
						end

						// Xor operation.
						XOR: begin
							Result = Rdest ^ Rsrc_Imm;
							ZFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = 1'bx;
							lFlag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, lFlag, fFlag, zFlag, nFlag};
						end

						// Not operation.
						NOT: begin
							Result = ~Rsrc_Imm;
							ZFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = 1'bx;
							lFlag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, lFlag, fFlag, zFlag, nFlag};
						end

						// Left shift operation with signed shifting amount.
						LSH, LSHI: begin
							shift_amt = Rsrc_Imm;
							Result = (shift_amt >= 0) ? (Rdest << shift_amt) : (Rdest >> -shift_amt);
							
							ZFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = 1'bx;
							lFlag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, lFlag, fFlag, zFlag, nFlag};
						end
						RSH, RSHI: begin
							shift_amt = Rsrc_Imm;
							Result = (shift_amt >= 0) ? (Rdest >> shift_amt) : (Rdest << -shift_amt);
							
							ZFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = 1'bx;
							lFlag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, lFlag, fFlag, zFlag, nFlag};
						end
						ARSH, ARSHI: begin
							shift_amt = $signed(Rsrc_Imm);
							Result = (shift_amt >= 0) ? ($signed(Rdest) >> shift_amt) : ($signed(Rdest) << -shift_amt);
							
							ZFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = 1'bx;
							lFlag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, lFlag, fFlag, zFlag, nFlag};
						end
						NOP: begin
							Flags = {cFlag, lFlag, fFlag, zFlag, nFlag};
						end
                endcase
            end
endmodule