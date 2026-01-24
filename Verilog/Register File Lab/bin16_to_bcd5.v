module bin16_to_bcd5 (
    input  wire [15:0] bin,
    output reg  [3:0] bcd4,  // ten-thousands
    output reg  [3:0] bcd3,  // thousands
    output reg  [3:0] bcd2,  // hundreds
    output reg  [3:0] bcd1,  // tens
    output reg  [3:0] bcd0   // ones
);

    integer i;
    reg [35:0] shift_reg; // 16 bits binary + 5*4 bits BCD

    always @(*) begin
        // initialize
        shift_reg = 36'd0;
        shift_reg[15:0] = bin;

        // double dabble algorithm
        for (i = 0; i < 16; i = i + 1) begin
            if (shift_reg[19:16] >= 5) shift_reg[19:16] = shift_reg[19:16] + 3;
            if (shift_reg[23:20] >= 5) shift_reg[23:20] = shift_reg[23:20] + 3;
            if (shift_reg[27:24] >= 5) shift_reg[27:24] = shift_reg[27:24] + 3;
            if (shift_reg[31:28] >= 5) shift_reg[31:28] = shift_reg[31:28] + 3;
            if (shift_reg[35:32] >= 5) shift_reg[35:32] = shift_reg[35:32] + 3;

            shift_reg = shift_reg << 1;
        end

        // assign outputs
        bcd0 = shift_reg[19:16];
        bcd1 = shift_reg[23:20];
        bcd2 = shift_reg[27:24];
        bcd3 = shift_reg[31:28];
        bcd4 = shift_reg[35:32];
    end

endmodule
