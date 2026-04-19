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
 
localparam DIGIT_W = 5;
localparam DIGIT_H = 9;
 
wire [15:0] drawW = DIGIT_W * scale;
wire [15:0] drawH = DIGIT_H * scale;
 
reg [3:0] hundreds;
reg [3:0] tens;
reg [3:0] ones;
 
integer i;
reg [27:0] shift;
 
always @(*) begin
    shift = 0;
    shift[15:0] = number;
 
    for (i = 0; i < 16; i = i + 1) begin
        if (shift[19:16] >= 5) shift[19:16] = shift[19:16] + 3;
        if (shift[23:20] >= 5) shift[23:20] = shift[23:20] + 3;
        if (shift[27:24] >= 5) shift[27:24] = shift[27:24] + 3;
        shift = shift << 1;
    end
 
    hundreds = shift[27:24];
    tens     = shift[23:20];
    ones     = shift[19:16];
end
 
wire [3:0] digit0 = hundreds;
wire [3:0] digit1 = tens;
wire [3:0] digit2 = ones;
 
wire [15:0] digitX0 = baseX;
wire [15:0] digitX1 = baseX + drawW + 2;
wire [15:0] digitX2 = baseX + (drawW << 1) + 4;
wire [15:0] digitY  = baseY;
 
wire use0 = (pixelX >= digitX0 && pixelX < digitX0 + drawW);
wire use1 = (pixelX >= digitX1 && pixelX < digitX1 + drawW);
wire use2 = (pixelX >= digitX2 && pixelX < digitX2 + drawW);
 
wire [1:0] active_digit =
    use0 ? 2'd0 :
    use1 ? 2'd1 :
    use2 ? 2'd2 : 2'd3;
 
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
 
wire [31:0] rom0, rom1, rom2;
 
glyph_rom
#(.DATA_WIDTH(24), .ADDR_WIDTH(14), .ROM_FILE("sevenSeg.hex"))
digit_rom0
(
    .clk(clk50),
    .addr(digit0 * (DIGIT_W * DIGIT_H) + (spriteY * DIGIT_W + spriteX)),
    .q(rom0)
);
 
glyph_rom
#(.DATA_WIDTH(24), .ADDR_WIDTH(14), .ROM_FILE("sevenSeg.hex"))
digit_rom1
(
    .clk(clk50),
    .addr(digit1 * (DIGIT_W * DIGIT_H) + (spriteY * DIGIT_W + spriteX)),
    .q(rom1)
);
 
glyph_rom
#(.DATA_WIDTH(24), .ADDR_WIDTH(14), .ROM_FILE("sevenSeg.hex"))
digit_rom2
(
    .clk(clk50),
    .addr(digit2 * (DIGIT_W * DIGIT_H) + (spriteY * DIGIT_W + spriteX)),
    .q(rom2)
);
 
reg [31:0] rom_data;
wire [7:0] h_b = {highlightColor[4:0], 3'b000};
wire [7:0] h_g = {highlightColor[10:5], 2'b00};
wire [7:0] h_r = {highlightColor[15:11], 3'b000};
 
always @(*) begin
    pixelR = 8'd0;
    pixelG = 8'd0;
    pixelB = 8'd0;
    rom_data = 32'd0;
 
    if (active_digit != 3 && in_bounds) begin
        case (active_digit)
            0: rom_data = rom0;
            1: rom_data = rom1;
            2: rom_data = rom2;
            default: rom_data = 32'd0;
        endcase
 
        pixelR = (rom_data[23:16] == 0) ? 8'd0 :
                 ((rom_data[23:16] + h_r > 8'd255) ? 8'd255 : rom_data[23:16] + h_r);
        pixelG = (rom_data[15:8]  == 0) ? 8'd0 :
                 ((rom_data[15:8]  + h_g > 8'd255) ? 8'd255 : rom_data[15:8]  + h_g);
        pixelB = (rom_data[7:0]   == 0) ? 8'd0 :
                 ((rom_data[7:0]   + h_b > 8'd255) ? 8'd255 : rom_data[7:0]   + h_b);
    end
end
 
endmodule