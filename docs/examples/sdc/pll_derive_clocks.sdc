# Cookbook — PLL method 2: manual base + derive_pll_clocks (MNL-01035)
create_clock -period 10.000 -name clk [get_ports clk]
derive_pll_clocks
