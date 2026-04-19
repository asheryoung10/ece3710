module score_tracker (
    input  wire        clk,
    input  wire        reset,
    input  wire        sample_tick,
    input  wire [15:0] y_pos,
    input  wire        position_valid,
    output wire [15:0] score
);
 
reg        started;
reg [15:0] start_y;
reg [15:0] best_y;
 
always @(posedge clk or posedge reset) begin
    if (reset) begin
        started <= 1'b0;
        start_y <= 16'd0;
        best_y  <= 16'd0;
    end else if (sample_tick) begin
        if (!started) begin
            if (position_valid) begin
                started <= 1'b1;
                start_y <= y_pos;
                best_y  <= y_pos;
            end
        end else if (y_pos < best_y) begin
            best_y <= y_pos;
        end
    end
end
 
assign score = (started && (start_y > best_y)) ? (best_y - start_y) : 16'd0;
 
endmodule
