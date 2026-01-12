module lab1 (
    input  wire [9:0] SW,	 // 10 Switches
    output wire [7:0] HEX0, // LSByte ALU result
	 output wire [7:0] HEX1,
	 output wire [7:0] HEX2,
	 output wire [7:0] HEX3, // MSByte ALU result
	 output wire [4:0] flags // Flags
);
	
	 wire [15:0] result;
	 
	 alu Alu (
    .Rsrc_Imm(16'b0),
    .Rdest   (16'b0),
    .Opcode  (SW),
    .Flags   (flags),
    .Result  (result)
	); 
	
	seven_seg_decoder u0 (
        .bin(result[3:0]),
        .hex(HEX0)
    );
	 
	 seven_seg_decoder u1 (
        .bin(result[7:4]),
        .hex(HEX1)
    );
	 
	 seven_seg_decoder u2 (
        .bin(result[11:8]),
        .hex(HEX2)
    );
	 
	 seven_seg_decoder u3 (
        .bin(result[15:12]),
        .hex(HEX3)
    );


endmodule
