//======================================================
// memory.v
// Top-level memory using TWO BRAM instances (512x16 each)
// Verilog-2001 ONLY
//======================================================

module bmemory
#(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 10  // 1024 words total
)
(
    // -------- Port A --------
    input  [ADDR_WIDTH-1:0] addr_a, // 10-bit
    input  [DATA_WIDTH-1:0] din_a,
    input                    en_a,
    input                    we_a,
    output [DATA_WIDTH-1:0] dout_a,

    // -------- Port B --------
    input  [ADDR_WIDTH-1:0] addr_b,
    input  [DATA_WIDTH-1:0] din_b,
    input                    en_b,
    input                    we_b,
    output [DATA_WIDTH-1:0] dout_b,

    input clk
);

    // -------------------------
    // Internal wires to BRAMs
    // -------------------------
    wire [DATA_WIDTH-1:0] dout_a0, dout_a1;
    wire [DATA_WIDTH-1:0] dout_b0, dout_b1;

    // -------------------------
    // BRAM0 (addresses 0-511)
    // -------------------------
    bram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH-1)  // 512 words
    ) bram0 (
        .data_a(din_a),
        .addr_a(addr_a[ADDR_WIDTH-2:0]),
        .we_a(we_a & (addr_a[ADDR_WIDTH-1]==1'b0) & en_a),
        .clk(clk),
        .q_a(dout_a0),

        .data_b(din_b),
        .addr_b(addr_b[ADDR_WIDTH-2:0]),
        .we_b(we_b & (addr_b[ADDR_WIDTH-1]==1'b0) & en_b),
        .q_b(dout_b0)
    );

    // -------------------------
    // BRAM1 (addresses 512-1023)
    // -------------------------
    bram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH-1)  // 512 words
    ) bram1 (
        .data_a(din_a),
        .addr_a(addr_a[ADDR_WIDTH-2:0]),
        .we_a(we_a & (addr_a[ADDR_WIDTH-1]==1'b1) & en_a),
        .clk(clk),
        .q_a(dout_a1),

        .data_b(din_b),
        .addr_b(addr_b[ADDR_WIDTH-2:0]),
        .we_b(we_b & (addr_b[ADDR_WIDTH-1]==1'b1) & en_b),
        .q_b(dout_b1)
    );

    // -------------------------
    // MUX outputs based on MSB of address
    // -------------------------
    assign dout_a = (addr_a[ADDR_WIDTH-1]==1'b0) ? dout_a0 : dout_a1;
    assign dout_b = (addr_b[ADDR_WIDTH-1]==1'b0) ? dout_b0 : dout_b1;

endmodule

