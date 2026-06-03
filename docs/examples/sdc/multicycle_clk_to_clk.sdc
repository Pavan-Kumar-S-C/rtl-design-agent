# Cookbook Ex.17 — multicycle clock-to-clock (MNL-01035)
create_clock -period 10 [get_ports clkA]
create_clock -period 5  [get_ports clkB]
set_multicycle_path -from [get_clocks clkA] -to [get_clocks clkB] -setup -end 2
