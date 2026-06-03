# Cookbook Ex.2 — offset clocks, same period (MNL-01035)
create_clock -period 10.000 -name clkA [get_ports clkA]
create_clock -period 10.000 -waveform {2.500 7.500} -name clkB [get_ports clkB]
