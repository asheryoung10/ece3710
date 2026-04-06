module cpu
#(
    parameter DATA_WIDTH = 16,
    parameter MEMORY_ADDR_WIDTH = 16
)
(
    input clock,
    input reset,

    output [DATA_WIDTH-1:0] instructionRegisterContentsOutput,
    output [DATA_WIDTH-1:0] programCounterContentsOutput,
    output [DATA_WIDTH-1:0] programStateRegisterContentsOutput,
    output [DATA_WIDTH-1:0] aluResultOutput,
    output [4:0] aluFlagsOutput,
	 
	output [2:0] controlUnitState,
	output [2:0] controlUnitNextState,
	
	output memoryWriteEnable,
	output [MEMORY_ADDR_WIDTH-1:0] memoryReadWriteAddress,
	output [DATA_WIDTH-1:0] registerFileContentsB,
	input [DATA_WIDTH-1:0] memoryContents,
	
	input wire leftButton,
	input wire rightButton,
	input wire jumpButton,
	input wire vsync,
	
	output wire [15:0] R3
);

//
// Connections/Wires
//

// Inputs


// Outputs



// Inputs
wire savePreviousInstructionTargetRegIndex;
wire instructionAsImmediate;
wire registerFileWriteEnable;
wire [DATA_WIDTH-1:0] registerFileWriteData;
wire [3:0] registerFileReadAddressA;
wire [3:0] registerFileReadAddressB;
//Outputs
wire [DATA_WIDTH-1:0] registerFileContentsA;

// Inputs
wire [DATA_WIDTH-1:0] aluA;

wire [7:0] aluOpcode;
// Outputs
wire [4:0] aluFlags;
wire [DATA_WIDTH-1:0] aluResult;

// Inputs
wire instructionRegisterWriteEnable;
// Outputs
wire [DATA_WIDTH-1:0] instructionRegisterContents;

// Inputs
wire programStateRegisterWriteEnable;
wire [DATA_WIDTH-1:0] programStateRegisterWriteData;
// Outputs
wire [DATA_WIDTH-1:0] programStateRegisterContents;

// Inputs
wire aluSelectImmediate;

// Output
wire [15:0] instructionDecoderImmediate;
// Inputs
wire [1:0] registerFileSelectInput;
wire memorySelectReadWriteAddress;

// Inputs
wire programCounterWriteEnable;
wire [DATA_WIDTH-1:0] programCounterWriteData;
// Outputs
wire [DATA_WIDTH-1:0] programCounterContents;


//
// Core modules
//



register_file 
#(
    .DATA_WIDTH(DATA_WIDTH)
)
register_file_instance
(
    // Inputs
    .clock(clock),
    .reset(reset),
    .writeEnable(registerFileWriteEnable),
    .writeAddress(registerFileReadAddressB),
    .writeData(registerFileWriteData),
    .readAddressA(registerFileReadAddressA),
    .readAddressB(registerFileReadAddressB),
    // Outputs
    .contentsA(registerFileContentsA),
    .contentsB(registerFileContentsB),
	 .leftButton(leftButton),
	 .rightButton(rightButton),
	 .jumpButton(jumpButton),
	 .vsync(vsync),
	 .R3(R3)
);


alu 
#(
    .DATA_WIDTH(DATA_WIDTH)
)
alu_instance
(
    // Inputs
    .A(aluA),
    .B(registerFileContentsB),
    .Opcode(aluOpcode),
    // Outputs
    .Flags(aluFlags),
    .Result(aluResult)
);

register 
#(
    .DATA_WIDTH(DATA_WIDTH)
)
instruction_register
(
    // Inputs
    .clock(clock),
    .reset(reset),
    //Outputs
    .writeEnable(instructionRegisterWriteEnable),
    .writeData(memoryContents),
    .contents(instructionRegisterContents)
);

register 
#(
    .DATA_WIDTH(DATA_WIDTH)
)
program_state_register
(
    // Inputs
    .clock(clock),
    .reset(reset),
    //Outputs
    .writeEnable(programStateRegisterWriteEnable),
    .writeData(aluFlags),
    .contents(programStateRegisterContents)
);

register
#(
    .DATA_WIDTH(DATA_WIDTH)
)
 program_counter
(
    // Inputs
    .clock(clock),
    .reset(reset),
    //Outputs
    .writeEnable(programCounterWriteEnable),
    .writeData(programCounterWriteData),
    .contents(programCounterContents)
);

instruction_decoder instruction_decoder_instance
(
    // Inputs
	 .clock(clock),
	 .savePreviousInstructionTargetRegIndex(savePreviousInstructionTargetRegIndex),
	 .instructionAsImmediate(instructionAsImmediate),
    .instruction(instructionRegisterContents),
	.programCounter(programCounterContents),
    .programStateRegisterContents(programStateRegisterContents),
    .registerFileContentsA(registerFileContentsA),
    // Outputs
    .registerAddressA(registerFileReadAddressA),
    .registerAddressB(registerFileReadAddressB),
    .immediate(instructionDecoderImmediate),
    .aluOpcode(aluOpcode),
	.nextProgramCounter(programCounterWriteData)
);


//
// Muxes
//

mux2 
#(
    .DATA_WIDTH(DATA_WIDTH)
)
alu_input_mux
(
    // Inputs
    .select(aluSelectImmediate),
    .selection0(registerFileContentsA),
    .selection1(instructionDecoderImmediate),
    // Outputs
    .selection(aluA)
);

mux2 
#(
    .DATA_WIDTH(MEMORY_ADDR_WIDTH)
)
memory_select_read_write_address_mux
(
    // Inputs
    .select(memorySelectReadWriteAddress),
    .selection0(programCounterContents),
    .selection1(registerFileContentsA),
    // Outputs
    .selection(memoryReadWriteAddress)
);

mux4 
#(
    .DATA_WIDTH(DATA_WIDTH)
)
register_file_input_mux
(
    // Inputs
    .select(registerFileSelectInput),
    .selection0(aluResult),
    .selection1(registerFileContentsA),
    .selection2(instructionDecoderImmediate),
    .selection3(memoryContents),
    // Outputs
    .selection(registerFileWriteData)
);

//
// Control Unit
//
control_unit control_unit_instance
(
    .clock(clock),
    .reset(reset),
    .aluOpcode(aluOpcode),
	 .instructionAsImmediate(instructionAsImmediate),
	 .savePreviousInstructionTargetRegIndex(savePreviousInstructionTargetRegIndex),

    .memoryWriteEnable(memoryWriteEnable),
    .registerFileWriteEnable(registerFileWriteEnable),
    .registerFileSelectInput(registerFileSelectInput),

    .instructionRegisterWriteEnable(instructionRegisterWriteEnable),
    .programCounterWriteEnable(programCounterWriteEnable),
    .programStateRegisterWriteEnable(programStateRegisterWriteEnable),

    .aluSelectImmediate(aluSelectImmediate),
    .memorySelectReadWriteAddress(memorySelectReadWriteAddress),
	 
	.state(controlUnitState),
	.nextState(controlUnitNextState)
);



//
// Module Outputs
//
assign instructionRegisterContentsOutput = instructionRegisterContents;
assign programCounterContentsOutput = programCounterContents;
assign programStateRegisterContentsOutput = programStateRegisterContents;
assign aluResultOutput = aluResult;
assign aluFlagsOutput = aluFlags;
endmodule