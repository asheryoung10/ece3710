`timescale 1ns/1ps

module input_synchronizer #
(
    parameter WIDTH = 1
)
(
    input wire clk,
    input wire rst,
    input wire [WIDTH-1:0] async_in,
    output reg [WIDTH-1:0] sync_out
);

// Hold the first synchronization stage for the asynchronous input bus.
reg [WIDTH-1:0] stage1;

// Resynchronize the external inputs through two clocked stages.
always @(posedge clk or posedge rst) begin
    if (rst) begin
        stage1 <= {WIDTH{1'b0}};
        sync_out <= {WIDTH{1'b0}};
    end else begin
        stage1 <= async_in;
        sync_out <= stage1;
    end
end

endmodule
