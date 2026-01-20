module instruction_register (
    input  wire        clk,
    input  wire        rst,
    input  wire        we,          // write enable (from control unit)
    input  wire [15:0] instr_in,    // from instruction memory
    output reg  [15:0] instr_out    // latched instruction
);

    always @(posedge clk) begin
        if (rst) begin
            instr_out <= 16'b0;
        end else if (we) begin
            instr_out <= instr_in;
        end
    end

endmodule
