# Quartus Prime Timing Analyzer (agent summary)

**Source:** Intel *Quartus Prime Pro Edition User Guide: Timing Analyzer* (UG-20140, doc **683243**, version **2023.01.31**; suite **22.4** on cover).

**Verbatim PDF:** [Timing Analyser UG.pdf](Timing%20Analyser%20UG.pdf)

**Keywords:** `timing analyzer`, `sdc`, `sta`, `setup`, `hold`, `slack`, `multicycle`, `false path`, `create_clock`, `create_generated_clock`, `set_clock_groups`, `set_false_path`, `set_multicycle_path`, `set_input_delay`, `set_output_delay`, `set_max_skew`, `set_net_delay`, `report_timing`, `report_metastability`, `quartus_sta`

**Related:** [timing-analyzer-cookbook.md](timing-analyzer-cookbook.md) (SDC recipes) · [metastability-mtbf.md](metastability-mtbf.md) · [quartus-design-recommendations.md](quartus-design-recommendations.md) · [cdc-crossings.md](cdc-crossings.md)

**Coverage note:** Agent-readable summary of the full UG (~145 PDF pages). For Tcl option tables and GUI screenshots, use the PDF.

## Contents

### Chapter 1 — Concepts
- [1.1 Timing paths and clocks](#11-timing-paths-and-clocks)
- [1.2 Setup, hold, recovery, removal](#12-setup-hold-recovery-removal)
- [1.2.5 Multicycle path analysis (concepts)](#125-multicycle-path-analysis-concepts)
- [1.2.6 Metastability analysis (concepts)](#126-metastability-analysis-concepts)
- [1.2.7–1.2.10 Advanced analysis concepts](#1271210-advanced-analysis-concepts)

### Chapter 2 — Using the Timing Analyzer
- [2.1 Timing Analyzer flow](#21-timing-analyzer-flow)
- [2.5.1 Generating timing reports](#251-generating-timing-reports)
- [2.6.1 Recommended initial SDC](#261-recommended-initial-sdc)
- [2.6.5 Creating clocks and clock constraints](#265-creating-clocks-and-clock-constraints)
- [2.6.5.7 Constraining CDC paths](#2657-constraining-cdc-paths)
- [2.6.6 I/O constraints](#266-io-constraints)
- [2.6.7 Delay and skew constraints](#267-delay-and-skew-constraints)
- [2.6.8 Timing exceptions](#268-timing-exceptions)
- [2.7 Tcl and collections](#27-tcl-and-collections)

---

## 1.1 Timing paths and clocks

The Timing Analyzer analyzes:

| Path type | Description |
|-----------|-------------|
| Edge paths | port↔pin, pin↔pin |
| Clock paths | port or generated clock → register clock pin |
| Data paths | sequential output → sequential input |
| Async paths | async reset/clear, etc. |

**Arrival / required:** data arrival = launch edge + clock delay + µtCO + datapath; data required = latch edge + clock delay − µtSU (setup) or + µtH (hold).

**Launch / latch edges:** launch sends data from a register; latch captures it. **All clocks must be constrained** — unconstrained clocks are analyzed as 1 GHz (unrealistic slack).

**Timing netlist:** available after Fitter; regenerate reports after SDC changes (gold “outdated” icon in GUI).

---

## 1.2 Setup, hold, recovery, removal

### Setup (register-to-register)

- Slack = data required − data arrival (positive = margin).
- Uses **max** delay for arrival, **min** for required.
- Most restrictive setup relationship among launch/latch edge pairs wins.

### Hold

- Two hold checks per setup relationship; **most restrictive** (smallest latch−launch gap) reported.
- Slack = data arrival − data required.
- Uses **min** delay for arrival, **max** for required.

### Recovery / removal (async control)

- **Recovery:** async deassert (e.g. reset release) stable before next clock edge — like setup for async signals.
- **Removal:** async deassert stable after active clock edge — like hold.
- Async reset from **I/O port** needs `set_input_delay` on that port for recovery/removal analysis.

---

## 1.2.5 Multicycle path analysis (concepts)

Default: **single-cycle** setup (latch edge − launch edge = one period) and hold checks derived from that.

**Multicycle** extends or shifts the setup or hold window when data valid for multiple cycles or on specific edges only.

| Assignment | Effect |
|------------|--------|
| `-setup -end N` | Move latch edge right (common) |
| `-setup -start N` | Move launch edge left |
| `-hold -end N` | Move hold latch edge left |
| `-hold -start N` | Move hold launch edge right |

**Rule of thumb (relax setup N cycles):** also set hold to **N−1**:

```tcl
set_multicycle_path -setup -from src_reg* -to dst_reg* 2
set_multicycle_path -hold  -from src_reg* -to dst_reg* 1
```

**Phase-shifted PLL outputs:** may need multicycle or `-phase` on `create_generated_clock` — default setup window can equal phase shift (hard hold closure).

**Example:** [docs/examples/sdc/multicycle_setup_hold.sdc](../examples/sdc/multicycle_setup_hold.sdc)

---

## 1.2.6 Metastability analysis (concepts)

Async/unrelated clock transfers can cause metastability. Synchronizer chains in the destination domain improve MTBF.

Timing Analyzer can report per-chain and design MTBF; Fitter may protect/optimize synchronizers (see Design Recommendations).

**Tcl:** `report_metastability` — detail in [§2.5.1](#251-generating-timing-reports) and [quartus-design-recommendations.md](quartus-design-recommendations.md).

---

## 1.2.7–1.2.10 Advanced analysis concepts

| Section | Summary |
|---------|---------|
| **1.2.7 Timing pessimism** | Common-clock pessimism removal: adds min/max clock path difference to slack on common-clock paths |
| **1.2.8 Clock-as-data** | Generated clock on data pin (e.g. DDR, inverted clock tree) — TA analyzes rise and fall; worst slack path wins |
| **1.2.9 Multicorner** | Analysis across process/voltage/temperature corners |
| **1.2.10 Time borrowing** | Hyperflex: borrow time from adjacent cycles; `set_max_time_borrow`; limitations on I/O and some register types |

**2.4.2** Enable time borrowing optimization in compiler settings when supported.

---

## 2.1 Timing Analyzer flow

1. **Settings** — metastability, IP regeneration, operating conditions.
2. **Constraints** — complete `.sdc` (clocks, I/O, exceptions).
3. **Run** — after Fitter for sign-off STA.
4. **Reports** — setup/hold/recovery/removal summaries, `report_timing`, CDC/metastability; cross-probe Design Assistant.

GUI constraint edits do not auto-save — **Write SDC File** in Timing Analyzer tasks.

**SDC precedence (2.6.2):** global `.sdc` vs entity-bound `.sdc`; iterative constraints supported.

---

## 2.5.1 Generating timing reports

Default reports include Setup Summary and Timing Analyzer Summary. Generate others via GUI or Tcl.

| Report | Tcl (typical) | Use |
|--------|---------------|-----|
| Report Fmax Summary | `report_clock_fmax_summary` | Max frequency per clock (setup intra-clock slack=0); see also restricted Fmax (hold/min pulse) |
| Report Timing | `report_timing` | Path slack — setup/hold/recovery/removal; filters: clocks, from/to, `-npaths` |
| Report Timing By Source Files | `report_timing` + file filter | Hot-spot hierarchy |
| Report Data Delay | (constraint report) | `set_data_delay` paths |
| Report Net Delay | (constraint report) | `set_net_delay` paths |
| Report Clocks and Clock Network | clock reports | Clock tree, sources |
| Report Clock Transfers | `report_clock_transfers` | Clock-to-clock matrix; safe/async classification |
| Report Metastability | `report_metastability` | Sync chains, MTBF, toggle rate |
| Report CDC Viewer | CDC viewer | Visual CDC review |
| Report Asynchronous CDC | async CDC report | Async CDC paths |
| Report Logic Depth | logic depth | Pipeline depth |
| Report Neighbor Paths | neighbor paths | Adjacent failing paths |
| Report Register Spread | register spread | Placement spread |
| Report Route Net of Interest | route net | Critical nets |
| Report Retiming Restrictions | retiming | Hyper-retiming limits |
| Report Exceptions / Reachability | exceptions | What exceptions apply |
| Report Bottlenecks | bottlenecks | Congestion/timing hotspots |
| Report Time Borrowing Data | time borrowing | Borrowed time per path |

**Report Timing tips:** filter `From Clock` / `To Clock`; increase path count; use wildcards on hierarchy for `From`/`To` nodes.

**Fmax caveat:** Fmax does not replace full setup/hold/recovery/removal/min pulse width summary checks.

---

## 2.6.1 Recommended initial SDC

```tcl
create_clock -period 20.00 -name adc_clk [get_ports adc_clk]
create_clock -period 8.00  -name sys_clk  [get_ports sys_clk]
derive_pll_clocks
derive_clock_uncertainty
```

Then relate unrelated domains (`set_clock_groups -asynchronous` or equivalent).

| Command | Purpose |
|---------|---------|
| `create_clock` | Base clocks on ports/pins |
| `derive_pll_clocks` | PLL generated clocks (device-dependent; many families from IP) |
| `derive_clock_uncertainty` | Inter-clock uncertainty |

**Example:** [initial_dual_clock.sdc](../examples/sdc/initial_dual_clock.sdc)

---

## 2.6.5 Creating clocks and clock constraints

### Base clocks (`create_clock`)

```tcl
create_clock -name sys_clk -period 8.0 [get_ports fpga_clk]
# Optional waveform:
# create_clock -name sys_clk -period 8.0 -waveform {0 4} [get_ports fpga_clk]
```

Tcl: `[get_ports fpga_clk]` executes `get_ports` — names are case-sensitive.

### Virtual clocks (`create_clock` without port)

For **I/O timing** and separate uncertainty from core clocks:

```tcl
create_clock -period 10 -name virt_clk_in
set_input_delay -clock virt_clk_in -max 2.0 [get_ports data_in]
set_input_delay -clock virt_clk_in -min 0.5 [get_ports data_in]
```

Do not use `set_input_delay -clock clk_in` alone if you need correct synchronizer/uncertainty behavior on ports.

### Generated clocks (`create_generated_clock`)

For PLL outputs, dividers, muxed clocks, forwarded clocks. Define **after** base clocks.

```tcl
create_clock -period 10ns -name clk_sys [get_ports clk_sys]
create_generated_clock -name clk_div_2 -divide_by 2 \
    -source [get_ports clk_sys] [get_pins reg|q]
```

- `-source` must be a **netlist node**, not a clock name.
- Multiple base clocks on one source node → multiple `create_generated_clock` with `-master_clock`.
- Preserve synthesized mux/divider node names (attributes) so constraints survive renames.

**Clock mux + exclusive groups:**

```tcl
create_generated_clock -name clock_a_mux -source [get_ports clk_a] \
    [get_pins clk_mux|mux_out]
create_generated_clock -name clock_b_mux -source [get_ports clk_b] \
    [get_pins clk_mux|mux_out] -add
set_clock_groups -logically_exclusive -group clock_a_mux -group clock_b_mux
```

**Example:** [generated_clock_mux.sdc](../examples/sdc/generated_clock_mux.sdc)

### PLL derivation

`derive_pll_clocks` — auto `create_generated_clock` per PLL output (prefer over hand-copying after PLL changes).

### Clock groups (`set_clock_groups`)

See [§2.6.5.7](#2657-constraining-cdc-paths) for async CDC. Also:

- `-logically_exclusive` — muxed clocks
- `-physically_exclusive` — profiles that cannot both be active
- `-asynchronous` — unrelated clocks (both directions cut for timing)

Prefer `set_clock_groups` over many directed `set_false_path` when many clocks exist.

### Clock latency / uncertainty

- `set_clock_latency` — source or network latency on clocks.
- `set_clock_uncertainty` / `derive_clock_uncertainty` — jitter/skew margin between clocks.

---

## 2.6.5.7 Constraining CDC paths

Multibit CDC needs constraints — not only RTL synchronizers.

**Since Quartus Prime Pro 21.3:** `set_false_path` does **not** override `set_max_skew` on the same path.

| Constraint | Role |
|------------|------|
| `set_clock_groups -asynchronous` | Cut both directions (typical for unrelated clocks) |
| `set_false_path` | Point, clock (one direction), or path specific |
| `set_max_skew` | Bus bit skew bound — Report Max Skew Summary |
| `set_net_delay -max` | Per-net max delay (clock-period multipliers supported) |
| `set_data_delay` | Path-level max datapath delay |

```tcl
set_clock_groups -asynchronous -group [get_clocks clk_a] -group [get_clocks clk_b]
set_net_delay -from [get_registers {data_a[*]}] -to [get_registers {data_b[*]}] \
    -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8
set_max_skew -from [get_keepers {data_a[*]}] -to [get_keepers {data_b[*]}] \
    -get_skew_value_from_clock_period min_clock_period -skew_value_multiplier 0.8
```

**DCFIFO gray sync (false path on pointer sync flops only):**

```tcl
set_false_path -from [get_registers {*dcfifo*delayed_wrptr_g[*]}] \
    -to [get_registers {*dcfifo*rs_dgwp*}]
```

**RTL:** plain 2-flop bus sampling is unsafe — see [legacy-tod-sync-analysis.md](../design/legacy-tod-sync-analysis.md).

**Example:** [cdc_async_bus.sdc](../examples/sdc/cdc_async_bus.sdc)

---

## 2.6.6 I/O constraints

`set_input_delay` / `set_output_delay` with **virtual clock** for system-centric timing and separate core vs I/O uncertainty.

Min and max delays model board + external device setup/hold.

---

## 2.6.7 Delay and skew constraints

Analyzed somewhat independently of false path / multicycle precedence (see §2.6.8).

| Constraint | Use |
|------------|-----|
| `set_max_delay` / `set_min_delay` | Absolute min/max on path or clock; overwrites default setup/hold for that scope; specify **both** min and max for async port paths |
| `set_max_skew` | Max skew between bus bits (CDC) |
| `set_net_delay` | Net-based max/min; can use `-get_value_from_clock_period` |
| `set_data_delay` | Path datapath max (21.3+: not overridden by `set_false_path`) |

**I/O:** Advanced I/O timing and board trace models (device/family dependent).

---

## 2.6.8 Timing exceptions

Apply **after** clocks and I/O delays.

### Precedence (highest first)

1. `set_false_path` (ties `set_clock_groups` unless `-latency_insensitive` / `-no_synchronizer` on false path)
2. `set_clock_groups`
3. `set_min_delay` / `set_max_delay`
4. `set_multicycle_path`

**Independent:** `set_net_delay`, `set_max_skew`, `set_data_delay` (with 21.3+ interaction rules documented in UG §2.6.8.1).

### False paths (`set_false_path`)

Exclude paths from analysis (test logic, static config, etc.). `-from`/`-to` can be nodes or clocks; `-thru` combinational only.

```tcl
set_false_path -from [get_pins A*] -to [get_pins B*]
```

Prefer `set_clock_groups` for cutting **all** transfers between clock domains vs many false paths.

Do not false-path entire clock groups when some registers still need synchronized CDC.

### Multicycle paths (`set_multicycle_path`)

Default `-end` if `-start`/`-end` omitted for setup.

```tcl
# Relax setup 2 cycles (e.g. clock-enabled every 2nd cycle):
set_multicycle_path -setup -from src_reg* -to dst_reg* 2
set_multicycle_path -hold  -from src_reg* -to dst_reg* 1

# Slow I/O to SRAM (3-cycle setup):
# set_multicycle_path -setup -to [get_ports {SRAM_ADD[*] SRAM_DATA[*]}] 3
# set_multicycle_path -hold  -to [get_ports {SRAM_ADD[*] SRAM_DATA[*]}] 2
```

**Phase shift:** `create_generated_clock -phase <deg>` may require multicycle to widen setup window.

UG §2.6.8.5 has worked examples (same frequency with offset, faster/slower destination clock, etc.).

---

## 2.7 Tcl and collections

| Command | Use |
|---------|-----|
| `quartus_sta` | Command-line STA |
| `report_timing` | Path reports with filters |
| `report_clock_transfers` | CDC matrix |
| `report_metastability` | MTBF / sync chains |
| `report_clock_fmax_summary` | Fmax table |
| `get_clock_fmax_info` | Tcl list for scripting |

**Collections (SDC):** `get_ports`, `get_pins`, `get_registers`, `get_clocks`, `get_nets`, `get_keepers` — support wildcards `*`, `?`, `|`. Use explicit collections in constraints; names are case-sensitive.

**Help:** `quartus_sh --qhelp`

**Metastability assignments:** see [quartus-design-recommendations.md §3](quartus-design-recommendations.md).

---

## PDF sections not duplicated here

Use the PDF for: full GUI walkthroughs, NativeLink (Standard Edition), imported compilation results (§2.8), complete multicycle example catalog (§2.6.8.5), Fitter overconstraints (§2.6.9), example design §2.6.10, and per-command Tcl help pages.
