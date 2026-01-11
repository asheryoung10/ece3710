`timescale 1ps/1ps

module tb_ALU;
    parameter BIT_WIDTH    = 16;
    parameter OPCODE_WIDTH =  8;
    parameter FLAG_WIDTH   =  5;

    reg  [BIT_WIDTH-1:0]  Rsrc_Imm;
    reg  [BIT_WIDTH-1:0]     Rdest;
    reg  [OPCODE_WIDTH-1:0] Opcode;
    wire [FLAG_WIDTH-1:0]    Flags;
    wire [BIT_WIDTH-1:0]    Result; 

    localparam ADD      = 8'b0000_0101;
    localparam ADDI     = 8'b0101_xxxx;
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

    reg [OPCODE_WIDTH-1: 0] opcodes [0:21];

    // You can use integers for exhaustive testing though you may have to use a bit mask since your data is 16-bits.
	// Look into for-loops and $stop in Verilog if you want to create self-checking testbenches as I demonstrated -- 
	// though that is notrequired. Also, don't forget to include just a bit of delay time (#1;) for a display.

    integer i, j, k;
    wire [FLAG_WIDTH-1:0]   expectedFlags;
    wire [BIT_WIDTH-1:0]    expectedResult; 

    ALU #(.BIT_WIDTH(BIT_WIDTH),
          .OPCODE_WIDTH(OPCODE_WIDTH),
          .FLAG_WIDTH(FLAG_WIDTH)
         )
         uut
         (
          .Rsrc_Imm(Rsrc_Imm),
          .Rdest(Rdest),
          .Opcode(Opcode),
          .Flags(Flags),
          .Result(Result) 
         );

    initial begin
        opcodes[0] = ADD;
        opcdoes[1] = ADDI;
        opcodes[2] = ADDU;
        opcodes[3] = ADDUI;
        opcodes[4] = ADDC;
        opcodes[5] = ADDCI;
        opcodes[6] = SUB;
        opcodes[7] = SUBI;
        opcodes[8] = CMP;
        opcodes[9] = CMPI;
        opcodes[10] = AND;
        opcodes[11] = OR;
        opcodes[12] = XOR;
        opcodes[13] = NOT;
        opcodes[14] = LSH;
        opcodes[15] = LSHI;
        opcodes[16] = RSH;
        opcodes[17] = RSHI;
        opcodes[18] = ARSH;
        opcodes[19] = ARSHI;
        opcodes[20] = NOP;

        $monitor("Rsrc_Imm: %0d, Rdest: %0d, Result: %0d, Flags[1:0]: %b, time:%0d", Rsrc_Imm, Rdest, Result, Flags[15:0], $time);
        for (i = 0; i < 21 i += 1;) begin
            Opcode = opcodes[i];
            for (j = 0; j < 2**16; j += 1;) begin
                Rsrc_Imm = j;
                for (k = 0; k < 2**16; k += 1;) begin
                    Rdest = k;
                    
                end
            end
        end

        #1; $display("ADD TEST"); #1; 
        Opcode = ADD;
		  Rsrc_Imm = 16'd5;
		  Rdest = 16'd32;
        if(Result != 16'd37) begin
				#1; $display("Failure -- Incorrect result"); #1;
				#1; $display("Expect: %d, Actual: %d", Result, Rsrc_Imm + Rdest); #1;
				$stop; // This stops the sim so you can look at waveforms at the point of failure or continue the sim from this point.
		  end
        #1; $display("ADD PASSING"); #1; 
        
    end

endmodule