# Topic: Timing Analyzer / SDC / STA

**Load when keywords:** timing analyzer, timing cookbook, sdc, sta, setup, hold, slack, multicycle, create_clock, create_generated_clock, derive_pll_clocks, virtual clock, set_clock_groups, set_false_path, set_multicycle_path, set_input_delay, set_output_delay, set_max_delay, set_min_delay, set_max_skew, set_net_delay, set_data_delay, report_timing, report_metastability, report_clock_transfers, report_fmax, fmax, quartus_sta, get_registers, get_clocks, get_fanouts, duty cycle, -waveform, -add, jtag, altera_reserved, system synchronous, tsu, th, tco, pll switchover

## Which standard file

| Task | Read |
|------|------|
| **SDC recipe** (PLL, I/O delays, mux, multicycle, JTAG, duty cycle) | [timing-analyzer-cookbook.md](../../../../docs/standards/timing-analyzer-cookbook.md) — INDEX **Cookbook** router |
| **STA concepts**, reports, CDC constraints, precedence | [timing-analyzer-ug.md](../../../../docs/standards/timing-analyzer-ug.md) — INDEX **Timing Analyzer UG** router |

Read **one** `##` section per router — not both full files unless the task spans recipe + theory.

**Also load when:** CDC RTL + SDC — [cdc-crossings.md](../../../../docs/standards/cdc-crossings.md), [cdc-reusable-patterns.md](../../../../docs/design/cdc-reusable-patterns.md).

**MTBF / synchronizer attributes:** [quartus-design-recommendations.md](../../../../docs/standards/quartus-design-recommendations.md), [metastability-mtbf.md](../../../../docs/standards/metastability-mtbf.md).

**Examples:** [docs/examples/sdc/](../../../../docs/examples/sdc/) — see [README](../../../../docs/examples/sdc/README.md)

**Verbatim PDFs:** [Timing Analyser UG.pdf](../../../../docs/standards/Timing%20Analyser%20UG.pdf) · [Timing analyser CookBook.pdf](../../../../docs/standards/Timing%20analyser%20CookBook.pdf) — user requests full wording only (especially JTAG Example 21 procs).

**Ask user if:** `.sdc` not provided, clock names/domains unclear, board delays unknown for chip-to-chip I/O, or whether task is constraint authoring vs RTL-only review.
