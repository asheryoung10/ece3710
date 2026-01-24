module register_file #(
    parameter BIT_WIDTH = 16
)(
    input  wire                    clk,
    input  wire                    reset,
    input  wire                    writeEn,

    input  wire [BIT_WIDTH-1:0]    writeData,
    input  wire [3:0]              addrDest,
    input  wire [3:0]              addrSrc,
    input  wire [3:0]              WriteAddr,

    output reg  [BIT_WIDTH-1:0]    Rdest,
    output reg  [BIT_WIDTH-1:0]    Rsrc
);

    // --------------------------------------------------
    // 16 registers, each BIT_WIDTH bits wide
    // --------------------------------------------------
    reg [BIT_WIDTH-1:0] regs [0:15];
    integer i;

    // --------------------------------------------------
    // Synchronous write + synchronous reset
    // --------------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1)
                regs[i] <= {BIT_WIDTH{1'b0}};
        end
        else if (writeEn) begin
            regs[WriteAddr] <= writeData;
        end
    end

    // --------------------------------------------------
    // Asynchronous read ports
    // --------------------------------------------------
    always @(*) begin
        Rdest = regs[addrDest];
        Rsrc  = regs[addrSrc];
    end

endmodule
