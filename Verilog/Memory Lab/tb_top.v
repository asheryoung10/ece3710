`timescale 1ns/1ps

module tb_top;

    // Clock and reset
    reg clk;
    reg rst;

    // Wires for top module outputs
    wire [9:0]  addr_a;
    wire        en_a;
    wire        we_a;
    wire [15:0] dout_a;

    wire [9:0]  addr_b;
    wire [15:0] din_b;
    wire        en_b;
    wire        we_b;

    wire [2:0] state;
    wire [4:0] index;
    wire done;
	 integer i;

    // Instantiate the top module
    top uut (
        .clk    (clk),
        .rst    (rst),
        .addr_a (addr_a),
        .en_a   (en_a),
        .we_a   (we_a),
        .dout_a (dout_a),
        .addr_b (addr_b),
        .din_b  (din_b),
        .en_b   (en_b),
        .we_b   (we_b),
        .state  (state),
        .index  (index),
        .done   (done)
    );
	 
    task pulse_clk;
		 begin
			  clk = 0;
			  #5;
			  clk = 1;
			  #5;
		 end
    endtask


    task apply_reset;
		 begin
			  rst = 1;
			  pulse_clk();
			  rst = 0;
		 end
    endtask
	 
	task print_state;
		begin
			 $display("=======================================================");
			 $display("Time: %0t ns", $time);
			 $display("Next FSM State : %0d", state);
			 $display("FSM Index : %0d", index);
			 $display("FSM Done  : %b", done);
			 $display("BRAM A    : addr=%0d, en=%b, we=%b, dout=%0d", addr_a, en_a, we_a, dout_a);
			 $display("BRAM B    : addr=%0d, en=%b, we=%b, din=%0d", addr_b, en_b, we_b, din_b);
			 $display("=======================================================\n");
		end
	endtask
	
	task dump_memory;
		 integer i;
		 begin
			  $display("---- Source: mem[0..15] ----");
			  for (i = 0; i < 16; i = i + 1) begin
					$display("mem[%0d] = %h", i, uut.bram.bram0.ram[i]);
			  end

			  $display("---- Destination: mem[512..527] ----");
			  for (i = 0; i < 16; i = i + 1) begin
					$display("mem[%0d] = %h", 512+i, uut.bram.bram1.ram[i]);
			  end

		 end
	endtask

	 
	 

    initial begin
			$display("Initial State");
			dump_memory();
			print_state();
			apply_reset();
			$display("State After Reset");
			print_state();
			pulse_clk();
			pulse_clk();
			
			for(i = 0; i < 16; i = i + 1) begin
				$display("Copy Cycle %d", i);
				print_state();
				pulse_clk();
				print_state();
				pulse_clk();
				print_state();
				pulse_clk();
				dump_memory();
			end
        $stop;
    end

endmodule