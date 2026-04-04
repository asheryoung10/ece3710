module sixteen_bit_seven_seg(
    input  wire [15:0] value,  // 16-bit input
    output [6:0] hex0,         // least significant nibble
    output [6:0] hex1,
    output [6:0] hex2,
    output [6:0] hex3          // most significant nibble
);

    // Instantiate four 4-bit decoders
    seven_seg_decoder dec0 (
        .bin(value[3:0]),
        .hex(hex0)
    );

    seven_seg_decoder dec1 (
        .bin(value[7:4]),
        .hex(hex1)
    );

    seven_seg_decoder dec2 (
        .bin(value[11:8]),
        .hex(hex2)
    );

    seven_seg_decoder dec3 (
        .bin(value[15:12]),
        .hex(hex3)
    );

endmodule
