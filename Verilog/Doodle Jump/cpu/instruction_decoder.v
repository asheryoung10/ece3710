module instruction_decoder (
	input wire clock,
	 input wire instructionAsImmediate,
    input [15:0] instruction,
	input [15:0] programCounter,
    input [15:0] programStateRegisterContents,
    input [15:0] registerFileContentsA,
	 	 input wire savePreviousInstructionTargetRegIndex,

	 
    output [3:0] registerAddressA,
    output [3:0] registerAddressB,
    output [15:0] immediate,
    output [7:0] aluOpcode,
	output reg [15:0] nextProgramCounter
);
// Next Program Counter Logic
`include "opcodes.vh"
`include "conditions.vh"
`include "indicesPSR.vh"
reg [3:0] addressTarget;
reg [15:0] programCounterPlusOne;
assign registerAddressA = instruction[3:0];
assign registerAddressB = (instructionAsImmediate) ? addressTarget : instruction[11:8];
assign aluOpcode = {instruction[15:12], instruction[7:4]};
assign immediate = (instructionAsImmediate) ? instruction : ((aluOpcode == JAL) ? programCounterPlusOne : {{8{instruction[7]}}, instruction[7:0]});


always @(posedge clock) begin
	if(aluOpcode == READ) begin
		if(savePreviousInstructionTargetRegIndex) begin
			addressTarget = registerAddressB;
		end
	end
end


reg conditionMet;
always @(*) begin
    conditionMet = 1'b0;
    case (instruction[11:8])
        EQ: conditionMet = programStateRegisterContents[ZIndex];
        NE: conditionMet = ~programStateRegisterContents[ZIndex];
        GE: conditionMet = programStateRegisterContents[NIndex] | programStateRegisterContents[ZIndex];
        CS: conditionMet = programStateRegisterContents[CIndex];
        CC: conditionMet = ~programStateRegisterContents[CIndex];
        HI: conditionMet = programStateRegisterContents[LIndex];
        LS: conditionMet = ~programStateRegisterContents[LIndex];
        LO: conditionMet = ~programStateRegisterContents[LIndex] & ~programStateRegisterContents[ZIndex];
        HS: conditionMet = programStateRegisterContents[LIndex] | programStateRegisterContents[ZIndex];
        GT: conditionMet = programStateRegisterContents[NIndex];
        LE: conditionMet = ~programStateRegisterContents[NIndex];
        FS: conditionMet = programStateRegisterContents[FIndex];
        FC: conditionMet = ~programStateRegisterContents[FIndex];
        LT: conditionMet = ~programStateRegisterContents[NIndex] & ~programStateRegisterContents[ZIndex];
        UC: conditionMet = 1'b1;
        4'b1111: conditionMet = 1'b0;
        default: conditionMet = 1'b0;
    endcase
end
always @(*) begin
		programCounterPlusOne = programCounter+1;
       casex(aluOpcode)
		  JAL: begin
				nextProgramCounter = registerFileContentsA;
		  
		  end
        BCOND: begin
            if(conditionMet)
                nextProgramCounter = programCounter + immediate;
            else
                nextProgramCounter = programCounter + 1;
            
        end
        JCOND: begin
            if(conditionMet)
                nextProgramCounter = registerFileContentsA;
            else 
                nextProgramCounter = programCounter + 1;
            
        end
        default: begin
            nextProgramCounter = programCounter + 1;
        end

    endcase
end

endmodule