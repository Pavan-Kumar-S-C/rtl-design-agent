# Cookbook Ex.14 — system synchronous input + virtual clock (MNL-01035)
set CLKs_max 0.200
set CLKs_min 0.100
set CLKd_max 0.200
set CLKd_min 0.100
set tCO_max 0.525
set tCO_min 0.415
set BD_max  0.180
set BD_min  0.120

create_clock -period 10 -name sys_clk [get_ports sys_clk]
create_clock -period 10 -name virt_sys_clk

set_input_delay -clock virt_sys_clk \
    -max [expr $CLKs_max + $tCO_max + $BD_max - $CLKd_min] \
    [get_ports data_in*]
set_input_delay -clock virt_sys_clk \
    -min [expr $CLKs_min + $tCO_min + $BD_min - $CLKd_max] \
    [get_ports data_in*]
