module audio_player (
    input clk,               // System clock
    input rst,               // Reset signal
    input [15:0] audio_data, // PCM audio data (16-bit per channel for stereo)
    output scl,              // I2C clock for codec configuration
    inout sda,               // I2C data for codec configuration
    output bclk,             // I2S Bit Clock
    output lrck,             // I2S Left/Right Clock
    output dac_data          // I2S audio data to DAC
);

    reg [15:0] audio_sample;  // Audio sample data
    reg [15:0] left_channel;  // Left audio channel
    reg [15:0] right_channel; // Right audio channel

    // Instantiate I2C controller (to initialize codec)
    i2c_controller i2c_inst (
        .clk(clk),
        .rst(rst),
        .data_in(8'd0), // Data to be sent to codec during initialization (placeholder)
        .start(1'b1),    // Start signal for initialization
        .done(),         // Done signal after initialization
        .scl(scl),
        .sda(sda)
    );

    // Instantiate I2S clock generator
    i2s_clock_generator i2s_clk_gen_inst (
        .clk(clk),
        .bclk(bclk),
        .lrck(lrck)
    );

    // Assign audio data to left and right channels (stereo audio)
    always @(posedge bclk or posedge rst) begin
        if (rst) begin
            left_channel <= 16'd0;
            right_channel <= 16'd0;
        end else begin
            left_channel <= audio_data[15:8];  // 8 bits for left channel
            right_channel <= audio_data[7:0]; // 8 bits for right channel
        end
    end

    // Output the audio data (I2S format) to the DAC
    assign dac_data = (lrck) ? right_channel : left_channel;  // Toggle between left and right channels based on lrck

endmodule
