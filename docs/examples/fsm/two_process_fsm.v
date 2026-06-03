// Golden pattern: two-process Verilog-2001 FSM

module two_process_fsm_v (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       go,
    output reg        done
);

    localparam [1:0] ST_IDLE = 2'd0;
    localparam [1:0] ST_RUN  = 2'd1;
    localparam [1:0] ST_DONE = 2'd2;

    reg [1:0] state_q;
    reg [1:0] state_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state_q <= ST_IDLE;
        else
            state_q <= state_d;
    end

    always @* begin
        state_d = state_q;
        done    = 1'b0;
        case (state_q)
            ST_IDLE: begin
                if (go)
                    state_d = ST_RUN;
            end
            ST_RUN: begin
                state_d = ST_DONE;
            end
            ST_DONE: begin
                done    = 1'b1;
                state_d = ST_IDLE;
            end
            default: state_d = ST_IDLE;
        endcase
    end

endmodule
