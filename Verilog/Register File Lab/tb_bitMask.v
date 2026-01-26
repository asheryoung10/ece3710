`timescale 1ns/1ps

module tb_bitMask;

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
   reg [15:0] maskValues [0:15];
	initial begin
        // init values
        clk      = 0;
        reset    = 1;
        switches = 0;
			
		  maskValues[0] = 16'd1; 
		  maskValues[1] = 16'd3; 
		  maskValues[2] = 16'd7; 
			maskValues[3] = 16'd15; 
			maskValues[4] = 16'd31; 
			maskValues[5] = 16'd63; 
			maskValues[6] = 16'd127; 
			maskValues[7] = 16'd255; 
			maskValues[8] = 16'd511; 
			maskValues[9] = 16'd1023; 
			maskValues[10] = 16'd2047; 
			maskValues[11] = 16'd4095; 
			maskValues[12] = 16'd8191; 
			maskValues[13] = 16'd16383; 
			maskValues[14] = 16'd32767; 
			maskValues[15] = 16'd65535;

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
            if (currentResult !== maskValues[i]) begin
                	$display("FAIL: FIB VALUE AT REG%0d t=%0t  state=%0d  result=%0d, expected=%0d",
						i, $time, fsmState, currentResult, maskValues[i]);
					 $stop;
            end 
		end


	  $display("No Errors, All tests Passed");
	  $finish;
    end

endmodule
