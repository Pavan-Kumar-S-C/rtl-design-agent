// From: docs/design/cdc-reusable-patterns.md §1.1 — instantiation template
// Replace module name/parameters with your project cell if not using km_hssi_bitsync.

module km_hssi_bitsync_inst_example (
    input  logic       dst_clk,
    input  logic       dst_rst_n,
    input  logic       src_signal,
    output logic       dst_signal_sync
);

    km_hssi_bitsync #(
        .DWIDTH            (1),
        .RESET_VAL         (0),
        .DST_CLK_FREQ_MHZ  (500),
        .SRC_DATA_FREQ_MHZ (100)
    ) u_my_sync (
        .clk      (dst_clk),
        .rst_n    (dst_rst_n),
        .data_in  (src_signal),
        .data_out (dst_signal_sync)
    );

endmodule
