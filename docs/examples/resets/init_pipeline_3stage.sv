// From: docs/design/cdc-reusable-patterns.md §4.2 Pipelined Initialization Sequence

module init_pipeline_3stage (
    input  logic clk,
    input  logic rst_n,
    input  logic i_enable,
    output logic init,
    output logic init_d1,
    output logic init_d2
);

    logic enable_d1;
    logic init_next;

    assign init_next = !enable_d1 && i_enable;

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            enable_d1 <= 1'b0;
            init      <= 1'b0;
            init_d1   <= 1'b0;
            init_d2   <= 1'b0;
        end else begin
            enable_d1 <= i_enable;
            init      <= init_next;
            init_d1   <= init;
            init_d2   <= init_d1;
        end
    end

endmodule
