module seven_seg_decoder (
    input  wire [3:0] bin,   // 4-bit binary input
    output reg  [7:0] hex    // 7-seg output (active LOW)
);

    always @(*) begin
        case (bin)
            4'h0: hex = 8'b11000000; // 0
            4'h1: hex = 8'b11111001; // 1
            4'h2: hex = 8'b10100100; // 2
            4'h3: hex = 8'b10110000; // 3
            4'h4: hex = 8'b10011001; // 4
            4'h5: hex = 8'b10010010; // 5
            4'h6: hex = 8'b10000010; // 6
            4'h7: hex = 8'b11111000; // 7
            4'h8: hex = 8'b10000000; // 8
            4'h9: hex = 8'b10010000; // 9
            4'hA: hex = 8'b10001000; // A
            4'hB: hex = 8'b10000011; // b
            4'hC: hex = 8'b11000110; // C
            4'hD: hex = 8'b10100001; // d
            4'hE: hex = 8'b10000110; // E
            4'hF: hex = 8'b10001110; // F
            default: hex = 8'b11111111; // all OFF
        endcase
    end

endmodule
