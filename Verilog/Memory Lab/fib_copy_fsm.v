//======================================================
// fib_copy_fsm.v
// Dual-port FSM (3-state copy):
//   Port A reads  mem[0..15]
//   Port B writes mem[512..527]
//======================================================

module fib_copy_fsm (
    input  clk,
    input  rst,
	 input [3:0] switches,
	 
    // -------- BRAM Port A (READ) --------
    output reg [9:0]  addr_a,
    output reg        en_a,
    output reg        we_a,     // always 0
    input      [15:0] dout_a,
	 

    // -------- BRAM Port B (WRITE) --------
    output reg [9:0]  addr_b,
    output reg [15:0] din_b,
    output reg        en_b,
    output reg        we_b,

    output reg done
);

    // FSM states
    localparam IDLE         = 3'd0;
    localparam SETUP_READ   = 3'd1;
    localparam CAPTURE_READ = 3'd2;
    localparam APPLY_WRITE  = 3'd3;
    localparam FINISH       = 3'd4;

    reg [2:0] state;
    reg [4:0] index;           // 0..15
    reg [15:0] buffer;         // capture dout_a

    // -------------------------------
    // FSM
    // -------------------------------
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            index <= 5'd0;
            done  <= 1'b0;

            // Port A
            en_a  <= 1'b0;
            we_a  <= 1'b0;

            // Port B
            en_b  <= 1'b0;
            we_b  <= 1'b0;
            din_b <= 16'd0;
            addr_b <= 10'd0;
        end
        else begin
            case (state)

                // -----------------------
                // IDLE
                // -----------------------
                IDLE: begin
                    index <= 5'd0;
                    done  <= 1'b0;

                    en_a <= 1'b0;
                    en_b <= 1'b0;
                    we_b <= 1'b0;

                    state <= SETUP_READ;
                end

                // -----------------------
                // SETUP_READ
                // Present address on Port A
                // -----------------------
                SETUP_READ: begin
                    en_a   <= 1'b1;
                    we_a   <= 1'b0;
                    addr_a <= index;

                    en_b   <= 1'b0;
                    we_b   <= 1'b0;

                    state <= CAPTURE_READ;
                end

                // -----------------------
                // CAPTURE_READ
                // Capture data from Port A into buffer
                // -----------------------
                CAPTURE_READ: begin
                    //buffer <= dout_a;   // store synchronous read value

                    // Keep Port A enabled
                    en_a <= 1'b1;
                    we_a <= 1'b0;

                    // Prepare to write next
                    state <= APPLY_WRITE;
                end

                // -----------------------
                // APPLY_WRITE
                // Write buffered data to Port B
                // -----------------------
                APPLY_WRITE: begin
                    en_a <= 1'b1;
                    we_a <= 1'b0;

                    en_b   <= 1'b1;
                    we_b   <= 1'b1;
                    addr_b <= 10'd512 + index;
                    din_b  <= dout_a;

                    // Advance or finish
                    if (index == 5'd15)
                        state <= FINISH;
                    else begin
                        index <= index + 1'b1;
                        state <= SETUP_READ;
                    end
                end

                // -----------------------
                // FINISH
                // -----------------------
                FINISH: begin
                    en_a <= 1'b1;
						  we_a <= 1'b0;
						  addr_a = switches;
                    en_b <= 1'b0;
                    we_b <= 1'b0;
                    done <= 1'b1;
                    state <= FINISH;
                end

            endcase
        end
    end

endmodule

