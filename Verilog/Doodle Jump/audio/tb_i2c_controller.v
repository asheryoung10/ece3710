module tb_i2c_controller;

reg clock;
reg reset;

reg sendMessage;
reg [7:0] addressByte;
reg [7:0] firstByte;
reg [7:0] secondByte;

wire busy;
wire done;
wire encounteredError;

wire i2c_clock;
wire i2c_data;

pullup(i2c_clock);
pullup(i2c_data);

i2c_controller uut (
    .clock(clock),
    .reset(reset),
    .sendMessage(sendMessage),
    .addressByte(addressByte),
    .firstByte(firstByte),
    .secondByte(secondByte),
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

reg simulate_ack;
assign i2c_data = (simulate_ack) ? 1'b0 : 1'bz;


initial begin
    // Initialize Inputs
    clock = 0;
    reset = 0;
    sendMessage = 0;
    addressByte = 8'hA1;
    firstByte   = 8'h12;
    secondByte  = 8'h34;
    simulate_ack = 0;

    #25;
    reset = 1;
    #20;
    reset = 0;
    #40;

    sendMessage = 1;
    #20;
    sendMessage = 0;

    repeat (3) begin
        repeat (8) @(posedge i2c_clock);
        
        @(negedge i2c_clock); 
        simulate_ack = 1;
        
        @(negedge i2c_clock);
        simulate_ack = 0;
    end

    wait(done);
    #100;
    
    $display("Transaction Complete. Error Flag: %b", encounteredError);
    $finish;
end

endmodule