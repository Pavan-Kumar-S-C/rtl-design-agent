// From: docs/design/cdc-reusable-patterns.md §3.3 Deterministic Pipeline with Tick Propagation

module tick_pipeline_3stage (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       active_tick,
    input  logic [31:0] raw_input,
    output logic [31:0] stage2_data
);

    logic active_tick_d1, active_tick_d2, active_tick_d3;
    logic [31:0] stage0_data, stage1_data;

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            active_tick_d1 <= 1'b0;
            active_tick_d2 <= 1'b0;
            active_tick_d3 <= 1'b0;
        end else begin
            active_tick_d1 <= active_tick;
            active_tick_d2 <= active_tick_d1;
            active_tick_d3 <= active_tick_d2;
        end
    end

    always_ff @(posedge clk) begin
        if (active_tick)
            stage0_data <= raw_input;
    end

    always_ff @(posedge clk) begin
        if (active_tick_d1)
            stage1_data <= stage0_data + 32'd1;  // placeholder process_a
    end

    always_ff @(posedge clk) begin
        if (active_tick_d2)
            stage2_data <= stage1_data + 32'd1;  // placeholder process_b
    end

endmodule
