// Golden pattern: two-process SystemVerilog FSM (company style)
// State register + combinational next-state/output logic

module two_process_fsm_sv (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       go,
    output logic       done
);

    typedef enum logic [1:0] {
        ST_IDLE = 2'd0,
        ST_RUN  = 2'd1,
        ST_DONE = 2'd2
    } state_t;

    state_t state_q, state_d;

    // Sequential: state register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state_q <= ST_IDLE;
        else
            state_q <= state_d;
    end

    // Combinational: next state + outputs (full case, default)
    always_comb begin
        state_d = state_q;
        done    = 1'b0;
        unique case (state_q)
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
