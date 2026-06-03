# Cookbook Ex.22 — stub: dual clock on one port + virtual I/O clocks (MNL-01035)
# Full latency / -add_delay input-output: see PDF Example 22 or timing-analyzer-cookbook.md

set PERIOD_CLK_A 10.000
set PERIOD_CLK_B  7.000

create_clock -name clk_a -period $PERIOD_CLK_A [get_ports clk]
create_clock -name clk_b -period $PERIOD_CLK_B [get_ports clk] -add

create_clock -name virtual_source_clk_a -period $PERIOD_CLK_A
create_clock -name virtual_source_clk_b -period $PERIOD_CLK_B
create_clock -name virtual_dest_clk_a   -period $PERIOD_CLK_A
create_clock -name virtual_dest_clk_b   -period $PERIOD_CLK_B

set_clock_groups -exclusive -group {clk_a} -group {virtual_source_clk_b}
set_clock_groups -exclusive -group {clk_b} -group {virtual_source_clk_a}
set_clock_groups -exclusive -group {clk_a} -group {virtual_dest_clk_b}
set_clock_groups -exclusive -group {clk_b} -group {virtual_dest_clk_a}

# Continue with set_clock_latency -source and set_input/output_delay -add_delay per cookbook.
