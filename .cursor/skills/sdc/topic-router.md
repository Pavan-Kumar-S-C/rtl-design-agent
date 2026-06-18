# Topic router — @sdc

## Rule: cookbook + UG constraint sections + user input; ask only when in doubt

1. Use **Timing Analyzer Cookbook**, **UG constraint sections** (§2.6.x), **examples/sdc/**, and user `.sdc` / RTL / datasheet.
2. **Do not** load every file — match keywords; read **one** cookbook or UG `##` section at a time.
3. **Do not invent** clock names, periods, board delays, or port names.
4. **Do not** load UG Ch.1 theory or report catalog for pure authoring — redirect to `@timing-analysis` for STA/report interpretation.
5. Prefer adapting a golden [examples/sdc/](../../../docs/examples/sdc/) file over inventing Tcl syntax.

## Step 1 — Match INDEX rows

Read [docs/standards/INDEX.md](../../../docs/standards/INDEX.md). Match **only**:

| INDEX row | When |
|-----------|------|
| **Timing Analyzer Cookbook** | SDC recipes, `create_clock`, I/O delays, multicycle, false path, JTAG, PLL |
| **Timing Analyzer / SDC** | UG §2.6.x constraint authoring, precedence, CDC constraint syntax |

## Step 2 — Timing Analyzer Cookbook (primary for recipes)

Source: [timing-analyzer-cookbook.md](../../../docs/standards/timing-analyzer-cookbook.md). Read **one** section when keywords match:

| Section | Keywords |
|---------|----------|
| Clocks — duty cycle / waveform | duty cycle, 50/50, -waveform, non-50 |
| Clocks — offset | offset clock, phase offset, -waveform offset |
| Clocks — divide_by / edges / toggle | divide_by, -edges, toggle register, clock divider |
| Clocks — PLL derive | derive_pll_clocks, altpll, pll manual, multiply_by |
| Clocks — mux / switched / switchover | clock mux, exclusive, -add same port, pll switchover, clk0 clk1 |
| I/O — virtual clock chip-to-chip | virtual clock, chip to chip, board delay, tCO external |
| I/O — tri-state | tri-state, tristate, oe |
| I/O — system synchronous | system synchronous, CLKs CLKd, sys_clk input output delay |
| I/O — tSU tH tCO | tsu, th, tco, datasheet io timing |
| I/O — multiple clocks one port | primary secondary clock, redundant clock, -add_delay io, virtual_source |
| Exceptions — multicycle | multicycle clock to clock, multicycle register, clock enable multicycle, get_fanouts |
| Exceptions — false path | false path clock, cut path |
| Miscellaneous — JTAG | jtag, altera_reserved_tck, tms, tdi, tdo, in-system debug |

**Verbatim PDF:** [Timing analyser CookBook.pdf](../../../docs/standards/Timing%20analyser%20CookBook.pdf) — especially JTAG Tcl procs (Example 21).

## Step 3 — UG constraint sections (precedence + CDC + clocks)

Source: [timing-analyzer-ug.md](../../../docs/standards/timing-analyzer-ug.md). Load **only** these when authoring/reviewing constraints:

| Section | Keywords |
|---------|----------|
| 2.6.1 Recommended initial SDC | initial sdc, create_clock, derive_pll_clocks, derive_clock_uncertainty |
| 2.6.5 Creating clocks and clock constraints | create_generated_clock, virtual clock, clock mux, derive_pll, set_clock_groups, clock latency, clock uncertainty |
| 2.6.5.7 Constraining CDC paths | constrain cdc, cdc path, set_max_skew, set_net_delay, set_data_delay, async bus, dcfifo false path |
| 2.6.6 I/O constraints | set_input_delay, set_output_delay, virtual clock, io timing, io uncertainty |
| 2.6.7 Delay and skew constraints | set_max_delay, set_min_delay, set_max_skew, set_net_delay, set_data_delay, board trace |
| 2.6.8 Timing exceptions | set_false_path, timing exception precedence, set_multicycle_path, set_clock_groups precedence |

**Do not** load UG §1.x or §2.5.1 under `@sdc` unless user also needs report interpretation → `@timing-analysis`.

## Step 4 — Golden examples

Catalog: [docs/examples/sdc/README.md](../../../docs/examples/sdc/README.md)

| File | Source |
|------|--------|
| [initial_dual_clock.sdc](../../../docs/examples/sdc/initial_dual_clock.sdc) | UG §2.6.1 |
| [cdc_async_bus.sdc](../../../docs/examples/sdc/cdc_async_bus.sdc) | UG §2.6.5.7 |
| [multicycle_setup_hold.sdc](../../../docs/examples/sdc/multicycle_setup_hold.sdc) | UG §2.6.8.4.2 |
| [generated_clock_mux.sdc](../../../docs/examples/sdc/generated_clock_mux.sdc) | UG §2.6.5.3.2 |
| [duty_cycle_6040.sdc](../../../docs/examples/sdc/duty_cycle_6040.sdc) | Cookbook duty cycle |
| [clock_offset.sdc](../../../docs/examples/sdc/clock_offset.sdc) | Cookbook offset |
| [pll_derive_clocks.sdc](../../../docs/examples/sdc/pll_derive_clocks.sdc) | Cookbook PLL |
| [external_switched_clock.sdc](../../../docs/examples/sdc/external_switched_clock.sdc) | Cookbook switched clock |
| [virtual_io_chip_to_chip.sdc](../../../docs/examples/sdc/virtual_io_chip_to_chip.sdc) | Cookbook chip-to-chip |
| [io_tsu_th_tco.sdc](../../../docs/examples/sdc/io_tsu_th_tco.sdc) | Cookbook tSU/tH/tCO |
| [multicycle_clk_to_clk.sdc](../../../docs/examples/sdc/multicycle_clk_to_clk.sdc) | Cookbook multicycle |
| [false_path_clk_to_clk.sdc](../../../docs/examples/sdc/false_path_clk_to_clk.sdc) | Cookbook false path |
| [clock_enable_multicycle.sdc](../../../docs/examples/sdc/clock_enable_multicycle.sdc) | Cookbook CE multicycle |
| [jtag_constraints_stub.sdc](../../../docs/examples/sdc/jtag_constraints_stub.sdc) | Cookbook JTAG stub |
| [dual_port_clock_io.sdc](../../../docs/examples/sdc/dual_port_clock_io.sdc) | Cookbook dual clock I/O |

## Step 5 — Redirects

| User intent | Invoke |
|-------------|--------|
| Interpret timing reports, slack, MTBF reports | `@timing-analysis` |
| RTL CDC primitive / synchronizer RTL | `@rtl-design` |
| List all features | `@help` |

## No INDEX match (fallback)

1. Read [initial_dual_clock.sdc](../../../docs/examples/sdc/initial_dual_clock.sdc) pattern + user `.sdc`.
2. Ask for clock names, periods, and I/O datasheet values if missing.
3. Cite cookbook example or UG section when recommending constraints.
