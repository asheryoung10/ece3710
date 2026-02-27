module audio_output (
    input  clk_50,       // 50MHz Clock
    input  [1:0] pitch_sel, // Pitch selection: 00, 01, 10, 11
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

    assign aud_bclk    = counter[2]; 
    assign aud_daclrck = counter[7]; 

    // 2. Variable Pitch Generation
    reg [15:0] audio_sample;
    reg [8:0]  tone_divider; // Increased width to allow lower pitches
    reg [8:0]  pitch_limit;

    // Pitch Selection Table
    // Smaller limit = Higher frequency
    always @(*) begin
        case(pitch_sel)
            2'b00:   pitch_limit = 9'd255; // Deepest (~95Hz)
            2'b01:   pitch_limit = 9'd127; // Original (~190Hz)
            2'b10:   pitch_limit = 9'd63;  // Higher (~380Hz)
            2'b11:   pitch_limit = 9'd31;  // Highest (~760Hz)
            default: pitch_limit = 9'd127;
        endcase
    end
    
    always @(posedge aud_daclrck) begin
        if (tone_divider >= pitch_limit) begin
            tone_divider <= 9'd0;
            // Toggle Square Wave
            if (audio_sample == 16'h2000)
                audio_sample <= 16'hE000;
            else
                audio_sample <= 16'h2000;
        end else begin
            tone_divider <= tone_divider + 1'b1;
        end
    end

    // 3. I2S Serial Output Logic
    wire [4:0] bit_count;
    assign bit_count = counter[6:2];

    reg dacdat_reg;
    always @(negedge aud_bclk) begin
        if (bit_count >= 5'd1 && bit_count <= 5'd16) begin
            dacdat_reg <= audio_sample[5'd16 - bit_count];
        end else begin
            dacdat_reg <= 1'b0;
        end
    end
    
    assign aud_dacdat = dacdat_reg;

endmodule