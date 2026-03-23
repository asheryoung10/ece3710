`timescale 1ns/1ps

module tb_doodle;
    `include "cpu/states.vh"

    // Parameters
    localparam CLK_PERIOD = 10;
	 integer running;
    // Inputs
    reg clock;
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
            push_buttons[0] = 1'b0;
            pulse_clock(1);
            push_buttons[0] = 1'b1;
        end
    endtask

    // ==================================================
    // Task to print CPU state
    // ==================================================
    task print_cpu_state;
        begin
            $display(
    "Time=%0t | IR=%h | DecInst=%h| DecRsrc=%h | DecRdest=%h | DecodedImmediate=%h | DecodedOpcode=%h | PC=%h | PSR=%h | ALU select Imm=%h| ALURes=%h | ALUFlags=%b | CU_State=%0d | CU_Next=%0d | ALUOpcode=%0d | ALU_A=%h | ALU_B=%h | RegFile_WriteEn=%b | RegFile_WriteAddr=%0d | RegFile_WriteData=%h | RegFile_ReadA=%h | RegFile_ReadB=%h | RegFileSel=%h | PSR=%h | NextPC: %h",
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
	 uut.cpu_instance.instruction_decoder_instance.nextProgramCounter
);
        end
    endtask
	 
task dumpRegisterFile;
    begin
        $display("RegisterFile:");
        $display("registerFile[0] = %h",  uut.cpu_instance.register_file_instance.registers[0]);
        $display("registerFile[1] = %h",  uut.cpu_instance.register_file_instance.registers[1]);
        $display("registerFile[2] = %h",  uut.cpu_instance.register_file_instance.registers[2]);
        $display("registerFile[3] = %h",  uut.cpu_instance.register_file_instance.registers[3]);
        $display("registerFile[4] = %h",  uut.cpu_instance.register_file_instance.registers[4]);
        $display("registerFile[5] = %h",  uut.cpu_instance.register_file_instance.registers[5]);
        $display("registerFile[6] = %h",  uut.cpu_instance.register_file_instance.registers[6]);
        $display("registerFile[7] = %h",  uut.cpu_instance.register_file_instance.registers[7]);
        $display("registerFile[8] = %h",  uut.cpu_instance.register_file_instance.registers[8]);
        $display("registerFile[9] = %h",  uut.cpu_instance.register_file_instance.registers[9]);
        $display("registerFile[10] = %h", uut.cpu_instance.register_file_instance.registers[10]);
        $display("registerFile[11] = %h", uut.cpu_instance.register_file_instance.registers[11]);
        $display("registerFile[12] = %h", uut.cpu_instance.register_file_instance.registers[12]);
        $display("registerFile[13] = %h", uut.cpu_instance.register_file_instance.registers[13]);
        $display("registerFile[14] = %h", uut.cpu_instance.register_file_instance.registers[14]);
        $display("registerFile[15] = %h", uut.cpu_instance.register_file_instance.registers[15]);
        $display(""); // blank line for readability
    end
endtask

task dumpMemory;
    begin
        $display("Memory:");
        $display("memory[0] = %h",   uut.memory_instance.bram_inst.ram[0]);
        $display("memory[1] = %h",   uut.memory_instance.bram_inst.ram[1]);
        $display("memory[2] = %h",   uut.memory_instance.bram_inst.ram[2]);
        $display("memory[3] = %h",   uut.memory_instance.bram_inst.ram[3]);
        $display("memory[4] = %h",   uut.memory_instance.bram_inst.ram[4]);
        $display("memory[5] = %h",   uut.memory_instance.bram_inst.ram[5]);
        $display("memory[6] = %h",   uut.memory_instance.bram_inst.ram[6]);
        $display("memory[7] = %h",   uut.memory_instance.bram_inst.ram[7]);
        $display("memory[8] = %h",   uut.memory_instance.bram_inst.ram[8]);
        $display("memory[9] = %h",   uut.memory_instance.bram_inst.ram[9]);
        $display("memory[10] = %h",  uut.memory_instance.bram_inst.ram[10]);
        $display("memory[11] = %h",  uut.memory_instance.bram_inst.ram[11]);
        $display("memory[12] = %h",  uut.memory_instance.bram_inst.ram[12]);
        $display("memory[13] = %h",  uut.memory_instance.bram_inst.ram[13]);
        $display("memory[14] = %h",  uut.memory_instance.bram_inst.ram[14]);
        $display("memory[15] = %h",  uut.memory_instance.bram_inst.ram[15]);
        $display("memory[16] = %h",  uut.memory_instance.bram_inst.ram[16]);
        $display("memory[17] = %h",  uut.memory_instance.bram_inst.ram[17]);
        $display("memory[18] = %h",  uut.memory_instance.bram_inst.ram[18]);
        $display("memory[19] = %h",  uut.memory_instance.bram_inst.ram[19]);
        $display("memory[20] = %h",  uut.memory_instance.bram_inst.ram[20]);
        $display("memory[21] = %h",  uut.memory_instance.bram_inst.ram[21]);
        $display("memory[22] = %h",  uut.memory_instance.bram_inst.ram[22]);
        $display("memory[23] = %h",  uut.memory_instance.bram_inst.ram[23]);
        $display("memory[24] = %h",  uut.memory_instance.bram_inst.ram[24]);
        $display("memory[25] = %h",  uut.memory_instance.bram_inst.ram[25]);
        $display("memory[26] = %h",  uut.memory_instance.bram_inst.ram[26]);
        $display("memory[27] = %h",  uut.memory_instance.bram_inst.ram[27]);
        $display("memory[28] = %h",  uut.memory_instance.bram_inst.ram[28]);
        $display("memory[29] = %h",  uut.memory_instance.bram_inst.ram[29]);
        $display("memory[30] = %h",  uut.memory_instance.bram_inst.ram[30]);
        $display("memory[31] = %h",  uut.memory_instance.bram_inst.ram[31]);
        $display("memory[32] = %h",  uut.memory_instance.bram_inst.ram[32]);
        $display("memory[33] = %h",  uut.memory_instance.bram_inst.ram[33]);
        $display("memory[34] = %h",  uut.memory_instance.bram_inst.ram[34]);
        $display("memory[35] = %h",  uut.memory_instance.bram_inst.ram[35]);
        $display("memory[36] = %h",  uut.memory_instance.bram_inst.ram[36]);
        $display("memory[37] = %h",  uut.memory_instance.bram_inst.ram[37]);
        $display("memory[38] = %h",  uut.memory_instance.bram_inst.ram[38]);
        $display("memory[39] = %h",  uut.memory_instance.bram_inst.ram[39]);
        $display("memory[40] = %h",  uut.memory_instance.bram_inst.ram[40]);
        $display("memory[41] = %h",  uut.memory_instance.bram_inst.ram[41]);
        $display("memory[42] = %h",  uut.memory_instance.bram_inst.ram[42]);
        $display("memory[43] = %h",  uut.memory_instance.bram_inst.ram[43]);
        $display("memory[44] = %h",  uut.memory_instance.bram_inst.ram[44]);
        $display("memory[45] = %h",  uut.memory_instance.bram_inst.ram[45]);
        $display("memory[46] = %h",  uut.memory_instance.bram_inst.ram[46]);
        $display("memory[47] = %h",  uut.memory_instance.bram_inst.ram[47]);
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


    // ==================================================
    // Testbench stimulus
    // ==================================================
    initial begin
        // Initialize
        clock = 0;
		  
		  switches = 10'b0;
		  push_buttons = 4'b1111;

        // Apply reset
        apply_reset();
			running = 1;
        // Run for a few cycles and print state
        while (running != 0) begin
		  
		  
				if(controlUnitNextState == NOTHING_STATE) running = 0;
				if(controlUnitState == NOTHING_STATE) running = 0;
	
				
				
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
