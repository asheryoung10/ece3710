module program_counter (
    input  wire        clk,
    input  wire        rst,
    input  wire        we,        // PC write enable
    input  wire [15:0] pc_next,   // next PC value
    output reg  [15:0] pc_curr
);

    always @(posedge clk) begin
        if (rst) begin
            pc_curr <= 16'b0;
        end else if (we) begin
            pc_curr <= pc_next;
        end
    end

endmodule
