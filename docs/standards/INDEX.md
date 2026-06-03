# Standards topic router

**Do not read every file on every task.** Match the user prompt (and open files) to topics below, then read **only** those standard files and the listed **design doc sections**.

If **no topic matches** → use **coding guidelines** (at minimum dialect + synthesizability for RTL tasks) plus **user input**; load other standard topics only when clearly implied. **Ask the user only when you have doubts** — do not invent spec or block the task solely because INDEX had no row.

## Topic → standard file

| Topic | Keywords (match any) | Standard file | Skill topic | Examples |
|-------|----------------------|---------------|-------------|----------|
| Dialect | verilog, systemverilog, sv, .v, .sv, logic, always_ff | [verilog-systemverilog-dialect.md](verilog-systemverilog-dialect.md) | [topics/dialect.md](../../.cursor/skills/rtl-design/topics/dialect.md) | [examples/dialect/](../examples/dialect/) |
| Synth / lint | synth, latch, lint, spyglass, verilator, combinational, initial, #delay | [synthesizability-lint.md](synthesizability-lint.md) | [topics/synthesizability.md](../../.cursor/skills/rtl-design/topics/synthesizability.md) | [examples/comb/](../examples/comb/) |
| Clocks / resets | clock, clk, reset, rst, async, sync, posedge | [clocks-resets.md](clocks-resets.md) | [topics/clocks-resets.md](../../.cursor/skills/rtl-design/topics/clocks-resets.md) | [examples/resets/](../examples/resets/) |
| CDC | cdc, crossing, synchronizer, 2ff, metastable, fifo, gray, vecsync, pulse cross, async fifo | [cdc-crossings.md](cdc-crossings.md) | [topics/cdc.md](../../.cursor/skills/rtl-design/topics/cdc.md) | [examples/cdc/](../examples/cdc/) |
| Metastability / MTBF | metastability, metastable, mtbf, bitsync3, 3-flop, 3-stage, synchronizer chain, settling time, toggle rate | [metastability-mtbf.md](metastability-mtbf.md) | [topics/quartus-metastability.md](../../.cursor/skills/rtl-design/topics/quartus-metastability.md) | [examples/cdc/bitsync3_inst.sv](../examples/cdc/bitsync3_inst.sv), [synchronizer_attributes.sv](../examples/cdc/synchronizer_attributes.sv) |
| Quartus / Intel STA | quartus, altera_attribute, synchronizer identification, preserve register, dont merge, report_metastability, optimize for metastability, quartus prime | [quartus-design-recommendations.md](quartus-design-recommendations.md) | [topics/quartus-metastability.md](../../.cursor/skills/rtl-design/topics/quartus-metastability.md) | [examples/cdc/synchronizer_attributes.sv](../examples/cdc/synchronizer_attributes.sv) |
| Timing Analyzer / SDC | timing analyzer, sdc, sta, create_clock, set_clock_groups, set_false_path, set_multicycle_path, set_input_delay, set_output_delay, set_max_skew, set_net_delay, report_clock_transfers, quartus_sta | [timing-analyzer-ug.md](timing-analyzer-ug.md) | [topics/timing-analyzer.md](../../.cursor/skills/rtl-design/topics/timing-analyzer.md) | [examples/sdc/](../examples/sdc/) |
| Timing Analyzer Cookbook | timing cookbook, sdc recipe, virtual clock, derive_pll_clocks, duty cycle, -waveform, -add, clock mux, pll switchover, system synchronous, tsu, th, tco, jtag, altera_reserved, get_fanouts, clock enable multicycle | [timing-analyzer-cookbook.md](timing-analyzer-cookbook.md) | [topics/timing-analyzer.md](../../.cursor/skills/rtl-design/topics/timing-analyzer.md) | [examples/sdc/](../examples/sdc/) |
| RTL macros / library | macro, km_hssi, library module, instantiate, reuse, standard cell, vecsync, bitsync, pulse cross | [rtl-macros.md](rtl-macros.md) | [topics/rtl-macros.md](../../.cursor/skills/rtl-design/topics/rtl-macros.md) | [examples/cdc/](../examples/cdc/) |
| Megafunctions / IP Catalog | megafunction, ip catalog, parameter editor, altera ip, intel ip, altera_mf, altfp, qip, inferred ram, inferred fifo, pll ip, dsp ip | [megafunctions-ip-cores.md](megafunctions-ip-cores.md) | [topics/rtl-macros.md](../../.cursor/skills/rtl-design/topics/rtl-macros.md) | — |
| FSM | fsm, state machine, state, next state, default case | [fsm-coding.md](fsm-coding.md) | [topics/fsm.md](../../.cursor/skills/rtl-design/topics/fsm.md) | [examples/fsm/](../examples/fsm/) |
| Constants / structure | localparam, parameter, define, comment, avmm, avalon, bus | [constants-structure.md](constants-structure.md) | [topics/structure.md](../../.cursor/skills/rtl-design/topics/structure.md) | — |
| CSR | csr, register, mmio, ro, wo, w1c, memory map | [csr-registers.md](csr-registers.md) | [topics/csr.md](../../.cursor/skills/rtl-design/topics/csr.md) | — |
| CT22 / security | ct22, security, debug, lock, fuse, zeroization | [ct22-security-debug.md](ct22-security-debug.md) | [topics/ct22.md](../../.cursor/skills/rtl-design/topics/ct22.md) | — |
| Review flow | review, code review, checklist, sign-off | [review-workflow.md](review-workflow.md) | — | — |

## Design source documents (authoritative for project patterns)

Section-level routing: [docs/design/INDEX.md](../design/INDEX.md)

| Document | Use when |
|----------|----------|
| [cdc-reusable-patterns.md](../design/cdc-reusable-patterns.md) | CDC primitives, handshake, FIFO, gray, latching, reset |
| [architecture-comparison.md](../design/architecture-comparison.md) | Legacy vs km_xcvr ToD architecture |
| [km-xcvr-tod-analysis.md](../design/km-xcvr-tod-analysis.md) | km_xcvr_mps_tod_counter sync behavior |
| [legacy-tod-sync-analysis.md](../design/legacy-tod-sync-analysis.md) | Legacy altera_eth_1588_tod_synchronizer CDC / Quartus attributes |
| [rtl-macro-library.md](../design/rtl-macro-library.md) | Reusable `km_hssi_*` macro catalog + selection guide |
| [macro-library-user.md](../design/macro-library-user.md) | Project-specific macro table (optional supplement) |

Read **only** the matched **Contents** / `##` section — not the whole file.

Then load [docs/examples/](../examples/) files listed in [design/INDEX.md](../design/INDEX.md).

## Megafunctions / IP cores — section router

Source: [megafunctions-ip-cores.md](megafunctions-ip-cores.md) (summary of [ug_intro_to_megafunctions-683102-848730.pdf](ug_intro_to_megafunctions-683102-848730.pdf)). Read **one** `##` section when keywords match.

| Section | Keywords |
|---------|----------|
| Agent rule: IP megafunction vs custom RTL | use ip, megafunction or custom, ip catalog or rtl |
| What the IP Catalog provides | ip catalog categories, what ip does altera provide |
| IP Catalog and Parameter Editor | parameter editor, double-click ip, ip variation |
| Best practices | ip best practice, qip, do not megafunctions directory, ram fifo older family |
| Generate and instantiate in HDL | instantiate ip hdl, insert template, altera_mf, defparam |
| Licensing and upgrade | ip license, evaluation mode, upgrade ip |
| Simulation | ip-setup-simulation, ip-make-simscript, generate simulator script |

**Verbatim PDF:** [ug_intro_to_megafunctions-683102-848730.pdf](ug_intro_to_megafunctions-683102-848730.pdf) only when user requests full UG wording.

## Quartus Design Recommendations — section router

Source: [quartus-design-recommendations.md](quartus-design-recommendations.md) (summary of [Design Recommendations.pdf](Design%20Recommendations.pdf)). Read **one** `##` section when keywords match.

| Section | Keywords |
|---------|----------|
| 2.2.6 Managing design metastability (overview) | design metastability overview, synchronizer placement |
| 3. Managing metastability with Quartus Prime | quartus metastability, mtbf analysis |
| 3.1 Metastability analysis | synchronizer chain, data synchronization register |
| 3.1.1 Data synchronization register chains | chain length, no reset in chain, settling time |
| 3.1.2 Identify synchronizers | synchronizer identification auto, identify synchronizer |
| 3.1.3 Timing constraints and synchronizer ID | set_input_delay, false path synchronizer, timing constraints mtbf |
| 3.2 Metastability and MTBF reporting | metastability report, mtbf summary, toggle rate 12.5 |
| 3.3 MTBF optimization | optimize for metastability, synchronization register chain length |
| 3.4 Reducing metastability effects | force synchronizer, forced if asynchronous, increase synchronizer stages |
| 3.5 Scripting (Tcl) | report_metastability, synchronizer_toggle_rate tcl |

**Verbatim PDF:** open [Design Recommendations.pdf](Design%20Recommendations.pdf) only when the user requests full UG wording.

## Timing Analyzer UG — section router

Source: [timing-analyzer-ug.md](timing-analyzer-ug.md) (agent summary of [Timing Analyser UG.pdf](Timing%20Analyser%20UG.pdf), UG-20140 / 683243). Read **one** `##` section when keywords match.

| Section | Keywords |
|---------|----------|
| 1.1 Timing paths and clocks | timing path, edge path, clock path, data path, unconstrained clock |
| 1.2 Setup, hold, recovery, removal | setup, hold, slack, recovery, removal, async reset timing |
| 1.2.5 Multicycle path analysis (concepts) | multicycle, setup end start, hold multicycle, phase shift |
| 1.2.6 Metastability analysis (concepts) | metastability analysis, mtbf timing analyzer |
| 1.2.7–1.2.10 Advanced analysis concepts | timing pessimism, clock-as-data, multicorner, time borrowing, hyperflex |
| 2.1 Timing Analyzer flow | run timing analyzer, timing flow, write sdc, sdc precedence |
| 2.5.1 Generating timing reports | report_timing, report_fmax, fmax summary, report_clock_transfers, report_metastability, cdc viewer, bottlenecks |
| 2.6.1 Recommended initial SDC | initial sdc, create_clock, derive_pll_clocks, derive_clock_uncertainty |
| 2.6.5 Creating clocks and clock constraints | create_generated_clock, virtual clock, clock mux, derive_pll, set_clock_groups, clock latency, clock uncertainty |
| 2.6.5.7 Constraining CDC paths | constrain cdc, cdc path, set_max_skew, set_net_delay, set_data_delay, async bus, dcfifo false path |
| 2.6.6 I/O constraints | set_input_delay, set_output_delay, virtual clock, io timing, io uncertainty |
| 2.6.7 Delay and skew constraints | set_max_delay, set_min_delay, set_max_skew, set_net_delay, set_data_delay, board trace |
| 2.6.8 Timing exceptions | set_false_path, timing exception precedence, set_multicycle_path, set_clock_groups precedence |
| 2.7 Tcl and collections | quartus_sta, report_timing tcl, get_registers, get_clocks, get_pins |

**Examples:** [initial_dual_clock.sdc](../examples/sdc/initial_dual_clock.sdc), [cdc_async_bus.sdc](../examples/sdc/cdc_async_bus.sdc), [multicycle_setup_hold.sdc](../examples/sdc/multicycle_setup_hold.sdc), [generated_clock_mux.sdc](../examples/sdc/generated_clock_mux.sdc)

**Verbatim PDF:** open [Timing Analyser UG.pdf](Timing%20Analyser%20UG.pdf) only when the user requests full UG wording.

## Timing Analyzer Cookbook — section router

Source: [timing-analyzer-cookbook.md](timing-analyzer-cookbook.md) (summary of [Timing analyser CookBook.pdf](Timing%20analyser%20CookBook.pdf), MNL-01035 / 683081). Prefer this over the UG summary for **SDC recipe** tasks. Read **one** `##` section when keywords match.

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

**Verbatim PDF:** [Timing analyser CookBook.pdf](Timing%20analyser%20CookBook.pdf) for full JTAG Tcl procs (Example 21).

## Default loads

| User intent | Always read | Also read (if keywords match) |
|-------------|-------------|-------------------------------|
| Any RTL task | This INDEX + conduct rule | Matched topic files only |
| Write / implement | [design-workflow.md](../../.cursor/skills/rtl-design/design-workflow.md) | Matched topics + matched examples |
| Review | [review-checklist.md](../../.cursor/skills/rtl-design/review-checklist.md) | `review-workflow.md` + matched topics |

## Maintainer

- Add a row when you add `docs/standards/<topic>.md`.
- Register design docs and **Content** sections in `docs/design/INDEX.md`.
- Add examples under `docs/examples/<topic>/`.
