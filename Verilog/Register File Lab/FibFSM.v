module FibFSM #(
    parameter BIT_WIDTH    = 16,
    parameter SEL_WIDTH    = 4,
    parameter OPCODE_WIDTH = 8
)(
    input  wire clk,
    input  wire reset,
    input  wire [3:0] userInput,

    // Regfile control
    output reg [SEL_WIDTH-1:0] SrcAddr,
    output reg [SEL_WIDTH-1:0] DestAddr,
    output reg [SEL_WIDTH-1:0] WriteAddr,

    // Control signals
    output reg regReset,
    output reg regWriteEn,
    output reg ImmMuxSel,

    // Immediate and opcode
    output reg [BIT_WIDTH-1:0]    ImmData,
    output reg [OPCODE_WIDTH-1:0] op,
    output reg [2:0] outputState
);

    // --------------------------------------------------
    // State encoding
    // --------------------------------------------------
    localparam INIT_REGS = 3'b000;
    localparam INIT_R1   = 3'b001;
    localparam CALC_FIB  = 3'b010;
    localparam DONE      = 3'b011;

    reg [2:0] state;
    reg [SEL_WIDTH-1:0] regIndex;

    // --------------------------------------------------
    // Single sequential FSM
    // --------------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state       <= INIT_REGS;
            regIndex    <= 4'd2;

            // defaults
            regReset    <= 1'b0;
            regWriteEn  <= 1'b0;
            ImmMuxSel   <= 1'b0;
            SrcAddr     <= 0;
            DestAddr    <= 0;
            WriteAddr   <= 0;
            ImmData     <= 0;
            op          <= 0;
            outputState <= INIT_REGS;
        end else begin
            // defaults every cycle
            regReset    <= 1'b0;
            regWriteEn  <= 1'b0;
            ImmMuxSel   <= 1'b0;
            SrcAddr     <= 0;
            DestAddr    <= 0;
            WriteAddr   <= 0;
            ImmData     <= 0;
            op          <= 0;
            outputState <= state;

            case (state)
                // --------------------------------------
                // Zero all registers
                // --------------------------------------
                INIT_REGS: begin
                    regReset <= 1'b1;
                    state    <= INIT_R1;
                end

                // --------------------------------------
                // r1 = 1
                // --------------------------------------
                INIT_R1: begin
                    regWriteEn <= 1'b1;
                    ImmMuxSel  <= 1'b1;
                    WriteAddr  <= 4'd1;
                    ImmData    <= 16'd1;
                    op         <= 8'b0000_0101; // ADD

                    state      <= CALC_FIB;
                end

                // --------------------------------------
                // r[n] = r[n-1] + r[n-2]
                // --------------------------------------
                CALC_FIB: begin
                    regWriteEn <= 1'b1;
                    SrcAddr    <= regIndex - 2;
                    DestAddr   <= regIndex - 1;
                    WriteAddr  <= regIndex;
                    op         <= 8'b0000_0101; // ADD

                    if (regIndex == 4'd15) begin
                        state <= DONE;
                    end else begin
                        regIndex <= regIndex + 1'b1;
                    end
                end

                // --------------------------------------
                // DONE: read register selected by switches
                // --------------------------------------
                DONE: begin
                    SrcAddr <= userInput;
                    state   <= DONE;
                end

                default: begin
                    state <= INIT_REGS;
                end
            endcase
        end
    end

endmodule
