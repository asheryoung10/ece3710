module mux4
#(
    parameter DATA_WIDTH = 16
)
(
    input  [1:0] select,
    input  [DATA_WIDTH-1:0] selection0,
    input  [DATA_WIDTH-1:0] selection1,
    input  [DATA_WIDTH-1:0] selection2,
    input  [DATA_WIDTH-1:0] selection3,
    output [DATA_WIDTH-1:0] selection
);

assign selection =
    (select == 2'b00) ? selection0 :
    (select == 2'b01) ? selection1 :
    (select == 2'b10) ? selection2 :
                        selection3;

endmodule