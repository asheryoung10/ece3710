`timescale 1ns / 1ps

module tb_bram;

    // Parameters
    localparam DATA_WIDTH = 16;
    localparam ADDR_WIDTH = 9;

    // DUT signals
    reg  [DATA_WIDTH-1:0] data_a, data_b;
    reg  [ADDR_WIDTH-1:0] addr_a, addr_b;
    reg  we_a, we_b;
    reg  clk;
    wire [DATA_WIDTH-1:0] q_a, q_b;

    // Instantiate DUT
    bram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .data_a(data_a),
        .data_b(data_b),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .we_a(we_a),
        .we_b(we_b),
        .clk(clk),
        .q_a(q_a),
        .q_b(q_b)
    );

    // Clock generation (10 ns period)
    always #5 clk = ~clk;

    // Task: check expected value
    task check;
        input [DATA_WIDTH-1:0] actual;
        input [DATA_WIDTH-1:0] expected;
        input [255:0] msg;
        begin
            if (actual !== expected) begin
                $display("❌ FAIL: %s | expected=%h got=%h",
                          msg, expected, actual);
            end else begin
                $display("✅ PASS: %s | value=%h", msg, actual);
            end
        end
    endtask

    initial begin
        // Init signals
        clk    = 0;
        we_a   = 0;
        we_b   = 0;
        data_a = 0;
        data_b = 0;
        addr_a = 0;
        addr_b = 0;

        // Wait for RAM init
        @(posedge clk);

        // --------------------------------------------------
        // Test 1: Initial contents
        // ram[i] = i[15:0]
        // --------------------------------------------------
        addr_a = 9'd10;
        addr_b = 9'd20;
        @(posedge clk);
        check(q_a, 16'd10, "Initial read Port A");
        check(q_b, 16'd20, "Initial read Port B");

        // --------------------------------------------------
        // Test 2: Write on Port A
        // --------------------------------------------------
        we_a   = 1;
        addr_a = 9'd5;
        data_a = 16'hABCD;
        @(posedge clk);
        we_a = 0;

        // Read back
        addr_a = 9'd5;
        @(posedge clk);
        check(q_a, 16'hABCD, "Write/read Port A");

        // --------------------------------------------------
        // Test 3: Write on Port B
        // --------------------------------------------------
        we_b   = 1;
        addr_b = 9'd7;
        data_b = 16'h1234;
        @(posedge clk);
        we_b = 0;

        // Read back
        addr_b = 9'd7;
        @(posedge clk);
        check(q_b, 16'h1234, "Write/read Port B");

        // --------------------------------------------------
        // Test 4: Simultaneous writes
        // --------------------------------------------------
        we_a   = 1;
        we_b   = 1;
        addr_a = 9'd100;
        addr_b = 9'd200;
        data_a = 16'hAAAA;
        data_b = 16'hBBBB;
        @(posedge clk);
        we_a = 0;
        we_b = 0;

        // Read back
        addr_a = 9'd100;
        addr_b = 9'd200;
        @(posedge clk);
        check(q_a, 16'hAAAA, "Simultaneous write A");
        check(q_b, 16'hBBBB, "Simultaneous write B");

        // --------------------------------------------------
        // Test 5: Read-after-write (same cycle behavior)
        // q_* should output written data
        // --------------------------------------------------
        we_a   = 1;
        addr_a = 9'd50;
        data_a = 16'hDEAD;
        @(posedge clk);
        check(q_a, 16'hDEAD, "Read-after-write Port A");
        we_a = 0;

        // --------------------------------------------------
        $display("\n🎉 All tests completed.");
        $finish;
    end

endmodule
