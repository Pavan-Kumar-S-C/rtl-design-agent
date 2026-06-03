# Cookbook Ex.19 — false path one direction; use set_clock_groups for both dirs (MNL-01035)
create_clock -period 12 [get_ports clkA]
create_clock -period 5  [get_ports clkB]
set_false_path -from [get_clocks clkA] -to [get_clocks clkB]
