module lab1 (
    input  wire [3:0] SW,   // switches
    output wire [7:0] HEX0  // 7-seg display
);
    localparam ADDI   	= 8'b0101_xxxx;

    seven_seg_decoder u0 (
        .bin(SW),
        .hex(HEX0)
    );
	 alu Alu (
    .Rsrc_Imm(16'b0),
    .Rdest   (16'b0),
    .Opcode  (ADDI),
    .Flags   (),
    .Result  ()
);


endmodule
