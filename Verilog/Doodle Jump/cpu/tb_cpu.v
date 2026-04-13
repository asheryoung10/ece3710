`timescale 1ns/1ps

module tb_cpu;
    `include "states.vh"

    localparam CLK_PERIOD = 10;
    localparam MAX_CYCLES = 200000;
    localparam [7:0] LOAD_OPCODE = 8'h40;

    reg clock = 0;
    reg reset = 0;
    reg p1Left = 0, p1Right = 0, p1Up = 0, p1Down = 0;
    reg p2Left = 0, p2Right = 0, p2Up = 0, p2Down = 0;
    reg p3Left = 0, p3Right = 0, p3Up = 0, p3Down = 0;
    reg p4Left = 0, p4Right = 0, p4Up = 0, p4Down = 0;
    reg vsync = 0;

    wire [15:0] instructionRegisterContentsOutput;
    wire [15:0] programCounterContentsOutput;
    wire [15:0] programStateRegisterContentsOutput;
    wire [15:0] aluResultOutput;
    wire [4:0] aluFlagsOutput;
    wire [2:0] controlUnitState;
    wire [2:0] controlUnitNextState;
    wire memoryWriteEnable;
    wire [15:0] memoryReadWriteAddress;
    wire [15:0] registerFileContentsB;
    wire [15:0] memoryContents;
    wire [15:0] R3;
    wire [15:0] R4;

    integer cycleCounter = 0;
    integer instructionCounter = 0;
    integer traceFd;
    reg [1023:0] tracePath;
    reg [1023:0] programPath;
    reg pendingLoad = 0;
    reg [15:0] pendingLoadPc = 0;
    reg [15:0] pendingLoadInstruction = 0;
    reg [7:0] pendingLoadOpcode = 0;
    reg [3:0] pendingLoadRd = 0;
    reg [3:0] pendingLoadRs = 0;
    reg signed [15:0] pendingLoadImm = 0;
    reg [15:0] prevPc = 0;
    reg hasPrevPc = 0;

    cpu uut (
        .clock(clock),
        .reset(reset),
        .instructionRegisterContentsOutput(instructionRegisterContentsOutput),
        .programCounterContentsOutput(programCounterContentsOutput),
        .programStateRegisterContentsOutput(programStateRegisterContentsOutput),
        .aluResultOutput(aluResultOutput),
        .aluFlagsOutput(aluFlagsOutput),
        .controlUnitState(controlUnitState),
        .controlUnitNextState(controlUnitNextState),
        .memoryWriteEnable(memoryWriteEnable),
        .memoryReadWriteAddress(memoryReadWriteAddress),
        .registerFileContentsB(registerFileContentsB),
        .memoryContents(memoryContents),
        .p1Left(p1Left), .p1Right(p1Right), .p1Up(p1Up), .p1Down(p1Down),
        .p2Left(p2Left), .p2Right(p2Right), .p2Up(p2Up), .p2Down(p2Down),
        .p3Left(p3Left), .p3Right(p3Right), .p3Up(p3Up), .p3Down(p3Down),
        .p4Left(p4Left), .p4Right(p4Right), .p4Up(p4Up), .p4Down(p4Down),
        .vsync(vsync),
        .R3(R3),
        .R4(R4)
    );

    sharedMemory memory_instance (
        .clock(clock),
        .reset(reset),
        .writeEnable(memoryWriteEnable),
        .writeData(registerFileContentsB),
        .readWriteAddress(memoryReadWriteAddress),
        .contents(memoryContents),
        .vgaX(10'd0),
        .vgaY(10'd0),
        .r(),
        .g(),
        .b(),
        .p1X(), .p1Y(), .p1AnimationIndex(), .p1HighlightColor(),
        .p2X(), .p2Y(), .p2AnimationIndex(), .p2HighlightColor(),
        .p3X(), .p3Y(), .p3AnimationIndex(), .p3HighlightColor(),
        .p4X(), .p4Y(), .p4AnimationIndex(), .p4HighlightColor(),
        .backgroundOffsetX(), .backgroundOffsetY(), .audioPitchIndex()
    );

    function automatic signed [15:0] signext8(input [7:0] value);
        begin
            signext8 = $signed({{8{value[7]}}, value});
        end
    endfunction

    task automatic emit_trace_row(
        input [15:0] pcBefore,
        input [15:0] instructionWord,
        input [7:0] opcodeCombined,
        input [3:0] rd,
        input [3:0] rs,
        input signed [15:0] immediateSigned,
        input regWrite,
        input [3:0] regWriteAddr,
        input [15:0] regWriteValue,
        input memWrite,
        input [15:0] memWriteAddr,
        input [15:0] memWriteValue
    );
        begin
            $fwrite(
                traceFd,
                "%0d,0x%04h,0x%04h,0x%02h,0x%1h,0x%1h,%0d,%0d,%0d,%0d,%0d,%0d,%0d,C=%0d;L=%0d;F=%0d;Z=%0d;N=%0d\n",
                cycleCounter,
                pcBefore,
                instructionWord,
                opcodeCombined,
                rd,
                rs,
                immediateSigned,
                regWrite ? 1 : 0,
                regWrite ? regWriteAddr : -1,
                regWrite ? regWriteValue : -1,
                memWrite ? 1 : 0,
                memWrite ? memWriteAddr : -1,
                memWrite ? memWriteValue : -1,
                programStateRegisterContentsOutput[0],
                programStateRegisterContentsOutput[1],
                programStateRegisterContentsOutput[2],
                programStateRegisterContentsOutput[3],
                programStateRegisterContentsOutput[4]
            );
        end
    endtask

    always #(CLK_PERIOD/2) clock = ~clock;

    initial begin
        if (!$value$plusargs("PROGRAM=%s", programPath)) begin
            programPath = "New Assembler/assembly/instructions.bin";
        end
        if (!$value$plusargs("TRACE=%s", tracePath)) begin
            tracePath = "build/hdl_trace.csv";
        end

        // Load test program after memory init.
        #1;
        $readmemh(programPath, memory_instance.cpu_memory_instance.ram);

        traceFd = $fopen(tracePath, "w");
        if (traceFd == 0) begin
            $display("ERROR: Could not open HDL trace file: %0s", tracePath);
            $finish;
        end
        $fwrite(traceFd, "cycle,pc,instruction,opcodeCombined,rd,rs,immSigned,regWrite,regWriteAddr,regWriteValue,memWrite,memWriteAddr,memWriteValue,flags\n");

        reset = 1'b1;
        repeat (2) @(posedge clock);
        reset = 1'b0;

        while (cycleCounter < MAX_CYCLES) begin
            @(posedge clock);
            cycleCounter = cycleCounter + 1;
        end

        $display("ERROR: Reached MAX_CYCLES without halting.");
        $fclose(traceFd);
        $finish;
    end

    always @(posedge clock) begin
        if (reset) begin
            pendingLoad <= 1'b0;
            instructionCounter <= 0;
            hasPrevPc <= 0;
        end else begin
            if (hasPrevPc && (controlUnitState == DECODE_INSTRUCTION || controlUnitState == EXECUTE_LOAD_INSTRUCTION)) begin
                // Sanity assert: instruction retirement should either advance or branch.
                if (programCounterContentsOutput === 16'hxxxx) begin
                    $display("ASSERTION FAILED: PC is X at cycle %0d", cycleCounter);
                    $fclose(traceFd);
                    $finish;
                end
            end
            prevPc <= programCounterContentsOutput;
            hasPrevPc <= 1'b1;

            if (controlUnitState == DECODE_INSTRUCTION) begin
                if (uut.instruction_decoder_instance.aluOpcode == LOAD_OPCODE) begin
                    pendingLoad <= 1'b1;
                    pendingLoadPc <= programCounterContentsOutput;
                    pendingLoadInstruction <= instructionRegisterContentsOutput;
                    pendingLoadOpcode <= uut.instruction_decoder_instance.aluOpcode;
                    pendingLoadRd <= uut.instruction_decoder_instance.registerAddressB;
                    pendingLoadRs <= uut.instruction_decoder_instance.registerAddressA;
                    pendingLoadImm <= signext8(instructionRegisterContentsOutput[7:0]);
                end else begin
                    emit_trace_row(
                        programCounterContentsOutput,
                        instructionRegisterContentsOutput,
                        uut.instruction_decoder_instance.aluOpcode,
                        uut.instruction_decoder_instance.registerAddressB,
                        uut.instruction_decoder_instance.registerAddressA,
                        signext8(instructionRegisterContentsOutput[7:0]),
                        uut.register_file_instance.writeEnable,
                        uut.register_file_instance.writeAddress,
                        uut.register_file_instance.writeData,
                        memoryWriteEnable,
                        memoryReadWriteAddress,
                        registerFileContentsB
                    );
                    instructionCounter <= instructionCounter + 1;
                end

                if (uut.register_file_instance.writeEnable && (uut.register_file_instance.writeAddress === 4'bxxxx)) begin
                    $display("ASSERTION FAILED: register write address is X at cycle %0d", cycleCounter);
                    $fclose(traceFd);
                    $finish;
                end
                if (memoryWriteEnable && (memoryReadWriteAddress === 16'hxxxx)) begin
                    $display("ASSERTION FAILED: memory write address is X at cycle %0d", cycleCounter);
                    $fclose(traceFd);
                    $finish;
                end
            end

            if (controlUnitState == EXECUTE_LOAD_INSTRUCTION && pendingLoad) begin
                emit_trace_row(
                    pendingLoadPc,
                    pendingLoadInstruction,
                    pendingLoadOpcode,
                    pendingLoadRd,
                    pendingLoadRs,
                    pendingLoadImm,
                    uut.register_file_instance.writeEnable,
                    uut.register_file_instance.writeAddress,
                    uut.register_file_instance.writeData,
                    memoryWriteEnable,
                    memoryReadWriteAddress,
                    registerFileContentsB
                );
                pendingLoad <= 1'b0;
                instructionCounter <= instructionCounter + 1;
            end
        end
    end

endmodule
