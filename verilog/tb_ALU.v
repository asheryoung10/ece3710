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
            #1; // wait for combinational output

            // Compute expected result and flags
            casex(op)
                ADD, ADDI: begin
                    {lastBit, expected_result} = $signed(a) + $signed(b);
                    expected_flags[cFlagIndex] = lastBit; // C for signed add
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
                    expected_flags[fFlagIndex] = 1'bx;
                    expected_flags[zFlagIndex] = (expected_result == 0);
                    expected_flags[nFlagIndex] = 1'bx;
                end
                ADDC, ADDCI: begin
                    {lastBit, expected_result} = a + b + oldFlags[cFlagIndex];
                    expected_flags[cFlagIndex] = lastBit;
                    expected_flags[lFlagIndex] = 1'bx;
                    expected_flags[fFlagIndex] = ($signed(a[BIT_WIDTH-1]) == $signed(b[BIT_WIDTH-1]) &&
                                         expected_result[BIT_WIDTH-1] != a[BIT_WIDTH-1]);
                    
                    expected_flags[zFlagIndex] = (expected_result == 0);
                    expected_flags[nFlagIndex] = $signed(a) < $signed(b);

                end
                SUB, SUBI: begin
                    {lastBit, expected_result} = $signed(a) - $signed(b);
                    expected_flags[cFlagIndex] = lastBit;
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
                    expected_result = (b >= 0) ? (a << b) : (a >> -b);
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
                    expected_result = ($signed(b) >= 0) ? ($signed(a) >> $signed(b)) : ($signed(a) << -$signed(b));
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

            // Check result
            if (Result !== expected_result || Flags !== expected_flags) begin
                $display("FAIL: Opcode=%b, Rdest=%d, Rsrc_Imm=%d => Result=%d (exp %d), Flags(CLFZN)=%b (exp %b)",
                         op, a, b, Result, expected_result, Flags, expected_flags);
            end 
            //else begin
            //    $display("PASS: Opcode=%b, Rdest=%d, Rsrc_Imm=%d => Result=%d, Flags=%b",
            //             op, a, b, Result, Flags);
            //end
        end
    endtask

    integer i, j;

    initial begin
        $display("Starting ALU testbench...");

        // Exhaustive tests for ADD and ADDI with small numbers for demo
        for (i = -5; i <= 5; i = i + 1) begin
            for (j = -5; j <= 5; j = j + 1) begin
                apply_test(i, j, ADD);
                apply_test(i, j, ADDI);
                apply_test(i, j, ADDU);
                apply_test(i, j, ADDUI);
                apply_test(i, j, ADDC);
                apply_test(i, j, ADDCI);

            end
        end

        $display("ALU testbench completed.");
        $finish;
    end

endmodule