// From: docs/design/cdc-reusable-patterns.md §2.1 — km_hssi_vecsync_cdc instantiation template

module km_hssi_vecsync_cdc_inst_example (
    input  logic        cfg_clk,
    input  logic        core_clk,
    input  logic        rst_n,
    input  logic [31:0] cfg_register,
    output logic [31:0] cfg_register_sync
);

    km_hssi_vecsync_cdc #(
        .DWIDTH            (32),
        .RESET_VAL         (0),
        .SRC_CLK_FREQ_MHZ  (250),
        .DST_CLK_FREQ_MHZ  (500)
    ) u_cfg_sync (
        .i_wr_clk         (cfg_clk),
        .i_rst_n          (rst_n),
        .i_rd_clk         (core_clk),
        .i_data_in        (cfg_register),
        .i_dft_byprst_b   (1'b1),
        .i_dft_rstnbypen_b(1'b1),
        .i_dft_scan_mode  (1'b0),
        .o_data_out       (cfg_register_sync)
    );

endmodule
