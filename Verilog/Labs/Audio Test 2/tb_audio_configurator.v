module tb_audio_configurator;

reg clock;
reg reset;

reg configure;

wire busy;
wire done;
wire encounteredError;

wire i2c_clock;
wire i2c_data;

pullup(i2c_clock);
pullup(i2c_data);

audio_configurator uut (
    .systemClock(clock),
    .reset(reset),
    .configure(configure),
    .busy(busy),
    .done(done),
    .encounteredError(encounteredError),
    .i2c_clock(i2c_clock),
    .i2c_data(i2c_data)
);

always begin
    clock = 1'b0;
    #10;
    clock = 1'b1;
    #10;
end


initial begin
    // Initialize Inputs
    clock = 0;
    reset = 0;
    configure = 0;

    #25;
    reset = 1;
    #20;
    reset = 0;
    #40;

    configure = 1;
    #40;
    configure = 0;

    wait(done);
    #100;
    
    $display("Transaction Complete. Error Flag: %b", encounteredError);
    $finish;
end

endmodule