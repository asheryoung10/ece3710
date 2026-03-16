module playerMemory (
    input  wire       clk50,
    input  wire [9:0] playerX, // sprite position X on screen
    input  wire [9:0] playerY, // sprite position Y on screen
    input  wire [9:0] pixelX,  // current pixel being fetched
    input  wire [9:0] pixelY,  // current pixel being fetched
    input  wire [3:0] playerAnimationIndex, // animation frame index
    output reg  [7:0] playerPixelR,
    output reg  [7:0] playerPixelG,
    output reg  [7:0] playerPixelB
);

reg [7:0] r_next, g_next, b_next;

// Generate 32x32 square at player position
always @(posedge clk50) begin
    if ((pixelX >= playerX) && (pixelX < playerX + 32) &&
        (pixelY >= playerY) && (pixelY < playerY + 32)) begin
        // Change color based on animation index
        // Red fixed, green varies, blue varies for fun
        r_next <= 8'd255;                     // Red fixed
        g_next <= playerAnimationIndex * 16;  // Green changes with animation index
        b_next <= 8'd15 * playerAnimationIndex; // Blue also changes for effect
    end else begin
        r_next <= 8'd0;  // Transparent background
        g_next <= 8'd0;
        b_next <= 8'd0;
    end
end

// Output registers (simulate one-cycle memory latency)
always @(posedge clk50) begin
    playerPixelR <= r_next;
    playerPixelG <= g_next;
    playerPixelB <= b_next;
end

endmodule