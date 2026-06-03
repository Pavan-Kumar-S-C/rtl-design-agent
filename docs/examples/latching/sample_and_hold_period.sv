// From: docs/design/cdc-reusable-patterns.md §3.1 Sample-and-Hold on Tick Event

module sample_and_hold_period #(
    parameter int WIDTH = 32,
    parameter logic [WIDTH-1:0] INCREMENT = '1,
    parameter logic [WIDTH-1:0] RESET_VAL = '0
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic             enable,
    input  logic             sample_event,
    output logic [WIDTH-1:0] counter_sampled
);

    logic [WIDTH-1:0] counter;
    logic [WIDTH-1:0] counter_next;

    assign counter_next = sample_event ? RESET_VAL : (counter + INCREMENT);

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter         <= '0;
            counter_sampled <= '0;
        end else begin
            if (enable) begin
                counter <= counter_next;
            end
            if (sample_event) begin
                counter_sampled <= counter;
            end
        end
    end

endmodule
