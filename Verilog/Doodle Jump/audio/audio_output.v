module audio_output (
    input clk_50,         // 50 MHz Clock
    input [7:0] pitch,   // 8-bit pitch selection (0 -> lowest, 255 -> highest)
    input drum_toggle,    // 1-bit drum toggle (1 -> play drum sound, 0 -> play pitch)
    output aud_xck,      // 12.5 MHz (MCLK)
    output aud_bclk,     // ~1.56 MHz
    output aud_daclrck,  // 48.8 kHz
    output aud_dacdat    // Serial data
);

    // Clock Dividers (for generating MCLK, BCLK, LRCLK)
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

    // Submodule 1: Note Generator
    wire [15:0] note_data;
    note_generator note_gen (
        .clk_50(clk_50),
        .pitch(pitch),
        .aud_daclrck(aud_daclrck),
        .note_data(note_data)
    );

    // Submodule 2: Drum Sound Generator
    wire [15:0] drum_data;
    drum_generator drum_gen (
        .clk_50(clk_50),
        .drum_toggle(drum_toggle),
        .aud_daclrck(aud_daclrck),
        .drum_data(drum_data)
    );

    // Combining Note and Drum Output
    reg [15:0] final_audio_data;
    always @(posedge aud_daclrck) begin
        if (drum_toggle) begin
            final_audio_data <= drum_data;  // If drum toggle is on, output drum sound
        end else begin
            final_audio_data <= note_data;  // Otherwise, output the note
        end
    end

    // I2S Serial Output Logic
    wire [4:0] bit_count;
    assign bit_count = counter[6:2];

    reg dacdat_reg;
    always @(negedge aud_bclk) begin
        if (bit_count >= 5'd1 && bit_count <= 5'd16) begin
            dacdat_reg <= final_audio_data[5'd16 - bit_count]; // Send 16-bit audio sample
        end else begin
            dacdat_reg <= 1'b0;
        end
    end

    assign aud_dacdat = dacdat_reg;

endmodule

// Submodule 1: Note Generator
module note_generator (
    input clk_50,
    input [7:0] pitch,        // 8-bit pitch value
    input aud_daclrck,        // Clock for sampling the note data
    output reg [15:0] note_data  // Output audio data (16-bit)
);

    // Define the base frequency (A1 = 55 Hz)
    parameter BASE_FREQUENCY = 55;

    reg [31:0] tone_divider;
    reg [31:0] tone_limit;

    always @(posedge aud_daclrck) begin
        // Calculate the tone divider for the selected pitch
        tone_limit <= (BASE_FREQUENCY << pitch);  // Exponentially scale the frequency
        
        if (tone_divider >= tone_limit) begin
            tone_divider <= 0;
            note_data <= 16'hFFFF;  // Output high tone level (square wave)
        end else begin
            tone_divider <= tone_divider + 1'b1;
            note_data <= 16'h0000;  // Output low tone level (square wave)
        end
    end

endmodule

// Submodule 2: Drum Sound Generator
module drum_generator (
    input clk_50,
    input drum_toggle,         // 1-bit drum toggle (1 -> play drum sound)
    input aud_daclrck,         // Clock for sampling the drum data
    output wire [15:0] drum_data  // Output drum sound data
);

    reg [15:0] drum_sample;

    always @(posedge aud_daclrck) begin
        if (drum_toggle) begin
            // Generate a simple drum sound (square wave)
            drum_sample <= 16'hFFFF;  // Drum sound high level
        end else begin
            drum_sample <= 16'h0000;  // No sound when toggle is off
        end
    end

    assign drum_data = drum_sample;

endmodule