module i2s_clock_generator (
    input clk,               // System clock (50 MHz or 100 MHz)
    output reg bclk,         // I2S Bit Clock (bclk)
    output reg lrck          // I2S Left/Right Clock (lrck)
);

    reg [15:0] bclk_counter;  // Counter for bit clock
    reg lrck_toggle;          // Toggle for left/right clock

    // Generate bit clock (bclk) and left/right clock (lrck)
    always @(posedge clk) begin
        bclk_counter <= bclk_counter + 1;
        if (bclk_counter == 16'd4999) begin
            bclk <= ~bclk;  // Toggle bit clock at every 5000 cycles (for 50 MHz clock)
            bclk_counter <= 16'd0;
        end
    end

    // Generate lrck (left/right clock) for stereo audio (alternates every 1 bit)
    always @(posedge bclk) begin
        lrck <= ~lrck;  // Toggle lrck every clock cycle
    end

endmodule
