// From: docs/design/architecture-comparison.md §2 Control Signaling (legacy)

module legacy_tod_toggle_detect (
    input  wire toggle_bit_slave,
    input  wire toggle_bit_slave_old,
    output wire toggle
);

    assign toggle = toggle_bit_slave ^ toggle_bit_slave_old;

endmodule
