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
   reg [15:0] fibValues [0:15];
	initial begin
        // init values
        clk      = 0;
        reset    = 1;
        switches = 0;
			
		  fibValues[0] = 16'd0; 
		  fibValues[1] = 16'd1; 
		  fibValues[2] = 16'd1; 
			fibValues[3] = 16'd2; 
			fibValues[4] = 16'd3; 
			fibValues[5] = 16'd5; 
			fibValues[6] = 16'd8; 
			fibValues[7] = 16'd13; 
			fibValues[8] = 16'd21; 
			fibValues[9] = 16'd34; 
			fibValues[10] = 16'd55; 
			fibValues[11] = 16'd89; 
			fibValues[12] = 16'd144; 
			fibValues[13] = 16'd233; 
			fibValues[14] = 16'd377; 
			fibValues[15] = 16'd610;

        // apply reset
        apply_reset();

        // set input (example fib(6))
        switches = 4'd6;

        // step FSM manually
        //repeat (20) begin
		  repeat (40) begin //bitmask has more substates
            pulse_clk();
            $display("t=%0t  state=%0d  result=%0d",
                     $time, fsmState, currentResult);
        end
		  
		  for (i = 0; i < 16; i = i + 1) begin
				switches = i[3:0];
				pulse_clk();
				// Check result
            if (currentResult !== fibValues[i]) begin
                	$display("FAIL: FIB VALUE AT REG%0d t=%0t  state=%0d  result=%0d, expected=%0d",
						i, $time, fsmState, currentResult, fibValues[i]);
					 $stop;
            end 
		end


	  $display("No Errors, All tests Passed");
	  $finish;
    end

endmodule
