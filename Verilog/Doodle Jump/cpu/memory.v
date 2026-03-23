module memory
#(
    parameter DATA_WIDTH = 16,
    parameter INIT_FILE = "init_mem.text"
)
(
    input clock,
    input writeEnable,
    input [15:0] writeData,
    input [15:0] readWriteAddress,
    output reg [15:0] contents,

    input [9:0] vgaX,
    input [9:0] vgaY,
    output reg [7:0] r,
    output reg [7:0] g,
    output reg [7:0] b
);

// --------------------
// BRAM (10-bit address)
// --------------------
reg [DATA_WIDTH-1:0] ram[0:1023];

initial begin
    $readmemh(INIT_FILE, ram);
end

// --------------------
// Rectangle registers
// --------------------
reg [15:0] rect_x [0:7];
reg [15:0] rect_y [0:7];
reg [7:0]  rect_w [0:7];
reg [7:0]  rect_h [0:7];

localparam RECT_BASE = 16'h8000;

// --------------------
// Memory access
// --------------------
integer idx;
wire in_bram  = (readWriteAddress < 16'd1024);
wire in_rect  = (readWriteAddress >= RECT_BASE &&
                 readWriteAddress < RECT_BASE + 32);

always @(posedge clock)
begin
    if (writeEnable) begin

        if (in_rect) begin
            idx = (readWriteAddress - RECT_BASE) >> 2;

            case ((readWriteAddress - RECT_BASE) & 2'b11)
                2'd0: rect_x[idx] <= writeData;
                2'd1: rect_y[idx] <= writeData;
                2'd2: begin
                    rect_w[idx] <= writeData[15:8];
                    rect_h[idx] <= writeData[7:0];
                end
            endcase

            contents <= writeData;

        end else if (in_bram) begin
            ram[readWriteAddress[9:0]] <= writeData;
            contents <= writeData;

        end else begin
            contents <= 16'd0;
        end

    end else begin

        if (in_rect) begin
            idx = (readWriteAddress - RECT_BASE) >> 2;

            case ((readWriteAddress - RECT_BASE) & 2'b11)
                2'd0: contents <= rect_x[idx];
                2'd1: contents <= rect_y[idx];
                2'd2: contents <= {rect_w[idx], rect_h[idx]};
                default: contents <= 16'd0;
            endcase

        end else if (in_bram) begin
            contents <= ram[readWriteAddress[9:0]];

        end else begin
            contents <= 16'd0;
        end
    end
end

// --------------------
// VGA Rendering
// --------------------
integer i;
reg hit;

always @(*) begin
    r = 0;
    g = 0;
    b = 0;
    hit = 0;

    for (i = 0; i < 8; i = i + 1) begin
        if (!hit) begin
            if (vgaX >= rect_x[i][9:0] &&
                vgaX < rect_x[i][9:0] + rect_w[i] &&
                vgaY >= rect_y[i][9:0] &&
                vgaY < rect_y[i][9:0] + rect_h[i]) begin

                // Color from upper bits
                r = {rect_x[i][15:12], 4'b0000};
                g = {rect_y[i][15:12], 4'b0000};
                b = {rect_x[i][11:8],  4'b0000};

                hit = 1;
            end
        end
    end
end


integer j;

initial begin
    // Rectangle size
    for (j = 0; j < 8; j = j + 1) begin
        rect_w[j] = 8'd80;
        rect_h[j] = 8'd120;
    end

    // Row 0 (top)
    rect_x[0] = {4'hF, 12'd40};   rect_y[0] = {4'h1, 12'd60};
    rect_x[1] = {4'hE, 12'd200};  rect_y[1] = {4'h2, 12'd60};
    rect_x[2] = {4'hD, 12'd360};  rect_y[2] = {4'h3, 12'd60};
    rect_x[3] = {4'hC, 12'd520};  rect_y[3] = {4'h4, 12'd60};

    // Row 1 (bottom)
    rect_x[4] = {4'hB, 12'd40};   rect_y[4] = {4'h5, 12'd300};
    rect_x[5] = {4'hA, 12'd200};  rect_y[5] = {4'h6, 12'd300};
    rect_x[6] = {4'h9, 12'd360};  rect_y[6] = {4'h7, 12'd300};
    rect_x[7] = {4'h8, 12'd520};  rect_y[7] = {4'h8, 12'd300};
end

endmodule
