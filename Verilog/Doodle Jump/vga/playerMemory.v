module playerMemory (
    input  wire       clk50,
    input  wire [15:0] playerX,
    input  wire [15:0] playerY,
    input  wire [15:0] highlightColor,
    input  wire [9:0]  pixelX,
    input  wire [9:0]  pixelY,
    input  wire [3:0]  playerAnimationIndex,
    input  wire        shrinkHalf,

    output reg  [7:0] playerPixelR,
    output reg  [7:0] playerPixelG,
    output reg  [7:0] playerPixelB
);

reg [7:0] r_next, g_next, b_next;

localparam PLAYER_WIDTH  = 45;
localparam PLAYER_HEIGHT = 41;

// Half-size draw region
wire [15:0] drawWidth  = shrinkHalf ? (PLAYER_WIDTH  >> 1) : PLAYER_WIDTH;
wire [15:0] drawHeight = shrinkHalf ? (PLAYER_HEIGHT >> 1) : PLAYER_HEIGHT;

// raw sprite coordinates in screen space
wire [15:0] rawX = pixelX - playerX;
wire [15:0] rawY = pixelY - playerY;

// nearest-neighbor downsample (2x shrink)
wire [15:0] spriteX = shrinkHalf ? (rawX << 1) : rawX;
wire [15:0] spriteY = shrinkHalf ? (rawY << 1) : rawY;

wire [31:0] rom_data;

// ROM lookup
glyph_rom glyph_rom_instance(
    .clk(clk50),
    .addr(
        (playerAnimationIndex * (PLAYER_HEIGHT * PLAYER_WIDTH)) +
        spriteX +
        1 +
        (spriteY * PLAYER_WIDTH)
    ),
    .q(rom_data)
);

// Pixel generation
always @(posedge clk50) begin

    if ((pixelX >= playerX) && (pixelX < playerX + drawWidth) &&
        (pixelY >= playerY) && (pixelY < playerY + drawHeight)) begin

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
