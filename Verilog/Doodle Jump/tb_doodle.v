`timescale 1ns/1ps

module tb_doodle;
    localparam FETCH_INSTRUCTION_FROM_MEMORY     = 3'd1;
localparam LOAD_INSTRUCTION_INTO_INSTRUCTION_REGISTER     = 3'd2;
localparam DECODE_INSTRUCTION = 3'd3;
localparam EXECUTE_LOAD_INSTRUCTION = 3'd5;
localparam NOTHING_STATE = 3'd6;
localparam MOVE_STATE = 3'd7;


    // Parameters
    localparam CLK_PERIOD = 10;
	 integer running;
    // Inputs
    reg clock;
    reg reset;
	 
	 reg [9:0] switches;
	 reg [3:0] push_buttons;

    // Outputs
    wire [15:0] instructionRegisterContentsOutput;
    wire [15:0] programCounterContentsOutput;
    wire [15:0] programStateRegisterContentsOutput;
    wire [15:0] aluResultOutput;
    wire [4:0] aluFlagsOutput;

    wire [2:0] controlUnitState;
    wire [2:0] controlUnitNextState;

    // Instantiate the CPU

	  doodle_jump uut(
		.systemClock50MHz(clock),
		.switches(switches),
		.push_buttons(push_buttons),
	        //.reset(reset),
		.instructionRegisterContentsOutput(instructionRegisterContentsOutput),
		.programCounterContentsOutput(programCounterContentsOutput),
		.programStateRegisterContentsOutput(programStateRegisterContentsOutput),
      .aluResultOutput(aluResultOutput),
      .aluFlagsOutput(aluFlagsOutput),
      .controlUnitState(controlUnitState),
      .controlUnitNextState(controlUnitNextState)
	
);

    // ==================================================
    // Clock task
    // ==================================================
    task pulse_clock;
        input integer num_cycles;
        integer i;
        begin
            for (i = 0; i < num_cycles; i = i + 1) begin
                clock = 1'b0;
                # (CLK_PERIOD/2);
                clock = 1'b1;
                # (CLK_PERIOD/2);
            end
        end
    endtask

    // ==================================================
    // Reset task
    // ==================================================
    task apply_reset;
        begin
            reset = 1'b1;
				push_buttons = 4'b0000;
            pulse_clock(1);
				push_buttons = 4'b1111;
            reset = 1'b0;
        end
    endtask

    // ==================================================
    // Task to print CPU state
    // ==================================================
task print_cpu_state;
    begin
	 $display("\nPC: %d, IR %h",
	 uut.cpu_instance.programCounterContents,
	 uut.cpu_instance.instructionRegisterContents
	 );
	 $display("\t Register File: WE: %d, WA: %d, RAA: %d, RAB: %d, A: %d, B: %d",
	 uut.cpu_instance.register_file_instance.writeEnable,
	 uut.cpu_instance.register_file_instance.writeAddress,
	 uut.cpu_instance.register_file_instance.readAddressA,
	 uut.cpu_instance.register_file_instance.readAddressB,
	 uut.cpu_instance.register_file_instance.contentsA,
	 uut.cpu_instance.register_file_instance.contentsB
	 );
	 $display("\t Shared Memory: WE: %d, WD: %d, RWA: %d, Contents: %d, cCPU: %d, cPlay: %d, cRect: %d, aCPU: %d, aPlay: %d, aRect: %d",
	 uut.memory_instance.writeEnable,
	 uut.memory_instance.writeData,
	 uut.memory_instance.readWriteAddress,
	 uut.memory_instance.contents,
	 uut.memory_instance.contentsCPU,
	 uut.memory_instance.contentsPlayer,
	 uut.memory_instance.contentsRect,
	 uut.memory_instance.isMemoryAccess,
	 uut.memory_instance.isPlayerAccess,
	 uut.memory_instance.isRectAccess
	 );

	end
endtask
	 
task dumpRegisterFile;
    integer i;
    begin
        $display("RegisterFile:");
        for (i = 0; i < 16; i = i + 1) begin
            $display("registerFile[%0d] = %h", i, uut.cpu_instance.register_file_instance.registers[i]);
        end
        $display(""); // blank line for readability
    end
endtask

task dumpMemory;
    integer i;
    begin
        $display("Memory:");
        for (i = 0; i < 48; i = i + 1) begin
            $display("memory[%0d] = %h", i, uut.memory_instance.cpu_memory_instance.ram[i]);
        end
		  $display("%0d", uut.memory_instance.cpu_memory_instance.ram[1025]);
        $display(""); // blank line for readability
    end
endtask

// ==================================================
// Task to print Control Unit State Name
// ==================================================
task print_state;
    begin
		  
        $write("Current State: ");

        case (controlUnitState)

            FETCH_INSTRUCTION_FROM_MEMORY:
                $write("Fetch Instruction");

            LOAD_INSTRUCTION_INTO_INSTRUCTION_REGISTER:
                $write("Load Instruction");

            DECODE_INSTRUCTION:
                $write("Decode Instruction");

            EXECUTE_LOAD_INSTRUCTION:
                $write("EXECUTE_LOAD_INSTRUCTION");

            NOTHING_STATE:
                $write("NOTHING_STATE");
            default:
                $write("UNKNOWN_STATE (%0d)", controlUnitState);

        endcase

        $write(" Next State: ");

        case (controlUnitNextState)

            FETCH_INSTRUCTION_FROM_MEMORY:
                $write("Fetch Instruction");

            LOAD_INSTRUCTION_INTO_INSTRUCTION_REGISTER:
                $write("Load Instruction");

            DECODE_INSTRUCTION:
                $write("Decode Instruction");

            EXECUTE_LOAD_INSTRUCTION:
                $write("EXECUTE_LOAD_INSTRUCTION");

            NOTHING_STATE:
                $write("NOTHING_STATE");
            default:
                $write("UNKNOWN_STATE (%0d)", controlUnitNextState);

        endcase

    end
endtask

integer i = 0;
    // ==================================================
    // Testbench stimulus
    // ==================================================
    initial begin
        // Initialize
        clock = 0;
        reset = 0;
		  
		  switches = 10'b0;
		  

        // Apply reset
        apply_reset();
		  push_buttons = 4'b1101;
			running = 1;
        // Run for a few cycles and print state
		  
        while (running != 0) begin
				i = i + 1;
				if(i == 190) running = 0;
		  
				if(controlUnitNextState == NOTHING_STATE) begin
			$display("stoped due to nothing state");
			running = 0;
			end
				if(controlUnitState == NOTHING_STATE) begin
			$display("stoped due to nothing state");
			running = 0;
			end
			   if(uut.memory_instance.cpu_memory_instance.ram[0] === 16'hxxxx) running = 0;

				
				
			   if(controlUnitState == FETCH_INSTRUCTION_FROM_MEMORY) begin
					$display("\n\n\n");
					$display("CONTENTS AFTER PREVIOUS INSTRUCTION");
					dumpRegisterFile();
					dumpMemory();
				end
				print_state();
				print_cpu_state();
				
				pulse_clock(1);
				
            
        end

        $finish;
    end

endmodule
