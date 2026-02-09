module mux2
#(
    parameter DATA_WIDTH = 16
)
(
    input select,
    input [DATA_WIDTH-1:0] selection0,
    input [DATA_WIDTH-1:0] selection1,
    output [DATA_WIDTH-1:0] selection
);

assign selection = select ? selection1 : selection0;

endmodule