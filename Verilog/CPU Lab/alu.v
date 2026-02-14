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

    // Opcodes
    localparam ADD   = 8'b0000_0101;
    localparam ADDI  = 8'b0101_xxxx;
    localparam ADDU  = 8'b0000_0110;
    localparam ADDUI = 8'b0110_xxxx;
    localparam ADDC  = 8'b0000_0111;
    localparam ADDCI = 8'b0111_xxxx;
    localparam SUB   = 8'b0000_1001;
    localparam SUBI  = 8'b1001_xxxx;
    localparam CMP   = 8'b0000_1011;
    localparam CMPI  = 8'b1011_xxxx;
    localparam AND   = 8'b0000_0001;
    localparam OR    = 8'b0000_0010;
    localparam XOR   = 8'b0000_0011;
    localparam NOT   = 8'b0000_0100;
    localparam LSH   = 8'b1000_0100;
    localparam LSHI  = 8'b1000_000x;
    localparam RSH   = 8'b1000_100x;
    localparam RSHI  = 8'b1000_101x;
    localparam ARSH  = 8'b1000_0110;
    localparam ARSHI = 8'b1000_001x;
    localparam NOP   = 8'b0000_0000;
	 
	 localparam LOAD  = 8'b0100_0000;
	 localparam STOR  = 8'b0100_0100;

    // Individual flag bits
    reg cFlag, lFlag, fFlag, zFlag, nFlag;
    integer shift_amt;
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
                shift_amt = $signed(A);
                sa = (shift_amt >= 0) ? shift_amt : -shift_amt;
                Result = (shift_amt >= 0) ? (B << sa) : (B >> sa);
            end
            RSH, RSHI: begin
                shift_amt = A;
                Result = (shift_amt >= 0) ? (B >> shift_amt) : (B << -shift_amt);
            end
            ARSH, ARSHI: begin
                shift_amt = $signed(A);
                Result = (shift_amt >= 0) ? ($signed(B) >>> shift_amt) : ($signed(B) <<< -shift_amt);
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
