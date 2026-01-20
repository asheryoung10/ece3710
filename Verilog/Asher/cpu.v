module cpu (
    input  wire clk,
    input  wire rst
);

    // -------------------------------
    // Wires between modules
    // -------------------------------
    wire [15:0] pc_curr;
    wire [15:0] pc_next;
    wire        pc_we;

    wire [15:0] ir_out;   // instruction register output

    // Register File signals
    wire [3:0]  rf_raddr_a;
    wire [3:0]  rf_raddr_b;
    wire [3:0]  rf_waddr;
    wire [15:0] rf_rdata_a;
    wire [15:0] rf_rdata_b;
    wire [15:0] rf_wdata;
    wire        rf_we;

    // ALU signals
    wire [15:0] alu_a;
    wire [15:0] alu_b;
    wire [7:0]  alu_opcode;
    wire [15:0] alu_result;
    wire [4:0]  alu_flags;

    // Data memory signals
    wire [15:0] mem_addr;
    wire [15:0] mem_wdata;
    wire [15:0] mem_rdata;
    wire        mem_we;

    // Program Flags signals
    wire f_flag, l_flag, c_flag, n_flag, z_flag;
    wire flags_we;

    // -------------------------------
    // Program Counter
    // -------------------------------
    program_counter pc_inst (
        .clk(clk),
        .rst(rst),
        .we(pc_we),
        .pc_next(pc_next),
        .pc_curr(pc_curr)
    );

    // -------------------------------
    // Instruction Memory
    // -------------------------------
    instruction_memory imem (
        .addr(pc_curr),
        .instr(ir_out)
    );

    // -------------------------------
    // Instruction Register
    // -------------------------------
    instruction_register ir_inst (
        .clk(clk),
        .rst(rst),
        .we(1'b1),         // always latch instruction
        .instr_in(ir_out),
        .instr_out(ir_out)
    );

    // -------------------------------
    // Register File
    // -------------------------------
    register_file rf (
        .clk(clk),
        .rst(rst),
        .raddr_a(rf_raddr_a),
        .raddr_b(rf_raddr_b),
        .waddr(rf_waddr),
        .wdata(rf_wdata),
        .we(rf_we),
        .rdata_a(rf_rdata_a),
        .rdata_b(rf_rdata_b)
    );

    // -------------------------------
    // ALU
    // -------------------------------
    alu alu_inst (
        .Rsrc_Imm(alu_a),
        .Rdest(alu_b),
        .Opcode(alu_opcode),
        .Result(alu_result),
        .Flags(alu_flags)
    );

    // -------------------------------
    // Data Memory
    // -------------------------------
    data_memory dmem (
        .clk(clk),
        .rst(rst),
        .we(mem_we),
        .addr(mem_addr),
        .wdata(mem_wdata),
        .rdata(mem_rdata)
    );

    // -------------------------------
    // Program Flags
    // -------------------------------
    program_flags psr (
        .clk(clk),
        .rst(rst),
        .we(flags_we),
        .f_in(alu_flags[4]),
        .l_in(alu_flags[3]),
        .c_in(alu_flags[0]),
        .n_in(alu_flags[1]),
        .z_in(alu_flags[2]),
        .f(f_flag),
        .l(l_flag),
        .c(c_flag),
        .n(n_flag),
        .z(z_flag)
    );

    // -------------------------------
    // Control Unit
    // -------------------------------
    control_unit cu (
        .clk(clk),
        .rst(rst),
        .ir(ir_out),

        // Register File interface
        .rf_raddr_a(rf_raddr_a),
        .rf_raddr_b(rf_raddr_b),
        .rf_rdata_a(rf_rdata_a),
        .rf_rdata_b(rf_rdata_b),
        .rf_waddr(rf_waddr),
        .rf_wdata(rf_wdata),
        .rf_we(rf_we),

        // ALU interface
        .alu_op(alu_opcode),
        .alu_a(alu_a),
        .alu_b(alu_b),
        .alu_result(alu_result),

        // Data Memory interface
        .mem_we(mem_we),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata),

        // Program Counter interface
        .pc_next(pc_next),
        .pc_we(pc_we)
    );

endmodule
