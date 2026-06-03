# Muxed clock sources with logically exclusive generated clocks (UG-20140 §2.6.5.3.2, §2.6.5.5.1)

create_clock -period 10.0 -name clk_a [get_ports clk_a]
create_clock -period 10.0 -name clk_b [get_ports clk_b]

create_generated_clock -name clock_a_mux -source [get_ports clk_a] \
    [get_pins clk_mux|mux_out]
create_generated_clock -name clock_b_mux -source [get_ports clk_b] \
    [get_pins clk_mux|mux_out] -add

set_clock_groups -logically_exclusive -group clock_a_mux -group clock_b_mux
