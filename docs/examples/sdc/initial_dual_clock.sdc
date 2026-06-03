# From: Timing Analyzer UG §2.6.1 — recommended initial constraints (dual-clock template)
# Adjust periods, port names, and clock groups for your design.

create_clock -period 20.00 -name adc_clk [get_ports adc_clk]
create_clock -period 8.00  -name sys_clk  [get_ports sys_clk]

derive_pll_clocks
derive_clock_uncertainty

# Unrelated domains — cut inter-clock timing (customize clock names):
# set_clock_groups -asynchronous -group [get_clocks adc_clk] -group [get_clocks sys_clk]
