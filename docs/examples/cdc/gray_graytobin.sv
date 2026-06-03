// From: docs/design/cdc-reusable-patterns.md §5.2

module km_hssi_graytobin #(
    parameter WIDTH = 2
) (
    input  wire [WIDTH-1:0] data_in,
    output wire [WIDTH-1:0] data_out
);
    genvar i;
    generate
        for (i = 0; i <= (WIDTH-1); i = i+1) begin : GRAY_TO_BIN
            assign data_out[i] = ^(data_in >> i);
        end
    endgenerate
endmodule
