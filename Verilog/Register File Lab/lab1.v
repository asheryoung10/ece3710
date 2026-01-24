module lab1 #(
    parameter BIT_WIDTH    = 16,
    parameter SEL_WIDTH    = 4,
    parameter OPCODE_WIDTH = 8,
    parameter FLAG_WIDTH   = 5
)(
    input  wire                 clk,
    input  wire                 reset,
    input  wire [3:0]           switches,   // user register select
    output wire [6:0]           seven_seg_0,
	 output wire [6:0]           seven_seg_1,
	 output wire [6:0]           seven_seg_2,
	 output wire [6:0]           seven_seg_3,
	 output wire [2:0]				fsmState,
	 output wire [3:0]				switch
);

		assign switch = SrcAddr;
		wire reset_inverted = ~reset;

    // --------------------------------------------------
    // Control signals from FSM
    // --------------------------------------------------
    wire [SEL_WIDTH-1:0] SrcAddr;
    wire [SEL_WIDTH-1:0] DestAddr;
    wire [SEL_WIDTH-1:0] WriteAddr;

    wire regReset;
    wire regWriteEn;
    wire ImmMuxSel;

    wire [BIT_WIDTH-1:0] ImmData;
    wire [OPCODE_WIDTH-1:0] op;

    // --------------------------------------------------
    // Datapath wires
    // --------------------------------------------------
    wire [BIT_WIDTH-1:0] Rsrc;
    wire [BIT_WIDTH-1:0] Rdest;
    wire [BIT_WIDTH-1:0] ImmMuxOut;
    wire [BIT_WIDTH-1:0] ALUResult;
    wire [FLAG_WIDTH-1:0] Flags;

    // --------------------------------------------------
    // Control Unit (FSM)
    // --------------------------------------------------
    FibFSM #(
        .BIT_WIDTH(BIT_WIDTH),
        .SEL_WIDTH(SEL_WIDTH),
        .OPCODE_WIDTH(OPCODE_WIDTH)
    ) fsm (
        .clk(clk),
        .reset(reset_inverted),
        .SrcAddr(SrcAddr),
        .DestAddr(DestAddr),
        .WriteAddr(WriteAddr),
        .regReset(regReset),
        .regWriteEn(regWriteEn),
        .ImmMuxSel(ImmMuxSel),
        .ImmData(ImmData),
        .op(op),
		  .outputState(fsmState),
		  .userInput(switches)
    );

    // --------------------------------------------------
    // Register File
    // --------------------------------------------------
    register_file #(
        .BIT_WIDTH(BIT_WIDTH)
    ) rf (
        .clk(clk),
        .reset(regReset),
        .writeEn(regWriteEn),
        .writeData(ALUResult),
        .addrDest(DestAddr),
        .addrSrc(SrcAddr),
        .WriteAddr(WriteAddr),
        .Rdest(Rdest),
        .Rsrc(Rsrc)
    );

    // --------------------------------------------------
    // Immediate Mux
    // --------------------------------------------------
    ImmMux #(
        .BIT_WIDTH(BIT_WIDTH)
    ) imm_mux (
        .RSrc(Rsrc),
        .Imm(ImmData),
        .sel(ImmMuxSel),
        .ImmOut(ImmMuxOut)
    );

    // --------------------------------------------------
    // ALU
    // --------------------------------------------------
    alu #(
        .BIT_WIDTH(BIT_WIDTH),
        .OPCODE_WIDTH(OPCODE_WIDTH),
        .FLAG_WIDTH(FLAG_WIDTH)
    ) alu_unit (
        .Rsrc_Imm(ImmMuxOut),
        .Rdest(Rdest),
        .Opcode(op),
        .Flags(Flags),
        .Result(ALUResult)
    );

    // --------------------------------------------------
    // Display logic
    // After FSM finishes, user selects register via switches
    // --------------------------------------------------
    wire [BIT_WIDTH-1:0] display_value = Rsrc;
	 wire [3:0] bcd0;
	  wire [3:0] bcd1;
	   wire [3:0] bcd2;
		 wire [3:0] bcd3;
	 
	 bin16_to_bcd5 converter(
		.bin(Rsrc),
		.bcd0(bcd0),
		.bcd1(bcd1),
		.bcd2(bcd2),
		.bcd3(bcd3)
	 );

    seven_seg_decoder seg0 (
        .bin(bcd0),
        .hex(seven_seg_0)
    );
	 seven_seg_decoder seg1 (
        .bin(bcd1),
        .hex(seven_seg_1)
    );
	 seven_seg_decoder seg2 (
        .bin(bcd2),
        .hex(seven_seg_2)
    );
	 seven_seg_decoder seg3 (
		  .bin(bcd3),
        .hex(seven_seg_3)
    );


endmodule
