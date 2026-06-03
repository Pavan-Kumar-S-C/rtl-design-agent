# Cookbook Ex.21 — minimal JTAG (full template in PDF / timing-analyzer-cookbook.md)
# Pro Edition: altera_reserved_* are unconstrained unless you constrain them.
create_clock -name altera_reserved_tck -period 41.666 [get_ports altera_reserved_tck]
set_clock_groups -asynchronous -group {altera_reserved_tck}
