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
            $display(
    "Time=%0t | IR=%h | DecInst=%h| DecRsrc=%h | DecRdest=%h | DecodedImmediate=%h | DecodedOpcode=%h | PC=%h | PSR=%b | ALU select Imm=%h| ALURes=%h | ALUFlags=%b | CU_State=%0d | CU_Next=%0d | ALUOpcode=%0d | ALU_A=%h | ALU_B=%h | RegFile_WriteEn=%b | RegFile_WriteAddr=%0d | RegFile_WriteData=%h | RegFile_ReadA=%h | RegFile_ReadB=%h | RegFileSel=%h | PSR=%h | NextPC: %h | WriteEnableMemory: %h | MemoryReadWriteAddress: %h | MemoryContents: %h| WriteContents: %h | firstRectX: %h | contentsShared: %h | contentsSharedCPU: %h | contentsSharedRect: %h | contentsSharedPlayer: %h| isRectAccess: %h| isPlayerAccess: %h | memorySelReadWrite: %h",
    $time,
    uut.cpu_instance.instructionRegisterContentsOutput,
	 uut.cpu_instance.instruction_decoder_instance.instruction,
	 uut.cpu_instance.instruction_decoder_instance.registerAddressA,
	 uut.cpu_instance.instruction_decoder_instance.registerAddressB,
	 uut.cpu_instance.instruction_decoder_instance.immediate,
	 uut.cpu_instance.instruction_decoder_instance.aluOpcode,
    uut.cpu_instance.programCounterContentsOutput,
    uut.cpu_instance.programStateRegisterContentsOutput,
	 uut.cpu_instance.control_unit_instance.aluSelectImmediate,
    uut.cpu_instance.aluResultOutput,
    uut.cpu_instance.aluFlagsOutput,
    uut.cpu_instance.controlUnitState,
    uut.cpu_instance.controlUnitNextState,
    uut.cpu_instance.instruction_decoder_instance.aluOpcode,
    uut.cpu_instance.alu_instance.A,                     // ALU input A
    uut.cpu_instance.alu_instance.B,                     // ALU input B
    uut.cpu_instance.register_file_instance.writeEnable, // Register file write enable
    uut.cpu_instance.register_file_instance.writeAddress, // Register file write address
    uut.cpu_instance.register_file_instance.writeData,    // Register file write data
    uut.cpu_instance.register_file_instance.contentsA,    // Register file read output A
    uut.cpu_instance.register_file_instance.contentsB,     // Register file read output B
    uut.cpu_instance.register_file_input_mux.select,
	 uut.cpu_instance.program_state_register.contents,
	 uut.cpu_instance.instruction_decoder_instance.nextProgramCounter,
	 uut.memoryWriteEnable,
	 uut.memoryReadWriteAddress,
	 uut.memoryContents,
	 uut.registerFileContentsB,
	 uut.memory_instance.rect_data[0],
	 uut.memory_instance.contents,
	 	 uut.memory_instance.contentsCPU,
	 uut.memory_instance.contentsRect,
	 uut.memory_instance.contentsPlayer,
	 uut.memory_instance.isRectAccess,
	 uut.memory_instance.isPlayerAccess,
	 	 uut.cpu_instance.memorySelectReadWriteAddress

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
        $display(""); // blank line for readability
    end
endtask

// ==================================================
// Task to print Control Unit State Name
// ==================================================
task print_state;
    begin
		  
        $write("Current State = ");

        case (controlUnitState)

            FETCH_INSTRUCTION_FROM_MEMORY:
                $write("FETCH_INSTRUCTION_FROM_MEMORY");

            LOAD_INSTRUCTION_INTO_INSTRUCTION_REGISTER:
                $write("LOAD_INSTRUCTION_INTO_INSTRUCTION_REGISTER");

            DECODE_INSTRUCTION:
                $write("DECODE_INSTRUCTION");

            EXECUTE_LOAD_INSTRUCTION:
                $write("EXECUTE_LOAD_INSTRUCTION");

            NOTHING_STATE:
                $write("NOTHING_STATE");
            default:
                $write("UNKNOWN_STATE (%0d)", controlUnitState);

        endcase

        $write("\t\t\t\t\t\tNext State = ");

        case (controlUnitNextState)

            FETCH_INSTRUCTION_FROM_MEMORY:
                $write("FETCH_INSTRUCTION_FROM_MEMORY");

            LOAD_INSTRUCTION_INTO_INSTRUCTION_REGISTER:
                $write("LOAD_INSTRUCTION_INTO_INSTRUCTION_REGISTER");

            DECODE_INSTRUCTION:
                $write("DECODE_INSTRUCTION");

            EXECUTE_LOAD_INSTRUCTION:
                $write("EXECUTE_LOAD_INSTRUCTION");

            NOTHING_STATE:
                $write("NOTHING_STATE");
            default:
                $write("UNKNOWN_STATE (%0d)", controlUnitNextState);

        endcase

        $display("");  // newline
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
				if(i == 120) running = 0;
		  
				if(controlUnitNextState == NOTHING_STATE) running = 0;
				if(controlUnitState == NOTHING_STATE) running = 0;
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
