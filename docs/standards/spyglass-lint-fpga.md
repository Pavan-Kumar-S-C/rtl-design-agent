# VC SpyGlass Lint — FPGA scope (agent summary)

Source: [vc_spyglass_lint_userguide.pdf](vc_spyglass_lint_userguide.pdf) (X-2025.06-SP1). Raw extract: [_spyglass_lint_extract_raw.txt](_spyglass_lint_extract_raw.txt).

**Invoke:** `@lint` skill. **Company baseline:** [synthesizability-lint.md](synthesizability-lint.md) (RTL write rules). **Not** SpyGlass CDC → `@cdc`.

## FPGA scope

VC SpyGlass has **no `lint_fpga` goal**. For FPGA RTL sign-off use:

| Item | Value |
|------|-------|
| **Goal** | `lint_rtl` (not default `lint_rtl_enhanced` — set `lint_rtl_goal_default_enable true` for legacy default) |
| **Methodology** | `block/initial_rtl` |
| **Out of scope** | `lint_netlist`, `lint_assurance`, `lint_rtl_automotive`, `lint_emulation`, `lint_formality` — ASIC/netlist/emulation specific |

### What `lint_rtl` checks (FPGA-necessary categories)

Per UG Ch. 4 — run after every RTL change before check-in:

1. **Connectivity** — floating inputs, width mismatch, unconnected ports
2. **Simulation quality** — incomplete sensitivity lists, blocking/non-blocking misuse, races, potential sim hangs
3. **Synthesizability** — constructs that fail FPGA synthesis or cause RTL vs gate sim mismatch (`#delay`, unsynth constructs, etc.)
4. **Structure** — multiple drivers, combinational loops, improper reset usage (sync/async), high fan-in MUX

Aligns with [synthesizability-lint.md](synthesizability-lint.md): no latches, no `#delay` in synth logic, no combinational loops, no `initial` for logic.

## Recommended FPGA flow

```tcl
set_app_var enable_lint true
configure_lint_setup -goal lint_rtl
# optional: configure_lint_methodology -path $::env(VC_STATIC_HOME)/auxx/monet/tcl/GuideWare/block/initial_rtl/lint/ -goal lint_rtl
analyze -f sverilog {design.sv}
elaborate TOP
check_lint
report_violations -app {design lint} -file report_hdl.txt -report {sg_moresimple}
view_activity
```

## FPGA-relevant application variables

Set **before** design read:

| Variable | Default | FPGA relevance |
|----------|---------|----------------|
| `lint_clk_rst_node_latch` | `true` | Detect clock/reset driven from latch outputs — common FPGA CDC/timing hazard |
| `lint_clk_rst_node_on_pad` | `true` | Clock/reset on pad outputs after fan-in from sequential pins |
| `lint_rtl_goal_default_enable` | — | Set `true` to use `lint_rtl` as default instead of `lint_rtl_enhanced` |
| `tag_severity_for_unsynth_modules` | — | Control severity for unsynthesizable module constructs |

## Rule categories → FPGA fixes

| Category | Typical violations | RTL fix (see synthesizability-lint) |
|----------|-------------------|-------------------------------------|
| **Latch inference** | incomplete `if`/`case` branches | Assign all outputs in all branches; `default` in `case` |
| **Unsynthesizable** | `#delay`, unsynth `initial`, system tasks in RTL | Remove from synth modules; TB only |
| **Multiple drivers** | two drivers on same net | Single driver; use `assign` mux or tri-state only when intentional |
| **Combinational loop** | zero-delay feedback | Break loop with register; refactor logic |
| **Sensitivity list** | incomplete `@(*)` / missing signals | Full sensitivity or `always_comb` / `always @(*)` |
| **Blocking/NB mix** | blocking in clocked `always` | Use `<=` in sequential blocks |
| **Width mismatch** | port width ≠ connection | Fix parameters / explicit casts |
| **Reset structure** | async reset on data path, mixed polarity | Per [clocks-resets.md](clocks-resets.md) |

## Tag configuration

Disable noisy tags only with documented waiver:

```tcl
configure_lint_tag -disable -tag "W415a" -goal lint_rtl
```

**Do not** blanket-disable synthesizability or connectivity tags for FPGA sign-off.

## Optional: `lint_synth` (post-synth only)

`lint_synth` checks simulation vs synthesis mismatches. Use on **post-synthesis netlist** handoff, not primary FPGA RTL lint. For RTL phase, `lint_rtl` unsynthesizable category is sufficient.

## Reports

- `report_violations -app {design lint}` — primary text report
- `view_activity` — GUI schematic/backtrace
- Methodology scripts under `GuideWare/block/initial_rtl/lint/` — `lint_rtl.tcl`, optional `lint_rtl_optional_rules.tcl`

**PDF opt-in:** [vc_spyglass_lint_userguide.pdf](vc_spyglass_lint_userguide.pdf) for per-tag reference pages.
