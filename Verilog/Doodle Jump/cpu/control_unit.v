module control_unit
(
    input clock,
    input reset,
	 output reg savePreviousInstructionTargetRegIndex,
    input [7:0] aluOpcode,
	 output reg instructionAsImmediate,
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
reg currentIsRead;
reg readNow;
always @(posedge clock or posedge reset) begin
    if (reset) begin
        state <= FETCH_INSTRUCTION_FROM_MEMORY;
		  readNow <= 0;
	end
    else begin
        state <= nextState;
		if(state == LOAD_INSTRUCTION_INTO_INSTRUCTION_REGISTER) begin
			if(currentIsRead) begin
				readNow <= 1;
			end else begin
				readNow <= 0;
			end
		end
	end
end

always @(*) begin
	if(reset) begin
		currentIsRead = 0;
	end
    memoryWriteEnable               = 1'b0;
    memorySelectReadWriteAddress    = 1'b0;
    registerFileWriteEnable         = 1'b0;
    registerFileSelectInput         = 2'b0;
    instructionRegisterWriteEnable  = 1'b0;
    programCounterWriteEnable       = 1'b0;
    programStateRegisterWriteEnable = 1'b0;
    aluSelectImmediate              = 1'b0;
    state                           = state;
	 instructionAsImmediate = 0;
	 savePreviousInstructionTargetRegIndex = 0;
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
				if(readNow) begin
					instructionAsImmediate = 1;
					registerFileWriteEnable = 1'b1;
					nextState = FETCH_INSTRUCTION_FROM_MEMORY;
					registerFileSelectInput = 2'b10; // Select Immediate which has pc+1 for JAL
					currentIsRead = 0;
				end else begin
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
						 JAL: begin
							registerFileWriteEnable = 1'b1;
							nextState = FETCH_INSTRUCTION_FROM_MEMORY;
							registerFileSelectInput = 2'b10; // Select Immediate which has pc+1 for JAL
						 end
						 READ: begin
							currentIsRead = 1;
							nextState = FETCH_INSTRUCTION_FROM_MEMORY;
							savePreviousInstructionTargetRegIndex = 1;
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