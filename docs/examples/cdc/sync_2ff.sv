// Golden pattern: single-bit CDC synchronizer (2-flop)

module sync_2ff_sv (
    input  logic src_clk,
    input  logic src_rst_n,
    input  logic dst_clk,
    input  logic dst_rst_n,
    input  logic data_in,   // async to dst_clk — treat as CDC in
    output logic data_out   // synchronized to dst_clk
);

    (* async_reg = "true" *) logic meta_q;
    logic                    sync_q;

    // CDC: src domain -> dst domain (single bit)
    always_ff @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n) begin
            meta_q <= 1'b0;
            sync_q <= 1'b0;
        end else begin
            meta_q <= data_in;
            sync_q <= meta_q;
        end
    end

    assign data_out = sync_q;

endmodule
