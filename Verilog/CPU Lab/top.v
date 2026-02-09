module top
(
    input  wire                 clock,
    input  wire                 reset,
    output [15:0] aluResultOutput
);

cpu cpu_instance
	 (
		.clock(clock),
		.reset(reset),
		.aluResultOutput(aluResultOutput)
	 );

endmodule