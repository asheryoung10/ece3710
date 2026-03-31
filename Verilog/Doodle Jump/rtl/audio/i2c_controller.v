`timescale 1ns/1ps

module i2c_controller (
    input wire clock,
    input wire reset,
    input wire sendMessage,
    input wire [7:0] addressByte,
    input wire [7:0] firstByte,
    input wire [7:0] secondByte,
    output reg busy,
    output reg done,
    output reg encounteredError,
    inout wire i2c_clock,
    inout wire i2c_data
);

// Control the open-drain I2C lines by selectively pulling them low.
reg pullClockLow;
reg pullDataLow;

assign i2c_clock = pullClockLow ? 1'b0 : 1'bz;
assign i2c_data = pullDataLow ? 1'b0 : 1'bz;

// Enumerate the major phases of the I2C byte transmission FSM.
localparam IDLE_STATE = 0;
localparam START_STATE = 1;
localparam SEND_BIT_STATE = 2;
localparam ACK_STATE = 3;
localparam STOP_STATE = 4;

// Buffer the outgoing bytes and track the current transfer position.
reg [7:0] savedAddressByte;
reg [7:0] savedFirstByte;
reg [7:0] savedSecondByte;
reg [7:0] currentByte;

reg [3:0] currentState;
reg [3:0] currentStep;
reg [3:0] currentBitIndex;
reg [2:0] currentByteIndex;

// Sequence the start, byte, ACK, and stop phases of each I2C write.
always @(posedge clock or posedge reset) begin
    if (reset) begin
        currentState <= IDLE_STATE;
        encounteredError <= 0;
        busy <= 0;
        done <= 0;
    end else begin
        case (currentState)
            // Wait for a new three-byte transfer request from the caller.
            IDLE_STATE: begin
                if (sendMessage) begin
                    currentState <= START_STATE;
                    currentStep <= 0;
                    savedAddressByte <= addressByte;
                    savedFirstByte <= firstByte;
                    savedSecondByte <= secondByte;
                    busy <= 1;
                    currentByteIndex <= 0;
                end else begin
                    busy <= 0;
                    done <= 0;
                    pullClockLow <= 0;
                    pullDataLow <= 0;
                end
            end
            // Issue the I2C start condition before shifting out the address byte.
            START_STATE: begin
                case (currentStep)
                    0: begin
                        if (i2c_clock) begin
                            pullDataLow <= 1;
                            currentStep <= 1;
                        end else begin
                            pullClockLow <= 0;
                        end
                    end
                    1: begin
                        pullClockLow <= 1;
                        currentBitIndex <= 7;
                        currentState <= SEND_BIT_STATE;
                        currentStep <= 0;
                        currentByte <= savedAddressByte;
                    end
                endcase
            end
            // Shift the current byte out one bit at a time on the data line.
            SEND_BIT_STATE: begin
                case (currentStep)
                    0: begin
                        pullDataLow <= ~currentByte[currentBitIndex];
                        currentStep <= 1;
                    end
                    1: begin
                        pullClockLow <= 0;
                        currentStep <= 2;
                    end
                    2: begin
                        if (i2c_clock) begin
                            pullClockLow <= 1;
                            if (currentBitIndex == 0) begin
                                currentStep <= 0;
                                currentState <= ACK_STATE;
                                currentByteIndex <= currentByteIndex + 1;
                            end else begin
                                currentBitIndex <= currentBitIndex - 1;
                                currentStep <= 0;
                            end
                        end else begin
                            pullClockLow <= 0;
                        end
                    end
                endcase
            end
            // Release the data line and sample the slave ACK bit.
            ACK_STATE: begin
                case (currentStep)
                    0: begin
                        pullDataLow <= 0;
                        currentStep <= 1;
                    end
                    1: begin
                        pullClockLow <= 1;
                        currentStep <= 2;
                    end
                    2: begin
                        if (i2c_clock) begin
                            if (i2c_data)
                                encounteredError <= 1;
                            currentBitIndex <= 7;
                            currentStep <= 0;
                            pullClockLow <= 1;
                            case (currentByteIndex)
                                1: begin
                                    currentByte <= savedFirstByte;
                                    currentState <= SEND_BIT_STATE;
                                end
                                2: begin
                                    currentByte <= savedSecondByte;
                                    currentState <= SEND_BIT_STATE;
                                end
                                3: begin
                                    currentState <= STOP_STATE;
                                end
                            endcase
                        end else begin
                            pullClockLow <= 0;
                        end
                    end
                endcase
            end
            // Release the lines to complete the I2C stop condition.
            STOP_STATE: begin
                case (currentStep)
                    0: begin
                        pullDataLow <= 1;
                        currentStep <= 1;
                    end
                    1: begin
                        if (i2c_clock) begin
                            pullDataLow <= 0;
                            done <= 1;
                            busy <= 0;
                            currentState <= IDLE_STATE;
                        end else begin
                            pullClockLow <= 0;
                        end
                    end
                endcase
            end
        endcase
    end
end

endmodule
