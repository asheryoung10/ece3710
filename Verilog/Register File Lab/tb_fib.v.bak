`timescale 1ns/1ps

module tb_alu;

    // Parameters
    parameter BIT_WIDTH = 16;
    parameter OPCODE_WIDTH = 8;
    parameter FLAG_WIDTH = 5;

    // Inputs
    reg [BIT_WIDTH-1:0] Rsrc_Imm;
    reg [BIT_WIDTH-1:0] Rdest;
    reg [OPCODE_WIDTH-1:0] Opcode;

    // Outputs
    wire [BIT_WIDTH-1:0] Result;
    wire [FLAG_WIDTH-1:0] Flags;

    // Instantiate the ALU
    alu #(
        .BIT_WIDTH(BIT_WIDTH),
        .OPCODE_WIDTH(OPCODE_WIDTH),
        .FLAG_WIDTH(FLAG_WIDTH)
    ) uut (
        .Rsrc_Imm(Rsrc_Imm),
        .Rdest(Rdest),
        .Opcode(Opcode),
        .Result(Result),
        .Flags(Flags)
    );

    // Local constants for opcodes
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


    localparam cFlagIndex = 4;
    localparam lFlagIndex = 3;
    localparam fFlagIndex = 2;
    localparam zFlagIndex = 1;
    localparam nFlagIndex = 0;

    // Variables for checking
    reg [BIT_WIDTH-1:0] expected_result;
    reg [FLAG_WIDTH-1:0] expected_flags; // C, L, F, Z, N
    reg lastBit;
    reg [FLAG_WIDTH-1:0] oldFlags;
	 reg [3:0] sa;

	 
	 	 
	 task apply_test_expected;
        input [BIT_WIDTH-1:0] a;
        input [BIT_WIDTH-1:0] b;
        input [OPCODE_WIDTH-1:0] op;
		  input [BIT_WIDTH-1:0] expected_result_in;
		input [FLAG_WIDTH-1:0] expected_flags_in; // C, L, F, Z, N
		  
        begin
				#1; // wait for combinational output
            Rdest = a;
            Rsrc_Imm = b;
            Opcode = op;
            oldFlags = Flags;
				expected_flags = expected_flags_in;
				expected_result = expected_result_in;
            #1; // wait for combinational output

            // Check result
            if (Result !== expected_result || Flags !== expected_flags) begin
                $display("FAIL: Opcode=%b, Rdest=%d, Rsrc_Imm=%d => Result=%d (exp %d), Flags(CLFZN)=%b (exp %b)",
                         op, a, b, Result, expected_result, Flags, expected_flags);
					 $stop;
            end 
        end
    endtask
	 
    // Task to apply test vectors
    task apply_test;
        input [BIT_WIDTH-1:0] a;
        input [BIT_WIDTH-1:0] b;
        input [OPCODE_WIDTH-1:0] op;
        begin
            Rdest = a;
            Rsrc_Imm = b;
            Opcode = op;
            oldFlags = Flags;
            // Compute expected result and flags
            casex(op)
                ADD, ADDI: begin
                    expected_result = $signed(a) + $signed(b);
                    expected_flags[cFlagIndex] = 1'b0; // C = 0 for signed add
                    expected_flags[lFlagIndex] = 1'bx; // L set to x when signed
                    expected_flags[fFlagIndex] = ($signed(a[BIT_WIDTH-1]) == $signed(b[BIT_WIDTH-1]) &&
                                         expected_result[BIT_WIDTH-1] != a[BIT_WIDTH-1]);
                    expected_flags[zFlagIndex] = (expected_result == 0);
                    expected_flags[nFlagIndex] = $signed(a) < $signed(b);
                end
                ADDU, ADDUI: begin
                    {lastBit, expected_result} = a + b;
                    expected_flags[cFlagIndex] = lastBit;
                    expected_flags[lFlagIndex] = a < b;
                    expected_flags[fFlagIndex] = 1'b0;
                    expected_flags[zFlagIndex] = (expected_result == 0);
                    expected_flags[nFlagIndex] = 1'bx;
                end
                ADDC, ADDCI: begin
                    {lastBit, expected_result} = a + b + oldFlags[cFlagIndex];
                    expected_flags[cFlagIndex] = lastBit;
                    expected_flags[lFlagIndex] = 1'bx;
                    expected_flags[fFlagIndex] = ($signed(a[BIT_WIDTH-1]) == $signed(b[BIT_WIDTH-1]) &&
                                         expected_result[BIT_WIDTH-1] != a[BIT_WIDTH-1]);             
                    expected_flags[zFlagIndex] = 1'bx;
                    expected_flags[nFlagIndex] = 1'bx;

                end
                SUB, SUBI: begin
                    expected_result = $signed(a) - $signed(b);
                    expected_flags[cFlagIndex] = 0;
                    expected_flags[lFlagIndex] = 1'bx;
                    expected_flags[fFlagIndex] = ($signed(a[BIT_WIDTH-1]) == $signed(b[BIT_WIDTH-1]) &&
                                         expected_result[BIT_WIDTH-1] != a[BIT_WIDTH-1]);
                    expected_flags[zFlagIndex] = (expected_result == 0);
                    expected_flags[nFlagIndex] = $signed(a) < $signed(b);
                end
                CMP, CMPI: begin
                    expected_result = 0;
                    expected_flags[cFlagIndex] = 1'bx;
                    expected_flags[lFlagIndex] = a < b;
                    expected_flags[fFlagIndex] = 1'bx;
                    expected_flags[zFlagIndex] = $signed(a) == $signed(b);
                    expected_flags[nFlagIndex] = $signed(a) < $signed(b);
                end
                AND: begin
                    expected_result = a & b;
                    expected_flags[cFlagIndex] = 1'bx;
                    expected_flags[lFlagIndex] = 1'bx;
                    expected_flags[fFlagIndex] = 1'bx;
                    expected_flags[zFlagIndex] = (expected_result == 0);
                    expected_flags[nFlagIndex] = $signed(a) < $signed(b);
                end
                OR: begin
                    expected_result = a | b;
                    expected_flags[cFlagIndex] = 1'bx;
                    expected_flags[lFlagIndex] = 1'bx;
                    expected_flags[fFlagIndex] = 1'bx;
                    expected_flags[zFlagIndex] = (expected_result == 0);
                    expected_flags[nFlagIndex] = $signed(a) < $signed(b);
                end
                XOR: begin
                    expected_result = a ^ b;
                    expected_flags[cFlagIndex] = 1'bx;
                    expected_flags[lFlagIndex] = 1'bx;
                    expected_flags[fFlagIndex] = 1'bx;
                    expected_flags[zFlagIndex] = (expected_result == 0);
                    expected_flags[nFlagIndex] = $signed(a) < $signed(b);
                end
                NOT: begin
                    expected_result = ~b;
                    expected_flags[cFlagIndex] = 1'bx;
                    expected_flags[lFlagIndex] = 1'bx;
                    expected_flags[fFlagIndex] = 1'bx;
                    expected_flags[zFlagIndex] = (expected_result == 0);
                    expected_flags[nFlagIndex] = $signed(a) < $signed(b);
                end
                LSH, LSHI: begin
					 

						if ($signed(b) >= 0)
							 sa = b;
						else
							 sa = -b;

						// Clamp to data width (16 bits)
						if (sa > 15)
							 sa = 15;

						// Use 16-bit logical shift
						if ($signed(b) >= 0)
							 expected_result = a << sa;   // left shift
						else
							 expected_result = a >> sa;   // logical right shift
                    expected_flags[cFlagIndex] = 1'bx;
                    expected_flags[lFlagIndex] = 1'bx;
                    expected_flags[fFlagIndex] = 1'bx;
                    expected_flags[zFlagIndex] = (expected_result == 0);
                    expected_flags[nFlagIndex] = $signed(a) < $signed(b);
                end
                RSH, RSHI: begin
                    expected_result = (b >= 0) ? (a >> b) : (a << -b);
                    expected_flags[cFlagIndex] = 1'bx;
                    expected_flags[lFlagIndex] = 1'bx;
                    expected_flags[fFlagIndex] = 1'bx;
                    expected_flags[zFlagIndex] = (expected_result == 0);
                    expected_flags[nFlagIndex] = $signed(a) < $signed(b);
                end
                ARSH, ARSHI: begin
                    expected_result = ($signed(b) >= 0) ? ($signed(a) >>> $signed(b)) : ($signed(a) << -$signed(b));
                    expected_flags[cFlagIndex] = 1'bx;
                    expected_flags[lFlagIndex] = 1'bx;
                    expected_flags[fFlagIndex] = 1'bx;
                    expected_flags[zFlagIndex] = (expected_result == 0);
                    expected_flags[nFlagIndex] = $signed(a) < $signed(b);
                end
                NOP: begin
                    expected_flags = oldFlags;
                end
                default: begin
                    expected_result = 0;
                    expected_flags = 5'bxxxxx;
                end
            endcase

            apply_test_expected(a, b, op, expected_result, expected_flags);
        end
    endtask

	 
	 
	 
	 

    integer i, j;
	
    initial begin
				 	 $display("Starting ALU Test Bench.");

			$display("Testing ADD edge cases.");
			apply_test_expected(16'h0000, 16'h0000, ADD, 16'h0000, 5'b0x010);
			apply_test_expected(16'h8000, 16'h8000, ADD, 16'h0000, 5'b0x110);
			apply_test_expected(16'h8000, 16'h0000, ADD, 16'h8000, 5'b0x001);
			$display("Add edge cases successfull.");
		 
			$display("Testing ADDU edge cases.");
			apply_test_expected(16'h0000, 16'h0000, ADDU, 16'h0000, 5'b0001x);
			apply_test_expected(16'h8000, 16'h8000, ADDU, 16'h0000, 5'b1001x);
			apply_test_expected(16'h8000, 16'h0000, ADDU, 16'h8000, 5'b0000x);
			$display("Add edge cases successfull.");
		  
		   $display("Testing ADDC edge cases.");
			apply_test_expected(16'h0001, 16'h0001, ADDC, 16'h0002, 5'b0x0xx);
			apply_test_expected(16'hFFFF, 16'h0001, ADDC, 16'h0000, 5'b1x0xx);
			apply_test_expected(16'h7FFF, 16'h0001, ADDC, 16'h8001, 5'b0x1xx);
			$display("ADDC edge cases successful.");
			
			$display("Testing SUB edge cases.");
			apply_test_expected(16'h0000, 16'h0000, SUB, 16'h0000, 5'b0x010);
			apply_test_expected(16'h0000, 16'h0001, SUB, 16'hFFFF, 5'b0x101);
			apply_test_expected(16'h8000, 16'h7FFF, SUB, 16'h0001, 5'b0x001);
			$display("SUB edge cases successful.");

			$display("Testing CMP edge cases.");
			apply_test_expected(16'h0001, 16'h0001, CMP, 16'h0000, 5'bx0x10);
			apply_test_expected(16'h0000, 16'h0001, CMP, 16'h0000, 5'bx1x01);
			apply_test_expected(16'h8000, 16'h7FFF, CMP, 16'h0000, 5'bx0x01);
			$display("CMP edge cases successful.");
			
			$display("Testing AND edge cases.");
			apply_test_expected(16'hFFFF, 16'h0000, AND, 16'h0000, 5'bxxx11);
			apply_test_expected(16'hFFFF, 16'h8000, AND, 16'h8000, 5'bxxx00);
			$display("AND edge cases successful.");

			$display("Testing OR edge cases.");
			apply_test_expected(16'h0000, 16'h0000, OR, 16'h0000, 5'bxxx10);
			apply_test_expected(16'h8000, 16'h0001, OR, 16'h8001, 5'bxxx01);
			$display("OR edge cases successful.");
			
			$display("Testing LSH edge cases.");
			apply_test_expected(16'h0001, 16'h000F, LSH, 16'h8000, 5'bxxx01);
			apply_test_expected(16'h8000, 16'hFFF1, LSH, 16'h0001, 5'bxxx01);
			$display("LSH edge cases successful.");
			
			$display("Starting ALU testbench extreme values...");
		  
        // Exhaustive tests for different operations
        for (i = -5; i <= 5; i = i + 1) begin
            for (j = -5; j <= 5; j = j + 1) begin
                apply_test(i, j, ADD);
                apply_test(i, j, ADDI);
                apply_test(i, j, ADDU);
                apply_test(i, j, ADDUI);
                apply_test(i, j, ADDC);
                apply_test(i, j, ADDCI);
					 apply_test(i, j, SUB);
                apply_test(i, j, SUBI);
                apply_test(i, j, CMP);
                apply_test(i, j, CMPI);
                apply_test(i, j, AND);
                apply_test(i, j, OR);
					 apply_test(i, j, XOR);
                apply_test(i, j, NOT);
                apply_test(i, j, LSH);
                apply_test(i, j, LSHI);
                apply_test(i, j, RSH);
                apply_test(i, j, RSHI);
					 apply_test(i, j, ARSH);
                apply_test(i, j, ARSHI);
                apply_test(i, j, NOP);
            end
        end
		  $display("Passed middle range tests, begining edge case testing.");
		  







		  
	

        $display("ALU testbench completed.");
        $finish;
    end

endmodule