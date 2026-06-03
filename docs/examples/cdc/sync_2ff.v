// Golden pattern: single-bit CDC synchronizer (2-flop), Verilog

module sync_2ff_v (
    input  wire src_clk,
    input  wire src_rst_n,
    input  wire dst_clk,
    input  wire dst_rst_n,
    input  wire data_in,
    output wire data_out
);

    (* async_reg = "true" *) reg meta_q;
    reg sync_q;

    always @(posedge dst_clk or negedge dst_rst_n) begin
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
