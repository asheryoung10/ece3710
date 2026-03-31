`timescale 1ns/1ps

module background_renderer (
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,
    output reg [7:0] red,
    output reg [7:0] green,
    output reg [7:0] blue
);

// Paint a checkerboard-style background from the current pixel coordinates.
always @(*) begin
    if (((pixel_x / 32) + (pixel_y / 32)) % 2 == 0) begin
        red = 8'd24;
        green = 8'd78;
        blue = 8'd158;
    end else begin
        red = 8'd14;
        green = 8'd116;
        blue = 8'd78;
    end
end

endmodule
