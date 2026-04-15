module playerMemory (
    input  wire       clk50,
    input  wire [15:0] playerX,
    input  wire [15:0] playerY,
    input  wire [15:0] highlightColor,
    input  wire [9:0]  pixelX,
    input  wire [9:0]  pixelY,
    input  wire [3:0]  playerAnimationIndex,
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
wire [15:0] spriteX = rawX / scale;
wire [15:0] spriteY = rawY / scale;

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
always @(posedge clk50) begin

    if ((pixelX >= playerX) && (pixelX < playerX + drawWidth) &&
        (pixelY >= playerY) && (pixelY < playerY + drawHeight) &&
        in_bounds) begin

        // Blue channel
        b_next <= (rom_data[7:0] == 0) ? 0 :
                  ((rom_data[7:0] + highlightColor[4:0] > 8'd255)
                    ? 8'd255
                    : rom_data[7:0] + highlightColor[4:0]);

        // Green channel
        g_next <= (rom_data[15:8] == 0) ? 0 :
                  ((rom_data[15:8] + highlightColor[10:5] > 8'd255)
                    ? 8'd255
                    : rom_data[15:8] + highlightColor[10:5]);

        // Red channel
        r_next <= (rom_data[23:16] == 0) ? 0 :
                  ((rom_data[23:16] + highlightColor[15:11] > 8'd255)
                    ? 8'd255
                    : rom_data[23:16] + highlightColor[15:11]);

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