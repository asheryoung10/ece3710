module control_unit
(
    input clock,
    input reset,
    input [7:0] aluOpcode,

    output reg memoryWriteEnable,
    output reg memorySelectReadWriteAddress,
    output reg registerFileWriteEnable,
    output reg [1:0] registerFileSelectInput,
    output reg instructionRegisterWriteEnable,
    output reg programCounterWriteEnable,
    output reg programStateRegisterWriteEnable,
    output reg aluSelectImmediate,
	output reg [2:0] state,
	output reg [2:0] nextState
);
     
`include "opcodes.vh"
`include "states.vh"

always @(posedge clock or posedge reset) begin
    if (reset)
        state <= FETCH_INSTRUCTION_FROM_MEMORY;
    else
        state <= nextState;
end

always @(*) begin
    memoryWriteEnable               = 1'b0;
    memorySelectReadWriteAddress    = 1'b0;
    registerFileWriteEnable         = 1'b0;
    registerFileSelectInput         = 2'b0;
    instructionRegisterWriteEnable  = 1'b0;
    programCounterWriteEnable       = 1'b0;
    programStateRegisterWriteEnable = 1'b0;
    aluSelectImmediate              = 1'b0;
    state                           = state;
    nextState                       = NOTHING_STATE;

    case (state)
        FETCH_INSTRUCTION_FROM_MEMORY: begin
            // Address memory with program counter
            memorySelectReadWriteAddress = 1'b0;
            nextState = LOAD_INSTRUCTION_INTO_INSTRUCTION_REGISTER;

        end
        LOAD_INSTRUCTION_INTO_INSTRUCTION_REGISTER: begin
            // Write instruction to the instruction register
            instructionRegisterWriteEnable = 1'b1;
            nextState = DECODE_INSTRUCTION;
        end 
        DECODE_INSTRUCTION: begin
            programCounterWriteEnable = 1'b1;
            // Choose next state
            casex (aluOpcode)
					CMP, CMPI: begin
							registerFileWriteEnable = 1'b0;
						  programStateRegisterWriteEnable = 1'b1;
                    nextState = FETCH_INSTRUCTION_FROM_MEMORY;
					end
                ADD, ADDI, ADDUI, ADDC, ADDCI, SUB, SUBI,  AND, OR, XOR, NOT, LSH, LSHI, RSH, RSHI, ARSH, ARSHI: begin
                    registerFileWriteEnable = 1'b1;
						  programStateRegisterWriteEnable = 1'b1;
                    nextState = FETCH_INSTRUCTION_FROM_MEMORY;
							end
                LOAD: 
                    nextState = EXECUTE_LOAD_INSTRUCTION;
                STOR:
                    nextState = FETCH_INSTRUCTION_FROM_MEMORY;
                MOV, MOVI: begin
                    registerFileWriteEnable = 1'b1;
                    nextState = FETCH_INSTRUCTION_FROM_MEMORY;
					 end
					 BCOND, JCOND: begin
						nextState = FETCH_INSTRUCTION_FROM_MEMORY;
					 end
            endcase

            // Setup next state
            casex (aluOpcode)
                ADDI, ADDUI, ADDCI, SUBI, CMPI, LSHI, RSHI, ARSHI: aluSelectImmediate = 1'b1;
                MOV:    registerFileSelectInput = 2'b01; // Select Contents A
                MOVI:   registerFileSelectInput = 2'b10; // Select Immediate
                LOAD:   memorySelectReadWriteAddress = 1'b1;
                STOR: begin
                    memoryWriteEnable = 1'b1;
                    memorySelectReadWriteAddress = 1'b1;
                end
            endcase
        end
        EXECUTE_LOAD_INSTRUCTION: begin
            registerFileWriteEnable = 1'b1;
            registerFileSelectInput = 2'b11;
				memorySelectReadWriteAddress = 1'b1;
				nextState = FETCH_INSTRUCTION_FROM_MEMORY;
        end
        NOTHING_STATE: begin
            nextState = NOTHING_STATE;
        end
    endcase
end

endmodule