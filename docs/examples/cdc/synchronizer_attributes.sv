// Quartus synchronizer attributes + project library pattern (docs/standards/quartus-design-recommendations.md §3.4.2)
// FORCED: intentional CDC synchronizer. OFF: not a synchronizer (datapath / multi-bit bus).

module synchronizer_attribute_examples (
    input  logic       dst_clk,
    input  logic       dst_rst_n,
    input  logic       async_bit_in,
    output logic       sync_bit_out
);

    // Intentional 2-flop synchronizer — identify for MTBF analysis and Fitter protection
    (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED",
                          "-name DONT_MERGE_REGISTER ON",
                          "-name PRESERVE_REGISTER ON"} *)
    logic meta_d1, meta_d2;

    always_ff @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n) begin
            meta_d1 <= 1'b0;
            meta_d2 <= 1'b0;
        end else begin
            meta_d1 <= async_bit_in;
            meta_d2 <= meta_d1;
        end
    end

    assign sync_bit_out = meta_d2;

    // Datapath register crossing unrelated clocks — NOT a synchronizer chain
    (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *)
    logic [19:0] ppm_diff;

endmodule
