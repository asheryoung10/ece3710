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

            localparam ADD    = 8'b0000_0101;
            localparam ADDI   = 8'0101_xxxx;
				localparam ADDU   = 8'b0000_0110;
				localparam ADDUI  = 8'b0110_xxxx;
				localparam ADDC   = 8'b0000_0111;
				localparam ADDCI  = 8'b0111_xxxx;
				localparam SUB    = 8'b0000_1001;
				localparam SUBI   = 8'b1001_xxxx;
				localparam CMP 	= 8'b0000_1011;
				localparam CMPI	= 8'b1011_xxxx;
				localparam AND 	= 8'b0000_0001;
				localparam OR 		= 8'b0000_0010;
				localparam XOR		= 8'b0000_0011;
				localparam NOT		= 8'b0000_0100;
				localparam LSH		= 8'b1000_0100;
				localparam LSHI	= 8'b1000_000x;
				localparam RSH		= 8'b1000_100x;	
				localparam RSHI	= 8'b1000_101x;
				localparam ARSH 	= 8'b1000_0110;
				localparam ARSHI 	= 8'b1000_001x;
				localparam NOP		= 8'b0000_0000;
				
				reg cFlag;
				reg LFlag;
				reg fFlag;
				reg nFlag;
				reg zFlag;
				
				wire [BIT_WIDTH-1:0] shift_amt;
            always@(*) begin
                // Note: In a casex statement you can have opcodes with Don't Cares such as ADDI and also be able
					 // to set Result or Flags to x as well (i.e. Flags[#] = 1'bx, Result = 16'bx).
					 
					 // ALWAYS SET ALL FLAGS AND RESULT OR YOU WILL GET LATCHING!!!!!!
                
                casex(Opcode)
						ADD, ADDI: begin
							Result = $signed(Rdest) + $signed(Rsrc_Imm);
							
							zFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = (Rdest[15] == Rsrc_Imm[15]) && (Result[15] != Rdest[15]);
							Lflag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, LFlag, fFlag, zFlag, nFlag};
                  end
						ADDU, ADDUI: begin
							Result = Rdest + Rsrc_Imm;
							
							zFlag = Result == 0;
							cFlag = Result > 2**15;
							fFlag = 1'bx;
							Lflag = Rdest < Rscr_Imm;
							nFlag = 1'bx;
							
							Flags = {cFlag, LFlag, fFlag, zFlag, nFlag};
						end
						ADDC, ADDCI: begin
							Result = cFlag + $signed(Rdest) + $signed(Rsrc_Imm);
							
							zFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = (Rdest[15] == Rsrc_Imm[15]) && (Result[15] != Rdest[15]);
							Lflag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, LFlag, fFlag, zFlag, nFlag};
						end
						SUB, SUBI: begin
							wire Rsrc2s = ~(Rsrc_Imm) + 1'b1;
							Result = $signed(Rdest) + $signed(Rsrc2s);
							
							zFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = (Rdest[15] == Rsrc_Imm[15]) && (Result[15] != Rdest[15]);
							Lflag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, LFlag, fFlag, zFlag, nFlag};
						end
						CMP, CMPI: begin
							Result = 16b'xxxx_xxxx_xxxx_xxxx;
							zFlag = $signed(Rdest) == $signed(Rsrc_Imm);
							cFlag = 1'bx;
							fFlag = 1'bx;
							Lflag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, LFlag, fFlag, zFlag, nFlag};
						end
						AND: begin
							Result = Rdest & Rsrc_Imm;
							zFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = 1'bx;
							Lflag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, LFlag, fFlag, zFlag, nFlag};
						end
						OR: begin
							Result = Rdest | Rsrc_Imm;
							ZFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = 1'bx;
							Lflag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, LFlag, fFlag, zFlag, nFlag};
						
						end
						XOR: begin
							Result = Rdest ^ Rsrc_Imm;
							ZFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = 1'bx;
							Lflag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, LFlag, fFlag, zFlag, nFlag};
						end
						NOT: begin
							Result = ~Rsrc_Imm;
							ZFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = 1'bx;
							Lflag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, LFlag, fFlag, zFlag, nFlag};
						end
						LSH, LSHI: begin
							shift_amt = $signed(Rsrc_Imm);
							Result = (shift_amt >= 0) ? ($signed(Rdest) << shift_amt) : ($signed(Rdest) >> -shift_amt);
							
							ZFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = 1'bx;
							Lflag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, LFlag, fFlag, zFlag, nFlag};
						end
						RSH, RSHI: begin
							shift_amt = $signed(Rsrc_Imm);
							Result = (shift_amt >= 0) ? ($signed(Rdest) >> shift_amt) : ($signed(Rdest) << -shift_amt);
							
							ZFlag = Result == 0;
							cFlag = 1'bx;
							fFlag = 1'bx;
							Lflag = 1'bx;
							nFlag = $signed(Rdest) < $signed(Rsrc_Imm);
							
							Flags = {cFlag, LFlag, fFlag, zFlag, nFlag};
						end
						ARSH, ARSHI: begin
							
						
						end
						NOP: begin
						
						
						end
                endcase
            end
endmodule
