module tb_i2c_audio_setup;

    // Testbench signals
    reg fpga50MHzClock;
    reg reset;
    reg start;
    reg [7:0] address;
    reg [7:0] firstByte;
    reg [7:0] secondByte;
    wire busy;
    wire done;
    wire error;
    wire i2c_clock;
    wire i2c_data;

    // Instantiate the I2C module
    i2c_audio_setup uut (
        .fpga50MHzClock(fpga50MHzClock),
        .reset(reset),
        .start(start),
        .address(address),
        .firstByte(firstByte),
        .secondByte(secondByte),
        .busy(busy),
        .done(done),
        .error(error),
        .i2c_clock(i2c_clock),
        .i2c_data(i2c_data)
    );

    // Generate the 50 MHz FPGA clock
    always begin
        fpga50MHzClock = 1'b0;
        #10;
        fpga50MHzClock = 1'b1;
        #10;
    end

    // Stimulus
    initial begin
        // Initialize signals
        reset = 0;
        start = 0;
        address = 8'hA0;   // Example address (I2C write address)
        firstByte = 8'h55;  // Example first byte to send
        secondByte = 8'hAA; // Example second byte to send
        
        // Reset the system
        reset = 1;
        #20;
        reset = 0;
        
        // Start the I2C communication
        #20;
        start = 1; // Assert start signal
        #20;
        start = 0; // Deassert start signal
        
        // Wait some time to observe the communication
        #200;

        // Finish the simulation
        $stop;
    end

    // Monitor the signals for debugging
    initial begin
        $monitor("Time = %t, i2c_clock = %b, i2c_data = %b, busy = %b, done = %b, error = %b", 
                 $time, i2c_clock, i2c_data, busy, done, error);
    end

endmodule