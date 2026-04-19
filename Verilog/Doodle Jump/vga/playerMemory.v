module playerMemory (
    input  wire       clk50,
    input  wire [15:0] playerX,
    input  wire [15:0] playerY,
    input  wire [15:0] highlightColor,
    input  wire [9:0]  pixelX,
    input  wire [9:0]  pixelY,
    input  wire [4:0]  playerAnimationIndex,
    input  wire [15:0] scale,

    output reg  [7:0] playerPixelR,
    output reg  [7:0] playerPixelG,
    output reg  [7:0] playerPixelB
);

reg [7:0] r_next, g_next, b_next;

localparam PLAYER_WIDTH  = 16;
localparam PLAYER_HEIGHT = 16;

// Scaled draw region
wire [15:0] drawWidth  = PLAYER_WIDTH  * scale;
wire [15:0] drawHeight = PLAYER_HEIGHT * scale;

// Offset from sprite origin
wire [15:0] rawX = pixelX - playerX;
wire [15:0] rawY = pixelY - playerY;

// Nearest-neighbor scaling (integer division)
wire [15:0] spriteX = rawX / (scale == 0 ? 1 : scale);
wire [15:0] spriteY = rawY / (scale == 0 ? 1 : scale);

// Bounds safety (prevents ROM overflow)
wire in_bounds =
    (spriteX < PLAYER_WIDTH) &&
    (spriteY < PLAYER_HEIGHT);

// ROM lookup
wire [31:0] rom_data;

glyph_rom glyph_rom_instance(
    .clk(clk50),
    .addr(
        (playerAnimationIndex * (PLAYER_HEIGHT * PLAYER_WIDTH)) +
        (spriteX + (spriteY * PLAYER_WIDTH))
    ),
    .q(rom_data)
);

// Pixel generation
// Detect if pixel is completely black
wire pixel_is_black = (rom_data[23:0] == 24'd0);
wire [7:0] h_b = {highlightColor[4:0], 3'b000}; // << 3 
wire [7:0] h_g = {highlightColor[10:5], 2'b00}; // << 2 (6-bit channel) 
wire [7:0] h_r = {highlightColor[15:11], 3'b000}; // << 3

// Force 9-bit sums to detect overflow
wire [8:0] b_sum = rom_data[7:0]   + h_b;
wire [8:0] g_sum = rom_data[15:8]  + h_g;
wire [8:0] r_sum = rom_data[23:16] + h_r;

always @(posedge clk50) begin

    if ((pixelX >= playerX) && (pixelX < playerX + drawWidth) &&
        (pixelY >= playerY) && (pixelY < playerY + drawHeight) &&
        in_bounds) begin

        if (pixel_is_black) begin
            r_next <= 8'd0;
            g_next <= 8'd0;
            b_next <= 8'd0;
        end else begin
            b_next <= b_sum[8] ? 8'd255 : b_sum[7:0];
            g_next <= g_sum[8] ? 8'd255 : g_sum[7:0];
            r_next <= r_sum[8] ? 8'd255 : r_sum[7:0];
        end

    end else begin
        r_next <= 8'd0;
        g_next <= 8'd0;
        b_next <= 8'd0;
    end
end

// Output registers
always @(posedge clk50) begin
    playerPixelR <= r_next;
    playerPixelG <= g_next;
    playerPixelB <= b_next;
end

endmodule