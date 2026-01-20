module program_flags (
    input  wire clk,
    input  wire rst,
    input  wire we,        // flag write enable

    input  wire f_in,      // overflow
    input  wire l_in,      // lower (borrow)
    input  wire c_in,      // carry
    input  wire n_in,      // negative
    input  wire z_in,      // zero

    output reg  f,
    output reg  l,
    output reg  c,
    output reg  n,
    output reg  z
);

    always @(posedge clk) begin
        if (rst) begin
            f <= 1'b0;
            l <= 1'b0;
            c <= 1'b0;
            n <= 1'b0;
            z <= 1'b0;
        end else if (we) begin
            f <= f_in;
            l <= l_in;
            c <= c_in;
            n <= n_in;
            z <= z_in;
        end
    end

endmodule
