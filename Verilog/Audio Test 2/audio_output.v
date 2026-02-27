module audio_output (
    input  clk_50,       // 50MHz Clock
    output aud_xck,      // 12.5 MHz (MCLK)
    output aud_bclk,     // ~1.56 MHz
    output aud_daclrck,  // 48.8 kHz
    output aud_dacdat    // Serial data
);

    // 1. Clock Dividers
    reg [1:0] mclk_count;
    always @(posedge clk_50) begin
        mclk_count <= mclk_count + 1'b1;
    end
    assign aud_xck = mclk_count[1]; 

    reg [7:0] counter; 
    always @(posedge aud_xck) begin
        counter <= counter + 1'b1;
    end

    // MCLK (12.5MHz) / 8 = 1.5625 MHz BCLK
    assign aud_bclk    = counter[2]; 
    // MCLK (12.5MHz) / 256 = 48.828 kHz LRCK
    assign aud_daclrck = counter[7]; 

    // 2. Square Wave Generation (~190Hz tone)
    reg [15:0] audio_sample;
    reg [6:0]  tone_divider;
    
    always @(posedge aud_daclrck) begin
        tone_divider <= tone_divider + 1'b1;
        if (tone_divider == 7'd0) begin
            if (audio_sample == 16'h2000)
                audio_sample <= 16'hE000;
            else
                audio_sample <= 16'h2000;
        end
    end

    // 3. I2S Serial Output Logic
    // counter[6:2] gives us a 5-bit value (0-31) for each LRCK half-cycle.
    wire [4:0] bit_count;
    assign bit_count = counter[6:2];

    reg dacdat_reg;
    always @(negedge aud_bclk) begin
        // I2S Standard: 
        // bit_count 0: Transition/Idle bit
        // bit_count 1: MSB (Bit 15)
        // bit_count 16: LSB (Bit 0)
        if (bit_count >= 5'd1 && bit_count <= 5'd16) begin
            dacdat_reg <= audio_sample[5'd16 - bit_count];
        end else begin
            dacdat_reg <= 1'b0;
        end
    end
    
    assign aud_dacdat = dacdat_reg;

endmodule