module instruction_decoder (
    input [15:0] instruction,
	 input [15:0] programCounter,
	 
    output [3:0] registerAddressA,
    output [3:0] registerAddressB,
    output [15:0] immediate,
    output [7:0] aluOpcode,
	 output [15:0] nextProgramCounter
);

assign registerAddressA = instruction[3:0];
assign registerAddressB = instruction[11:8];
assign immediate = $signed(instruction[7:0]);
assign aluOpcode = {instruction[15:12], instruction[7:4]}; // inst = 5101 => 0101_0000 //aluopcode = 0x0a when should be
assign nextProgramCounter = programCounter + 1;

endmodule