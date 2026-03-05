module top (
    input clk,
    input rst,
	 output [9:0]  addr_a,
    output        en_a,
    output        we_a,
    output [15:0] dout_a,

    output [9:0]  addr_b,
    output [15:0] din_b,
    output        en_b,
    output        we_b,
	 
	 output [2:0] state,
	 output [4:0] index,
	 output done
);

    fib_copy_fsm fsm (
        .clk    (clk),
        .rst    (rst),
		  .switches(switches),

        .addr_a (addr_a),
        .en_a   (en_a),
        .we_a   (we_a),
        .dout_a (dout_a),

        .addr_b (addr_b),
        .din_b  (din_b),
        .en_b   (en_b),
        .we_b   (we_b),
	
			.state(state),
			.index(index),
        .done(done)
    );

    bmemory bram (
        .addr_a (addr_a),
        .din_a  (16'd0), 
        .en_a   (en_a),
        .we_a   (we_a),
        .dout_a (dout_a),

        .addr_b (addr_b),
        .din_b  (din_b),
        .en_b   (en_b),
        .we_b   (we_b),
        .dout_b (dout_b),

        .clk    (clk)
    );

endmodule

