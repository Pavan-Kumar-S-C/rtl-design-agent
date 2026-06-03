// From: docs/design/km-xcvr-tod-analysis.md §2.1 — km_xcvr_mps_tod_counter reference tick

module km_xcvr_tick_detect (
    input  logic i_clk,
    input  logic i_rst_n,
    input  logic i_ref_signal,
    input  logic i_cfg_ref_time_toggle,
    output logic tick
);

    logic ref_signal_d1;
    logic tick_next;

    assign tick_next = i_cfg_ref_time_toggle
        ? (i_ref_signal ^ ref_signal_d1)
        : (i_ref_signal && !ref_signal_d1);

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            ref_signal_d1 <= 1'b0;
            tick          <= 1'b0;
        end else begin
            ref_signal_d1 <= i_ref_signal;
            tick          <= tick_next;
        end
    end

endmodule
