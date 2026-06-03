# Cookbook Ex.10 — same port, two frequencies via -add (MNL-01035)
create_clock -period 10.000 -name clkA [get_ports clk]
create_clock -period 20.000 -name clkB [get_ports clk] -add
set_clock_groups -exclusive -group {clkA} -group {clkB}
