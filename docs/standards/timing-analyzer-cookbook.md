# Quartus Prime Timing Analyzer Cookbook (agent summary)

**Source:** Intel *Quartus Prime Timing Analyzer Cookbook* (MNL-01035, doc **683081**, version **2022.07.21**, suite **22.2**).

**Verbatim PDF:** [Timing analyser CookBook.pdf](Timing%20analyser%20CookBook.pdf)

**Companion (concepts / full UG):** [timing-analyzer-ug.md](timing-analyzer-ug.md)

**Keywords:** `timing cookbook`, `sdc recipe`, `virtual clock`, `set_input_delay`, `set_output_delay`, `derive_pll_clocks`, `create_clock -add`, `set_clock_groups -exclusive`, `clock enable multicycle`, `get_fanouts`, `jtag`, `altera_reserved_tck`, `duty cycle`, `-waveform`, `-edges`, `system synchronous`, `tSU`, `tH`, `tCO`

**Use this doc when:** the user needs **copy-paste SDC patterns** for a specific topology (PLL, mux, I/O, multicycle, JTAG). Use **timing-analyzer-ug.md** for STA theory, report catalog, exception precedence, and CDC constraint rules.

## Contents

- [Clocks and generated clocks](#clocks-and-generated-clocks)
- [I/O constraints](#io-constraints)
- [Timing exceptions](#timing-exceptions)
- [Miscellaneous](#miscellaneous)

---

## Clocks and generated clocks

### Basic non-50/50 duty cycle clock

Default `create_clock` is 50/50. Use `-waveform {rise fall}` for duty cycle (times in ns).

```tcl
# 60/40 duty cycle, 10 ns period: high 0–6 ns, low 6–10 ns
create_clock -period 10.000 -waveform {0.000 6.000} -name clk6040 [get_ports clk]
```

**Example:** [duty_cycle_6040.sdc](../examples/sdc/duty_cycle_6040.sdc)

### Offset clocks

First edge defaults to 0. Shift with `-waveform` (still 50/50 if only offset changes).

```tcl
create_clock -period 10.000 -name clkA [get_ports clkA]
create_clock -period 10.000 -waveform {2.500 7.500} -name clkB [get_ports clkB]
```

**Example:** [clock_offset.sdc](../examples/sdc/clock_offset.sdc)

### Basic clock divider (`-divide_by`)

Source can be port or divider register clock pin (same net).

```tcl
create_clock -period 10.000 -name clk [get_ports clk]
create_generated_clock -divide_by 2 -source [get_ports clk] -name clkdiv [get_pins DIV|q]
# or: -source [get_pins DIV|clk]
```

**Alternative — `-edges`:** edge numbers refer to **master** clock edges, e.g. divide-by-2:

```tcl
create_generated_clock -edges {1 3 5} -source [get_pins DIV|clk] -name clkdiv [get_pins DIV|q]
```

### Toggle register generated clock

TFF with constant `1` on D → divide-by-2 on `q`:

```tcl
create_clock -period 10.000 -name clk [get_ports clk]
create_generated_clock -name tff_clk -source [get_ports clk] -divide_by 2 [get_pins tff|q]
```

### PLL clocks — three methods

| Method | Commands | When |
|--------|----------|------|
| **1 — Auto all** | `derive_pll_clocks -create_base_clocks` | ALTPLL params drive all PLL in/out clocks; IP changes auto-track |
| **2 — Manual base, auto out** | `create_clock … [get_ports clk]` then `derive_pll_clocks` | Try different input frequency vs IP setting (must be PLL-legal) |
| **3 — Manual all** | `create_clock` + `create_generated_clock` on `PLL|…|clk[n]` | Full control; may diverge from IP GUI |

```tcl
# Method 2 (common)
create_clock -period 10.000 -name clk [get_ports clk]
derive_pll_clocks

# Method 3 (snippet)
create_generated_clock -name PLL_C0 \
    -source [get_pins {PLL|altpll_component|pll|inclk[0]}] \
    [get_pins {PLL|altpll_component|pll|clk[0]}]
create_generated_clock -name PLL_C1 -multiply_by 2 \
    -source [get_pins {PLL|altpll_component|pll|inclk[0]}] \
    [get_pins {PLL|altpll_component|pll|clk[1]}]
```

**Example:** [pll_derive_clocks.sdc](../examples/sdc/pll_derive_clocks.sdc)

### Multi-frequency analysis

#### Clock multiplexer (2:1)

Cut transfers between mux inputs; do **not** analyze paths that assume both clocks active.

```tcl
create_clock -period 10.000 -name clkA [get_ports clkA]
create_clock -period 20.000 -name clkB [get_ports clkB]
set_clock_groups -exclusive -group {clkA} -group {clkB}
```

**Note:** For mux **output** as generated clock, see [generated_clock_mux.sdc](../examples/sdc/generated_clock_mux.sdc) (UG pattern).

#### Externally switched clock (same port, two frequencies)

Two `create_clock` on **same port** — second needs `-add`; exclusive groups.

```tcl
create_clock -period 10.000 -name clkA [get_ports clk]
create_clock -period 20.000 -name clkB [get_ports clk] -add
set_clock_groups -exclusive -group {clkA} -group {clkB}
```

**Example:** [external_switched_clock.sdc](../examples/sdc/external_switched_clock.sdc)

#### PLL clock switchover

Constrain both reference clocks; `derive_pll_clocks` handles switchover outputs; cut between ref clocks.

```tcl
create_clock -period 10.000 -name clk0 [get_ports clk0]
create_clock -period 20.000 -name clk1 [get_ports clk1]
derive_pll_clocks
set_clock_groups -exclusive -group {clk0} -group {clk1}
```

---

## I/O constraints

### Rule: virtual clocks for I/O delays

**All** `set_input_delay` / `set_output_delay` should reference a **virtual clock** with the same period/waveform as the board clock that times the external device. Reasons (cookbook):

- `derive_clock_uncertainty` applies correct intra- vs inter-clock uncertainty on ports
- Extra external uncertainty can be added independently

Virtual clock properties must match the clock that times the external chip (not necessarily the FPGA port clock name).

### Input/output delays with virtual clocks (chip-to-chip)

Account for external clock skew, `tCO`/`tSU`/`tH`, and board delay in Tcl `expr`:

```tcl
# Input max delay (source → FPGA):
# CLKs_max + tCOa_max + BDa_max - CLKAd_min
set_input_delay -clock clkA_virt -max [expr $CLKAs_max + $tCOa_max + $BDa_max - $CLKAd_min] [get_ports data_in*]
set_input_delay -clock clkA_virt -min [expr $CLKAs_min + $tCOa_min + $BDa_min - $CLKAd_max] [get_ports data_in*]

# Output max delay (FPGA → sink):
# CLKBs_max + tSUb + BDb_max - CLKBd_min
set_output_delay -clock clkB_virt -max [expr $CLKBs_max + $tSUb + $BDb_max - $CLKBd_min] [get_ports data_out]
set_output_delay -clock clkB_virt -min [expr $CLKBs_min - $tHb + $BDb_min - $CLKBd_max] [get_ports data_out]
```

**Example:** [virtual_io_chip_to_chip.sdc](../examples/sdc/virtual_io_chip_to_chip.sdc) (system-synchronous input pattern)

### Tri-state outputs

Same as normal outputs: base clock + virtual clock + `set_output_delay` on tri-state port.

### System synchronous input / output

Simpler single-clock case: one `sys_clk` port clock + `virt_sys_clk`; fold `CLKs`, `CLKd`, `tCO` or `tSU`/`tH`, and board delay into `set_input_delay` / `set_output_delay` (see cookbook Examples 14–15).

### I/O timing requirements (tSU, tH, tCO only)

When you have datasheet numbers but not full board delay breakdown:

```tcl
set period 10.000
set tSU  1.250
set tH   0.750
set tCO  0.400
create_clock -period $period -name clk [get_ports sys_clk]
create_clock -period $period -name virt_clk
set_input_delay  -clock virt_clk -max [expr $period - $tSU] [get_ports data_in*]
set_input_delay  -clock virt_clk -min $tH [get_ports data_in*]
set_output_delay -clock virt_clk -max [expr $period - $tCO] [get_ports data_out*]
set_output_delay -clock virt_clk -min [expr -1 * $tCO] [get_ports data_out*]
```

**Example:** [io_tsu_th_tco.sdc](../examples/sdc/io_tsu_th_tco.sdc)

### Input/output delays with multiple clocks (redundant clock on one port)

Primary + secondary clock on **same** `clk` port (`-add`); separate virtual clocks per external mux selection; `set_clock_groups -exclusive` between impossible clock combinations; `set_clock_latency -source` on virtual/FPGA clocks to remove common-path pessimism; `set_input_delay` / `set_output_delay` with `-add_delay` for second clock.

**Full recipe:** cookbook Example 22 (long) — see PDF or expand from [dual_port_clock_io.sdc](../examples/sdc/dual_port_clock_io.sdc) stub.

---

## Timing exceptions

### Multicycle exceptions

Default is single-cycle (most restrictive).

**Clock-to-clock** — affects all reg-to-reg paths where launch clock ∈ from and latch clock ∈ to:

```tcl
create_clock -period 10 [get_ports clkA]
create_clock -period 5  [get_ports clkB]
set_multicycle_path -from [get_clocks clkA] -to [get_clocks clkB] -setup -end 2
```

**Register-to-register** — only specified path:

```tcl
set_multicycle_path -from [get_pins reg1|q] -to [get_pins reg2|d] -setup -end 2
```

**Clock-enable multicycle** — enable pulse wider than one cycle; setup=2, hold=1 on all enable-driven destination regs:

```tcl
set_multicycle_path 2 -to [get_fanouts [get_pins enable_reg|q] -through [get_pins -hierarchical *|ena]] -end -setup
set_multicycle_path 1 -to [get_fanouts [get_pins enable_reg|q] -through [get_pins -hierarchical *|ena]] -end -hold
```

(Cookbook Example 23 shows setup only — add explicit hold per UG/cookbook clock-enable text.)

**Examples:** [multicycle_clk_to_clk.sdc](../examples/sdc/multicycle_clk_to_clk.sdc), [clock_enable_multicycle.sdc](../examples/sdc/clock_enable_multicycle.sdc), [multicycle_setup_hold.sdc](../examples/sdc/multicycle_setup_hold.sdc)

### False paths

Cut non-critical or async paths so Fitter focuses on critical timing.

| Scope | Effect |
|-------|--------|
| Clock → clock | Cuts **one direction** only unless second command or `set_clock_groups` |
| Pin → pin | Cuts single path |

```tcl
set_false_path -from [get_clocks clkA] -to [get_clocks clkB]
# Bidirectional async: prefer
set_clock_groups -asynchronous -group [get_clocks clkA] -group [get_clocks clkB]
```

**Example:** [false_path_clk_to_clk.sdc](../examples/sdc/false_path_clk_to_clk.sdc)

---

## Miscellaneous

### JTAG signals (`altera_reserved_*`)

Pro Edition: JTAG ports often **unconstrained** unless you apply Intel’s template SDC.

| Signal | Role |
|--------|------|
| `altera_reserved_tck` | JTAG clock |
| `altera_reserved_tms` / `tdi` / `tdo` | Control / data |

Cookbook provides a **large Tcl proc** (`set_jtag_timing_constraints`) with:

- `create_clock` on `altera_reserved_tck` (USB Blaster 6/24/16 MHz options)
- `set_clock_groups -asynchronous` for TCK domain
- `set_input_delay` / `set_output_delay` with `-clock_fall` per JTAG spec
- `set_false_path` on TDI→TDO and non-JTAG logic to TDO
- Optional `set_max_delay -to altera_reserved_tdo` for Fitter placement (fit-specific branch)

**Agent guidance:** Do not invent JTAG delays — use cookbook/PDF template and customize `---customize here---` sections (chain position, cable, PCB inches ~160 ps/inch).

**Stub:** [jtag_constraints_stub.sdc](../examples/sdc/jtag_constraints_stub.sdc) (minimal clock + async group only).

### Related UG topics

Multicycle theory, exception precedence, CDC `set_max_skew` → [timing-analyzer-ug.md](timing-analyzer-ug.md).
