// From: docs/design/cdc-reusable-patterns.md §1.3 Toggle/Edge Detector
// Assumes i_ref_signal already passed through external 2-flop bitsync.

module toggle_edge_detector (
    input  logic       i_clk,
    input  logic       i_rst_n,
    input  logic       i_ref_signal,
    input  logic       cfg_toggle_mode,  // 1: any edge; 0: rising only
    output logic       tick
);

    logic ref_signal_d1;
    logic tick_next;

    assign tick_next = cfg_toggle_mode
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
