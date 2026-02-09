`timescale 1ns/1ps

module tb_cpu;

    // Parameters
    localparam CLK_PERIOD = 10;

    // Inputs
    reg clock;
    reg reset;

    // Outputs
    wire [15:0] instructionRegisterContentsOutput;
    wire [15:0] programCounterContentsOutput;
    wire [15:0] programStateRegisterContentsOutput;
    wire [15:0] aluResultOutput;
    wire [4:0] aluFlagsOutput;

    wire [2:0] controlUnitState;
    wire [2:0] controlUnitNextState;

    // Instantiate the CPU
    cpu uut (
        .clock(clock),
        .reset(reset),
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
            pulse_clock(1);
            reset = 1'b0;
        end
    endtask

    // ==================================================
    // Task to print CPU state
    // ==================================================
    task print_cpu_state;
        begin
            $display(
    "Time=%0t | IR=%h | DecInst=%h| DecRsrc=%h | DecRdest=%h | DecodedImmediate=%h | DecodedOpcode=%h | PC=%h | PSR=%h | ALU select Imm=%h| ALURes=%h | ALUFlags=%b | CU_State=%0d | CU_Next=%0d | ALUOpcode=%0d | ALU_A=%h | ALU_B=%h | RegFile_WriteEn=%b | RegFile_WriteAddr=%0d | RegFile_WriteData=%h | RegFile_ReadA=%h | RegFile_ReadB=%h",
    $time,
    uut.instructionRegisterContentsOutput,
	 uut.instruction_decoder_instance.instruction,
	 uut.instruction_decoder_instance.registerAddressA,
	 uut.instruction_decoder_instance.registerAddressB,
	 uut.instruction_decoder_instance.immediate,
	 uut.instruction_decoder_instance.aluOpcode,
    uut.programCounterContentsOutput,
    uut.programStateRegisterContentsOutput,
	 uut.control_unit_instance.aluSelectImmediate,
    uut.aluResultOutput,
    uut.aluFlagsOutput,
    uut.controlUnitState,
    uut.controlUnitNextState,
    uut.instruction_decoder_instance.aluOpcode,
    uut.alu_instance.A,                     // ALU input A
    uut.alu_instance.B,                     // ALU input B
    uut.register_file_instance.writeEnable, // Register file write enable
    uut.register_file_instance.writeAddress, // Register file write address
    uut.register_file_instance.writeData,    // Register file write data
    uut.register_file_instance.contentsA,    // Register file read output A
    uut.register_file_instance.contentsB     // Register file read output B
);

        end
    endtask
	 
task dumpRegisterFile;
    integer i;
    begin
        $display("RegisterFile:");
        for (i = 0; i < 16; i = i + 1) begin
            $display("registerFile[%0d] = %h", i, uut.register_file_instance.registers[i]);
        end
        $display(""); // blank line for readability
    end
endtask

    // ==================================================
    // Testbench stimulus
    // ==================================================
    initial begin
        // Initialize
        clock = 0;
        reset = 0;

        // Apply reset
        apply_reset();
		  print_cpu_state();
        // Run for a few cycles and print state
        repeat (10) begin
		  
            pulse_clock(1);
				$display("FETCH");
            print_cpu_state();
				pulse_clock(1);
				$display("DECODE");
            print_cpu_state();
				pulse_clock(1);
				$display("EXECUTE");
            print_cpu_state();
				pulse_clock(1);
				$display("WRITEBACK");
            print_cpu_state();
				dumpRegisterFile();
        end

        $finish;
    end

endmodule
