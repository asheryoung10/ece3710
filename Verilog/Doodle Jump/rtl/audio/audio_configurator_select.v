`timescale 1ns/1ps

module audio_configurator_select (
    input wire systemClock,
    input wire reset,
    input wire configure,
    input wire [3:0] selectedCommand,
    output reg busy,
    output reg done,
    output wire encounteredError,
    inout wire i2c_clock,
    inout wire i2c_data
);

// Store the codec configuration commands that can be selected over MMIO.
reg [23:0] commands[16:0];
localparam commandCount = 1;

// Preload the configuration command table used by the I2C sequencer.
initial begin
    // Reset Address: 7'b0001111 Data: RESET
    commands[0] = {8'b00110100, 8'b00111110, 8'b00000000};
    // Left Line In Address: 7'b0000000, DATA: Simultaneous load, Mute, Max Volume
    commands[1] = {8'b00110100, 8'b00000001, 8'b10011111};
    // Left Headphone Out Address: 7'b0000001, DATA: Simultaneous load, Disable LZCEN, Volume Max
    commands[2] = {8'b00110100, 8'b00000011, 8'b00000000};
    // Analogue Audio Path Control Address: 7'b0000100, DATA: Select DAC and Mute Mic
    commands[3] = {8'b00110100, 8'b00001000, 8'b00010010};
    // Digital Audio Path Address: 7'b0000101, DATA: Disable soft mute
    commands[4] = {8'b00110100, 8'b00001010, 8'b00000000};
    // Power down control Address: 7'b0000110, DATA: Powerdown linein, mic, and adc
    commands[5] = {8'b00110100, 8'b00001100, 8'b00000111};
    // Digital Audio Interface Format Address: 7'b0000111, DATA: i2s MSB first left 1 justified
    commands[6] = {8'b00110100, 8'b00001110, 8'b00000010};
    // Sampling Control Address: 7'b0001000, DATA: defaults
    commands[7] = {8'b00110100, 8'b00010000, 8'b00000000};
    // Active Control Address: 7'b0001001, DATA: active
    commands[8] = {8'b00110100, 8'b00010010, 8'b00000001};
    // Power down control Address: 7'b0000110, DATA: Powerdown linein, mic, and adc
    commands[9] = {8'b00110100, 8'b00001100, 8'b10011111};
    // Left Headphone On/Off
    commands[10] = {8'b00110100, 8'b00000100, 8'b00111111};
    commands[11] = {8'b00110100, 8'b00000100, 8'b00000000};
    // Right Headphone On/Off
    commands[12] = {8'b00110100, 8'b00000110, 8'b00111111};
    commands[13] = {8'b00110100, 8'b00000110, 8'b00000000};

    // Sampling control presets.
    commands[14] = {8'b00110100, 8'b00010000, 8'b00000100};
    commands[15] = {8'b00110100, 8'b00010000, 8'b00001000};
    commands[16] = {8'b00110100, 8'b00010000, 8'b00001100};
end

// Divide the system clock down to the slower controller clock.
reg [7:0] clk_divider_count;
reg i2c_clk_reg;

// Generate the internal I2C controller clock from the faster system clock.
always @(posedge systemClock or posedge reset) begin
    if (reset) begin
        clk_divider_count <= 8'd0;
        i2c_clk_reg <= 1'b0;
    end else begin
        if (clk_divider_count >= 8'd124) begin
            clk_divider_count <= 8'd0;
            i2c_clk_reg <= ~i2c_clk_reg;
        end else begin
            clk_divider_count <= clk_divider_count + 1'b1;
        end
    end
end

// Expose the divided clock to the byte-level I2C controller.
wire controllerClock;
assign controllerClock = i2c_clk_reg;

// Hold the command bytes presented to the lower-level I2C controller.
reg sendMessage;
reg [7:0] addressByte;
reg [7:0] firstByte;
reg [7:0] secondByte;

// Observe the lower-level controller handshake signals.
wire controllerBusy;
wire controllerDone;

// Instantiate the byte-level I2C transmitter.
i2c_controller i2c_controller_instance (
    .clock(controllerClock),
    .reset(reset),
    .sendMessage(sendMessage),
    .addressByte(addressByte),
    .firstByte(firstByte),
    .secondByte(secondByte),
    .busy(controllerBusy),
    .done(controllerDone),
    .encounteredError(encounteredError),
    .i2c_clock(i2c_clock),
    .i2c_data(i2c_data)
);

localparam IDLE_STATE = 0;
localparam SEND_COMMAND_STATE = 1;

// Track the active command, FSM state, and byte-send progress.
reg [3:0] currentCommandIndex;
reg [2:0] currentState;
reg [2:0] currentStep;
reg [15:0] delay;

// Step through command setup, message launch, and controller completion.
always @(posedge controllerClock or posedge reset) begin
    if (reset) begin
        currentCommandIndex <= 0;
        currentState <= IDLE_STATE;
        busy <= 0;
        done <= 0;
    end else begin
        case (currentState)
            // Wait for a new configuration request from the audio subsystem.
            IDLE_STATE: begin
                if (configure) begin
                    busy <= 1;
                    currentState <= SEND_COMMAND_STATE;
                    currentCommandIndex <= selectedCommand;
                    currentStep <= 0;
                end else begin
                    busy <= 0;
                    done <= 0;
                end
            end
            // Load the selected command and launch the three-byte I2C transfer.
            SEND_COMMAND_STATE: begin
                case (currentStep)
                    0: begin
                        addressByte <= commands[currentCommandIndex][23:16];
                        firstByte <= commands[currentCommandIndex][15:8];
                        secondByte <= commands[currentCommandIndex][7:0];
                        currentStep <= 1;
                        currentCommandIndex <= currentCommandIndex + 1;
                    end
                    // Pulse the lower-level controller to begin transmission.
                    1: begin
                        sendMessage <= 1;
                        currentStep <= 2;
                    end
                    // Wait for the lower-level controller to acknowledge the start.
                    2: begin
                        sendMessage <= 0;
                        if (controllerBusy)
                            currentStep <= 3;
                    end
                    // Finish once the lower-level controller returns to idle.
                    3: begin
                        if (controllerBusy) begin
                            currentStep <= 3;
                        end else begin
                            busy <= 0;
                            done <= 1;
                            currentState <= IDLE_STATE;
                        end
                    end
                endcase
            end
        endcase
    end
end

endmodule
