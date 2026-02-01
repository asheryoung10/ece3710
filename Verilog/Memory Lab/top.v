//======================================================
// top.v
// Connects dual-port fib_copy_fsm to true dual-port BRAM
//======================================================

module top (
    input clk,
    input rst,
    output done,
	 
	 input [3:0] switches,
	 output [6:0] seven_seg_0,
	 output [6:0] seven_seg_1,
	 output [6:0] seven_seg_2,
	 output [6:0] seven_seg_3
);

    // -----------------------------
    // Wires between FSM and BRAM
    // -----------------------------
    // Port A (read)
    wire [9:0]  addr_a;
    wire        en_a;
    wire        we_a;     // always 0
    wire [15:0] dout_a;

    // Port B (write)
    wire [9:0]  addr_b;
    wire [15:0] din_b;
    wire        en_b;
    wire        we_b;

    // -----------------------------
    // FSM
    // -----------------------------
    fib_copy_fsm fsm (
        .clk    (clk),
        .rst    (rst),
		  .switches(switches),

        // Port A (read)
        .addr_a (addr_a),
        .en_a   (en_a),
        .we_a   (we_a),
        .dout_a (dout_a),

        // Port B (write)
        .addr_b (addr_b),
        .din_b  (din_b),
        .en_b   (en_b),
        .we_b   (we_b),

        .done   (done)
    );

    // -----------------------------
    // BRAM
    // -----------------------------
    memory bram (
        // Port A (FSM read)
        .addr_a (addr_a),
        .din_a  (16'd0),   // Port A is read-only for FSM
        .en_a   (en_a),
        .we_a   (we_a),
        .dout_a (dout_a),

        // Port B (FSM write)
        .addr_b (addr_b),
        .din_b  (din_b),
        .en_b   (en_b),
        .we_b   (we_b),
        .dout_b (),         // unused

        .clk    (clk)
    );
	
	 wire [3:0] bcd0;
	  wire [3:0] bcd1;
	   wire [3:0] bcd2;
		 wire [3:0] bcd3;
	 
	 bin16_to_bcd5 converter(
		.bin(dout_a),
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

