`timescale 1ns/1ps

module tb_fib;

    // -------------------------
    // DUT signals
    // -------------------------
    reg         clk;
    reg         reset;
    reg [3:0]   switches;
	 integer i;

    wire [2:0]  fsmState;
    wire [15:0] currentResult;

    // -------------------------
    // Instantiate DUT
    // -------------------------
    lab1 uut (
        .clk(clk),
        .reset(reset),
        .switches(switches),
        .fsmState(fsmState),
        .currentResult(currentResult)
    );

    // -------------------------
    // Clock pulse task
    // -------------------------
    task pulse_clk;
    begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end
    endtask

    // -------------------------
    // Optional: reset task
    // -------------------------
    task apply_reset;
    begin
        reset = 0;
        pulse_clk();
        reset = 1;
    end
    endtask

    // -------------------------
    // Test sequence
    // -------------------------
    initial begin
        // init values
        clk      = 0;
        reset    = 1;
        switches = 0;

        // apply reset
        apply_reset();

        // set input (example fib(6))
        switches = 4'd6;

        // step FSM manually
        repeat (20) begin
            pulse_clk();
            $display("t=%0t  state=%0d  result=%0d",
                     $time, fsmState, currentResult);
        end
		  
		  for (i = 0; i < 16; i = i + 1) begin
				switches = i[3:0];
				pulse_clk();
				$display("FIB VALUE AT REG%0d t=%0t  state=%0d  result=%0d",
             i, $time, fsmState, currentResult);
		end


        $display("FINAL RESULT = %0d", currentResult);
        $finish;
    end

endmodule
