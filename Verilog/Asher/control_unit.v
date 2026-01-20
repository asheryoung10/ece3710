module control_unit (
    input  wire        clk,
    input  wire        rst,

    // Instruction interface
    input  wire [15:0] ir,        // instruction from instruction_register

    // Register file interface
    output reg  [3:0]  rf_raddr_a,
    output reg  [3:0]  rf_raddr_b,
    input  wire [15:0] rf_rdata_a,
    input  wire [15:0] rf_rdata_b,
    output reg  [3:0]  rf_waddr,
    output reg  [15:0] rf_wdata,
    output reg         rf_we,

    // ALU interface
    output reg  [3:0]  alu_op,
    output reg  [15:0] alu_a,
    output reg  [15:0] alu_b,
    input  wire [15:0] alu_result,

    // Data memory interface
    output reg         mem_we,
    output reg  [15:0] mem_addr,
    output reg  [15:0] mem_wdata,
    input  wire [15:0] mem_rdata,

    // Program counter interface
    output reg  [15:0] pc_next,
    output reg         pc_we
);

    // -------------------------------
    // FSM states
    // -------------------------------
 // -------------------------------
// FSM states (Verilog-2001 style)
// -------------------------------
localparam FETCH       = 4'd0;
localparam DECODE      = 4'd1;
localparam EXEC_ALU    = 4'd2;
localparam EXEC_MEM_RD = 4'd3;
localparam EXEC_MEM_WR = 4'd4;
localparam EXEC_BRANCH = 4'd5;
localparam WRITEBACK   = 4'd6;
localparam HALT        = 4'd7;

// current and next state registers
reg [3:0] state, next_state;



    // -------------------------------
    // FSM sequential logic
    // -------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= FETCH;
        end else begin
            state <= next_state;
        end
    end

    // -------------------------------
    // FSM combinational logic
    // -------------------------------
    always @(*) begin
        // default outputs
        rf_raddr_a  = 4'b0000;
        rf_raddr_b  = 4'b0000;
        rf_waddr    = 4'b0000;
        rf_wdata    = 16'b0;
        rf_we       = 1'b0;

        alu_op      = 4'b0000;
        alu_a       = 16'b0;
        alu_b       = 16'b0;

        mem_we      = 1'b0;
        mem_addr    = 16'b0;
        mem_wdata   = 16'b0;

        pc_next     = 16'b0;
        pc_we       = 1'b0;

        // FSM transitions
        case (state)
            FETCH: begin
                // Prepare to fetch instruction
                pc_we     = 1'b1;
                pc_next   = pc_next + 16'd1;
                next_state = DECODE;
            end

            DECODE: begin
                // Decode instruction opcode
                case (ir[15:12])   // high nibble = opcode
                    4'b0000: next_state = EXEC_ALU;     // ADD, SUB, etc
                    4'b0100: begin
                        if (ir[7:4] == 4'b0000)          // LOAD
                            next_state = EXEC_MEM_RD;
                        else if (ir[7:4] == 4'b0100)     // STOR
                            next_state = EXEC_MEM_WR;
                        else
                            next_state = FETCH;
                    end
                    4'b1100: next_state = EXEC_BRANCH;   // Bcond
                    default: next_state = FETCH;
                endcase
            end

            EXEC_ALU: begin
                // Set ALU inputs
                rf_raddr_a = ir[3:0];   // Rsrc
                rf_raddr_b = ir[11:8];  // Rdest
                alu_a = rf_rdata_b;
                alu_b = rf_rdata_a;
                alu_op = ir[7:4];       // simplified for skeleton
                next_state = WRITEBACK;
            end

            EXEC_MEM_RD: begin
                // LOAD
                rf_raddr_a = ir[3:0];   // Raddr
                mem_addr   = rf_rdata_a;
                next_state = WRITEBACK;
            end

            EXEC_MEM_WR: begin
                // STOR
                rf_raddr_a = ir[3:0];   // Rsrc
                rf_raddr_b = ir[11:8];  // Raddr
                mem_addr   = rf_rdata_b;
                mem_wdata  = rf_rdata_a;
                mem_we     = 1'b1;
                next_state = FETCH;
            end

            EXEC_BRANCH: begin
                // Conditional branch
                // placeholder: compute pc_next based on condition flags
                pc_next = pc_next; // TODO: compute branch target
                pc_we   = 1'b1;
                next_state = FETCH;
            end

            WRITEBACK: begin
                // Write ALU or memory results back to register file
                rf_waddr = ir[11:8];     // Rdest
                case (ir[15:12])
                    4'b0000: rf_wdata = alu_result;    // ALU result
                    4'b0100: rf_wdata = mem_rdata;     // LOAD result
                    default: rf_wdata = 16'b0;
                endcase
                rf_we = 1'b1;
                next_state = FETCH;
            end

            HALT: begin
                next_state = HALT;
            end

            default: next_state = FETCH;
        endcase
    end

endmodule
