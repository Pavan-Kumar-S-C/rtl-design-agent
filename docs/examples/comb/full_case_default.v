// Golden pattern: combinational logic with full case + default (no latch)

module mux_safe_v (
    input  wire [1:0] sel,
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [7:0] c,
    output reg  [7:0] y
);

    always @* begin
        y = 8'h00;
        case (sel)
            2'b00: y = a;
            2'b01: y = b;
            2'b10: y = c;
            default: y = 8'h00;
        endcase
    end

endmodule
