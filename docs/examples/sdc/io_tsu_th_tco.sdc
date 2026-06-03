# Cookbook Ex.16 — tSU, tH, tCO via virtual clock (MNL-01035)
set period 10.000
set tSU  1.250
set tH   0.750
set tCO  0.400

create_clock -period $period -name clk [get_ports sys_clk]
create_clock -period $period -name virt_clk

set_input_delay -clock virt_clk -max [expr $period - $tSU] [get_ports data_in*]
set_input_delay -clock virt_clk -min $tH [get_ports data_in*]
set_output_delay -clock virt_clk -max [expr $period - $tCO] [get_ports data_out*]
set_output_delay -clock virt_clk -min [expr -1 * $tCO] [get_ports data_out*]
