`timescale 1ns / 1ps

module tb_seven_seg_decoder;

    reg  [3:0] bin;
    wire [7:0] hex;

    // Instantiate the DUT (Device Under Test)
    seven_seg_decoder dut (
        .bin(bin),
        .hex(hex)
    );

    initial begin
        // Optional: waveform dump (for GTKWave / ModelSim)
        $dumpfile("seven_seg_decoder.vcd");
        $dumpvars(0, tb_seven_seg_decoder);

        // Test all possible 4-bit inputs
        bin = 4'h0; #10;
        bin = 4'h1; #10;
        bin = 4'h2; #10;
        bin = 4'h3; #10;
        bin = 4'h4; #10;
        bin = 4'h5; #10;
        bin = 4'h6; #10;
        bin = 4'h7; #10;
        bin = 4'h8; #10;
        bin = 4'h9; #10;
        bin = 4'hA; #10;
        bin = 4'hB; #10;
        bin = 4'hC; #10;
        bin = 4'hD; #10;
        bin = 4'hE; #10;
        bin = 4'hF; #10;

        // End simulation
        $finish;
    end

endmodule
