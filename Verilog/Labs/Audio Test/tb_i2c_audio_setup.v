module tb_i2c_audio_setup;

    // Testbench signals
    reg fpga50MHzClock;
    reg reset;
    reg start;
    wire busy;
    wire done;
    wire error;
    wire i2c_clock;
    wire i2c_data;
	wire [7:0] debugAddress;
	wire [7:0] debugFirstByte;
	wire [7:0] debugSecondByte;

    // Instantiate the I2C module
    i2c_commands uut (
        .fpga50MHzClock(fpga50MHzClock),
        .reset(reset),
        .start(start),
        .busy(busy),
        .done(done),
        .error(error),
        .i2c_clock(i2c_clock),
        .i2c_data(i2c_data),
		.debugAddress(debugAddress),
		.debugFirstByte(debugFirstByte),
		.debugSecondByte(debugSecondByte)
    );

    // Generate the 50 MHz FPGA clock
    always begin
        fpga50MHzClock = 1'b0;
        #10;
        fpga50MHzClock = 1'b1;
        #10;
    end
	 
	 pullup(i2c_clock);
	 pullup(i2c_data);

	     // Monitor the signals for debugging
    initial begin
        $monitor("Time = %t, i2c_clock = %b, i2c_clock_value = %b, i2c_data = %b, i2c_data_value = %b, busy = %b, done = %b, error = %b, state = %b, stepIndex = %b", 
                 $time, i2c_clock, uut.i2c_instance.i2c_clock_value, i2c_data, uut.i2c_instance.i2c_clock_value, busy, done, error, uut.i2c_instance.state, uut.i2c_instance.subStep);
    end
	 
    // Stimulus
    initial begin
        // Initialize signals
        reset = 0;
        start = 0;
        
        // Reset the system
        reset = 1;
        #20;
        reset = 0;
        
        // Start the I2C communication
        #40;
        start = 1; // Assert start signal
        #20;
        start = 0; // Deassert start signal
        
        // Wait some time to observe the communication
        #10000;

        // Finish the simulation
        $stop;
    end



endmodule