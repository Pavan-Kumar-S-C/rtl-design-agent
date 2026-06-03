// Golden pattern: async assert, sync deassert reset stretcher

module sync_reset_release_sv (
    input  logic clk,
    input  logic rst_n_async,  // async active-low reset in
    output logic rst_n_sync     // synchronized active-low reset out
);

    logic rst_meta;
    logic rst_sync;

    always_ff @(posedge clk or negedge rst_n_async) begin
        if (!rst_n_async) begin
            rst_meta <= 1'b0;
            rst_sync <= 1'b0;
        end else begin
            rst_meta <= 1'b1;
            rst_sync <= rst_meta;
        end
    end

    assign rst_n_sync = rst_sync;

endmodule
