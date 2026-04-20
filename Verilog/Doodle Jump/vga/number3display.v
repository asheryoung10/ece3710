module number3Display (
    input  wire        clk50,
    input  wire [15:0] number,
    input  wire [15:0] baseX,
    input  wire [15:0] baseY,
    input  wire [15:0] highlightColor,
    input  wire [9:0]  pixelX,
    input  wire [9:0]  pixelY,
    input  wire [15:0] scale,

    output reg  [7:0] pixelR,
    output reg  [7:0] pixelG,
    output reg  [7:0] pixelB
);

//////////////////////////////
// Glyph constants
//////////////////////////////
localparam DIGIT_W = 7;
localparam DIGIT_H = 11;

wire [15:0] drawW = DIGIT_W * scale;
wire [15:0] drawH = DIGIT_H * scale;

//////////////////////////////
// Double dabble (16-bit → 3 BCD digits)
// result: hundreds, tens, ones
//////////////////////////////
reg [3:0] hundreds;
reg [3:0] tens;
reg [3:0] ones;

integer i;
reg [27:0] shift; // enough for 16-bit + BCD

always @(*) begin
    shift = 0;
    shift[15:0] = number;

    // 16 iterations
    for (i = 0; i < 16; i = i + 1) begin

        // adjust BCD digits
        if (shift[19:16] >= 5) shift[19:16] = shift[19:16] + 3;
        if (shift[23:20] >= 5) shift[23:20] = shift[23:20] + 3;
        if (shift[27:24] >= 5) shift[27:24] = shift[27:24] + 3;

        shift = shift << 1;
    end

    hundreds = shift[27:24];
    tens     = shift[23:20];
    ones     = shift[19:16];
end

//////////////////////////////
// digit selection helper
//////////////////////////////
wire [3:0] digit0 = hundreds;
wire [3:0] digit1 = tens;
wire [3:0] digit2 = ones;

//////////////////////////////
// digit X selection
//////////////////////////////
wire [15:0] digitX0 = baseX;
wire [15:0] digitX1 = baseX + drawW;
wire [15:0] digitX2 = baseX + (drawW << 1);

wire [15:0] digitY  = baseY;

//////////////////////////////
// active digit mask
//////////////////////////////
wire use0 = (pixelX >= digitX0 && pixelX < digitX0 + drawW);
wire use1 = (pixelX >= digitX1 && pixelX < digitX1 + drawW);
wire use2 = (pixelX >= digitX2 && pixelX < digitX2 + drawW);

wire [1:0] active_digit =
    use0 ? 2'd0 :
    use1 ? 2'd1 :
    use2 ? 2'd2 : 2'd3;

//////////////////////////////
// local sprite coordinates
//////////////////////////////
wire [15:0] localX =
    (active_digit == 0) ? (pixelX - digitX0) :
    (active_digit == 1) ? (pixelX - digitX1) :
    (pixelX - digitX2);

wire [15:0] localY = pixelY - digitY;

wire [15:0] spriteX = localX / scale;
wire [15:0] spriteY = localY / scale;

wire in_bounds =
    (spriteX < DIGIT_W) &&
    (spriteY < DIGIT_H);

//////////////////////////////
// ROM instances (3 digits)
// If you have one ROM, you can replace this with offset addressing
//////////////////////////////
wire [31:0] rom0, rom1, rom2;

glyph_rom 
#(.DATA_WIDTH(32), .ADDR_WIDTH(14), .ROM_FILE("wideHex.hex")) digit_rom0 
(
    .clk(clk50),
    .addr(digit0 * (DIGIT_W * DIGIT_H) + (spriteY * DIGIT_W + spriteX)),
    .q(rom0)
);

glyph_rom 
#(.DATA_WIDTH(32), .ADDR_WIDTH(14), .ROM_FILE("wideHex.hex")) digit_rom1 
( 
    .clk(clk50),
    .addr(digit1 * (DIGIT_W * DIGIT_H) + (spriteY * DIGIT_W + spriteX)),
    .q(rom1)
);

glyph_rom 
#(.DATA_WIDTH(32), .ADDR_WIDTH(14), .ROM_FILE("wideHex.hex")) digit_rom2 
(
    .clk(clk50),
    .addr(digit2 * (DIGIT_W * DIGIT_H) + (spriteY * DIGIT_W + spriteX)),
    .q(rom2)
);

reg [31:0] rom_data;
// Expand RGB565 highlightColor to 8-bit channels

wire [7:0] h_r = {highlightColor[15:11], 3'b000}; // 5 → 8 bits
wire [7:0] h_g = {highlightColor[10:5],  2'b00};  // 6 → 8 bits
wire [7:0] h_b = {highlightColor[4:0],   3'b000}; // 5 → 8 bits
            reg [8:0] r_sum;
            reg [8:0] g_sum;
            reg [8:0] b_sum;

				
always @(*) begin
    pixelR = 0;
    pixelG = 0;
    pixelB = 0;

    if (active_digit != 3 && in_bounds) begin

        case (active_digit)
            0: rom_data = rom0;
            1: rom_data = rom1;
            2: rom_data = rom2;
            default: rom_data = 0;
        endcase

        // Detect full transparency
        if (rom_data[23:0] != 24'd0) begin

            // Expand highlight (same as before)
            // (do this once somewhere if you already have it)
            // h_r, h_g, h_b assumed 8-bit

            // 9-bit sums to prevent overflow wrap

            r_sum = rom_data[23:16] + h_r;
            g_sum = rom_data[15:8]  + h_g;
            b_sum = rom_data[7:0]   + h_b;

            // Saturate
            pixelR = r_sum[8] ? 8'd255 : r_sum[7:0];
            pixelG = g_sum[8] ? 8'd255 : g_sum[7:0];
            pixelB = b_sum[8] ? 8'd255 : b_sum[7:0];
        end
    end
end

endmodule