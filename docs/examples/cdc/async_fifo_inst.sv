// From: docs/design/cdc-reusable-patterns.md §6 — km_hssi_async_fifo (key ports only)

module km_hssi_async_fifo_inst_example (
    input  logic               wr_clk,
    input  logic               wr_rst_n,
    input  logic               wr_en,
    input  logic [40:0]        wr_data,
    output logic               wr_full,
    input  logic               rd_clk,
    input  logic               rd_rst_n,
    input  logic               rd_en,
    output logic [40:0]        rd_data,
    output logic               rd_empty
);

    localparam int AW = 6;

    km_hssi_async_fifo #(
        .DWIDTH           (41),
        .AWIDTH           (AW),
        .DST_CLK_FREQ_MHZ (500),
        .SRC_CLK_FREQ_MHZ (500)
    ) u_async_fifo (
        .wr_rst_n    (wr_rst_n),
        .wr_clk      (wr_clk),
        .wr_en       (wr_en),
        .wr_data     (wr_data),
        .wr_empty    (),
        .wr_full     (wr_full),
        .wr_pempty   (),
        .wr_pfull    (),
        .rd_rst_n    (rd_rst_n),
        .rd_clk      (rd_clk),
        .rd_en       (rd_en),
        .o_rd_data   (rd_data),
        .rd_empty    (rd_empty),
        .rd_full     (),
        .rd_pempty   (),
        .rd_pfull    (),
        .r_pempty    ('0),
        .r_pfull     ('0),
        .r_empty     ('0),
        .r_full      ('0),
        .r_rd_empty  (1'b0),
        .r_wr_full   (1'b0),
        .rd_numdata  (),
        .wr_numdata  (),
        .fifo_underrun(),
        .fifo_overflow(),
        .i_tdf_en    (1'b0)
    );

endmodule
