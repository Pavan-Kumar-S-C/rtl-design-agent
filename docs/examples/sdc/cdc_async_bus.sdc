# From: Timing Analyzer UG §2.6.5.7 — multibit CDC constraints (example pattern)
# Does NOT make an unsafe 2-flop bus CDC correct — use with proper RTL (FIFO/handshake/gray).

create_clock -name clk_a -period 4.000 [get_ports {clk_a}]
create_clock -name clk_b -period 4.500 [get_ports {clk_b}]

set_clock_groups -asynchronous -group [get_clocks {clk_a}] -group [get_clocks {clk_b}]

set_net_delay -from [get_registers {data_a[*]}] -to [get_registers {data_b[*]}] \
    -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8

set_max_skew -from [get_keepers {data_a[*]}] -to [get_keepers {data_b[*]}] \
    -get_skew_value_from_clock_period min_clock_period -skew_value_multiplier 0.8

# DCFIFO gray sync (single-bit paths) — UG example pattern:
# set_false_path -from [get_registers {*dcfifo*delayed_wrptr_g[*]}] -to [get_registers {*dcfifo*rs_dgwp*}]
# set_false_path -from [get_registers {*dcfifo*rdptr_g[*]}]     -to [get_registers {*dcfifo*ws_dgrp*}]
