// From: docs/design/cdc-reusable-patterns.md §2.4 — km_hssi_pulse_cross (single-cycle pulse CDC)

module km_hssi_pulse_cross_inst_example (
    input  logic src_clk,
    input  logic src_rst_n,
    input  logic dst_clk,
    input  logic dst_rst_n,
    input  logic event_pulse,
    output logic pulse_in_dst,
    output logic ready_for_next
);

    km_hssi_pulse_cross u_pulse_cross (
        .i_clk           (src_clk),
        .i_rstn          (src_rst_n),
        .i_pulse         (event_pulse),
        .i_oclk          (dst_clk),
        .i_early_pulse   (1'b0),
        .i_orstn         (dst_rst_n),
        .o_next_i_pulse  (ready_for_next),
        .o_out_pulse     (pulse_in_dst)
    );

endmodule
