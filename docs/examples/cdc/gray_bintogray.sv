// From: docs/design/cdc-reusable-patterns.md §5.1

module km_hssi_bintogray #(
    parameter WIDTH = 2
) (
    input  wire [WIDTH-1:0] data_in,
    output wire [WIDTH-1:0] data_out
);
    assign data_out = (data_in >> 1) ^ data_in;
endmodule
