module i2c_audio_setup (
    input wire fpga50MHzClock,
    input wire reset,
    input wire start,
    input wire [7:0] address,
    input wire [7:0] firstByte,
    input wire [7:0] secondByte,
    output reg busy,
    output reg done,
    output reg error,
    inout wire i2c_clock,
    inout wire i2c_data
);

reg [7:0] clock_divider;  // For dividing 50 MHz to 100 kHz
reg i2c_tick;

// Generate 100 kHz I2C clock from 50 MHz FPGA clock
always @(posedge fpga50MHzClock or posedge reset) begin
    if (reset) begin
        i2c_tick <= 0;
        clock_divider <= 0;
    end else if (clock_divider >= 250) begin
        i2c_tick <= 1;
        clock_divider <= 0;
    end else begin
        i2c_tick <= 0;
        clock_divider <= clock_divider + 1;
    end
end

localparam IDLE = 0;
localparam START = 1;
localparam SEND_BIT = 2;
localparam ACK_STATE = 3;
localparam STOP = 4;

reg driveClockLow;
reg driveDataLow;
reg [2:0] state;
reg [2:0] subStep;
reg [7:0] dataByte;
reg [3:0] bitIndex;
reg [2:0] ackNumber;
reg [7:0] savedAddress;
reg [7:0] savedFirstByte;
reg [7:0] savedSecondByte;
wire i2c_clock_value;
wire i2c_data_value;
assign i2c_clock_value = (i2c_clock) ? 1 : 0;
assign i2c_data_value = (i2c_data) ? 1 : 0;

// Main FSM for I2C Communication
always @(posedge fpga50MHzClock or posedge reset) begin
    if (reset) begin
        driveClockLow <= 0;
        driveDataLow <= 0;
        busy <= 0;
        done <= 0;
        error <= 0;
        subStep <= 0;
        state <= IDLE;
        bitIndex <= 0;
    //end else if (i2c_tick) begii2c_data_valuen
	 end else begin
        case (state)
            IDLE: begin
                driveClockLow <= 0;
                driveDataLow <= 0;
                busy <= 0;
                done <= 0;
                error <= 0;
                subStep <= 0;
					 ackNumber <= 0;
                if (start) begin
						  savedAddress <= address;
						  savedFirstByte <= firstByte;
						  savedSecondByte <= secondByte;
                    state <= START;
                    busy <= 1;
                end
            end
            
            START: begin
                case (subStep) 
                    0: begin
                        if (i2c_clock_value) begin
									driveDataLow <= 1; // Start condition, drive data low
                           subStep <= 1;
                            
                        end else begin
                            subStep <= 0; // Wait until the clock is high
                        end
                    end
                    1: begin
                        driveClockLow <= 1; // Drive clock low
                        state <= SEND_BIT; // Transition to sending the address
                        dataByte <= savedAddress; // Load address to send
                        bitIndex <= 7; // Address has 8 bits
                        subStep <= 0;
                    end
                endcase
            end

            SEND_BIT: begin
					case (subStep) 
						0: begin
							driveDataLow <= ~dataByte[bitIndex];
							subStep <= 1;
						end
						1: begin
							driveClockLow = 0; // Let clock go high
							subStep <= 2;
						end
						2: begin
							if(i2c_clock_value)
								subStep <= 3;
							else
								subStep <= 2; // Wait for slave to finish stretching clock
						end
						3: begin
							driveClockLow <= 1; // Drive clock low;
							bitIndex <= bitIndex - 1;
							subStep <= 0;
							if(bitIndex == 0)
								state <= ACK_STATE;
							else
								state <= SEND_BIT;
						
						end
					endcase
            end

            ACK_STATE: begin
                case (subStep) 
						0: begin
							driveClockLow <= 0; // Let clock go high;
							subStep <= 1;
						end
						1: begin
							if(i2c_clock_value) begin
								//if(i2c_data_value) begin
								if(i2c_data_value == 0 || i2c_data_value == 1) begin
									ackNumber <= ackNumber + 1;
									case(ackNumber) 
										0: begin
											dataByte <= savedFirstByte;
											driveClockLow <= 1;
											state <= SEND_BIT;
											bitIndex <= 7;
											subStep <= 0;
										end
										1: begin 
											dataByte <= savedSecondByte;
											driveClockLow <= 1;
											state <= SEND_BIT;
											bitIndex <= 7;
											subStep <= 0;
										end
										2: begin
											state <= STOP; // We are done;
										end
										
									endcase
								end else begin
									error <= 1; // Failed ACK
									state <= STOP;
								end
							end else begin
								subStep <= 1; // Wait untill slave finishes stretching clock.
							end
						end
					 endcase
            end
            
            STOP: begin
                // Issue Stop condition
                driveDataLow <= 0; // Drive data low
                driveClockLow <= 0;
                subStep <= 0;
                state <= IDLE; // Go back to IDLE after stop
                done <= 1; // Operation done
            end

        endcase
    end
end

// Control the I2C clock line and data line
assign i2c_clock = (driveClockLow) ? 1'b0 : 1'bz; // Clock low when driving
assign i2c_data = (driveDataLow) ? 1'b0 : 1'bz;   // Data low when driving

endmodule