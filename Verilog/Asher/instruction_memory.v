module instruction_memory (
    input  wire [15:0] addr,      // PC value
    output wire [15:0] instr
);

    // 1024 x 16-bit instruction memory
    reg [15:0] mem [0:1023];

    initial begin
        // Load program here
        // Example: $readmemh("program.hex", mem);
    end

    // Word-addressed (lower bits ignored)
    assign instr = mem[addr[9:0]];

endmodule
