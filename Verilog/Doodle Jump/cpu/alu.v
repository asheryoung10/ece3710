module alu 
#(
    parameter DATA_WIDTH = 16
)
(
    input  [DATA_WIDTH-1:0] A,      // Source/Immediate
    input  [DATA_WIDTH-1:0] B,      // Destination
    input  [7:0] Opcode,

    output reg [4:0] Flags,         // {C, L, F, Z, N}
    output reg [DATA_WIDTH-1:0] Result
);

    `include "opcodes.vh" 
    `include "states.vh"

    // Individual flag bits
    reg cFlag, lFlag, fFlag, zFlag, nFlag;
    integer shift_amt;
	 integer shift_amt_comp;

    reg [3:0] sa;
    reg signed [DATA_WIDTH-1:0] negA;

    always @(*) begin
        // Default values
        cFlag = 1'bx; lFlag = 1'bx; fFlag = 1'bx; zFlag = 1'b0; nFlag = 1'bx;
        Result = 0;

        casex(Opcode)
            // Signed addition
            ADD, ADDI: begin
                Result = $signed(B) + $signed(A);
                zFlag = Result == 0;
                cFlag = 1'b0;
                fFlag = (B[DATA_WIDTH-1] == A[DATA_WIDTH-1]) && (Result[DATA_WIDTH-1] != B[DATA_WIDTH-1]);
                lFlag = 1'bx;
                nFlag = $signed(B) < $signed(A);
            end

            // Unsigned addition
            ADDU, ADDUI: begin
                {cFlag, Result} = B + A;
                zFlag = Result == 0;
                fFlag = 1'b0;
                lFlag = B < A;
                nFlag = 1'bx;
            end

            // Addition with carry
            ADDC, ADDCI: begin
                {cFlag, Result} = cFlag + $signed(B) + $signed(A);
                zFlag = 1'bx;
                fFlag = (B[DATA_WIDTH-1] == A[DATA_WIDTH-1]) && (Result[DATA_WIDTH-1] != B[DATA_WIDTH-1]);
                lFlag = 1'bx;
                nFlag = 1'bx;
            end

            // Signed subtraction
            SUB, SUBI: begin
                negA = -$signed(A);
                Result = $signed(B) + negA;
                zFlag = Result == 0;
                cFlag = 1'b0;
                fFlag = (B[DATA_WIDTH-1] == A[DATA_WIDTH-1]) && (Result[DATA_WIDTH-1] != B[DATA_WIDTH-1]);
                lFlag = 1'bx;
                nFlag = $signed(B) < $signed(A);
            end

            // Compare
            CMP, CMPI: begin
                Result = 0;
                zFlag = $signed(B) == $signed(A);
                cFlag = 1'bx;
                fFlag = 1'bx;
                lFlag = B < A;
                nFlag = $signed(B) < $signed(A);
            end

            // Bitwise operations
            AND:  Result = B & A;
            OR:   Result = B | A;
            XOR:  Result = B ^ A;
            NOT:  Result = ~A;

            // Shifts
            LSH, LSHI: begin
                // Extract lower 5 bits and sign-extend
					shift_amt = $signed({{11{A[4]}}, A[4:0]});  // replicate the sign bit 11 times to make 16-bit signed
					sa = (shift_amt >= 0) ? shift_amt : -shift_amt;
					Result = (shift_amt >= 0) ? (B << sa) : (B >> sa);
            end
            RSH, RSHI: begin
                shift_amt = A;
                Result = (shift_amt >= 0) ? (B >> shift_amt) : (B << -shift_amt);
            end
            ARSH, ARSHI: begin
					 shift_amt = $signed({{11{A[4]}}, A[4:0]});
						shift_amt_comp = - shift_amt;
					 if (shift_amt >= 0) begin
						  sa = shift_amt[3:0];        // safe truncate positive
						  Result = B << sa;
					 end else begin
						  sa = shift_amt_comp[3:0];     // safe truncate magnitude
						  Result = $signed(B) >>> sa;
					 end
				end

            // NOP and LOAD/STOR
            default: begin
                Result = B; // pass-through
            end
        endcase

        // Update flags
        Flags = {cFlag, lFlag, fFlag, zFlag, nFlag};
    end

endmodule
