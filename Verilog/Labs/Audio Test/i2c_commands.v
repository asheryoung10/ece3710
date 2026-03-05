module i2c_commands (
    input wire fpga50MHzClock,
    input wire reset,
    input wire start,
    output reg busy,
    output reg done,
    output reg error,
    inout wire i2c_clock,
    inout wire i2c_data,
	 output wire [7:0] debugAddress,
	 output wire [7:0] debugFirstByte,
	 output wire [7:0] debugSecondByte
);

    // Declare the signals for i2c_audio_setup instantiation
    reg [7:0] address;
    reg [7:0] firstByte;
    reg [7:0] secondByte;
	 assign debugAddress = address;
	 assign debugFirstByte = firstByte;
	 assign debugSecondByte = secondByte;
    wire i2c_busy;
    wire i2c_done;
    wire i2c_error;

    // Define the 6 hardcoded commands (address, firstByte, secondByte)
    reg [23:0] commands[5:0]; // 6 commands, each having 3 bytes (24 bits)

    initial begin
        // Hardcoding 6 commands (address, firstByte, secondByte)
        commands[0] = {8'h11, 8'h01, 8'h02}; // Command 1
        commands[1] = {8'h11, 8'h03, 8'h04}; // Command 2
        commands[2] = {8'h12, 8'h05, 8'h06}; // Command 3
        commands[3] = {8'h13, 8'h07, 8'h08}; // Command 4
        commands[4] = {8'h14, 8'h09, 8'h0A}; // Command 5
        commands[5] = {8'h15, 8'h0B, 8'h0C}; // Command 6
    end

    // State machine states for command processing
    reg [2:0] command_index; // Index to track which command is being sent
    reg [1:0] state; // Simple state machine for controlling the command sequence
    localparam IDLE = 2'b00, SEND_COMMAND = 2'b01, DONE = 2'b10;
	 reg i2cStart;
    // Instantiate i2c_audio_setup for communication
    i2c_audio_setup i2c_instance (
        .fpga50MHzClock(fpga50MHzClock),
        .reset(reset),
        .start(i2cStart),
        .address(address),
        .firstByte(firstByte),
        .secondByte(secondByte),
        .busy(i2c_busy),
        .done(i2c_done),
        .error(i2c_error),
        .i2c_clock(i2c_clock),
        .i2c_data(i2c_data)
    );

    // Process commands and control state machine
    always @(posedge fpga50MHzClock or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            command_index <= 0;
            busy <= 0;
            done <= 0;
            error <= 0;
				i2cStart <= 0;
        end else begin
            case(state)
                IDLE: begin
						  command_index <= 0;
                    if (start) begin
                        state <= SEND_COMMAND;
                        busy <= 1;
                        address <= commands[command_index][23:16];  // Address byte
                        firstByte <= commands[command_index][15:8]; // First data byte
                        secondByte <= commands[command_index][7:0]; // Second data byte
								i2cStart <= 1;
                    end
                end

                SEND_COMMAND: begin
                    if (~i2c_busy && ~i2cStart) begin
                        if (command_index < 5) begin
                            command_index <= command_index + 1; // Move to next command
                            address <= commands[command_index][23:16];  // Address byte
                            firstByte <= commands[command_index][15:8]; // First data byte
                            secondByte <= commands[command_index][7:0]; // Second data byte
									 i2cStart <= 1;
                        end else begin
                            state <= DONE; // All commands sent
                        end
                    end else if (i2c_error) begin
                        error <= 1; // If there is an error
                        state <= DONE;
                    end else begin
								i2cStart = 0;
						  end
                end

                DONE: begin
                    busy <= 0;
                    done <= 1;
						  state <= IDLE;
                end

            endcase
        end
    end

endmodule