module i2c_audio_setup (
    input wire fpga50MHzClock,  // 50 MHz FPGA clock input
    input wire sendConfig,      // Trigger to start sending config
    output reg i2c_clock,       // I2C clock output (100 kHz)
    inout wire i2c_data         // I2C data (SDA) - bi-directional
);

// Clock divider to generate 100 kHz clock from 50 MHz clock
reg [7:0] clock_divider; // For dividing 50 MHz to 100 kHz
reg clk_100kHz;

// Generate 100 kHz I2C clock from 50 MHz FPGA clock
always @(posedge fpga50MHzClock) begin
    if (clock_divider >= 250) begin
        clk_100kHz <= ~clk_100kHz;
        clock_divider <= 0;
    end else begin
        clock_divider <= clock_divider + 1;
    end
end

// I2C commands (16-bit format) - example commands, verify with your exact device register map
reg [15:0] commands [0:9];  // Array to store 10 commands
integer cmd_index;          // Command index pointer

// I2C state machine states
reg [2:0] state, next_state;  // Current and next states
reg [3:0] bit_index;          // Bit index for sending each bit in a command
reg [15:0] current_command;   // Current command being sent
reg ack_received;             // Acknowledge signal
reg send_next_bit;           // Flag to trigger the next bit

// State Encoding (for 2001 Verilog)
parameter IDLE = 3'b000, 
          START = 3'b001, 
          SEND_DATA = 3'b010, 
          ACK_WAIT = 3'b011, 
          STOP = 3'b100, 
          DONE = 3'b101;

// State machine logic (next state and state transitions)
always @(posedge clk_100kHz or posedge sendConfig) begin
    if (sendConfig) begin
        cmd_index <= 0;  // Reset command index
        state <= START;   // Start state when trigger is given
    end else begin
        state <= next_state;
    end
end

// State machine transitions
always @(*) begin
    case (state)
        IDLE:         next_state = sendConfig ? START : IDLE;
        START:        next_state = SEND_DATA;
        SEND_DATA:    next_state = (bit_index == 7) ? ACK_WAIT : SEND_DATA;
        ACK_WAIT:     next_state = ack_received ? (cmd_index < 9 ? SEND_DATA : STOP) : START;
        STOP:         next_state = DONE;
        DONE:         next_state = DONE;
        default:      next_state = IDLE;
    endcase
end

// Control signal for i2c_data
reg i2c_data_out;  // Control signal to drive the SDA line
assign i2c_data = (i2c_data_out) ? 1'b0 : 1'bz;  // Drive the SDA line when needed, otherwise put it in high-impedance (Z)

// I2C signal generation (sending each bit of the command)
always @(posedge clk_100kHz) begin
    case (state)
        START: begin
            // Start condition (SDA low, SCL high)
            i2c_data_out <= 1'b0;  // SDA low (start condition)
            i2c_clock <= 1'b1;  // Clock high during start
        end
        SEND_DATA: begin
            // Send one bit of the current command (MSB first)
            i2c_data_out <= current_command[15 - bit_index];  // Send MSB first
            i2c_clock <= ~i2c_clock;  // Toggle clock for each bit
            if (i2c_clock) begin
                bit_index <= bit_index + 1;  // Move to next bit after clock toggle
            end
        end
        ACK_WAIT: begin
            // Wait for ACK (ack_received is set when SDA is 0)
            ack_received <= (i2c_data == 1'b0);  // ACK is received when SDA is low
        end
        STOP: begin
            // Stop condition (SDA high, SCL high)
            i2c_data_out <= 1'b1;  // SDA high (stop condition)
            i2c_clock <= 1'b1;  // Clock high during stop
        end
        DONE: begin
            // End of I2C transaction
            i2c_clock <= 1'b0;
            i2c_data_out <= 1'b1;  // Leave SDA high (idle state)
        end
    endcase
end

// Load command and reset for sending the next command
always @(posedge clk_100kHz) begin
    if (state == START) begin
        current_command <= commands[cmd_index];  // Load the command to send
        bit_index <= 0;  // Reset bit index for the new command
        ack_received <= 0;  // Reset ack flag
        send_next_bit <= 1;  // Start sending bits
    end else if (state == ACK_WAIT && ack_received) begin
        // After ACK, move to next command
        cmd_index <= cmd_index + 1;  // Increment command index
    end
end

// Initialize I2C commands (example values, verify with actual register map)
initial begin
    commands[0] = 16'h0F00;  // Command 1: example
    commands[1] = 16'h0A01;  // Command 2: example
    commands[2] = 16'h0400;  // Command 3: example
    commands[3] = 16'h0C10;  // Command 4: example
    commands[4] = 16'h0800;  // Command 5: example
    commands[5] = 16'h1000;  // Command 6: example
    commands[6] = 16'h0401;  // Command 7: example
    commands[7] = 16'h0E00;  // Command 8: example
    commands[8] = 16'h0800;  // Command 9: example
    commands[9] = 16'h0000;  // Command 10: example
end

endmodule