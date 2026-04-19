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

// Doodle-Jump-inspired notebook background:
//   - warm paper color
//   - light blue graph lines
//   - a subtle red notebook margin line
always @(posedge clk50) begin
    // Red notebook margin line.
    if ((pixelX >= 10'd63) && (pixelX < 10'd65)) begin
        r_next <= 8'd235;
        g_next <= 8'd110;
        b_next <= 8'd110;
    end
    // Darker accent every 128 pixels.
    else if ((pixelX[6:0] == 7'd0) || (pixelY[6:0] == 7'd0)) begin
        r_next <= 8'd160;
        g_next <= 8'd200;
        b_next <= 8'd245;
    end
    // Light blue graph-paper lines every 32 pixels.
    else if ((pixelX[4:0] == 5'd0) || (pixelY[4:0] == 5'd0)) begin
        r_next <= 8'd180;
        g_next <= 8'd215;
        b_next <= 8'd250;
    end
    // Paper fill.
    else begin
        r_next <= 8'd248;
        g_next <= 8'd245;
        b_next <= 8'd220;
    end
end

// Output one cycle after calculation (simulate memory latency)
always @(posedge clk50) begin
    glyphPixelR <= r_next;
    glyphPixelG <= g_next;
    glyphPixelB <= b_next;
end

endmodule
