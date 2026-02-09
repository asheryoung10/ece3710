module top (
    input  wire        clk,        // system clock
    input  wire [11:0]  switches,   // address select
    output wire [15:0] value        // BRAM output
);

    bram bram_instance (
        .data_a(16'b0),      // no writes
        .data_b(16'b0),
        .addr_a(switches),
        .addr_b(11'b0),
        .we_a(1'b0),
        .we_b(1'b0),
        .clk(clk),
        .q_a(value),
        .q_b()
    );

endmodule