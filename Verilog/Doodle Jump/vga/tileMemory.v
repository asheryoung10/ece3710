`timescale 1ns / 1ps
module tileMemory (
    input  wire       clk50,
    input  wire [9:0] pixelX,
    input  wire [9:0] pixelY,
    output reg  [7:0] glyphPixelR,
    output reg  [7:0] glyphPixelG,
    output reg  [7:0] glyphPixelB
);

reg [7:0] r_next, g_next, b_next;

always @(posedge clk50) begin
    // Checkerboard pattern: tiles 32x32
    if (((pixelX/32) + (pixelY/32)) % 2 == 0) begin
        r_next <= 8'd0;   // Black
        g_next <= 8'd0;
        b_next <= 8'd255; // Blue
    end else begin
        r_next <= 8'd0;
        g_next <= 8'd255; // Green
        b_next <= 8'd0;
    end
end

// Output one cycle after calculation (simulate memory latency)
always @(posedge clk50) begin
    glyphPixelR <= r_next;
    glyphPixelG <= g_next;
    glyphPixelB <= b_next;
end

endmodule
