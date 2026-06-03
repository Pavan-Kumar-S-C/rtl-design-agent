// From: docs/design/cdc-reusable-patterns.md §3.2 Software-Triggered Coherent Status Snapshot

module coherent_status_snapshot #(
    parameter int TOD_W = 96,
    parameter int FILTER_W = 64
) (
    input  logic                clk,
    input  logic                rst_n,
    input  logic                cfg_status_update,
    input  logic                internal_valid,
    input  logic [TOD_W-1:0]    internal_tod,
    input  logic [FILTER_W-1:0] internal_filter_state,
    output logic                sts_valid,
    output logic [TOD_W-1:0]    sts_tod,
    output logic [FILTER_W-1:0] sts_filter_state
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sts_valid        <= '0;
            sts_tod          <= '0;
            sts_filter_state <= '0;
        end else if (cfg_status_update) begin
            sts_valid        <= internal_valid;
            sts_tod          <= internal_tod;
            sts_filter_state <= internal_filter_state;
        end
    end

endmodule
