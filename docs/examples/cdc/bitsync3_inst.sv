// From: docs/design/cdc-reusable-patterns.md §1.2 — 3-stage / higher-MTBF bit synchronizer
// Use when Quartus MTBF report is low or path is safety-critical (see metastability-mtbf.md).

module km_hssi_bitsync3_inst_example (
    input  logic       dst_clk,
    input  logic       dst_rst_n,
    input  logic       src_signal,
    output logic       dst_signal_sync
);

    km_hssi_bitsync3 #(
        .DWIDTH            (1),
        .RESET_VAL         (0),
        .DST_CLK_FREQ_MHZ  (500),
        .SRC_DATA_FREQ_MHZ (100)
    ) u_crit_sync (
        .clk      (dst_clk),
        .rst_n    (dst_rst_n),
        .data_in  (src_signal),
        .data_out (dst_signal_sync)
    );

endmodule
