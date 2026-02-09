module control_unit
(
    input clock,
    input reset,

    input [7:0] aluOpcode,

    output reg memoryWriteEnable,

    output reg registerFileWriteEnable,
    output reg [1:0] registerFileSelectInput,

    output reg instructionRegisterWriteEnable,
    output reg programCounterWriteEnable,
    output reg programStateRegisterWriteEnable,

    output reg aluSelectImmediate,
    output reg memorySelectReadWriteAddress,
	 
	 output reg [2:0] state,
	 output reg [2:0] nextState
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
			localparam LSHI	= 8'b1000_000x;
			localparam RSH		= 8'b1000_100x;	
		 	localparam RSHI	= 8'b1000_101x;
			localparam ARSH 	= 8'b1000_0110;
			localparam ARSHI 	= 9'b1000_001x;
			localparam NOP		= 8'b0000_0000;
			// States
			localparam FETCH     = 3'd0;
			localparam DECODE    = 3'd1;
			localparam EXECUTE   = 3'd2;
			localparam WRITEBACK = 3'd3;

    // State register
    always @(posedge clock or posedge reset) begin
        if (reset)
            state <= FETCH;
        else
            state <= nextState;
    end

    // Default control values
    always @(*) begin
        // Defaults (safe!)
        memoryWriteEnable              = 1'b0;
        registerFileWriteEnable        = 1'b0;
        instructionRegisterWriteEnable = 1'b0;
        programCounterWriteEnable      = 1'b0;
        programStateRegisterWriteEnable= 1'b0;

        aluSelectImmediate             = 1'b0;
        memorySelectReadWriteAddress   = 1'b0;
        registerFileSelectInput        = 2'b00;

        nextState = state;

        case (state)

            // ======================
            // FETCH
            // ======================
            FETCH: begin
                memorySelectReadWriteAddress   = 1'b0; // PC → memory
                instructionRegisterWriteEnable = 1'b1; // IR <= memory
                programCounterWriteEnable      = 1'b1; // PC++

                nextState = DECODE;
            end

            // ======================
            // DECODE
            // ======================
            DECODE: begin
                // No writes, just let instruction decoder settle
                nextState = EXECUTE;
            end

            // ======================
            // EXECUTE
            // ======================
            EXECUTE: begin
                // Example: ALU register-register or immediate
                casex (aluOpcode)
						  ADDI, SUBI: aluSelectImmediate = 1'b1;  // I-type
						  default:    aluSelectImmediate = 1'b0;  // Register-register type
					 endcase

                nextState = WRITEBACK;
            end

            // ======================
            // WRITEBACK
            // ======================
            WRITEBACK: begin
					casex (aluOpcode)
						  ADDI, SUBI: aluSelectImmediate = 1'b1;  // I-type
						  default:    aluSelectImmediate = 1'b0;  // Register-register type
					 endcase
                registerFileWriteEnable = 1'b1;
                registerFileSelectInput = 2'b00; // ALU result

                nextState = FETCH;
            end

            default: begin
                nextState = FETCH;
            end
        endcase
    end

endmodule
