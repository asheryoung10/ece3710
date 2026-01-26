module data_memory (
    input  wire        clk,
    input  wire        rst,
    
    // Write port
    input  wire        we,         // write enable
    input  wire [15:0] addr,       // memory address (word-addressed)
    input  wire [15:0] wdata,      // data to write
    
    // Read port
    output wire [15:0] rdata       // data read from memory
);

    // 1024 × 16-bit memory
    reg [15:0] mem [0:1023];

    integer i;

    // Reset memory (optional)
    always @(negedge clk) begin
        if (rst) begin
            for (i=0; i<1024; i=i+1)
                mem[i] <= 16'b0;
        end else if (we) begin
            mem[addr[9:0]] <= wdata;  // lower 10 bits for 1024 words
        end
    end

    // Asynchronous read
    assign rdata = mem[addr[9:0]];

endmodule
