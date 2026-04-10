module playerMemory (
    input  wire       clk50,
    input  wire [9:0] playerX, // sprite position X on screen
    input  wire [9:0] playerY, // sprite position Y on screen
	 input wire  [15:0] highlightColor,
    input  wire [9:0] pixelX,  // current pixel being fetched
    input  wire [9:0] pixelY,  // current pixel being fetched
    input  wire [3:0] playerAnimationIndex, // animation frame index
    output reg  [7:0] playerPixelR,
    output reg  [7:0] playerPixelG,
    output reg  [7:0] playerPixelB
);

reg [7:0] r_next, g_next, b_next;
localparam PLAYER_WIDTH = 45;
localparam PLAYER_HEIGHT = 41;

wire [31:0] rom_data;
wire [15:0] relativeToPlayerX;
wire [15:0] relativeToPlayerY;
assign relativeToPlayerX = pixelX - playerX;
assign relativeToPlayerY = pixelY - playerY;


glyph_rom glyph_rom_instance(
	.clk(clk50), 
	.addr(
		(playerAnimationIndex * (PLAYER_HEIGHT * PLAYER_WIDTH)) +
		relativeToPlayerX + 1 + 
		(relativeToPlayerY * PLAYER_WIDTH)
		),
	.q(rom_data)
);
// Generate 32x32 square at player position
always @(posedge clk50) begin
    if ((pixelX >= playerX) && (pixelX < playerX + PLAYER_WIDTH) &&
        (pixelY >= playerY) && (pixelY < playerY + PLAYER_HEIGHT)) begin
        // Change color based on animation index
        // Red fixed, green varies, blue varies for fun
		  if(rom_data[7:0] == 0) begin
		  b_next <= rom_data[7:0];
		  end else begin
		          b_next <= rom_data[7:0]    + {highlightColor[4:0],   3'b000};                

		  end
		   if(rom_data[15:8] == 0) begin
		  g_next <= rom_data[15:8];
		  end else begin
		          g_next <= rom_data[15:8] + {highlightColor[10:5],  2'b00};  

		  end
		   if(rom_data[23:16] == 0) begin
		  r_next <= rom_data[23:16];
		  end else begin
		          r_next <= rom_data[23:16] + {highlightColor[15:11], 3'b000};

		  end

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