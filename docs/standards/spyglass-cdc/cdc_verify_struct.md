# SpyGlass CDC — `cdc_verify_struct`

**Invoke:** `@cdc` · **UG:** Ch. 2 § Performing CDC Checks, Ch. 5 § Glitch Checks · **PDF:** [VC_SpyGlass_CDC_UserGuide.pdf](../VC_SpyGlass_CDC_UserGuide.pdf)

**Related:** Setup clock overlap tags → [cdc_setup.md](cdc_setup.md) · Sync schemes → [cdc_verify.md](cdc_verify.md)

## Purpose

**Structural** checks beyond basic synchronizer presence:

- **Convergence** — multiple async sources recombine before a destination
- **Glitch** — hazardous glitches on clock or control paths affecting CDC safety
- **Quasi-static** path glitch analysis

Runs after clean setup; typically after `sync` analysis on FPGA flows.

## Command

```tcl
check_cdc -type struct
```

UG notes:

- `check_cdc -type struct` runs **glitch checks**, **setup-related checks**, and **structural convergence** checks.
- `check_cdc` without `-type` runs setup + integ + sync + struct + convergence (full pass).

Optional dedicated glitch:

```tcl
check_glitch
cdc_check_glitch
get_glitch
get_glitch_paths
```

## Relationship to `check_cdc -type integ`

| Check type | Focus |
|------------|-------|
| `integ` | Clock/reset definition quality, glitches, races, hazards (optional pre-sync) |
| `struct` | Convergence + glitch on **crossing structure** after sync context established |

For FPGA: run **`setup` → `sync` → `struct`** unless tool flow requires `integ` earlier.

## Setup tag overlapping struct domain

### `SETUP_CLOCK_GLITCH` (Error)

**Description:** Asynchronous signal isolates a clock but is in a **different domain** than that clock. One violation per clock cone per async isolation source.

**Clock cone:** Net driving clock pin of sequential element, top-level port, or black-box pin.

**Prerequisites:** `create_clock` / `create_generated_clock` in SDC.

**FPGA fix:** Review clock mux / gating / async control on clock tree; ensure `set_clock_groups` and case analysis reflect real clock modes; fix RTL reconvergence of async controls into clock paths.

## Configure commands

| Command | Use |
|---------|-----|
| `configure_cdc_convergence` | Convergence detection thresholds and filtering |
| `configure_cdc_glitch` | CDC glitch rules |
| `configure_glitch` | General glitch analysis |
| `configure_glitch_free_cells` | Recognize glitch-free library cells |
| `configure_cdc_clock_glitch` | Clock-path glitch |
| `configure_cdc_integrity_glitch` | Integrity-phase glitch |
| `configure_quasi_signal` | Quasi-static signals |
| `create_static` / quasi constraints | Mark slowly changing signals |

### Quasi-static / semi-quasi

- `USER_QUASI_STATIC_*` reason codes on ignored paths (see [cdc_verify.md](cdc_verify.md))
- `SEMI_QUASI_STATIC_SRC` — quasi via `check_glitch` enables glitch checks on semi-quasi crossings
- Review `auto_case_analysis.sdc` from setup for mux/CE constants affecting convergence

## Convergence scenarios (FPGA)

| Scenario | Risk | Action |
|----------|------|--------|
| Two async sources merge before one flop | Re-converging unsync data | Separate sync per source or valid qualifier + blocking gate |
| Async source + synced qualifier converge incorrectly | `INVALID_BLOCKING_GATE`, `QUAL_CONVERGES_ASYNC_SRC` | Fix gate topology (UG blocking-gate rules) |
| Clock overlap on mux (async) | `SETUP_ASYNC_CLOCK_OVERLAP_*`, `SETUP_CLOCK_GLITCH` | Constrain mux select (`set_case_analysis`) or fix clock tree |
| Multi-flop output fans out before block | `NFF_DST_WITH_MULTI_FANOUTS` | Keep sync chain output isolated until destination |

## Glitch-free cells

Use `configure_glitch_free_cells` to recognize vendor clock-gating / glitch-free mux cells used in FPGA clock networks. Document cell list in project CDC config Tcl.

## Tcl example

```tcl
check_cdc -type setup
check_cdc -type sync
check_cdc -type struct
report_violations -app CDC -file struct.rpt

# Debug specific glitch path
get_glitch_paths
```

## FPGA sign-off checklist

- [ ] No `SETUP_CLOCK_GLITCH` errors
- [ ] No struct-phase convergence errors on async sources
- [ ] Clock mux / PLL switchover modes covered in SDC case analysis
- [ ] Quasi-static signals explicitly declared (not assumed)
- [ ] Waivers documented with `waive_cdc` + engineering review

## PDF opt-in

UG Ch. 2 (pages 57–58), Ch. 5 § Performing Glitch Checks. Extract `CDC_VERIFY_STRUCT` has 0 pages — use PDF for full tag catalog.
