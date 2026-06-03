# Relax setup by 2 clock cycles; hold = setup - 1 (UG-20140 §2.6.8.4.2)
# Use when data is valid every 2nd cycle (e.g. clock-enabled registers).

set_multicycle_path -setup -from [get_registers src_reg*] -to [get_registers dst_reg*] 2
set_multicycle_path -hold  -from [get_registers src_reg*] -to [get_registers dst_reg*] 1
