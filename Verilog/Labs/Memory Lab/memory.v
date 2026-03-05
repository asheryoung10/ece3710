
module memory
#(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 10
)
(
    // -------- Port A --------
    input  [ADDR_WIDTH-1:0] addr_a,
    input  [DATA_WIDTH-1:0] din_a,
    input                   en_a,
    input                   we_a,
    output reg [DATA_WIDTH-1:0] dout_a,

    // -------- Port B --------
    input  [ADDR_WIDTH-1:0] addr_b,
    input  [DATA_WIDTH-1:0] din_b,
    input                   en_b,
    input                   we_b,
    output reg [DATA_WIDTH-1:0] dout_b,

    // -------- Clock --------
    input clk
);

    // 1024 x 16-bit RAM (2 BRAM blocks × 512 words)
    reg [DATA_WIDTH-1:0] ram [0:(1<<ADDR_WIDTH)-1];

    // --------------------------------------------------
    // Memory Initialization
    // --------------------------------------------------
    initial begin
        // Hex or binary file is fine
        // Example: mem_init.hex
        $readmemh("mem_init.text", ram);
    end

    // --------------------------------------------------
    // Port A : Read / Write
    // --------------------------------------------------
    always @(posedge clk) begin
        if (en_a) begin
            if (we_a) begin
                ram[addr_a] <= din_a;   // Write
                dout_a      <= din_a;   // Write-through
            end
            else begin
                dout_a <= ram[addr_a];  // Read
            end
        end
    end

    // --------------------------------------------------
    // Port B : Read / Write
    // --------------------------------------------------
    always @(posedge clk) begin
        if (en_b) begin
            if (we_b) begin
                ram[addr_b] <= din_b;   // Write
                dout_b      <= din_b;   // Write-through
            end
            else begin
                dout_b <= ram[addr_b];  // Read
            end
        end
    end

endmodule
