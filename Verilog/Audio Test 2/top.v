module top(
    input  CLOCK_50,     // 50MHz onboard clock
    input  RESET_N,      // Active-low reset (usually a pushbutton)
    input configure_N,
	 input wire [1:0] pitch,
    // I2C Pins
    inout  FPGA_I2C_SCLK,
    inout  FPGA_I2C_SDAT,
    
    // Audio CODEC Pins
    output AUD_XCK,      // Master Clock
    output AUD_BCLK,     // Bit Clock
    output AUD_DACLRCK,  // DAC Sample Clock
    output AUD_DACDAT,    // DAC Serial Data
	 output error
);

    wire config_done;
    wire config_busy;

    // 1. Instance: Audio Configuration (I2C)
    // This talks to the chip registers to unmute and power it up.
    audio_configurator i2c_conf (
        .systemClock(CLOCK_50),
        .reset(~RESET_N),        // Converting active-low to active-high
        .configure(~configure_N),        // Always try to configure on power-up
        .busy(config_busy),
        .done(config_done),
        .encounteredError(error),     // Unused for this simple setup
        .i2c_clock(FPGA_I2C_SCLK),
        .i2c_data(FPGA_I2C_SDAT)
    );

    // 2. Instance: Audio Output Logic (I2S)
    // This generates the actual square wave bitstream.
    audio_output dac_driver (
        .clk_50(CLOCK_50),
		  .pitch_sel(pitch),
        .aud_xck(AUD_XCK),
        .aud_bclk(AUD_BCLK),
        .aud_daclrck(AUD_DACLRCK),
        .aud_dacdat(AUD_DACDAT)
    );

endmodule