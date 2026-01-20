module register_file (
    input  wire         clk,
    input  wire         rst,
    
    // Read ports
    input  wire  [3:0]  raddr_a,    // Read address A
    input  wire  [3:0]  raddr_b,    // Read address B
    output wire [15:0]  rdata_a,    // Read data A
    output wire [15:0]  rdata_b,    // Read data B
    
    // Write port
    input  wire  [3:0]  waddr,      // Write address
    input  wire [15:0]  wdata,      // Write data
    input  wire         we           // Write enable
);

    // 16 × 16-bit registers
    reg [15:0] regs [15:0];

    integer i;
    // Reset all registers (except R0)
    always @(posedge clk) begin
        if (rst) begin
            for (i=1; i<16; i=i+1)
                regs[i] <= 16'b0;
        end else if (we && waddr != 4'b0000) begin
            // Synchronous write, R0 is always 0
            regs[waddr] <= wdata;
        end
    end

    // Asynchronous read ports
    assign rdata_a = (raddr_a == 4'b0000) ? 16'b0 : regs[raddr_a];
    assign rdata_b = (raddr_b == 4'b0000) ? 16'b0 : regs[raddr_b];

endmodule