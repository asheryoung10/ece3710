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
           
				
            always@(*) begin
                // Note: In a casex statement you can have opcodes with Don't Cares such as ADDI and also be able
					 // to set Result or Flags to x as well (i.e. Flags[#] = 1'bx, Result = 16'bx).
					 
					 // ALWAYS SET ALL FLAGS AND RESULT OR YOU WILL GET LATCHING!!!!!!
                
                casex(Opcode)
						ADD, ADDI: begin
							Rdest <= $signed(Rdest) + $signed(Rsrc_Imm);
							if (Rdest == 16'b0000_0000_0000_0000)
								Flags = {0,0,0,0,0};
                       
                  end

                endcase
            end
endmodule
