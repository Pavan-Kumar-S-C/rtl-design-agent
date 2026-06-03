# Cookbook Ex.23 — multicycle to enable-driven registers (MNL-01035)
# Add explicit hold=1 when relaxing setup=2 (see multicycle_setup_hold.sdc).
set_multicycle_path 2 -to [get_fanouts [get_pins enable_reg|q] \
    -through [get_pins -hierarchical *|ena]] -end -setup
set_multicycle_path 1 -to [get_fanouts [get_pins enable_reg|q] \
    -through [get_pins -hierarchical *|ena]] -end -hold
