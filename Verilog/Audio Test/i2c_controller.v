module i2c_controller (
    input clk,               // System clock
    input rst,               // Reset signal
    input [7:0] data_in,     // Data to send for I2C write
    input start,             // Start signal for I2C transmission
    output reg done,         // I2C operation done signal
    output scl,              // I2C clock
    inout sda                // I2C data (bidirectional)
);

    // Define state values (state machine)
    reg [2:0] state, next_state;

    localparam IDLE = 3'b000;
    localparam START = 3'b001;
    localparam SEND_ADDRESS = 3'b010;
    localparam SEND_DATA = 3'b011;
    localparam DONE = 3'b100;

    reg [7:0] shift_reg;      // Data to send
    reg sda_out;              // I2C data output
    reg sda_dir;              // I2C data direction (output or input)
    reg scl_reg;              // I2C clock output
    reg [3:0] bit_count;      // Bit counter for sending data

    assign scl = scl_reg;     // I2C clock output

    // Combine state machine and signal assignments in a single always block
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            scl_reg <= 1;
            done <= 0;
            shift_reg <= 8'd0;
            bit_count <= 4'd0;
            sda_out <= 1;  // Default to high impedance for SDA (input)
            sda_dir <= 0;   // SDA as input
        end else begin
            state <= next_state;
            
            // Default to IDLE state and high impedance
            case (state)
                IDLE: begin
                    scl_reg <= 1;
                    sda_dir <= 0;  // Set SDA as input
                    done <= 0;
                    sda_out <= 1;  // Release SDA line (high impedance)
                end
                START: begin
                    scl_reg <= 0;
                    sda_out <= 0;  // Start condition (SDA goes low)
                    sda_dir <= 1;  // Set SDA as output
                    done <= 0;
                end
                SEND_ADDRESS: begin
                    scl_reg <= 1;
                    shift_reg <= {data_in, 1'b0};  // Address and Write flag (LSB is write)
                    sda_out <= shift_reg[7];  // Send MSB of address
                    sda_dir <= 1;  // Set SDA as output
                    done <= 0;
                end
                SEND_DATA: begin
                    scl_reg <= 0;
                    sda_out <= shift_reg[7];  // Send bit by bit
                    shift_reg <= shift_reg << 1;  // Shift to next bit
                    bit_count <= bit_count + 1;
                    done <= 0;
                end
                DONE: begin
                    scl_reg <= 1;
                    done <= 1;  // Set done once transfer is complete
                end
                default: begin
                    scl_reg <= 1;
                    sda_out <= 1;
                    sda_dir <= 0;  // Set SDA as input in case of an error
                    done <= 0;
                end
            endcase
        end
    end

    // Transition between states
    always @(*) begin
        case (state)
            IDLE: next_state = (start) ? START : IDLE;
            START: next_state = SEND_ADDRESS;
            SEND_ADDRESS: next_state = SEND_DATA;
            SEND_DATA: next_state = (bit_count == 4'd7) ? DONE : SEND_DATA;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // SDA bidirectional control: Drive SDA line when output mode, otherwise high impedance
    assign sda = (sda_dir) ? sda_out : 1'bz;

endmodule