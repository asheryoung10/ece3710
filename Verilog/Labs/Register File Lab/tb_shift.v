`timescale 1ns/1ps

module tb_shift;

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
   reg [15:0] shiftValues [0:15];
	initial begin
        // init values
        clk      = 0;
        reset    = 1;
        switches = 0;
		  
		  shiftValues[0] = 16'd1; 
		  shiftValues[1] = 16'd2; 
		  shiftValues[2] = 16'd4; 
		  shiftValues[3] = 16'd8; 
		  shiftValues[4] = 16'd16; 
		  shiftValues[5] = 16'd32; 
		  shiftValues[6] = 16'd64; 
		  shiftValues[7] = 16'd128; 
		  shiftValues[8] = 16'd256; 
		  shiftValues[9] = 16'd512; 
		  shiftValues[10] = 16'd1024; 
		  shiftValues[11] = 16'd2048; 
		  shiftValues[12] = 16'd4096; 
		  shiftValues[13] = 16'd8192; 
		  shiftValues[14] = 16'd16384; 
		  shiftValues[15] = 16'd32768;
		 
        // apply reset
        apply_reset();

        // set input (example fib(6))
        switches = 4'd0;

        // step FSM manually
        repeat (20) begin
		  //repeat (40) begin //bitmask has more substates
            pulse_clk();
            $display("t=%0t  state=%0d  result=%0d",
                     $time, fsmState, currentResult);
        end
		  
		  for (i = 0; i < 16; i = i + 1) begin
				switches = i[3:0];
				pulse_clk();
				// Check result
            if (currentResult !== shiftValues[i]) begin
                	$display("FAIL: FIB VALUE AT REG%0d t=%0t  state=%0d  result=%0d, expected=%0d",
						i, $time, fsmState, currentResult, shiftValues[i]);
					 $stop;
            end 
		end


	  $display("No Errors, All tests Passed");
	  $finish;
    end

endmodule
