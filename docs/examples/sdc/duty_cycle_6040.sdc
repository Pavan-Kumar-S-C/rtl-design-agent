# Cookbook Ex.1 — 60/40 duty cycle (MNL-01035)
create_clock -period 10.000 -waveform {0.000 6.000} -name clk6040 [get_ports clk]
