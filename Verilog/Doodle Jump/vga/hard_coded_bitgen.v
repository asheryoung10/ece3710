module hard_coded_bitgen (
    input wire          vga_blank_n,
    input wire [9:0]    hcount, 
    input wire [9:0]    vcount,
    output [23:0]       rgb
);

// Constant for box size in each corner
parameter CORNERS_SIZE = 10; // You can adjust this value to control the box size

reg [7:0] r, g, b;
assign rgb = {r, g, b};

wire [9:0] x_pos, y_pos;

parameter H_SYNC        = 10'd96;  // Horizontal Sync Region -- 96 pixels
parameter H_BACK_PORCH  = 10'd48;  // Horizontal Back Porch -- 48 pixels
parameter H_DISPLAY     = 10'd640; // Horizontal Display Region -- 640 pixels
parameter H_FRONT_PORCH = 10'd16;  // Horizontal Front Porch -- 16 pixels
parameter H_TOTAL       = 10'd800; // Horizontal Total Width -- 96 + 16 + 640 + 48 = 800 pixels

parameter V_SYNC        = 10'd2;   // Vertical Sync Region -- 2 lines
parameter V_BACK_PORCH  = 10'd33;  // Vertical Back Porch -- 33 lines
parameter V_DISPLAY     = 10'd480; // Vertical Display Region -- 480 lines
parameter V_FRONT_PORCH = 10'd10;  // Vertical Front Porch -- 10 lines
parameter V_TOTAL       = 10'd525; // Vertical Total Width -- 2 + 33 + 480 + 10 = 525 lines

assign x_pos = hcount - (H_SYNC + H_BACK_PORCH);
assign y_pos = vcount - (V_SYNC + V_BACK_PORCH)+1;
always @(vga_blank_n, x_pos, y_pos) begin
    {r, g, b} = 0; // Default to black
    if (vga_blank_n) begin
     
        // Draws boxes in each corner with adjustable size
        // Top-left corner box (adjusted to 640x480 resolution)
        if ((x_pos >= 0) && (x_pos < CORNERS_SIZE) && (y_pos >= 0) && (y_pos < CORNERS_SIZE)) begin
            r = 8'd255; // Red for top-left box
        end
        // Top-right corner box (adjusted to 640x480 resolution)
        else if ((x_pos >= 640 - CORNERS_SIZE) && (x_pos < 640) && (y_pos >= 0) && (y_pos < CORNERS_SIZE)) begin
            g = 8'd255; // Green for top-right box
        end
        // Bottom-left corner box (adjusted to 640x480 resolution)
        else if ((x_pos >= 0) && (x_pos < CORNERS_SIZE) && (y_pos >= 480 - CORNERS_SIZE) && (y_pos < 480)) begin
            b = 8'd255; // Blue for bottom-left box
        end
        // Bottom-right corner box (adjusted to 640x480 resolution)
        else if ((x_pos >= 640 - CORNERS_SIZE) && (x_pos < 640) && (y_pos >= 480 - CORNERS_SIZE) && (y_pos < 480)) begin
            r = 8'd255; // Red for bottom-right box
            g = 8'd255; // Green for bottom-right box (blending red and green makes yellow)
        end
        else begin
				if(x_pos[4:0] == 0 || y_pos [4:0] == 0) begin
					r = 8'd255;
					g = 8'd255;
					b = 8'd255;
				end else begin
					r = 8'd0;
					g = 8'd0;
					b = 8'd0;
				end
            
        end
    end
end

endmodule