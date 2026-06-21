`timescale 1ns/1ps

module packet_cmd_controller #(
    parameter DATA_W = 8,
    parameter ADDR_W = 2
)(
    input  wire                 clk,
    input  wire                 rst_n,       // Active-low reset
    input  wire                 cmd_valid,
    input  wire [1:0]           cmd,
    input  wire [ADDR_W-1:0]    addr,
    input  wire [DATA_W-1:0]    wr_data,

    output reg                  rsp_valid,
    output reg  [DATA_W-1:0]    rd_data,
    output reg                  error
);

    localparam CMD_WRITE = 2'b00;
    localparam CMD_READ  = 2'b01;
    localparam CMD_ADD   = 2'b10;
    localparam CMD_CLR   = 2'b11;

    localparam ADDR_REG_A = 2'b00;
    localparam ADDR_REG_B = 2'b01;

    reg [DATA_W-1:0] reg_a;
    reg [DATA_W-1:0] reg_b;

    reg [DATA_W-1:0] next_rd_data;
    reg              next_error;

    integer debug_file;

    // ------------------------------------------------------------
    // Synthesizability issue:
    // File operations and initial block are not suitable for synthesis
    // ------------------------------------------------------------
    initial begin
        debug_file = $fopen("packet_cmd_debug.log", "w");
    end

    // ------------------------------------------------------------
    // Combinational decode logic
    // Contains intentional latch inference and missing defaults
    // ------------------------------------------------------------
    always @(*) begin
        // INTENTIONAL ISSUE:
        // next_rd_data and next_error are not assigned default values.
        // This can infer latches when some branches do not assign them.

        if (cmd_valid) begin
            case (cmd)

                CMD_READ: begin
                    case (addr)
                        ADDR_REG_A: begin
                            next_rd_data = reg_a;
                            next_error   = 1'b0;
                        end

                        ADDR_REG_B: begin
                            next_rd_data = reg_b;
                            next_error   = 1'b0;
                        end

                        // INTENTIONAL ISSUE:
                        // Missing default case for invalid address.
                        // next_rd_data and next_error may retain old values.
                    endcase
                end

                CMD_ADD: begin
                    next_rd_data = reg_a + reg_b;
                    next_error   = 1'b0;
                end

                CMD_WRITE: begin
                    // INTENTIONAL ISSUE:
                    // For write command, next_rd_data is not assigned.
                    // This may infer latch for next_rd_data.
                    next_error = 1'b0;
                end

                // INTENTIONAL ISSUE:
                // CMD_CLR is not handled.
                // Missing case branch may infer latches.
            endcase
        end

        // INTENTIONAL ISSUE:
        // If cmd_valid is 0, next_rd_data and next_error are not assigned.
        // This creates latch inference.
    end

    // ------------------------------------------------------------
    // Sequential register update
    // Reset is intended to be active-low asynchronous reset
    // ------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_a     <= {DATA_W{1'b0}};
            reg_b     <= {DATA_W{1'b0}};
            rsp_valid <= 1'b0;
            rd_data   <= {DATA_W{1'b0}};
            error     <= 1'b0;
        end else begin
            rsp_valid <= cmd_valid;
            rd_data   <= next_rd_data;
            error     <= next_error;

            if (cmd_valid) begin
                case (cmd)

                    CMD_WRITE: begin
                        case (addr)
                            ADDR_REG_A: reg_a <= wr_data;
                            ADDR_REG_B: reg_b <= wr_data;

                            // INTENTIONAL ISSUE:
                            // Missing default for invalid address.
                        endcase
                    end

                    CMD_CLR: begin
                        if (addr == ADDR_REG_A)
                            reg_a <= {DATA_W{1'b0}};

                        // INTENTIONAL ISSUE:
                        // ADDR_REG_B clear is missing.
                        // Invalid address also not handled.
                    end

                    default: begin
                        // No register update for READ or ADD
                    end

                endcase
            end

            // ----------------------------------------------------
            // Synthesizability issue:
            // File write inside RTL sequential logic
            // ----------------------------------------------------
            if (cmd_valid) begin
                $fwrite(debug_file, "cmd=%0d addr=%0d data=%0h\n",
                        cmd, addr, wr_data);
            end
        end
    end

    // ------------------------------------------------------------
    // Synthesizability issue:
    // Delay-based assignment is not synthesizable RTL style
    // ------------------------------------------------------------
    always @(cmd_valid) begin
        #2;
        if (cmd_valid)
            $display("Command received at time %0t", $time);
    end

endmodule